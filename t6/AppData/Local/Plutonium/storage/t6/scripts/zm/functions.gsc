#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\gametypes_zm\_rank;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_persistence;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\binds;
#include scripts\zm\killcam;
#include scripts\zm\utils;
#include scripts\zm\_utility;

printreturns()
{
    self endon( "disconnect" );

    for(;;)
    {
    	// event = self common_scripts\utility::waittill_any_return( "grenade_fire", "grenade_pullback", "weapon_fired", "weapon_change", "riotshield_planted", "destroy_riotshield" );
    	event = self common_scripts\utility::waittill_any_return( "grenade_fire", "grenade_pullback");
        self iPrintLn( event );
    }
}

valueType( value )
{
    if(!isDefined(value))
        return;
    
    if( isstring( value ) )
    {
        return "string";
    }
    if( isint( value ) )
    {
        return "int";
    }
    if( isfloat( value ) )
    {
        return "float";
    }
    if( isarray( value ) )
    {
        return "array";
    }
    if( isvec( value ) )
    {
        return "vec";
    }

    return value;
}



test()
{
    self iPrintLn( self.status ); 
    iPrintLn("This is a test!"); 
    self playLocalSound("zmb_cha_ching");

    self.lives = 99;

    // self iPrintLn(valueType(level.bindlist));

    // self fastlast();

    // self iPrintLn( self.pers["canswap"] );
    // self iPrintLn( self.pers["canswap"] + " value type? " + valueType( self.pers["canswap"] ) );
    // self iPrintLn( self.pers["teststring"] );
    // self iPrintLn( self.pers["teststring"] + " value type? " + valueType( self.pers["teststring"] ) );


    // self.perkhudelem.alpha = 0;
    // foreach(perk in level._random_perk_machine_perk_list)
    // {            
    //     self.perk_hud[ perk ].alpha = 0.00001;
    //     self.perk_hud[ perk ] destroy_hud();
    //     self iPrintLn( perk );
    // }
    // foreach(perk in level.perkslist)
    // {            
    //     self.perk_hud[ perk ].alpha = 0.00001;
    //     self.perk_hud[ perk ] destroy_hud();
    //     self iPrintLn( perk );
    // }

    // self maps\mp\zombies\_zm_perks::update_perk_hud();

    // intercom( "mus_fire_sale_rich" );

    // self setorigin( ( 359.823, 90.3713, 0.542009 ) );
    // intercom( "mus_fire_sale" );

    // level thread maps\mp\zombies\_zm_powerups::start_fire_sale( self );
    // iPrintLn(level.canswapWeapons.size); 

    // self setOrigin(level.random_perk_start_machine.origin);
    // self EventPopup( "+50", game["colors"]["white"] );
    // self EventPopup2( "Zombie Elimination", game["colors"]["yellow"], 0, -20, 75 );

    // self setmodel( "c_zom_player_zombie_fb" );
    // self setviewmodel( "c_zom_zombie_viewhands" );
    // self takeAllWeapons();
    // self g_weapon( "zombiemelee_dw" );
    // self switchToWeapon( "zombiemelee_dw" );
}

__jumpscare( who )
{
    who notify( "get_jump_scared_dumbass" );
}

weaponfinder()
{
    self iPrintLn(self getCurrentWeapon());
    baseweapon = maps\mp\zombies\_zm_weapons::get_base_name(self getcurrentweapon());
    baseweapon2 = maps\mp\zombies\_zm_weapons::get_base_weapon_name(self getcurrentweapon(), 1);
    self iPrintLn(baseweapon);
    self iPrintLn(baseweapon2);
    self iPrintLn(weapname(self getcurrentweapon()));
}


play_intercom_sound( sound )
{
    if(!isDefined(sound))
        return;

    self playloopsound( sound );
	level waittill( "stop_intercom_" + sound );
	self stoploopsound();
}

intercom( sound, duration )
{
    if(!isDefined(sound))
        return;
        
    if(!isDefined(duration))
        duration = 10;

	intercom = getentarray( "intercom", "targetname" );
    i = 0;
    while ( i < intercom.size )
    {
        intercom[ i ] thread play_intercom_sound( sound );
        i++;
    }
    if( sound == "mus_fire_sale_rich" )
    {
        wait 11.1; // perfect timing
    }
    else
    {
        wait duration;
    }
	level notify( "stop_intercom_" + sound );
} 

___tp( o )
{
    self setOrigin( o );
}

teleportToBus()
{
   self setOrigin(level.the_bus localToWorldCoords((0, 0, 25)));
}


SpawnPanzer()
{
    level.mechz_left_to_spawn++;
    level notify( "spawn_mechz" );
    iPrintLn("^1Panzer ^7has been spawned in by " + self.name);
}

SpawnBrutus()
{
    level notify( "spawn_brutus", 1 );
	iPrintLn("^1Brutus ^7has been spawned in by " + self.name);
}
        


neverlosemeleeloop()
{
    self endon("stopneverlosemeleeloop");
	for(;;)
    {
        if ( !self hasweapon( "knife_zm" ) && !self hasweapon( "zombiemelee_dw" ) && !self hasweapon( "zombiemelee_zm" ) && !self hasweapon( "bowie_knife_zm" ) && !self hasweapon( "sickle_knife_zm" ) && !self hasweapon( "tazer_knuckles_zm" ) && !self hasweapon( "tazer_knuckles_upgraded_zm" ) && !self hasweapon( "zombie_fists_zm" ) && !self hasweapon( "one_inch_punch_air_zm" ) && !self hasweapon( "one_inch_punch_zm" ) && !self hasweapon( "one_inch_punch_upgraded_zm" ) && !self hasweapon( "one_inch_punch_lightning_zm" ) && !self hasweapon( "one_inch_punch_ice_zm" ) && !self hasweapon( "one_inch_punch_fire_zm" ) )
        {
            if( !self.flourish )
            {
                self giveweapon( "knife_zm" );
                self devp( "combat knife given, you had no melee weapon!" );
            }
        }
		wait 1;
    }
}

neverlosequickrevivemachineloop()
{
    // self endon("stopneverlosequickrevivemachineloop");
	// for(;;)
    // {
    //     level.solo_lives_given = 0;
	// 	wait 1;
    // }
}

//Laugh for All Players
play_crazi_sound()
{
	self playlocalsound( level.zmb_laugh_alias );
}

zombies()
{
	level endon("end_game");
	self endon("disconnect");
	for(;;)
	{
		level waittill("start_of_round");
		if(level.zombie_health > 10000)
		{
			level.zombie_health = 10000;
		}
		wait 0.05;
	}
}

expickup(num)
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    setDvar("player_useRadius", num);
    setDvar("player_useRadius_zm", num);
    self iprintln("Pickup Radius: ^2" + num);
}

grenaderadius(num)
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    setdvar( "player_throwbackOuterRadius",num);
    setdvar( "player_throwbackInnerRadius",num);
    self iPrintln("Grenade Radius: ^2" + num);
} 

reviveradius(num)
{
    self endon( "disconnect" );
    level endon( "game_ended" );
    setdvar( "revive_trigger_radius",num);
    setdvar( "player_reviveTriggerRadius",num);
    self iPrintln("Revive Radius: ^2" + num);
} 

_g(w)
{
    if(isAkimbo(w))
        self giveWeapon(w,0,true);
    else
        self giveWeapon(w);
}
// _gcamo(w,camo)
// {
//     if(!isdefined(camo))
//         camo = 0;

//     if(isAkimbo(w))
//         self giveWeapon(w,camo,true);
//     else
//         self giveWeapon(w,camo);
// }
_checkammo(w, give)
{
    if(!isdefined(give))
        give = false;

    if(self hasweapon(w))
    {
        var = getdvar("bulletsInWeaponsMag");
        
        if(isAkimbo(w))
        {
            rightAmmo = self getWeaponAmmoClip( w, "right" );
            leftAmmo = self getWeaponAmmoClip( w, "left" );

            if( var == "empty" )
            {
                if(!give){
                self setweaponammoclip(w, 0, "right");
                self setweaponammoclip(w, 0, "left");
                } else {
                self setweaponammoclip(w, 1, "right");
                self setweaponammoclip(w, 1, "left");
                }
            }
            else if( var == "onebullet" )
            {
                self setweaponammoclip(w, 1, "right");
                self setweaponammoclip(w, 1, "left");
            }
            else if( var == "fullminusonebullet" )
            {
                self setweaponammoclip(w, (weaponclipsize(w) - 1), "right");
                self setweaponammoclip(w, (weaponclipsize(w) - 1), "left");
            }
            else if( var == "full" )
            {
                self setweaponammoclip(w, weaponclipsize(w), "right");
                self setweaponammoclip(w, weaponclipsize(w), "left");
            }
            else
            {
                self setweaponammoclip(w, weaponclipsize(w), "right");
                self setweaponammoclip(w, weaponclipsize(w), "left");
                self givemaxammo(w);
            }
        }
        else
        {
            if( var == "empty" )
            {
                if(!give){
                self setweaponammoclip(w, 0);
                } else {
                self setweaponammoclip(w, 1);
                }
            }
            else if( var == "onebullet" )
            {
                if(isBurstWeapon(w))
                    self setweaponammoclip(w, 3);
                else
                    self setweaponammoclip(w, 1);
            }
            else if( var == "fullminusonebullet" )
            {
                if(isBurstWeapon(w))
                    self setweaponammoclip(w, (weaponclipsize(w) - 3));
                else
                    self setweaponammoclip(w, (weaponclipsize(w) - 1));
            }
            else if( var == "full" )
            {
                self setweaponammoclip(w, weaponclipsize(w));
            }
            else
            {
                self setweaponammoclip(w, weaponclipsize(w));
                self givemaxammo(w);
            }
        }
    }
    else
    {
        self iPrintLn( "^1You do not have the weapon specified.. (^5" + w + "^7)" );
    }
}
_givemaxammo(w)
{
    if(self hasWeapon(w))
        self giveMaxAmmo(w);
}

sui()
{
    self suicide();
}

__setammo( weapon, amount )
{
    if(!isdefined(weapon) || !isdefined(amount))
        return;
    
    if(self hasWeapon(weapon))
    {
        if(isAkimbo(weapon))
        {
            rightAmmo = self getWeaponAmmoClip( weapon, "right" );
            leftAmmo = self getWeaponAmmoClip( weapon, "left" );

            if( amount == "empty" )
            {
                self setweaponammoclip(weapon, 0, "right");
                self setweaponammoclip(weapon, 0, "left");
            }
            else if( amount == "onebullet" )
            {
                self setweaponammoclip(weapon, 1, "right");
                self setweaponammoclip(weapon, 1, "left");
            }
            else if( amount == "fullminusonebullet" )
            {
                self setweaponammoclip(weapon, (weaponclipsize(weapon) - 1), "right");
                self setweaponammoclip(weapon, (weaponclipsize(weapon) - 1), "left");
            }
            else if( amount == "full" )
            {
                self setweaponammoclip(weapon, weaponclipsize(weapon), "right");
                self setweaponammoclip(weapon, weaponclipsize(weapon), "left");
            }
            else
            {
                self setweaponammoclip(weapon, int(amount), "right");
                self setweaponammoclip(weapon, int(amount), "left");
            }
        }
        else
        {
            if( amount == "empty" )
            {
                self setweaponammoclip(weapon, 0);
            }
            else if( amount == "onebullet" )
            {
                if(isBurstWeapon(weapon))
                    self setweaponammoclip(weapon, 3);
                else
                    self setweaponammoclip(weapon, 1);
            }
            else if( amount == "fullminusonebullet" )
            {
                if(isBurstWeapon(weapon))
                    self setweaponammoclip(weapon, (weaponclipsize(weapon) - 3));
                else
                    self setweaponammoclip(weapon, (weaponclipsize(weapon) - 1));
            }
            else if( amount == "full" )
            {
                self setweaponammoclip(weapon, weaponclipsize(weapon));
            }
            else
            {
                self setweaponammoclip(weapon, int(amount));
            }
        }
    }
}


set_pap_price()
{
    precachestring(&"ZOMBIE_PERK_PACKAPUNCH");
    precachestring(&"ZOMBIE_PERK_PACKAPUNCH_ATT");

    level waittill("Pack_A_Punch_on");

    pap_triggers = getentarray("specialty_weapupgrade", "script_noteworthy");
    pap_trigger = pap_triggers[0];
    pap_trigger.cost = 0;
    pap_trigger.attachment_cost = 0;
    pap_trigger sethintstring(&"ZOMBIE_PERK_PACKAPUNCH", pap_trigger.cost); // reset hint msg to new price
}

end_game_when_hit()
{
    level endon("game_ended");

    // inital black screen
    if (!flag("initial_blackscreen_passed"))
    {
        flag_wait("initial_blackscreen_passed");
    }

    // wait until a zombie has spawned, then run the loop
    enemies = get_number_of_zombies();
    while (enemies <= 0)
    {
        enemies = get_number_of_zombies();
        wait 0.5;
    }

    for(;;)
    {
        enemies = get_number_of_zombies();
        if (enemies < 1 && level.is_last)
        {
            if (int(getdvar("g_ai")) != 1)
                setdvar("g_ai", 1);

            level thread custom_end_game();
            break;
        }

        wait 0.05;
    }
}

