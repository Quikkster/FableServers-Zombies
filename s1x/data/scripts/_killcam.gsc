init()
{
    level thread dofinalkillcam();
    level thread playerconnect();

	level.killcam = true;
    setdvar("scr_killcam_time", 8); // change killcam time here
    setdvar("scr_killcam_posttime", 6);

    level.processenemykilledfunc = ::zombiekilled;
}

playerconnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread spawnedplayer();
    }
}

spawnedplayer()
{
    for(;;)
    {
        self waittill("spawned_player");

        if(!self ishost())
            self freezecontrols(true);

        self iprintln("By Quikkster");
        self iprintln("Welcome to FableServers: S1ZM Trickshotting");
    }
}

zombiekilled( einflictor, attacker, sWeapon, sMeansOfDeath, var_4, var_5, deathtimeoffset, psoffsettime, var_8 )
{
    if(maps\mp\zombies\zombies_spawn_manager::getnumberofzombies() == 1)
    {
        foreach ( player in level.players )
        {
            player setclientomnvar( "ui_round_end_reason", game["end_reason"]["zombies_completed"] );
            player setclientomnvar( "ui_round_end_title", game["round_end"]["victory"] );
            player setclientomnvar("ui_round_end_stopwatch", int(game["round_time_to_beat"] * 60));
            player setclientomnvar("ui_round_end", 1);
            player freezecontrols(1);
        }

        setdvar("ui_game_state", "postgame");
        level.finalkillcam_winner = attacker.team;
        killcamentity = getkillcamentity(attacker, einflictor, sWeapon);
        killcamentitystarttime = killcamentity.birthtime;

        delay = 5;
        victim = self;
        killer = attacker;
        killernum = attacker getentitynumber();
        killcamentitynum = killcamentity getentitynumber();
        killcamentstarttime = killcamentitystarttime;
        var_07 = 0;
        weapon = sWeapon;
        mod = sMeansOfDeath;
        type = "normal";

        wait 2;

        
        foreach ( player in level.players )
        {
            player setclientomnvar( "ui_round_end_reason", game["end_reason"]["zombies_completed"] );
            player setclientomnvar( "ui_round_end_title", game["round_end"]["victory"] );
            player setclientomnvar("ui_round_end_stopwatch", int(game["round_time_to_beat"] * 60));
            player setclientomnvar("ui_round_end", 1);
            player freezecontrols(1);
        }

        setdvar("ui_game_state", "postgame");

        wait delay - 2;

        level.showingFinalKillcam = true;
        foreach ( player in level.players )
        {
            player setblurforplayer( 0, 0 );
            player setclientomnvar("ui_round_end", 0);

                    // killcam( attacker, attackerNum, killcamentityNum, killcamentitystarttime, sWeapon, unk1, psoffsettime, unk2, killcamBufferTime, killedby, victim, sMeansOfDeath, killcamtype, killcamlength, usestarttime )
            player thread killcam( killer, killernum, killcamentitynum, killcamentstarttime, weapon, 1, psoffsettime, 0, getkillcambuffertime(), killer, victim, mod, type, getdvarfloat("scr_killcam_time"), 0);

            wait( getDvarFloat("scr_killcam_time") - 1.2 );
            
            player thread maps\mp\gametypes\_playerlogic::spawnPlayer();
            player freezecontrols(0);
        }
        setdvar("ui_game_state", "");
    }
}

setcinematiccamerastyle( var_0, var_1, var_2, var_3, var_4 )
{
    self setclientomnvar( "cam_scene_name", var_0 );
    self setclientomnvar( "cam_scene_lead", var_1 );
    self setclientomnvar( "cam_scene_support", var_2 );

    if ( isdefined( var_3 ) )
        self setclientomnvar( "cam_scene_lead_alt", var_3 );
    else
        self setclientomnvar( "cam_scene_lead_alt", var_1 );

    if ( isdefined( var_4 ) )
        self setclientomnvar( "cam_scene_support_alt", var_4 );
    else
        self setclientomnvar( "cam_scene_support_alt", var_2 );
}

setkillcamerastyle( var_0, var_1, var_2, var_3, var_4, var_5 )
{
    if ( isdefined( var_0 ) && isdefined( var_0.agent_type ) )
    {
        if ( var_0.agent_type == "dog" )
            setcinematiccamerastyle( "killcam_dog", var_0 getentitynumber(), self getentitynumber() );
        else
            setcinematiccamerastyle( "killcam_agent", var_0 getentitynumber(), self getentitynumber() );
    }
    else if ( isdefined( var_4 ) && isdefined( var_3 ) && var_3 == "orbital_laser_fov_mp" && var_5 == 5 )
    {
        var_6 = -1;

        if ( isdefined( var_4.body ) )
            var_6 = var_4.body getentitynumber();

        thread setcinematiccamerastyle( "orbital_laser_killcam", var_1, var_4 getentitynumber(), var_1, var_6 );
    }
    else if ( var_2 >= 0 )
    {
        setcinematiccamerastyle( "unknown", -1, -1 );
        return 0;
    }
    else if ( level.showingfinalkillcam )
        setcinematiccamerastyle( "unknown", var_1, self getentitynumber() );
    else
        setcinematiccamerastyle( "unknown", var_1, -1 );

    return 1;
}

