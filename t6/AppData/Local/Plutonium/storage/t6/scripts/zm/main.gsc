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
#include scripts\zm\functions;
#include scripts\zm\killcam;
#include scripts\zm\utils;
#include scripts\zm\_utility;

main()
{
    replacefunc(maps\mp\zombies\_zm_laststand::is_reviving, ::is_reviving_hook);
    replacefunc(maps\mp\zombies\_zm_laststand::can_revive, ::can_revive_hook);
    replacefunc(maps\mp\zombies\_zm_powerups::nuke_powerup, ::__nuke_powerup);
    replacefunc(maps\mp\zombies\_zm_perks::disable_quickrevive, ::__disable_quickrevive);
    replacefunc(maps\mp\zombies\_zm_equipment::equipment_release, ::__equipment_release);
    replacefunc(maps\mp\zombies\_zm_weap_claymore::claymore_setup, ::__claymore_setup);
    replacefunc(maps\mp\zombies\_zm_utility::include_weapon, ::include_weapon_hook);
    replacefunc(maps\mp\gametypes_zm\_hud::fontpulseinit, ::__fontpulseinit);
}

__disable_quickrevive( machine_clip )
{
    return;
}
__equipment_release( equipment )
{
	if( equipment != "jetgun_zm" && equipment != "jetgun_upgraded_zm" )
    	self maps\mp\zombies\_zm_equipment::equipment_take( equipment );
}
__nuke_powerup(drop_item, player_team)
{
    players = get_players( player_team );
	i = 0;
	while ( i < players.size )
	{
		players[ i ] maps\mp\zombies\_zm_score::player_add_points( "nuke_powerup", 400 );
		i++;
	}
    return;
}

init()
{
    // watermark
    // TODO: Fix this shit already LOL
    // info_text();

    init_precache();
    init_dvars();

    // variables
    level.perk_purchase_limit = 20;
    level.zombie_vars["zombie_use_failsafe"] = false;
    set_zombie_var("zombie_use_failsafe", 0);
    level.player_out_of_playable_area_monitor = undefined;
    level.player_too_many_weapons_monitor = undefined;
    level._zombies_round_spawn_failsafe = undefined;

    level.callbackactorkilled_og = level.callbackactorkilled;
    level.callbackactorkilled = ::callbackactorkilled_stub; 

    level.callbackplayerkilled_og = level.callbackplayerkilled;
    level.callbackplayerkilled = ::callbackplayerkilled_stub;

    level.onteamoutcomenotify = ::outcome_notify_stub;

    level.spawnplayer_og = level.spawnplayer;
    level.spawnplayer = ::spawnplayer_stub;

    // vars
    level.enemy_score = randomintrange(0, 4); // default is random
    level.round_based = false;                // victory by default

    maps\mp\zombies\_zm_spawner::register_zombie_damage_callback(::do_hitmarker);
    maps\mp\zombies\_zm_spawner::register_zombie_death_event_callback(::do_hitmarker_death);

    level.perkslist = strTok("specialty_armorvest,specialty_fastreload,specialty_rof,specialty_deadshot,specialty_scavenger,specialty_additionalprimaryweapon,specialty_quickrevive,specialty_grenadepulldeath,specialty_nomotionsensor", ",");
    // level.checkthis = strTok("specialty_unlimitedsprint,specialty_fastweaponswitch,specialty_scavenger", ",");
    level.checkthis = strTok("specialty_unlimitedsprint,specialty_scavenger", ",");
    level.meleelist = strTok("knife_zm,zombiemelee_dw,zombiemelee_zm,bowie_knife_zm,sickle_knife_zm,tazer_knuckles_zm,tazer_knuckles_upgraded_zm,zombie_fists_zm,one_inch_punch_air_zm,one_inch_punch_zm,one_inch_punch_upgraded_zm,one_inch_punch_lightning_zm,one_inch_punch_ice_zm,one_inch_punch_fire_zm", ",");
    level.teststring = strTok("canswap,knucklecrack,bowieknifeanim,galvaknucklesanim,chalkdrawanim,ironfistanim,tomahawkspinanim,backflip,frontflip,leftflip,rightflip,testbinda,testbindb,testbindc,testbindd,testbinde,testbindf,testbindg,testbindh,testbindi,testbindj,testbindk,testbindl,testbindm,testbindn,testbindo,testbindp,testbindq", ",");

    level thread on_player_connect();
    level thread end_game_when_hit();
    level thread open_seseme();
    level thread zombies_counter();
    level thread last_cooldown();

    // lil changes
    level thread build_buildables();
    level thread build_craftables();

    if(level.script == "zm_tomb")
        level._random_zombie_perk_cost = 0;

    if(level.script != "zm_nuked")
    {
    	setdvar( "magic_chest_movable", "0" );
        level thread set_pap_price();
    }

    // make this true for the Redacted mod
    level.isRedacted = false;
    level.isSteam = false;

    level.debug_mode = getdvarintdefault("debug_mode", 0);
    level.azza_mode = getdvarintdefault("azza_mode", 0);
    level.isHostedServer = getdvarint("isHostedServer");

    setDvarIfUninitialized("devprintsenabled", 1 );
    level.devprintsenabled = getDvarInt("devprintsenabled");
    
    setDvarIfUninitialized("limit_damage_weapons", 1 );
    level.limit_damage_weapons = getDvarInt("limit_damage_weapons");

    setDvarIfUninitialized("land_protection", 1 );
    level.land_protection = getDvarInt("land_protection");

    setDvarIfUninitialized("barrel_protection", 1 );
    level.barrel_protection = getDvarInt("barrel_protection");

    level.result = 0;

    level thread init_killcam();
}