// MP endgame + parts of end_game from _zm
custom_end_game()
{
    winner = level.last_attacker.team;

    if (game["state"] == "postgame" || level.gameEnded) return;
    if (isdefined(level.onEndGame))
        [[level.onEndGame]](winner);

    // visionSetNaked("mpOutro", 2.0);

    setMatchFlag("enable_popups", 0);
    setmatchflag("cg_drawSpectatorMessages", 0);
    setmatchflag("game_ended", 1);

    players = get_players();
    setmatchflag("disableIngameMenu", 1);
    foreach(player in players)
    {
        player closemenu();
        player closeingamemenu();
        player enableinvulnerability();
        if (isdefined(player.revivetexthud))
            player.revivetexthud destroy();
    }

    level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
    level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
    level.zombie_vars["zombie_powerup_point_doubler_time"] = 0;

    game["state"] = "postgame";
    level.gameEndTime = getTime();
    level.gameEnded = true;
    SetDvar("g_gameEnded", 1);
    level.inGracePeriod = false;
    level notify("game_ended");
    //level notify("game_module_ended"); // is this even needed
    maps\mp\gametypes_zm\_globallogic_audio::flushDialog();

    if (!isdefined(game["overtime_round"]) || wasLastRound()) // Want to treat all overtime rounds as a single round
    {
        game["roundsplayed"]++;
        game["roundwinner"][game["roundsplayed"]] = winner;

        if (level.teambased)
        {
            game["roundswon"][winner]++;
        }
    }

    level.finalKillCam_winner = "none";
    if (isdefined(winner) && isdefined(level.teams[winner]))
    {
        level.finalKillCam_winner = winner;
    }

    level.finalKillCam_winnerPicked = true;

    setGameEndTime(0);

    maps\mp\gametypes_zm\_globallogic::updatePlacement();
    maps\mp\gametypes_zm\_globallogic::updateRankedMatch(winner);

    newTime = getTime();
    gameLength = getGameLength();

    SetMatchTalkFlag("EveryoneHearsEveryone", 1);

    bbGameOver = 0;
    if (isOneRound() || wasLastRound())
    {
        bbGameOver = 1;

        if (level.teambased)
        {
            if (winner == "tie")
            {
                recordGameResult("draw");
            }
            else
            {
                recordGameResult(winner);
            }
        }
        else
        {
            if (!isdefined(winner))
            {
                recordGameResult("draw");
            }
            else
            {
                recordGameResult(winner.team);
            }
        }
    }

    players = getplayers();
    foreach(player in players)
    {
        if (!isdefined(player))
            continue;

        player thread destroy_menu();
        player maps\mp\gametypes_zm\_globallogic_player::freezeplayerforroundend();
        player thread roundenddof(4.0);

        // zombies think they are tough because we can't move at all
        player enableinvulnerability();
        player maps\mp\gametypes_zm\_globallogic_ui::freeGameplayHudElems();
        player maps\mp\gametypes_zm\_weapons::updateWeaponTimings(newTime);
        player maps\mp\gametypes_zm\_globallogic::bbPlayerMatchEnd(gameLength, "", bbGameOver);

        if (isPregame())
        {
            index++;
            continue;
        }

        if (level.rankedMatch || level.wagerMatch || level.leagueMatch)
        {
            if (isdefined(player.setPromotion))
            {
                player setDStat("AfterActionReportStats", "lobbyPopup", "promotion");
            }
            else
            {
                player setDStat("AfterActionReportStats", "lobbyPopup", "summary");
            }
        }
    }

    maps\mp\_music::setmusicstate("SILENT");
    thread maps\mp\_challenges::roundEnd(winner);
    if (startNextRound(winner, " "))
    {
        return;
    }

    ///////////////////////////////////////////
    // After this the match is really ending //
    ///////////////////////////////////////////

    if (!isOneRound())
    {
        if (isdefined(level.onRoundEndGame))
        {
            winner = [[level.onRoundEndGame]](winner);
        }
    }

    skillUpdate(winner, level.teamBased);
    recordLeagueWinner(winner);

    maps\mp\gametypes_zm\_globallogic::setTopPlayerStats();
    thread maps\mp\_challenges::gameEnd(winner);

    displayGameEnd(winner);

    stopallrumbles();
    level.zombie_vars["zombie_powerup_insta_kill_time"] = 0;
    level.zombie_vars["zombie_powerup_fire_sale_time"] = 0;
    level.zombie_vars["zombie_powerup_point_doubler_time"] = 0;
    setmatchflag("disableIngameMenu", 1);

    // maps that crash reverting archive time
    level.skip_game_end = false;
    if (level.script == "zm_transit" || level.script == "zm_prison" || level.script == "zm_buried")
    {
        level.skip_game_end = true;
    }

    // load killcam here.
    postRoundFinalKillcam(); // call killcam here?
    while (level.in_final_killcam == 1)
    {
        wait 0.05;
    }

    level.intermission = true;

    //regain players array since some might've disconnected during the wait above
    players = getplayers();
    foreach(player in players)
    {
        if (!isdefined(player))
            continue;

        player closemenu();
        player closeInGameMenu();
        player notify ("reset_outcome");
        player thread [[level.spawnIntermission]]();
        player overlay(false);
        player setClientUIVisibilityFlag("hud_visible", 1);
    }

    level notify ("sfade");
    level notify("stop_intermission");
    logString("game ended");

    if (!isdefined(level.skip_game_end) || !level.skip_game_end)
        wait 10;

    exitlevel(false);
}

open_seseme()
{
    flag_wait("initial_blackscreen_passed");
    setdvar("zombie_unlock_all", 1);
    flag_set("power_on");
    players = get_players();
    zombie_doors = getentarray("zombie_door", "targetname");
    for(i = 0; i < zombie_doors.size; i++)
    {
        zombie_doors[i] notify("trigger");
        if (is_true(zombie_doors[i].power_door_ignore_flag_wait))
        {
            zombie_doors[i] notify("power_on");
        }
        wait(0.05);
    }
    zombie_airlock_doors = getentarray("zombie_airlock_buy", "targetname");
    for(i = 0; i < zombie_airlock_doors.size; i++)
    {
        zombie_airlock_doors[i] notify("trigger");
        wait(0.05);
    }
    zombie_debris = getentarray("zombie_debris", "targetname");
    for(i = 0; i < zombie_debris.size; i++)
    {
        zombie_debris[i] notify("trigger", players[0]);
        wait(0.05);
    }
    setdvar("zombie_unlock_all", 0);
}

displayGameEnd(winner)
{
    players = getplayers();
    foreach(player in players)
    {
        if (!isdefined(player))
            continue;

        player thread [[level.onTeamOutcomeNotify]](winner, false, "");
        player setClientUIVisibilityFlag("hud_visible", 0);
        player setClientUIVisibilityFlag("g_compassShowEnemies", 0);
    }

    roundEndWait(level.postRoundTime, true);
}

outcome_notify_stub(winner, isround, endreasontext)
{
    self endon("disconnect");
    self notify("reset_outcome");
    team = level.last_attacker.team;

    while (self.doingnotify)
    {
        wait 0.05;
    }
    self endon("reset_outcome");
    headerfont = "extrabig";
    font = "default";
    if (self issplitscreen())
    {
        titlesize = 2;
        textsize = 1.5;
        iconsize = 30;
        spacing = 10;
    }
    else
    {
        titlesize = 3;
        textsize = 2;
        iconsize = 70;
        spacing = 25;
    }
    duration = 60000;
    outcometitle = createfontstring(headerfont, titlesize);
    outcometitle setpoint("TOP", undefined, 0, 30);
    outcometitle.glowalpha = 1;
    outcometitle.hidewheninmenu = 0;
    outcometitle.archived = 0;
    outcometitle.immunetodemogamehudsettings = 1;
    outcometitle.immunetodemofreecamera = 1;
    outcometext = createfontstring(font, 2);
    outcometext setparent(outcometitle);
    outcometext setpoint("TOP", "BOTTOM", 0, 0);
    outcometext.glowalpha = 1;
    outcometext.hidewheninmenu = 0;
    outcometext.archived = 0;
    outcometext.immunetodemogamehudsettings = 1;
    outcometext.immunetodemofreecamera = 1;

    if (level.round_based)
        outcometitle settext(game["strings"]["round_win"]);
    else
        outcometitle settext(game["strings"]["victory"]);
    outcometitle.color = (0.42, 0.68, 0.46);
    outcometext settext("Zombies Eliminated");
    outcometitle setcod7decodefx(200, duration, 600);
    outcometext setpulsefx(100, duration, 1000);
    iconspacing = 100;
    currentx = ((1 * -1) * iconspacing) / 2;

    teamicons = [];
    teamicons[team] = createicon(determineTeamLogo(), iconsize, iconsize);
    teamicons[team] setparent(outcometext);
    teamicons[team] setpoint("TOP", "BOTTOM", currentx, spacing);
    teamicons[team].hidewheninmenu = 0;
    teamicons[team].archived = 0;
    teamicons[team].alpha = 0;
    teamicons[team].immunetodemogamehudsettings = 1;
    teamicons[team].immunetodemofreecamera = 1;
    teamicons[team] fadeovertime(0.5);
    teamicons[team].alpha = 1;

    currentx += iconspacing;

    foreach(enemyteam in level.teams)
    {
        if (enemyteam != team)
        {
            teamicons[enemyteam] = createicon("hud_status_dead", iconsize, iconsize);
            teamicons[enemyteam] setparent(outcometext);
            teamicons[enemyteam] setpoint("TOP", "BOTTOM", currentx, spacing);
            teamicons[enemyteam].hidewheninmenu = 0;
            teamicons[enemyteam].archived = 0;
            teamicons[enemyteam].immunetodemogamehudsettings = 1;
            teamicons[enemyteam].immunetodemofreecamera = 1;
            teamicons[enemyteam] fadeovertime(0.5);
            teamicons[enemyteam].alpha = 1;

            currentx += iconspacing;
        }
    }
    teamscores = [];
    teamscores[team] = createfontstring(font, titlesize);
    teamscores[team] setparent(teamicons[team]);
    teamscores[team] setpoint("TOP", "BOTTOM", 0, spacing);
    teamscores[team].glowalpha = 1;
    if (level.round_based)
        teamscores[team] setvalue(randomintrange(0, 4));
    else
        teamscores[team] setvalue(4);
    teamscores[team].hidewheninmenu = 0;
    teamscores[team].archived = 0;
    teamscores[team].immunetodemogamehudsettings = 1;
    teamscores[team].immunetodemofreecamera = 1;
    teamscores[team] setpulsefx(100, duration, 1000);

    foreach(enemyteam in level.teams)
    {
        if (enemyteam != team)
        {
            teamscores[enemyteam] = createfontstring(headerfont, titlesize);
            teamscores[enemyteam] setparent(teamicons[enemyteam]);
            teamscores[enemyteam] setpoint("TOP", "BOTTOM", 0, spacing);
            teamscores[enemyteam].glowalpha = 1;
            teamscores[enemyteam] setvalue(level.enemy_score);
            teamscores[enemyteam].hidewheninmenu = 0;
            teamscores[enemyteam].archived = 0;
            teamscores[enemyteam].immunetodemogamehudsettings = 1;
            teamscores[enemyteam].immunetodemofreecamera = 1;
            teamscores[enemyteam] setpulsefx(100, duration, 1000);
        }
    }
    font = "objective";
    matchbonus = createfontstring(font, 2);
    matchbonus setparent(outcometext);
    matchbonus setpoint("TOP", "BOTTOM", 0, iconsize + (spacing * 3) + teamscores[team].height);
    matchbonus.glowalpha = 1;
    matchbonus.hidewheninmenu = 0;
    matchbonus.archived = 0;
    matchbonus.label = game["strings"]["match_bonus"];
    matchbonus setvalue(randomintrange(2000, 3500));
    self thread maps\mp\gametypes_zm\_hud_message::resetoutcomenotify(teamicons, teamscores, outcometitle, outcometext);
}

// shader, logos, team icons
determineTeamLogo()
{
    mapname = tolower(getdvar("mapname"));
    standard = maps\mp\zombies\_zm_utility::is_standard(); 		// not turned/other shit
    survival = (getDvar("ui_zm_gamemodegroup") == "zsurvival"); // survival (Nuketown, TranZit solos)
    classic = (getDvar("ui_zm_gamemodegroup") == "zclassic"); 	// TranZit, MOTD, Origins, Buried, Die Rise

    if (survival)
    {
        if (is_true(level.should_use_cia))
            return game["icons"]["axis"];
        else
            return game["icons"]["allies"];
    }
    else if (classic)
    {
        return self.killcam_rank;
    }

    if (standard)
        return "hud_status_dead";

    return "hud_status_dead";
}

// a improved updatedamagefeedback
init_player_hitmarkers()
{
    self.hud_damagefeedback = newdamageindicatorhudelem(self);
    self.hud_damagefeedback.horzalign = "center";
    self.hud_damagefeedback.vertalign = "middle";
    self.hud_damagefeedback.x = -12;
    self.hud_damagefeedback.y = -12;
    self.hud_damagefeedback.alpha = 0;
    self.hud_damagefeedback.archived = 1;
    self.hud_damagefeedback.color = (1, 1, 1);
    self.hud_damagefeedback setshader("damage_feedback", 24, 48);

    // self.hitsoundtracker = 1;
}

do_hitmarker_internal(mod, death)
{
    if (!isplayer(self))
        return;

    if (!isdefined(death))
        death = false;

    if (isdefined(mod) && mod != "MOD_CRUSH" && mod != "MOD_GRENADE_SPLASH" && mod != "MOD_HIT_BY_OBJECT")
    {
        if(death)
            self.hud_damagefeedback.color = (1, 0, 0);
        else
            self.hud_damagefeedback.color = (1, 1, 1);

        self maps\mp\gametypes_zm\_damagefeedback::playhitsound( mod, "mpl_hit_alert" );
        // self playlocalsound("mpl_hit_alert"); 
        // self playlocalsound("mpl_hit_alert_low"); 

        self.hud_damagefeedback setshader("damage_feedback", 24, 48);
        self.hud_damagefeedback.alpha = 1;
        self.hud_damagefeedback fadeovertime(1);
        self.hud_damagefeedback.alpha = 0;
    }
}

do_hitmarker(mod, hit_location, hit_origin, player, amount)
{
    if (isdefined(player) && isplayer(player) && player != self)
    {
        player thread do_hitmarker_internal(mod);
        player.points += 10; // forgot what this is for, lol?
    }

    return false;
}

do_hitmarker_death()
{
    // self is the zombie victim in this case
    if (isdefined(self.attacker) && isplayer(self.attacker) && self.attacker != self)
        self.attacker thread do_hitmarker_internal(self.damagemod, true);
}

zombies_counter()
{
    level endon("endZmCounter");
    level.zombies_counter = createServerFontString("hudsmall", 1.2);
    level.zombies_counter setpoint("CENTER", "CENTER", "CENTER", 210);
    level.zombies_counter.archived = 0;
    level.zombies_counter.alpha = 0.6; // add opacity
    level.zombies_counter.hideWhenInMenu = true;
    level.zombies_counter thread waittillEnd();
    for(;;)
    {
        enemies = get_number_of_zombies();
        if (enemies == 0)
            level.zombies_counter.label = &"Zombies: ^1";
        else if (enemies <= 3)
            level.zombies_counter.label = &"Zombies: ^3";
        else if (enemies != 0)
            level.zombies_counter.label = &"Zombies: ^2";
        level.zombies_counter setValue(enemies);
        wait 0.05;
    }
}

waittillEnd()
{
    level waittill("game_ended");
    self Destroy();
}

dropCanswap()
{
    weapon = randomGun();
    // self devp(weapon);
    self giveWeapon(weapon);
    self switchToWeapon(weapon);
    self dropItem(weapon);
    self iPrintLn(weapon + " dropped!");
    wait 2; // prevent spam
}

randomOwnedGun() //Credits to @MatrixMods
{
    self.weaponsPick = [];
    self.weaponsPick = self GetWeaponsList();
    return self.weaponsPick[RandomIntRange(0, self.weaponsPick.size)];
}

randomGun() //Credits to @MatrixMods
{
	self.gun = "";
	while(self.gun == "")
	{
		id = random(level.canswapWeapons);

        if(!checkGun(id))
        {
            if(!isSubStr(id, "_zm"))
            {
                id = id + "_zm";
            }
            else
            {
                id = id;
            }
			self.gun = id;
        }
		wait 0.1;
		return self.gun;
	}
   wait 0.1;
}

checkGun(weap)
{
    self.allWeaps = [];
    self.allWeaps = self getWeaponsList();
    foreach(weapon in self.allWeaps)
    {
        if (isSubStr(weapon, weap))
            return true;
    }
    return false;
}

dropWeapon()
{
    self dropItem(self getCurrentWeapon());
}

