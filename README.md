# System Setup Script

## Description
This script automates the setup of a Linux-based system for a development environment. 
It handles various tasks such as system information display, installing essential utilities, setting up SSH, configuring Vim with useful plugins, 
and backing up configuration files as requested in the task.

## Features
- **System Information**: Displays user and machine info, disk space, memory usage, and uptime.
- **Utility Installation**: Installs common utilities like `vim`, `curl`, `git`, and `htop`.
- **Vim Plugin Manager**: Installs and configures `vim-plug` to manage Vim plugins.
- **SSH Setup**: Installs and configures OpenSSH for remote access.
- **Backup**: Backs up key configuration files and directories.

## Requirements
- Linux-based OS (Utility install is based on apt)
- A non-root user
- `sudo` privileges

## Usage

### **1. Download the Script**
Clone the repository or download the script file to your system.
```bash
git clone https://github.com/tomeir2105/first_install.git
cd first_install
```
### **2. Make the Script Executable**
```bash
chmod +x install_script.sh
``` 
### **2. Run the Script**
Make sure to run the script as non-root user
```bash
./install_script.sh
```
The script will prompt you for your password to run commands with sudo privileges.
# Script Breakdown
## System Information
The script will display the following information about your system:
- **User and Host Information:** Displays the current user and the machine's hostname.
- **Kernel Version:** Shows the current kernel version.
- **Disk Space:** Displays the disk space usage of the root device.
- **Memory Usage:** Shows used and free memory.
- **System Uptime:** Displays how long the system has been running.

## Utility Installation

### The following utilities will be installed:

vim – Text editor for development
curl – Command-line tool for transferring data
git – Version control system
htop – Interactive process viewer

## Vim Plugin Manager
### The script installs vim-plug, a plugin manager for Vim, and configures it with the following plugins:
godlygeek/tabular – A plugin for alignment in Vim.
tomasr/molokai – A dark Vim color scheme.
LunarWatcher/auto-pairs – Automatically inserts matching pairs of parentheses, brackets, etc.

## SSH Setup
### The script installs and configures the OpenSSH server, ensuring the following:
- Installs OpenSSH if not already installed.
- Starts and enables the SSH service.
- Configures the firewall to allow SSH connections.

## Backup
The script creates a backup of the following directories and files:
- /etc – System configuration files.
- ~/.config – User configuration files.
- ~/.local – User local data.
- ~/.bashrc and ~/.profile – Shell configuration files.
- ~/.vim and ~/.vimrc – Vim configuration files.
The backup is saved as backup.tar.gz in the backup directory in your home folder.

### Security Considerations
The script temporarily stores the user password in a base64-encoded file (.secret) for use with sudo. 

### Troubleshooting
Permission Denied: Execute the script from the user home directory.
Install fail: Make sure the internet is connected, handle the errors.



