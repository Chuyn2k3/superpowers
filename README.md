# Antigravity Superpowers

Antigravity Superpowers is a complete software development methodology explicitly curated for the **Antigravity AI Agent**. This is a specialized fork of the original [Superpowers project](https://github.com/obra/superpowers), heavily optimized to automatically integrate with the Antigravity workflow.

## How it works

When you use Antigravity, these skills load seamlessly into its internal system. 
As soon as the agent sees you're building something, it utilizes these specialized logic paths instead of randomly attempting to write code. 
These skills guide Antigravity through methodical practices like:
- **Systematic Debugging:** Finding root causes rather than patching symptoms.
- **Test-Driven Development:** Strict Red-Green-Refactor cycles.
- **Workflow Planning:** Elaborate planning before execution.

Because the skills are natively supported by the Antigravity skill architecture (`~/.gemini/antigravity/skills`), they trigger automatically. You don't need to do anything special. Your Antigravity AI just has Superpowers.

## Installation

No cloning required. Run a single command on your terminal and you're done. ✨

### 🪟 Windows — PowerShell (One-Liner)

Open **PowerShell** and run:

```powershell
irm https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.ps1 | iex
```

> [!TIP]
> If you get an execution policy error, run this first:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

### 🍎 macOS / Linux — Bash (One-Liner)

Open your **Terminal** and run:

```bash
curl -fsSL https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.sh | bash
```

Both commands will automatically download the latest skills and install them to the correct location. No manual cloning needed.

---

### 📦 Manual Install (after cloning)

If you prefer to clone first:

```bash
# Clone the repo
git clone https://github.com/Chuyn2k3/superpowers.git
cd superpowers

# Windows
.\install.ps1

# macOS / Linux
bash install.sh
```

> [!NOTE]
> **Copy vs Symlink:**
> The installer uses **Copy** (not Symlink) for maximum compatibility. Windows blocks non-admin users from creating symlinks. Your Antigravity agent keeps working even if you delete the downloaded folder.

---

## What's Inside

### Skills Library

**Testing**
- **test-driven-development** - RED-GREEN-REFACTOR cycle (includes testing anti-patterns reference)

**Debugging**
- **systematic-debugging** - 4-phase root cause process (includes root-cause-tracing, defense-in-depth, condition-based-waiting techniques)
- **verification-before-completion** - Ensure it's actually fixed

**Collaboration** 
- **brainstorming** - Socratic design refinement
- **writing-plans** - Detailed implementation plans
- **executing-plans** - Batch execution with checkpoints
- **dispatching-parallel-agents** - Concurrent subagent workflows
- **requesting-code-review** - Pre-review checklist
- **receiving-code-review** - Responding to feedback
- **using-git-worktrees** - Parallel development branches
- **finishing-a-development-branch** - Merge/PR decision workflow
- **subagent-driven-development** - Fast iteration with two-stage review

**Meta**
- **writing-skills** - Create new skills following best practices (includes testing methodology)
- **using-superpowers** - Introduction to the skills system

## Philosophy

- **Test-Driven Development** - Write tests first, always
- **Systematic over ad-hoc** - Process over guessing
- **Complexity reduction** - Simplicity as primary goal
- **Evidence over claims** - Verify before declaring success

## License

MIT License - see LICENSE file for details.
