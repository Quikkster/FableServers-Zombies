#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;

#include scripts\zm\functions;
#include scripts\zm\utils;

init()
{
	level.client = getClient();
}

getClient()
{
    result = "Not valid cod client";
    version = getDvar("version");
    switch( version )
    {
		/* add Redacted into this eventually */

        case "CoD4 MP 19.0 win_minw-x86 Dec 12 2020":
            result = "IW3";
        break;
        case "IW4x (v0.6.1)":
            result = "IW4";
        break;
        case "IW5 MP 1.9 build 388110 Fri Sep 14 00:04:28 2012 win-x86":
            result = "IW5";
        break;
        case "Plutonium T4^7":
            result = "T4";
        break;
         case "Call of Duty Multiplayer - Ship COD_T%_S MP build 7.0.189 CL(1022875) CODPCAB-V64 CEG Wed Nov 02 10:02:23 2011 win-x86 default: ":
            result = "T5";
        break;
        case "Call of Duty Multiplayer - Ship COD_T6_S MP build 1.0.44 CL(1759941) CODPCAB2 CEG Fri May 9 19:19:19 2014 win-x86 813e66d5":
            result = "T6";
        break;
    }

    if( isSubStr(version, "CoD4")) 
        result = "IW3";
    else if( isSubStr(version, "IW4")) 
        result = "IW4"; 
    else if( isSubStr(version, "IW5")) 
        result = "IW5";
    else if( isSubStr(version, "T4")) 
        result = "T4";
    else if( isSubStr(version, "T5")) 
        result = "T5"; 
    else if( isSubStr(version, "T6")) 
        result = "T6"; 

    return result;
}

waitframe()
{
    wait ( 0.05 );
}

generate_random_password( length )
{
    if(!isDefined(length))
        length = 4;

	str = "";
	for ( i = 0; i < length; i++ )
	{
		str = str + randomInt( 10 );
	}
	returnstr;
}

/* 
pin = generate_random_password();
setDvar( "g_password", pin );

players = getPlayers();
for ( i = 0; i < players.size; i++ )
{
    players[ i ] setClientDvar( "password", pin );
            players[ i ] iPrintLn( "Server is now locked use " + pin + " password to rejoin" );
}
*/

bindwait(notif,act)
{
    self notifyOnPlayerCommand(notif + act,act);
    self waittill(notif + act);
    if(act == "+actionslot 2")
    if(self adsButtonPressed())
    wait 0.25;
}

vector_multiply( vec, dif )
{
	vec = ( vec[ 0 ] * dif, vec[ 1 ] * dif, vec[ 2 ] * dif );
	return vec;
}

setdvarifuni(dvar,var) // im lazy
{
    setDvarIfUninitialized(dvar, var);
}

changedamap(map, mode)
{
	if(!isdefined(mode))
		mode = "dsr FableServersSND";

    // exec("devmap " + map);
    setdvar("sv_mapRotation", mode + "devmap " + map);
    setdvar("sv_mapRotationCurrent", mode + "devmap " + map);
}

bracketStr( str, color )
{
	if( !isDefined( str ))
		return;

	if( !isDefined( color )) {
		colors = strtok("0;1;2;3;4;5;6;7;:", ";");
		index = randomint(colors.size);
		color = colors[index];
		// color = ":";
		// color = RandomIntRange(1, 7);
	}

	return "^7[^" + color + str + "^7]";
}

bracketStrSpaced( str, color )
{
	if( !isDefined( str ))
		return;

	if( !isDefined( color )) {
		colors = strtok("0;1;2;3;4;5;6;7;:", ";");
		index = randomint(colors.size);
		color = colors[index];
		// color = ":";
		// color = RandomIntRange(1, 7);
	}
	
	return "^7[^" + color + " " + str + " ^7]";
}

convertStatus( bool )
{
	if( !bool )
	{
		return "^7[^1OFF^7]";
	}
	else
	{
		return "^7[^2ON^7]";
	}
}

docanswap()
{
    x = self getCurrentWeapon();
    x_c = self getWeaponAmmoClip(x);
    x_s = self getWeaponAmmoStock(x);
    akimbo = false;
    self takeWeapon(x);
    waitframe();
    if(isSubStr(x, "akimbo"))
        akimbo = true;
	self giveWeapon(x, self.camo, akimbo);
    self setWeaponAmmoClip(x,x_c);
    self setWeaponAmmoStock(x,x_s);
	self switchToWeapon(x);
}

docanswapt6()
{
    x = self getCurrentWeapon();
    self InitialWeaponRaise(x);
}

smooth(){/* needs to be made for MW3/T6 */}

instashoot()
{
    setDvar("cg_nopredict", 1);
    self disableweapons();
    waitframe();
    self enableweapons();
    wait(0.5);
    setDvar("cg_nopredict", 0);
}

instashoot2()
{
    self setSpawnWeapon(self getCurrentWeapon());
}

