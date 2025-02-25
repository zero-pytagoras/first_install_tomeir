#!/usr/bin/env bash
######################################
# Created by : Meir Amiel
# Purpose : Primary install script
# Date : 14/2/25
# Version : 1
#set -x
set -o errexit
set -o pipefail
set -o nounset
#####################################

TEMP_ETC=$(mktemp -d)
TEMP_USER=$(mktemp -d)
TEMP_VIM=$(mktemp -d)
USER=$(whoami)
HOME_FOLDER="/home/$USER"
BACKUP_DIR="$HOME_FOLDER/backup"
BACKUP_FILE="$BACKUP_DIR/backup.tar.gz"
PASSWORD_FILE="$HOME_FOLDER/.secret"
VIM_PLUGIN_CONFIG="$HOME_FOLDER/.vim/autoload/plug.vim"
VIMRC="$HOME_FOLDER/.vimrc"

VIM_PLUGINS=(
  'godlygeek/tabular'
  'tomasr/molokai'
  'LunarWatcher/auto-pairs'
)

UTILITIES=(
    'vim' 
    'curl'
    'git'
    'htop'
)


# VERIFY NOT ROOT USER
if [ "$(id -u)" -eq 0 ]; then
    echo "Run script with non-root user."
    exit 1
fi

# SCRIPT PRIVILEGE ESCALATION
get_user_password() {
    read -sp "Enter user password: " value ; echo
    if ! echo "$value" | sudo -S -k true 2>/dev/null; then 
        echo "Wrong password"
        exit 1
    fi
    echo $value | base64 > $PASSWORD_FILE
}

monitor_script() {
    main_script &
    MAIN_PID=$! # GET MAIN PROCESS ID
    while kill -0 $MAIN_PID 2>/dev/null; do # MONITOR MAIN PROCESS
        sleep 1
    done
    # CLEAN AFTER MAIN FINISHES OR CRUSHES
    cat $PASSWORD_FILE | base64 -d | sudo -S rm -f $PASSWORD_FILE
    echo "Script finished."
}

main_script() {
    print_user_machine_info
    print_disk_space
    print_memory_usage
    print_uptime
    do_apt_update
    install_utilities
    download_vim_plugin_manager
    install_vim_plugins
    setup_ssh
    do_backup
}

print_user_machine_info(){
    can_be_root=$( [[ $EUID == 0 ]] && echo "- can be root" || echo "- can not be root")
    echo "Current user: $USER $can_be_root"
    echo "Machine hostname: $(hostname)"
    echo "Kernel version: $(uname -r)"
}
print_disk_space(){
    root_device=$(mount | grep 'on / ' |  awk '{print $1}')
    df -h | grep "$root_device" | awk '{
	    print "Main disk:\t"$1;
	    print "Used space:\t"$3" /"$2;
	    print "Free space:\t"$4" ("$5")";
    }'
}
print_memory_usage(){
    used_memory=$(free -h| grep Mem | awk '{print $3}')
    free_memory=$(free -h| grep Mem | awk '{print $2}')
    echo "Used memory: $used_memory"
    echo "Free memory: $free_memory"
}
print_uptime(){
    uptime=$(uptime -p)
    echo "System is up for $uptime"
}

do_apt_update(){
    # Run apt update
    cat $PASSWORD_FILE | base64 -d | sudo -S apt update > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "apt update completed successfully."
    else
        echo "apt update failed."
        exit 1
    fi
}

