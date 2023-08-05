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

#include scripts\zm\functions;
#include scripts\zm\killcam;
#include scripts\zm\utils;
#include scripts\zm\_utility;

main()
{
    replacefunc(maps\mp\zombies\_zm_laststand::is_reviving, ::is_reviving_hook);
    replacefunc(maps\mp\zombies\_zm_powerups::nuke_powerup, ::__nuke_powerup);
    replacefunc(maps\mp\zombies\_zm_perks::disable_quickrevive, ::__disable_quickrevive);
    replacefunc(maps\mp\zombies\_zm_equipment::equipment_release, ::__equipment_release);
    // replacefunc(maps\mp\gametypes\_hud::fontpulseinit, ::__fontpulseinit);
    replacefunc(maps\mp\gametypes_zm\_hud::fontpulseinit, ::__fontpulseinit);

    // if(level.script == "zm_buried")
    //     scripts\zm\zm_buried\script::main();

    // if(level.script == "zm_highrise")
    //     scripts\zm\zm_highrise\script::main();
    
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
    // if(level.script == "zm_buried")
    //     scripts\zm\zm_buried\script::init();

    // if(level.script == "zm_highrise")
    //     scripts\zm\zm_highrise\script::init();

    // if(level.script == "zm_transit")
    //     scripts\zm\zm_transit\script::init();

    // watermark
    info_text();

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
    level.meleelist = strTok("knife_zm,zombiemelee_dw,zombiemelee_zm,bowie_knife_zm,sickle_knife_zm,tazer_knuckles_zm,tazer_knuckles_upgraded_zm,zombie_fists_zm,one_inch_punch_air_zm,one_inch_punch_zm,one_inch_punch_upgraded_zm,one_inch_punch_lightning_zm,one_inch_punch_ice_zm,one_inch_punch_fire_zm", ",");

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
    level.isHostedServer = getdvarintdefault("isHostedServer", 0);

    setDvarIfUninitialized("devprintsenabled", 1 );
    level.devprintsenabled = getDvarInt("devprintsenabled");
    
    setDvarIfUninitialized("limit_damage_weapons", 1 );
    level.limit_damage_weapons = getDvarInt("limit_damage_weapons");

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
        player thread onGrenadeFire();
        player thread onWeaponFire();
        player thread monitorAmmo();

        player.hud_EventPopup = player createEventPopup();
        player.hud_EventPopup2 = player createEventPopup2();

        if(!player isBot())
        {
            player thread zombies();

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
                    if( perk == "specialty_armorvest" || perk == "specialty_quickrevive" ) {
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
        self setperk("specialty_unlimitedsprint");

        foreach(perk in level.perkslist)
        {            
            if(isDefined(self.pers[perk]) && self.pers[perk] == true )
            {
                self doperks(perk);
            }
        }

        if(self.pers["fasthands"])
            self setperk("specialty_fastweaponswitch");
        
        if(self.pers["semtex"] && is_valid_equipment("sticky_grenade_zm"))
            self g_weapon( "sticky_grenade_zm" );
        
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
            level.bank_deposit_max_amount = 999999;

            self.account_value = level.bank_deposit_max_amount;
            self.score = self.account_value;

            self thread toggle_save_and_load(true);
            self thread monitor_reviving();

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
    precacheshader("white");
    precacheshader("zombies_rank_1");
    precacheshader("zombies_rank_2");
    precacheshader("zombies_rank_3");
    precacheshader("zombies_rank_4");
    precacheshader("zombies_rank_5");
    precacheshader("emblem_bg_default");
    precacheshader("damage_feedback");
    precacheshader("hud_status_dead");
    precacheshader("specialty_instakill_zombies");
    precacheshader("menu_lobby_icon_twitter");
    precacheshader("faction_cia");
    precacheshader("faction_cdc");

    precachemodel("p6_anim_zm_magic_box");
    precachemodel("zombie_pickup_perk_bottle");

    precacheitem("zombie_knuckle_crack");
    precacheitem("zombie_perk_bottle_jugg");
    precacheitem("zombie_perk_bottle_sleight");
    precacheitem("zombie_perk_bottle_doubletap");
    precacheitem("zombie_perk_bottle_deadshot");
    precacheitem("zombie_perk_bottle_tombstone");
    precacheitem("zombie_perk_bottle_additionalprimaryweapon");
    precacheitem("zombie_perk_bottle_revive");
    precacheitem("chalk_draw_zm");
    precacheitem("lightning_hands_zm");
    
    precacheitem("death_throe_zm");
    precacheitem("death_self_zm");

    level.turnedmeleeweapon = "zombiemelee_zm";
	level.turnedmeleeweapon_dw = "zombiemelee_dw";
	precacheitem( level.turnedmeleeweapon );
	precacheitem( level.turnedmeleeweapon_dw );
    precachemodel( "c_zom_player_zombie_fb" );
    precachemodel( "c_zom_zombie_viewhands" );

    // maps\mp\zombies\_zm_turned::init();

    level.shader_weapons_list = strtok("specialty_quickrevive_zombies_pro voice_off voice_off_xboxlive voice_on_xboxlive menu_zm_weapons_ballista menu_mp_weapons_m14 hud_python zm_hud_icon_oneinch_clean hud_cymbal_monkey zom_hud_craftable_element_water zom_hud_craftable_element_lightning zom_hud_craftable_element_fire zom_hud_craftable_element_wind hud_obit_grenade_launcher_attach hud_obit_death_grenade_round menu_mp_weapons_knife menu_mp_weapons_1911 menu_mp_weapons_judge menu_mp_weapons_kard menu_mp_weapons_five_seven menu_mp_weapons_dual57s menu_mp_weapons_ak74u menu_mp_weapons_mp5 menu_mp_weapons_qcw menu_mp_weapons_870mcs menu_mp_weapons_rottweil72 menu_mp_weapons_saiga12 menu_mp_weapons_srm menu_mp_weapons_m16 menu_mp_weapons_saritch menu_mp_weapons_xm8 menu_mp_weapons_type95 menu_mp_weapons_tar21 menu_mp_weapons_galil menu_mp_weapons_fal menu_mp_weapons_rpd menu_mp_weapons_hamr menu_mp_weapons_dsr1 menu_mp_weapons_m82a menu_mp_weapons_rpg menu_mp_weapons_m32gl menu_zm_weapons_raygun menu_zm_weapons_jetgun menu_zm_weapons_shield menu_mp_weapons_ballistic_80 menu_mp_weapons_hk416 menu_mp_weapons_lsat menu_mp_weapons_an94 menu_mp_weapons_ar57 menu_mp_weapons_svu menu_zm_weapons_slipgun menu_zm_weapons_hell_shield menu_mp_weapons_minigun menu_zm_weapons_blundergat menu_zm_weapons_acidgat menu_mp_weapons_ak47 menu_mp_weapons_uzi menu_zm_weapons_thompson menu_zm_weapons_rnma voice_off_mute_xboxlive menu_zm_weapons_raygun_mark2 menu_zm_weapons_mc96 menu_zm_weapons_mg08 menu_zm_weapons_stg44 menu_mp_weapons_scar menu_mp_weapons_ksg menu_zm_weapons_mp40 menu_mp_weapons_evoskorpion menu_mp_weapons_ballista menu_zm_weapons_staff_air menu_zm_weapons_staff_fire menu_zm_weapons_staff_lightning menu_zm_weapons_staff_water menu_zm_weapons_tomb_shield hud_icon_claymore_256 hud_grenadeicon hud_icon_sticky_grenade hud_obit_knife hud_obit_ballistic_knife menu_mp_weapons_baretta menu_zm_weapons_taser menu_mp_weapons_baretta93r menu_mp_weapons_olympia hud_obit_death_crush menu_zm_weapons_bowie hud_icon_sticky_grenade", " ");

    foreach(shader in level.shader_weapons_list)
    {
        precacheShader( shader );
    }

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

    setdvar("sv_patch_zm_weapons", 0); /* pre-patch zm weapons */
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
	level.infoText = level createServerFontString( "Objective", 0.5 );
	level.infoText setPoint( "TOP", "RIGHT", 30, -230 );
	level.infoText setText("^7@FableServers");
	level.infoText.hidewheninmenu = false;
	// level.infoText.color = (1,0,0);

    level.watermark = true;
}

