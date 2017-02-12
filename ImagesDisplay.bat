@echo off

SET localpath=%~dp0

"C:\Program Files\Processing\processing-java.exe" --sketch="%localpath%\" --output="%localpath%\build" --force --present