setup_ssh() {
    # INSTALL SSH SERVICE
    cat $PASSWORD_FILE | base64 -d | sudo -S apt install -y openssh-server  > /dev/null 2>&1
    # START SSH SERVICE
    cat $PASSWORD_FILE | base64 -d | sudo -S systemctl start ssh  > /dev/null 2>&1
    cat $PASSWORD_FILE | base64 -d | sudo -S systemctl enable ssh  > /dev/null 2>&1
    # OPEN SSH IN FW
    cat $PASSWORD_FILE | base64 -d | sudo -S ufw allow ssh || true > /dev/null 2>&1
    cat $PASSWORD_FILE | base64 -d | sudo -S ufw enable || true > /dev/null 2>&1
    cat $PASSWORD_FILE | base64 -d | sudo -S ufw reload || true > /dev/null 2>&1
    # VERIFY SSH SERVICE IS UP
    if sudo systemctl is-active --quiet ssh; then
        echo "SSH service is running."
    else
        echo "SSH service failed to start."
        exit 1
    fi
}

install_utilities(){
    for UTIL in "${UTILITIES[@]}"; do
        cat $PASSWORD_FILE | base64 -d | sudo -S apt-get install -y $UTIL > /dev/null 2>&1
        if dpkg -s $UTIL &>/dev/null; then
            echo "$UTIL installed successfully."
        else
            echo "$UTIL installation failed."
            exit 1
        fi
    done
}

download_vim_plugin_manager(){
    curl -fLo $VIM_PLUGIN_CONFIG --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim > /dev/null 2>&1
    # Verify download OK
    [[ -s $VIM_PLUGIN_CONFIG ]] && echo "vim plugins downloaded successfully." || echo "vim plugins plugin failed"
}

install_vim_plugins(){
    # update plugins in vim config
    touch "$VIMRC"
    # ADD CONFIG HEADER
    if ! grep -q "call plug\#begin" "$VIMRC"; then
      echo "Adding plugin manager configuration to $VIMRC..."
      echo "call plug#begin('~/.vim/plugged')" >> "$VIMRC"
      echo "" >> "$VIMRC"
      echo "call plug#end()" >> "$VIMRC"
    fi

    # ADD PLUGINS TO FILE
    for PLUGIN in "${VIM_PLUGINS[@]}"; do
      if ! grep -q "Plug '$PLUGIN'" "$VIMRC"; then
        echo "Adding plugin '$PLUGIN' to $VIMRC..."
        # Insert the plugin line before 'call plug#end()'
        sed -i "/call plug#end()/i Plug '$PLUGIN'" "$VIMRC"
      else
        echo "Plugin '$PLUGIN' is already in $VIMRC."
      fi
    done
    # update plugins in vim
    cat $PASSWORD_FILE | base64 -d | sudo -S vim +PlugInstall +qall
}

do_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
	    mkdir -p "$BACKUP_DIR"
    fi
    if [ -f "$BACKUP_FILE" ]; then
        creation_date_filename="$(stat --format='%W' "$BACKUP_FILE")_backup.tar.gz"
        cat $PASSWORD_FILE | base64 -d | sudo mv $BACKUP_FILE "$BACKUP_DIR/$creation_date_filename"
    fi
    cat $PASSWORD_FILE | base64 -d | sudo -S cp -r /etc $TEMP_ETC || true > /dev/null 2>&1
    cp -r $HOME_FOLDER/.config $TEMP_USER || true > /dev/null 2>&1
    cp -r $HOME_FOLDER/.local $TEMP_USER || true > /dev/null 2>&1
    cp $HOME_FOLDER/.bashrc $TEMP_USER || true > /dev/null 2>&1
    cp $HOME_FOLDER/.profile $TEMP_USER || true > /dev/null 2>&1
    cp -r $HOME_FOLDER/.vim $TEMP_VIM || true > /dev/null 2>&1  
    cp $HOME_FOLDER/.vimrc $TEMP_VIM || true > /dev/null 2>&1  
    cat $PASSWORD_FILE | base64 -d | sudo -S tar -czf $BACKUP_FILE $TEMP_VIM $TEMP_USER $TEMP_ETC > /dev/null 2>&1
    if [ -f "$BACKUP_FILE" ]; then
        echo "Backup finished successfully - $BACKUP_FILE"
    else
		echo "Backup failed."
	fi
	
}


get_user_password
monitor_script # START MONITOR AND MAIN SCRIPT


