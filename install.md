Run this script by copying, pasting, and hitting Enter in your terminal. (required)

echo "" && echo "" echo -n "Which environment are you on? (1=Termux / 2=Linux) Type (1/2): " && read choice && if [ "$choice" -eq 1 ]; then sed -i 's|#for_settings_up 10101010|#!/data/data/com.termux/files/usr/bin/bash|' photon.sh && echo "Updated for Termux in photon.sh"; elif [ "$choice" -eq 2 ]; then sed -i 's|#for_settings_up 10101010|#!/bin/bash|' photon.sh && echo "Updated for Linux in photon.sh"; else echo "Invalid choice. Please run again and type 1 or 2."; fi


If you haven't installed feroxbuster and sqlmap yet, run: 
./dependency_if_need.sh

If the script fails, please install those tools manually.
