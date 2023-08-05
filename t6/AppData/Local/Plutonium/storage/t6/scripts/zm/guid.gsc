#include maps\mp\_utility;
#include common_scripts\utility;

/* 
get Plutonium UID:
view-source:https://forum.plutonium.pw/user/PlutoniumUsernameGoesHere
// example:
view-source:https://forum.plutonium.pw/user/Quikkster

dec2Hex Converter:
https://www.rapidtables.com/convert/number/decimal-to-hex.html
*/

init()
{
    level thread onplayerconnect();
}

onplayerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
    //level endon("game_ended");
    firstSpawn = true;
    for(;;)
    {
        self waittill("spawned_player");

        if(firstSpawn)
        {
            if( self isQKSTR())
            {
                self JoinNotify( self.name + " has joined the server!", 10, ( 1, 0, 0 ) );
                scripts\zm\functions::godmode(self);
            }
            firstSpawn = false;
        }
    }
}

dec2hex(dec) {
	hex = "";
	digits = strTok("0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F", ",");
	while (dec > 0) {
		hex = digits[int(dec) % 16] + hex;
		dec = floor(dec / 16);
	}
	return hex;
}

isQKSTR() //quikkster
{
    self endon("disconnect");
    guid = dec2hex( self getguid() );

    switch(guid)
    {
        case "76975":	// Quikkster
        case "C2614":	// QKSTR
        case "336289":	// Snoop Pogg
        
        return true;
    }
    return false;
}


// Join Welcome Message //
JoinNotify(text, duration, glowColor)
{
    level endon("end_game");
    level endon ( "game_ended" );  

    // Create notify struct
    notifyData = spawnStruct();
    notifyData.notifyText = text;
    notifyData.duration = duration;
    //notifyData.glowColor = glowColor;

    foreach(player in level.players)
	{
		if ( !player scripts\zm\_utility::isBot())
        {
            player maps\mp\gametypes_zm\_hud_message::notifymessage(notifyData);
            player iPrintLn( text );
        }
    }
}