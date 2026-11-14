#!/bin/bash 

# MAC Address Watcher - Changes MAC address every 30 minutes and on internet reconnection 

VERSION="v1.0.0"
echo "[macchanger-daemon $VERSION] Starting..."

INTERVAL=1800 # 30 minutes


change_mac() {
     echo "[+] Changing MAC addresses for all network interfaces..."
     interfaces=$(ip -o link show | awk -F': ' '{print $2}' | grep -v lo)
     

     for iface in $interfaces; do
         echo "    ↪ Interface: $iface"
         sudo ip link set "$iface" down        
         sudo macchanger -r "$iface"
         sudo ip link set "$iface" up
         
         
         # 🔽 Log the change
         mac=$(ip link show "$iface" | grep ether | awk '{print $2}') 
         echo "$(date): $iface MAC changed to: $mac" | sudo tee -a /var/log/macchanger.log > /dev/null
     
     done
}

last_change_time=0 

while true; do
     current_time=$(date +%s);     

     # Check for interval-based MAC change
     if (( current_time - last_change_time >= INTERVAL )); then
         echo "[⏰] 30-minute interval reached. Triggering MAC change."
         change_mac
         last_change_time=$current_time
     fi
     sleep INTERVAL
done 
