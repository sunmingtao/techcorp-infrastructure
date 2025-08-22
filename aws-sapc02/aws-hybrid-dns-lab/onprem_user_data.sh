#!/bin/bash

# Update system
yum update -y

# Install DNS tools and dnsmasq
yum install -y bind-utils
yum install -y telnet wget
yum install -y dnsmasq

# Set hostname
hostnamectl set-hostname ${hostname}
echo "127.0.0.1 ${hostname}" >> /etc/hosts

# Wait for installation to complete
sleep 5

# Verify installation
if [ ! -f /etc/dnsmasq.conf ]; then
    echo "ERROR: dnsmasq not installed properly"
    exit 1
fi

# Backup original dnsmasq config
cp /etc/dnsmasq.conf /etc/dnsmasq.conf.backup

# Configure dnsmasq as DNS forwarder
cat << EOF > /etc/dnsmasq.conf
# Listen on all interfaces
interface=eth0

# Forward specific domain queries to Route 53 inbound resolver
server=/${domain}/${resolver_ip_1}
server=/${domain}/${resolver_ip_2}

# Forward all other queries to public DNS
server=8.8.8.8
server=8.8.4.4

# Don't read /etc/hosts for domain resolution
no-hosts

# Cache DNS queries
cache-size=1000

# Log queries for troubleshooting
log-queries
log-facility=/var/log/dnsmasq.log

# Don't poll /etc/resolv.conf for changes
no-poll

# Don't read /etc/resolv.conf
no-resolv
EOF

# Enable and start dnsmasq
sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq

# Create comprehensive test script
cat << 'TESTEOF' > /home/ec2-user/test_hybrid_dns.sh
#!/bin/bash
echo "=========================================="
echo "  AWS Hybrid DNS Lab - On-Premises Tests"
echo "=========================================="
echo "Hostname: ${hostname}"
echo "Domain: ${domain}"
echo "Resolver IPs: ${resolver_ip_1}, ${resolver_ip_2}"
echo ""

echo "=== Testing DNS Resolution via Local DNS Forwarder ==="
echo ""

echo "1. Testing api.${domain} via localhost:"
nslookup api.${domain} localhost
echo ""

echo "2. Testing db.${domain} via localhost:"
nslookup db.${domain} localhost
echo ""

echo "3. Testing web.${domain} via localhost:"
nslookup web.${domain} localhost
echo ""

echo "4. Testing public domain (amazon.com) via localhost:"
nslookup amazon.com localhost
echo ""

echo "=== Testing Direct Queries to Route 53 Inbound Resolver ==="
echo ""

echo "5. Direct query to resolver ${resolver_ip_1}:"
nslookup api.${domain} ${resolver_ip_1}
echo ""

echo "6. Direct query to resolver ${resolver_ip_2}:"
nslookup api.${domain} ${resolver_ip_2}
echo ""

echo "=== Testing Connectivity to Resolvers ==="
echo ""

echo "7. Testing TCP connectivity to resolver ${resolver_ip_1}:53"
timeout 5 bash -c "echo >/dev/tcp/${resolver_ip_1}/53" && echo "SUCCESS: TCP connection established" || echo "FAILED: Cannot connect to ${resolver_ip_1}:53"
echo ""

echo "8. Testing TCP connectivity to resolver ${resolver_ip_2}:53"
timeout 5 bash -c "echo >/dev/tcp/${resolver_ip_2}/53" && echo "SUCCESS: TCP connection established" || echo "FAILED: Cannot connect to ${resolver_ip_2}:53"
echo ""

echo "=== System Information ==="
echo ""

echo "9. Current DNS configuration:"
cat /etc/resolv.conf
echo ""

echo "10. Dnsmasq status:"
systemctl status dnsmasq --no-pager -l
echo ""

echo "11. Recent dnsmasq log entries:"
tail -10 /var/log/dnsmasq.log 2>/dev/null || echo "No dnsmasq log entries found"
echo ""

