@echo off
color 0d
cd ..
cd ..
@echo on
lime build windows -debug
butler push ./export/debug/windows/bin ninja-muffin24/spirits:win
butler status ninja-muffin24/spirits:win
pause