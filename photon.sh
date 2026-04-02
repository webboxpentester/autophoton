#for_settings_up 10101010

# Photon Manager Script - Universal Linux/Termux Version
# Works on both Linux and Termux environments

set -e

# Detect environment
IS_TERMUX=false
if [ -d "/data/data/com.termux" ] || command -v termux-info >/dev/null 2>&1; then
    IS_TERMUX=true
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Set Python command based on environment
if command -v python3 >/dev/null 2>&1; then
    PYTHON_CMD="python3"
elif command -v python >/dev/null 2>&1; then
    PYTHON_CMD="python"
else
    echo -e "${RED}[!] Python not found!${NC}"
    exit 1
fi

# Set pip command
if command -v pip3 >/dev/null 2>&1; then
    PIP_CMD="pip3"
elif command -v pip >/dev/null 2>&1; then
    PIP_CMD="pip"
else
    PIP_CMD="pip"
fi

# Banner
clear
echo -e "${GREEN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║            PHOTON RECONNAISSANCE MANAGER v2.0           ║"
if [ "$IS_TERMUX" = true ]; then
    echo "║              Termux Edition - Real World Tool           ║"
else
    echo "║              Linux Edition - Real World Tool            ║"
fi
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check and install dependencies
check_dependencies() {
    echo -e "${YELLOW}[*] Checking dependencies...${NC}"
    
    # Check for git
    if ! command -v git >/dev/null 2>&1; then
        echo -e "${YELLOW}[!] Git not found. Installing...${NC}"
        if [ "$IS_TERMUX" = true ]; then
            pkg install -y git
        else
            if command -v apt >/dev/null 2>&1; then
                sudo apt install -y git
            elif command -v dnf >/dev/null 2>&1; then
                sudo dnf install -y git
            elif command -v yum >/dev/null 2>&1; then
                sudo yum install -y git
            elif command -v pacman >/dev/null 2>&1; then
                sudo pacman -S --noconfirm git
            fi
        fi
    fi
    
    # Check for Python requirements
    if ! $PYTHON_CMD -c "import requests" 2>/dev/null; then
        echo -e "${YELLOW}[!] Installing Python requests module...${NC}"
        $PIP_CMD install requests
    fi
    
    if ! $PYTHON_CMD -c "import bs4" 2>/dev/null; then
        echo -e "${YELLOW}[!] Installing BeautifulSoup4...${NC}"
        $PIP_CMD install beautifulsoup4
    fi
    
    echo -e "${GREEN}[+] Dependencies OK${NC}"
}

# Check if Photon exists
if [ ! -d "$HOME/Photon" ]; then
    echo -e "${RED}[!] Photon not found in $HOME/Photon${NC}"
    echo -e "${YELLOW}[+] Installing Photon...${NC}"
    
    # Install dependencies first
    check_dependencies
    
    cd $HOME
    git clone https://github.com/s0md3v/Photon.git
    cd Photon
    
    # Install requirements
    if [ -f "requirements.txt" ]; then
        $PIP_CMD install -r requirements.txt
    fi
    
    echo -e "${GREEN}[+] Photon installed successfully!${NC}"
    sleep 2
    clear
fi

# Function to extract domain from URL
extract_domain() {
    local url=$1
    local domain=$(echo "$url" | sed -E 's|^https?://||')
    domain=$(echo "$domain" | cut -d'/' -f1)
    domain=$(echo "$domain" | cut -d':' -f1)
    echo "$domain"
}

