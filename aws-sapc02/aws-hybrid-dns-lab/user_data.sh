#!/bin/bash

# Update system
yum update -y

# Install useful tools
yum install -y bind-utils telnet wget curl

# Set hostname
hostnamectl set-hostname ${hostname}
echo "127.0.0.1 ${hostname}" >> /etc/hosts

# Create DNS test script
cat << 'EOF' > /home/ec2-user/test_dns.sh
#!/bin/bash
echo "=== DNS Resolution Test ==="
echo "Testing resolution of ${domain} records..."
echo ""

echo "1. Testing api.${domain}:"
nslookup api.${domain}
echo ""

echo "2. Testing db.${domain}:"
nslookup db.${domain}
echo ""

echo "3. Testing web.${domain}:"
nslookup web.${domain}
echo ""

echo "4. Testing public domain (google.com):"
nslookup google.com
echo ""

echo "5. Current DNS configuration:"
cat /etc/resolv.conf
echo ""

echo "6. Current hostname and IP:"
echo "Hostname: $(hostname)"
echo "Private IP: $(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)"
echo ""
EOF

chmod +x /home/ec2-user/test_dns.sh
chown ec2-user:ec2-user /home/ec2-user/test_dns.sh

# Create welcome message
cat << EOF > /etc/motd

========================================
  AWS Hybrid DNS Lab - Test Instance
========================================
Hostname: ${hostname}
Domain: ${domain}

Test DNS resolution with:
  ./test_dns.sh

Manual DNS tests:
  nslookup api.${domain}
  nslookup db.${domain}
  nslookup web.${domain}

========================================

EOF

# Log setup completion
echo "$(date): User data script completed successfully" >> /var/log/user-data.log
