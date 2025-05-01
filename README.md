# VPS Firewall Hardener for Penetration testers & Bug Bounty Hunters 🔐🐞

This script safely resets and configures `iptables` on a cloud VPS to reduce the risk of abuse-related bans while performing penetration testing or bug bounty activities. It blocks dangerous outbound ports, applies rate limits, and persists the configuration.

---

## 🚀 Why Use This?

Cloud providers like **DigitalOcean**, **AWS**, and **Vultr** may **suspend or ban VPS instances** if your outbound traffic looks abusive — e.g., sending SMTP traffic (port 25), performing brute-force login attempts (RDP/MySQL), or flooding DNS.

This script is made for:

- ✅ **Anyone using a cloud VPS for ethical hacking**

---

## 🔧 What It Does

- Resets all current `iptables` and `ip6tables` rules
- Blocks **high-risk outbound ports** (25, 3389, 3306, 161, 162)
- Applies **rate limiting** to:
  - SSH (`22/tcp`) — 1 connection/sec
  - DNS (`53/udp`) — 166 requests/sec
- Saves the firewall configuration for persistence
- Reboots the VPS safely after 10 seconds

---

## 🛠️ Usage

### 1. Clone or Download

```bash
https://github.com/XploitAsh/VPS-Gurd.git
cd VPS-Gurd
chmod +x guard.sh
sudo ./guard.sh
```