echo "12. Network interface information:"
ip addr show eth0
echo ""

echo "=========================================="
echo "Test completed!"
echo "=========================================="
TESTEOF

chmod +x /home/ec2-user/test_hybrid_dns.sh
chown ec2-user:ec2-user /home/ec2-user/test_hybrid_dns.sh

# Create simple test script for quick checks
cat << 'SIMPLEEOF' > /home/ec2-user/quick_test.sh
#!/bin/bash
echo "=== Quick DNS Test ==="
echo "Testing ${domain} resolution..."
echo ""
nslookup api.${domain} localhost
echo ""
echo "Testing public domain..."
nslookup google.com localhost
echo ""
echo "Dnsmasq status:"
systemctl is-active dnsmasq
SIMPLEEOF

chmod +x /home/ec2-user/quick_test.sh
chown ec2-user:ec2-user /home/ec2-user/quick_test.sh

# Create troubleshooting script
cat << 'TROUBLEEOF' > /home/ec2-user/troubleshoot_dns.sh
#!/bin/bash
echo "=== DNS Troubleshooting Script ==="
echo ""

echo "1. Checking dnsmasq service status:"
systemctl status dnsmasq --no-pager
echo ""

echo "2. Checking dnsmasq configuration:"
echo "--- /etc/dnsmasq.conf ---"
cat /etc/dnsmasq.conf
echo ""

echo "3. Testing resolver connectivity:"
echo "Ping test to ${resolver_ip_1}:"
ping -c 3 ${resolver_ip_1}
echo ""
echo "Ping test to ${resolver_ip_2}:"
ping -c 3 ${resolver_ip_2}
echo ""

echo "4. Checking iptables rules:"
iptables -L -n
echo ""

echo "5. Checking network routes:"
ip route
echo ""

echo "6. Recent dnsmasq logs:"
tail -20 /var/log/dnsmasq.log 2>/dev/null || echo "No dnsmasq logs found"
echo ""

echo "7. Testing UDP connectivity to resolvers:"
nc -u -v -w 3 ${resolver_ip_1} 53 < /dev/null
nc -u -v -w 3 ${resolver_ip_2} 53 < /dev/null
echo ""

echo "8. Manual dig tests:"
dig @${resolver_ip_1} api.${domain}
echo ""

echo "=== Troubleshooting Complete ==="
TROUBLEEOF

chmod +x /home/ec2-user/troubleshoot_dns.sh
chown ec2-user:ec2-user /home/ec2-user/troubleshoot_dns.sh

# Create welcome message
cat << EOF > /etc/motd

==========================================
  AWS Hybrid DNS Lab - On-Premises Simulator
==========================================
Hostname: ${hostname}
Domain: ${domain}
Resolver IPs: ${resolver_ip_1}, ${resolver_ip_2}

Available test scripts:
  ./quick_test.sh          - Quick DNS test
  ./test_hybrid_dns.sh     - Comprehensive DNS test
  ./troubleshoot_dns.sh    - Troubleshooting tools

Manual DNS tests:
  nslookup api.${domain} localhost
  nslookup api.${domain} ${resolver_ip_1}
  
Check dnsmasq status:
  systemctl status dnsmasq
  tail -f /var/log/dnsmasq.log

==========================================

EOF

# Wait for dnsmasq to be fully ready
sleep 10

# Test DNS configuration
echo "$(date): Testing DNS configuration..." >> /var/log/user-data.log
nslookup api.${domain} localhost >> /var/log/user-data.log 2>&1
if [ $? -eq 0 ]; then
    echo "$(date): DNS configuration successful" >> /var/log/user-data.log
else
    echo "$(date): DNS configuration may have issues" >> /var/log/user-data.log
fi

# Log setup completion
echo "$(date): On-premises simulator setup completed successfully" >> /var/log/user-data.log
