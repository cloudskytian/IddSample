certutil -delstore root IndirectDisplay(Test)
certmgr.exe -del -c -n IndirectDisplay(Test) -s root
makecert -b 01/01/2000 -e 01/01/2100 -r -ss root -n CN=IndirectDisplay(Test) IndirectDisplay(Test).cer
certutil -addstore root IndirectDisplay(Test).cer
signtool.exe sign /ac IndirectDisplay(Test).cer /v /s root /n IndirectDisplay(Test) iddsampledriver.cat
pause
