#!/bin/sh

# Define the script name
SCRIPT_NAME="ping_script.sh"
SERVICE_SCRIPT_NAME="autoping"

# Create the ping script
cat << 'EOF' > /usr/bin/$SCRIPT_NAME
#!/bin/sh

# Function to perform the ping
ping_url() {
    while true; do
        curl -s "http://192.168.1.1:9090/proxies/GLOBAL/delay?timeout=8000&url=http%3A%2F%2Fwww.gstatic.com%2Fgenerate_204" -H "Authorization: Bearer 499977"
        sleep 1
    done
}

# Start ping in the background
ping_url &

# Restart mihomo service every 30 minutes
while true; do
    sleep 1800  # 30 minutes
    service mihomo restart
    killall curl  # Stop all ping processes
    ping_url &   # Restart ping process
done
EOF

# Create the service script
cat << 'EOF' > /etc/init.d/$SERVICE_SCRIPT_NAME
#!/bin/sh /etc/rc.common

START=99
STOP=15

start() {
    /usr/bin/ping_script.sh &
}

stop() {
    killall ping_script.sh
}
EOF

# Set execute permissions
chmod +x /usr/bin/$SCRIPT_NAME
chmod +x /etc/init.d/$SERVICE_SCRIPT_NAME

# Enable the service to start on boot
/etc/init.d/$SERVICE_SCRIPT_NAME enable

# Start the service
/etc/init.d/$SERVICE_SCRIPT_NAME start

echo "Installation complete. The ping script and service have been set up."
