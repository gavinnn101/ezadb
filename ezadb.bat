@echo off
setlocal enabledelayedexpansion

:: Check if any arguments were provided
if "%1"=="" (
    call :usage
    exit /b 1
)

:: Handle the different commands
if "%1"=="list" (
    call :list
) else if "%1"=="connect" (
    call :connect %2
) else if "%1"=="logs" (
    call :logs %2 %3
) else (
    call :usage
)
exit /b 0

:: Subroutine to print usage instructions
:usage
    echo Usage: ezadb connect [PORT]             - Connects to the device at 127.0.0.1:$port and forwards tcp:61666 for local scripts
    echo        ezadb logs [PORT] [OUTPUT_PATH]  - Prints logs for device at $port and saves them to OUTPUT_PATH or ~/Desktop/ezadb.log if omitted
    echo        ezadb list                       - Lists connected devices. (`adb devices` wrapper)
exit /b 0

:: Subroutine to handle the "list" command
:list
    adb devices
exit /b 0

:: Subroutine to handle the "connect" command
:connect
    call :check_port %1
    if !errorFlag! neq 0 (
        exit /b 1
    )
    set port=%1
    adb disconnect 127.0.0.1:!port!
    adb connect 127.0.0.1:!port!
    adb -s 127.0.0.1:!port! forward tcp:61666 tcp:61666
exit /b 0

:: Subroutine to handle the "logs" command
:logs
    call :check_port %1
    if !errorFlag! neq 0 (
        exit /b 1
    )
    if "%2"=="" (
        set outputPath="%USERPROFILE%\Desktop\ezadb.log"
    ) else (
        set outputPath="%2"
    )
    set outputPathCleaned=%outputPath:"=%
    powershell -Command ^
        "$port = '127.0.0.1:%1';" ^
        "$outputPath = '%outputPathCleaned%';" ^
        "$adbLogcat = & 'adb' -s $port logcat -d;" ^
        "$filters = 'eglCodecCommon', 'EGL_emulation', 'eglMakeCurrent';" ^
        "$filteredLogs = $adbLogcat | Where-Object { $line = $_; $match = $false; $filters | ForEach-Object { if($line -match $_) { $match = $true } }; $match -eq $false };" ^
        "$filteredLogs | Tee-Object -FilePath $outputPath;" ^
        "Start-Process $outputPath"
exit /b 0

:: Subroutine to check for a valid port number
:check_port
    if "%1"=="" (
        echo Missing port number for command
        set errorFlag=1
        exit /b 1
    )
    set errorFlag=0
exit /b 0
