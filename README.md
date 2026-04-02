# autophoton

**Cross-platform Linux support** - Works on Termux (Android), Kali Linux, Ubuntu, Debian, Arch, and all major Linux distributions.

Photon Manager v2.0 - Universal Reconnaissance Automation Tool

A complete management wrapper for s0md3v's Photon reconnaissance tool that works seamlessly on both Linux and Termux (Android) environments. This script transforms Photon into a powerful, menu-driven OSINT and information gathering platform.

🔥 FEATURES (15+ Scanning Modes):

Basic Operations:
• Basic Scan - Default settings for standard reconnaissance
• Fast Scan - 50 threads, level 2 for quick results
• Aggressive Scan - Deep crawl level 5 with 100 threads
• Nuclear Mode - Extreme aggressive (level 8, 200 threads) - Use with caution!

Information Harvesting:
• Secret Keys & API Tokens Hunter - Automated key detection
• DNS & Subdomain Enumeration
• Wayback Machine Archive Scan
• Email Harvester - Automatic email extraction
• Custom Regex Pattern Search (11 built-in patterns)

Advanced Features:
• Full Recon Mode - Combines DNS + Keys + Wayback + Aggressive
• Local Website Cloning
• JSON Export Support
• Previous Results Viewer
• Clear Results & Update Tool Options

Built-in Regex Patterns:
✓ Email Addresses
✓ URLs & Links
✓ API Keys (32-40 chars)
✓ AWS Keys (AKIA format)
✓ Database Connection Strings
✓ Phone Numbers
✓ IPv4 Addresses
✓ Credit Card Numbers
✓ JWT Tokens
✓ Social Security Numbers (US)
✓ Custom pattern support

System Features:
• Automatic environment detection (Linux/Termux)
• Auto-installs missing dependencies (git, Python modules)
• Color-coded terminal output
• Timestamped results storage
• Cross-platform compatibility

REQUIREMENTS:
• Python 3.x
• Git
• Internet connection for installation

INSTALLATION:
1. git clone https://github.com/s0md3v/Photon.git ~/Photon
2. Run this script from any location
3. First run auto-installs all dependencies

USAGE:
./photon_manager.sh

OUTPUT LOCATION:
• Linux: ~/Photon/[domain-name]/
• Termux: /data/data/com.termux/files/home/Photon/[domain-name]/

⚠️ DISCLAIMER:
Use only on authorized systems and domains you own or have permission to test. Unauthorized scanning may violate laws and regulations.

📁 OUTPUT FILES:
• links.txt - Discovered URLs
• intel.txt - Intelligence gathered
• regex_results.txt - Pattern matching results
• dns.txt - Subdomain/DNS findings
• wayback_data.txt - Archive results
• json_output/ - JSON exports
