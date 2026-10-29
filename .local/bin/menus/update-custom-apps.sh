#!/bin/bash
# ═══════════════════════════════════════════════════════════════
# INTERACTIVE SOURCE APP UPDATER v2 - Terminal Edition
# ═══════════════════════════════════════════════════════════════
# 
# CONFIGURATION SECTION - Edit these easily when upstream changes
#

SOURCE_DIR="$HOME/Source"
BIN_DIR="$HOME/.local/bin"

# App definitions
APPS=("ly" "linux-wallpaperengine" "yazi")
APP_NAMES=("Ly (Display Manager)" "Linux Wallpaper Engine" "Yazi (File Manager)")

# Build commands for each app
# Format: command to run from the app source directory
LY_BUILD="make"
LY_INSTALL="echo '⚠️ Ly requires sudo:' && sudo make install"

WPE_BUILD="mkdir -p build && cd build && cmake .. && make"
WPE_INSTALL="cp build/linux-wallpaperengine ${BIN_DIR}/"

YAZI_BUILD="cargo build --release"
YAZI_INSTALL="cp target/release/yazi ${BIN_DIR}/ && cp target/release/ya ${BIN_DIR}/"

# Dependencies for each app (space separated package names)
LY_DEPS="build-essential"
WPE_DEPS="libsdl2-dev libsdl2-image-dev liblz4-dev libmpv-dev cmake"
YAZI_DEPS="cargo rustc"

# ═══════════════════════════════════════════════════════════════
# UI & UTILITIES
# ═══════════════════════════════════════════════════════════════

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

print_header() {
    clear
    echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BOLD}${BLUE}║         📦 SOURCE APP UPDATER - ${USER}@${HOSTNAME}          ║${NC}"
    echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════════════╝${NC}"
}

print_line() {
    echo -e "${BLUE}──────────────────────────────────────────────────────────────${NC}"
}

print_app_box() {
    local name="$1"
    echo -e "\n${BOLD}${CYAN}┌── ${name} ──────────────────────────────────────┐${NC}"
}

print_app_box_end() {
    echo -e "${BOLD}${CYAN}└──────────────────────────────────────────────────────┘${NC}"
}

print_app_status() {
    local name="$1"
    local dir="$2"
    
    if [ ! -d "$dir/.git" ]; then
        echo -e "   ${RED}❌ $name - Not a git repo${NC}"
        return
    fi

    cd "$dir" || return
    local current=$(git rev-parse --short HEAD)
    local branch=$(git rev-parse --abbrev-ref HEAD)
    
    git fetch --quiet origin 2>/dev/null || {
        echo -e "   ${YELLOW}⚠️  $name - Offline${NC}"
        return
    }
    
    local behind=$(git rev-list --count HEAD..origin/${branch} 2>/dev/null)
    
    if [ -z "$behind" ] || [ "$behind" -eq 0 ]; then
        echo -e "   ${GREEN}✅${NC} ${WHITE}$name${NC} ${CYAN}[$branch: $current]${NC} ${GREEN}UP TO DATE${NC}"
    else
        echo -e "   ${YELLOW}📥${NC} ${WHITE}$name${NC} ${CYAN}[$branch: $current]${NC} ${YELLOW}($behind commits behind)${NC}"
    fi
}

# ═══════════════════════════════════════════════════════════════
# MENU FUNCTIONS
# ═══════════════════════════════════════════════════════════════

