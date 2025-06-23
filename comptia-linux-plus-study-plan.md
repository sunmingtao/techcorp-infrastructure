# CompTIA Linux+ Study Plan (4-Week Intensive)

## Overview
- **Duration:** 4 weeks
- **Daily commitment:** 4 hours average
- **Target:** Pass CompTIA Linux+ (XK0-005) exam
- **Exam details:** 90 minutes, ~90 questions, 720/900 passing score

## Daily Structure
- **2 hours:** Theory (videos/reading)
- **1.5 hours:** Hands-on labs
- **30 minutes:** Practice questions

## Week 1: Hardware & System Configuration (19%)
**Focus:** Boot process, storage, file systems

### Topics to Master:
- GRUB2 bootloader configuration
- Disk partitioning (fdisk, parted, gdisk)
- RAID setup and management
- LVM (logical volumes, volume groups)
- File systems (ext4, XFS, Btrfs)
- systemd fundamentals
- Hardware troubleshooting

### Hands-on Labs:
- Install multiple Linux distributions
- Configure GRUB bootloader
- Create and manage RAID arrays
- Set up LVM storage
- Work with different file systems

## Week 2: Systems Operation & Maintenance (25%)
**Focus:** Day-to-day administration

### Topics to Master:
- systemd services and targets
- Process management (ps, top, htop, kill)
- Job scheduling (cron, anacron, at)
- Log management (journalctl, rsyslog)
- Package management (yum/dnf, apt, zypper)
- User/group management
- Network configuration

### Hands-on Labs:
- Create custom systemd services
- Schedule automated jobs
- Configure system logging
- Manage packages across different distros
- Set up users, groups, and permissions

## Week 3: Security & Troubleshooting (42% combined)
**Focus:** Security hardening and problem-solving

### Security Topics (21%):
- File permissions and ACLs
- SELinux/AppArmor configuration
- Firewall management (iptables, firewalld)
- SSH hardening and key management

### Troubleshooting Topics (21%):
- System monitoring and performance tuning
- Troubleshooting boot issues
- Network diagnostics
- Log analysis

### Hands-on Labs:
- Harden Linux systems
- Configure firewalls and security policies
- Practice troubleshooting broken systems
- Set up monitoring and alerting

## Week 4: Automation & Final Review (14% + review)
**Focus:** Scripting and exam preparation

### Topics to Master:
- Bash scripting fundamentals
- Advanced scripting (loops, conditionals, functions)
- Text processing (sed, awk, grep)
- System automation
- Practice exams and weak area review

### Hands-on Labs:
- Write system automation scripts
- Create maintenance and monitoring scripts
- Take full practice exams
- Review and strengthen weak areas

## Lab Environment Setup
### Required Virtual Machines:
- **CentOS/RHEL 8/9:** Enterprise focus, systemd, dnf/yum
- **Ubuntu 20.04/22.04:** Debian-based, apt package manager
- **openSUSE Leap:** Different package manager (zypper)
- **Practice VM:** For breaking and fixing systems

### Lab Infrastructure:
- Minimum 16GB RAM recommended
- VirtualBox or VMware
- Network configuration for inter-VM communication
- Shared storage for practicing NFS/Samba

## Study Resources
### Primary Materials:
- Official CompTIA Linux+ Study Guide (XK0-005)
- Linux Academy/A Cloud Guru video courses
- Red Hat Enterprise Linux documentation
- Ubuntu Server documentation

### Practice Materials:
- MeasureUp practice exams
- Kaplan IT Training practice tests
- Professor Messer Linux+ videos (free)
- Linux Foundation training materials

### Hands-on Resources:
- VirtualBox/VMware for lab setup
- Real hardware for physical troubleshooting
- Cloud instances (AWS EC2, Google Cloud) for practice

## Weekly Milestones
- **Week 1 End:** Comfortable with boot process, storage, file systems
- **Week 2 End:** Proficient in system administration tasks
- **Week 3 End:** Confident in security and troubleshooting
- **Week 4 End:** Ready for exam, scoring 80%+ on practice tests

## Daily Schedule Example
### Morning (2 hours - Theory):
- Watch instructional videos
- Read study materials
- Take notes on key concepts

### Afternoon (1.5 hours - Labs):
- Follow lab exercises
- Practice commands and configurations
- Break and fix systems

### Evening (30 minutes - Practice):
- Answer practice questions
- Review incorrect answers
- Identify knowledge gaps

## Tips for Success
1. **Consistency:** Study every day, even if just 2-3 hours
2. **Hands-on:** Linux is learned by doing, not just reading
3. **Document:** Keep notes on commands and configurations
4. **Practice exams:** Take them frequently to gauge progress
5. **Community:** Join Linux forums and study groups
6. **Real scenarios:** Practice with actual production-like setups

## Final Week Preparation
- Take multiple full-length practice exams
- Review all flagged topics and weak areas
- Practice performance-based questions
- Get comfortable with exam interface
- Schedule exam for end of week 4

## Exam Day Strategy
- Review key commands and concepts morning of exam
- Arrive early and relaxed
- Read questions carefully
- Manage time effectively (90 minutes for ~90 questions)
- Flag difficult questions and return to them

Remember: This is an intensive plan requiring dedication and consistent effort. Adjust the schedule based on your background and learning pace.