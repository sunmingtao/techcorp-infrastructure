#!/bin/bash
# User Provisioning Script for TechCorp Infrastructure

# Configuration
ADMIN_GROUP="svcadmin"
BACKUP_GROUP="backupadmin"
MONITORING_GROUP="monitoring"
LOG_READERS_GROUP="logreaders"

# Function to display usage
usage() {
  echo "Usage: $0 [add|remove|modify] [username] [role] [options]"
  echo ""
  echo "Roles:"
  echo "  admin       - Full system administrator"
  echo "  developer   - Developer with limited sudo"
  echo "  monitor     - Monitoring/metrics access only"
  echo "  backup      - Backup management access"
  echo "  readonly    - Read-only access to logs/metrics"
  echo ""
  echo "Examples:"
  echo "  $0 add john developer --ssh-key /path/to/key.pub"
  echo "  $0 add sarah admin --temp-days 30"
  echo "  $0 remove john"
  echo "  $0 modify sarah readonly"
}

# Function to create user with role-based permissions
create_user() {
  local username=$1
  local role=$2
  local ssh_key=$3
  local temp_days=$4

  echo "Creating user: $username with role: $role"

  # Create user
  if id "$username" &>/dev/null; then
    echo "User $username already exists!"
    return 1
  fi

  sudo useradd -m -s /bin/bash "$username"

  # Set up SSH directory
  sudo mkdir -p "/home/$username/.ssh"
  sudo chmod 700 "/home/$username/.ssh"

  # Add SSH key if provided
  if [[ -n "$ssh_key" && -f "$ssh_key" ]]; then
    sudo cp "$ssh_key" "/home/$username/.ssh/authorized_keys"
    sudo chmod 600 "/home/$username/.ssh/authorized_keys"
    sudo chown -R "$username:$username" "/home/$username/.ssh"
    echo "SSH key added for $username"
  fi

  # Set role-based groups and permissions
  case $role in
    "admin")
      sudo usermod -a -G wheel,"$ADMIN_GROUP","$BACKUP_GROUP","$MONITORING_GROUP" "$username"
      echo "Admin privileges granted to $username"
      ;;
    "developer")
      sudo usermod -a -G "$ADMIN_GROUP" "$username"
      # Create sudoers rule for developers
      echo "$username ALL=(root) /bin/systemctl restart nginx, /bin/systemctl restart apache2" | sudo tee "/etc/sudoers.d/$username"
      echo "Developer privileges granted to $username"
      ;;
    "monitor")
      sudo usermod -a -G "$MONITORING_GROUP","$LOG_READERS_GROUP" "$username"
      echo "Monitoring access granted to $username"
      ;;
    "backup")
      sudo usermod -a -G "$BACKUP_GROUP" "$username"
      echo "Backup access granted to $username"
      ;;
    "readonly")
      sudo usermod -a -G "$LOG_READERS_GROUP" "$username"
      echo "Read-only access granted to $username"
      ;;
    *)
      echo "Unknown role: $role"
      return 1
      ;;
  esac

  # Set account expiration if temporary
  if [[ -n "$temp_days" ]]; then
    local expire_date=$(date -d "+$temp_days days" +%Y-%m-%d)
    sudo chage -E "$expire_date" "$username"
    echo "Account expires on: $expire_date"
  fi

  # Log the action
  logger -t user-provisioning "Created user $username with role $role"
  echo "User $username created successfully!"
}