show_main_menu() {
    print_header
    
    echo -e "\n${BOLD}${CYAN}📊 App Status Overview:${NC}"
    print_line
    
    for i in "${!APPS[@]}"; do
        print_app_status "${APP_NAMES[$i]}" "$SOURCE_DIR/${APPS[$i]}"
    done
    
    echo -e "\n${BOLD}${CYAN}📋 Menu Options:${NC}"
    print_line
    echo -e ""
    echo -e "   ${MAGENTA}[1]${NC} 🔍  Check Update (Detailed)"
    echo -e "   ${MAGENTA}[2]${NC} 📝  Changelog / Release Notes / Diff"
    echo -e "   ${MAGENTA}[3]${NC} 🔨  Build App"
    echo -e "   ${MAGENTA}[4]${NC} 🔍  Check Dependencies"
    echo -e "   ${MAGENTA}[5]${NC} 🔄  Full Auto Update"
    echo -e "   ${MAGENTA}[6]${NC} ❌  Exit"
    echo -e ""
    print_line
    
    echo -ne "\n${YELLOW}❓ Select option [1-6]: ${NC}"
    read -r choice
    
    case "$choice" in
        1) check_update_menu ;;
        2) changelog_menu ;;
        3) build_menu ;;
        4) deps_menu ;;
        5) full_auto_update ;;
        6|q|Q) 
            echo -e "\n${GREEN}👋 Goodbye!${NC}\n"
            exit 0
            ;;
        *) 
            echo -e "\n${RED}❌ Invalid option${NC}"
            sleep 1
            show_main_menu
            ;;
    esac
}

# ─── 1. CHECK UPDATE (DETAILED) ───
check_update_menu() {
    print_header
    echo -e "\n${BOLD}${CYAN}🔍 Detailed Update Check:${NC}\n"
    
    for i in "${!APPS[@]}"; do
        local dir="$SOURCE_DIR/${APPS[$i]}"
        local name="${APP_NAMES[$i]}"
        
        print_app_box "$name"
        
        if [ ! -d "$dir/.git" ]; then
            echo -e "${RED}   Not a git repository${NC}"
            print_app_box_end
            echo ""
            continue
        fi
        
        cd "$dir" || continue
        
        local current=$(git rev-parse --short HEAD)
        local branch=$(git rev-parse --abbrev-ref HEAD)
        local current_date=$(git log -1 --format=%cd --date=short)
        local current_msg=$(git log -1 --format=%s)
        
        echo -e "${BLUE}   Local:${NC}  ${CYAN}$current${NC} ($current_date) - $current_msg"
        
        if git fetch --quiet origin 2>/dev/null; then
            local remote=$(git rev-parse --short origin/${branch})
            local remote_date=$(git log -1 --format=%cd --date=short origin/${branch})
            local remote_msg=$(git log -1 --format=%s origin/${branch})
            local behind=$(git rev-list --count HEAD..origin/${branch} 2>/dev/null)
            
            echo -e "${BLUE}   Remote:${NC} ${CYAN}$remote${NC} ($remote_date) - $remote_msg"
            
            if [ -n "$behind" ] && [ "$behind" -gt 0 ]; then
                echo -e "${YELLOW}   Status: 📥 $behind commit(s) behind${NC}"
            else
                echo -e "${GREEN}   Status: ✅ Up to date${NC}"
            fi
        else
            echo -e "${RED}   Status: ⚠️ Cannot reach remote${NC}"
        fi
        
        print_app_box_end
        echo ""
    done
    
    echo -ne "\n${BLUE}Press Enter to return to menu...${NC}"
    read
    show_main_menu
}

# ─── 2. CHANGELOG / DIFF ───
changelog_menu() {
    print_header
    echo -e "\n${BOLD}${CYAN}📝 Changelog / Release Notes / Diff${NC}"
    print_line
    echo -e ""
    
    for i in "${!APPS[@]}"; do
        echo -e "   ${MAGENTA}[$((i+1))]${NC} ${APP_NAMES[$i]}"
    done
    echo -e "   ${MAGENTA}[0]${NC} ↩  Back to Main Menu"
    echo -e ""
    print_line
    
    echo -ne "\n${YELLOW}❓ Select app [0-${#APPS[@]}]: ${NC}"
    read -r choice
    
    if [ "$choice" = "0" ] || [ "$choice" = "q" ]; then
        show_main_menu
        return
    fi
    
    local idx=$((choice-1))
    if [ "$idx" -lt 0 ] || [ "$idx" -ge "${#APPS[@]}" ]; then
        echo -e "\n${RED}❌ Invalid selection${NC}"
        sleep 1
        changelog_menu
        return
    fi
    
    show_changelog "$idx"
}

