######### Anti Sanction DNS

#!/bin/bash

# Function to clear DNS cache
dns_cache_clear() {
    if command -v systemd-resolve &>/dev/null; then
        sudo systemd-resolve --flush-caches
        echo "DNS cache cleared."
    elif command -v resolvectl &>/dev/null; then
        sudo resolvectl flush-caches
        echo "DNS cache cleared."
    elif [ -f /etc/init.d/dns-clean ]; then
        sudo /etc/init.d/dns-clean restart
        echo "DNS cache cleared."
    else
        echo "Unable to determine DNS cache clearing method for your system."
    fi
}

# Function to configure DNS resolver
configure_dns() {
    local primary_dns=$1
    local secondary_dns=$2

    echo "Configuring DNS resolvers..."
    sudo sed -i '/^nameserver/d' /etc/resolv.conf
    echo "nameserver $primary_dns" | sudo tee -a /etc/resolv.conf
    echo "nameserver $secondary_dns" | sudo tee -a /etc/resolv.conf
    echo "DNS resolvers set to $primary_dns and $secondary_dns."
}

# Function to check active DNS resolver
check_active_resolver() {
    echo "Checking active DNS resolver..."
    local active_dns
    active_dns=$(grep '^nameserver' /etc/resolv.conf | awk '{print $2}')
    if [ -z "$active_dns" ]; then
        echo "No active DNS resolver configured."
    else
        echo "Active DNS resolver(s): $active_dns"
    fi
}

# Check current DNS resolver
check_active_resolver

# Disable existing DNS resolvers (remove entries from resolv.conf)
echo "Disabling all existing DNS resolvers..."
sudo sed -i '/^nameserver/d' /etc/resolv.conf

echo "Are you sure you want to enable Anti-Sanctions DNS Service? (yes/no)"
read -r enable_dns

if [[ "$enable_dns" =~ ^([Yy][Ee][Ss]|[Yy])$ ]]; then
    echo "Which service do you want to use?"
    echo "1. Shecan"
    echo "2. 403.online"
    read -r service_choice

    if [ "$service_choice" = "1" ]; then
        configure_dns 178.22.122.100 185.51.200.2
    elif [ "$service_choice" = "2" ]; then
        configure_dns 10.202.10.202 10.202.10.102
    else
        echo "Invalid choice. Setting default DNS to 8.8.8.8 and 9.9.9.9."
        configure_dns 8.8.8.8 9.9.9.9
    fi
else
    echo "Anti-Sanctions DNS Service not enabled. Setting default DNS to 8.8.8.8 and 9.9.9.9."
    configure_dns 8.8.8.8 9.9.9.9
fi

# Clear DNS cache
dns_cache_clear
