@echo off
setlocal enabledelayedexpansion

:: コンピュータ名を取得
set COMPUTER_NAME=%COMPUTERNAME%

:: 現在のブランチ名を取得
for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD') do set CURRENT_BRANCH=%%i

:: 現在のブランチにコンピュータ名が含まれている場合は終了
echo %CURRENT_BRANCH% | findstr /i "%COMPUTER_NAME%" >nul
if %errorlevel% equ 0 (
    echo 現在のブランチにはコンピュータ名が含まれています。新しいブランチは作成しません。
    exit /b 0
)

:: コンピュータ名のブランチが既存のものとかぶらないように確認
set BRANCH_NAME=%COMPUTER_NAME%
set INDEX=1

:CHECK_BRANCH
git show-ref --verify --quiet refs/heads/%BRANCH_NAME%
if %errorlevel% equ 0 (
    set BRANCH_NAME=%COMPUTER_NAME%_%INDEX%
    set /a INDEX+=1
    goto :CHECK_BRANCH
)

:: 新しいブランチを作成してチェックアウト
git checkout -b %BRANCH_NAME%
if %errorlevel% neq 0 (
    echo ブランチの作成または切り替えに失敗しました。
    exit /b 1
)

echo 新しいブランチ %BRANCH_NAME% を作成して切り替えました。
