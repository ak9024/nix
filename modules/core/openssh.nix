{ config, lib, pkgs, ... }:
{
  # Enable OpenSSH service
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      # Use paths without /private prefix since /etc -> /private/etc on macOS
      HostKey = [
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
    };
  };

  # Move SSH setup to preActivation to ensure it runs before services are configured
  system.activationScripts.preActivation.text = ''
    echo "===== Setting up SSH host keys ====="
    
    # Define common paths and commands
    SSH_DIR="/private/etc/ssh"
    MKDIR="/bin/mkdir"
    CHMOD="/bin/chmod"
    CHOWN="/usr/sbin/chown"
    RM="/bin/rm"
    
    # Ensure directory structure is clean
    echo "Cleaning up SSH directory structure..."
    sudo $RM -f "/etc/ssh" 2>/dev/null || true
    sudo $RM -f "/private/etc/ssh" 2>/dev/null || true
    
    # Create SSH directory with proper permissions
    echo "Creating SSH directory..."
    sudo $MKDIR -p "$SSH_DIR"
    sudo $CHMOD 755 "$SSH_DIR"
    sudo $CHOWN root:wheel "$SSH_DIR"
    # Generate ED25519 key
    if [ ! -f "$SSH_DIR/ssh_host_ed25519_key" ]; then
      echo "Generating ED25519 host key..."
      sudo ssh-keygen -t ed25519 -f "$SSH_DIR/ssh_host_ed25519_key" -N ""
      sudo $CHMOD 600 "$SSH_DIR/ssh_host_ed25519_key"
      sudo $CHMOD 644 "$SSH_DIR/ssh_host_ed25519_key.pub"
    fi
    
    # Generate RSA key
    if [ ! -f "$SSH_DIR/ssh_host_rsa_key" ]; then
      echo "Generating RSA host key..."
      sudo ssh-keygen -t rsa -b 4096 -f "$SSH_DIR/ssh_host_rsa_key" -N ""
      sudo $CHMOD 600 "$SSH_DIR/ssh_host_rsa_key"
      sudo $CHMOD 644 "$SSH_DIR/ssh_host_rsa_key.pub"
    fi
    
    # Create symlink from /etc/ssh to /private/etc/ssh
    if [ ! -e "/etc/ssh" ]; then
      echo "Creating symlink from /etc/ssh to /private/etc/ssh"
      sudo ln -sf "$SSH_DIR" "/etc/ssh"
    fi
    
    # Verify setup
    echo "===== Verifying SSH setup ====="
    ls -la "/etc/ssh"
    echo "===== SSH host key setup complete ====="