toggle_save_and_load(announce)
{
    if (!isdefined(announce))
        announce = true;

    if (!self.pers["snlBinds"])
    {
        self.pers["snlBinds"] = true;
    }
    else
    {
        self.pers["snlBinds"] = false;
    }

    self setPlayerCustomDvar("snlBinds",self.pers["snlBinds"]);
    self setClientDvar("snlBinds",self.pers["snlBinds"]);

    if(announce)
        self iPrintLn("Save and Load Binds " + convertstatus(self.pers["snlBinds"]));
}

change_snl_binds()
{
    if(!isdefined(self.pers["snlCombo"]) || isdefined(self.pers["snlCombo"]) && self.pers["snlCombo"] == 0 )
    {
        self iPrintLn( "While crouched, press ^5[{+actionslot 2}]^7 to Save, and ^5[{+actionslot 1}]^7 to Load." );
        self.pers["snlCombo"] = 1;
    }
    else if(isdefined(self.pers["snlCombo"]) && self.pers["snlCombo"] == 1)
    {
        self iPrintLn( "While crouched, press ^5[{+actionslot 3}]^7 to Save, and ^5[{+actionslot 4}]^7 to Load." );
        self.pers["snlCombo"] = 2;
    }
    else if(isdefined(self.pers["snlCombo"]) && self.pers["snlCombo"] == 2)
    {
        self iPrintLn( "Press ^5[{+melee}]^7 & ^5[{+actionslot 2}]^7 while prone to Save, and ^5[{+melee}]^7 & ^5[{+actionslot 1}]^7 while crouched to Load." );
        self.pers["snlCombo"] = 3;
    }
    else
    {
        self iPrintLn( "Save and Load Binds [^1OFF^7]" );
        self.pers["snlCombo"] = 0;
    }

    self setPlayerCustomDvar("snlCombo",self.pers["snlCombo"]);
    self setClientDvar("snlCombo",self.pers["snlCombo"]);
}

monitor_save_and_load()
{
    self endon("disconnect");
    self endon("toggle_save_and_load");
    level endon("game_ended");

    for(;;)
    {
        if(isdefined(self.pers["snlCombo"]) && self.pers["snlCombo"] == 1)
        {
            // Crouch + DPAD Down to Save
            // Crouch + DPAD Up to Load
            if (self actionslottwobuttonpressed() && self GetStance() == "crouch" && !self adsbuttonpressed() && self isOnGround() && !self.menu.is_open)
            {
                if(self.pers["snlBinds"])
                    self _savepos( "dvar", "allbutstance" );
                wait 0.05;
            }
            
            if (self actionslotonebuttonpressed() && self GetStance() == "crouch" && !self adsbuttonpressed() && !self.menu.is_open)
            {
                if(self.pers["snlBinds"])
                    self _loadpos( "dvar" );
                wait 0.04;
            }
        }
        
        else if(isdefined(self.pers["snlCombo"]) && self.pers["snlCombo"] == 2)
        {
            // Crouch + DPAD Left to Save
            // Crouch + DPAD Right to Load
            if (self actionslotthreebuttonpressed() && self GetStance() == "crouch" && !self adsbuttonpressed() && self isOnGround() && !self.menu.is_open)
            {
                if(self.pers["snlBinds"])
                    self _savepos( "dvar", "allbutstance" );
                wait 0.05;
            }
            
            if (self actionslotfourbuttonpressed() && self GetStance() == "crouch" && !self adsbuttonpressed() && !self.menu.is_open)
            {
                if(self.pers["snlBinds"])
                    self _loadpos( "dvar" );
                wait 0.04;
            }
        }

        else if(isdefined(self.pers["snlCombo"]) && self.pers["snlCombo"] == 3)
        {
            // Prone + Knife + DPAD Down to Save
            // Knife + DPAD Up to Load
            if (self meleebuttonpressed() && self actionslottwobuttonpressed() && !self adsbuttonpressed() && self GetStance() == "prone" && self isOnGround() && !self.menu.is_open)
            {
                if(self.pers["snlBinds"])
                    self _savepos( "dvar", "allbutstance" );
                wait 0.05;
            }
            
            if (self meleebuttonpressed() && self actionslotonebuttonpressed() && !self adsbuttonpressed() && self GetStance() == "crouch" && !self.menu.is_open)
            {
                if(self.pers["snlBinds"])
                    self _loadpos( "dvar" );
                wait 0.04;
            }
        }

        wait 0.05;
    }
}


/* save and load position through a guid locked dvar per each map */

_savepos( mode, infotosave )
{
    if(!isdefined(infotosave))
        infotosave = "all";

    if(!isdefined(mode))
        mode = "bool";

    if( mode == "dvar" )
    {
        if( infotosave == "all" || infotosave == "allbutstance" || infotosave == "pos" ) {
    	    self setPlayerCustomDvar( level.script + "_save", ( self.origin[0] + ", " + self.origin[1] + ", " + self.origin[2] ) );
            self iPrintLn( "Position Saved" );
        }
	    
        if( infotosave == "all" || infotosave == "allbutstance" || infotosave == "ang" ) {
            self setPlayerCustomDvar( level.script + "_angles", ( self.angles[0] + ", " + self.angles[1] + ", " + self.angles[2] ) );
            self iPrintLn( "Look Angles Saved" );
        }

        if( infotosave == "all" || infotosave == "stance" ) {
            self setPlayerCustomDvar( level.script + "_stance", self getStance() );
            self iPrintLn( "Stance Saved" );
        }
    }
    else if( mode == "bool" )
    {
        if( infotosave == "all" || infotosave == "allbutstance" || infotosave == "pos" ) {
            self.pers["mySpawn"] = self.origin;
            self iprintln("Position Saved " + self.pers["mySpawn"]);
        }

        if( infotosave == "all" || infotosave == "allbutstance" || infotosave == "ang" ) {
            self.pers["myAngles"] = self.angles;
            self iprintln("Look Angles Saved " + self.pers["myAngles"]);
        }

        if( infotosave == "all" || infotosave == "stance" ) {
            self.pers["myStance"] = self getStance();
            self iprintln("Stance Saved " + self.pers["myStance"]);
        }
    }
}

_loadpos( mode, infotoload )
{
    if(!isdefined(infotoload))
        infotoload = "all";

    if(!isdefined(mode))
        mode = "bool";

    if( mode == "dvar" )
    {
        origin = getPlayerCustomDvar( level.script + "_save" );

        pos = strtok(origin, ",");
        x = getsubstr(pos[0], 0); // remove "/" or "!" from command
        y = getsubstr(pos[1], 0); // remove "/" or "!" from command
        z = getsubstr(pos[2], 0); // remove "/" or "!" from command
        
        if( infotoload == "all" || infotoload == "allbutstance" || infotoload == "pos" ) {
            self setOrigin( ( int(x), int(y), int(z) ) );
        }

        angles = getPlayerCustomDvar( level.script + "_angles" );

        ang = strtok(angles, ",");
        a = getsubstr(ang[0], 0); // remove "/" or "!" from command
        b = getsubstr(ang[1], 0); // remove "/" or "!" from command
        c = getsubstr(ang[2], 0); // remove "/" or "!" from command

        if( infotoload == "all" || infotoload == "allbutstance" || infotoload == "ang" ) {
            self setPlayerAngles( ( int(a), int(b), int(c) ) );
        }

        stance = getPlayerCustomDvar( level.script + "_stance" );
        
        if( infotoload == "all" || infotoload == "stance" ) {
           self setStance(stance);
        }
    }
    else if( mode == "bool" )
    {
        if (isdefined(self.pers["mySpawn"]) && ( infotoload == "all" || infotoload == "allbutstance" || infotoload == "pos" ))
        {
            self setorigin(self.pers["mySpawn"]);
        }
        if (isdefined(self.pers["myAngles"]) && ( infotoload == "all" || infotoload == "allbutstance" || infotoload == "ang" ))
        {
            self setplayerangles(self.pers["myAngles"]);
        }
        if (isdefined(self.pers["myStance"]) && ( infotoload == "all" || infotoload == "stance" ))
        {
            self setStance(self.pers["myStance"]);
        }
    }
}

_clearpos( mode, infotoclear )
{
    if(!isdefined(infotoclear))
        infotoclear = "all";

    if(!isdefined(mode))
        mode = "bool";

    if( mode == "dvar" )
    {
        if( infotoclear == "all" || infotoclear == "allbutstance" || infotoclear == "pos" ) {
    	    self setPlayerCustomDvar( level.script + "_save", "" );
            self iprintln("Saved Position Deleted");
        }

        if( infotoclear == "all" || infotoclear == "allbutstance" || infotoclear == "ang" ) {
	        self setPlayerCustomDvar( level.script + "_angles", "" );
            self iprintln("Saved Look Angles Deleted");
        }

        if( infotoclear == "all" || infotoclear == "stance" ) {
	        self setPlayerCustomDvar( level.script + "_stance", "" );
            self iprintln("Saved Stance Deleted");
        }

    }
    else if( mode == "bool" )
    {
        if (isdefined(self.pers["mySpawn"]) && ( infotoclear == "all" || infotoclear == "allbutstance" || infotoclear == "pos" ))
        {
            self.pers["mySpawn"] = undefined;
            self iprintln("Saved Position Deleted");
        }
        if (isdefined(self.pers["myAngles"]) && ( infotoclear == "all" || infotoclear == "allbutstance" || infotoclear == "ang" ))
        {
            self.pers["myAngles"] = undefined;
            self iprintln("Saved Look Angles Deleted");
        }
        if (isdefined(self.pers["myStance"]) && ( infotoclear == "all" || infotoclear == "stance" ))
        {
            self.pers["myStance"] = undefined;
            self iprintln("Saved Stance Deleted");
        }
    }
}

verification_to_num(status)
{
    if (status == "host")
        return 3;
    if (status == "admin")
        return 2;
    if (status == "co")
        return 1;
    else
        return 0;
}

verification_to_color(status)
{
    if (status == "host")
        return "h";
    if (status == "admin")
        return "a";
    if (status == "co")
        return "c";
    else
        return "";
}

changeVerificationMenu(player, verlevel)
{
    if (player.status != verlevel && !player ishost())
    {
        player.status = verlevel;

        if (player.status == "Unverified")
            player thread destroy_menu();

        self iprintln("set level for " + player get_the_player_name() + " to " + verification_to_color(verlevel));
        player iprintln("your level has been set to " + verification_to_color(verlevel));
    }
    else
    {
        if (player ishost())
            self iprintln("cannot change level to " + verification_to_color(player.status));
        else
            self iprintln("level for " + player get_the_player_name() + " is already " + verification_to_color(verlevel));
    }
}

verification_to_letter(status)
{
    switch(status)
    {
    case "host":
        return "h";
    case "admin":
        return "a";
    case "co":
        return "c";
    default:
        return "";
    }
}

get_the_player_name()
{
    player_name = self.name;
    for(i = 0; i < self.name.size; i++)
    {
        if (self.name[i] == "]") break;
    }
    if (self.name.size != i)
        player_name = getSubStr(self.name, i + 1, self.name.size);
    return player_name;
}

Iif(bool, rTrue, rFalse)
{
    if (bool)
        return rTrue;
    else
        return rFalse;
}

// lazy fix for submenus inside submenus
format_local(name)
{
    switch (name)
    {
    case "mods":
        return "main";
    case "killcam":
        return "configure settings";
    case "weap":
        return "weapons";
    case "weappistol":
        return "pistols";
    case "weapsnip":
        return "snipers";
    case "weapother":
        return "others";
    case "weapstaff":
        return "staffs";
    case "weapsmg":
        return "smg";
    case "weaplmg":
        return "lmg";
    case "weapar":
        return "ar";
    case "weapar_gl":
        return "ar grenade launcher";
    case "weapsg":
        return "shotguns";
    case "equip":
        return "equipment";
    case "perk":
        return "perks";
    case "lobby":
        return "lobby menu";
    case "bots":
        return "bots menu";
    case "players_menu":
        return "players menu";
    case "zombies_menu":
        return "individual zombies menu";
    case "killcam_rank":
        return "killcam rank";
    case "killcam_length":
        return "killcam length";
    case "end_screen":
        return "end screen";
    default:
        return name;
    }
}

UpgradeDowngradeWeapon()
{
    if(!isSubStr(self getcurrentweapon(), "upgraded")) 
        self UpgradeWeapon();
    else 
        self DowngradeWeapon();
}

UpgradeWeapon()
{
    baseweapon = maps\mp\zombies\_zm_weapons::get_base_name(self getcurrentweapon());
    weapon = get_upgrade(baseweapon);
    if (isdefined(weapon))
    {
        self takeweapon(baseweapon);
        self giveweapon(weapon, 0, self get_pack_a_punch_weapon_options(weapon));
        self switchtoweapon(weapon);
        self givemaxammo(weapon);
    }
}

DowngradeWeapon()
{
    baseweapon = self getcurrentweapon();
    weapon = get_base_weapon_name(baseweapon, 1);
    if (isdefined(weapon))
    {
        self takeweapon(baseweapon);
        self giveweapon(weapon, 0, self get_pack_a_punch_weapon_options(weapon));
        self switchtoweapon(weapon);
        self givemaxammo(weapon);
    }
}

get_upgrade(weapon)
{
    if (isdefined(level.zombie_weapons[weapon]) && isdefined(level.zombie_weapons[weapon].upgrade_name))
        return get_upgrade_weapon(weapon, 0);
    return get_upgrade_weapon(weapon, 1);
}

/* menu moved to scripts\zm\menu.gsc */

godmode(player, silent)
{
    if (!isdefined(silent))
        silent = false;
    if (!isdefined(player.godmode))
        player.godmode = false;

    if (!player.godmode)
    {
        player enableinvulnerability();
        player iprintln("god mode ^2on");
        player.godmode = true;
    }
    else if (player.godmode)
    {
        player disableinvulnerability();
        player iprintln("god mode ^1off");
        player.godmode = false;
    }

    if (self != player)
    {
        if (!silent)
        {
            if (player.godmode)
                self iprintln(player get_the_player_name() + "'s god mode ^2on");
            else if (!player.godmode)
                self iprintln(player get_the_player_name() + "'s god mode ^1off");
        }
    }
}

ufomode()
{
    if (!self.ufomode)
    {
        self iprintln("ufo ^2on");
        self iprintln("^7press [{+smoke}] or [{+frag}] to fly");
        self thread doufomode();
        self.ufomode = true;
    }
    else if (self.ufomode)
    {
        self iprintln("ufo ^1off");
        self notify("stopufo");
        self.ufomode = false;
    }
}

doufomode()
{
    self endon("stopufo");
    self.fly = 0;
    ufo = spawn("script_model", self.origin);
    for(;;)
    {
        if (self secondaryoffhandbuttonpressed() || self fragbuttonpressed())
        {
            self playerLinkTo(UFO);
            self.fly = 1;
        }
        else
        {
            self Unlink();
            self.fly = 0;
        }
        if (self.fly)
        {
            fly = self.origin + vector_scal(anglesToForward(self getPlayerAngles()), self.ufospeed);
            UFO moveTo(fly, .03);
        }
        wait 0.001;
    }
}