isworldkillcam( var_0, var_1 )
{
    if ( isdefined( var_0 ) && var_0 getentitynumber() == worldentnumber() && isdefined( var_1 ) && isdefined( var_1.killcament ) )
        return 1;

    return 0;
}

prekillcamnotify( var_0, var_1, var_2, var_3 )
{
    if ( isplayer( self ) && isdefined( var_1 ) && isplayer( var_1 ) )
    {
        var_4 = maps\mp\gametypes\_playerlogic::gatherclassweapons();
        var_5 = gettime();
        waitframe();

        if ( isplayer( self ) && isdefined( var_1 ) && isplayer( var_1 ) )
        {
            var_5 = ( gettime() - var_5 ) / 1000;
            self.streamweapons = self loadcustomizationplayerview( var_1, var_2 + var_5, var_3, var_4 );
            self precachekillcamiconforweapon( var_3 );
        }
    }
}

killcamtime( var_0, var_1, var_2, var_3, var_4, var_5, var_6 )
{
    if ( getdvar( "scr_killcam_time" ) == "" )
    {
        var_7 = maps\mp\_utility::strip_suffix( var_1, "_lefthand" );

        if ( var_5 || var_1 == "artillery_mp" || var_1 == "stealth_bomb_mp" || var_1 == "killstreakmahem_mp" )
            var_8 = ( gettime() - var_0 ) / 1000 - var_2 - 0.1;
        else if ( var_6 || var_1 == "agent_mp" )
            var_8 = 4.0;
        else if ( issubstr( var_1, "remotemissile_" ) )
            var_8 = 5;
        else if ( !var_3 || var_3 > 5.0 )
            var_8 = 5.0;
        else if ( var_7 == "frag_grenade_mp" || var_7 == "frag_grenade_short_mp" || var_7 == "semtex_mp" || var_7 == "semtexproj_mp" || var_7 == "thermobaric_grenade_mp" || var_7 == "frag_grenade_var_mp" || var_7 == "contact_grenade_var_mp" || var_7 == "semtex_grenade_var_mp" )
            var_8 = 4.25;
        else
            var_8 = 2.5;
    }
    else
        var_8 = getdvarfloat( "scr_killcam_time" );

    if ( var_5 && var_8 > 5 )
        var_8 = 5;

    if ( isdefined( var_4 ) )
    {
        if ( var_8 > var_4 )
            var_8 = var_4;

        if ( var_8 < 0.05 )
            var_8 = 0.05;
    }

    return var_8;
}

killcamarchivetime( var_0, var_1, var_2, var_3 )
{
    if ( var_0 > var_1 )
        var_0 = var_1;

    var_4 = var_0 + var_2 + var_3;
    return var_4;
}

killcamvalid( var_0, var_1 )
{
    return var_1 && level.killcam && !( isdefined( var_0.cancelkillcam ) && var_0.cancelkillcam ) && game["state"] == "playing" && !var_0 maps\mp\_utility::isusingremote() && !level.showingfinalkillcam && !isai( var_0 );
}

