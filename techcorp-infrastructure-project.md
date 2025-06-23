# **TechCorp Infrastructure Project**
*CompTIA Linux+ Certification Preparation*

## **Project Overview**

### **Scenario:**
You're the new junior sysadmin at TechCorp, a growing software company. The infrastructure needs a complete overhaul to support 50+ employees and serve their SaaS application to customers.

### **Project Architecture:**
- **Load Balancer** (nginx) - Ubuntu 22.04
- **Web Servers** (2x) - RHEL 9/CentOS Stream
- **Database Server** - Ubuntu 22.04 (PostgreSQL)
- **Monitoring Server** - openSUSE Leap (Grafana/Prometheus)
- **Backup Server** - CentOS Stream
- **Development Server** - Ubuntu 22.04

---

## **Phase 1: Foundation Infrastructure (Week 1)**
*Covers: Hardware & System Configuration (19%)*

### **Mission:** Build the base infrastructure

**Deliverables:**
1. **Storage Setup:**
   - Configure LVM on all servers
   - Set up RAID 1 on database server
   - Create standardized partition schemes

2. **Boot Configuration:**
   - Customize GRUB2 on all systems
   - Set up different boot targets (multi-user, graphical)
   - Configure systemd boot parameters

3. **Network Foundation:**
   - Configure static IPs for all servers
   - Set up internal DNS resolution
   - Plan network security zones

**Real-world Skills:** Disk management, boot troubleshooting, systemd basics

---

## **Phase 2: Core Services (Week 2)**
*Covers: Systems Operation & Maintenance (25%)*

### **Mission:** Deploy TechCorp's core services

**Deliverables:**
1. **Web Infrastructure:**
   - Deploy nginx load balancer
   - Set up Apache/nginx web servers
   - Configure reverse proxy and SSL termination

2. **Database Services:**
   - Install and configure PostgreSQL
   - Set up replication between primary/standby
   - Configure connection pooling

3. **System Management:**
   - Implement centralized logging (rsyslog/journald)
   - Set up process monitoring
   - Configure automated package updates
   - Create custom systemd services

**Real-world Skills:** Service management, logging, package management, performance tuning

---

## **Phase 3: Security Hardening (Week 2.5)**
*Covers: Security (21%)*

### **Mission:** Secure TechCorp's infrastructure

**Deliverables:**
1. **Access Control:**
   - Implement SSH key authentication
   - Configure sudo policies and user groups
   - Set up centralized authentication (if time permits)

2. **Firewall & Network Security:**
   - Configure iptables/firewalld rules
   - Set up fail2ban for intrusion prevention
   - Implement network segmentation

3. **System Hardening:**
   - Configure SELinux policies
   - Implement file system ACLs
   - Secure file permissions across all systems
   - Set up SSL certificates for all services

**Real-world Skills:** Security policies, firewall management, access controls

---

## **Phase 4: Automation & Monitoring (Week 3)**
*Covers: Automation and Scripting (14%)*

### **Mission:** Automate TechCorp's operations

**Deliverables:**
1. **Monitoring Stack:**
   - Deploy Prometheus for metrics collection
   - Set up Grafana dashboards
   - Configure alerting rules

2. **Backup System:**
   - Implement automated backups (rsync/tar/mysqldump)
   - Create backup rotation scripts
   - Test disaster recovery procedures

3. **Automation Scripts:**
   - Write user provisioning scripts
   - Create system health check scripts
   - Implement log rotation automation
   - Set up cron jobs for maintenance tasks

**Real-world Skills:** Bash scripting, monitoring, backup strategies, job scheduling

---

## **Phase 5: Chaos Engineering (Week 3.5)**
*Covers: Linux Troubleshooting and Diagnostics (21%)*

### **Mission:** Break everything and fix it!

**Disaster Scenarios:**
1. **Boot Failures:**
   - Corrupt GRUB configuration
   - Wrong fstab entries
   - Kernel panic situations

2. **Performance Issues:**
   - Memory leaks and CPU spikes
   - Disk space problems
   - Network connectivity issues

3. **Service Failures:**
   - Database corruption
   - Web server misconfigurations
   - SSL certificate expiration

4. **Security Incidents:**
   - Compromised user accounts
   - Failed SELinux policies
   - Firewall misconfigurations

**Real-world Skills:** System diagnostics, performance analysis, incident response

---

## **Final Deliverable: TechCorp Runbook**
Create comprehensive documentation including:
- System architecture diagrams
- Standard operating procedures
- Troubleshooting guides
- Recovery procedures
- Security policies

## **Weekly Hands-on Schedule:**
- **Day 1-2:** Set up phase infrastructure
- **Day 3-4:** Implement core functionality
- **Day 5:** Testing and troubleshooting
- **Day 6:** Documentation and hardening
- **Day 7:** Disaster recovery testing

## **Linux+ Exam Coverage:**
- **Hardware & System Configuration:** 19% (Phase 1)
- **Systems Operation & Maintenance:** 25% (Phase 2)
- **Security:** 21% (Phase 3)
- **Automation and Scripting:** 14% (Phase 4)
- **Linux Troubleshooting and Diagnostics:** 21% (Phase 5)

**Total Coverage:** 100% of Linux+ objectives through realistic scenarios

---

## **Project Benefits:**
- Learn by solving actual sysadmin problems
- Build portfolio-worthy infrastructure
- Gain hands-on experience with enterprise tools
- Practice troubleshooting in realistic scenarios
- Create documentation skills valued by employers

This project covers **100% of Linux+ objectives** through realistic scenarios you'll face as a professional Linux administrator.