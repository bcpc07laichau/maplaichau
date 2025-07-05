@echo off
echo ========================================
echo    UPLOAD TO GITHUB - FLUTTER PROJECT
echo ========================================
echo.

:: Kiểm tra xem có phải là Git repository không
if not exist ".git" (
    echo ERROR: Khong tim thay Git repository!
    echo Hay chay 'git init' truoc khi su dung script nay.
    pause
    exit /b 1
)

:: Hiển thị trạng thái hiện tại
echo [1/5] Kiem tra trang thai Git...
git status
echo.

:: Thêm tất cả file vào staging area
echo [2/5] Them tat ca file vao staging area...
git add .
echo.

:: Hiển thị file đã được thêm
echo [3/5] File da duoc them:
git status --porcelain
echo.

:: Nhập commit message
set /p commit_msg="Nhap commit message (hoac nhan Enter de su dung 'Update code'): "
if "%commit_msg%"=="" set commit_msg="Update code"

:: Thực hiện commit
echo [4/5] Thuc hien commit voi message: %commit_msg%
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
echo [5/5] Push len GitHub...
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

pause 