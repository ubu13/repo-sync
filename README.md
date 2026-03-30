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

1. Edit files directly in the `core/` folder
2. Run the sync script:
   ```bash
   ./synch.sh
   ```
3. Done! Your changes are now synced to both repositories

## Setup for New Projects

To use this script in a new project, follow these steps carefully:

### Prerequisites

Before starting, ensure you have:
- SSH keys configured for GitHub access

### Step-by-Step Setup

### 1. Create a new project folder
```bash
mkdir ~/projects/my-awesome-app
cd ~/projects/my-awesome-app
```

### 2. Initialize the PUBLIC Git repository
```bash
git init
git remote add origin git@github.com:your-username/my-awesome-app.git
```

### 3. Create and initialize the core folder (PRIVATE repo)

This step creates the private repository from scratch:

```bash
# Create the core folder
mkdir core
cd core

# Initialize it as a separate git repository
git init

# Add your private production repo as remote
git remote add origin git@github.com:your-username/my-awesome-app-private.git

# Create initial commit
echo "# My Awesome App - Production" > README.md
git add .
git commit -m "Initial commit"

# Push to private repo (this creates the repo on GitHub)
git branch -M main
git push -u origin main

# Go back to parent folder
cd ..
```

> **Note:** If the private repository already exists on GitHub, you can skip Step 3 and go directly to Step 4.

### 4. Convert core folder to submodule

Now convert the `core/` folder into a proper Git submodule:

```bash
# Remove the existing core folder (we'll re-add it as submodule)
rm -rf core

# Add the private repo as a submodule
git submodule add git@github.com:your-username/my-awesome-app-private.git core

# Initialize and update submodule
git submodule update --init --recursive
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
