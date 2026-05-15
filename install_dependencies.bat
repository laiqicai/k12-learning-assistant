@echo off
chcp 936 >nul
setlocal
cd /d %~dp0

echo ================================================
echo  新学习助手 · 一键安装依赖
echo ================================================

set "PIP_INDEX="
if /i "%~1"=="official" (
  echo [模式] 官方源 pypi.org
) else (
  echo [模式] 清华源 pypi.tuna.tsinghua.edu.cn
  echo        若想用官方源，请运行：install_dependencies.bat official
  set "PIP_INDEX=-i https://pypi.tuna.tsinghua.edu.cn/simple"
)

where python >nul 2>nul
if errorlevel 1 (
  echo [错误] 没有找到 Python。请先安装 Python 3.10 或更新版本，
  echo        并在安装时勾选 "Add Python to PATH"。
  pause
  exit /b 1
)

if not exist .venv (
  echo [步骤] 创建 Python 虚拟环境 .venv ...
  python -m venv .venv
  if errorlevel 1 (
    echo [错误] 虚拟环境创建失败。
    pause
    exit /b 1
  )
)

call .venv\Scripts\activate.bat

echo [步骤] 升级 pip ...
python -m pip install --upgrade pip %PIP_INDEX%
if errorlevel 1 (
  echo [错误] pip 升级失败。
  pause
  exit /b 1
)

echo [步骤] 安装项目依赖 ...
pip install -r requirements.txt %PIP_INDEX%
if errorlevel 1 (
  echo [错误] 依赖安装失败。可以尝试运行：install_dependencies.bat official
  pause
  exit /b 1
)

echo.
echo [完成] 依赖安装成功。接下来请双击 run.bat 启动项目。
pause