show_changelog() {
    local idx="$1"
    local app="${APPS[$idx]}"
    local name="${APP_NAMES[$idx]}"
    local dir="$SOURCE_DIR/$app"
    
    print_header
    
    if [ ! -d "$dir/.git" ]; then
        echo -e "\n${RED}❌ Not a git repository${NC}\n"
        echo -ne "${BLUE}Press Enter...${NC}"
        read
        changelog_menu
        return
    fi
    
    cd "$dir" || return
    local branch=$(git rev-parse --abbrev-ref HEAD)
    
    git fetch --quiet origin 2>/dev/null || {
        echo -e "\n${RED}❌ Cannot fetch from remote${NC}\n"
        echo -ne "${BLUE}Press Enter...${NC}"
        read
        changelog_menu
        return
    }
    
    local behind=$(git rev-list --count HEAD..origin/${branch} 2>/dev/null)
    
    if [ -z "$behind" ] || [ "$behind" -eq 0 ]; then
        echo -e "\n${GREEN}✅ $name is already up to date!${NC}\n"
        echo -ne "${BLUE}Press Enter...${NC}"
        read
        changelog_menu
        return
    fi
    
    echo -e "\n${BOLD}${CYAN}📝 Changelog for $name${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${BOLD}${YELLOW}📋 New Commits ($behind total):${NC}\n"
    git log --pretty=format:"   ${GREEN}%h${NC} ${YELLOW}%ad${NC} %s" --date=short HEAD..origin/${branch}
    
    echo -e "\n\n${BOLD}${CYAN}📊 File Changes Summary:${NC}\n"
    git diff --stat HEAD origin/${branch} | sed 's/^/   /'
    
    echo -e "\n${BOLD}${CYAN}📝 Detailed Diff (first 80 lines):${NC}\n"
    git diff --color HEAD origin/${branch} | sed 's/^/   /' | head -80
    
    echo -e "\n${BLUE}Press Enter to return...${NC}"
    read
    changelog_menu
}

# ─── 3. BUILD ───
build_menu() {
    print_header
    echo -e "\n${BOLD}${CYAN}🔨 Build App${NC}"
    print_line
    echo -e ""
    
    for i in "${!APPS[@]}"; do
        echo -e "   ${MAGENTA}[$((i+1))]${NC} ${APP_NAMES[$i]}"
    done
    echo -e "   ${MAGENTA}[0]${NC} ↩  Back to Main Menu"
    echo -e ""
    print_line
    
    echo -ne "\n${YELLOW}❓ Select app to build [0-${#APPS[@]}]: ${NC}"
    read -r choice
    
    if [ "$choice" = "0" ] || [ "$choice" = "q" ]; then
        show_main_menu
        return
    fi
    
    local idx=$((choice-1))
    if [ "$idx" -lt 0 ] || [ "$idx" -ge "${#APPS[@]}" ]; then
        echo -e "\n${RED}❌ Invalid selection${NC}"
        sleep 1
        build_menu
        return
    fi
    
    build_app "$idx"
}