# Function to get target URL
get_target() {
    echo -e "${CYAN}[?] Enter target URL (e.g., https://example.com): ${NC}"
    read -r TARGET
    if [ -z "$TARGET" ]; then
        echo -e "${RED}[!] No URL provided!${NC}"
        return 1
    fi
    if [[ ! "$TARGET" =~ ^https?:// ]]; then
        TARGET="https://$TARGET"
    fi
    return 0
}

# Function to show results location
show_results() {
    local domain=$(extract_domain "$TARGET")
    echo -e "${GREEN}[+] Results saved in: ${YELLOW}$HOME/Photon/$domain${NC}"
    if [ "$IS_TERMUX" = true ]; then
        echo -e "${GREEN}[+] Location: ${YELLOW}/data/data/com.termux/files/home/Photon/$domain${NC}"
    else
        echo -e "${GREEN}[+] Location: ${YELLOW}$HOME/Photon/$domain${NC}"
    fi
}

# Function for regex pattern selection
select_regex_pattern() {
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[1]${NC} 📧 Email Addresses"
    echo -e "${GREEN}[2]${NC} 🔗 URLs & Links"
    echo -e "${GREEN}[3]${NC} 🔑 API Keys (Generic)"
    echo -e "${GREEN}[4]${NC} 🔐 AWS Keys (AKIA...)"
    echo -e "${GREEN}[5]${NC} 🗄️  Database Connection Strings"
    echo -e "${GREEN}[6]${NC} 📱 Phone Numbers"
    echo -e "${GREEN}[7]${NC} 🆔 IPv4 Addresses"
    echo -e "${GREEN}[8]${NC} 💳 Credit Card Numbers"
    echo -e "${GREEN}[9]${NC} 🔑 JWT Tokens"
    echo -e "${GREEN}[10]${NC} 🎨 Social Security Numbers (US)"
    echo -e "${GREEN}[11]${NC} 📝 Custom Pattern (Manual Input)"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[?] Select pattern type (1-11): ${NC}"
    read -r pattern_choice
    
    case $pattern_choice in
        1) regex="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
           pattern_name="emails" ;;
        2) regex="https?://[a-zA-Z0-9./?=_-]+"
           pattern_name="urls" ;;
        3) regex="[a-zA-Z0-9]{32,40}"
           pattern_name="api_keys" ;;
        4) regex="AKIA[0-9A-Z]{16}"
           pattern_name="aws_keys" ;;
        5) regex="(mongodb|mysql|postgresql|redis)://[a-zA-Z0-9._%+-]+(:[^@]+)?@[a-zA-Z0-9.-]+:[0-9]+/[a-zA-Z0-9_]+"
           pattern_name="db_strings" ;;
        6) regex="\+?[0-9]{1,4}[-.]?\(?[0-9]{1,4}\)?[-.]?[0-9]{3,4}[-.]?[0-9]{3,4}"
           pattern_name="phone_numbers" ;;
        7) regex="[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}"
           pattern_name="ip_addresses" ;;
        8) regex="\b(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|3[47][0-9]{13}|6(?:011|5[0-9]{2})[0-9]{12})\b"
           pattern_name="credit_cards" ;;
        9) regex="eyJ[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*\.[a-zA-Z0-9_-]*"
           pattern_name="jwt_tokens" ;;
        10) regex="[0-9]{3}-[0-9]{2}-[0-9]{4}"
            pattern_name="ssn" ;;
        11) echo -e "${YELLOW}[?] Enter your custom regex pattern: ${NC}"
            read -r regex
            echo -e "${YELLOW}[?] Enter a name for this pattern: ${NC}"
            read -r pattern_name ;;
        *) echo -e "${RED}[!] Invalid choice! Using default email pattern.${NC}"
           regex="[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
           pattern_name="emails" ;;
    esac
    
    echo -e "${GREEN}[+] Using pattern: ${YELLOW}$regex${NC}"
}

# Function for automatic email search
auto_email_search() {
    get_target
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[+] Starting automatic email harvesting...${NC}"
        cd $HOME/Photon
        $PYTHON_CMD photon.py -u "$TARGET" -r "[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}"
        show_results
        local domain=$(extract_domain "$TARGET")
        if [ -f "$HOME/Photon/$domain/regex_results.txt" ]; then
            echo -e "${GREEN}[+] Found emails:${NC}"
            head -20 "$HOME/Photon/$domain/regex_results.txt"
        fi
    fi
}

# Function to ensure proper permissions
ensure_permissions() {
    if [ ! -x "$HOME/Photon/photon.py" ]; then
        chmod +x "$HOME/Photon/photon.py"
    fi
}

# Ensure proper permissions
ensure_permissions

