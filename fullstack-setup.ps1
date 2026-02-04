# -----------------------------------------
# 🚀 FULLSTACK DEV STARTER INSTALLER (X-PLATFORM)
# Windows | macOS | Linux
# -----------------------------------------

# ---------- Helpers ----------
function Test-Command {
    param ($cmd)
    return (Get-Command $cmd -ErrorAction SilentlyContinue)
}

function Install-NpmIfMissing {
    param($pkg)
    if (-not (npm list -g --depth=0 | Select-String $pkg)) {
        Write-Host "➡ Installing npm package: $pkg" -ForegroundColor Yellow
        npm install -g $pkg
    }
    else {
        Write-Host "✅ npm package '$pkg' already installed." -ForegroundColor Gray
    }
}

# ---------- OS Detection ----------
Write-Host "`n🖥️ Detecting OS..." -ForegroundColor Cyan

if ($IsWindows) {
    $OS = "Windows"
}
elseif ($IsMacOS) {
    $OS = "macOS"
}
elseif ($IsLinux) {
    $OS = "Linux"
}
else {
    Write-Error "Unsupported OS"
    exit 1
}

Write-Host "✅ Detected: $OS" -ForegroundColor Green

# ---------- Package Manager ----------
if ($OS -eq "Windows") {
    if (-not (Test-Command winget)) {
        Write-Error "winget is required on Windows."
        exit 1
    }
}
elseif ($OS -eq "macOS") {
    if (-not (Test-Command brew)) {
        Write-Error "Homebrew not found. Install from https://brew.sh"
        exit 1
    }
}
elseif ($OS -eq "Linux") {
    if (-not (Test-Command apt) -and -not (Test-Command dnf) -and -not (Test-Command pacman)) {
        Write-Error "No supported Linux package manager found (apt/dnf/pacman)."
        exit 1
    }
}

# ---------- GitHub CLI ----------
if (-not (Test-Command gh)) {
    Write-Host "➡ Installing GitHub CLI..." -ForegroundColor Yellow
    if ($OS -eq "Windows") { winget install GitHub.cli -e }
    elseif ($OS -eq "macOS") { brew install gh }
    else { sudo apt install gh -y }
}

# ---------- Hugging Face CLI ----------
Write-Host "➡ Installing Hugging Face CLI..." -ForegroundColor Yellow
pip3 install --upgrade huggingface_hub

# ---------- Node.js ----------
if (-not (Test-Command node)) {
    Write-Host "➡ Installing Node.js..." -ForegroundColor Yellow
    if ($OS -eq "Windows") { winget install OpenJS.NodeJS.LTS -e }
    elseif ($OS -eq "macOS") { brew install node }
    else { sudo apt install nodejs npm -y }
}

# ---------- npm global tools ----------
$npmCLIs = @(
    "live-server",
    "nodemon",
    "prettier",
    "eslint",
    "@githubnext/copilot-cli",
    "vercel",
    "firebase-tools",
    "heroku",
    "next",
    "@angular/cli"
)
foreach ($cli in $npmCLIs) {
    Install-NpmIfMissing $cli
}

# ---------- PHP / Composer / Laravel ----------
if (-not (Test-Command php)) {
    Write-Host "➡ Installing PHP..." -ForegroundColor Yellow
    if ($OS -eq "Windows") { winget install PHP.PHP -e }
    elseif ($OS -eq "macOS") { brew install php }
    else { sudo apt install php-cli -y }
}

if (-not (Test-Command composer)) {
    Write-Host "➡ Installing Composer..." -ForegroundColor Yellow
    if ($OS -eq "Windows") { winget install Composer.Composer -e }
    elseif ($OS -eq "macOS") { brew install composer }
    else { sudo apt install composer -y }
}

if (-not (Test-Command laravel)) {
    composer global require laravel/installer
    if ($OS -eq "Windows") {
        $env:PATH += ";$env:APPDATA\Composer\vendor\bin"
    }
    else {
        $env:PATH += ":$HOME/.composer/vendor/bin"
    }
}

# ---------- Docker ----------
if (-not (Test-Command docker)) {
    Write-Host "➡ Installing Docker..." -ForegroundColor Yellow
    if ($OS -eq "Windows") { winget install Docker.DockerDesktop -e }
    elseif ($OS -eq "macOS") { brew install --cask docker }
    else { sudo apt install docker.io -y }
}

# ---------- Database Selection ----------
Write-Host "`n🗄️ Choose a database to install:" -ForegroundColor Cyan
Write-Host "1. PostgreSQL"
Write-Host "2. MySQL"
Write-Host "3. MongoDB"
Write-Host "4. None"

$selection = Read-Host "Select [1/2/3/4]"

switch ($selection) {
    '1' {
        if ($OS -eq "Windows") { winget install PostgreSQL.PostgreSQL -e }
        elseif ($OS -eq "macOS") { brew install postgresql }
        else { sudo apt install postgresql -y }
    }
    '2' {
        if ($OS -eq "Windows") { winget install Oracle.MySQL -e }
        elseif ($OS -eq "macOS") { brew install mysql }
        else { sudo apt install mysql-server -y }
    }
    '3' {
        if ($OS -eq "Windows") { winget install MongoDB.MongoDBCommunity -e }
        elseif ($OS -eq "macOS") { brew tap mongodb/brew; brew install mongodb-community }
        else { sudo apt install mongodb -y }
    }
    Default { Write-Host "🚫 Skipping database install." -ForegroundColor Yellow }
}

# ---------- PowerShell Modules ----------
$psModules = @("PSReadLine", "posh-git", "z")
foreach ($mod in $psModules) {
    if (-not (Get-Module -ListAvailable -Name $mod)) {
        Install-Module $mod -Scope CurrentUser -Force
    }
}

# ---------- Eza ----------
if (-not (Test-Command eza)) {
    Write-Host "➡ Installing eza..." -ForegroundColor Yellow
    if ($OS -eq "Windows") { winget install eza-community.eza -e }
    elseif ($OS -eq "macOS") { brew install eza }
    else { sudo apt install eza -y }
}

# ---------- Oh My Posh ----------
if (-not (Test-Command oh-my-posh)) {
    Write-Host "➡ Installing Oh My Posh..." -ForegroundColor Yellow
    if ($OS -eq "Windows") { winget install JanDeDobbeleer.OhMyPosh -e }
    elseif ($OS -eq "macOS") { brew install jandedobbeleer/oh-my-posh/oh-my-posh }
    else {
        curl -s https://ohmyposh.dev/install.sh | bash
    }
}

# ---------- Extras ----------
$extras = @("tldr", "httpie", "fzf")
foreach ($tool in $extras) {
    if (-not (Test-Command $tool)) {
        if ($OS -eq "Windows") { winget install $tool -e }
        elseif ($OS -eq "macOS") { brew install $tool }
        else { sudo apt install $tool -y }
    }
}

# ---------- Done ----------
Write-Host "`n✅ Fullstack environment ready on $OS!" -ForegroundColor Green
Write-Host "🎨 Load Oh My Posh + Nerd Font in your terminal for icons." -ForegroundColor Cyan