on_player_connect()
{
    for(;;)
    {
        level waittill("connected", player);

        if (!isdefined(player.hud_damagefeedback))
            player thread init_player_hitmarkers();

        player thread on_player_spawned();
        player thread verify_on_connect();
        player thread spawn_on_join();

        player.hud_EventPopup = player createEventPopup();
        player.hud_EventPopup2 = player createEventPopup2();

        if(isDefined(level.limit_damage_weapons))
            player.limit_damage_weapons = level.limit_damage_weapons;
            
        if(isDefined(level.land_protection))
            player.land_protection = level.land_protection;

        if(isDefined(level.barrel_protection))
            player.barrel_protection = level.barrel_protection;

        if(!player isBot())
        {
            player thread zombies();
            player thread onGrenadeFire();
            player thread onGrenadePullback();
            player thread onGrenadeLauncherFire();
            player thread onWeaponFire();
            player thread monitorAmmo();
            
            player thread setupBindNotifies();
            player thread bindinit();
            player thread bindwatch();

            /* always canswap on/off */
            if( player getPlayerCustomDvar("canswapweap") != "" /* && player getPlayerCustomDvar("canswapweap") != undefined */ ) 
            {
                player.pers["canswapweap"] = player getPlayerCustomDvar("canswapweap");
                player setClientDvar("canswapweap", player.pers["canswapweap"]);
                player setClientDvar("canswapweap_", "[" + player.pers["canswapweap"] + "]");
            }
            else
            {
                player.pers["canswapweap"] = "none";
                player setPlayerCustomDvar("canswapweap", player.pers["canswapweap"]);
                player setClientDvar("canswapweap",player.pers["canswapweap"]);
                player setClientDvar("canswapweap_","[" + player.pers["canswapweap"] + "]");
            }

            /* instant shoots on/off */
            if( player getPlayerCustomDvar("instashoot") != "" /* && player getPlayerCustomDvar("instashoot") != undefined */ ) 
            {
                player.pers["instashoot"] = int(player getPlayerCustomDvar("instashoot"));
                player setClientDvar("instashoot", player getPlayerCustomDvar(player.pers["instashoot"]));
            }
            else
            {
                player.pers["instashoot"] = true;
                player setPlayerCustomDvar("instashoot",player.pers["instashoot"]);
                player setClientDvar("instashoot",player.pers["instashoot"]);
            }
            if( player getPlayerCustomDvar("instashootweapon") != "" /* && player getPlayerCustomDvar("instashootweap") != undefined */ ) 
            {
                player.pers["instashootweapon"] = player getPlayerCustomDvar("instashootweapon");
                player setClientDvar("instashootweapon", player getPlayerCustomDvar("instashootweapon"));
            }
            else
            {
                player setPlayerCustomDvar("instashootweapon","none");
                player setClientDvar("instashootweapon","[none]");
                player.pers["instashootweapon"] = "none";
            }

            /* instapump on/off */
            if( player getPlayerCustomDvar("instapump") != "" /* && player getPlayerCustomDvar("instapump") != undefined */ ) 
            {
                player.pers["instapump"] = int(player getPlayerCustomDvar("instapump"));
                player setClientDvar("instapump", player getPlayerCustomDvar(player.pers["instapump"]));
            }
            else
            {
                player.pers["instapump"] = false;
                player setPlayerCustomDvar("instapump",player.pers["instapump"]);
                player setClientDvar("instapump",player.pers["instapump"]);
            }

            /* snl binds OFF by default */
            if( player getPlayerCustomDvar("snlBinds") != "" ) {
                player.pers["snlBinds"] = int(player getPlayerCustomDvar("snlBinds"));
            } else {
            player.pers["snlBinds"] = true;
            player setPlayerCustomDvar("snlBinds", player.pers["snlBinds"] );
            player setClientDvar( "snlBinds", player.pers["snlBinds"]);
            }
            
            /* snl button combo crouch + dpad up/down by default */
            if( player getPlayerCustomDvar("snlCombo") != "" ) {
                player.pers["snlCombo"] = int(player getPlayerCustomDvar("snlCombo"));
            } else {
            player.pers["snlCombo"] = 1;
            player setPlayerCustomDvar("snlCombo", player.pers["snlCombo"] );
            player setClientDvar( "snlCombo", player.pers["snlCombo"]);
            }

            player thread monitor_save_and_load();

            /* floaters OFF by default */
            if( player getPlayerCustomDvar("floaters") != "" ) {
                player.pers["floaters"] = int(player getPlayerCustomDvar("floaters"));
            } else {
            player.pers["floaters"] = 0;
            player setPlayerCustomDvar("floaters", player.pers["floaters"] );
            player setClientDvar( "floaters", player.pers["floaters"]);
            }

            /* fast hands OFF by default */
            if( player getPlayerCustomDvar("fasthands") != "" ) {
                player.pers["fasthands"] = int(player getPlayerCustomDvar("fasthands"));
            } else {
            player.pers["fasthands"] = 0;
            player setPlayerCustomDvar("fasthands", player.pers["fasthands"] );
            player setClientDvar( "fasthands", player.pers["fasthands"]);
            }

            foreach(perk in level.perkslist)
            {
                if( player getPlayerCustomDvar(perk) != "" ) {
                player.pers[perk] = int(player getPlayerCustomDvar(perk));
                } else {
                    if( perk == "specialty_armorvest" || perk == "specialty_quickrevive" || perk == "specialty_fallheight" ) {
                    player.pers[perk] = 1;
                    } else {
                    player.pers[perk] = 0;
                    }
                player setPlayerCustomDvar(perk, player.pers[perk] );
                player setClientDvar( perk, player.pers[perk]);
                }
            }

            /* semtex ON by default */
            if( player getPlayerCustomDvar("semtex") != "" ) {
                player.pers["semtex"] = int(player getPlayerCustomDvar("semtex"));
            } else {
            player.pers["semtex"] = 1;
            player setPlayerCustomDvar("semtex", player.pers["semtex"] );
            player setClientDvar( "semtex", player.pers["semtex"]);
            }

            /* semtex ON by default */
            if( player getPlayerCustomDvar("claymore") != "" ) {
                player.pers["claymore"] = int(player getPlayerCustomDvar("claymore"));
            } else {
            player.pers["claymore"] = 1;
            player setPlayerCustomDvar("claymore", player.pers["claymore"] );
            player setClientDvar( "claymore", player.pers["claymore"]);
            }
            
            /* grenade refill ON by default */
            if( player getPlayerCustomDvar("grenadeRefill") != "" ) {
                player.pers["grenadeRefill"] = int(player getPlayerCustomDvar("grenadeRefill"));
            } else {
            player.pers["grenadeRefill"] = 1;
            player setPlayerCustomDvar("grenadeRefill", player.pers["grenadeRefill"] );
            player setClientDvar( "grenadeRefill", player.pers["grenadeRefill"]);
            }

            /* ammo refill ON by default */
            if( player getPlayerCustomDvar("ammoRefill") != "" ) {
                player.pers["ammoRefill"] = int(player getPlayerCustomDvar("ammoRefill"));
            } else {
            player.pers["ammoRefill"] = 1;
            player setPlayerCustomDvar("ammoRefill", player.pers["ammoRefill"] );
            player setClientDvar( "ammoRefill", player.pers["ammoRefill"]);
            }

            /* knife lunge OFF by default */
            if( player getPlayerCustomDvar("knifelunge") != "" ) {
                player.pers["knifelunge"] = int(player getPlayerCustomDvar("knifelunge"));
            } else {
            player.pers["knifelunge"] = 0;
            player setPlayerCustomDvar("knifelunge", player.pers["knifelunge"] );
            player setClientDvar( "knifelunge", player.pers["knifelunge"]);
            }
        }
    }
}

