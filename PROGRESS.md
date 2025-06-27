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

### Troubleshooting Experience

#### Resolved Issues
- [x] **Issue #13: SELinux Security Context**
  - Encountered and resolved SELinux context issues with PostgreSQL
  - Learned proper SELinux troubleshooting techniques
- [x] **Issue #15: PostgreSQL Authentication Methods**
  - Resolved authentication configuration issues
  - Gained experience with PostgreSQL auth methods

## Current Status
- Infrastructure: All 3 servers operational
- Frontend Server (Ubuntu 22.04): nginx + Apache running
- Backend Server (RHEL 9): PostgreSQL operational with LVM storage
- Ops Server (CentOS Stream 9): Deployed and ready for configuration
- Network: Proxy configuration working

## Next Steps
- [ ] Configure tc-ops server for monitoring and backup services
- [ ] Set up PostgreSQL replication between backend (primary) and ops (standby)
- [ ] Complete remaining Phase 2 tasks (logging, monitoring, systemd services)
- [ ] Begin Phase 3: Security Hardening