CanzoomFunction()
{
    self.canswapWeap = self getCurrentWeapon();
    self takeWeapon(self.canswapWeap);
    self giveweapon(self.canswapWeap);
    wait 0.05;
    self setSpawnWeapon(self.canswapWeap);
}

nacto(weapon)
{
   current = self GetCurrentWeapon();

   self takeweapongood(current);
   self scripts\zm\functions::_g(weapon); /* fix akimbo weapons breaking */
//    self giveweapon(weapon);
   self SwitchToWeapon(weapon);
   waitframe();
   self giveweapongood3(current); /* fix akimbo weapons breaking */
//    self giveweapongood(current);
}

takeweapongood(gun)
{
   self.getgun[gun] = gun;
   self.getclip[gun] =  self GetWeaponAmmoClip(gun);
   self.getstock[gun] = self GetWeaponAmmoStock(gun);
   self takeweapon(gun);
}

// giveweapongood2(gun,camo)
// {
// //    self GiveWeapon(self.getgun[gun],camo,false);
// //    self GiveWeapon(self.getgun[gun],camo,isAkimbo(self.getgun[gun]));
//    self _gcamo(self.getgun[gun],camo,isAkimbo(self.getgun[gun]));
//    self SetWeaponAmmoClip(self.getgun[gun], self.getclip[gun]);
//    self SetWeaponAmmoStock(self.getgun[gun], self.getstock[gun]);
// }

giveweapongood(gun)
{
   self GiveWeapon(self.getgun[gun]);
   self SetWeaponAmmoClip(self.getgun[gun], self.getclip[gun]);
   self SetWeaponAmmoStock(self.getgun[gun], self.getstock[gun]);
}

giveweapongood3(gun)
{
   self scripts\zm\functions::_g(self.getgun[gun]);
   self SetWeaponAmmoClip(self.getgun[gun], self.getclip[gun]);
   self SetWeaponAmmoStock(self.getgun[gun], self.getstock[gun]);
}

giveweapongoodplusone(gun)
{
   self GiveWeapon(self.getgun[gun]);
   self SetWeaponAmmoClip(self.getgun[gun], self.getclip[gun] + 1);
   self SetWeaponAmmoStock(self.getgun[gun], self.getstock[gun] + 1);
}

getnextweapon()
{
   z = self getWeaponsListPrimaries();
   x = self getCurrentWeapon();
   for(i = 0 ; i < z.size ; i++)
   {
      if(x == z[i])
      {
         if(isDefined(z[i + 1]))
            return z[i + 1];
         else
            return z[0];
      }
   }
}

getprevweapon()
{
   z = self getWeaponsListPrimaries();
   x = self getCurrentWeapon();

   for(i = 0 ; i < z.size ; i++)
   {
      if(x == z[i])
      {
         y = i - 1;
         if(y < 0)
            y = z.size - 1;

         if(isDefined(z[y]))
            return z[y];
         else
            return z[0];
      }
   }
}


__canswap(delay, weapon)
{
    if(!isDefined(delay)) 
    {
        if(!isDefined(weapon)) 
        {
			cur = self getcurrentweapon();
            self InitialWeaponRaise(cur);
			// self takeweapongood(cur);
			// self giveweapongood3(cur);
        } 
        else 
        {
			cur = self getcurrentweapon();
			self takeweapongood(cur);
			self giveweapongood3(weapon);
			self switchToWeapon(weapon);
			wait 1;
			self takeweapongood(weapon);
			self switchToWeapon(cur);
        }
    } 
    else 
    {
        wait delay;
        if(!isDefined(weapon)) 
        {
			cur = self getcurrentweapon();
            self InitialWeaponRaise(cur);
			// self takeweapongood(cur);
			// self giveweapongood3(cur);
        } 
        else 
        {
			cur = self getcurrentweapon();
			// self takeweapongood(cur);
			self giveweapongood3(weapon);
			self switchToWeapon(weapon);
			wait 1;
			self takeweapongood(weapon);
			self switchToWeapon(cur);
			// self takeweapongood(weapon);
			// self giveweapongood3(weapon);
        }
    }
}


/* 
nacto(weapon)
{
   current = self GetCurrentWeapon();

   self takeweapongood(current);
   self giveweapon(weapon);
   self SwitchToWeapon(weapon);
   waitframe();
   self giveweapongood(current);
}

takeweapongood(gun)
{
   self.getgun[gun] = gun;
   self.getclip[gun] =  self GetWeaponAmmoClip(gun);
   self.getstock[gun] = self GetWeaponAmmoStock(gun);
   self takeweapon(gun);
}

giveweapongood(gun)
{
   self GiveWeapon(self.getgun[gun]);
   self SetWeaponAmmoClip(self.getgun[gun], self.getclip[gun]);
   self SetWeaponAmmoStock(self.getgun[gun], self.getstock[gun]);
}

getnextweapon()
{
   z = self getWeaponsListPrimaries();
   x = self getCurrentWeapon();
   for(i = 0 ; i < z.size ; i++)
   {
      if(x == z[i])
      {
         if(isDefined(z[i + 1]))
            return z[i + 1];
         else
            return z[0];
      }
   }
}

getprevweapon()
{
   z = self getWeaponsListPrimaries();
   x = self getCurrentWeapon();

   for(i = 0 ; i < z.size ; i++)
   {
      if(x == z[i])
      {
         y = i - 1;
         if(y < 0)
            y = z.size - 1;

         if(isDefined(z[y]))
            return z[y];
         else
            return z[0];
      }
   }
}
*/