on_player_spawned()
{
    self endon("disconnect");
    //level endon("game_ended");

    self.first = true;

    if(level.azza_mode)
        self.menuname = "FableZombies: Azza";
    else
        self.menuname = "FableZombies: Trickshotting";

    self.menuxpos = 0;
    self.menu_init = false;
    self.default_team = self.team;
    self.ufospeed = 80;

    self.killcam_rank = "zombies_rank_5"; // max rank by default
    self.killcam_length = 5;

    scripts\zm\afterhits::init_afterhit();
    self thread endGameThing();

    for(;;)
    {
        self waittill("spawned_player");

        if (is_true(level.intermission))
        {
            if (isalive(self))
            {
                self enableinvulnerability();
                self freezecontrols(true);
            }
            continue;
        }

        self setperk("specialty_fallheight");
        // self setperk("specialty_unlimitedsprint");

        // if(self.pers["fasthands"])
            // self setperk("specialty_fastweaponswitch");

        self setup_my_perks();
        
        if(self.pers["semtex"] && is_valid_equipment("sticky_grenade_zm"))
            self g_weapon( "sticky_grenade_zm" );

        if ( !isDefined( self.pers["claymoreSlot"] ) )
        {
            self.pers["claymoreSlot"] = 4;
        }
        
        if(self.pers["claymore"] && is_valid_equipment("claymore_zm"))
            self g_claymore();

        if (verification_to_num(self.status) > verification_to_num("Unverified"))
        {
            if (!self.menu_init)
            {
                self overflow_fix();
                self thread menu_init();
                self.menu_init = true;
            }
        }

        // save and load
        if (isdefined(self.pers["myAngles"]) && isdefined(self.pers["mySpawn"]))
        {
            self setplayerangles(self.pers["myAngles"]);
            self setorigin(self.pers["mySpawn"]);
        }

        // first spawn
        if (is_true(self.first))
        {
            if (!flag("initial_blackscreen_passed"))
            {
                flag_wait("initial_blackscreen_passed");
            }

            level.ta_vaultfee = 0;
            level.ta_tellerfee = 0;
            level.bank_deposit_max_amount = 1000000;

            self.account_value = level.bank_deposit_max_amount;
            self.score = 5000;

            self thread monitor_reviving();

            // always canswap loop
            self thread scripts\zm\_always_canswap::canswaps();
            self thread scripts\zm\_instashoot::instashootloop();
            self thread scripts\zm\_instapump::instapump();

            self iprintln("^7Hello ^1" + self.name + " ^7& Welcome to ^1FableServers: Zombies Trickshotting^7!");
            self iprintln("^5[{+speed_throw}] ^7+ ^5[{+actionslot 1}] ^7to open menu");
            // self iprintln("'last' is when ^11 ^7zombie is alive.");

            self neverlosemeleeloop();
            // self neverlosequickrevivemachineloop();

            foreach(weapon in self.afterhit)
            {
                if (weapon["on"])
                    self iPrintLn(weapon);
            }

            self.first = false;
        }
    }
}

