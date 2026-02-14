#!/usr/bin/env bash
# ============================================================
#  C++ Dev Environment Setup — Ubuntu 24.04
# ============================================================
set -euo pipefail

echo "══════════════════════════════════════════════════"
echo "  C++ Development Environment — Ubuntu Setup"
echo "══════════════════════════════════════════════════"
echo ""

# ── 1. Update package lists ─────────────────────────────────
echo "📦 Updating package lists..."
sudo apt-get update -qq

# ── 2. Install compiler, debugger, build tools ──────────────
echo "🔧 Installing build-essential (g++, gcc, make) + GDB..."
sudo apt-get install -y build-essential gdb

# ── 3. Install CMake (Phase 0 uses CMake for all builds) ────
echo "🔧 Installing CMake..."
sudo apt-get install -y cmake

# ── 4. Install useful extras ────────────────────────────────
echo "🔧 Installing extras (clang-format, valgrind, git)..."
sudo apt-get install -y \
    clang-format \
    valgrind \
    git \
    pkg-config

# ── 5. Install Eigen (linear algebra library, used everywhere)
echo "🔧 Installing Eigen3..."
sudo apt-get install -y libeigen3-dev

# ── 6. Verify installations ────────────────────────────────
echo ""
echo "── Verification ─────────────────────────────────"
echo -n "  g++          : "; g++ --version | head -1
echo -n "  gdb          : "; gdb --version | head -1
echo -n "  cmake        : "; cmake --version | head -1
echo -n "  git          : "; git --version
echo -n "  clang-format : "; clang-format --version | head -1
echo -n "  valgrind     : "; valgrind --version
echo -n "  eigen3       : "; pkg-config --modversion eigen3 2>/dev/null || echo "installed (no pkg-config entry)"

# ── 7. Install VSCode (if not present) ─────────────────────
if ! command -v code &>/dev/null; then
    echo ""
    echo "📥 Installing Visual Studio Code..."
    sudo apt-get install -y wget gpg apt-transport-https
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
    echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | \
        sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null
    sudo apt-get update -qq
    sudo apt-get install -y code
    rm -f /tmp/packages.microsoft.gpg
    echo "  ✔ VSCode installed"
else
    echo ""
    echo "  ✔ VSCode already installed: $(code --version | head -1)"
fi

# ── 8. Install VSCode C++ extensions ───────────────────────
echo ""
echo "📦 Installing VSCode extensions..."
EXTENSIONS=(
    "ms-vscode.cpptools"                # IntelliSense, GDB debugging
    "ms-vscode.cpptools-extension-pack" # CMake Tools + themes
    "ms-vscode.cmake-tools"             # CMake configure/build/debug
    "twxs.cmake"                        # CMake syntax highlighting
)
for ext in "${EXTENSIONS[@]}"; do
    echo "  → $ext"
    code --install-extension "$ext" --force 2>/dev/null || echo "    ⚠ skipped (run outside SSH?)"
done

# ── 9. Create a starter project to confirm everything works ─
echo ""
echo "🚀 Creating test project ~/projects/hello-cpp..."

mkdir -p ~/projects/hello-cpp
cat > ~/projects/hello-cpp/main.cpp <<'CPP'
#include <iostream>
#include <vector>
#include <string>
#include <memory>

// Quick smoke test: modern C++ features used in Phase 0
int main() {
    // Range-based for (C++11)
    std::vector<std::string> msg{"Hello", "C++", "from", "Vector", "Lock!"};
    for (const auto& word : msg) {
        std::cout << word << " ";
    }
    std::cout << "\n";

    // Smart pointers (C++14)
    auto ptr = std::make_unique<int>(42);
    std::cout << "Smart pointer value: " << *ptr << "\n";

    // Structured bindings (C++17)
    auto [x, y] = std::pair{3.14, 2.71};
    std::cout << "Pair: " << x << ", " << y << "\n";

    return 0;
}
CPP

cat > ~/projects/hello-cpp/CMakeLists.txt <<'CMAKE'
cmake_minimum_required(VERSION 3.16)
project(hello-cpp LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)  # helps VSCode IntelliSense

add_executable(hello main.cpp)
CMAKE

# ── 10. Build and run the test project ─────────────────────
echo "🔨 Building test project..."
cd ~/projects/hello-cpp
cmake -B build -S . -DCMAKE_BUILD_TYPE=Debug
cmake --build build

echo ""
echo "▶  Running test project..."
./build/hello

echo ""
echo "══════════════════════════════════════════════════"
echo "  ✅  C++ environment ready!"
echo ""
echo "  Installed:"
echo "    • g++ + GDB + CMake + clang-format + valgrind"
echo "    • Eigen3 (linear algebra)"
echo "    • VSCode + C++ extensions"
echo ""
echo "  Test project: ~/projects/hello-cpp"
echo "    cd ~/projects/hello-cpp && code ."
echo ""
echo "  Next steps:"
echo "    1. Open the project:  cd ~/projects/hello-cpp && code ."
echo "    2. Set a breakpoint on any line, press F5 to debug"
echo "    3. Start learncpp.com Chapter 1 → Phase 0 is go"
echo "══════════════════════════════════════════════════"