isKnife( weapon ) {
	if ( isSubStr( weapon, "knife_" ) ) return true;
	if ( isSubStr( weapon, "knife_held_" ) ) return true;
	if ( isSubStr( weapon, "knife_ballistic" ) ) return true;
	if ( isSubStr( weapon, "bowie_" ) ) return true;
	if ( isSubStr( weapon, "tazer_knuckles" ) ) return true;
	if ( isSubStr( weapon, "javelin" ) ) return true;

	return false;
}

isRocketLauncher( weapon ) 
{

    if ( isSubStr( weapon, "rpg" ) ) return true;
    if ( isSubStr( weapon, "m220_tow_" ) ) return true;
	if ( isSubStr( weapon, "m202_flash_" ) ) return true;
    if ( isSubStr( weapon, "stinger" ) ) return true;
    if ( isSubStr( weapon, "at4" ) ) return true;
    if ( isSubStr( weapon, "javelin" ) ) return true;
   
    if ( isSubStr( weapon, "fhj18" ) ) return true;
    if ( isSubStr( weapon, "m72_law" ) ) return true;
    if ( isSubStr( weapon, "smaw" ) ) return true;

	return false;
}

noobTube( weapon ) 
{
	if ( isSubStr( weapon, "gl_" ) ) return true;
	if ( isSubStr( weapon, "china_lake" ) ) return true;
	if ( isSubStr( weapon, "xm25" ) ) return true;
    if ( isSubStr( weapon, "m79" ) ) return true;

    if( getClient() == "T6")
    {
    	if ( isSubStr( weapon, "m32_" ) ) return true;
    }

	return false;
}

isSemtex( weapon ) {
	if ( isSubStr( weapon, "semtex" ) ) return true;
	if ( isSubStr( weapon, "stickygrenade" ) ) return true;
	if ( isSubStr( weapon, "sticky_grenade" ) ) return true;

	return false;
}

isFrag( weapon ) {
	if ( isSubStr( weapon, "frag_grenade" ) ) return true;

	return false;
}

isTK( weapon ) {
	if ( isSubStr( weapon, "throwingknife" ) ) return true;
	if ( isSubStr( weapon, "throwingknife_rhand" ) ) return true;
	if ( isSubStr( weapon, "hatchet" ) ) return true;
	if ( isSubStr( weapon, "tomahawk" ) ) return true;

	return false;
}

isTacIns( weapon ) {
	if ( isSubStr( weapon, "flare" ) ) return true;
	if ( isSubStr( weapon, "lightstick" ) ) return true;
	if ( isSubStr( weapon, "tactical_insertion" ) ) return true;
	if ( isSubStr( weapon, "specialty_tacticalinsertion" ) ) return true;

	return false;
}

isConcussion( weapon ) {
	if ( isSubStr( weapon, "concussion_grenade" ) ) return true;

	return false;
}

isFlash( weapon ) {
	if ( isSubStr( weapon, "flash_grenade" ) ) return true;

	return false;
}

isShockCharge( weapon ) 
{
    if( getClient() == "T6")
    {
    	if ( isSubStr( weapon, "proximity_grenade" ) && !isSubStr( weapon, "aoe" ) ) return true;
    }

	return false;
}

isBurstWeapon( weapon ) {

    if( getClient() == "IW4")
	{
        if ( isSubStr( weapon, "famas_" ) ) return true;
        if ( isSubStr( weapon, "m16_" ) ) return true;
        if ( isSubStr( weapon, "beretta393_" ) ) return true;
    }

    if( getClient() == "T6")
    {
    	if ( isSubStr( weapon, "xm8_" ) ) return true;
    	if ( isSubStr( weapon, "chicom_" ) ) return true;
    	if ( isSubStr( weapon, "sig556_" ) ) return true;
    	if ( isSubStr( weapon, "beretta93r_" ) ) return true;
    }

	return false;
}

getCustomVariant( weapon ) {
	if ( weapon == "rpg" ) return "rpg2";

	return weapon;
}

hasCustomVariant( weapon ) {
	if ( isSubStr( weapon, "rpg" ) ) return true;

	return false;
}


isAkimbo( weapon ) {

	if ( isSubStr( weapon, "_akimbo" ) ) return true;

    if( getClient() == "T6")
    {
	    if ( isSubStr( weapon, "dw_" ) ) return true;
    }

	return false;
}