spawnplayer_stub()
{
    if (is_true(level.in_final_killcam))
    {
        return;
    }
        
    [[level.spawnplayer_og]]();
}

init_precache()
{
    level.customShaders = [];
    console(  "^2PRECACHING SHADERS" );
    console(  "^4************************" );
    level.customShaders[ level.customShaders.size ] = "white";
    level.customShaders[ level.customShaders.size ] = "zombies_rank_1";
    level.customShaders[ level.customShaders.size ] = "zombies_rank_2";
    level.customShaders[ level.customShaders.size ] = "zombies_rank_3";
    level.customShaders[ level.customShaders.size ] = "zombies_rank_4";
    level.customShaders[ level.customShaders.size ] = "zombies_rank_5";
    level.customShaders[ level.customShaders.size ] = "emblem_bg_default";
    level.customShaders[ level.customShaders.size ] = "damage_feedback";
    level.customShaders[ level.customShaders.size ] = "hud_status_dead";
    level.customShaders[ level.customShaders.size ] = "specialty_instakill_zombies";
    level.customShaders[ level.customShaders.size ] = "menu_lobby_icon_twitter";
    level.customShaders[ level.customShaders.size ] = "faction_cia";
    level.customShaders[ level.customShaders.size ] = "faction_cdc";
    foreach( shader in level.customShaders )
    {
        precacheShader( shader );
    }
    console(  "^4************************" );

    level.fsModels = [];
    console(  "^2PRECACHING MODELS" );
    console(  "^4************************" );
    level.fsModels[ level.fsModels.size ] = "p6_anim_zm_magic_box";
    level.fsModels[ level.fsModels.size ] = "zombie_pickup_perk_bottle";
    level.fsModels[ level.fsModels.size ] = "zombie_teddybear";
	if ( level.gametype == "zcleansed" )
    {
        level.fsModels[ level.fsModels.size ] =  "c_zom_zombie_viewhands";
        level.fsModels[ level.fsModels.size ] =  "c_zom_player_zombie_fb";
    }
    foreach( model in level.fsModels )
    {
        precacheModel( model );
        console( "^5" + model + "^3 precached" );
    }
    console(  "^4************************" );

    level.fsItems = [];
    console(  "^2PRECACHING ITEMS" );
    console(  "^4************************" );
    level.fsItems[ level.fsItems.size ] = "zombie_knuckle_crack";
    level.fsItems[ level.fsItems.size ] = "zombie_perk_bottle_jugg";
    level.fsItems[ level.fsItems.size ] = "zombie_perk_bottle_sleight";
    level.fsItems[ level.fsItems.size ] = "zombie_perk_bottle_doubletap";
    level.fsItems[ level.fsItems.size ] = "zombie_perk_bottle_deadshot";
    level.fsItems[ level.fsItems.size ] = "zombie_perk_bottle_tombstone";
    level.fsItems[ level.fsItems.size ] = "zombie_perk_bottle_additionalprimaryweapon";
    level.fsItems[ level.fsItems.size ] = "zombie_perk_bottle_revive";
    level.fsItems[ level.fsItems.size ] = "death_throe_zm";
    level.fsItems[ level.fsItems.size ] = "death_self_zm";
    level.fsItems[ level.fsItems.size ] = "zombie_fists_zm";
    level.fsItems[ level.fsItems.size ] = "no_hands_zm";
	if ( level.script == "zm_tomb" )
    {
        level.fsItems[ level.fsItems.size ] = "zombie_one_inch_punch_flourish";
    }
	if ( level.script == "zm_prison" )
    {
        level.fsItems[ level.fsItems.size ] = "lightning_hands_zm";
    }
	if ( level.script == "zm_buried" )
    {
        level.fsItems[ level.fsItems.size ] = "chalk_draw_zm";
    }
	if ( level.gametype == "zcleansed" )
    {
    	level.fsItems[ level.fsItems.size ] =  "zombiemelee_zm";
	    level.fsItems[ level.fsItems.size ] =  "zombiemelee_dw";
    }
    foreach( item in level.fsItems )
    {
        preCacheItem( item );
        console( "^5" + item + "^3 precached" );
    }
    console(  "^4************************" );

    game["colors"]["blue"] = (0.25,0.25,0.75);
    game["colors"]["red"] = (0.75,0.25,0.25);
    game["colors"]["white"] = (1.0,1.0,1.0);
    game["colors"]["black"] = (0.0,0.0,0.0);
    game["colors"]["green"] = (0.25,0.75,0.25);
    game["colors"]["yellow"] = (0.65,0.65,0.0);
    game["colors"]["orange"] = (1.0,0.45,0.0);
    game["colors"]["pink"] = (1.0,0.0,1.0);
    game["colors"]["bright_red"] = (1.0,0.0,0.0);
    game["colors"]["cyan"] = (0.0,1.0,1.0);
}

