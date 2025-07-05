@echo off
echo ========================================
echo    UPLOAD FOLDER TO GITHUB
echo ========================================
echo.

:: Hiển thị thư mục hiện tại
echo Thu muc hien tai: %CD%
echo.

:: Kiểm tra xem có file batch trong thư mục hiện tại không
if not exist "%~nx0" (
    echo ERROR: File batch khong o trong thu muc hien tai!
    echo Hay chay file batch trong thu muc chua file can upload.
    pause
    exit /b 1
)

:: Kiểm tra xem có file nào trong thư mục không (trừ file batch)
dir /b /a-d | findstr /v "%~nx0" >nul
if errorlevel 1 (
    echo ERROR: Thu muc trong! Khong co file nao de upload.
    echo Hay them file vao thu muc truoc khi chay script.
    pause
    exit /b 1
)

echo Cac file trong thu muc:
dir /b /a-d
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
echo Kiem tra remote origin hien tai:
git remote -v
echo.

:: Kiểm tra xem có remote origin không
git remote -v | findstr origin >nul
if errorlevel 1 (
    echo Chua co remote origin, hay nhap thong tin:
    set /p github_user="Nhap GitHub username: "
    set /p repo_name="Nhap ten repository: "
    
    :: Lưu thông tin GitHub vào biến môi trường
    set GITHUB_USER=%github_user%
    set REPO_NAME=%repo_name%
    
    if not "%github_user%"=="" if not "%repo_name%"=="" (
        echo Dang them remote origin: https://github.com/%github_user%/%repo_name%.git
        git remote add origin https://github.com/%github_user%/%repo_name%.git
        
        :: Kiểm tra remote origin đã được thiết lập
        echo Kiem tra remote origin sau khi them:
        git remote -v
        echo.
        
        echo Kiem tra ket noi den GitHub...
        echo Repository URL: https://github.com/%github_user%/%repo_name%
        echo.
        echo LUU Y: Repository phai duoc tao tren GitHub truoc!
        echo Hay vao https://github.com/%github_user%/%repo_name% de kiem tra
        echo.
        set /p repo_exists="Repository da duoc tao tren GitHub? (y/n): "
        if /i not "%repo_exists%"=="y" (
            echo.
            echo Hay tao repository tren GitHub truoc:
            echo 1. Vao https://github.com/new
            echo 2. Dat ten repository: %repo_name%
            echo 3. Chon Public hoac Private
            echo 4. KHONG chon "Initialize with README"
            echo 5. Click "Create repository"
            echo.
            pause
            exit /b 0
        )
        
        :: Kiểm tra lại remote origin sau khi xác nhận
        echo Kiem tra lai remote origin:
        git remote -v
        echo.
        
        :: Test kết nối ngay lập tức
        echo Test ket noi den GitHub...
        git ls-remote origin >nul 2>&1
        if errorlevel 1 (
            echo ERROR: Khong the ket noi den GitHub!
            echo Hay kiem tra repository URL: https://github.com/%github_user%/%repo_name%
            pause
            exit /b 1
        )
        echo Ket noi den GitHub thanh cong!
        echo Remote origin da duoc thiet lap thanh cong!
        echo.
    ) else (
        echo ERROR: Username hoac repository name khong duoc de trong!
        pause
        exit /b 1
    )
) else (
    set /p check_remote="Remote origin da co san. Ban co muon thay doi? (y/n): "
    if /i "%check_remote%"=="y" (
    echo.
    set /p github_user="Nhap GitHub username: "
    set /p repo_name="Nhap ten repository: "
    
    if not "%github_user%"=="" if not "%repo_name%"=="" (
        echo Dang them remote origin: https://github.com/%github_user%/%repo_name%.git
        git remote remove origin 2>nul
        git remote add origin https://github.com/%github_user%/%repo_name%.git
        echo Remote origin da duoc cap nhat!
        
        echo.
        echo Kiem tra ket noi den GitHub...
        echo Repository URL: https://github.com/%github_user%/%repo_name%
        echo Hay dam bao repository da duoc tao tren GitHub!
        echo.
    ) else (
        echo ERROR: Username hoac repository name khong duoc de trong!
        pause
        exit /b 1
    )
) else (
    echo Su dung remote origin hien tai.
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

:: Kiểm tra remote origin trước khi push
echo [5/5] Kiem tra remote origin...
echo.
echo Kiem tra remote origin hien tai:
git remote -v
echo.

:: Kiểm tra xem có remote origin không
git remote -v | findstr origin >nul
if errorlevel 1 (
    echo ERROR: Khong co remote origin!
    echo.
    echo Nguyen nhan co the la:
    echo 1. Script bi dung giua chung
    echo 2. Remote origin chua duoc thiet lap dung
    echo.
    echo Hay chay lai script tu dau.
    pause
    exit /b 1
)

echo Remote origin da duoc thiet lap dung!
echo.

:: Kiểm tra xác thực GitHub
echo Kiem tra xac thuc GitHub...
echo.
echo LUU Y: Ban can xac thuc voi GitHub de push code.
echo Co 2 cach xac thuc:
echo 1. Personal Access Token (khuyen dung)
echo 2. SSH key
echo.
echo Neu chua co Personal Access Token:
echo 1. Vao GitHub.com -^> Settings -^> Developer settings -^> Personal access tokens
echo 2. Generate new token (classic)
echo 3. Chon quyen: repo, workflow
echo 4. Copy token va su dung khi duoc yeu cau
echo.
set /p ready="Ban da san sang push len GitHub? (y/n): "
if /i not "%ready%"=="y" (
    echo Upload bi huy. Hay chuan bi xac thuc truoc khi chay lai.
    pause
    exit /b 0
)

:: Test kết nối đến GitHub
echo Test ket noi den GitHub...
git ls-remote origin >nul 2>&1
if errorlevel 1 (
    echo ERROR: Khong the ket noi den GitHub!
    echo.
    echo Nguyen nhan co the la:
    echo 1. Repository chua duoc tao tren GitHub
    echo 2. Sai username hoac repository name
    echo 3. Khong co quyen truy cap
    echo.
    if defined GITHUB_USER if defined REPO_NAME (
        echo Hay kiem tra: https://github.com/%GITHUB_USER%/%REPO_NAME%
    ) else (
        echo Hay kiem tra repository URL
    )
    pause
    exit /b 1
)
echo Ket noi den GitHub thanh cong!
echo.

:: Push lên GitHub
echo Push len GitHub...
git push origin main
if errorlevel 1 (
    echo Thu push len branch master...
    git push origin master
    if errorlevel 1 (
        echo ERROR: Khong the push len GitHub!
        echo.
        echo Nguyen nhan co the la:
        echo 1. Ket noi internet
        echo 2. Repository chua duoc tao tren GitHub
        echo 3. Quyen truy cap repository
        echo 4. Chua xac thuc GitHub (Personal Access Token hoac SSH key)
        echo 5. Sai username hoac repository name
        echo.
        echo Hay kiem tra:
        echo - Repository URL: https://github.com/[username]/[repository]
        echo - Personal Access Token hoac SSH key
        echo - Quyen truy cap repository
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