canBeAkimbo( weapon )
{
    if( getClient() == "IW4")
    {
        if(isSubStr(weapon, "mp5k")) return true;
        if(isSubStr(weapon, "uzi")) return true;
        if(isSubStr(weapon, "p90")) return true;
        if(isSubStr(weapon, "kriss")) return true;
        if(isSubStr(weapon, "ump45")) return true;
        if(isSubStr(weapon, "deserteagle")) return true;
        if(isSubStr(weapon, "deserteaglegold")) return true;
        if(isSubStr(weapon, "deserteaglegold")) return true;
        if(isSubStr(weapon, "coltanaconda")) return true;
        if(isSubStr(weapon, "usp")) return true;
        if(isSubStr(weapon, "beretta")) return true;
        if(isSubStr(weapon, "beretta393")) return true;
        if(isSubStr(weapon, "pp2000")) return true;
        if(isSubStr(weapon, "glock")) return true;
        if(isSubStr(weapon, "tmp")) return true;
        if(isSubStr(weapon, "ranger")) return true;
        if(isSubStr(weapon, "model1887")) return true;
    }

    if( getClient() == "T6")
    {
        if(isSubStr(weapon, "fiveseven")) return true;
        if(isSubStr(weapon, "beretta93r")) return true;
        if(isSubStr(weapon, "m1911")) return true;
        if(isSubStr(weapon, "judge")) return true;
        if(isSubStr(weapon, "kard")) return true;
        if(isSubStr(weapon, "fnp45")) return true;
    }

	return false;
}



isNade( weapon )
{
    switch ( weapon )
    {
        case "cymbal_monkey":
        
        case "frag_grenade":

        case "throwingknife":
		case "throwingknife_rhand":
		case "hatchet":
		case "tomahawk":

        case "claymore":
        case "bouncingbetty":

        case "trophy":
        case "trophy_system":

        case "specialty_portable_radar":
        case "specialty_scrambler":

        case "semtex":
        case "stickygrenade":
        case "sticky_grenade":

        case "c4":
        case "satchel_charge":
        
        case "smoke_grenade":
        case "willy_pete":

        case "emp_grenade":
        case "flash_grenade":
        case "concussion_grenade":
        case "proximity_grenade_aoe":
        case "proximity_grenade":
        case "sensor_grenade":
        case "pda_hack":

        case "flare":
        case "tactical_insertion":
        case "specialty_tacticalinsertion":
        case "lightstick":

            return 1;

        default:
            return 0;
    }
}


GiveAkimbo()
{
	Weap = self GetCurrentWeapon();
	self TakeWeapon(Weap);
	self GiveWeapon(Weap, 0, true);
}

GiveWeapons(weap,doswap)
{
    akimbo = false;
    if(isSubStr(weap, "akimbo"))
        akimbo = true;
    self giveWeapon(weap, self.camo, akimbo);
    self giveMaxAmmo(weap);
    if(!isDefined(doswap))
    self switchToWeapon(weap);
}

isBot()
{
//    if(isSubStr(self.guid, "bot")) return true;
    if(self is_bot()) return true;
    if (isdefined(self.pers["isBot"]) && self.pers["isBot"]) return true;

    return false;
}

DvarIsInitialized(dvarName)
{
	result = GetDvar(dvarName);
	return result != "";
}

SetDvarIfNotInitialized(dvarName, dvarValue)
{
	if (!DvarIsInitialized(dvarName))
    {
        SetDvar(dvarName, dvarValue);
    }
}

notblank( dvar )
{
	if(getdvar(dvar) == "") return false;
	if(getdvar(dvar) == " ") return false;
	// if(getdvar(dvar) == undefined) return false;

	return true;
}

notblankp( pvar )
{
	if(self getPlayerCustomDvar(pvar) == "") return false;
	if(self getPlayerCustomDvar(pvar) == " ") return false;
	// if(self getPlayerCustomDvar(pvar) == undefined) return false;

	return true;
}

_setClientDvar( dvar, value )
{
	self setClientDvar( dvar, value );
	self devp( "^1DONE" );
}

setPlayerCustomDvar(dvar, value) 
{
	// dvar = self getguid() + "_" + dvar;
	dvar = scripts\zm\guid::dec2hex( self getguid()) + "_" + dvar;
	setDvar(dvar, value);
}

getPlayerCustomDvar(dvar) 
{
	// dvar = self getguid() + "_" + dvar;
	dvar = scripts\zm\guid::dec2hex( self getguid()) + "_" + dvar;
	return getDvar(dvar);
}

AddElementToArray(array, element)
{
    array[array.size] = element;
    return array;
}

//getTL
getTL(){
    return getDvarFloat("scr_" + getDvar("g_gametype") + "_timelimit");
}

/* example:  self doDamage( self, self, self.health+1, 0, "MOD_EXPLOSIVE", "none", self.origin, self.origin, "none" ); */
// __doDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc )
// {
// 	self finishPlayerDamage(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, 0 );
// }


