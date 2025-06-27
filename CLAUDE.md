# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **TechCorp Infrastructure Project** - a hands-on learning environment designed for CompTIA Linux+ certification preparation. The project simulates building and managing a complete enterprise infrastructure through 5 progressive phases.

## Architecture

**3-Server Consolidated Architecture:**
- **tc-frontend** (Ubuntu 22.04): nginx load balancer + Apache web server + Squid proxy
- **tc-backend** (RHEL 9): PostgreSQL primary database + application services  
- **tc-ops** (CentOS Stream 9): PostgreSQL standby replica + Prometheus/Grafana monitoring + backup services + dev tools

This multi-distro setup provides experience with different package managers (apt, dnf, zypper) and system administration approaches.

## Infrastructure Management Commands

### Terraform Infrastructure
```bash
# Initialize and deploy infrastructure
cd terraform/
terraform init
terraform plan
terraform apply

# Destroy infrastructure when done
terraform destroy
```

### Server Access
Terraform outputs SSH commands for each server:
- Frontend: `ssh -i ~/.ssh/techcorp-key.pem ubuntu@54.242.140.75`
- Backend: `ssh -i ~/.ssh/techcorp-key.pem ec2-user@10.2.2.252` (via frontend)
- Ops: `ssh -i ~/.ssh/techcorp-key.pem ec2-user@10.2.2.97` (via frontend)

**Current Infrastructure Status:**
- All 3 servers deployed and operational
- Frontend: 54.242.140.75 (public) - Proxy configured for private subnet internet access
- Backend: 10.2.2.252 (private) - PostgreSQL primary with streaming replication
- Ops: 10.2.2.97 (private) - PostgreSQL standby replica
- Database Replication: Active streaming replication between backend (primary) and ops (standby)

## Project Phases Structure

**Phase 1: Foundation Infrastructure** (Hardware & System Configuration - 19%)
- LVM and RAID storage configuration
- GRUB2 and systemd boot management
- Network foundation and static IP setup

**Phase 2: Core Services** (Systems Operation & Maintenance - 25%)
- Web infrastructure deployment (nginx/Apache)
- PostgreSQL database setup with replication
- Centralized logging and process monitoring
- Custom systemd services

**Phase 3: Security Hardening** (Security - 21%)
- SSH key authentication and sudo policies
- Firewall configuration (iptables/firewalld)
- SELinux policies and file system ACLs
- SSL certificate management

**Phase 4: Automation & Monitoring** (Automation and Scripting - 14%)
- Prometheus/Grafana monitoring stack
- Automated backup systems with rotation
- Bash scripts for system administration
- Cron job automation

**Phase 5: Chaos Engineering** (Troubleshooting and Diagnostics - 21%)
- Deliberate system breaking and repair
- Boot failure scenarios
- Performance issue simulation
- Security incident response

## Learning Approach

This project uses **project-based learning** rather than traditional study methods. Each phase builds upon the previous one, creating a realistic enterprise environment that covers 100% of Linux+ exam objectives through practical implementation.

## Key Infrastructure Components

- **Multi-distro environment**: Experience with Ubuntu (apt), RHEL (dnf), and CentOS Stream
- **Storage management**: LVM, RAID, and filesystem configuration
- **Service management**: systemd services, process monitoring, and automation
- **Security implementation**: Comprehensive hardening across all layers
- **Monitoring and observability**: Full-stack monitoring with alerting
- **Disaster recovery**: Backup strategies and incident response procedures

## Development Workflow

1. **Infrastructure as Code**: All AWS resources managed through Terraform
2. **Progressive complexity**: Each phase adds new skills while reinforcing previous ones
3. **Real-world scenarios**: Problems mirror actual production environments
4. **Documentation-driven**: Each phase produces runbooks and procedures
5. **Break-and-fix methodology**: Deliberate failure injection for troubleshooting practice

This project prepares for both the CompTIA Linux+ certification and real-world Linux system administration roles.