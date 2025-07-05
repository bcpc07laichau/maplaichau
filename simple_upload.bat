@echo off
echo ========================================
echo    SIMPLE UPLOAD TO GITHUB
echo ========================================
echo.

:: Hiển thị thư mục hiện tại
echo Thu muc hien tai: %CD%
echo.

:: Kiểm tra Git
if not exist ".git" (
    echo [1/6] Khoi tao Git repository...
    git init
    echo Git repository da duoc khoi tao!
    echo.
)

:: Thiết lập thông tin người dùng
echo [2/6] Thiet lap thong tin nguoi dung...
set /p user_name="Nhap ten cua ban: "
set /p user_email="Nhap email cua ban: "

git config --global user.name "%user_name%"
git config --global user.email "%user_email%"
git config user.name "%user_name%"
git config user.email "%user_email%"

echo Thong tin da duoc thiet lap: %user_name% ^<%user_email%^>
echo.

:: Thiết lập remote origin
echo [3/6] Thiet lap remote origin...
set /p github_user="Nhap GitHub username: "
set /p repo_name="Nhap ten repository: "

echo Dang them remote origin...
git remote add origin https://github.com/%github_user%/%repo_name%.git

echo Kiem tra remote origin:
git remote -v
echo.

:: Kiểm tra repository tồn tại
echo [4/6] Kiem tra repository...
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
echo [5/6] Them file va commit...
git add .
git commit -m "Initial commit"
echo Commit thanh cong!
echo.

:: Xác thực và push
echo [6/6] Xac thuc va push...
echo.
echo LUU Y: Ban can xac thuc voi GitHub!
echo.
echo Cach 1: Personal Access Token (khuyen dung)
echo 1. Vao GitHub.com -^> Settings -^> Developer settings -^> Personal access tokens
echo 2. Generate new token (classic)
echo 3. Chon quyen: repo, workflow
echo 4. Copy token va su dung khi duoc yeu cau
echo.
echo Cach 2: Dang nhap GitHub
echo Git se mo trinh duyet de dang nhap GitHub
echo.
set /p auth_method="Chon cach xac thuc (1=Token, 2=Dang nhap): "

if "%auth_method%"=="1" (
    echo.
    echo Hay chuan bi Personal Access Token...
    set /p ready="Da san sang? (y/n): "
    if /i not "%ready%"=="y" (
        echo Upload bi huy.
        pause
        exit /b 0
    )
    echo Push len GitHub voi token...
    git push origin main
    if errorlevel 1 (
        echo Thu push len branch master...
        git push origin master
    )
) else (
    echo.
    echo Push len GitHub voi dang nhap...
    git push origin main
    if errorlevel 1 (
        echo Thu push len branch master...
        git push origin master
    )
)

if errorlevel 1 (
    echo.
    echo ERROR: Khong the push len GitHub!
    echo.
    echo Nguyen nhan co the la:
    echo 1. Chua xac thuc dung cach
    echo 2. Repository chua duoc tao
    echo 3. Khong co quyen truy cap
    echo.
    echo Hay thu lai voi cach xac thuc khac.
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