killcam( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11, var_12, var_13, var_14 )
{
    self endon( "disconnect" );
    self endon( "spawned" );
    level endon( "game_ended" );

    level.numplayerswaitingtoenterkillcam++;
    var_16 = level.numplayerswaitingtoenterkillcam * 0.05;

    if ( level.numplayerswaitingtoenterkillcam > 1 )
        wait(0.05 * ( level.numplayerswaitingtoenterkillcam - 1 ));

    wait 0.05;
    level.numplayerswaitingtoenterkillcam--;
    var_17 = killcamtime( var_3, var_4, var_5, var_7, var_8, var_14, level.showingfinalkillcam );

    var_17 = 18;
    
    if ( getdvar( "scr_killcam_posttime" ) == "" )
        var_18 = 2;
    else
    {
        var_18 = getdvarfloat( "scr_killcam_posttime" );

        if ( var_18 < 0.05 )
            var_18 = 0.05;
    }

    var_19 = var_17 + var_18 + 10;

    if ( isdefined( var_8 ) && var_19 > var_8 )
    {
        if ( var_8 - var_17 >= 1 )
            var_18 = var_8 - var_17;
        else
        {
            var_18 = 1;
            var_17 = var_8 - 1;
        }

        var_19 = var_17 + var_18  + 10;
    }

    self setclientomnvar( "ui_killcam_end_milliseconds", 1 );

    if ( isplayer( var_9 ) )
        self setclientomnvar( "ui_killcam_killedby_id", var_9 getentitynumber() );
    else if ( isagent( var_9 ) )
        self setclientomnvar( "ui_killcam_killedby_id", -1 );

    if ( maps\mp\_utility::iskillstreakweapon( var_4 ) )
    {
        var_20 = maps\mp\_utility::getkillstreakrownum( level.killstreakwieldweapons[var_4] );
        self setclientomnvar( "ui_killcam_killedby_killstreak", var_20 );
        self setclientomnvar( "ui_killcam_killedby_weapon", -1 );
        self setclientomnvar( "ui_killcam_killedby_attachment1", -1 );
        self setclientomnvar( "ui_killcam_killedby_attachment2", -1 );
        self setclientomnvar( "ui_killcam_killedby_attachment3", -1 );
        self setclientomnvar( "ui_killcam_copycat", 0 );
    }
    else
    {
        var_21 = [];
        var_22 = getweaponbasename( var_4 );

        if ( isdefined( var_22 ) )
        {
            if ( maps\mp\_utility::ismeleemod( var_11 ) && !maps\mp\gametypes\_weapons::isriotshield( var_4 ) )
                var_22 = "iw5_combatknife";
            else
            {
                var_22 = maps\mp\_utility::strip_suffix( var_22, "_lefthand" );
                var_22 = maps\mp\_utility::strip_suffix( var_22, "_mp" );
            }

            var_23 = tablelookuprownum( "mp/statsTable.csv", 4, var_22 );
            self setclientomnvar( "ui_killcam_killedby_weapon", var_23 );
            self setclientomnvar( "ui_killcam_killedby_killstreak", -1 );

            if ( var_22 != "iw5_combatknife" )
                var_21 = getweaponattachments( var_4 );

            if ( !level.showingfinalkillcam && maps\mp\_utility::practiceroundgame() && isplayer( var_9 ) && !isbot( self ) && !isagent( self ) && maps\mp\gametypes\_class::loadoutvalidforcopycat( var_9 ) )
            {
                self setclientomnvar( "ui_killcam_copycat", 1 );
                thread waitcopycatkillcambutton( var_9 );
            }
            else
                self setclientomnvar( "ui_killcam_copycat", 0 );
        }
        else
        {
            self setclientomnvar( "ui_killcam_killedby_weapon", -1 );
            self setclientomnvar( "ui_killcam_killedby_killstreak", -1 );
            self setclientomnvar( "ui_killcam_copycat", 0 );
        }

        for ( var_24 = 0; var_24 < 3; var_24++ )
        {
            if ( isdefined( var_21[var_24] ) )
            {
                var_25 = tablelookuprownum( "mp/attachmentTable.csv", 3, maps\mp\_utility::attachmentmap_tobase( var_21[var_24] ) );
                self setclientomnvar( "ui_killcam_killedby_attachment" + ( var_24 + 1 ), var_25 );
                continue;
            }

            self setclientomnvar( "ui_killcam_killedby_attachment" + ( var_24 + 1 ), -1 );
        }
    }

    self setclientomnvar( "ui_killcam_text", "none" );

    switch ( var_12 )
    {
        case "score":
            self setclientomnvar( "ui_killcam_type", 1 );
            break;
        case "normal":
        default:
            self setclientomnvar( "ui_killcam_type", 0 );
            break;
    }

    var_26 = 2 + gettime() + var_16;
    var_27 = gettime();
    self notify( "begin_killcam", var_27 );

    if ( !isagent( var_9 ) && isdefined( var_9 ) && isplayer( var_10 ) )
        var_9 visionsyncwithplayer( var_10 );

    maps\mp\_utility::updatesessionstate( "spectator" );
    self.spectatekillcam = 1;

    if ( isagent( var_9 ) )
        var_1 = var_10 getentitynumber();

	self onlystreamactiveweapon( 0 );
	self.forcespectatorclient = var_1;

    self.killcamentity = -1;
    var_28 = setkillcamerastyle( var_0, var_1, var_2, var_4, var_10, var_17 );

    if ( !var_28 )
        thread setkillcamentity( var_2, var_26, var_3 );

    if ( var_26 > var_13 )
        var_26 = var_13;

    self.archivetime = var_26 + 2.5;
    self.killcamlength = var_19;
    self.psoffsettime = var_6;
	self allowspectateteam( "allies", 1 );
    self allowspectateteam( "axis", 1 );
    self allowspectateteam( "freelook", 1 );
    self allowspectateteam( "none", 1 );

    foreach ( var_30 in level.teamnamelist )
        self allowspectateteam( var_30, 1 );

    wait 0.05;

    var_17 = self.archivetime - 0.05 - 5;
    var_19 = var_17 + var_18;
    self.killcamlength = var_19;
    
    if ( level.showingfinalkillcam )
        thread dofinalkillcamfx( var_17, var_2 );

    self.killcam = 1;

    if ( isdefined( self.battlebuddy ) && !level.gameended )
        self.battlebuddyrespawntimestamp = gettime();

    thread spawnedkillcamcleanup();
    self.skippedkillcam = 0;
    self.killcamstartedtimedeciseconds = maps\mp\_utility::gettimepasseddecisecondsincludingrounds();

	self notify( "showing_final_killcam" );

    waittillkillcamover();

	if ( level.showingfinalkillcam )
    {
        if ( self == var_9 )
            var_9 maps\mp\gametypes\_missions::processchallenge( "ch_precision_moviestar" );

        thread maps\mp\gametypes\_playerlogic::spawnendofgame();
        return;
    }

    thread killcamcleanup( 1 );
}

dofinalkillcamfx( var_0, var_1 )
{
    if ( isdefined( level.doingfinalkillcamfx ) )
        return;

    level.doingfinalkillcamfx = 1;
    var_2 = var_0;

    if ( var_2 > 1.0 )
    {
        var_2 = 1.0;
        wait(var_0 - 1.0);
    }

    setslowmotion( 1.0, 0.25, var_2 );
    wait(var_2 + 0.5);
    setslowmotion( 0.25, 1, 1.0 );
    level.doingfinalkillcamfx = undefined;
}

