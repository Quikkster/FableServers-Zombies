title @FableServers: T6 Zombies Trickshotting [Auto-Installing to Plutonium]
color 04

xcopy /s /e gamesettings "%localappdata%\Plutonium\storage\t6\gamesettings" /y
xcopy /s /e maps\mp\gametypes_zm "%localappdata%\Plutonium\storage\t6\maps\mp\gametypes_zm" /y
xcopy /s /e maps\mp\zombies "%localappdata%\Plutonium\storage\t6\maps\mp\zombies" /y
xcopy /s /e plugins "%localappdata%\Plutonium\storage\t6\plugins" /y
xcopy /s /e scripts\zm "%localappdata%\Plutonium\storage\t6\scripts\zm" /y

cls

color 02
title @FableServers: T6 Zombies Trickshotting [INSTALL COMPLETE!]
echo INSTALL COMPLETE!
pause