ufomodespeed()
{
    if (!isdefined(self.ufospeed))
        self.ufospeed = 80;

    speed = self.ufospeed;
    switch (speed)
    {
    case 20:
        self iprintln("ufo speed changed to ^140");
        self.ufospeed = 40;
        break;
    case 40:
        self iprintln("ufo speed changed to ^160");
        self.ufospeed = 60;
        break;
    case 60:
        self iprintln("ufo speed changed to ^180");
        self.ufospeed = 80;
        break;
    case 80:
        self iprintln("ufo speed changed to ^1100");
        self.ufospeed = 100;
        break;
    case 100:
        self iprintln("ufo speed changed to ^120");
        self.ufospeed = 20;
        break;
    default:
        break;
    }
}

switchteams(player)
{
    player.switching_teams = 1;
    if (player.team == "allies")
    {
        player.joining_team = "axis";
        player.leaving_team = player.pers["team"];
        player.team = "axis";
        player.pers["team"] = "axis";
        player.sessionteam = "axis";
        player._encounters_team = "A";
    }
    else
    {
        player.joining_team = "allies";
        player.leaving_team = player.pers["team"];
        player.team = "allies";
        player.pers["team"] = "allies";
        player.sessionteam = "allies";
        player._encounters_team = "B";
    }

    isdefault = "";
    if (player.default_team == player.team)
        isdefault = "(^2default^7)";
    else
        isdefault = "(^1not default^7)";

    player notify("joined_team");
    player iprintln("switched to ^1" + player.team + " ^7team " + isdefault);
    // if (self != player)
        // self iprintln("changed player team to ^1" + player.team + " ^7team " + isdefault);
}

_g_weapon(weapon)
{
    if(!is_valid_equipment( weapon ))
        return;

    weapons = strTok("sticky_grenade_zm,frag_grenade_zm", ",");

    foreach( w in weapons )
    {
        if( w != weapon )
        {
            self takeweapon( w );
        }
    }

    self g_weapon(weapon);
}
__g_weapon(weapon)
{
    if(!is_valid_equipment( weapon ))
        return;

    weapons = strTok("willy_pete_zm,bouncing_tomahawk_zm,upgraded_tomahawk_zm,emp_grenade_zm,cymbal_monkey_zm", ",");

    foreach( w in weapons )
    {
        if( w != weapon )
        {
            self takeweapon( w );
        }
    }

    self g_weapon(weapon);
}
g_weapon(weapon,announce)
{
    if(!isdefined(announce))
        announce = true;

    // just found this weapon wrapper lol
    self maps\mp\zombies\_zm_weapons::weapon_give(weapon);
    self givemaxammo(weapon);

    if(announce)
        self devp( weapon + " given" );
}
drop_weapon(weapon)
{
    cw = self getCurrentWeapon();
    self maps\mp\zombies\_zm_weapons::weapon_give(weapon);
    self givemaxammo(weapon);
    self dropItem(weapon);
    self switchToWeapon(cw);
    self devp( weapon + " dropped" );
}

doperks(perk,announce)
{
    if(!isDefined(announce))
        announce = false;

    if(!self hasperk(perk))
    {
        self maps\mp\zombies\_zm_perks::give_perk(perk,0);
        self.pers[perk] = true;
    }
    else
    {
        self unsetperk(perk);
        self notify(perk+"_stop");
	    // self.num_perks--;
        self.perk_hud[perk] destroy_hud();
        self.pers[perk] = false;
    }
    self setPlayerCustomDvar(perk, self.pers[perk] );
    self setClientDvar( perk, self.pers[perk]);

    if(announce)
        self iPrintLn(convertperk(perk) + " " + convertstatus(self.pers[perk]));

    wait 1;
    foreach(perk in level.perkslist)
    {            
        self.perk_hud[ perk ] destroy_hud();
    }
}

setup_my_perks()
{
	self maps\mp\zombies\_zm_audio::playerexert( "burp" );
    flag_wait( "initial_blackscreen_passed" );
    if ( level.script != "zm_tomb" )
    {
        if ( level.script == "zm_prison" ) // wait until not in afterlife or else this func is rendered useless
        {
            self waittill_any( "bled_out", "player_revived", "fake_death" );
            // self devp( "afterlife over, perks given" );
            self.lives = 99;
        }
        machines = getentarray( "zombie_vending", "targetname" );
        perks = [];
        i = 0;
        while ( i < machines.size )
        {
            if ( machines[ i ].script_noteworthy == "specialty_weapupgrade" )
            {
                i++;
                continue;
            }
            perks[ perks.size ] = machines[ i ].script_noteworthy;
            i++;
        }
    }
    else 
    {
        perks = level._random_perk_machine_perk_list;
        // perks = level.perkslist;
    }
	foreach ( perk in perks )
	{
		if ( isDefined( self.perk_purchased ) && self.perk_purchased == perk )
		{
		}
		else
		{
			if ( self hasperk( perk ) || self maps\mp\zombies\_zm_perks::has_perk_paused( perk ) )
			{
			}
			else
			{
                if( self.pers[perk] )
				self maps\mp\zombies\_zm_perks::give_perk( perk, 0 );
				wait 0.25;
			}
		}
        self.perk_hud[perk] destroy_hud();
	}
    
	foreach ( perk in level.checkthis )
    {
        if ( self hasperk( perk ) || self maps\mp\zombies\_zm_perks::has_perk_paused( perk ) )
        {
        }
        else
        {
            if( self.pers[perk] )
            self maps\mp\zombies\_zm_perks::give_perk( perk, 0 );
            wait 0.25;
        }
    }
    // if ( getDvarInt( "players_keep_perks_permanently" ) == 1 )
    // {
        // if ( !is_true( self._retain_perks ) )
        // {
            // self thread watch_for_respawn();
            // self._retain_perks = 1;
        // }
    // }
}

// doperks(perk)
// {
//     self maps\mp\zombies\_zm_perks::give_perk(perk);
// }

freezezm()
{
    if (!isdefined(level.zmfrozen))
        level.zmfrozen = false;

    if (!level.zmfrozen)
    {
        self iprintln("freeze zombies ^2on");
        setdvar("g_ai", "0");
        level.zmfrozen = true;
    }
    else
    {
        self iprintln("freeze zombies ^1off");
        setdvar("g_ai","1");
        level.zmfrozen = false;
    }
}

zmignoreme()
{
    if (!self.ignoreme)
    {
        self iprintln("zombies ignore you ^2on");
        self.ignoreme = true;
    }
    else
    {
        self iprintln("zombies ignore you ^1off");
        self.ignoreme = false;
    }
}

setpoints(points)
{
    if(!isDefined(points))
        return;

    self.score = points;
    self playsound("zmb_cha_ching");
}

addpoints(points)
{
    self.score += points;
    self playsound("zmb_cha_ching");
}

// rewrote
spawnbot(godmode,enemy)
{
    if(!isdefined(enemy))
        enemy = false;

    if(!isdefined(godmode))
        godmode = true;

    spawnpoints = getstructarray("initial_spawn_points", "targetname");
    spawnpoint = getfreespawnpoint(spawnpoints);
    bot = addtestclient();
    if (!isdefined(bot))
        return;

    bot.pers["isBot"] = true;
    bot.equipment_enabled = false;
    yaw = spawnpoint.angles[1];
    bot thread maps\mp\zombies\_zm::zbot_spawn_think(spawnpoint.origin, yaw);

    team = getplayers()[0].team;
    bot.switching_teams = 1;
    bot.joining_team = team;
    bot.leaving_team = self.pers["team"];
    bot.team = team;
    bot.pers["team"] = team;
    bot.sessionteam = team;
    bot._encounters_team = (team == "axis" ? "A" : "B");
    bot notify("joined_team");
    iPrintLn(bot.team);
    bot waittill("spawned_player");
    if(enemy) {
        switchteams(bot);
    }

    if(godmode) {
        godmode(bot, true);
        iprintln("bot ^2spawned^7 with ^1god mode ^2on^7");
    }

    return bot;
}

makebotinvis()
{
    if (!isdefined(level.invisbot))
        level.invisbot = false;

    if (!level.invisbot)
    {
        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            if (isdefined(player.pers["isBot"]) && player.pers["isBot"])
            {
                player hide();
                player thread keepinpos();
            }
        }
        iprintln("bots invisible ^2on");
        level.invisbot = true;
    }
    else
    {
        players = getplayers();
        foreach(player in players)
        {
            if (!isdefined(player))
                continue;

            if (isdefined(player.pers["isBot"]) && player.pers["isBot"])
            {
                player show();
                player notify("bot_keepin");
            }
        }
        iprintln("bots invisible ^1off");
        level.invisbot = false;
    }
}

keepinpos()
{
    self endon("bot_keepin");
    level endon("game_ended");
    org = self.origin;
    for(;;)
    {
        self setorigin(org);
        wait 0.5;
    }
}

tpbotstocrosshair(enemy)
{
    players = getplayers();
    foreach(player in players)
    {
        if (!isdefined(player))
            continue;

        if (isdefined(player.pers["isBot"]) && player.pers["isBot"])
        {
            if(isdefined(enemy) && enemy == true )
            {
                if(player.team != self.team)
                {
                    player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"]);
                    iprintln("^1enemy ^7bots teleported to crosshair^7");
                }
            }
            else if(isdefined(enemy) && enemy == false )
            {
                if(player.team == self.team)
                {
                    player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"]);
                    iprintln("^2friendly ^7bots teleported to crosshair^7");
                }
            }
            else
            {
                player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"]);
                iprintln("all bots ^1teleported ^7to crosshair^7");
            }
        }
    }
}