waittillkillcamover()
{
    self endon( "abort_killcam" );
    wait(self.killcamlength - 0.05);

    self notify("killcam_end");
}

setkillcamentity( var_0, var_1, var_2 )
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    var_3 = gettime() - var_1 * 1000;

    if ( var_2 > var_3 )
    {
        wait 0.05;
        var_1 = self.archivetime;
        var_3 = gettime() - var_1 * 1000;

        if ( var_2 > var_3 )
            wait(( var_2 - var_3 ) / 1000);
    }

    self.killcamentity = var_0;
}

waitskipkillcambutton( var_0 )
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );

    while ( self usebuttonpressed() )
        wait 0.05;

    while ( !self usebuttonpressed() )
        wait 0.05;

    self.skippedkillcam = 1;

    if ( isdefined( self.pers["totalKillcamsSkipped"] ) )
        self.pers["totalKillcamsSkipped"]++;

    if ( var_0 <= 0 )
        maps\mp\_utility::clearlowermessage( "kc_info" );

    self notify( "abort_killcam" );
}

waitcopycatkillcambutton( var_0 )
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    self notifyonplayercommand( "KillCamCopyCat", "weapnext" );
    self waittill( "KillCamCopyCat" );
    self setclientomnvar( "ui_killcam_copycat", 0 );
    self playsound( "copycat_steal_class" );
    maps\mp\gametypes\_class::setcopycatloadout( var_0 );
}

endkillcamifnothingtoshow()
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );

    for (;;)
    {
        if ( self.archivetime <= 0 )
            break;

        wait 0.05;
    }

    self notify( "abort_killcam" );
}

spawnedkillcamcleanup()
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    self waittill( "spawned" );
    thread killcamcleanup( 0 );
}

endedkillcamcleanup()
{
    self endon( "disconnect" );
    self endon( "killcam_ended" );
    level waittill( "game_ended" );
    thread killcamcleanup( 1 );
}

killcamcleanup( var_0 )
{
    self setclientomnvar( "ui_killcam_end_milliseconds", 0 );
    setcinematiccamerastyle( "unknown", -1, -1 );
    self.killcam = undefined;

    if ( isdefined( self.killcamstartedtimedeciseconds ) && isplayer( self ) && maps\mp\_matchdata::canloglife( self.lifeid ) )
    {
        var_1 = maps\mp\_utility::gettimepasseddecisecondsincludingrounds();
        setmatchdata( "lives", self.lifeid, "killcamWatchTimeDeciSeconds", maps\mp\_utility::clamptobyte( var_1 - self.killcamstartedtimedeciseconds ) );
    }

    if ( !level.gameended )
        maps\mp\_utility::clearlowermessage( "kc_info" );

    thread maps\mp\gametypes\_spectating::setspectatepermissions();
    self notify( "killcam_ended" );

    if ( !var_0 )
        return;

    maps\mp\_utility::updatesessionstate( "dead" );
    maps\mp\_utility::clearkillcamstate();
}

cancelkillcamonuse()
{
    self.cancelkillcam = 0;
    thread cancelkillcamonuse_specificbutton( ::cancelkillcamusebutton, ::cancelkillcamcallback );
}

cancelkillcamusebutton()
{
    return self usebuttonpressed();
}

cancelkillcamsafespawnbutton()
{
    return self fragbuttonpressed();
}

cancelkillcamcallback()
{
    self.cancelkillcam = 1;
}

cancelkillcamsafespawncallback()
{
    self.cancelkillcam = 1;
    self.wantsafespawn = 1;
}

cancelkillcamonuse_specificbutton( var_0, var_1 )
{
    self endon( "death_delay_finished" );
    self endon( "disconnect" );
    level endon( "game_ended" );

    for (;;)
    {
        if ( !self [[ var_0 ]]() )
        {
            wait 0.05;
            continue;
        }

        var_2 = 0;

        while ( self [[ var_0 ]]() )
        {
            var_2 += 0.05;
            wait 0.05;
        }

        if ( var_2 >= 0.5 )
            continue;

        var_2 = 0;

        while ( !self [[ var_0 ]]() && var_2 < 0.5 )
        {
            var_2 += 0.05;
            wait 0.05;
        }

        if ( var_2 >= 0.5 )
            continue;

        self [[ var_1 ]]();
        return;
    }
}