# Main menu
while true; do
    echo ""
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}[1]${NC} 🔍 Basic Scan (Default settings)"
    echo -e "${GREEN}[2]${NC} ⚡ Fast Scan (High threads, level 2)"
    echo -e "${GREEN}[3]${NC} 🎯 Aggressive Scan (Deep crawl, level 5)"
    echo -e "${GREEN}[4]${NC} 🔑 Secret Keys & API Tokens Hunter"
    echo -e "${GREEN}[5]${NC} 🌐 DNS & Subdomain Enumeration"
    echo -e "${GREEN}[6]${NC} 📜 Wayback Machine Archive Scan"
    echo -e "${GREEN}[7]${NC} 💀 Full Recon (DNS + Keys + Wayback + Aggressive)"
    echo -e "${GREEN}[8]${NC} 📂 Clone Website Locally"
    echo -e "${GREEN}[9]${NC} 📧 AUTOMATIC EMAIL HARVESTER"
    echo -e "${GREEN}[10]${NC} 🕸️ Custom Regex Pattern Search (11 Patterns)"
    echo -e "${GREEN}[11]${NC} ☢️ NUCLEAR MODE (Extreme Aggressive - Use Carefully!)"
    echo -e "${GREEN}[12]${NC} 📊 Export as JSON"
    echo -e "${GREEN}[13]${NC} 📁 View Results from Previous Scan"
    echo -e "${GREEN}[14]${NC} 🧹 Clear All Photon Results"
    echo -e "${GREEN}[15]${NC} 🔄 Update Photon Tool"
    echo -e "${RED}[0]${NC} ❌ Exit"
    echo -e "${CYAN}════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}[?] Choose option (0-15): ${NC}"
    read -r choice

    case $choice in
        1)  # Basic Scan
            if get_target; then
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET"
                show_results
            fi
            ;;
        2)  # Fast Scan
            if get_target; then
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET" -t 50 -l 2
                show_results
            fi
            ;;
        3)  # Aggressive Scan
            if get_target; then
                echo -e "${RED}[!] Aggressive Mode - Deep Crawl Level 5${NC}"
                echo -e "${YELLOW}[?] Continue? (y/n): ${NC}"
                read -r confirm
                if [[ $confirm == "y" || $confirm == "Y" ]]; then
                    cd $HOME/Photon
                    $PYTHON_CMD photon.py -u "$TARGET" -l 5 -t 100 -d 0
                    show_results
                fi
            fi
            ;;
        4)  # Secret Keys Hunter
            if get_target; then
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET" --keys
                show_results
            fi
            ;;
        5)  # DNS & Subdomain Enumeration
            if get_target; then
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET" --dns
                show_results
            fi
            ;;
        6)  # Wayback Machine Scan
            if get_target; then
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET" --wayback
                show_results
            fi
            ;;
        7)  # Full Recon
            if get_target; then
                echo -e "${RED}[!] FULL RECON MODE - DNS + Keys + Wayback + Aggressive${NC}"
                echo -e "${YELLOW}[?] Continue? (y/n): ${NC}"
                read -r confirm
                if [[ $confirm == "y" || $confirm == "Y" ]]; then
                    cd $HOME/Photon
                    $PYTHON_CMD photon.py -u "$TARGET" -l 4 -t 80 --dns --keys --wayback
                    show_results
                fi
            fi
            ;;
        8)  # Clone Website
            if get_target; then
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET" --clone
                show_results
            fi
            ;;
        9)  # AUTOMATIC EMAIL HARVESTER
            auto_email_search
            ;;
        10) # Custom Regex Pattern Search
            if get_target; then
                select_regex_pattern
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET" -r "$regex"
                show_results
            fi
            ;;
        11) # NUCLEAR MODE
            echo -e "${RED}╔══════════════════════════════════════════════════════════╗${NC}"
            echo -e "${RED}║              🔥 NUCLEAR MODE ACTIVATED 🔥                ║${NC}"
            echo -e "${RED}║  Extreme Aggressive - Max Threads - Deep Crawl Level 8  ║${NC}"
            echo -e "${RED}╚══════════════════════════════════════════════════════════╝${NC}"
            if get_target; then
                echo -e "${YELLOW}[?] Type 'NUCLEAR' to confirm: ${NC}"
                read -r confirm_nuclear
                if [[ $confirm_nuclear == "NUCLEAR" ]]; then
                    cd $HOME/Photon
                    $PYTHON_CMD photon.py -u "$TARGET" -l 8 -t 200 --dns --keys --wayback --headers -d 0
                    show_results
                fi
            fi
            ;;
        12) # Export as JSON
            if get_target; then
                cd $HOME/Photon
                $PYTHON_CMD photon.py -u "$TARGET" -e json
                show_results
            fi
            ;;
        13) # View Results
            echo -e "${CYAN}[+] Available scan results:${NC}"
            if [ -d "$HOME/Photon" ]; then
                ls -d $HOME/Photon/*/ 2>/dev/null | while read dir; do
                    basename "$dir"
                done
            fi
            echo -e "${YELLOW}[?] Enter domain name to view: ${NC}"
            read -r domain
            if [ -d "$HOME/Photon/$domain" ]; then
                echo -e "${GREEN}Contents of $domain:${NC}"
                ls -la "$HOME/Photon/$domain/"
                echo ""
                echo -e "${YELLOW}[?] View a specific file? (enter filename or 'n'): ${NC}"
                read -r file
                if [ "$file" != "n" ] && [ -f "$HOME/Photon/$domain/$file" ]; then
                    cat "$HOME/Photon/$domain/$file"
                fi
            else
                echo -e "${RED}[!] No results found for: $domain${NC}"
            fi
            ;;
        14) # Clear Results
            echo -e "${RED}[!] This will delete ALL Photon scan results!${NC}"
            echo -e "${YELLOW}[?] Type 'DELETE' to confirm: ${NC}"
            read -r confirm_del
            if [[ $confirm_del == "DELETE" ]]; then
                cd $HOME/Photon
                find . -maxdepth 1 -type d ! -name "." ! -name ".git" -exec rm -rf {} + 2>/dev/null || true
                echo -e "${GREEN}[+] All results cleared!${NC}"
            fi
            ;;
        15) # Update Photon
            echo -e "${GREEN}[+] Updating Photon...${NC}"
            cd $HOME/Photon
            git pull
            if [ -f "requirements.txt" ]; then
                $PIP_CMD install -r requirements.txt --upgrade
            fi
            echo -e "${GREEN}[+] Photon updated successfully!${NC}"
            ;;
        0)  # Exit
            echo -e "${GREEN}[+] Exiting...${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}[!] Invalid option! Please choose 0-15${NC}"
            ;;
    esac
    
    echo ""
    echo -e "${YELLOW}[?] Press Enter to continue...${NC}"
    read -r
    clear
done