@echo off
echo ========================================
echo    UPLOAD TO GITHUB - FIXED CONFIG
echo ========================================
echo.

:: Thiết lập thông tin cố định
set GITHUB_USER=bcpc07laichau
set USER_EMAIL=bcpc07laichau@gmail.com

:: Kiểm tra Git
if not exist ".git" (
    echo [1/4] Khoi tao Git repository...
    git init
    echo Git repository da duoc khoi tao!
)

:: Thiết lập thông tin người dùng
echo [2/4] Thiet lap thong tin nguoi dung...
git config --global user.name "%GITHUB_USER%"
git config --global user.email "%USER_EMAIL%"
git config user.name "%GITHUB_USER%"
git config user.email "%USER_EMAIL%"

:: Thiết lập remote origin
echo [3/4] Thiet lap remote origin...
set /p repo_name="Nhap ten repository: "

git remote remove origin 2>nul
git remote add origin https://github.com/%GITHUB_USER%/%repo_name%.git

:: Thêm file và commit
echo [4/4] Them file va commit...
git add . -q
git commit -m "Initial commit" -q

:: Push lên GitHub
echo Push len GitHub...
echo Username: %GITHUB_USER% | Password: [PASTE TOKEN]
git push origin main -q
if errorlevel 1 (
    git push origin master -q
)

if errorlevel 1 (
    echo ERROR: Push that bai! Hay kiem tra token.
    pause
    exit /b 1
)

echo ========================================
echo    UPLOAD THANH CONG!
echo ========================================
echo https://github.com/%GITHUB_USER%/%repo_name%
pause 