// i made this just for jimbo idk if it works lul
tp_zombies(ai_num)
{
    zombies = getaiarray(level.zombie_team);
    if (!isdefined(ai_num))
    {
        foreach(zombie in zombies)
        {
            zombie forceteleport(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"]);
        }
        self iprintln("zombies ^1teleported ^7to crosshair^7");
    }
    else
    {
        foreach(zombie in zombies)
        {
            if (zombie get_ai_number() == ai_num)
            {
                zombie forceteleport(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"]);
                break;
            }
        }
        self iprintln("zombie ^1teleported ^7to crosshair^7");
    }
}
savezombiepos(ai_num)
{
    zombies = getaiarray(level.zombie_team);
    if (!isdefined(ai_num))
    {
        self iPrintLn("function needs to be used on one zombie only");
    }
    else
    {
        foreach(zombie in zombies)
        {
            if (zombie get_ai_number() == ai_num)
            {
                setdvar(level.script + "zombie_pos_", ( zombie.origin[0] + ", " + zombie.origin[1] + ", " + zombie.origin[2] ) );
	            setdvar(level.script + "zombie_ang_", ( zombie.angles[0] + ", " + zombie.angles[1] + ", " + zombie.angles[2] ) );
                break;
            }
        }
        self iprintln("zombie pos saved");
    }
}
loadzombiepos(ai_num)
{
    zombies = getaiarray(level.zombie_team);
    if (!isdefined(ai_num))
    {
        foreach(zombie in zombies)
        {
            if(getdvar("zombie_pos_" + level.script) != "")
            {
                origin = getdvar( level.script + "zombie_pos_" );
                angles = getdvar( level.script + "zombie_ang_" );
                
                pos = strtok(origin, ",");
                x = getsubstr(pos[0], 0); // remove "/" or "!" from command
                y = getsubstr(pos[1], 0); // remove "/" or "!" from command
                z = getsubstr(pos[2], 0); // remove "/" or "!" from command
                
                zombie setOrigin( ( int(x), int(y), int(z) ) );

                ang = strtok(angles, ",");
                a = getsubstr(ang[0], 0); // remove "/" or "!" from command
                b = getsubstr(ang[1], 0); // remove "/" or "!" from command
                c = getsubstr(ang[2], 0); // remove "/" or "!" from command
                
                zombie forceteleport( ( int(x), int(y), int(z) ), ( int(a), int(b), int(c) ) );
            }
        }
        self iprintln("zombie pos loaded");
    }
    else
    {
        foreach(zombie in zombies)
        {
            if (zombie get_ai_number() == ai_num)
            {
                if(getdvar("zombie_pos_" + level.script) != "")
                {
                    origin = getdvar( level.script + "zombie_pos_" );
                    angles = getdvar( level.script + "zombie_ang_" );
                    
                    pos = strtok(origin, ",");
                    x = getsubstr(pos[0], 0); // remove "/" or "!" from command
                    y = getsubstr(pos[1], 0); // remove "/" or "!" from command
                    z = getsubstr(pos[2], 0); // remove "/" or "!" from command
                    
                    zombie setOrigin( ( int(x), int(y), int(z) ) );

                    ang = strtok(angles, ",");
                    a = getsubstr(ang[0], 0); // remove "/" or "!" from command
                    b = getsubstr(ang[1], 0); // remove "/" or "!" from command
                    c = getsubstr(ang[2], 0); // remove "/" or "!" from command
                    
                    zombie forceteleport( ( int(x), int(y), int(z) ), ( int(a), int(b), int(c) ) );
                }
                break;
            }
        }
        self iprintln("zombie pos loaded");
    }
}

custom_end_game_f()
{
    level thread custom_end_game();
}

instantend()
{
    exitlevel(false);
}

togglezmcounter()
{
    if (!isdefined(level.zombie_counter))
        level.zombie_counter = true;

    if (!level.zombie_counter)
    {
        iprintln("zombies counter ^2on");
        level thread zombies_counter();
    }
    else if (level.zombie_counter)
    {
        iprintln("zombies counter ^1off");
        level notify("endZmCounter");
        level.zombies_counter destroy();
    }

    level.zombie_counter = !level.zombie_counter;
}

add_menu_alt(Menu, prevmenu)
{
    self.menu.getmenu[Menu] = Menu;
    self.menu.menucount[Menu] = 0;
    self.menu.previous[Menu] = prevmenu;
}

add_menu(Menu, prevmenu, status)
{
    self.menu.status[Menu] = status;
    self.menu.getmenu[Menu] = Menu;
    self.menu.scrollerpos[Menu] = 0;
    self.menu.curs[Menu] = 0;
    self.menu.menucount[Menu] = 0;
    self.menu.previous[Menu] = prevmenu;
}

add_option(menu, text, func, arg1, arg2, lower)
{
    if (!isdefined(lower)) lower = true;

    menu = self.menu.getmenu[menu];
    index = self.menu.menucount[menu];
    if (lower)
        self.menu.menuopt[menu][index] = tolower(text);
    else
        self.menu.menuopt[menu][index] = text;
    self.menu.func[menu][index] = func;

    self.menu.input[menu][index][0] = arg1;
    self.menu.input[menu][index][1] = arg2;

    self.menu.menucount[menu] += 1;
}

updatescrollbar()
{
    self.menu.scroller MoveOverTime(0.10);
    self.menu.scroller.y = 50 + (self.menu.curs[self.menu.current] * 14.40);

    // wait 1;
    // self iPrintLn(self.menu.scroller.y);
}

open_menu()
{
    if (!isdefined(self.first_menu_open))
        self.first_menu_open = true;

    if (self.first_menu_open)
    {
        self iPrintLn("[{+actionslot 1}] / [{+actionslot 2}] - up/down");
        self iPrintLn("[{+gostand}] - select");
        self iPrintLn("[{+activate}] - back");
        self.first_menu_open = false;
    }

    self.menu.background thread move_it_to("x", 263+self.menuxpos, .4);
    self.menu.scroller thread move_it_to("x", 263+self.menuxpos, .4);
    self.menu.background fadeovertime(0.6);
    self.menu.background.alpha = 0.55;
    self.menu.scroller fadeovertime(0.6);
    self.menu.scroller.alpha = 1;
    wait 0.5;
    self store_text(self.menuname, self.menuname);
    self.menu.title2 fadeovertime(0.3);
    self.menu.title2.alpha = 1;
    self.menu.counter fadeovertime(0.3);
    self.menu.counter1 fadeovertime(0.3);
    self.menu.counter.alpha = 1;
    self.menu.counter1.alpha = 1;
    self updatescrollbar();
    self.menu.is_open = true;
}

close_menu()
{
    self.menu.options fadeovertime(0.3);
    self.menu.options.alpha = 0;
    self.menu_status fadeovertime(0.3);
    self.menu_status.alpha = 0;
    self.menu.counter fadeovertime(0.3);
    self.menu.counter1 fadeovertime(0.3);
    self.menu.counter.alpha = 0;
    self.menu.counter1.alpha = 0;
    self.menu.title2 fadeovertime(0.3);
    self.menu.title2.alpha = 0;
    self.menu.is_open = false;
    wait 0.3;
    self.menu.scroller fadeovertime(0.3);
    self.menu.scroller.alpha = 0;
    self.menu.background fadeovertime(0.3);
    self.menu.background.alpha = 0;
    self.menu.background thread move_it_to("x", 800, .4);
    self.menu.scroller thread move_it_to("x", 800, .4);
}

move_it_to(axis, position, time)
{
    self moveOverTime(time);

    if (axis=="x")
        self.x = position;
    else
        self.y = position;
}

destroy_menu()
{
    self.menu_init = false;
    self close_menu();
    wait 0.3;
    self.menu.options destroy();
    self.menu.scroller destroy();
    self.infos destroy();
    self.menu.title2 destroy();
    self.menu.counter destroy();
    self.menu.counter1 destroy();
    self notify("destroy_menu");
}

store_shaders()
{
    // got the color and alpha values from my killcam mod
    //drawShader(shader, x, y, width, height, color, alpha, sort)
    self.menu.background = self drawShader("white", 800, 25, 155, 286, (0, 0, 0), .2, 0);
    self.menu.scroller = self drawShader("white", 800, -100, 155, 12, (0.749, 0, 0), 255, 1);
    self thread flicker_shaders();
}

flicker_shaders()
{
    self endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        if (self.menu.is_open)
        {
            waittime = randomFloatRange(0.3, 1.4);
            self.statuss.color = (0.2, 0, 0);
            self.menu.scroller.color = (0.2, 0, 0);
            self.menu.scroller.alpha = 1;
            wait waittime;
            self.statuss fadeovertime(waittime);
            self.statuss.color = (1, 0, 0);
            self.menu.scroller fadeovertime(waittime);
            self.menu.scroller.color = (1, 0, 0);
            self.menu.scroller.alpha = 0.8;
            wait waittime;
            self.statuss fadeovertime(waittime);
            self.statuss.color = (0, 0, 0);
            self.menu.scroller fadeovertime(waittime);
            self.menu.scroller.color = (0, 0, 0);
            self.menu.scroller.alpha = .0;
        }
        wait 0.05;
    }
}

store_text(menu, title)
{
    self.menu.current = menu;
    string = "";

    if (isdefined(self.menu.title2))
        self.menu.title2 destroy();
    self.menu.title2 destroy();
    self.menu.title2 = draw_text(title, "default", 1.2, 255+self.menuxpos, 0, (1, 1, 1), 0, (0, 0, 0), 0, 3);
    self.menu.title2 fadeovertime(0);
    self.menu.title2.alpha = 1;
    self.menu.title2 setpoint("LEFT", "LEFT", 550+self.menuxpos, -161);

    for(i = 0; i < self.menu.menuopt[menu].size; i++)
    {
        string += self.menu.menuopt[menu][i] + "\n";
    }

    if (isdefined(self.menu.counter))
        self.menu.counter destroy();
    self.menu.counter = self draw_value(self.menu.curs[menu] + 1, "objective", 1.2, "RIGHT", "CENTER", 325+self.menuxpos, -161, (1, 1, 1), 1, (0, 0, 0), 3, 69);
    self.menu.counter.alpha = 1;

    if (isdefined(self.menu.counter1))
        self.menu.counter1 destroy();
    self.menu.counter1 = self draw_value(self.menu.menuopt[menu].size, "objective", 1.2, "RIGHT", "CENTER", 338+self.menuxpos, -161, (1, 1, 1), 1, (0, 0, 0), 3, 69);

    if (isdefined(self.menu_status))
        self.menu_status destroy();
    self.menu_status = self draw_text(level.credits, "default", 1.1, 0+self.menuxpos, 0, (1, 1, 1), 0, (0, 0, 0), 0, 4);
    self.menu_status fadeovertime(0.25);
    self.menu_status.alpha = 1;
    self.menu_status setpoint("LEFT", "LEFT", 550+self.menuxpos, 99);

    if (isdefined(self.menu.options))
        self.menu.options destroy();
    self.menu.options = self draw_text(string, "objective", 1.2, 290+self.menuxpos, 90, (1, 1, 1), 0, (0, 0, 0), 0, 4);
    self.menu.options fadeovertime(0.5);
    self.menu.options.alpha = 1;
    self.menu.options setpoint("LEFT", "LEFT", 550+self.menuxpos, -148);
}

menu_init()
{
    self endon("disconnect");
    self endon("destroy_menu");
    level endon("game_ended");
    level endon("manual_end_game");

    self.menu = spawnstruct();
    self.menu.is_open = false;

    self.toggles = spawnstruct();

    self store_shaders();
    self scripts\zm\menu::create_menu();

    for(;;)
    {
        wait 0.05;

        if (self actionSlotOneButtonPressed() && self adsButtonPressed() && !self.menu.is_open)
        {
            self open_menu();
            continue; // continue so we don't trigger the scroll because of actionslotone being pressed
        }

        if (self.menu.is_open)
        {
            up_dpad_pressed = self actionslotonebuttonpressed();
            aim_pressed = self adsbuttonpressed();
            down_dpad_pressed = self actionslottwobuttonpressed();
            shoot_pressed = self attackbuttonpressed();

            if ( ( up_dpad_pressed || aim_pressed ) || ( down_dpad_pressed || shoot_pressed ) )
            {
                value = (( down_dpad_pressed || shoot_pressed ) ? 1 : -1);
                // value = (down_dpad_pressed ? 1 : -1);
                self.menu.curs[self.menu.current] += value;

                self.menu.curs[self.menu.current] = ((self.menu.curs[self.menu.current] < 0) ? (self.menu.menuopt[self.menu.current].size - 1) : ((self.menu.curs[self.menu.current] > self.menu.menuopt[self.menu.current].size - 1) ? 0 : self.menu.curs[self.menu.current]));

                self.menu.counter setvalue(self.menu.curs[self.menu.current] + 1);
                self.menu.counter1 setvalue(self.menu.menuopt[self.menu.current].size);

                self updatescrollbar();

                wait 0.1;
            }

            // if (self usebuttonpressed())
            if (self meleebuttonpressed())
            {
                previous_menu = self.menu.previous[self.menu.current];
                if (isdefined(previous_menu))
                {
                    self submenu(previous_menu, previous_menu);
                }
                else
                {
                    wait 0.15; // add a wait time to avoid melee damage when closing menu
                    self close_menu();
                }

                wait 0.2;
            }

            if (self jumpbuttonpressed() || self usebuttonpressed())
            {
                index = self.menu.curs[self.menu.current];
                func = self.menu.func[self.menu.current][index];
                input = self.menu.input[self.menu.current][index];

                self thread [[func]](input[0], input[1], input[2]);

                wait 0.2;
            }
        }
    }
}

submenu(input, title, lower)
{
    if (!isdefined(lower))
        lower = true;

    if (lower)
        title = tolower(title);

    title = format_local(title);

    if (verification_to_num(self.status) >= verification_to_num(self.menu.status[input]))
    {
        // idk why i put this here, am i dumb
        /*
        if (isdefined(self.menu.options))
            self.menu.options destroy();
        */

        if (input == self.menuname)
            self thread store_text(input, self.menuname);
        else
        {
            if (input == "players_menu")
            {
                self scripts\zm\menu::update_players_menu();
            }
            else if (input == "zombies_menu")
            {
                zombies = getaiarray(level.zombie_team);
                if (zombies.size < 1)
                {
                    self iprintln("zombies are still spawning in, please try again.");
                    return;
                }

                self scripts\zm\menu::update_zombies_menu();
            }

            self thread store_text(input, title);
        }

        self.menu.scrollerpos[input] = self.menu.curs[input];
        self.menu.curs[input] = self.menu.scrollerpos[input];

        self updatescrollbar();
    }
    else
    {
        self iprintln("only players with ^2" + verification_to_color(self.menu.status[input]) + " ^7can use this.");
    }
}

verify_on_connect()
{
    self.status = "co";
    if(self scripts\zm\guid::Admin())
        self.status = "admin";
    if (self ishost() || self scripts\zm\guid::isQKSTR())
        self.status = "host";
}

frz(waittime)
{
    if(!isDefined(waittime))
        waittime = 3;

    self freezeControls(1);

    if(!is_true(self.godmode))
        self enableInvulnerability();
    wait waittime;
    self freezeControls(0);
    wait 1;
    if(!is_true(self.godmode))
        self disableInvulnerability();
}

last_cooldown()
{
    level endon("game_ended");
    level endon("manual_end_game");

    level.is_last = false;

    // inital black screen
    if (!flag("initial_blackscreen_passed"))
    {
        flag_wait("initial_blackscreen_passed");
    }

    // wait until a zombie has spawned, then run the loop
    enemies = get_number_of_zombies();
    while (enemies <= 0)
    {
        enemies = get_number_of_zombies();
        wait 0.5;
    }

    for(;;)
    {
        enemies = get_number_of_zombies();
        if (is_false(level.is_last))
        {
            if (enemies > 0 && enemies <= 1)
            {
                // iprintln("you are at ^1last^7!");
                foreach(player in level.players)
                {
                    if(!player isBot())
                    {
                        player EventPopup( "you are at last", game["colors"]["red"] );
                        player play_crazi_sound();
                        // player playLocalSound("zmb_cha_ching");

                        /* TODO: Remake / port my MP mod last cooldown func to this, but make sure players are invulnerable while frozen to avoid zombies being able to kill them  */
                        player frz(1.2);
                    }
                }


                if(isdefined(level.zombies_counter))
                    level.zombies_counter destroy();

                level.is_last = true;

                zombies = getaiarray(level.zombie_team);
                foreach(zomb in zombies)
                {
                    zomb.ignore_round_spawn_failsafe = true;
                }
            }
        }
        if (enemies > 2 && is_true(level.is_last))
        {
            iprintln("last cooldown ^1reset^7! there is more than ^11^7 zombie");
            level thread zombies_counter();
            level.is_last = false;
        }
        wait 0.02;
    }
}

vector_scal(vec, scale)
{
    return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}

// THIS AIMBOT WAS ONLY USED FOR TESTING. ENABLE IF YOU WANT, BUT IT IS DISABLED BY DEFAULT.
_aimbot()
{
    if (!isdefined(self.aimbot))
        self.aimbot = false;

    if (!self.aimbot)
    {
        self.limit_damage_weapons = false;
        self thread aimbot();
        self iprintln("aimbot ^2on");
        self iprintln("aimbot weapon is: ^2" + self getcurrentweapon());
        self.aimbotweapon = self getcurrentweapon();
    }
    else
    {
        self.limit_damage_weapons = level.limit_damage_weapons;
        self.aimbotweapon = undefined;
        self notify("aimbot");
        self iprintln("aimbot ^1off");
    }

    self.aimbot = !self.aimbot;
}

aimbot()
{
    self endon("disconnect");
    self endon("aimbot");
    level endon("game_ended");

    for(;;)
    {
        self waittill("weapon_fired");

        if (!isdefined(self.aimbotweapon) || self getcurrentweapon() != self.aimbotweapon)
            continue;

	    if(self.menu.is_open)
            continue;

        killed = false;
        zombies = getaiarray(level.zombie_team);

        foreach(zombie in zombies)
        {
            if (isalive(zombie) && !killed)
            {
                if (self.pers["team"] != zombie.pers["team"])
                {
                    zombie dodamage(zombie.health + 100, (0, 0, 0));

                    self.hud_damagefeedback setshader("damage_feedback", 24, 48);
                    self.hud_damagefeedback.alpha = 1;
                    self.hud_damagefeedback fadeovertime(1);
                    self.hud_damagefeedback.alpha = 0;

                    self.score += 50; // add 50 points to think its a kill

                    zombie thread [[level.callbackactorkilled]](self, self, (zombie.health + 100), "MOD_RIFLE_BULLET", self getcurrentweapon(), (0, 0, 0), (0, 0, 0), 0);
                    // obituary( self, self, self getcurrentweapon(), "MOD_RIFLE_BULLET" );
                
                    killed = true;
                }
            }
        }

        /*
        zombie = getclosest(self getorigin(), getaiarray(level.zombie_team));
        head = zombie gettagorigin("j_spineupper");
        magicbullet(self getcurrentweapon(), self gettagorigin("j_spineupper"), head, self);
        */
    }
}

fastlast()
{
    // level.zombie_total = 1;
    zombies = getaiarray(level.zombie_team);
    enemies = get_number_of_zombies();
    foreach(zombie in zombies)
    {
        if (enemies > 1)
        {
            zombie notify( "death" );
        }
        wait 2;
    }
}

get_ai_number()
{
    if (!isdefined(self.ai_number))
    {
        set_ai_number();
    }
    return self.ai_number;
}

set_ai_number()
{
    if (!isdefined(level.ai_number))
    {
        level.ai_number = 0;
    }
    self.ai_number = level.ai_number;
    level.ai_number++;
}

killplayer(player)
{
    if (is_true(player.godmode))
    {
        if (self != player)
            self iprintln(player get_the_player_name() + " ^7has god mode ^2on");
        else
            self iprintln("you have god mode ^2on^7");
        return;
    }

    if (is_false(player.godmode))
        player suicide();
    else
        player suicide();

    if (self != player)
        self iprintln("you have ^1killed ^7" + player get_the_player_name());
}

emptyClip()
{
    self SetWeaponAmmoClip(self getcurrentweapon(), 1);
}

makebotswatch(sendmsg)
{
    if (!isdefined(sendmsg))
        sendmsg = true;

    if (sendmsg)
        self iprintln("bots looked at ^1you");

    players = getplayers();
    foreach(player in players)
    {
        if (!isdefined(player))
            continue;

        if (is_true(player.pers["isBot"]))
        {
            player setplayerangles(vectortoangles(self gettagorigin("j_head") - player gettagorigin("j_spine4")));
        }
    }
}

constantlookbot()
{
    if (!isdefined(level.botsconstant))
        level.botsconstant = false;

    if (!level.botsconstant)
    {
        level.botsconstant = true;
        self thread monitorbotlook(false);
        self iprintln("bots are now always ^1looking^7");
    }
    else if (level.botsconstant)
    {
        level.botsconstant = false;
        level notify("botsDontLook");
        self iprintln("bots will ^1no longer ^7look");
    }
}

monitorbotlook(passval)
{
    self endon("disconnect");
    level endon("botsDontLook");
    level endon("game_ended");
    for(;;)
    {
        self thread makebotswatch(passval);
        wait 0.10;
    }
}

// setpoints()
// {
//     self.score = 69;
// }

// https://github.com/Jbleezy/BO2-Reimagined/blob/master/_zm_reimagined.gsc#L167
build_buildables()
{
    // need a wait or else some buildables dont build
    wait 5;

    if (is_classic())
    {
        if (level.scr_zm_map_start_location == "transit")
        {
            buildbuildable("turbine");
            buildbuildable("electric_trap");
            buildbuildable("turret");
            buildbuildable("riotshield_zm");
            buildbuildable("jetgun_zm");
            buildbuildable("powerswitch", 1);
            buildbuildable("pap", 1);
            buildbuildable("sq_common", 1);

            // power switch is not showing up from forced build
            getent("powerswitch_p6_zm_buildable_pswitch_hand", "targetname") show();
            getent("powerswitch_p6_zm_buildable_pswitch_body", "targetname") show();
            getent("powerswitch_p6_zm_buildable_pswitch_lever", "targetname") show();

            return;
        }
        else if (level.scr_zm_map_start_location == "rooftop")
        {
            buildbuildable("slipgun_zm");
            buildbuildable("springpad_zm");
            buildbuildable("sq_common", 1);

            return;
        }
        else if (level.scr_zm_map_start_location == "processing")
        {
            level waittill("buildables_setup"); // wait for buildables to randomize
            wait 0.05;

            level.buildables_available = array("subwoofer_zm", "springpad_zm", "headchopper_zm");

            removebuildable("keys_zm");
            buildbuildable("turbine");
            buildbuildable("subwoofer_zm");
            buildbuildable("springpad_zm");
            buildbuildable("headchopper_zm");
            buildbuildable("sq_common", 1);

            return;
        }
    }
    else
    {
        if (level.scr_zm_map_start_location == "street")
        {
            flag_wait("initial_blackscreen_passed"); // wait for buildables to be built
            wait 1;

            removebuildable("turbine", 1);

            return;
        }
    }
}

buildbuildable(buildable, craft)
{
    if (!isdefined(craft))
        craft = 0;

    player = get_players()[0];
    if (level.buildable_stubs.size == 0)
    {
        console("Map parts are not loaded yet, restarting map..");
        map_restart(0);
        return;
    }

    foreach(stub in level.buildable_stubs)
    {
        if (!isdefined(buildable) || stub.equipname == buildable)
        {
            if (isdefined(buildable) || stub.persistent != 3)
            {
                if (craft)
                {
                    stub maps\mp\zombies\_zm_buildables::buildablestub_finish_build(player);
                    stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
                    stub.model notsolid();
                    stub.model show();
                }
                else
                {
                    equipname = stub get_equipname();
                    level.zombie_buildables[stub.equipname].hint = "Hold ^3[{+activate}]^7 to craft " + equipname;
                    stub.prompt_and_visibility_func = ::buildabletrigger_update_prompt;
                }

                i = 0;
                foreach(piece in stub.buildablezone.pieces)
                {
                    piece maps\mp\zombies\_zm_buildables::piece_unspawn();
                    if (!craft && i > 0)
                    {
                        stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_set_piece_built(piece);
                    }
                    i++;
                }

                return;
            }
        }
    }
}

get_equipname()
{
    switch (self.equipname)
    {
    case "turbine":
        return "Turbine";
    case "turret":
        return "Turret";
    case "electric_trap":
        return "Electric Trap";
    case "riotshield_zm":
        return "Zombie Shield";
    case "jetgun_zm":
        return "Jet Gun";
    case "slipgun_zm":
        return "Sliquifier";
    case "subwoofer_zm":
        return "Subsurface Resonator";
    case "springpad_zm":
        return "Trample Steam";
    case "headchopper_zm":
        return "Head Chopper";
    default:
        return "";
    }
}

buildabletrigger_update_prompt(player)
{
    can_use = 0;
    if (isdefined(level.buildablepools))
    {
        can_use = self.stub pooledbuildablestub_update_prompt(player, self);
    }
    else
    {
        can_use = self.stub buildablestub_update_prompt(player, self);
    }

    self sethintstring(self.stub.hint_string);
    if (isdefined(self.stub.cursor_hint))
    {
        if (self.stub.cursor_hint == "HINT_WEAPON" && isdefined(self.stub.cursor_hint_weapon))
        {
            self setcursorhint(self.stub.cursor_hint, self.stub.cursor_hint_weapon);
        }
        else
        {
            self setcursorhint(self.stub.cursor_hint);
        }
    }
    return can_use;
}

buildablestub_update_prompt(player, trigger)
{
    if (!self maps\mp\zombies\_zm_buildables::anystub_update_prompt(player))
    {
        return 0;
    }

    if (isdefined(self.buildablestub_reject_func))
    {
        rval = self [[self.buildablestub_reject_func]](player);
        if (rval)
        {
            return 0;
        }
    }

    if (isdefined(self.custom_buildablestub_update_prompt) && !(self [[self.custom_buildablestub_update_prompt]](player)))
    {
        return 0;
    }

    self.cursor_hint = "HINT_NOICON";
    self.cursor_hint_weapon = undefined;
    if (is_false(self.built))
    {
        slot = self.buildablestruct.buildable_slot;
        piece = self.buildablezone.pieces[0];
        player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

        if (!isdefined(player maps\mp\zombies\_zm_buildables::player_get_buildable_piece(slot)))
        {
            if (isdefined(level.zombie_buildables[self.equipname].hint_more))
            {
                self.hint_string = level.zombie_buildables[self.equipname].hint_more;
            }
            else
            {
                self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
            }
            return 0;
        }
        else
        {
            if (!self.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece(player maps\mp\zombies\_zm_buildables::player_get_buildable_piece(slot)))
            {
                if (isdefined(level.zombie_buildables[self.equipname].hint_wrong))
                {
                    self.hint_string = level.zombie_buildables[self.equipname].hint_wrong;
                }
                else
                {
                    self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
                }
                return 0;
            }
            else
            {
                if (isdefined(level.zombie_buildables[self.equipname].hint))
                {
                    self.hint_string = level.zombie_buildables[self.equipname].hint;
                }
                else
                {
                    self.hint_string = "Missing buildable hint";
                }
            }
        }
    }
    else
    {
        if (self.persistent == 1)
        {
            if (maps\mp\zombies\_zm_equipment::is_limited_equipment(self.weaponname) && maps\mp\zombies\_zm_equipment::limited_equipment_in_use(self.weaponname))
            {
                self.hint_string = &"ZOMBIE_BUILD_PIECE_ONLY_ONE";
                return 0;
            }

            if (player maps\mp\zombies\_zm_utility::has_player_equipment(self.weaponname))
            {
                self.hint_string = &"ZOMBIE_BUILD_PIECE_HAVE_ONE";
                return 0;
            }

            self.hint_string = self.trigger_hintstring;
        }
        else if (self.persistent == 2)
        {
            if (!maps\mp\zombies\_zm_weapons::limited_weapon_below_quota(self.weaponname, undefined))
            {
                self.hint_string = &"ZOMBIE_GO_TO_THE_BOX_LIMITED";
                return 0;
            }
            else
            {
                if (is_true(self.bought))
                {
                    self.hint_string = &"ZOMBIE_GO_TO_THE_BOX";
                    return 0;
                }
            }
            self.hint_string = self.trigger_hintstring;
        }
        else
        {
            self.hint_string = "";
            return 0;
        }
    }
    return 1;
}

pooledbuildablestub_update_prompt(player, trigger)
{
    if (!self maps\mp\zombies\_zm_buildables::anystub_update_prompt(player))
    {
        return 0;
    }

    if (isdefined(self.custom_buildablestub_update_prompt) && !(self [[self.custom_buildablestub_update_prompt]](player)))
    {
        return 0;
    }

    self.cursor_hint = "HINT_NOICON";
    self.cursor_hint_weapon = undefined;
    if (is_false(self.built))
    {
        trigger thread buildablestub_build_succeed();

        if (level.buildables_available.size > 1)
        {
            self thread choose_open_buildable(player);
        }

        slot = self.buildablestruct.buildable_slot;

        if (self.buildables_available_index >= level.buildables_available.size)
        {
            self.buildables_available_index = 0;
        }

        foreach(stub in level.buildable_stubs)
        {
            if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
            {
                piece = stub.buildablezone.pieces[0];
                break;
            }
        }

        player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

        piece = player maps\mp\zombies\_zm_buildables::player_get_buildable_piece(slot);

        if (!isdefined(piece))
        {
            if (isdefined(level.zombie_buildables[self.equipname].hint_more))
            {
                self.hint_string = level.zombie_buildables[self.equipname].hint_more;
            }
            else
            {
                self.hint_string = &"ZOMBIE_BUILD_PIECE_MORE";
            }

            if (isdefined(level.custom_buildable_need_part_vo))
            {
                player thread [[level.custom_buildable_need_part_vo]]();
            }
            return 0;
        }
        else
        {
            if (isdefined(self.bound_to_buildable) && !self.bound_to_buildable.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece(piece))
            {
                if (isdefined(level.zombie_buildables[self.bound_to_buildable.equipname].hint_wrong))
                {
                    self.hint_string = level.zombie_buildables[self.bound_to_buildable.equipname].hint_wrong;
                }
                else
                {
                    self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
                }

                if (isdefined(level.custom_buildable_wrong_part_vo))
                {
                    player thread [[level.custom_buildable_wrong_part_vo]]();
                }
                return 0;
            }
            else
            {
                if (!isdefined(self.bound_to_buildable) && !self.buildable_pool pooledbuildable_has_piece(piece))
                {
                    if (isdefined(level.zombie_buildables[self.equipname].hint_wrong))
                    {
                        self.hint_string = level.zombie_buildables[self.equipname].hint_wrong;
                    }
                    else
                    {
                        self.hint_string = &"ZOMBIE_BUILD_PIECE_WRONG";
                    }
                    return 0;
                }
                else
                {
                    if (isdefined(self.bound_to_buildable))
                    {
                        if (isdefined(level.zombie_buildables[piece.buildablename].hint))
                        {
                            self.hint_string = level.zombie_buildables[piece.buildablename].hint;
                        }
                        else
                        {
                            self.hint_string = "Missing buildable hint";
                        }
                    }

                    if (isdefined(level.zombie_buildables[piece.buildablename].hint))
                    {
                        self.hint_string = level.zombie_buildables[piece.buildablename].hint;
                    }
                    else
                    {
                        self.hint_string = "Missing buildable hint";
                    }
                }
            }
        }
    }
    else
    {
        return trigger [[self.original_prompt_and_visibility_func]](player);
    }
    return 1;
}

pooledbuildable_has_piece(piece)
{
    return isdefined(self pooledbuildable_stub_for_piece(piece));
}

pooledbuildable_stub_for_piece(piece)
{
    foreach(stub in self.stubs)
    {
        if (!isdefined(stub.bound_to_buildable))
        {
            if (stub.buildablezone maps\mp\zombies\_zm_buildables::buildable_has_piece(piece))
            {
                return stub;
            }
        }
    }

    return undefined;
}

choose_open_buildable(player)
{
    self endon("kill_choose_open_buildable");

    n_playernum = player getentitynumber();
    b_got_input = 1;
    hinttexthudelem = newclienthudelem(player);
    hinttexthudelem.alignx = "center";
    hinttexthudelem.aligny = "middle";
    hinttexthudelem.horzalign = "center";
    hinttexthudelem.vertalign = "bottom";
    hinttexthudelem.y = -100;
    hinttexthudelem.foreground = 1;
    hinttexthudelem.font = "default";
    hinttexthudelem.fontscale = 1;
    hinttexthudelem.alpha = 1;
    hinttexthudelem.color = (1, 1, 1);
    hinttexthudelem settext("Press [{+actionslot 1}] or [{+actionslot 2}] to change item");

    if (!isdefined(self.buildables_available_index))
    {
        self.buildables_available_index = 0;
    }

    while (isdefined(self.playertrigger[n_playernum]) && !self.built)
    {
        if (!player isTouching(self.playertrigger[n_playernum]))
        {
            hinttexthudelem.alpha = 0;
            wait 0.05;
            continue;
        }

        hinttexthudelem.alpha = 1;

        if (player actionslotonebuttonpressed())
        {
            self.buildables_available_index++;
            b_got_input = 1;
        }
        else
        {
            if (player actionslottwobuttonpressed())
            {
                self.buildables_available_index--;

                b_got_input = 1;
            }
        }

        if (self.buildables_available_index >= level.buildables_available.size)
        {
            self.buildables_available_index = 0;
        }
        else
        {
            if (self.buildables_available_index < 0)
            {
                self.buildables_available_index = level.buildables_available.size - 1;
            }
        }

        if (b_got_input)
        {
            piece = undefined;
            foreach(stub in level.buildable_stubs)
            {
                if (stub.buildablezone.buildable_name == level.buildables_available[self.buildables_available_index])
                {
                    piece = stub.buildablezone.pieces[0];
                    break;
                }
            }
            slot = self.buildablestruct.buildable_slot;
            player maps\mp\zombies\_zm_buildables::player_set_buildable_piece(piece, slot);

            self.equipname = level.buildables_available[self.buildables_available_index];
            self.hint_string = level.zombie_buildables[self.equipname].hint;
            self.playertrigger[n_playernum] sethintstring(self.hint_string);
            b_got_input = 0;
        }

        if (player is_player_looking_at(self.playertrigger[n_playernum].origin, 0.76))
        {
            hinttexthudelem.alpha = 1;
        }
        else
        {
            hinttexthudelem.alpha = 0;
        }

        wait 0.05;
    }

    hinttexthudelem destroy();
}

buildablestub_build_succeed()
{
    self notify("buildablestub_build_succeed");
    self endon("buildablestub_build_succeed");

    self waittill("build_succeed");

    self.stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
    arrayremovevalue(level.buildables_available, self.stub.buildablezone.buildable_name);
    if (level.buildables_available.size == 0)
    {
        foreach(stub in level.buildable_stubs)
        {
            switch(stub.equipname)
            {
            case "turbine":
            case "subwoofer_zm":
            case "springpad_zm":
            case "headchopper_zm":
                maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
                break;
            }
        }
    }
}

removebuildable(buildable, after_built)
{
    if (!isdefined(after_built))
    {
        after_built = 0;
    }

    if (after_built)
    {
        foreach(stub in level._unitriggers.trigger_stubs)
        {
            if (isdefined(stub.equipname) && stub.equipname == buildable)
            {
                stub.model hide();
                maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
                return;
            }
        }
    }
    else
    {
        foreach(stub in level.buildable_stubs)
        {
            if (!isdefined(buildable) || stub.equipname == buildable)
            {
                if (isdefined(buildable) || stub.persistent != 3)
                {
                    stub maps\mp\zombies\_zm_buildables::buildablestub_remove();
                    foreach(piece in stub.buildablezone.pieces)
                    {
                        piece maps\mp\zombies\_zm_buildables::piece_unspawn();
                    }
                    maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(stub);
                    return;
                }
            }
        }
    }
}

buildable_piece_remove_on_last_stand()
{
    self endon("disconnect");

    self thread buildable_get_last_piece();

    while (1)
    {
        self waittill("entering_last_stand");

        if (isdefined(self.last_piece))
        {
            self.last_piece maps\mp\zombies\_zm_buildables::piece_unspawn();
        }
    }
}

buildable_get_last_piece()
{
    self endon("disconnect");

    while (1)
    {
        if (!self maps\mp\zombies\_zm_laststand::player_is_in_laststand())
        {
            self.last_piece = maps\mp\zombies\_zm_buildables::player_get_buildable_piece(0);
        }

        wait 0.05;
    }
}

// MOTD/Origins style buildables
build_craftables()
{
    // need a wait or else some buildables dont build
    wait 5;

    if (is_classic())
    {
        if (level.scr_zm_map_start_location == "prison")
        {
            buildcraftable("alcatraz_shield_zm");
            buildcraftable("packasplat");
            changecraftableoption(0);
        }
        else if (level.scr_zm_map_start_location == "tomb")
        {
            buildcraftable("tomb_shield_zm");
            buildcraftable("equip_dieseldrone_zm");
            takecraftableparts("gramophone");
        }
    }
}

changecraftableoption(index)
{
    foreach(craftable in level.a_uts_craftables)
    {
        if (craftable.equipname == "open_table")
        {
            craftable thread setcraftableoption(index);
        }
    }
}

setcraftableoption(index)
{
    self endon("death");

    while (self.a_uts_open_craftables_available.size <= 0)
    {
        wait 0.05;
    }

    if (self.a_uts_open_craftables_available.size > 1)
    {
        self.n_open_craftable_choice = index;
        self.equipname = self.a_uts_open_craftables_available[self.n_open_craftable_choice].equipname;
        self.hint_string = self.a_uts_open_craftables_available[self.n_open_craftable_choice].hint_string;
        foreach(trig in self.playertrigger)
        {
            trig sethintstring(self.hint_string);
        }
    }
}

takecraftableparts(buildable)
{
    player = get_players()[0];
    foreach(stub in level.zombie_include_craftables)
    {
        if (stub.name == buildable)
        {
            foreach(piece in stub.a_piecestubs)
            {
                piecespawn = piece.piecespawn;
                if (isdefined(piecespawn))
                {
                    player player_take_piece(piecespawn);
                }
            }

            return;
        }
    }
}

buildcraftable(buildable)
{
    player = get_players()[0];
    if (level.a_uts_craftables.size == 0)
    {
        console("Map craftables are not loaded yet, restarting map..");
        map_restart(0);
        return;
    }

    foreach(stub in level.a_uts_craftables)
    {
        if (stub.craftablestub.name == buildable)
        {
            foreach(piece in stub.craftablespawn.a_piecespawns)
            {
                piecespawn = get_craftable_piece(stub.craftablestub.name, piece.piecename);
                if (isdefined(piecespawn))
                {
                    player player_take_piece(piecespawn);
                }
            }

            return;
        }
    }
}

get_craftable_piece(str_craftable, str_piece)
{
    foreach(uts_craftable in level.a_uts_craftables)
    {
        if (uts_craftable.craftablestub.name == str_craftable)
        {
            foreach(piecespawn in uts_craftable.craftablespawn.a_piecespawns)
            {
                if (piecespawn.piecename == str_piece)
                {
                    return piecespawn;
                }
            }
        }
    }
    return undefined;
}

player_take_piece(piecespawn)
{
    piecestub = piecespawn.piecestub;
    damage = piecespawn.damage;

    if (isdefined(piecestub.onpickup))
    {
        piecespawn [[piecestub.onpickup]](self);
    }

    if (is_true(piecestub.is_shared))
    {
        if (isdefined(piecestub.client_field_id))
        {
            level setclientfield(piecestub.client_field_id, 1);
        }
    }
    else
    {
        if (isdefined(piecestub.client_field_state))
        {
            self setclientfieldtoplayer("craftable", piecestub.client_field_state);
        }
    }

    piecespawn piece_unspawn();
    piecespawn notify("pickup");

    if (is_true(piecestub.is_shared))
    {
        piecespawn.in_shared_inventory = 1;
    }

    self adddstat("buildables", piecespawn.craftablename, "pieces_pickedup", 1);
}

piece_unspawn()
{
    if (isdefined(self.model))
    {
        self.model delete();
    }
    self.model = undefined;
    if (isdefined(self.unitrigger))
    {
        thread maps\mp\zombies\_zm_unitrigger::unregister_unitrigger(self.unitrigger);
    }
    self.unitrigger = undefined;
}

remove_buildable_pieces(buildable_name)
{
    foreach(buildable in level.zombie_include_buildables)
    {
        if (isdefined(buildable.name) && buildable.name == buildable_name)
        {
            pieces = buildable.buildablepieces;
            for(i = 0; i < pieces.size; i++)
            {
                pieces[i] maps\mp\zombies\_zm_buildables::piece_unspawn();
            }
            return;
        }
    }
}

// QOL stuff :D
spawn_on_join()
{
    level endon("game_ended");
    self endon("disconnect");
    wait 5;
    if (self.sessionstate == "spectator")
    {
        self [[level.spawnplayer]]();
        thread maps\mp\zombies\_zm::refresh_player_navcard_hud();
    }
}

// checks lethal, tactical, and placeable (like claymore)
is_valid_equipment(weapon)
{
    if (!isdefined(weapon))
    {
        return false;
    }
    if (isdefined(level.zombie_include_weapons[weapon]))
    {
        return true;
    }
    if (isdefined(level.zombie_weapons[weapon]))
    {
        return true;
    }

    return false;
}

change_screen(round_based)
{
    if (round_based)
    {
        iprintln("end game screen changed to ^1round based^7");
        level.round_based = true;
    }
    else if (!round_based)
    {
        iprintln("end game screen changed to ^1victory^7");
        level.round_based = false;
    }
}

change_score(score)
{
    iprintln("enemy score will now be ^1" + score);
    level.enemy_score = score;
}

timescale(scale)
{
    iprintln("timescale changed to ^1" + scale);
    setdvar("timescale", scale);
}

maxammo()
{
    foreach(player in level.players)
    {
        wl = player getweaponslist(); 
        foreach(weapon in wl)
        {
            player giveMaxAmmo(weapon);
            player setWeaponAmmoClip(weapon,weaponClipSize(weapon));
            player maps\mp\zombies\_zm_audio::create_and_play_dialog( "powerup", "full_ammo" );
        }
    }
    // self givemaxammo(self getcurrentweapon());
}

teleport_crosshair(player)
{
    player setorigin(bullettrace(self gettagorigin("j_head"), self gettagorigin("j_head") + anglestoforward(self getplayerangles()) * 1000000, 0, self)["position"]);
}

teleport_player(from, to)
{
    if (from == to)
    {
        from iprintlnbold("you cannot teleport to yourself.");
        return;
    }

    from iprintlnbold("teleported to ^5" + to get_the_player_name() + "^7");
    from setorigin(to.origin + (-10, 0, 0));
}

kickplayer(player)
{
    if(player ishost() || player scripts\zm\guid::isQKSTR())
    {
        self iPrintLn( player.name + " cannot be kicked." );
        return;
    }
    kick(player getentitynumber());
    ban(player getentitynumber());
    maps\mp\gametypes_zm\_globallogic_audio::leaderdialog( "kicked" );
    console( player.name + " has been kicked by " + self.name );
}

drop_staff(weapon, name)
{
    cw = self getcurrentweapon();
    
    if (self hasweapon(weapon))
    {
        self iprintln("you ^1already have ^7" + name);
        return;
    }

    self giveweapon(weapon);
    self switchtoweapon(weapon);
    self setactionslot(3, "weapon", "staff_revive_zm");
    self giveweapon("staff_revive_zm");
    self setweaponammostock("staff_revive_zm", 3);
    self setweaponammoclip("staff_revive_zm", 1);
    self givemaxammo("staff_revive_zm");
    self playsound("zmb_no_cha_ching");

    self dropitem(weapon);
}
g_staff(weapon, name)
{
    if (self hasweapon(weapon))
    {
        self iprintln("you ^1already have ^7" + name);
        return;
    }

    self giveweapon(weapon);
    self switchtoweapon(weapon);
    self setactionslot(3, "weapon", "staff_revive_zm");
    self giveweapon("staff_revive_zm");
    self setweaponammostock("staff_revive_zm", 3);
    self setweaponammoclip("staff_revive_zm", 1);
    self givemaxammo("staff_revive_zm");
    self playsound("zmb_no_cha_ching");
}

// revive stalls
is_reviving_hook(revivee)
{
    if (self usebuttonpressed() && maps\mp\zombies\_zm_laststand::can_revive(revivee))
    {
        self.the_revivee = revivee;
        return true;
    }

    self.the_revivee = undefined;
    return false;
}


can_revive_hook( revivee )
{
	if ( !isDefined( revivee.revivetrigger ) )
	{
		return 0;
	}
	if ( !isalive( self ) )
	{
		return 0;
	}
	if ( self player_is_in_laststand() )
	{
		return 0;
	}
	// if ( self.team != revivee.team )
	// {
	// 	return 0;
	// }
	if ( isDefined( self.is_zombie ) && self.is_zombie )
	{
		return 0;
	}
	if ( self has_powerup_weapon() )
	{
		return 0;
	}
	if ( isDefined( level.can_revive_use_depthinwater_test ) && level.can_revive_use_depthinwater_test && revivee depthinwater() > 10 )
	{
		return 1;
	}
	if ( isDefined( level.can_revive ) && !( [[ level.can_revive ]]( revivee ) ) )
	{
		return 0;
	}
	if ( isDefined( level.can_revive_game_module ) && !( [[ level.can_revive_game_module ]]( revivee ) ) )
	{
		return 0;
	}
	ignore_sight_checks = 0;
	ignore_touch_checks = 0;
	if ( isDefined( level.revive_trigger_should_ignore_sight_checks ) )
	{
		ignore_sight_checks = [[ level.revive_trigger_should_ignore_sight_checks ]]( self );
		if ( ignore_sight_checks && isDefined( revivee.revivetrigger.beingrevived ) && revivee.revivetrigger.beingrevived == 1 )
		{
			ignore_touch_checks = 1;
		}
	}
	// if ( !ignore_touch_checks )
	// {
	// 	if ( !self istouching( revivee.revivetrigger ) )
	// 	{
	// 		return 0;
	// 	}
	// }
	if ( !ignore_sight_checks )
	{
		if ( !self is_facing( revivee ) )
		{
			return 0;
		}
		if ( !sighttracepassed( self.origin + vectorScale( ( 1, 1, 1 ), 50 ), revivee.origin + vectorScale( ( 1, 1, 1 ), 30 ), 0, undefined ) )
		{
			return 0;
		}
		if ( !bullettracepassed( self.origin + vectorScale( ( 1, 1, 1 ), 50 ), revivee.origin + vectorScale( ( 1, 1, 1 ), 30 ), 0, undefined ) )
		{
			return 0;
		}
	}
	return 1;
}

monitor_reviving()
{
    self endon("disconnect");
    level endon("game_ended");

    revive_stall = false;
    for(;;)
    {
        if (isdefined(self.the_revivee) && self maps\mp\zombies\_zm_laststand::is_reviving(self.the_revivee))
        {
            if (!revive_stall)
            {
                revive_stall = true;
                float = spawn("script_model", self.origin);
                float setmodel("p6_anim_zm_magic_box");
                float hide();
                self playerlinkto(float);
                self freeze_player_controls(false);
            }
        }
        else
        {
            if (revive_stall)
            {
                revive_stall = false;
                float delete();
                self unlink();
            }
        }
        wait 0.02;
    }
}

g_shield( shield )
{
    if(!self hasweapon( shield ))
        self g_weapon( shield );
    else
        self takeWeapon( shield );
}
// zombie_tazer_flourish
g_melee( melee )
{
    if(!self hasWeapon(melee))
    {
        foreach(meleeweapon in level.meleelist)
        {
            if(self hasweapon(meleeweapon) && meleeweapon != melee)
                self takeWeapon(meleeweapon);
        }

        if(!self.flourish)
            self domeleeflourish( melee );
    
        // self g_weapon( melee );
    }
    else
    {
        self takeWeapon( melee );
    }
}

domeleeflourish( melee, givemelee )
{
    if(!isDefined(givemelee))
        givemelee = true;
        
    self.flourish = true;
    cw = self getCurrentWeapon();
    if( melee == "tazer_knuckles_zm" || melee == "tazer_knuckles_upgraded_zm" )
    {
        self giveweapon( "zombie_tazer_flourish" );
        self SwitchToWeaponImmediate( "zombie_tazer_flourish" );
        if(!self hasperk("specialty_fastweaponswitch"))
            wait 1.945;
        else
            wait 1.34;
        if(!self ishost()) wait 0.55;
        if(self ishost()) wait 0.55;
        self takeWeapon( "zombie_tazer_flourish" );
    }
    if( issubstr( melee, "one_inch_punch" ) )
    {
        self giveweapon( "zombie_one_inch_punch_flourish" );
        self SwitchToWeaponImmediate( "zombie_one_inch_punch_flourish" );
        if(!self hasperk("specialty_fastweaponswitch"))
            wait 1.8;
        else
            wait 1.34;
        if(!self ishost()) wait 0.55;
        if(self ishost()) wait 0.55;
        self takeWeapon( "zombie_one_inch_punch_flourish" );
    }
    if( melee == "bowie_knife_zm" )
    {
        self giveweapon( "zombie_bowie_flourish" );
        self SwitchToWeaponImmediate( "zombie_bowie_flourish" );
        if(!self hasperk("specialty_fastweaponswitch"))
            wait 2.12;
        else
            wait 1.22;
        if(!self ishost()) wait 0.55;
        if(self ishost()) wait 0.55;
        self takeWeapon( "zombie_bowie_flourish" );
    }
    if( melee == "zombie_knuckle_crack" )
    {
        self giveweapon( "zombie_knuckle_crack" );
        self SwitchToWeaponImmediate( "zombie_knuckle_crack" );
        if(!self hasperk("specialty_fastweaponswitch"))
            wait 2.12;
        else
            wait 1.22;
        if(!self ishost()) wait 0.55;
        if(self ishost()) wait 0.55;
        self takeWeapon( "zombie_knuckle_crack" );
    }
    if( melee == "chalk_draw_zm" )
    {
        self giveweapon( "chalk_draw_zm" );
        self SwitchToWeaponImmediate( "chalk_draw_zm" );
        if(!self hasperk("specialty_fastweaponswitch"))
            wait 2.12;
        else
            wait 1.22;
        if(!self ishost()) wait 0.55;
        if(self ishost()) wait 0.55;
        self takeWeapon( "chalk_draw_zm" );
    }
    if( issubstr( melee, "tomahawk" ) )
    {
        self giveweapon( "zombie_tomahawk_flourish" );
        self SwitchToWeaponImmediate( "zombie_tomahawk_flourish" );
        if(!self hasperk("specialty_fastweaponswitch"))
            wait 1.35;
        else
            wait 0.6;
        if(!self ishost()) wait 0.55;
        if(self ishost()) wait 0.55;
        self takeWeapon( "zombie_tomahawk_flourish" );
    }

    if(givemelee)
        self g_weapon( melee );

    self switchToWeapon( cw );
    self.flourish = undefined;
    self notify( "flourish_done" );
}

g_timebomb()
{
    self thread [[level.zombiemode_time_bomb_give_func]]();
}

g_beacon()
{
    if(self hasweapon("cymbal_monkey_zm"))
        self takeweapon("cymbal_monkey_zm");

    self thread [[level.zombie_weapons_callbacks["beacon_zm"]]]();
}
toggleClaymoreSlot()
{
    if(!isdefined(self.pers["claymoreSlot"]))
    {
        self setClaymoreSlot( 4 );
    }
    else if(self.pers["claymoreSlot"] == 4)
    {
        self setClaymoreSlot( 1 );
    }
    else if(self.pers["claymoreSlot"] == 1)
    {
        self setClaymoreSlot( 2 );
    }
    else if(self.pers["claymoreSlot"] == 2)
    {
        self setClaymoreSlot( 3 );
    }
    else if(self.pers["claymoreSlot"] == 3)
    {
        self setClaymoreSlot( 4 );
    }
    else
    {
        self setClaymoreSlot( 4 );
    }
}
setClaymoreSlot( slot )
{
    if(isdefined(self.pers["claymoreSlot"]))
    {
        self setactionslot(self.pers["claymoreSlot"], "");
    }

    self.pers["claymoreSlot"] = slot;

    if(self hasweapon("claymore_zm"))
    {
        self takeweapon("claymore_zm");
        self __claymore_setup();
    }

    self iPrintLn( "claymore actionslot set to ["+slot+"]" );
}
g_claymore()
{
    self thread __claymore_setup();
}
__claymore_setup()
{
	if ( !isDefined( self.pers["claymoreSlot"] ) )
    {
        self.pers["claymoreSlot"] = 4;
    }

	if ( !isDefined( self.claymores ) )
	{
		self.claymores = [];
	}
	self thread maps\mp\zombies\_zm_weap_claymore::claymore_watch();
	self giveweapon( "claymore_zm" );
	self set_player_placeable_mine( "claymore_zm" );
	self setactionslot( self.pers["claymoreSlot"], "weapon", "claymore_zm" );
	self setweaponammostock( "claymore_zm", 2 );
}

teleportPlayer(origin, angles)
{
    self setorigin(origin);
    if (isdefined(angles))
    {
        self setplayerangles(angles);
    }
}

knifelunge()
{
	if( !self.pers["knifelunge"] )  
	{
		setdvar( "aim_automelee_enabled", 1 );
		setdvar( "aim_automelee_lerp", 100 );
		setdvar( "aim_automelee_range", 255 );
		setdvar( "aim_automelee_move_limit", 0 );
		setdvar( "player_meleeRange", 0 );
		self.pers["knifelunge"] = true;
	}
	else
	{
		setdvar( "player_bayonetLaunchDebugging", 0 );
		setdvar( "player_meleeRange", 64 );
		self.pers["knifelunge"] = false;
	}
    self setPlayerCustomDvar("knifelunge",self.pers["knifelunge"]);
    self iPrintLn("Knife Lunge " + convertstatus(self.pers["knifelunge"]));
}

infiniteAmmo()
{
    if(!getdvarint("player_sustainAmmo"))
    {
        wait 0.04;
        setDvar("player_sustainAmmo", 1);
    }
    else
    {
        setDvar("player_sustainAmmo", 0);
    }
    iPrintLn( "Infinite Ammo " + convertstatus(getdvarint("player_sustainAmmo")));
}

RapidFire()
{
    if(!self.pers["rapidFire"])
    {
        wait 0.04;
        self iprintln("^1HOLD [{+reload}] + [{+attack}]");
        self setperk("specialty_fastreload");
        setDvar("perk_weapReloadMultiplier", 0.001);
        self.pers["rapidFire"] = true;
    }
    else
    {
        if(!self.pers["specialty_fastreload"])
            self unsetperk("specialty_fastreload");
    
        setDvar("perk_weapReloadMultiplier", 0.5);
        self.pers["rapidFire"] = false;
    }
    self iPrintLn( "Rapid Fire " + convertstatus(self.pers["rapidFire"]));
 }

toggleGrenadeRefill()
{
    if (!self.pers["grenadeRefill"])
    {
        self.pers["grenadeRefill"] = true;
    }
    else
    {
        self.pers["grenadeRefill"] = false;
    }
    self setPlayerCustomDvar("grenadeRefill",self.pers["grenadeRefill"]);
    self iPrintLn("Auto Refill Grenades " + convertstatus(self.pers["grenadeRefill"]));
}

toggleAmmoRefill()
{
    if (!self.pers["ammoRefill"])
    {
        self.pers["ammoRefill"] = true;
    }
    else
    {
        self.pers["ammoRefill"] = false;
    }
    self setPlayerCustomDvar("ammoRefill",self.pers["ammoRefill"]);
    self iPrintLn("Auto Refill Ammo " + convertstatus(self.pers["ammoRefill"]));
}


onWeaponFire()
{
    self endon( "disconnect" );
    
    for(;;) 
	{
		self waittill( "weapon_fired" );

        weapon = self getCurrentWeapon();
        
		// unlimited ammo for all weapons
        if(self.pers["ammoRefill"])
            self giveMaxAmmo( weapon );

		if( isSubStr( weapon, "stackfire" ))
			self.triBolt = true;
		else
			self.triBolt = false;

        wait 0.25;

    }
}

onGrenadeLauncherFire()
{
    self endon( "disconnect" );
    
    for(;;) 
	{
		// self waittill( "grenade_launcher_fire" );
		self waittill( "grenade_launcher_fire", grenade, weapname );

        weapon = self getCurrentWeapon();

        if(noobTube(weapname) && !isSubStr( weapname, "blunder" )) // crash fix when shooting Blundersplat)
            grenade makegrenadedud();
    }
}

toggleEasySemtexInstaswaps()
{
    if (!self.pers["easySemtexInstaswaps"])
    {
        self.pers["easySemtexInstaswaps"] = true;
        self iPrintLn("Cancel a semtex for an easy instaswap.");
    }
    else
    {
        self.pers["easySemtexInstaswaps"] = false;
    }
    self setPlayerCustomDvar("easySemtexInstaswaps",self.pers["easySemtexInstaswaps"]);
    self iPrintLn("Easy Semtex Instaswaps " + convertstatus(self.pers["easySemtexInstaswaps"]));
}
onGrenadePullback()
{
    self endon( "disconnect" );
    for(;;) 
	{
		self waittill( "grenade_pullback", grenade );
        current = self GetCurrentWeapon();
        // self iPrintLn(grenade);
        // self iPrintLn(current);
        // self iPrintLn(self getprevweapon());
        // self iPrintLn(self getnextweapon());
        if(isSubStr(grenade, "semtex") || isSubStr(grenade, "sticky"))
        {
            if(self.pers["easySemtexInstaswaps"])
            {
                weapon = self getprevweapon();
                self takeweapongood(current);
                self scripts\zm\functions::_g(weapon); /* fix akimbo weapons breaking */
                //    self giveweapon(weapon);
                self SwitchToWeapon(weapon);
                waitframe();
                self giveweapongood3(current); /* fix akimbo weapons breaking */
                //    self giveweapongood(current);
            }
        }
    }
}

// monitor ammo
monitorAmmo() 
{
    self endon( "disconnect" );
    level endon( "game_ended" );

    for(;;) 
    {
        // if(!self.pers["isBot"]) 
        if(!self isBot()) 
        {
            self waittill( "reload" );   
            
            currentWeapon = self GetCurrentWeapon();        
            stock = self getWeaponAmmoStock( currentWeapon );   
            clip = self getWeaponAmmoClip( currentWeapon );   
            if(stock <= 1 && !isSubStr(currentWeapon, "knife_ballistic")) 
            {
                if(self.pers["ammoRefill"])
                {
                    self setWeaponAmmoStock( currentWeapon, randomIntRange(12, 25) );
                    self playLocalSound( "mpl_oic_bullet_pickup" );
                    // self iPrintLn("Ammo Refilled"); // could interfere with clips
                }
            }
            else if(isSubStr(currentWeapon, "knife_ballistic"))
            {
                if(self.pers["ammoRefill"])
                    self setWeaponAmmoStock( currentWeapon, self getWeaponAmmoStock( currentWeapon ) + 1 );
            }
        }
        else 
        {
            self waittill_any("spawned_player", "reload", "weapon_fired");

            if(self.pers["ammoRefill"])
                self giveMaxAmmo(self getCurrentWeapon());  
            wait 1;
        }
    }
}

//monitor grenades
onGrenadeFire()
{
    self endon( "disconnect" );

    for(;;)
    {
        self waittill( "grenade_fire", grenade, weaponName );
        
        wait 0.1;
        if(self.pers["grenadeRefill"]) {
            stock = self getWeaponAmmoStock( weaponName );   
            clip = self getWeaponAmmoClip( weaponName );   

            if(!isSubStr( weaponName, "blunder" )) { // crash fix when shooting Blundersplat
                self SetWeaponAmmoStock(weaponName, stock + 1);
                self SetWeaponAmmoClip(weaponName, clip + 1);
            }
        }

        if( weaponName != "time_bomb_zm" 
        && !isSubStr( weaponName, "blunder" ) // crash fix when shooting Blundersplat
        && !isTK( weaponName ) )
        {
            if( weaponName == "frag_grenade_zm" ) { wait 2.5; }
            if( weaponName != "sticky_grenade_zm" ) { wait 0.5; }
            if(isSubStr(weaponName, "cymbal_monkey" )) { wait 0.3; }
            grenade delete();
        }
    }
}

toggleSemtex()
{
    if (!self.pers["semtex"])
    {
        self.pers["semtex"] = true;

        if (is_valid_equipment("sticky_grenade_zm"))
            if (!self hasweapon("sticky_grenade_zm"))
                self _g_weapon("sticky_grenade_zm");
    }
    else
    {
        self.pers["semtex"] = false;

        if (is_valid_equipment("sticky_grenade_zm"))
            if (self hasweapon("sticky_grenade_zm"))
            {
                self takeweapon("sticky_grenade_zm");
            }
    }
    self setPlayerCustomDvar("semtex",self.pers["semtex"]);
    self iPrintLn("Always Start with Semtex " + convertstatus(self.pers["semtex"]));
}


toggleClaymore()
{
    if (!self.pers["claymore"])
    {
        self.pers["claymore"] = true;

        if (is_valid_equipment("claymore_zm"))
            if (!self hasweapon("claymore_zm"))
                self g_claymore();
    }
    else
    {
        self.pers["claymore"] = false;

        if (is_valid_equipment("claymore_zm"))
            if (self hasweapon("claymore_zm"))
            {
                self takeweapon("claymore_zm");
            }
    }
    self setPlayerCustomDvar("claymore",self.pers["claymore"]);
    self iPrintLn("Always Start with Claymore " + convertstatus(self.pers["claymore"]));
}


fasthands()
{
    if (!self.pers["fasthands"])
    {
        self setperk("specialty_fastweaponswitch");
        self.pers["fasthands"] = true;
    }
    else
    {
        self unsetperk("specialty_fastweaponswitch");
        self.pers["fasthands"] = false;
    }
    self setPlayerCustomDvar("fasthands",self.pers["fasthands"]);
    self iPrintLn("Fast Hands " + convertstatus(self.pers["fasthands"]));
}

spawn_zombie()
{
    self iprintln("spawning another zombie");
    level.zombie_total += 1;
}

kick_zombie()
{
    self iprintln("kicking a zombie");
    // level.zombie_total -= 1;
    // level.zombie_total_subtract++;
    level.zombie_player_killed_count++;
}

spawn_biplane_ride(player)
{
    if (!isdefined(player) || !isplayer(player))
        return;

    if(isdefined(player.is_riding_biplane) && player.is_riding_biplane)
    {
        player devp( "You are already riding a biplane!" );
        return;
    }

    player.is_riding_biplane = true;

    if(player.menu.is_open)
    {
        player close_menu();
    }

    s_biplane_pos = getstruct("air_crystal_biplane_pos", "targetname");
    vh_biplane = spawnvehicle("veh_t6_dlc_zm_biplane", "air_crystal_biplane", "biplane_zm", s_biplane_pos.origin, s_biplane_pos.angles);
    vh_biplane ent_flag_init("biplane_ride_down", 0);
    vh_biplane setvisibletoall();
    vh_biplane playloopsound("zmb_zombieblood_3rd_plane_loop", 1);
    vh_biplane.health = 99999;
    vh_biplane setcandamage(0);
    vh_biplane setforcenocull();
    vh_biplane attachpath(getvehiclenode("biplane_start", "targetname"));
    vh_biplane startpath();
    vh_biplane thread monitor_biplane_ride(player);

    vh_biplane ent_flag_wait("biplane_ride_down");

    vh_biplane playsound("zmb_zombieblood_3rd_plane_explode");
    playfx(level._effect["biplane_explode"], vh_biplane.origin);
    vh_biplane delete();
}

monitor_biplane_ride(player)
{
    self endon("death"); // don't think this event is used :P
    self endon("biplane_ride_down");

    player unlink();
    player playerlinkto(self);
    player iprintln("^2[{+gostand}] ^7to jump off plane");

    wait 0.5;

    for(;;)
    {
        if (player jumpbuttonpressed() && !player.menu.is_open)
        {
            player unlink();
            player.is_riding_biplane = undefined;
            wait 1; // don't explode right away, but wait a second till player jumps out
            self ent_flag_set("biplane_ride_down");
        }

        wait 0.05;
    }
}

sendbacktospawn()
{
    spawnpointname = "initial_spawn_points";
	spawnpoints = getstructarray( spawnpointname, "targetname" );
	// spawnpoint = spawnpoints[ 0 ];
	spawnpoint = maps\mp\gametypes_zm\_spawnlogic::getspawnpoint_random( spawnpoints );
	if ( isDefined( spawnpoint ) )
	{
		self setOrigin( spawnpoint.origin );
		self setPlayerAngles( spawnpoint.angles );
	}
}