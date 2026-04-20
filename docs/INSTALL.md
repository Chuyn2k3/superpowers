# 📖 Hướng Dẫn Cài Đặt & Cập Nhật — Antigravity Superpowers

> **Repo:** https://github.com/Chuyn2k3/superpowers

---

## 🚀 Cài Đặt Lần Đầu

Không cần clone repo. Chỉ cần chạy **1 lệnh** trên terminal.

### 🪟 Windows — PowerShell

Mở **PowerShell** (không cần quyền Admin) và chạy:

```powershell
irm https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.ps1 | iex
```

> **Gặp lỗi Execution Policy?** Chạy lệnh này trước, rồi thử lại:
> ```powershell
> Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
> ```

### 🍎 macOS / Linux — Terminal

Mở **Terminal** và chạy:

```bash
curl -fsSL https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.sh | bash
```

> **Không có curl?** Dùng `wget`:
> ```bash
> wget -qO- https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.sh | bash
> ```

---

## 🔄 Cập Nhật Khi Có Bản Mới

Khi repo GitHub được cập nhật, bạn chỉ cần **chạy lại đúng lệnh cũ** — script tự nhận biết đã cài rồi và chuyển sang chế độ **Update**:

### 🪟 Windows

```powershell
irm https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.ps1 | iex
```

### 🍎 macOS / Linux

```bash
curl -fsSL https://raw.githubusercontent.com/Chuyn2k3/superpowers/main/install.sh | bash
```

> Script sẽ hiển thị `🔄 Updating Antigravity Superpowers` thay vì `🚀 Installing`, và cho biết version trước đó đã cài là bao giờ.

---

## 📁 Files Được Cài Vào Đây

| Thư mục | Nội dung |
|---------|---------|
| `~/.gemini/antigravity/skills/` | Tất cả skills (TDD, debug, brainstorm...) |
| `~/.gemini/antigravity/global_workflows/` | Workflow commands (`/sp-plan`, `/sp-code`...) |
| `~/.gemini/antigravity/.superpowers-version` | Timestamp version đã cài |

> **Windows:** Thay `~` bằng `%USERPROFILE%` (thường là `C:\Users\TênBạn`)

---

## 📦 Cài Thủ Công (sau khi clone)

Nếu bạn thích clone repo về local trước:

```bash
git clone https://github.com/Chuyn2k3/superpowers.git
cd superpowers
```

Sau đó chạy installer:

| OS | Lệnh |
|----|------|
| Windows | `.\install.ps1` |
| macOS/Linux | `bash install.sh` |

Để cập nhật sau này khi repo có bản mới:

```bash
# Vào thư mục đã clone
cd superpowers

# Pull xuống bản mới nhất
git pull

# Chạy lại installer (tự động chế độ update)
.\install.ps1          # Windows
bash install.sh        # macOS/Linux
```

---

## ❓ Câu Hỏi Thường Gặp

**Q: Lệnh cài và lệnh update có khác nhau không?**  
A: Không. Cùng 1 lệnh. Script tự nhận biết lần đầu hay đã cài rồi.

**Q: Cập nhật có xóa mất config cũ không?**  
A: Không. Update chỉ ghi đè file skills/workflows với bản mới. Không động đến config khác của Antigravity.

**Q: Cần Git không?**  
A: Không bắt buộc. Nếu không có Git, script tự dùng ZIP download. Nhưng có Git thì nhanh hơn.

**Q: Có thể tự động update định kỳ không?**  
A: Có thể set cron job (Linux/macOS) hoặc Task Scheduler (Windows) để chạy lệnh update tự động theo lịch.

---

## 🔗 Links

- **Repo GitHub:** https://github.com/Chuyn2k3/superpowers
- **Antigravity AI:** https://antigravity.dev
