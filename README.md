# Repo Sync - Dual Repository Sync System

A bash automation script for synchronizing code between public and private Git repositories using submodules.

## TL;DR

Ever had a private project you wanted to show off to the public but didn't want to open source the full code? This is the solution! 🎉

This system lets you **showcase** your private project by only displaying `README.md` in the public repo, while the production code stays safe in the private repo. So you can say "hey, I actually built this" without sharing all your secret sauce 😏

But don't worry, some projects do need to stay private - you know, trade secrets and all that 🤫

## Overview

This system enables a dual-repository workflow where:
- **Public Repository** (`my-app.git`): Contains only `README.md` for public viewing
- **Private Repository** (`my-app-private.git`): Contains all production code via a Git submodule

## Directory Structure

```
project-folder/
├── core/              # Git submodule (PRIVATE repo)
│   └── (all production files)
├── README.md          # Public (synced from core/)
├── synch.sh           # Sync script
└── .git/              # Public repo
```

## Features

- ✅ Automatic README synchronization to public repository
- ✅ Production code deployment to private repository
- ✅ Submodule management for clean separation
- ✅ Timestamped commits for tracking
- ✅ Branch-aware synchronization

## Quick Start

### Usage

> **📍 This is your workspace:** The `core/` folder (or whatever you named it) is where you'll work from now on! All your production code, edits, and development happen inside this folder.

1. Edit files directly in the `core/` (or your private folder)
2. Go back to the **public repo root folder** (parent of core/)
3. Run the sync script from there:
   ```bash
   # ❌ DON'T run from inside core/private folder!
   cd core && ./synch.sh    # WRONG!
   
   # ✅ DO run from public repo root
   cd ..
   ./synch.sh               # CORRECT!
   ```
4. Done! Your changes are now synced to both repositories

> **⚠️ Important:** Always run `synch.sh` from the **public repository root folder**, NOT from inside the private/core folder. The script needs to access both the public repo `.git` and the private submodule.

## Setup for New Projects

To use this script in a new project, follow these steps carefully:

### Prerequisites

Before starting, ensure you have:
- SSH keys configured for GitHub access

### Step-by-Step Setup

> **💡 Important Note About Folder Names:**
> 
> The folder name `core` used in examples below is **completely customizable**! You can name it anything that fits your project:
> - `core` - generic name
> - `src` - if it's your source code
> - `private` - to emphasize it's private
> - `production` - for production code
> - `backend`, `frontend`, `app` - whatever makes sense!
> 
> **The key is consistency:** Use the same folder name in:
> 1. `git submodule add <repo-url> <folder-name>`
> 2. `PRIVATE_CORE` variable in `synch.sh`
> 
> Example:
> ```bash
> # If you use 'src' instead of 'core':
> git submodule add git@github.com:your-username/private-repo.git src
> 
> # Then in synch.sh:
> PRIVATE_CORE="$MASKING_DIR/src"
> ```

There are **2 scenarios** - choose yours:

---

#### Scenario A: You Already Have a Private Repo (Want to Showcase It)

If you already have a private repository with code and just want to showcase it publicly:

### 1. Create project folder & init public repo
```bash
mkdir ~/projects/my-awesome-app
cd ~/projects/my-awesome-app
git init
git remote add origin git@github.com:your-username/my-awesome-app.git
```

### 2. Add your existing private repo as submodule

Just add it directly! Name the folder whatever you want:

```bash
git submodule add git@github.com:your-username/existing-private-repo.git core
git submodule update --init --recursive
```

### 3. Create README in the private repo (for showcase)

```bash
cd core
echo "# My Awesome Project - Check this out!" > README.md
git add .
git commit -m "Add README for public showcase"
git push
cd ..
```

**Done!** Continue to Step 5 (Copy sync script).

---

#### Scenario B: Creating Everything from Scratch

If you're starting fresh with no existing repo:

### 1. Create project folder & init public repo
```bash
mkdir ~/projects/my-awesome-app
cd ~/projects/my-awesome-app
git init
git remote add origin git@github.com:your-username/my-awesome-app.git
```

### 2. Create empty private repo on GitHub

Go to GitHub → New Repository → Make it **Private** → Don't initialize with README/.gitignore

### 3. Add the empty private repo as submodule

```bash
git submodule add git@github.com:your-username/my-awesome-app-private.git core
git submodule update --init --recursive
```

### 4. Initialize content inside submodule

```bash
cd core

# Create your production code here
echo "# My Awesome App - Production" > README.md
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main

cd ..
```

### 5. Copy the sync script
```bash
cp /path/to/synch.sh .
chmod +x synch.sh
```

### 6. Edit Configuration

Open `synch.sh` and modify the following variables:

```bash
MASKING_DIR="/home/your-username/projects/my-awesome-app"
PRIVATE_CORE="$MASKING_DIR/core"
PRIVATE_REPO_URL="git@github.com:your-username/my-awesome-app-private.git"
PUBLIC_REPO_URL="git@github.com:your-username/my-awesome-app.git"
```

### 7. Create initial README in core (optional but recommended)
```bash
echo "# My Awesome App" > core/README.md
cd core
git add .
git commit -m "Add README"
git push
cd ..
```

### 8. Commit and push initial setup
```bash
git add .
git commit -m "Initial setup with core submodule"
git push -u origin main
```

### 9. Verify Setup
```bash
# Check submodule status
git submodule status

# Verify core folder is properly linked
ls -la core/
```

## Workflow

```
┌─────────────────────────────────────────────────────────────┐
│                    Edit Files in core/                      │
└─────────────────────────┬───────────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────────┐
│                  Run: ./synch.sh                            │
└─────────────────────────┬───────────────────────────────────┘
                          │
          ┌───────────────┴───────────────┐
          │                               │
          ▼                               ▼
┌─────────────────────┐         ┌─────────────────────┐
│   README.md         │         │   core/             │
│   → Public Repo     │         │   → Private Repo    │
│   (my-app.git)      │         │   (my-app-private)  │
└─────────────────────┘         └─────────────────────┘
```

## Script Steps

| Step | Description | Target |
|------|-------------|--------|
| 0 | Sync README.md to public repo | `my-app.git` |
| 1 | Commit & push production code | `my-app-private.git` |
| 2 | Update submodule reference | Public repo |

## Requirements

- Bash shell
- Git installed and configured
- SSH key setup for GitHub (for push access)
- Proper Git submodule support

## Example Use Cases

This system is useful for:

- **Open Source Projects**: Keep core code private while showing project info publicly
- **Freelance Work**: Separate client-facing documentation from production code
- **SaaS Applications**: Public marketing repo + private codebase
- **Educational Projects**: Public course materials + private solution code

## License

MIT License - Feel free to use and modify for your own projects.

---

**Version:** 1.0
**Author:** UNIXLAB
