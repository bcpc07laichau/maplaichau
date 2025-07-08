@echo off
echo ========================================
echo    UPLOAD TO GITHUB - AUTO CONFIG
echo ========================================
echo.

:: Kiểm tra Git
if not exist ".git" (
    echo [1/4] Khoi tao Git repository...
    git init
    echo Git repository da duoc khoi tao!
)

:: Thiết lập thông tin người dùng tự động
echo [2/4] Thiet lap thong tin nguoi dung...
set /p github_user="Nhap GitHub username: "
set /p user_email="Nhap email cua ban: "

git config --global user.name "%github_user%"
git config --global user.email "%user_email%"
git config user.name "%github_user%"
git config user.email "%user_email%"

:: Thiết lập remote origin
echo [3/4] Thiet lap remote origin...
set /p repo_name="Nhap ten repository: "

git remote remove origin 2>nul
git remote add origin https://github.com/%github_user%/%repo_name%.git

:: Thêm file và commit
echo [4/4] Them file va commit...
git add . -q
git commit -m "Initial commit" -q

:: Push lên GitHub
echo Push len GitHub...
echo Username: %github_user% | Password: [PASTE TOKEN]
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
echo https://github.com/%github_user%/%repo_name%
pause 