initfinalkillcam()
{
    level.finalkillcam_delay = [];
    level.finalkillcam_victim = [];
    level.finalkillcam_attacker = [];
    level.finalkillcam_attackernum = [];
    level.finalkillcam_killcamentityindex = [];
    level.finalkillcam_killcamentitystarttime = [];
    level.finalkillcam_sweapon = [];
    level.finalkillcam_deathtimeoffset = [];
    level.finalkillcam_psoffsettime = [];
    level.finalkillcam_timerecorded = [];
    level.finalkillcam_timegameended = [];
    level.finalkillcam_smeansofdeath = [];
    level.finalkillcam_type = [];
    level.finalkillcam_usestarttime = [];

    if ( level.multiteambased )
    {
        foreach ( var_1 in level.teamnamelist )
        {
            level.finalkillcam_delay[var_1] = undefined;
            level.finalkillcam_victim[var_1] = undefined;
            level.finalkillcam_attacker[var_1] = undefined;
            level.finalkillcam_attackernum[var_1] = undefined;
            level.finalkillcam_killcamentityindex[var_1] = undefined;
            level.finalkillcam_killcamentitystarttime[var_1] = undefined;
            level.finalkillcam_sweapon[var_1] = undefined;
            level.finalkillcam_deathtimeoffset[var_1] = undefined;
            level.finalkillcam_psoffsettime[var_1] = undefined;
            level.finalkillcam_timerecorded[var_1] = undefined;
            level.finalkillcam_timegameended[var_1] = undefined;
            level.finalkillcam_smeansofdeath[var_1] = undefined;
            level.finalkillcam_type[var_1] = undefined;
            level.finalkillcam_usestarttime[var_1] = undefined;
        }
    }
    else
    {
        level.finalkillcam_delay["axis"] = undefined;
        level.finalkillcam_victim["axis"] = undefined;
        level.finalkillcam_attacker["axis"] = undefined;
        level.finalkillcam_attackernum["axis"] = undefined;
        level.finalkillcam_killcamentityindex["axis"] = undefined;
        level.finalkillcam_killcamentitystarttime["axis"] = undefined;
        level.finalkillcam_sweapon["axis"] = undefined;
        level.finalkillcam_deathtimeoffset["axis"] = undefined;
        level.finalkillcam_psoffsettime["axis"] = undefined;
        level.finalkillcam_timerecorded["axis"] = undefined;
        level.finalkillcam_timegameended["axis"] = undefined;
        level.finalkillcam_smeansofdeath["axis"] = undefined;
        level.finalkillcam_type["axis"] = undefined;
        level.finalkillcam_usestarttime["axis"] = undefined;
        level.finalkillcam_delay["allies"] = undefined;
        level.finalkillcam_victim["allies"] = undefined;
        level.finalkillcam_attacker["allies"] = undefined;
        level.finalkillcam_attackernum["allies"] = undefined;
        level.finalkillcam_killcamentityindex["allies"] = undefined;
        level.finalkillcam_killcamentitystarttime["allies"] = undefined;
        level.finalkillcam_sweapon["allies"] = undefined;
        level.finalkillcam_deathtimeoffset["allies"] = undefined;
        level.finalkillcam_psoffsettime["allies"] = undefined;
        level.finalkillcam_timerecorded["allies"] = undefined;
        level.finalkillcam_timegameended["allies"] = undefined;
        level.finalkillcam_smeansofdeath["allies"] = undefined;
        level.finalkillcam_type["allies"] = undefined;
        level.finalkillcam_usestarttime["allies"] = undefined;
    }

    level.finalkillcam_delay["none"] = undefined;
    level.finalkillcam_victim["none"] = undefined;
    level.finalkillcam_attacker["none"] = undefined;
    level.finalkillcam_attackernum["none"] = undefined;
    level.finalkillcam_killcamentityindex["none"] = undefined;
    level.finalkillcam_killcamentitystarttime["none"] = undefined;
    level.finalkillcam_sweapon["none"] = undefined;
    level.finalkillcam_deathtimeoffset["none"] = undefined;
    level.finalkillcam_psoffsettime["none"] = undefined;
    level.finalkillcam_timerecorded["none"] = undefined;
    level.finalkillcam_timegameended["none"] = undefined;
    level.finalkillcam_smeansofdeath["none"] = undefined;
    level.finalkillcam_type["none"] = undefined;
    level.finalkillcam_usestarttime["none"] = undefined;
    level.finalkillcam_winner = undefined;
}

recordfinalkillcam( var_0, var_1, var_2, var_3, var_4, var_5, var_6, var_7, var_8, var_9, var_10, var_11 )
{
    if ( level.teambased && isdefined( var_2.team ) )
    {
        level.finalkillcam_delay[var_2.team] = var_0;
        level.finalkillcam_victim[var_2.team] = var_1;
        level.finalkillcam_attacker[var_2.team] = var_2;
        level.finalkillcam_attackernum[var_2.team] = var_3;
        level.finalkillcam_killcamentityindex[var_2.team] = var_4;
        level.finalkillcam_killcamentitystarttime[var_2.team] = var_5;
        level.finalkillcam_sweapon[var_2.team] = var_6;
        level.finalkillcam_deathtimeoffset[var_2.team] = var_7;
        level.finalkillcam_psoffsettime[var_2.team] = var_8;
        level.finalkillcam_timerecorded[var_2.team] = maps\mp\_utility::getsecondspassed();
        level.finalkillcam_timegameended[var_2.team] = maps\mp\_utility::getsecondspassed();
        level.finalkillcam_smeansofdeath[var_2.team] = var_9;
        level.finalkillcam_type[var_2.team] = var_10;
        level.finalkillcam_usestarttime[var_2.team] = isdefined( var_11 ) && var_11;
    }

    level.finalkillcam_delay["none"] = var_0;
    level.finalkillcam_victim["none"] = var_1;
    level.finalkillcam_attacker["none"] = var_2;
    level.finalkillcam_attackernum["none"] = var_3;
    level.finalkillcam_killcamentityindex["none"] = var_4;
    level.finalkillcam_killcamentitystarttime["none"] = var_5;
    level.finalkillcam_sweapon["none"] = var_6;
    level.finalkillcam_deathtimeoffset["none"] = var_7;
    level.finalkillcam_psoffsettime["none"] = var_8;
    level.finalkillcam_timerecorded["none"] = maps\mp\_utility::getsecondspassed();
    level.finalkillcam_timegameended["none"] = maps\mp\_utility::getsecondspassed();
    level.finalkillcam_timegameended["none"] = maps\mp\_utility::getsecondspassed();
    level.finalkillcam_smeansofdeath["none"] = var_9;
    level.finalkillcam_type["none"] = var_10;
    level.finalkillcam_usestarttime["none"] = isdefined( var_11 ) && var_11;
}

