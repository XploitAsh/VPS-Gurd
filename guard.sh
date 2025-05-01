#!/bin/bash

# Reset persistent configurations
echo "[+] Resetting existing iptables-persistent rules..."
rm -f /etc/iptables/rules.v4
rm -f /etc/iptables/rules.v6

# Install/Reinstall persistence package
echo "[+] Reinstalling iptables-persistent..."
apt update && apt install iptables-persistent -y
touch /etc/iptables/rules.v4
touch /etc/iptables/rules.v6

# Flush active rules
echo "[+] Flushing current rules "
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
ip6tables -F
ip6tables -X

# Set default policies (preserve DO defaults)
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT

# Apply new rules
echo "[+] Applying new rules "

# Block specified ports
block_ports=(25 3389 3306 161 162)
for port in "${block_ports[@]}"; do
    iptables -A OUTPUT -p tcp --dport $port -j DROP
    iptables -A OUTPUT -p udp --dport $port -j DROP
done

# Rate limiting
iptables -A OUTPUT -p tcp --dport 22 -m limit --limit 1/sec --limit-burst 1 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -m limit --limit 166/sec --limit-burst 1 -j ACCEPT

# Save configuration
echo "[+] Saving new persistent rules"
iptables-save > /etc/iptables/rules.v4
ip6tables-save > /etc/iptables/rules.v6

# Verification
echo -e "\n=== Final Configuration ==="
iptables -L -v -n

echo -e "\n[+] Reset and reconfiguration complete!"
shutdown -r +0 "Rebooting in 10 seconds" && sleep 10 && reboot
