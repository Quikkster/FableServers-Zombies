#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\functions;
#include scripts\zm\utils;
#include scripts\zm\_utility;

init()
{
    setdvar("cc_prefix", "!");
    level thread ChatListener();
}
ChatListener()
{
    while (true) 
    {
        level waittill("say", message, player);

        // player devp( message );

        if (message[0] != GetDvar("cc_prefix")) // For some reason checking for the buggy character doesn't work so we start at the second character if the first isn't the command prefix
        {
            message = GetSubStr(message, 1); // Remove the random/buggy character at index 0, get the real message
        }

        if (message[0] != GetDvar("cc_prefix")) // If the message doesn't start with the command prefix
        {
            continue; // stop
        }

        commandArray = StrTok(message, " "); // Separate the command by space character. Example: ["!map", "mp_dome"]
        command = commandArray[0]; // The command as text. Example: !map
        cmd = GetSubStr(command, 1); // remove "/" or "!" from command 
        args = []; // The arguments passed to the command. Example: ["mp_dome"]
        arg = "";

        for (i = 1; i < commandArray.size; i++)
        {
            checkedArg = commandArray[i];

            if (checkedArg[0] != "'" && arg == "")
            {
                args = AddElementToArray(args, checkedArg);
            }
            else if (checkedArg[0] == "'")
            {
                arg = StrTok(checkedArg, "'")[0] + " ";
            }
            else if (checkedArg[checkedArg.size - 1] == "'")
            {
                args = AddElementToArray(args, (arg + StrTok(checkedArg, "'")[0]));
                arg = "";
            }
            else
            {
                arg += (checkedArg + " ");
            }
        }

        switch(cmd) 
        {
            case "fx":
                player __lookat(level.shootable_biplane.origin);
                break;

            case "test":
                player iPrintLn( "This is a test!" );
                // player iPrintLn( args[0] );
                // player iPrintLn( "next weapon: " + player getnextweapon() );
                // player iPrintLn( "prev weapon: " + player getprevweapon() );
                player iPrintLn( level.canswap );
                player iPrintLn( level.canswap["func"] );
                
                // player thread printreturns();
                break;

            case "plane":
                player spawn_shootable_plane(player);
                break;

            case "gw":
                weapon = args[0];
                player g_weapon( weapon );
                break;

            case "d":
            case "drop":
                player dropWeapon();
                break;

            case "cs":
            case "canswap":
                player dropCanswap();
                break;

            case "cord":
                player iPrintLn( player.origin );
                player iPrintLn( player.angles );
                console( player.name );
                console( player.origin );
                console( player.angles );
                break;

            case "reset":
            case "stuck":
            case "spawn":
                player sendbacktospawn();
                break;

            case "save":
                player _savepos( "dvar", "allbutstance" );
                break;

            case "load":
                player _loadpos( "dvar" );
                break;

            case "clear":
            case "reset":
            case "resetpos":
                player _clearpos( "dvar","all" );
                break;

            default:
                break;
        }
    }
}