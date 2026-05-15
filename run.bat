@echo off
chcp 936 >nul
setlocal
cd /d %~dp0

echo ================================================
echo  新学习助手 · DeepSeek V4 Flash · 简洁界面版
echo ================================================

where python >nul 2>nul
if errorlevel 1 (
  echo [错误] 没有找到 Python。请先安装 Python 3.10 或更新版本，
  echo        并在安装时勾选 "Add Python to PATH"。
  pause
  exit /b 1
)

REM ---------- .env 处理（不再向旧 .env 追加模板内容）----------
if not exist .env (
  if not exist .env.example (
    echo [错误] 缺少 .env.example 模板文件，请检查代码包是否完整。
    pause
    exit /b 1
  )
  echo [提示] 当前没有 .env，从 .env.example 复制一份。
  copy .env.example .env >nul
  echo.
  echo [重要] 请先在 .env 里把 DEEPSEEK_API_KEY 改成你的真实 Key，
  echo        保存后再重新运行本脚本。
  notepad .env
  pause
  exit /b 0
)

REM 检查 KEY 是否还是占位符
findstr /C:"DEEPSEEK_API_KEY=请填写" .env >nul 2>nul
if not errorlevel 1 (
  echo [重要] 请先把 .env 里的 DEEPSEEK_API_KEY 改成你的真实 Key，
  echo        保存后再次运行本脚本。
  notepad .env
  pause
  exit /b 0
)

REM 检查 KEY 行是否存在
findstr /B /C:"DEEPSEEK_API_KEY=" .env >nul 2>nul
if errorlevel 1 (
  echo [重要] 你的 .env 里没有 DEEPSEEK_API_KEY 这一行。
  echo        请在 .env 中加一行：DEEPSEEK_API_KEY=你的Key
  notepad .env
  pause
  exit /b 0
)

REM ---------- 依赖环境 ----------
if not exist .venv (
  echo [提示] 没有检测到 .venv 依赖环境。
  echo [操作] 即将自动执行一键安装依赖（默认清华源）。
  call install_dependencies.bat
  if errorlevel 1 (
    echo [错误] 依赖安装失败，请检查网络后重试。
    pause
    exit /b 1
  )
)

call .venv\Scripts\activate.bat

echo.
echo [启动] 正在启动服务...
echo 本机访问  ：http://localhost:8000
echo 局域网访问：http://教师机IP:8000   （cmd 中 ipconfig 查 IP）
echo.

uvicorn main:app --host 0.0.0.0 --port 8000
pause
