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

Installing Antigravity Superpowers is incredibly simple. You do not need to configure anything manually. Just use one of the supplied installation scripts below depending on your operating system.

### Option 1: Windows (PowerShell or Batch)

Double click the **`install.bat`** file, or right-click **`install.ps1`** and select "Run with PowerShell". 
The script will automatically allocate and copy the skills to `%USERPROFILE%\.gemini\antigravity\skills`.

### Option 2: MacOS / Linux

Open your Terminal, navigate to the project directory, and run the shell script:
```bash
sh install.sh
```
This automatically allocates and copies the skills to `~/.gemini/antigravity/skills`.

> [!NOTE]
> **Difference between Copy vs Symlink:**
> These installation scripts use **Copy** by default instead of **Symlink**. This ensures maximum compatibility (Windows natively blocks local users from creating Symlinks) and guarantees your Antigravity agent will not lose access to the files if you move or delete this downloaded folder.

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
