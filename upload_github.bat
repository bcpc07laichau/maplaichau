@echo off
echo ========================================
echo    UPLOAD TO GITHUB - SIMPLE VERSION
echo ========================================
echo.

:: Hiển thị thư mục hiện tại
echo Thu muc hien tai: %CD%
echo.

:: Kiểm tra Git
if not exist ".git" (
    echo [1/5] Khoi tao Git repository...
    git init
    echo Git repository da duoc khoi tao!
    echo.
)

:: Thiết lập thông tin người dùng
echo [2/5] Thiet lap thong tin nguoi dung...
set /p user_name="Nhap ten cua ban: "
set /p user_email="Nhap email cua ban: "

git config --global user.name "%user_name%"
git config --global user.email "%user_email%"
git config user.name "%user_name%"
git config user.email "%user_email%"

echo Thong tin da duoc thiet lap: %user_name% ^<%user_email%^>
echo.

:: Thiết lập remote origin
echo [3/5] Thiet lap remote origin...
set /p github_user="Nhap GitHub username: "
set /p repo_name="Nhap ten repository: "

echo Dang them remote origin...
git remote remove origin 2>nul
git remote add origin https://github.com/%github_user%/%repo_name%.git

echo Kiem tra remote origin:
git remote -v
echo.

:: Kiểm tra repository tồn tại
echo [4/5] Kiem tra repository...
echo Repository URL: https://github.com/%github_user%/%repo_name%
set /p repo_exists="Repository da duoc tao tren GitHub? (y/n): "
if /i not "%repo_exists%"=="y" (
    echo.
    echo Hay tao repository tren GitHub truoc:
    echo 1. Vao https://github.com/new
    echo 2. Dat ten repository: %repo_name%
    echo 3. KHONG chon "Initialize with README"
    echo 4. Click "Create repository"
    echo.
    pause
    exit /b 0
)

:: Thêm file và commit
echo [5/5] Them file va commit...
git add .
git commit -m "Initial commit"
echo Commit thanh cong!
echo.

:: Push lên GitHub
echo Push len GitHub...
echo.
echo HUONG DAN XAC THUC:
echo 1. Khi Git yeu cau username, nhap: %github_user%
echo 2. Khi Git yeu cau password, nhap: [PASTE TOKEN VAO DAY]
echo.
echo Luu y: Token se khong hien thi khi nhap, do la binh thuong!
echo.
echo Dang push len GitHub...
git push origin main
if errorlevel 1 (
    echo Thu push len branch master...
    git push origin master
)

if errorlevel 1 (
    echo.
    echo ERROR: Khong the push len GitHub!
    echo.
    echo Nguyen nhan co the la:
    echo 1. Chua co Personal Access Token
    echo 2. Token khong dung hoac het han
    echo 3. Repository chua duoc tao
    echo 4. Khong co quyen truy cap
    echo.
    echo Hay tao Personal Access Token:
    echo 1. Vao https://github.com/settings/tokens
    echo 2. Generate new token (classic)
    echo 3. Chon quyen: repo, workflow
    echo 4. Copy token va thu lai
    pause
    exit /b 1
)

echo.
echo ========================================
echo    UPLOAD THANH CONG!
echo ========================================
echo.
echo Code da duoc tai len: https://github.com/%github_user%/%repo_name%
echo.
pause 