resetPlayerAngles()
{
    self setPlayerAngles(self.angles+(0,0,0));
}

_crosshair_(who)
{
    if(isDefined(who))
    return bulletTrace(who getTagOrigin("j_head"), who getTagOrigin("j_head") + anglesToForward(who getPlayerAngles())*1337, false, who)["position"];
}

__lookat( where )
{
	self setplayerangles(VectorToAngles(((where)) - (self getTagOrigin("j_head"))));
}

gettrace()
{
    x = bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglesToForward(self getplayerangles()) * 1000000, 0, self)["position"];
    return x;
}

getbullettrace()
{
    start = self geteye();
    end = start + anglestoforward(self getplayerangles()) * 1000000;
    x = bullettrace(start, end, false, self)["position"];
    return x;
}

setDvarForAllPlayers( dvar, value )
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
		player setClientDvar( dvar, value );
	}
}

IsMarksmanRifle( sWeapon ) {
    if(isSubStr(sWeapon, "mk14_")) return true;
    if(isSubStr(sWeapon, "m14_")) return true;
    if(isSubStr(sWeapon, "fal_")) return true;
    if(isSubStr(sWeapon, "fnfal_")) return true;
    if(isSubStr(sWeapon, "smr_")) return true;
    if( isSubStr( sWeapon, "saritch_" )) return true; // SMR
    if( isSubStr( sWeapon, "sa58_" )) return true; // FAL
    return false;
}

isSniper( sWeapon ) {
    if(isSubStr(sWeapon, "dsr_")) return true;
    if(isSubStr(sWeapon, "dsr50_")) return true;
    if(isSubStr(sWeapon, "ballista_")) return true;
    if(isSubStr(sWeapon, "barretm82_")) return true;
    if(isSubStr(sWeapon, "svu_")) return true;
    if(isSubStr(sWeapon, "xpr_")) return true;
    if(isSubStr(sWeapon, "xpr50_")) return true;
    return false;
}


IsCustomSniper( sWeapon ) {
    if( sWeapon == "customweaponnamehere" ) return true;
    // if( sWeapon == "" ) return true;
    // if( sWeapon == "" ) return true;
    // if( sWeapon == "" ) return true;
    return false;
}

IsThrowingKnife( sWeapon ) {
    // Throwing Knife
    if(isSubStr(sWeapon, "throwingknife")) return true;
    if(isSubStr(sWeapon, "hatchet")) return true;
    if(isSubStr(sWeapon, "tomahawk")) return true;
    if(isSubStr(sWeapon, "tomahawk")) return true;
    return false;
}

IsRiotShield( sWeapon ) {
    if(sWeapon == "riotshield") return true;
    if(sWeapon == "alcatraz_shield_zm") return true;
    if(sWeapon == "tomb_shield_zm") return true;
    return false;
}

IsCrossbow( weapon )
{
    if(isSubStr(weapon, "crossbow")) return true;

    return false;
}

IsCrossbowNonTriBolt( weapon )
{
    if( isSubStr( weapon, "crossbow_mp" )) return true; // Crossbow
    if( isSubStr( weapon, "crossbow_zm" )) return true; // Crossbow
    if( isSubStr( weapon, "stackfire" )) return false; // Crossbow Tri-Bolt
    if( isSubStr( weapon, "tribolt" )) return false; // Crossbow Tri-Bolt

    return false;
}

IsTriBolt( weapon )
{
    if( isSubStr( weapon, "stackfire" )) return true; // Crossbow Tri-Bolt
    if( isSubStr( weapon, "tribolt" )) return true; // Crossbow Tri-Bolt

    return false;
}

IsBallisticKnife( weapon )
{
    if( isSubStr( weapon, "knife_ballistic" )) return true; // Crossbow

    return false;
}

//sets that custom dvar to all players, not just the person who hit it, this way everyone will know how far the shot was
setDistanceMeterDvar(dt){
	players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(!player isBot())
		player setClientDvar("meters_killed", dt );
	}
}

_setupDistance()
{
    // level waittill("end_killcam");

    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if(!player isBot())
        player thread setupDistance();
        // maps\mp\mod\logging::cmdBox("^1setupDistance ran");
    }
}

setupDistance()
{
    // self waittill( "start_vote" );

	self.distanceLabel = self createFontString( "objective", 1.5 );
	self.distanceLabel setPoint( "TOPCENTER", "TOPCENTER", 0, 0 );
	self.distanceLabel setText( getDvar("meters_killed") );
	self.distanceLabel.alpha = 1;
	self.distanceLabel.showInKillcam = true;
}

hasSavedPosition()
{
    return isDefined(self.pers["mySpawn"]) && isDefined(self.pers["myAngles"]);
}

// sendMessagetoServerVIPs(message, sound)
// {
//     players = level.players;
//     for ( i = 0; i < players.size; i++ )
//     {
//         player = players[i];
// 		if(player scripts\mp\guid::Admin() || player scripts\mp\guid::Host())
// 		{
//     		player iprintln(message);     
			