# Function to remove user
remove_user() {
  local username=$1

  echo "Removing user: $username"

  # Check if user exists
  if ! id "$username" &>/dev/null; then
    echo "User $username does not exist!"
    return 1
  fi

  # Backup user's home directory before removal
  if [[ -d "/home/$username" ]]; then
    sudo tar -czf "/backup/users/user-$username-$(date +%Y%m%d).tar.gz" "/home/$username"
    echo "User data backed up to /backup/users/"
  fi

  # Remove from all special groups
  sudo gpasswd -d "$username" "$ADMIN_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" "$BACKUP_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" "$MONITORING_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" "$LOG_READERS_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" sudo 2>/dev/null
  sudo gpasswd -d "$username" wheel 2>/dev/null

  # Remove custom sudoers file
  sudo rm -f "/etc/sudoers.d/$username"

  # Kill all user processes
  sudo pkill -u "$username" 2>/dev/null

  # Remove user account and home directory
  sudo userdel -r "$username"

  # Log the action
  logger -t user-provisioning "Removed user $username"
    echo "User $username removed successfully!" 
}

# Function to modify user role
modify_user() {
  local username=$1
  local new_role=$2

  echo "Modifying user: $username to role: $new_role"
  # Check if user exists
  if ! id "$username" &>/dev/null; then
    echo "User $username does not exist!"
    return 1
  fi

  # Remove from all current groups (except primary)
  sudo gpasswd -d "$username" "$ADMIN_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" "$BACKUP_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" "$MONITORING_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" "$LOG_READERS_GROUP" 2>/dev/null
  sudo gpasswd -d "$username" sudo 2>/dev/null
  sudo gpasswd -d "$username" wheel 2>/dev/null

  # Remove existing sudoers file
  sudo rm -f "/etc/sudoers.d/$username"

  # Apply new role (same logic as create_user)
  case $new_role in
    "admin")
      sudo usermod -a -G sudo,wheel,"$ADMIN_GROUP","$BACKUP_GROUP","$MONITORING_GROUP" "$username"
      echo "Admin privileges granted to $username"
      ;;
    "developer")
      sudo usermod -a -G "$ADMIN_GROUP" "$username"
      echo "$username ALL=(root) /bin/systemctl restart nginx, /bin/systemctl restart apache2" | sudo tee "/etc/sudoers.d/$username"
      echo "Developer privileges granted to $username"
      ;;
    "monitor")
      sudo usermod -a -G "$MONITORING_GROUP","$LOG_READERS_GROUP" "$username"
      echo "Monitoring access granted to $username"
      ;;
    "backup")
      sudo usermod -a -G "$BACKUP_GROUP" "$username"
      echo "Backup access granted to $username"
      ;;
    "readonly")
      sudo usermod -a -G "$LOG_READERS_GROUP" "$username"
      echo "Read-only access granted to $username"
      ;;
    *)
      echo "Unknown role: $new_role"
      return 1
      ;;
  esac

  # Log the action
  logger -t user-provisioning "Modified user $username to role $new_role"
  echo "User $username modified successfully!"
}

# Main script logic
main() {
  local action=$1
  local username=$2
  local role=$3

  # Create backup directory for user data
  sudo mkdir -p /backup/users

  case $action in
    "add")
      if [[ -z "$username" || -z "$role" ]]; then
        echo "Error: Username and role required for add action"
        usage
        exit 1
      fi
      # Parse additional options
      local ssh_key=""
      local temp_days=""

      shift 3  # Skip action, username, role
      while [[ $# -gt 0 ]]; do
        case $1 in
          --ssh-key)
            ssh_key="$2"
            shift 2
            ;;
          --temp-days)
            temp_days="$2"
            shift 2
            ;;
          *)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
         esac
       done

       create_user "$username" "$role" "$ssh_key" "$temp_days"
       ;;
     "remove")
       if [[ -z "$username" ]]; then
         echo "Error: Username required for remove action"
         usage
         exit 1
       fi
       remove_user "$username"
       ;;
     "modify")
       if [[ -z "$username" || -z "$role" ]]; then
         echo "Error: Username and new role required for modify action"
         usage
         exit 1
       fi
       modify_user "$username" "$role"
       ;;
   *)
       echo "Error: Invalid action"
       usage
       exit 1
       ;;
 esac
}

# Run main function with all arguments
main "$@"
