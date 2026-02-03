# deps:
if [ ! -f /etc/pam.d/sudo_local ]; then
    echo "Setting up TouchID for sudo..."
    sudo sh -c 'echo "auth sufficient pam_tid.so" > /etc/pam.d/sudo_local'
fi