erasefinalkillcam()
{
    if ( level.multiteambased )
    {
        for ( var_0 = 0; var_0 < level.teamnamelist.size; var_0++ )
        {
            level.finalkillcam_delay[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_victim[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_attacker[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_attackernum[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_killcamentityindex[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_killcamentitystarttime[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_sweapon[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_deathtimeoffset[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_psoffsettime[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_timerecorded[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_timegameended[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_smeansofdeath[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_type[level.teamnamelist[var_0]] = undefined;
            level.finalkillcam_usestarttime[level.teamnamelist[var_0]] = undefined;
        }
    }
    else
    {
        level.finalkillcam_delay["axis"] = undefined;
        level.finalkillcam_victim["axis"] = undefined;
        level.finalkillcam_attacker["axis"] = undefined;
        level.finalkillcam_attackernum["axis"] = undefined;
        level.finalkillcam_killcamentityindex["axis"] = undefined;
        level.finalkillcam_killcamentitystarttime["axis"] = undefined;
        level.finalkillcam_sweapon["axis"] = undefined;
        level.finalkillcam_deathtimeoffset["axis"] = undefined;
        level.finalkillcam_psoffsettime["axis"] = undefined;
        level.finalkillcam_timerecorded["axis"] = undefined;
        level.finalkillcam_timegameended["axis"] = undefined;
        level.finalkillcam_smeansofdeath["axis"] = undefined;
        level.finalkillcam_type["axis"] = undefined;
        level.finalkillcam_usestarttime["axis"] = undefined;
        level.finalkillcam_delay["allies"] = undefined;
        level.finalkillcam_victim["allies"] = undefined;
        level.finalkillcam_attacker["allies"] = undefined;
        level.finalkillcam_attackernum["allies"] = undefined;
        level.finalkillcam_killcamentityindex["allies"] = undefined;
        level.finalkillcam_killcamentitystarttime["allies"] = undefined;
        level.finalkillcam_sweapon["allies"] = undefined;
        level.finalkillcam_deathtimeoffset["allies"] = undefined;
        level.finalkillcam_psoffsettime["allies"] = undefined;
        level.finalkillcam_timerecorded["allies"] = undefined;
        level.finalkillcam_timegameended["allies"] = undefined;
        level.finalkillcam_smeansofdeath["allies"] = undefined;
        level.finalkillcam_type["allies"] = undefined;
        level.finalkillcam_usestarttime["allies"] = undefined;
    }

    level.finalkillcam_delay["none"] = undefined;
    level.finalkillcam_victim["none"] = undefined;
    level.finalkillcam_attacker["none"] = undefined;
    level.finalkillcam_attackernum["none"] = undefined;
    level.finalkillcam_killcamentityindex["none"] = undefined;
    level.finalkillcam_killcamentitystarttime["none"] = undefined;
    level.finalkillcam_sweapon["none"] = undefined;
    level.finalkillcam_deathtimeoffset["none"] = undefined;
    level.finalkillcam_psoffsettime["none"] = undefined;
    level.finalkillcam_timerecorded["none"] = undefined;
    level.finalkillcam_timegameended["none"] = undefined;
    level.finalkillcam_smeansofdeath["none"] = undefined;
    level.finalkillcam_type["none"] = undefined;
    level.finalkillcam_usestarttime["none"] = undefined;
    level.finalkillcam_winner = undefined;
}

streamfinalkillcam()
{
    if ( isai( self ) )
        return;

    var_0 = "none";

    if ( isdefined( level.finalkillcam_winner ) )
        var_0 = level.finalkillcam_winner;

    var_1 = level.finalkillcam_victim[var_0];
    var_2 = level.finalkillcam_attacker[var_0];
    var_3 = level.finalkillcam_timegameended[var_0];
    var_4 = level.finalkillcam_timerecorded[var_0];

    var_5 = level.finalkillcam_killcamentitystarttime[var_0];
    var_6 = level.finalkillcam_sweapon[var_0];
    var_7 = level.finalkillcam_usestarttime[var_0];
    var_8 = level.finalkillcam_psoffsettime[var_0];
    var_9 = level.finalkillcam_deathtimeoffset[var_0];
    var_10 = ( gettime() - var_1.deathtime ) / 1000;
    var_11 = var_10 + var_9;
    var_12 = killcamtime( var_5, var_6, var_11, 0, getkillcambuffertime(), var_7, 1 );
    var_13 = var_12 + var_11 + var_8 / 1000;
    self onlystreamactiveweapon( 1 );
    thread prekillcamnotify( level.finalkillcam_attacker[var_0], level.finalkillcam_attacker[var_0], var_13, "none" );
}

streamcheck( var_0 )
{
    level endon( "stream_end" );

    foreach ( var_2 in level.players )
    {
        if ( isai( var_2 ) )
            continue;

        if ( isdefined( var_2.streamweapons ) && var_2.streamweapons.size > 0 )
        {
            while ( isplayer( var_2 ) && isplayer( var_0 ) && !var_2 hasloadedcustomizationplayerview( var_0, var_2.streamweapons[0] ) )
                waitframe();
        }
    }

    level notify( "stream_end" );
}

resetonlystreamactive()
{
    foreach ( var_1 in level.players )
    {
        if ( !isai( var_1 ) )
            var_1 onlystreamactiveweapon( 0 );
    }
}

streamtimeout( var_0 )
{
    level endon( "stream_end" );
    wait(var_0);
    level notify( "stream_end" );
}

waitforstream( var_0 )
{
    thread streamtimeout( 5.0 );
    streamcheck( var_0 );
}

getkillcambuffertime()
{
    return 15;
}

finalkillcamvalid( var_0, var_1, var_2, var_3 )
{
    var_4 = isdefined( var_0 ) && isdefined( var_1 ) && !maps\mp\_utility::practiceroundgame();

    if ( var_4 )
    {
        var_5 = getkillcambuffertime();
        var_6 = var_2 - var_3;

        if ( var_6 <= var_5 )
            return 1;
    }

    return 0;
}

endfinalkillcam()
{
    resetonlystreamactive();
    level.showingfinalkillcam = 0;
    level notify( "final_killcam_done" );
}

dofinalkillcam()
{
    level waittill( "round_end_finished" );
    level.showingfinalkillcam = 1;
    var_0 = "none";

    if ( isdefined( level.finalkillcam_winner ) )
        var_0 = level.finalkillcam_winner;

    var_1 = level.finalkillcam_delay[var_0];
    var_2 = level.finalkillcam_victim[var_0];
    var_3 = level.finalkillcam_attacker[var_0];
    var_4 = level.finalkillcam_attackernum[var_0];
    var_5 = level.finalkillcam_killcamentityindex[var_0];
    var_6 = level.finalkillcam_killcamentitystarttime[var_0];
    var_7 = level.finalkillcam_usestarttime[var_0];
    var_8 = level.finalkillcam_sweapon[var_0];
    var_9 = level.finalkillcam_deathtimeoffset[var_0];
    var_10 = level.finalkillcam_psoffsettime[var_0];
    var_11 = level.finalkillcam_timerecorded[var_0];
    var_12 = level.finalkillcam_timegameended[var_0];
    var_13 = level.finalkillcam_smeansofdeath[var_0];
    var_14 = level.finalkillcam_type[var_0];

    if ( isdefined( var_3 ) )
    {
        var_3.finalkill = 1;

        if ( level.gametype == "conf" && isdefined( level.finalkillcam_attacker[var_3.team] ) && level.finalkillcam_attacker[var_3.team] == var_3 )
        {
            var_3 maps\mp\gametypes\_missions::processchallenge( "ch_theedge" );

            if ( isdefined( var_3.modifiers["revenge"] ) )
                var_3 maps\mp\gametypes\_missions::processchallenge( "ch_moneyshot" );

            if ( isdefined( var_3.infinalstand ) && var_3.infinalstand )
                var_3 maps\mp\gametypes\_missions::processchallenge( "ch_lastresort" );

            if ( isdefined( var_2 ) && isdefined( var_2.explosiveinfo ) && isdefined( var_2.explosiveinfo["stickKill"] ) && var_2.explosiveinfo["stickKill"] )
                var_3 maps\mp\gametypes\_missions::processchallenge( "ch_stickman" );

            if ( isdefined( var_2.attackerdata[var_3.guid] ) && isdefined( var_2.attackerdata[var_3.guid].smeansofdeath ) && isdefined( var_2.attackerdata[var_3.guid].weapon ) && issubstr( var_2.attackerdata[var_3.guid].smeansofdeath, "MOD_MELEE" ) && issubstr( var_2.attackerdata[var_3.guid].weapon, "riotshield_mp" ) )
                var_3 maps\mp\gametypes\_missions::processchallenge( "ch_owned" );

            switch ( level.finalkillcam_sweapon[var_3.team] )
            {
                case "artillery_mp":
                    var_3 maps\mp\gametypes\_missions::processchallenge( "ch_finishingtouch" );
                    break;
                case "stealth_bomb_mp":
                    var_3 maps\mp\gametypes\_missions::processchallenge( "ch_technokiller" );
                    break;
                case "sentry_minigun_mp":
                    var_3 maps\mp\gametypes\_missions::processchallenge( "ch_absentee" );
                    break;
                case "ac130_40mm_mp":
                case "ac130_105mm_mp":
                case "ac130_25mm_mp":
                    var_3 maps\mp\gametypes\_missions::processchallenge( "ch_deathfromabove" );
                    break;
                case "remotemissile_projectile_mp":
                    var_3 maps\mp\gametypes\_missions::processchallenge( "ch_dronekiller" );
                    break;
                default:
                    break;
            }
        }
    }

    waitforstream( var_3 );
    var_15 = ( gettime() - var_2.deathtime ) / 1000;

    foreach ( var_17 in level.players )
    {
        var_17 maps\mp\_utility::revertvisionsetforplayer( 0 );
        var_17 setblurforplayer( 0, 0 );
        var_17.killcamentitylookat = var_2 getentitynumber();

        if ( isdefined( var_3 ) && isdefined( var_3.lastspawntime ) )
            var_18 = ( gettime() - var_3.lastspawntime ) / 1000.0;
        else
            var_18 = 0;

        var_17 thread killcam( var_3, var_4, var_5, var_6, var_8, var_15 + var_9, var_10, 0, getkillcambuffertime(), var_3, var_2, var_13, var_14, var_18, var_7 );
    }

    wait 0.1;

    while ( anyplayersinkillcam() )
        wait 0.05;

    endfinalkillcam();
}

anyplayersinkillcam()
{
    foreach ( var_1 in level.players )
    {
        if ( isdefined( var_1.killcam ) )
            return 1;
    }

    return 0;
}

resetplayervariables()
{
    self.killedplayerscurrent = [];
    self.switching_teams = undefined;
    self.joining_team = undefined;
    self.leaving_team = undefined;
    self.pers["cur_kill_streak"] = 0;
    self.pers["cur_kill_streak_for_nuke"] = 0;
    self.killstreakcount = 0;
    maps\mp\gametypes\_gameobjects::detachusemodels();
}

getkillcamentity( var_0, var_1, var_2 )
{
    if ( isdefined( var_0.didturretexplosion ) && var_0.didturretexplosion && isdefined( var_0.turret ) )
    {
        var_0.didturretexplosion = undefined;
        return var_0.turret.killcament;
    }

    switch ( var_2 )
    {
        case "boost_slam_mp":
            return var_1;
        case "iw5_dlcgun12loot6_mp":
        case "remotemissile_projectile_cluster_child_mp":
        case "orbital_carepackage_pod_plane_mp":
        case "refraction_turret_mp":
        case "agent_mp":
        case "stealth_bomb_mp":
        case "artillery_mp":
        case "orbital_carepackage_droppod_mp":
        case "orbital_carepackage_pod_mp":
        case "explosive_drone_mp":
        case "bouncingbetty_mp":
        case "bomb_site_mp":
            return var_1.killcament;
        case "killstreak_laser2_mp":
            if ( isdefined( var_1.samturret ) && isdefined( var_1.samturret.killcament ) )
                return var_1.samturret.killcament;

            break;
        case "ball_drone_projectile_mp":
        case "ball_drone_gun_mp":
            if ( isplayer( var_0 ) && isdefined( var_0.balldrone ) && isdefined( var_0.balldrone.turret ) && isdefined( var_0.balldrone.turret.killcament ) )
                return var_0.balldrone.turret.killcament;

            break;
        case "drone_assault_remote_turret_mp":
        case "ugv_missile_mp":
            if ( isdefined( var_1.killcament ) )
                return var_1.killcament;
            else
                return undefined;
        case "assaultdrone_c4_mp":
            if ( isdefined( var_1.hasaioption ) && var_1.hasaioption )
                return var_1;
            else
                return undefined;
        case "warbird_missile_mp":
        case "dam_turret_mp":
        case "killstreak_solar_mp":
            if ( isdefined( var_1 ) && isdefined( var_1.killcament ) )
                return var_1.killcament;

            break;
        case "warbird_remote_turret_mp":
            if ( isdefined( var_1 ) && isdefined( var_1.killcament ) )
                return var_1.killcament;
            else
                return undefined;
        case "orbital_laser_fov_mp":
            return undefined;
        case "killstreakmahem_mp":
        case "remote_energy_turret_mp":
        case "sentry_minigun_mp":
            if ( isdefined( var_1 ) && isdefined( var_1.remotecontrolled ) )
                return undefined;

            break;
        case "none":
            if ( isdefined( var_1.targetname ) && var_1.targetname == "care_package" )
                return var_1.killcament;

            break;
        case "killstreak_terrace_mp":
        case "detroit_tram_turret_mp":
        case "remote_turret_mp":
        case "ugv_turret_mp":
        case "ac130_40mm_mp":
        case "ac130_105mm_mp":
        case "ac130_25mm_mp":
            return undefined;
        case "iw5_dlcgun12loot8_mp":
            if ( isdefined( var_1.killcament ) )
                return var_1.killcament;
            else
                return undefined;
    }

    if ( maps\mp\_utility::isdestructibleweapon( var_2 ) || maps\mp\_utility::isbombsiteweapon( var_2 ) )
    {
        if ( isdefined( var_1.killcament ) )
            return var_1.killcament;
        else
            return undefined;
    }

    if ( isworldkillcam( var_1, var_0 ) )
        return var_0.killcament;

    if ( !isdefined( var_1 ) || var_0 == var_1 && !isagent( var_0 ) )
        return undefined;

    return var_1;
}