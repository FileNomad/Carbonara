@ECHO OFF

FOR /f %%a IN ('pwsh -NoProfile -Command "Get-CimInstance -ClassName Win32_Processor | Select-Object NumberOfLogicalProcessors"') DO SET CPU_COUNT_MULTIPLIER=%%a
SET FLAGS = -s -f make/main.mk -j%CPU_COUNT_MULTIPLIER%
SET UTILITY = utility %FLAGS%
SET PREPARE = prepare %FLAGS%
SET BUILD = build %FLAGS%

pwsh -NoExit -Command "make %PREPARE% && make %BUILD%"