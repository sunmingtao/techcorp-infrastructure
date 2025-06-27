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

## Current Status
- Infrastructure: All 3 servers operational
- Frontend Server (Ubuntu 22.04): nginx + Apache running
- Backend Server (RHEL 9): PostgreSQL primary with streaming replication
- Ops Server (CentOS Stream 9): PostgreSQL standby replica receiving streaming updates
- Network: Proxy configuration working on all servers
- Database Replication: Active streaming replication from backend to ops

## Next Steps
- [ ] Configure tc-ops server for Prometheus/Grafana monitoring
- [ ] Set up centralized logging with rsyslog
- [ ] Create custom systemd services
- [ ] Configure automated backups on tc-ops
- [ ] Begin Phase 3: Security Hardening