build_app() {
    local idx="$1"
    local app="${APPS[$idx]}"
    local name="${APP_NAMES[$idx]}"
    local dir="$SOURCE_DIR/$app"
    
    print_header
    echo -e "\n${BOLD}${CYAN}🔨 Building: $name${NC}\n"
    
    if [ ! -d "$dir" ]; then
        echo -e "${RED}❌ Source directory not found: $dir${NC}\n"
        echo -ne "${BLUE}Press Enter...${NC}"
        read
        build_menu
        return
    fi
    
    cd "$dir" || return
    
    # Select build command
    local build_cmd=""
    local install_cmd=""
    case "$app" in
        "ly") 
            build_cmd="$LY_BUILD"
            install_cmd="$LY_INSTALL"
            ;;
        "linux-wallpaperengine")
            build_cmd="$WPE_BUILD"
            install_cmd="$WPE_INSTALL"
            ;;
        "yazi")
            build_cmd="$YAZI_BUILD"
            install_cmd="$YAZI_INSTALL"
            ;;
    esac
    
    echo -e "${BLUE}📁 Directory:${NC} $dir"
    echo -e "${BLUE}🔧 Build:${NC}   $build_cmd"
    echo -e "${BLUE}📦 Install:${NC} $install_cmd\n"
    print_line
    
    # Run build
    echo -e "\n${YELLOW}Running build...${NC}\n"
    eval "$build_cmd"
    local build_status=$?
    
    if [ $build_status -ne 0 ]; then
        echo -e "\n${RED}❌ Build failed!${NC}\n"
        print_line
        echo -e "${YELLOW}Options:${NC}"
        echo -e "  ${MAGENTA}[r]${NC} Retry build"
        echo -e "  ${MAGENTA}[s]${NC} Update submodules & retry"
        echo -e "  ${MAGENTA}[d]${NC} Check dependencies"
        echo -e "  ${MAGENTA}[b]${NC} Back to menu"
        echo -ne "\n${YELLOW}Choice [r/s/d/b]: ${NC}"
        read -r choice
        
        case "$choice" in
            [Rr]*) build_app "$idx" ;;
            [Ss]*)
                echo -e "\n${BLUE}📦 Updating submodules...${NC}"
                git submodule update --init --recursive
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}✅ Submodules updated! Retrying build...${NC}\n"
                    build_app "$idx"
                else
                    echo -e "${RED}❌ Submodule update failed${NC}\n"
                    echo -ne "${BLUE}Press Enter...${NC}"
                    read
                    build_menu
                fi
                ;;
            [Dd]*) 
                check_deps "$idx"
                echo -ne "\n${BLUE}Press Enter...${NC}"
                read
                build_menu
                ;;
            *) build_menu ;;
        esac
        return
    fi
    
    echo -e "\n${GREEN}✅ Build successful!${NC}\n"
    
    # Ask to install
    echo -ne "${YELLOW}❓ Install binary? [Y/n]: ${NC}"
    read -r install_choice
    
    if [[ ! "$install_choice" =~ [Nn] ]]; then
        echo -e "\n${BLUE}📦 Installing...${NC}"
        eval "$install_cmd"
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ Install successful!${NC}\n"
        else
            echo -e "${RED}❌ Install failed${NC}\n"
        fi
    fi
    
    echo -ne "${BLUE}Press Enter to continue...${NC}"
    read
    build_menu
}

# ─── 4. CHECK DEPENDENCIES ───
deps_menu() {
    print_header
    echo -e "\n${BOLD}${CYAN}🔍 Check Dependencies${NC}"
    print_line
    echo -e ""
    
    for i in "${!APPS[@]}"; do
        echo -e "   ${MAGENTA}[$((i+1))]${NC} ${APP_NAMES[$i]}"
    done
    echo -e "   ${MAGENTA}[0]${NC} ↩  Back to Main Menu"
    echo -e ""
    print_line
    
    echo -ne "\n${YELLOW}❓ Select app [0-${#APPS[@]}]: ${NC}"
    read -r choice
    
    if [ "$choice" = "0" ] || [ "$choice" = "q" ]; then
        show_main_menu
        return
    fi
    
    local idx=$((choice-1))
    if [ "$idx" -lt 0 ] || [ "$idx" -ge "${#APPS[@]}" ]; then
        echo -e "\n${RED}❌ Invalid selection${NC}"
        sleep 1
        deps_menu
        return
    fi
    
    check_deps "$idx"
    echo -ne "\n${BLUE}Press Enter...${NC}"
    read
    deps_menu
}

check_deps() {
    local idx="$1"
    local name="${APP_NAMES[$idx]}"
    local deps=""
    
    case "${APPS[$idx]}" in
        "ly") deps="$LY_DEPS" ;;
        "linux-wallpaperengine") deps="$WPE_DEPS" ;;
        "yazi") deps="$YAZI_DEPS" ;;
    esac
    
    print_header
    echo -e "\n${BOLD}${CYAN}🔍 Dependency Check: $name${NC}\n"
    echo -e "${BLUE}Required packages:${NC} ${deps}\n"
    print_line
    echo -e "${CYAN}Checking...${NC}\n"
    
    local all_ok=true
    for pkg in $deps; do
        if dpkg -l | grep -q "^ii  $pkg " 2>/dev/null; then
            echo -e "   ${GREEN}✅${NC} $pkg"
        else
            echo -e "   ${RED}❌${NC} $pkg ${YELLOW}(missing)${NC}"
            all_ok=false
        fi
    done
    
    echo ""
    print_line
    if [ "$all_ok" = true ]; then
        echo -e "${GREEN}✅ All dependencies satisfied!${NC}\n"
    else
        echo -e "${YELLOW}⚠️ Some dependencies missing.${NC}"
        echo -e "${CYAN}Install with:${NC}"
        echo -e "   ${YELLOW}sudo apt install $deps${NC}\n"
    fi
}

