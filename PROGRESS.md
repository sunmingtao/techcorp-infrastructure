# TechCorp Infrastructure Project Progress

## Overview
This document tracks the progress of implementing the TechCorp Infrastructure Project for CompTIA Linux+ certification preparation.

## Completed Tasks

### Infrastructure Setup
- [x] **Terraform Infrastructure Deployment**
  - Successfully deployed AWS infrastructure using Terraform
  - Created 3 EC2 instances: tc-frontend, tc-backend, and tc-ops
  - Configured security groups and networking
  - Server IPs:
    - tc-frontend: 54.242.140.75 (public)
    - tc-backend: 10.2.2.252 (private)
    - tc-ops: 10.2.2.97 (private)

### Phase 1: Foundation Infrastructure

#### Storage Configuration
- [x] **LVM Configuration on Backend Server**
  - Created volume group `datavg` on 20GB disk (nvme1n1)
  - Created logical volumes:
    - `dblv` (5G) - Mounted at `/var/lib/postgresql`
    - `applv` (5G) - Mounted at `/opt/apps`
    - `backuplv` (8G) - Mounted at `/backup`

#### Network Configuration
- [x] **Squid Proxy Setup on Frontend**
  - Configured Squid proxy to allow backend internet access
  - Cost-effective alternative to AWS NAT Gateway
  - Extended proxy configuration to tc-ops server
- [x] **Static IP Configuration on Backend**
  - Configured static IP (maintained AWS-assigned address)

#### Boot Management
- [x] **GRUB2 Configuration**
  - Modified GRUB_TIMEOUT from default to 5 seconds
  - Learned GRUB2 configuration management

### Phase 2: Core Services

#### Web Infrastructure
- [x] **Nginx Setup on Frontend**
  - Installed and configured nginx as load balancer
- [x] **Apache2 Setup on Frontend**
  - Installed Apache web server
  - Configured to work behind nginx proxy

#### Database Services
- [x] **PostgreSQL Installation on Backend**
  - Successfully installed and configured PostgreSQL
  - Database mounted on LVM volume at `/var/lib/postgresql`
  - Created application user and replication user
  - Configured postgresql.conf for replication (wal_level, max_wal_senders, listen_addresses)
- [x] **PostgreSQL Streaming Replication**
  - Configured primary (tc-backend) for replication
  - Set up standby replica on tc-ops using pg_basebackup
  - Verified streaming replication is working (walreceiver process active)
  - Tested data replication from primary to standby

#### Logging Services
- [x] **Central Log Server Setup on tc-ops**
  - Configured rsyslog to receive logs on TCP/UDP port 514
  - Created remote log directory structure (/var/log/remote)
  - Installed and configured firewalld for log traffic
  - Verified rsyslog is listening on both protocols
  - Ready to receive logs from client servers
- [x] **Log Forwarding Configuration**
  - Configured tc-frontend to forward logs to tc-ops via TCP (@@)
  - Configured tc-backend to forward logs to tc-ops via TCP
  - Tested logging from both servers with logger command
  - Verified logs are organized by hostname in /var/log/remote/
  - Full centralized logging now operational

### Troubleshooting Experience

#### Resolved Issues
- [x] **Issue #13: SELinux Security Context**
  - Encountered and resolved SELinux context issues with PostgreSQL
  - Learned proper SELinux troubleshooting techniques
- [x] **Issue #15: PostgreSQL Authentication Methods**
  - Resolved authentication configuration issues
  - Gained experience with PostgreSQL auth methods

#### Resolved Issues  
- [x] **PostgreSQL pg_hba.conf Authentication**
  - Learned about pg_hba.conf authentication methods
  - Added trust authentication for local postgres user admin tasks
- [x] **Shell Quoting in sed Commands**
  - Discovered issue with special characters in double-quoted sed expressions
  - Learned proper escaping techniques for complex sed patterns
  - Learned difference between single and double quotes with shell expansion
- [x] **Package Discovery Methods**
  - Learned to use `dnf provides` to find which package provides a command
  - Used `dnf provides firewall-cmd` to discover firewalld package
  - Important skill for finding packages without external resources
- [x] **SELinux Context Inheritance**
  - Discovered that new directories inherit parent's SELinux context
  - Learned when explicit semanage rules are needed (persistence, system relabeling)
  - Understood var_log_t context for log directories

## Current Status
- Infrastructure: All 3 servers operational
- Frontend Server (Ubuntu 22.04): nginx + Apache running
- Backend Server (RHEL 9): PostgreSQL primary with streaming replication
- Ops Server (CentOS Stream 9): 
  - PostgreSQL standby replica receiving streaming updates
  - Central rsyslog server configured and listening on port 514
  - Firewalld configured to allow log traffic
- Network: Proxy configuration working on all servers
- Database Replication: Active streaming replication from backend to ops
- Logging: Centralized logging fully operational (all servers → tc-ops)

#### Custom Services
- [x] **Custom systemd service (disk-monitor)**
  - Created disk monitoring script with threshold alerts
  - Configured systemd service and timer for periodic execution
  - Service runs every 5 minutes to check disk usage
  - Logs sent to central log server via rsyslog

## Next Steps
- [ ] Configure tc-ops server for Prometheus/Grafana monitoring
- [ ] Configure automated backups on tc-ops
- [ ] Begin Phase 3: Security Hardening