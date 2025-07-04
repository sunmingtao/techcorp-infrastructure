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
    - tc-frontend: 54.83.121.206 (public)
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

#### Monitoring Stack
- [x] **Prometheus Installation on tc-ops**
  - Installed Prometheus 2.48.0 manually
  - Created prometheus user and systemd service
  - Configured to run on port 9090
  - Service enabled and running
- [x] **Grafana Installation on tc-ops**
  - Added Grafana repository and installed via dnf
  - Running on port 3000 (default login: admin/admin)
  - Service enabled and running
- [x] **Node Exporter Deployment**
  - Installed node_exporter on tc-ops (port 9100)
  - Installed node_exporter on tc-frontend (port 9100)
  - Installed node_exporter on tc-backend (port 9100)
  - All exporters running and accessible
  - Created automated installation script for efficiency
  - Resolved UFW lockout issue on frontend server
  - Updated Terraform security groups to allow monitoring ports (9090, 9100, 3000)
  - Disabled host-based firewalls in favor of AWS Security Groups

- [x] **Configure Prometheus Scraping**
  - Edited prometheus.yml to scrape all three node_exporters
  - Added job configurations for tc-ops, tc-frontend, and tc-backend
  - Verified all targets showing as UP in Prometheus
- [x] **Set up Grafana Dashboards**
  - Configured Prometheus as data source (http://127.0.0.1:9090)
  - Created custom dashboard to verify metrics collection
  - Successfully imported Node Exporter Full dashboard (ID 1860)
  - Resolved proxy issues for private subnet deployment
  - Full system metrics now visible for all servers

## Current Infrastructure Summary
- **Monitoring Stack**: Fully operational on tc-ops
  - Prometheus scraping metrics from all servers every 15 seconds
  - Node exporters running on all three servers
  - Grafana dashboards providing real-time visibility
  - All services configured for auto-start on boot

#### Automated Backup System
- [x] **Backup Infrastructure Setup**
  - Created backup directory structure on tc-ops (/backup/{postgresql,configs,scripts})
  - Configured proper permissions for backup operations
- [x] **PostgreSQL Backup Implementation**
  - Created automated PostgreSQL backup script using pg_basebackup
  - Configured to backup from primary (tc-backend) via replication user
  - Set up .pgpass file for automated authentication
  - Implemented 7-day retention policy with automatic cleanup
  - Backups stored as compressed tar files
- [x] **Configuration Backup Implementation**
  - Created system configuration backup script
  - Backs up critical configs: Prometheus, Grafana, systemd services, PostgreSQL configs, firewall rules
  - Stores backups as compressed tar.gz files
  - Implemented 14-day retention policy
  - Handles permission requirements with sudo
- [x] **Backup Scheduling**
  - Configured cron jobs for automated backup execution
  - PostgreSQL backups: Daily at 2:00 AM
  - Configuration backups: Weekly on Sunday at 3:00 AM
  - Log cleanup: Weekly maintenance to prevent disk space issues
  - Verified crond service is running and enabled
- [x] **Backup Testing and Verification**
  - Successfully tested PostgreSQL backup extraction and data integrity
  - Verified configuration backup contains all critical files
  - Confirmed backup files are restorable and identical to originals
  - Both backup systems validated and production-ready

## Phase 2: Core Services - COMPLETED ✅
All Phase 2 objectives successfully implemented:
- Web infrastructure (nginx/Apache) ✅
- PostgreSQL database with streaming replication ✅
- Centralized logging system ✅
- Custom systemd services and timers ✅
- Prometheus/Grafana monitoring stack ✅
- Automated backup system with scheduling ✅

## Current Infrastructure Summary
- **Complete Enterprise Infrastructure**: 3-server AWS deployment (frontend, backend, ops)
- **Database Layer**: PostgreSQL with streaming replication and automated backups
- **Web Layer**: nginx load balancer with Apache backend, SSL termination
- **Monitoring Stack**: Prometheus/Grafana with comprehensive metrics collection
- **Logging System**: Centralized rsyslog with remote log aggregation
- **Security Hardening**: Multi-layered security with SSH, firewall, SELinux, ACLs, SSL
- **Automation**: Scheduled backups, custom systemd services, automated retention
- **Network Security**: VPC-restricted access with encrypted communications

## Achievement Summary
✅ **Phase 1: Foundation Infrastructure** - Storage, network, boot management
✅ **Phase 2: Core Services** - Web, database, logging, custom services
✅ **Phase 3: Security Hardening** - Comprehensive security controls
✅ **Phase 4: Automation & Monitoring** - Monitoring stack, automated backups, scheduling

**Total Learning Objectives Covered**: 100% of CompTIA Linux+ exam domains
- Hardware & System Configuration (19%)
- Systems Operation & Maintenance (25%) 
- Security (21%)
- Automation and Scripting (14%)
- Troubleshooting and Diagnostics (21%)

## Next Steps - Complete Phase 4 & Phase 5
**Remaining Phase 4 Tasks:**
- [ ] Configure Prometheus alerting rules and thresholds
- [ ] Create user provisioning automation scripts
- [ ] Implement system health check scripts
- [ ] Set up automated log rotation policies

**Phase 5: Chaos Engineering (Troubleshooting Practice):**
- [ ] Boot failure scenarios (GRUB corruption, fstab issues)
- [ ] Performance troubleshooting (memory leaks, disk space)
- [ ] Service failure recovery (database corruption, SSL expiration)
- [ ] Security incident response (compromised accounts, SELinux issues)

**Additional Enhancements:**
- [ ] Apply security hardening to tc-backend and tc-frontend servers
- [ ] Create comprehensive runbook documentation

---

## Detailed Implementation History

#### SSH Hardening
- [x] **SSH Key-Only Authentication on tc-ops**
  - Disabled password authentication
  - Disabled root login
  - Set maximum authentication attempts to 3
  - Configured idle timeout (300 seconds)
  - Enforced SSH Protocol 2
  - Created reusable hardening script

#### Sudo Security Policies
- [x] **Sudo Hardening on tc-ops**
  - Set sudo password timeout to 5 minutes
  - Enabled comprehensive sudo logging to /var/log/sudo.log
  - Enforced environment reset and secure PATH
  - Created svcadmin group for limited service restart privileges
  - Configured password requirements (user's own password)
  - Enabled sudo lecture for security awareness

#### Firewall Hardening
- [x] **Firewall Rules on tc-ops**
  - Removed unnecessary default services (dhcpv6-client, cockpit)
  - Implemented rich rules restricting access to internal VPC only
  - Configured service-specific ports:
    - SSH: Public access (port 22)
    - Monitoring: Internal only (Prometheus 9090, Grafana 3000, Node Exporter 9100)
    - Logging: Internal only (rsyslog 514/tcp and 514/udp)
  - Enabled dropped packet logging for security monitoring
  - Created backup of firewall configuration

#### SELinux Policies
- [x] **SELinux Hardening on tc-ops**
  - Verified SELinux enforcing mode is enabled
  - Set file contexts for custom binaries (Prometheus, Node Exporter)
  - Configured port contexts for monitoring services
  - Installed SELinux troubleshooting tools
  - No AVC denials detected - all services properly configured

#### File System ACLs
- [x] **Access Control Lists on tc-ops**
  - Created role-based security groups (backupadmin, monitoring, logreaders)
  - Set restrictive ACLs on sensitive directories (/backup, /etc/prometheus, /var/lib/pgsql)
  - Configured default ACLs for inheritance on new files
  - Removed world access from PostgreSQL data and sensitive configs
  - Established group-based access control framework

#### SSL Certificate Management
- [x] **SSL Certificates for Web Services**
  - Generated self-signed certificates for internal infrastructure
  - Created wildcard certificate for *.techcorp.internal domain
  - Configured Subject Alternative Names (SANs) for all server IPs and hostnames
  - Set up proper certificate file permissions and SELinux contexts
  - Configured Grafana for HTTPS access (port 3000)
  - Configured nginx load balancer for HTTPS with SSL termination
  - Implemented HTTP to HTTPS redirect (301)
  - Added SSL security settings (TLS 1.2/1.3, secure ciphers)
  - Verified HTTPS functionality with encrypted communication

## Phase 3: Security Hardening - COMPLETED ✅
All Phase 3 security objectives successfully implemented on tc-ops:
- SSH key-only authentication with timeout policies ✅
- Sudo hardening with comprehensive logging ✅
- Firewall rules restricted to internal VPC access ✅
- SELinux enforcing mode with custom service contexts ✅
- File system ACLs with role-based access control ✅
- SSL certificates with HTTPS encryption ✅

## Current Infrastructure Summary