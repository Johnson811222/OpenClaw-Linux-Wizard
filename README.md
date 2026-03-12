# OpenClaw Linux Installation Wizard 🐧🚀

**One-click OpenClaw installation for Linux distributions**

## 🚀 Quick Installation

```bash
# One command installation
curl -fsSL https://raw.githubusercontent.com/Johnson811222/OpenClaw-Linux-Wizard/main/install.sh | sudo bash
```

## 📋 Features

- ✅ **One-command setup** - Complete in 15 minutes
- ✅ **Multi-distro support** - Ubuntu, Debian, CentOS, Fedora, Arch
- ✅ **Auto dependency resolution**
- ✅ **Feishu integration** ready
- ✅ **Systemd service** for auto-start
- ✅ **Security hardened** configuration

## 🐧 Supported Systems

- **Ubuntu** 20.04+, 22.04 LTS, 24.04 LTS
- **Debian** 11+, 12+
- **CentOS** 8+, Stream 9
- **Rocky Linux** 8+, 9+
- **Fedora** 34+
- **Arch Linux** latest

## 🔧 Installation Script

The `install.sh` script handles:
1. System detection
2. Dependency installation
3. OpenClaw installation
4. Feishu configuration
5. Service setup
6. Security hardening

## 📊 Post-Installation

```bash
# Check status
sudo systemctl status openclaw

# View logs
sudo journalctl -u openclaw -f

# Health check
./health-check.sh
```

## 📞 Support

- 📖 [OpenClaw Docs](https://docs.openclaw.ai)
- 💬 [Discord](https://discord.gg/clawd)
- 🐛 [Issues](https://github.com/Johnson811222/OpenClaw-Linux-Wizard/issues)

## 📄 License

MIT License

---

**Deploy your AI assistant in minutes!** 🎉

*Created: $(date)*
