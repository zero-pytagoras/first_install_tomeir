# Automated System Setup Script

## Description
This script automates the setup of a Linux-based system for a development environment. It handles various tasks such as system information display, installing essential utilities, setting up SSH, configuring Vim with useful plugins, and backing up configuration files.

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



