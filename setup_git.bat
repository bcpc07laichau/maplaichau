@echo off
echo ========================================
echo    SETUP GIT REPOSITORY
echo ========================================
echo.

:: Kiểm tra xem đã có Git repository chưa
if exist ".git" (
    echo WARNING: Git repository da ton tai!
    echo.
    git status
    echo.
    set /p continue="Ban co muon tiep tuc? (y/n): "
    if /i not "%continue%"=="y" (
        echo Setup bi huy.
        pause
        exit /b 0
    )
)

:: Khởi tạo Git repository
echo [1/4] Khoi tao Git repository...
git init
echo.

:: Thiết lập thông tin người dùng
echo [2/4] Thiet lap thong tin nguoi dung...
set /p user_name="Nhap ten cua ban: "
set /p user_email="Nhap email cua ban: "

git config user.name "%user_name%"
git config user.email "%user_email%"
echo Thong tin nguoi dung da duoc thiet lap!
echo.

:: Tạo file .gitignore cho Flutter
echo [3/4] Tao file .gitignore cho Flutter...
if not exist ".gitignore" (
    echo # Flutter/Dart specific
    echo .dart_tool/
    echo .flutter-plugins
    echo .flutter-plugins-dependencies
    echo .packages
    echo .pub-cache/
    echo .pub/
    echo build/
    echo ios/Pods/
    echo android/.gradle/
    echo android/app/build/
    echo android/build/
    echo android/gradle/
    echo android/local.properties
    echo android/key.properties
    echo *.iml
    echo .idea/
    echo .vscode/
    echo *.log
    echo .DS_Store
    echo Thumbs.db
    echo > .gitignore
    echo File .gitignore da duoc tao!
) else (
    echo File .gitignore da ton tai.
)
echo.

:: Thiết lập remote origin
echo [4/4] Thiet lap remote origin...
set /p setup_remote="Ban co muon thiet lap remote origin? (y/n): "
if /i "%setup_remote%"=="y" (
    set /p github_user="Nhap GitHub username: "
    set /p repo_name="Nhap ten repository: "
    
    echo.
    echo Dang them remote origin: https://github.com/%github_user%/%repo_name%.git
    git remote add origin https://github.com/%github_user%/%repo_name%.git
    echo Remote origin da duoc thiet lap!
) else (
    echo Ban co the thiet lap remote origin sau bang lenh:
    echo git remote add origin ^<your-github-repo-url^>
)

echo.
echo ========================================
echo    SETUP HOAN TAT!
echo ========================================
echo.
echo Git repository da duoc khoi tao thanh cong!
echo.
echo Cac buoc tiep theo:
echo 1. Tao repository tren GitHub (neu chua co)
echo 2. Chay file upload_to_github.bat de tai code
echo.

:: Hiển thị trạng thái
echo Trang thai hien tai:
git status
echo.

pause 