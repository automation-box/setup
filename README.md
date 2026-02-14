# Platform-Specific Setup Scripts

This repository contains platform-specific installation scripts for various tasks. The idea is to provide easy automation for installing software, tools, or setting up environments on different platforms (Ubuntu, Windows, macOS, etc.).

## Repository Structure

```
/repoInstallation
    /ubuntu
        install.sh    # Installation script for Ubuntu
    /windows
        install.ps1   # Installation script for Windows
    /macos
        install.sh    # Installation script for macOS
```

## Intended Platforms

* **Ubuntu** (currently 18.04, 20.04, etc.)
* **Windows** (via WSL or native installation methods)
* **macOS** (10.15 and above)

## Usage

1. Clone the repository:

   ```bash
   git clone https://github.com/your-username/platform-install-scripts.git
   cd platform-install-scripts/repo/[platform]
   ```

2. Run the appropriate script for your platform:

   * On Ubuntu:

     ```bash
     sudo ./install.sh
     ```
   * On Windows (PowerShell):

     ```powershell
     .\install.ps1
     ```
   * On macOS:

     ```bash
     ./install.sh
     ```


