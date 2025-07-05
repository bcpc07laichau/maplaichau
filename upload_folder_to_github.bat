@echo off
echo ========================================
echo    UPLOAD FOLDER TO GITHUB
echo ========================================
echo.

:: Kiểm tra xem có phải là Git repository không
if not exist ".git" (
    echo [1/5] Khoi tao Git repository...
    git init
    echo Git repository da duoc khoi tao!
    echo.
)

:: Thiết lập thông tin người dùng
echo [2/5] Thiet lap thong tin nguoi dung...

:: Xóa cấu hình cũ nếu có
echo Xoa cau hinh cu neu co...
git config --global --unset user.name 2>nul
git config --global --unset user.email 2>nul
git config --unset user.name 2>nul
git config --unset user.email 2>nul

echo Nhap thong tin nguoi dung:
set /p user_name="Nhap ten cua ban: "
set /p user_email="Nhap email cua ban: "

if "%user_name%"=="" (
    echo ERROR: Ten khong duoc de trong!
    pause
    exit /b 1
)

if "%user_email%"=="" (
    echo ERROR: Email khong duoc de trong!
    pause
    exit /b 1
)

git config --global user.name "%user_name%"
git config --global user.email "%user_email%"

:: Thiết lập thông tin cho repository hiện tại (local)
git config user.name "%user_name%"
git config user.email "%user_email%"

:: Kiểm tra lại thông tin đã được thiết lập
echo Kiem tra thong tin da duoc thiet lap (global):
git config --global user.name
git config --global user.email
echo.
echo Kiem tra thong tin da duoc thiet lap (local):
git config user.name
git config user.email
echo.

:: Kiểm tra xem thông tin có được thiết lập đúng không
git config user.name | findstr /r "^$" >nul
if not errorlevel 1 (
    echo ERROR: Khong the thiet lap ten nguoi dung!
    pause
    exit /b 1
)

git config user.email | findstr /r "^$" >nul
if not errorlevel 1 (
    echo ERROR: Khong the thiet lap email nguoi dung!
    pause
    exit /b 1
)

echo Thong tin nguoi dung da duoc thiet lap thanh cong!
echo.

:: Thiết lập remote origin
echo [3/5] Thiet lap remote origin...
git remote -v | findstr origin >nul
if errorlevel 1 (
    echo Chua co remote origin, hay nhap thong tin:
    set /p github_user="Nhap GitHub username: "
    set /p repo_name="Nhap ten repository: "
    
    if not "%github_user%"=="" if not "%repo_name%"=="" (
        echo Dang them remote origin: https://github.com/%github_user%/%repo_name%.git
        git remote add origin https://github.com/%github_user%/%repo_name%.git
        echo Remote origin da duoc thiet lap!
    ) else (
        echo ERROR: Username hoac repository name khong duoc de trong!
        pause
        exit /b 1
    )
) else (
    echo Remote origin da co san.
)
echo.

:: Kiểm tra trạng thái hiện tại
echo [4/5] Kiem tra trang thai hien tai...
git status
echo.

:: Thêm tất cả file vào staging area
echo Them tat ca file vao staging area...
git add .

:: Kiểm tra xem có file nào được thêm không
git status --porcelain | findstr "^[AM]" >nul
if errorlevel 1 (
    echo WARNING: Khong co file nao duoc them vao staging area!
    echo.
    echo Nguyen nhan co the la:
    echo 1. Tat ca file da duoc commit truoc do
    echo 2. Khong co file moi hoac thay doi
    echo 3. Thu muc trong hoac chi chua file .git
    echo.
    set /p continue="Ban co muon tiep tuc voi commit rong? (y/n): "
    if /i not "%continue%"=="y" (
        echo.
        set /p create_readme="Ban co muon tao file README.md? (y/n): "
        if /i "%create_readme%"=="y" (
            echo Tao file README.md...
            echo # Upload Folder > README.md
            echo. >> README.md
            echo This folder was uploaded using batch script. >> README.md
            echo Uploaded on: %date% %time% >> README.md
            git add README.md
            echo File README.md da duoc tao va them vao staging area.
        ) else (
            echo Upload bi huy.
            pause
            exit /b 0
        )
    ) else (
        echo Tiep tuc voi commit rong...
    )
) else (
    echo Cac file da duoc them vao staging area.
)
echo.

:: Kiểm tra thông tin người dùng trước khi commit
echo Kiem tra thong tin nguoi dung truoc khi commit:
echo Global config:
git config --global user.name
git config --global user.email
echo.
echo Local config:
git config user.name
git config user.email
echo.

:: Thử commit với thông tin hiện tại
echo Thu commit voi thong tin hien tai...
git commit --allow-empty -m "Test commit" >nul 2>&1
if errorlevel 1 (
    echo ERROR: Khong the commit voi thong tin hien tai!
    echo Hay kiem tra lai thong tin nguoi dung.
    pause
    exit /b 1
)
echo Test commit thanh cong!
git reset --soft HEAD~1 >nul 2>&1
echo.

:: Nhập commit message và thực hiện commit
set /p commit_msg="Nhap commit message (hoac nhan Enter de su dung 'Upload folder'): "
if "%commit_msg%"=="" set commit_msg="Upload folder"

echo Thuc hien commit voi message: %commit_msg%
git commit -m %commit_msg%
if errorlevel 1 (
    echo ERROR: Commit that bai!
    echo.
    echo Nguyen nhan co the la:
    echo 1. Khong co file nao de commit (working tree clean)
    echo 2. Thong tin nguoi dung chua duoc thiet lap dung
    echo.
    echo Thong tin nguoi dung hien tai:
    git config --global user.name
    git config --global user.email
    echo.
    echo Trang thai Git:
    git status
    pause
    exit /b 1
)
echo Commit thanh cong!
echo.

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
        echo 2. Repository da duoc tao tren GitHub
        echo 3. Quyen truy cap repository
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
echo Thu muc da duoc tai len GitHub thanh cong!
echo.

:: Hiển thị thông tin repository
echo Thong tin repository:
git remote -v
echo.

pause 