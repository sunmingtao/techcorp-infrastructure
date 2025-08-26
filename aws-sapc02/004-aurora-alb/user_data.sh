#!/bin/bash
# User Data Script for Web Application Servers
# This script sets up a simple web application that demonstrates sticky sessions

# Update system packages
yum update -y

# Install Apache and PHP
yum install -y httpd php

# Install newer PostgreSQL client that supports SCRAM authentication
# Try Amazon Linux Extras first
amazon-linux-extras install -y postgresql14 php7.4 || {
    # Fallback: Install from PostgreSQL official repo
    yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
    yum install -y postgresql15-server postgresql15
}

# Install PHP PostgreSQL extension
yum install -y php-pgsql

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Create a simple PHP application that shows server info and database connection
cat > /var/www/html/index.php << 'EOF'
<?php
session_start();

// Database configuration
$db_host = "${db_endpoint}";
$db_name = "${db_name}";
$db_user = "${db_username}";
$db_pass = "${db_password}";

// Get instance metadata
$instance_id = file_get_contents("http://169.254.169.254/latest/meta-data/instance-id");
$az = file_get_contents("http://169.254.169.254/latest/meta-data/placement/availability-zone");

// Session management for sticky session testing
if (!isset($_SESSION['visit_count'])) {
    $_SESSION['visit_count'] = 1;
    $_SESSION['first_server'] = $instance_id;
} else {
    $_SESSION['visit_count']++;
}

// Try to connect to database
$db_status = "Not Connected";
$db_info = "";
try {
    $pdo = new PDO("pgsql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $db_status = "Connected Successfully";
    
    // Get database server info
    $stmt = $pdo->query("SELECT version() as version, now() as current_time");
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $db_info = $row;
} catch (PDOException $e) {
    $db_status = "Connection failed: " . $e->getMessage();
}

?>
<!DOCTYPE html>
<html>
<head>
    <title>AWS Two-Tier Application Lab</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .header { background: #232f3e; color: white; padding: 20px; margin: -30px -30px 20px -30px; border-radius: 8px 8px 0 0; }
        .section { margin: 20px 0; padding: 15px; border-left: 4px solid #ff9900; background: #fff3cd; }
        .status-good { color: #28a745; font-weight: bold; }
        .status-bad { color: #dc3545; font-weight: bold; }
        .highlight { background: #e7f3ff; padding: 10px; border-radius: 4px; margin: 10px 0; }
        .refresh-btn { background: #ff9900; color: white; padding: 10px 20px; border: none; border-radius: 4px; cursor: pointer; margin: 10px 5px; }
        .refresh-btn:hover { background: #e68900; }
    </style>
    <script>
        function refreshPage() {
            location.reload();
        }
        
        function clearSession() {
            fetch('clear_session.php')
                .then(() => location.reload());
        }
    </script>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🚀 AWS Two-Tier Application Lab</h1>
            <p>Testing Aurora Auto Scaling + ALB with Sticky Sessions</p>
        </div>
        
        <div class="section">
            <h2>📊 Server Information</h2>
            <div class="highlight">
                <strong>Current Server:</strong> <?php echo htmlspecialchars($instance_id); ?><br>
                <strong>Availability Zone:</strong> <?php echo htmlspecialchars($az); ?><br>
                <strong>Session ID:</strong> <?php echo session_id(); ?><br>
                <strong>Visit Count:</strong> <?php echo $_SESSION['visit_count']; ?><br>
                <strong>First Server Visited:</strong> <?php echo htmlspecialchars($_SESSION['first_server']); ?>
            </div>
        </div>
        
        <div class="section">
            <h2>🗄️ Database Connection Status</h2>
            <div class="highlight">
                <strong>Status:</strong> 
                <span class="<?php echo ($db_status == 'Connected Successfully') ? 'status-good' : 'status-bad'; ?>">
                    <?php echo htmlspecialchars($db_status); ?>
                </span>
            </div>
            
            <?php if (is_array($db_info)): ?>
            <div class="highlight">
                <strong>Database Time:</strong> <?php echo htmlspecialchars($db_info['current_time']); ?><br>
                <strong>PostgreSQL Version:</strong> <?php echo htmlspecialchars(substr($db_info['version'], 0, 50)) . '...'; ?>
            </div>
            <?php endif; ?>
        </div>
        
        <div class="section">
            <h2>🔄 Sticky Session Test</h2>
            <div class="highlight">
                <?php if ($_SESSION['visit_count'] > 1 && $_SESSION['first_server'] == $instance_id): ?>
                    <span class="status-good">✅ Sticky Sessions Working!</span><br>
                    You've been consistently routed to the same server (<?php echo htmlspecialchars($instance_id); ?>) across <?php echo $_SESSION['visit_count']; ?> visits.
                <?php elseif ($_SESSION['visit_count'] > 1): ?>
                    <span class="status-bad">⚠️ Sticky Sessions May Not Be Working</span><br>
                    Your first visit was to server <?php echo htmlspecialchars($_SESSION['first_server']); ?>, but now you're on <?php echo htmlspecialchars($instance_id); ?>.
                <?php else: ?>
                    <span>📍 First visit to this server. Refresh to test sticky sessions.</span>
                <?php endif; ?>
            </div>
        </div>
        
        <div class="section">
            <h2>🧪 Test Actions</h2>
            <button class="refresh-btn" onclick="refreshPage()">🔄 Refresh Page</button>
            <button class="refresh-btn" onclick="clearSession()">🗑️ Clear Session</button>
        </div>
        
        <div class="section">
            <h2>📋 Lab Architecture</h2>
            <div class="highlight">
                <strong>✅ Application Load Balancer:</strong> Layer 7 load balancing with sticky sessions<br>
                <strong>✅ Auto Scaling Group:</strong> EC2 instances scale based on CPU utilization<br>
                <strong>✅ Aurora PostgreSQL:</strong> Writer + Read Replicas with auto scaling<br>
                <strong>✅ Multi-AZ Deployment:</strong> High availability across availability zones
            </div>
        </div>
        
        <p><small>Last updated: <?php echo date('Y-m-d H:i:s T'); ?></small></p>
    </div>
</body>
</html>
EOF

# Create health check endpoint
cat > /var/www/html/health << 'EOF'
OK
EOF

# Create session clear endpoint
cat > /var/www/html/clear_session.php << 'EOF'
<?php
session_start();
session_destroy();
echo "Session cleared";
?>
EOF

# Set proper permissions
chown -R apache:apache /var/www/html/
chmod -R 755 /var/www/html/

# Configure PHP session settings for better sticky session testing
cat >> /etc/php.ini << 'EOF'

; Custom session configuration for lab
session.cookie_lifetime = 86400
session.gc_maxlifetime = 86400
EOF

# Restart Apache to apply changes
systemctl restart httpd

# Create a simple log for debugging
echo "$(date): Web server setup completed on instance $(curl -s http://169.254.169.254/latest/meta-data/instance-id)" >> /var/log/webapp-setup.log
