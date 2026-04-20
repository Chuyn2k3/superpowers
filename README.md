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

## Installation & Update

> 📖 **Full guide:** [docs/INSTALL.md](docs/INSTALL.md)

No cloning required! You only need to run a **single command** to install the project. You can run the **exact same command** again anytime to update your local skills if this GitHub repository releases an update.

### 🪟 Windows — PowerShell

```powershell
irm https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.ps1 | iex
```

> [!TIP]
> If you get an execution policy error, run this first:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

### 🍎 macOS / Linux — Bash

```bash
curl -fsSL https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.sh | bash
```

### 🔄 Updating to the Latest Version

**Same command, same terminal.** The installer automatically detects whether this is a fresh install or an update:

| State | What happens |
|-------|-------------|
| First time | `🚀 Installing...` — copies all skills |
| Already installed | `🔄 Updating...` — shows previous version, replaces with latest |

No extra flags, no extra steps. Just run the same command whenever you want to pull the latest changes.

---

### 📦 Manual Install/Update (after cloning)

If you prefer to keep a local clone:

```bash
git clone https://github.com/Chuyn2k3/superpowers.git
cd superpowers

.\install.ps1     # Windows
bash install.sh   # macOS/Linux
```

To update when the repo changes:

```bash
cd superpowers
git pull
.\install.ps1     # Windows
bash install.sh   # macOS/Linux
```

> [!NOTE]
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

Dựa trên triết lý của hệ thống Superpowers mà bạn vừa xem qua, quy trình làm việc (workflow) chuẩn của một "Dev" thực thụ không chỉ là gõ code ngay lập tức. Để tối ưu hiệu suất và giảm thiểu lỗi, bạn nên áp dụng các lệnh/kỹ năng theo thứ tự sau:

1. Giai đoạn Lập kế hoạch (Planning)
Đừng bắt tay vào code ngay khi vừa nhận yêu cầu. Hãy dùng các kỹ năng lập kế hoạch trước.

writing-plans: Viết ra một kế hoạch triển khai chi tiết. Bạn cần xác định mình sẽ sửa file nào, logic thay đổi ra sao.

brainstorming: Nếu yêu cầu khó hoặc mơ hồ, hãy dùng kỹ năng này để phản biện và làm rõ các góc khuất của thiết kế trước khi thực hiện.

2. Giai đoạn Triển khai (TDD & Execution)
Đây là lúc áp dụng tư duy "Kiểm thử trước, Code sau".

test-driven-development (TDD):

Red: Viết một bản kiểm thử (test) cho tính năng mới (lúc này test sẽ báo lỗi vì chưa có code).

Green: Viết mã nguồn vừa đủ để test đó vượt qua.

Refactor: Tối ưu hóa lại mã nguồn cho sạch đẹp nhưng vẫn đảm bảo test vượt qua.

executing-plans: Thực hiện kế hoạch đã lập ở bước 1 theo từng lô (batch) nhỏ. Sau mỗi lô, hãy dừng lại kiểm tra (checkpoint) để đảm bảo không đi chệch hướng.

3. Giai đoạn Kiểm tra & Gỡ lỗi (Verification & Debugging)
Nếu trong quá trình code mà phát sinh lỗi ngoài dự kiến:

systematic-debugging: Đừng đoán mò. Hãy dùng quy trình 4 bước để tìm nguyên nhân gốc rễ (root cause).

verification-before-completion: Khi bạn nghĩ mình đã sửa xong lỗi, hãy dùng kỹ năng này để xác minh lại một lần nữa bằng các kịch bản kiểm thử thực tế. Đừng vội tin vào cảm giác của mình.

4. Giai đoạn Hoàn tất & Review (Finishing)
Trước khi đẩy code (commit/push) lên hệ thống:

requesting-code-review: Tự kiểm tra lại danh sách (checklist) trước khi nhờ người khác review. Điều này giúp bạn chuyên nghiệp hơn và giảm bớt các lỗi ngớ ngẩn.

finishing-a-development-branch: Đưa ra quyết định cuối cùng về việc gộp nhánh (merge) hoặc tạo Pull Request (PR) để đưa code vào nhánh chính.

Tóm tắt thứ tự ưu tiên:
Plan (Kế hoạch) ➔ Test (Kiểm thử) ➔ Code (Triển khai) ➔ Verify (Xác minh)

Cách tiếp cận này giúp bạn tránh được tình trạng "Code xong rồi mới thấy sai kiến trúc" hoặc "Sửa được lỗi này thì lại đẻ ra lỗi kia".