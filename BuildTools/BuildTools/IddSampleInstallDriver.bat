pnputil /add-driver IddSampleDriver.inf
REG ADD HKEY_CURRENT_USER\SOFTWARE\IddSampleDriver /v Width /t REG_DWORD /d 1920 /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\IddSampleDriver /v Height /t REG_DWORD /d 1080 /f
REG ADD HKEY_CURRENT_USER\SOFTWARE\IddSampleDriver /v VSync /t REG_DWORD /d 60 /f
pause
