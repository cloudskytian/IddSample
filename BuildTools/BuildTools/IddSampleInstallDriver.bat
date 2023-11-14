pnputil /add-driver IddSampleDriver.inf
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\IddSampleDriver /v Width /t REG_DWORD /d 1920 /f
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\IddSampleDriver /v Height /t REG_DWORD /d 1080 /f
REG ADD HKEY_LOCAL_MACHINE\SOFTWARE\IddSampleDriver /v VSync /t REG_DWORD /d 60 /f
pause