// 			if(isDefined(sound))
// 			player playsound(sound);
// 		}
// 	}
// }

sendMessagetoServer(message)
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
        if( !IsDefined( player.pers["isBot"] ) || player.pers["isBot"] == false )
        player iprintln(message);     
    }
}

sendBOLDMessagetoServer(message)
{
    players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];	if( !IsDefined( player.pers["isBot"] ) || player.pers["isBot"] == false )
        player iprintlnbold(message);     
    }
}

// Typewriter Message to One Player //
typewriter(text, duration, glowColor, sound)
{
    level endon("end_game");
    level endon ( "game_ended" );  

    // Create notify struct
    notifyData = spawnStruct();
    notifyData.notifyText = text;
    notifyData.duration = duration;
    //notifyData.glowColor = glowColor;

    self maps\mp\gametypes_zm\_hud_message::notifymessage(notifyData);

	if ( isDefined( sound ) )
	self playsound( sound );
}

// Typewriter Message to All //
typewriter_all(text, duration, glowColor, sound)
{
    level endon("end_game");
    level endon ( "game_ended" );  

    // Create notify struct
    notifyData = spawnStruct();
    notifyData.notifyText = text;
    notifyData.duration = duration;
    //notifyData.glowColor = glowColor;

    for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player ) )
	    player maps\mp\gametypes_zm\_hud_message::notifymessage(notifyData);
    
		if ( isDefined( sound ) )
		player playsound( sound );
	}
}

// Typewriter Message to One Player (delayed) //
typewriter_delayed(text, duration, glowColor, sound)
{
    level endon("end_game");
    level endon ( "game_ended" );  

    // Create notify struct
    notifyData = spawnStruct();
    notifyData.notifyText = text;
    notifyData.duration = duration;
    //notifyData.glowColor = glowColor;

	wait 3;
    self maps\mp\gametypes_zm\_hud_message::notifymessage(notifyData);

	if ( isDefined( sound ) )
	self playsound( sound );
}

// Typewriter Message to All (delayed) //
typewriter_all_delayed(text, duration, glowColor, sound)
{
    level endon("end_game");
    level endon ( "game_ended" );  

    // Create notify struct
    notifyData = spawnStruct();
    notifyData.notifyText = text;
    notifyData.duration = duration;
    //notifyData.glowColor = glowColor;

    for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];

		wait 3;
		
		if ( isDefined( player ) )
	    player maps\mp\gametypes_zm\_hud_message::notifymessage(notifyData);
    
		if ( isDefined( sound ) )
		player playsound( sound );
	}
}

//Print To All
printToAll(str)
{
	players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
		player iprintln(str);
	}
}

printboldToAll(str)
{
	players = level.players;
    for ( i = 0; i < players.size; i++ )
    {
        player = players[i];
		player iprintlnbold(str);
	}
}

print_wrapper(msg)
{
    self iPrintLn(msg);
}

print_wrapper_bold(msg)
{
    self iPrintLnBold(msg);
}


convertperk( perk )
{
	perk = toLower( perk );

    if ( perk == "specialty_rof" )
        return "Double Tap";
    else if ( perk == "specialty_fastreload" )
        return "Speed Cola";
    else if ( perk == "specialty_longersprint" )
        return "Staminup";
    else if ( perk == "specialty_armorvest" )
        return "Juggernog";
    else if ( perk == "specialty_deadshot" )
        return "Deadshot";
    else if ( perk == "specialty_scavenger" )
        return "Tombstone";
    else if ( perk == "specialty_additionalprimaryweapon" )
        return "Mule Kick";
    else if ( perk == "specialty_quickrevive" )
        return "Quick Revive";
    else if ( perk == "specialty_nomotionsensor" )
        return "Vulture Aid";
    else if ( perk == "specialty_grenadepulldeath" )
        return "Electric Cherry";
    else if ( perk == "specialty_fastweaponswitch" )
        return "Fast Hands";
    else if ( perk == "specialty_unlimitedsprint" )
        return "Unlimited Sprint";
    else if ( perk == "specialty_fallheight" )
        return "Lightweight";
	else
        return perk;
}

colorNameToStrColor( color )
{
	color = toLower( color );

    if ( color == "white" )
        return "7";
    else if ( color == "random" )
        return ":";
    else if ( color == "red" )
        return "1";
    else if ( color == "orange" )
        return "9";
    else if ( color == "yellow" )
        return "3";
    else if ( color == "green" )
        return "2";
    else if ( color == "lightgreen" )
        return "2";
    else if ( color == "blue" )
        return "4";
    else if ( color == "lightblue" )
        return "5";
    else if ( color == "cyan" )
        return "5";
    else if ( color == "purple" )
        return "6";
    else if ( color == "pink" )
        return "6";
    else if ( color == "brown" )
        return "9";
    else if ( color == "black" )
        return "0";
	else
        return "8";
}

