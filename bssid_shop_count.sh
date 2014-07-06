echo "keys BSSID*" | redis-cli -h $ipaddr0 | awk '{print("scard ",$1)}' | redis-cli -h $ipaddr0

