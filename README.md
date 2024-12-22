# Anti-Sanction DNS Script

This repository contains a Bash script to manage DNS resolver settings for systems. The script allows users to:

1. Disable all existing DNS resolvers.
2. Check the current active DNS resolver.
3. Configure a new DNS resolver with anti-sanction services like **Shecan** or **403.online**.
4. Revert to default DNS resolvers (Google DNS: `8.8.8.8`, Quad9: `9.9.9.9`) if no service is selected.
5. Clear DNS cache to apply changes.

## Features

- **Anti-Sanction Services**:
  - Shecan: `178.22.122.100`, `185.51.200.2`
  - 403.online: `10.202.10.202`, `10.202.10.102`
- Default fallback DNS: `8.8.8.8`, `9.9.9.9`
- User-friendly interactive prompts.
- Cross-system DNS cache clearing support.

## Requirements

- Linux-based system.
- Bash shell.
- `sudo` privileges to modify DNS settings.

## Usage

### Download and Run

To download and run the script, use the following commands:

```bash
curl -O https://raw.githubusercontent.com/yourusername/yourrepo/main/dns-changer.sh
chmod +x dns-changer.sh
sudo ./dns-changer.sh