init_dvars()
{
    setdvar("sv_cheats", 1); 

    setgametypesetting("allowAnnouncer", 1);
    setgametypesetting("allowBattleChatter", 1);
    setgametypesetting("disableTacInsert", 0);
    setgametypesetting("disableweapondrop", 0);
    setgametypesetting("forceRadar", 1);
    
    level.zombie_vars["riotshield_hit_points"] = 999999;
    set_zombie_var( "riotshield_hit_points", 999999 );
    
    setdvar("sv_patch_zm_weapons", 0); // // Apply Post DLC1 changes to tar21_zm, type95_zm, xm8_zm, an94_zm, hamr_zm, rpd_zm, pdw57_zm, kard_zm ? (only recoil changes)
    setdvar("sv_fix_zm_weapons", 1); // Fix the SMR's ADS spread, 870 MCS's penetration damage and allow sprinting with Galvaknuckles
    setDvar("sv_patch_dsr50", false ); // patch the DSR?

    setDvar("mod_version", "2.0");
    level.modVersion = getDvar("mod_version");

    level.developer = "QKSTR";
    level.credits = "discord.io/fableservers";
    level.credits2 = "@FableServers";

    setDvar("sv_maxclients", "18");
    setDvarIfUninitialized("sv_sayname", "@FableServers");
    setDvarIfUninitialized("sv_allowAimAssist", "1");

    // Voice Chat
    setDvar("sv_voice", "1" ); // Allow Voice Chat? (0 = Disable 1 = Everyone hears you. 2 = Teams only)
    setDvar("sv_voicequality", "9" ); // Voice Chat Quality. (0-9) Default is 3 (= Steam/Console quality). Use 9 for the best quality.

    makedvarserverinfo("perk_weapSpreadMultiplier", "0.50");
    setDvar("perk_weapSpreadMultiplier", "0.50");

    //fmj
    // makedvarserverinfo("perk_bulletPenetrationMultiplier", 999);
    // setDvar("perk_bulletPenetrationMultiplier", 999);

    makedvarserverinfo("perk_bulletPenetrationMultiplier", 30);
    setDvar("perk_bulletPenetrationMultiplier", 30);

    makedvarserverinfo("perk_weapReloadMultiplier", 0.5);
    setDvar("perk_weapReloadMultiplier", 0.5);

    makedvarserverinfo("player_sustainAmmo", 0);
    setDvar("player_sustainAmmo", 0);

    // bullet rocochet base chance
	makedvarserverinfo( "bullet_ricochetBaseChance", 0.95 );
	setdvar( "bullet_ricochetBaseChance", 0.95 );
    
    //penetration count
    makedvarserverinfo("penetrationcount", 30);
    setDvar("penetrationcount", 30);

    makedvarserverinfo("penetrationcount_axis", 30);
    setDvar("penetrationcount_axis", 30);

    makedvarserverinfo("penetrationcount_allies", 30);
    setDvar("penetrationcount_allies", 30);

    // bullet range
    makedvarserverinfo("bulletrange", 65536); //default: 8192 //max: 65536
    setDvar("bulletrange", 65536); //default: 8192 //max: 65536

    // super penetrate
    makedvarserverinfo("sv_SuperPenetrate", "1");
    setdvar("sv_SuperPenetrate", "1");
    
    //armor piercing
    makedvarserverinfo("perk_armorPiercing", 999);
    setDvar("perk_armorPiercing", 999);

    SetDvar("bg_gravity", 800);
    SetDvar("jump_slowdownEnable", 0);
    setDvar("mantle_view_yawcap", 180);
    setDvar("bg_prone_yawcap", 360);
    setDvar("bg_ladder_yawcap", 0);
    SetDvar("g_speed", 210); //default: 190

    // show perk hud on spawn
    SetDvar("scr_showperksonspawn", 0);

    setdvar("bot_AllowMovement", 0);
    setdvar("bot_PressAttackBtn", 0);
    setdvar("bot_PressMeleeBtn", 0);
    setdvar("friendlyfire_enabled", 0);
    setdvar("g_friendlyfireDist", 0);
    setdvar("ui_friendlyfire", 1);
    setdvar("jump_slowdownEnable", 0);
    setdvar("sv_enableBounces", 1);
    setdvar("player_lastStandBleedoutTime", 9999);
}


toggleWatermark()
{
    if( !level.watermark && !isDefined( level.infoText ) )
    {
        level thread info_text();
    }
    else
    {
        level.infoText destroyElem();
        level.watermark = false;
    }
}

info_text()
{
	level.infoText = level createServerFontString( "default", 0.5 ); //objective
	level.infoText setPoint( "TOP", "RIGHT", 30, -230 );
	level.infoText setText("^7@FableServers");
	level.infoText.hidewheninmenu = false;
	// level.infoText.color = (1,0,0);

    level.watermark = true;
}

