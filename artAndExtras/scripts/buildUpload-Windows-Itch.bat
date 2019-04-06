@echo off
color 0d
cd ..
cd ..
@echo on
lime build windows -release
butler push ./export/release/windows/cpp/bin ninja-muffin24/spirits:win
butler status ninja-muffin24/spirits:win
pause