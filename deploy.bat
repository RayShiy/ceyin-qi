@echo off
REM ============================================================
REM 音高检测与对比器 · 一键部署（Windows）
REM 用法：双击本文件，或在本目录执行 deploy.bat
REM ============================================================
chcp 65001 >nul
cd /d "%~dp0"

echo ==============================================
echo   音高检测与对比器 · 一键部署
echo ==============================================
echo.
echo 请选择部署方式（输入数字后回车）：
echo   1) Surge.sh    —— 无需注册即可用，最快（推荐）
echo   2) Netlify     —— 需授权登录，最稳定
echo   3) Vercel      —— 需授权登录
echo   4) 本地预览    —— 打开 http://localhost:8000
echo.
set /p CHOICE=请输入 [1-4]: 

if "%CHOICE%"=="1" (
  echo.
  echo ^>^>^> Surge.sh 部署（首次需输入邮箱密码创建账号）
  npx --yes surge ./
  echo.
  echo ✅ 完成后显示的 https://xxxx.surge.sh 即固定网址
) else if "%CHOICE%"=="2" (
  echo.
  echo ^>^>^> Netlify 部署（会打开浏览器授权）
  npx --yes netlify-cli deploy --prod --dir ./
) else if "%CHOICE%"=="3" (
  echo.
  echo ^>^>^> Vercel 部署
  npx --yes vercel --prod
) else if "%CHOICE%"=="4" (
  echo.
  echo ^>^>^> 本地预览 http://localhost:8000 （Ctrl+C 结束）
  python -m http.server 8000
) else (
  echo 无效选择，已退出。
)
pause
