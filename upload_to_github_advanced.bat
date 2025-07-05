@echo off
echo ========================================
echo    UPLOAD TO GITHUB - ADVANCED VERSION
echo ========================================
echo.

:: Kiểm tra xem có phải là Git repository không
if not exist ".git" (
    echo ERROR: Khong tim thay Git repository!
    echo Hay chay 'git init' truoc khi su dung script nay.
    pause
    exit /b 1
)

:: Kiểm tra remote origin hiện tại
echo [1/6] Kiem tra remote origin hien tai...
git remote -v
echo.

:: Hỏi người dùng có muốn thay đổi remote không
set /p change_remote="Ban co muon thay doi remote origin? (y/n): "
if /i "%change_remote%"=="y" (
    echo.
    set /p github_user="Nhap GitHub username: "
    set /p repo_name="Nhap ten repository: "
    set /p branch_name="Nhap ten branch (main/master): "
    if "%branch_name%"=="" set branch_name=main
    
    echo.
    echo Dang them remote origin: https://github.com/%github_user%/%repo_name%.git
    git remote remove origin 2>nul
    git remote add origin https://github.com/%github_user%/%repo_name%.git
    echo Remote origin da duoc cap nhat!
    echo.
)

:: Hiển thị trạng thái hiện tại
echo [2/6] Kiem tra trang thai Git...
git status
echo.

:: Thêm tất cả file vào staging area
echo [3/6] Them tat ca file vao staging area...
git add .
echo.

:: Hiển thị file đã được thêm
echo [4/6] File da duoc them:
git status --porcelain
echo.

:: Nhập commit message
set /p commit_msg="Nhap commit message (hoac nhan Enter de su dung 'Update code'): "
if "%commit_msg%"=="" set commit_msg="Update code"

:: Thực hiện commit
echo [5/6] Thuc hien commit voi message: %commit_msg%
git commit -m %commit_msg%
echo.

:: Kiểm tra xem có remote origin không
git remote -v | findstr origin >nul
if errorlevel 1 (
    echo ERROR: Khong tim thay remote origin!
    echo Hay them remote origin truoc:
    echo git remote add origin <your-github-repo-url>
    pause
    exit /b 1
)

:: Push lên GitHub
echo [6/6] Push len GitHub...
git push origin main
if errorlevel 1 (
    echo Thu push len branch master...
    git push origin master
    if errorlevel 1 (
        echo ERROR: Khong the push len GitHub!
        echo Hay kiem tra:
        echo 1. Ket noi internet
        echo 2. Quyen truy cap repository
        echo 3. Ten branch chinh xac
        echo 4. Xac thuc GitHub (Personal Access Token hoac SSH key)
        pause
        exit /b 1
    )
)

echo.
echo ========================================
echo    UPLOAD THANH CONG!
echo ========================================
echo.
echo Code da duoc tai len GitHub thanh cong!
echo.

:: Hiển thị thông tin repository
echo Thong tin repository:
git remote -v
echo.

:: Hiển thị URL repository
for /f "tokens=2" %%i in ('git remote get-url origin') do set repo_url=%%i
echo Repository URL: %repo_url%
echo.

pause 