#!/usr/bin/env bash
# ============================================================
# 音高检测与对比器 · 一键部署脚本
# 作用：把本目录（deploy）发布到一个固定的 https 网址
# 用法：在 deploy 目录里执行  bash deploy.sh
# ============================================================
set -e
cd "$(dirname "$0")"

echo "=============================================="
echo "  音高检测与对比器 · 一键部署"
echo "=============================================="
echo ""
echo "请选择部署方式（输入数字后回车）："
echo "  1) Surge.sh      —— 无需注册即可用，最快（推荐先用它拿到固定网址）"
echo "  2) Netlify       —— 需要授权登录，全球 CDN，最稳定"
echo "  3) Vercel        —— 需要授权登录"
echo "  4) 只做本地预览  —— 在电脑上开 http://localhost:8000 测试"
echo ""
read -p "请输入 [1-4]: " CHOICE

case "$CHOICE" in
  1)
    echo ""
    echo ">>> 使用 Surge.sh 部署"
    if ! command -v npx >/dev/null 2>&1; then
      echo "❌ 未检测到 Node.js / npx，请先安装 Node：https://nodejs.org"
      exit 1
    fi
    echo "首次运行会要求输入邮箱和密码（用于创建/登录 Surge 账号，免费）。"
    echo "随后会让你确认一个域名，例如 yourname-pitch.surge.sh —— 这个域名就是你的固定网址。"
    echo ""
    npx --yes surge ./
    echo ""
    echo "✅ 部署完成！上面显示的 https://xxxx.surge.sh 就是固定网址，手机可直接打开。"
    echo "   以后每次修改后重跑本命令即可更新同一网址。"
    ;;
  2)
    echo ""
    echo ">>> 使用 Netlify 部署"
    if ! command -v npx >/dev/null 2>&1; then
      echo "❌ 未检测到 Node.js / npx，请先安装 Node：https://nodejs.org"
      exit 1
    fi
    echo "浏览器会打开授权页面，登录后自动完成部署，并给出固定网址。"
    npx --yes netlify-cli deploy --prod --dir ./
    echo ""
    echo "✅ 部署完成！终端里会显示 Site URL，即固定网址。"
    ;;
  3)
    echo ""
    echo ">>> 使用 Vercel 部署"
    if ! command -v npx >/dev/null 2>&1; then
      echo "❌ 未检测到 Node.js / npx，请先安装 Node：https://nodejs.org"
      exit 1
    fi
    npx --yes vercel --prod
    echo ""
    echo "✅ 部署完成！终端里会显示 https 网址。"
    ;;
  4)
    echo ""
    echo ">>> 本地预览：http://localhost:8000"
    echo "按 Ctrl+C 结束。"
    python3 -m http.server 8000 --bind 0.0.0.0
    ;;
  *)
    echo "无效选择，已退出。请重新运行并输入 1-4。"
    exit 1
    ;;
esac