GetColor( color ){
	switch(tolower(color)){
    	case "red":
    		return (0.960, 0.180, 0.180);
    	case "black":
    		return (0, 0, 0);
    	case "purple":
    		return (1, 0.282, 1);
    	case "pink":
    		return  (1, 0.623, 0.811);
    	case "green":
    		return  (0, 0.69, 0.15);
    	case "blue":
    		return  (0, 0, 1);
    	case "lightblue":
    	case "light blue":
    		return  (0.152, 0329, 0.929);
    	case "lightgreen":
    	case "light green":
    		return  (0.09, 1, 0.09);
    	case "orange":
    		return  (1, 0662, 0.035);
    	case "yellow":
    		return (0.968, 0.992, 0.043);
    	case "brown":
    		return (0.501, 0.250, 0);
    	case "cyan":
    		return  (0, 1, 1);
        case "white":
		case "default":
            return;
        case "random":
            Colors = strTok("red,cyan,blue,white,orange,lightgreen,lightblue,pink,green,purple,black", ",");
                result =  GetColor(Colors[RandomInt(Colors.size-1)]); //getColor(RandomInt(Colors.size-1));
                print("Color Random;" + result +"\n");
                return result;
    }
}

destroySlowly( timeout, ent, ent2 )
{
	self endon("death");
	
	wait timeout;
	
	self fadeOverTime(1.0);
	self.alpha = 0;
	
	wait 1.0;

	if(isDefined(ent))
		ent delete();

	if(isDefined(ent2))
		ent2 delete();

	self destroy();
} 


__fontpulseinit( var_0 )
{
    self.baseFontScale = self.fontScale;

    if ( isdefined( var_0 ) )
        self.maxFontScale = min( var_0, 6.3 );
    else
        self.maxFontScale = min( self.fontScale * 2, 6.3 );

    self.inFrames = 2; // 1.5
    self.outFrames = 4; // 3
}

createEventPopup()
{
	hud_EventPopup = newClientHudElem( self );
	hud_EventPopup.children = [];		
	hud_EventPopup.horzAlign = "center";
	hud_EventPopup.vertAlign = "middle";
	hud_EventPopup.alignX = "center";
	hud_EventPopup.alignY = "middle";

    if(isDefined(hud_EventPopup.x_offset))
        hud_EventPopup.x = 50 + hud_EventPopup.x_offset;
    else
        hud_EventPopup.x = 50;

    if(isDefined(hud_EventPopup.y_offset))
        hud_EventPopup.y = -35 + hud_EventPopup.y_offset;
    else
        hud_EventPopup.y = -35;

	hud_EventPopup.font = "default";
	hud_EventPopup.fontscale = 1;
	// hud_EventPopup.fontscale = 0;
	hud_EventPopup.archived = false;
	hud_EventPopup.color = (0.5,0.5,0.5);
	hud_EventPopup.sort = 10000;
	hud_EventPopup.elemType = "font"; //msgText
	hud_EventPopup __fontpulseinit( 3.0 );
	// hud_EventPopup maps\mp\gametypes_zm\_hud::fontPulseInit( 3.0 );
	// hud_EventPopup maps\mp\gametypes_zm\_hud::fontpulse( self );

	return hud_EventPopup;
}

EventPopup( event, hudColor, glowAlpha, y_offset, x_offset )
{
	self endon( "disconnect" );

	self notify( "EventPopup" );
	self endon( "EventPopup" );

	wait ( 0.05 );
		
	if ( !isDefined( hudColor ) )
		hudColor = (1,1,0.5);
    if ( !isDefined( y_offset ) )
		y_offset = 0;
	if ( !isDefined( glowAlpha ) )
		glowAlpha = 0;

	self.hud_EventPopup.color = hudColor;
	self.hud_EventPopup.glowColor = hudColor;
	self.hud_EventPopup.glowAlpha = glowAlpha;
	self.hud_EventPopup.y_offset = y_offset;
	self.hud_EventPopup.x_offset = x_offset;

	self.hud_EventPopup setText(event);
	self.hud_EventPopup.alpha = 0.85;

	wait ( 1.0 );
	
	self.hud_EventPopup fadeOverTime( 0.75 );
	self.hud_EventPopup.alpha = 0;
}


createEventPopup2()
{
	hud_EventPopup2 = newClientHudElem( self );
	hud_EventPopup2.children = [];		
	hud_EventPopup2.horzAlign = "center";
	hud_EventPopup2.vertAlign = "middle";
	hud_EventPopup2.alignX = "left";
	hud_EventPopup2.alignY = "middle";

    if(isDefined(hud_EventPopup2.x_offset))
        hud_EventPopup2.x = 60 + hud_EventPopup2.x_offset;
    else
        hud_EventPopup2.x = 60;

    if(isDefined(hud_EventPopup2.y_offset))
        hud_EventPopup2.y = -25 + hud_EventPopup2.y_offset;
    else
        hud_EventPopup2.y = -25;

	hud_EventPopup2.font = "default";
	hud_EventPopup2.fontscale = 1;
	// hud_EventPopup2.fontscale = 0;
	hud_EventPopup2.archived = false;
	hud_EventPopup2.color = (0.5,0.5,0.5);
	hud_EventPopup2.sort = 10000;
	hud_EventPopup2.elemType = "font"; //msgText
	hud_EventPopup2 __fontpulseinit( 3.0 );
	// hud_EventPopup2 maps\mp\gametypes_zm\_hud::fontPulseInit( 3.0 );
	// hud_EventPopup2 maps\mp\gametypes_zm\_hud::fontpulse( self );

	return hud_EventPopup2;
}