# ─── 5. FULL AUTO UPDATE ───
full_auto_update() {
    print_header
    echo -e "\n${BOLD}${YELLOW}🔄 FULL AUTO UPDATE${NC}"
    echo -e "${YELLOW}This will: git pull → build → install for ALL apps${NC}\n"
    echo -ne "${YELLOW}Continue? [y/N]: ${NC}"
    read -r confirm
    
    if [[ ! "$confirm" =~ [Yy] ]]; then
        show_main_menu
        return
    fi
    
    for i in "${!APPS[@]}"; do
        local app="${APPS[$i]}"
        local name="${APP_NAMES[$i]}"
        local dir="$SOURCE_DIR/$app"
        
        echo -e "\n${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${BOLD}${CYAN}  📦 $name${NC}"
        echo -e "${BOLD}${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}\n"
        
        if [ ! -d "$dir/.git" ]; then
            echo -e "${RED}❌ Skipping: Not a git repo${NC}"
            continue
        fi
        
        cd "$dir" || continue
        
        # Git pull
        echo -e "${BLUE}⬇️  git pull...${NC}"
        git pull
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Git pull failed, skipping build${NC}"
            continue
        fi
        echo -e "${GREEN}✅ Source updated${NC}\n"
        
        # Update submodules if any
        if [ -f ".gitmodules" ]; then
            echo -e "${BLUE}📦 Updating submodules...${NC}"
            git submodule update --init --recursive
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Submodules updated${NC}\n"
            else
                echo -e "${YELLOW}⚠️  Submodule update warning (non-fatal)${NC}\n"
            fi
        fi
        
        # Update submodules if any
        if [ -f ".gitmodules" ]; then
            echo -e "${BLUE}📦 Updating submodules...${NC}"
            git submodule update --init --recursive
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✅ Submodules updated${NC}\n"
            else
                echo -e "${YELLOW}⚠️  Submodule update warning (non-fatal)${NC}\n"
            fi
        fi
        
        # Build
        local build_cmd=""
        local install_cmd=""
        case "$app" in
            "ly") build_cmd="$LY_BUILD"; install_cmd="$LY_INSTALL" ;;
            "linux-wallpaperengine") build_cmd="$WPE_BUILD"; install_cmd="$WPE_INSTALL" ;;
            "yazi") build_cmd="$YAZI_BUILD"; install_cmd="$YAZI_INSTALL" ;;
        esac
        
        echo -e "${BLUE}🔨 Building...${NC}"
        eval "$build_cmd"
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Build failed${NC}\n"
            continue
        fi
        echo -e "${GREEN}✅ Build successful${NC}\n"
        
        # Install
        echo -e "${BLUE}📦 Installing...${NC}"
        eval "$install_cmd"
        if [ $? -ne 0 ]; then
            echo -e "${RED}❌ Install failed${NC}\n"
            continue
        fi
        echo -e "${GREEN}✅ Install successful${NC}\n"
    done
    
    echo -e "\n${BOLD}${GREEN}══════════════════════════════════════════════════════${NC}"
    echo -e "${BOLD}${GREEN}  ✅ Full Update Complete!${NC}"
    echo -e "${BOLD}${GREEN}══════════════════════════════════════════════════════${NC}\n"
    
    echo -ne "${BLUE}Press Enter to return...${NC}"
    read
    show_main_menu
}

# ═══════════════════════════════════════════════════════════════
# MAIN ENTRY
# ═══════════════════════════════════════════════════════════════

show_main_menu
