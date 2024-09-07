@echo off
setlocal enabledelayedexpansion

:: �R���s���[�^�����擾
set COMPUTER_NAME=%COMPUTERNAME%

:: ���݂̃u�����`�����擾
for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD') do set CURRENT_BRANCH=%%i

:: ���݂̃u�����`�ɃR���s���[�^�����܂܂�Ă���ꍇ�͏I��
echo %CURRENT_BRANCH% | findstr /i "%COMPUTER_NAME%" >nul
if %errorlevel% equ 0 (
    echo ���݂̃u�����`�ɂ̓R���s���[�^�����܂܂�Ă��܂��B�V�����u�����`�͍쐬���܂���B
    exit /b 0
)

:: �R���s���[�^���̃u�����`�������̂��̂Ƃ��Ԃ�Ȃ��悤�Ɋm�F
set BRANCH_NAME=%COMPUTER_NAME%
set INDEX=1

:CHECK_BRANCH
git show-ref --verify --quiet refs/heads/%BRANCH_NAME%
if %errorlevel% equ 0 (
    set BRANCH_NAME=%COMPUTER_NAME%_%INDEX%
    set /a INDEX+=1
    goto :CHECK_BRANCH
)

:: �V�����u�����`���쐬���ă`�F�b�N�A�E�g
git checkout -b %BRANCH_NAME%
if %errorlevel% neq 0 (
    echo �u�����`�̍쐬�܂��͐؂�ւ��Ɏ��s���܂����B
    exit /b 1
)

echo �V�����u�����` %BRANCH_NAME% ���쐬���Đ؂�ւ��܂����B
