@echo off
title Wifi info
color 09
mode 38,20
:: Made by Tekniqas

setlocal enabledelayedexpansion


for /f "tokens=2 delims=:" %%A in ('ipconfig ^| findstr /i "IPv4"') do (
    set IPv4Address=%%A
    echo IPv4 Address: %%A
)

:loop
cls
ping -n 3 8.8.8.8 >%temp%\ping.txt

if not exist %temp%\ping.txt (
    echo Error: Ping results not found.
    timeout /t 5 >nul
    exit /b
)

for /f "tokens=4 delims==, " %%a in ('find "Average" %temp%\ping.txt') do set avgPing=%%a

for /f "tokens=2 delims=, " %%a in ('find "Lost" %temp%\ping.txt') do set ploss=%%a

for /f "tokens=2 delims= " %%b in ('find "Lost" %temp%\ping.txt') do (
    set /a packetsSent=3
    set /a packetsLost=%%b
    set /a packetsReceived=packetsSent-packetsLost
)

echo.
echo -------
echo Ping: %avgPing%
echo -------                                 
echo Packet Loss: %packetsLost% packets lost
echo -------
echo Packets Received: %packetsReceived%
echo -------

timeout /t 2 >nul
goto loop