EventPopup2( event, hudColor, glowAlpha, y_offset, x_offset )
{
	self endon( "disconnect" );

	self notify( "EventPopup2" );
	self endon( "EventPopup2" );

	wait ( 0.05 );
		
	if ( !isDefined( hudColor ) )
		hudColor = (1,1,0.5);
    if ( !isDefined( y_offset ) )
		y_offset = 0;
	if ( !isDefined( glowAlpha ) )
		glowAlpha = 0;

	self.hud_EventPopup2.color = hudColor;
	self.hud_EventPopup2.glowColor = hudColor;
	self.hud_EventPopup2.glowAlpha = glowAlpha;
	self.hud_EventPopup2.y_offset = y_offset;
	self.hud_EventPopup.x_offset = x_offset;

	self.hud_EventPopup2 setText(event);
	self.hud_EventPopup2.alpha = 0.85;

	wait ( 1.0 );
	
	self.hud_EventPopup2 fadeOverTime( 0.75 );
	self.hud_EventPopup2.alpha = 0;
}

fadeToBlack( startwait, blackscreenwait, fadeintime, fadeouttime )
{
    wait( startwait );
    if( !isdefined(self.blackscreen) )
    self.blackscreen = newclienthudelem( self );

    self.blackscreen.x = 0;
    self.blackscreen.y = 0; 
    self.blackscreen.horzAlign = "fullscreen";
    self.blackscreen.vertAlign = "fullscreen";
    self.blackscreen.foreground = false;
    self.blackscreen.hidewhendead = false;
    self.blackscreen.hidewheninmenu = true;

    self.blackscreen.sort = 50; 
    self.blackscreen SetShader( "black", 640, 480 ); 
    self.blackscreen.alpha = 0; 
    if( fadeintime>0 )
    self.blackscreen FadeOverTime( fadeintime ); 
    self.blackscreen.alpha = 1;
    // self setclientuivisibilityflag( "hud_visible", 0 );
    wait( fadeintime );
    if( !isdefined(self.blackscreen) )
        return;

    wait( blackscreenwait );
    if( !isdefined(self.blackscreen) )
        return;

    if( fadeouttime>0 )
    self.blackscreen FadeOverTime( fadeouttime ); 
    self.blackscreen.alpha = 0; 
    wait( fadeouttime );

    // self setclientuivisibilityflag( "hud_visible", 1 );
    if( isdefined(self.blackscreen) )			
    {
        self.blackscreen destroy();
        self.blackscreen = undefined;
    }
}

fadeToWhite( startwait, whitescreenwait, fadeintime, fadeouttime )
{
    wait( startwait );
    if( !isdefined(self.whitescreen) )
    self.whitescreen = newclienthudelem( self );
    self.whitescreen.x = 0;
    self.whitescreen.y = 0; 
    self.whitescreen.horzAlign = "fullscreen";
    self.whitescreen.vertAlign = "fullscreen";
    self.whitescreen.foreground = false;
    self.whitescreen.hidewhendead = false;
    self.whitescreen.hidewheninmenu = true;
    self.whitescreen.sort = 50; 
    self.whitescreen SetShader( "tow_filter_overlay_no_signal", 640, 480 ); 
    self.whitescreen.alpha = 0; 

    if( fadeintime > 0 )
    self.whitescreen FadeOverTime( fadeintime ); 
    self.whitescreen.alpha = 1; 
    // self setclientuivisibilityflag( "hud_visible", 0 );
    wait( fadeintime );
    if( !isdefined(self.whitescreen) )
        return;	

    wait( whitescreenwait );
    if( !isdefined(self.whitescreen) )
        return;

    if( fadeouttime>0 )
    self.whitescreen FadeOverTime( fadeouttime ); 
    self.whitescreen.alpha = 0; 
    wait( fadeouttime );

    // self setclientuivisibilityflag( "hud_visible", 1 );
    if( isdefined(self.whitescreen) )			
    {
        self.whitescreen destroy();
        self.whitescreen = undefined;
    }
}

devp(str)
{
	if(level.devprintsenabled && self isHost())
		self iPrintLn(str);
}

devpb(str)
{
	if(level.devprintsenabled && self isHost())
		self iPrintLnBold(str);
}

model(Location, model)
{
	Mod = spawn("script_model",Location);
	Mod setModel(model);
	Mod Solid();
}
