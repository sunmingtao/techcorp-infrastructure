# TechCorp Infrastructure Project Progress

## Overview
This document tracks the progress of implementing the TechCorp Infrastructure Project for CompTIA Linux+ certification preparation.

## Completed Tasks

### Infrastructure Setup
- [x] **Terraform Infrastructure Deployment**
  - Successfully deployed AWS infrastructure using Terraform
  - Created 2 EC2 instances: tc-frontend and tc-backend
  - Configured security groups and networking

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
- Infrastructure: Operational
- Frontend Server: nginx + Apache running
- Backend Server: PostgreSQL operational with LVM storage
- Network: Proxy configuration working

## Next Steps
- [ ] Complete remaining Phase 2 tasks (logging, monitoring, systemd services)
- [ ] Begin Phase 3: Security Hardening
- [ ] Set up tc-ops server (not yet deployed)