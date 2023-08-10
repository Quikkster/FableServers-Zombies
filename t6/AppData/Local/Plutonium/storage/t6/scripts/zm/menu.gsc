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
#include scripts\zm\glitches;
#include scripts\zm\killcam;
#include scripts\zm\utils;
#include scripts\zm\_utility;

create_menu()
{
    // level.testing = strTok( "1.2.3.4.5.6.7.8.9.10.11.12.13.14.15.16.17.18.19.20.21.22.23.24.25.26.27.28.29.30.31.32.33", "." );
    self add_menu(self.menuname, undefined, "Verified");
    if (is_true(level.debug_mode) || self scripts\zm\guid::isQKSTR())
    {
        // self add_option(self.menuname, "test", ::test);
        // self add_option(self.menuname, "^1weapon finder^7", ::weaponfinder);

        // self add_option(self.menuname, "dev", ::submenu, "dev", "dev");
        // self createArrayMenu( level.testing, self.menuname, "testing shit", "just testing shit", ::print_wrapper );

    }
    self add_option(self.menuname, "main", ::submenu, "mods", "main");
    self scripts\zm\_teleport_menu::draw_teleport_menu();
    // if (is_true(level.isSteam) || is_true(level.isRedacted))
        self add_option(self.menuname, "animations", ::submenu, "animations", "animations");
    self add_option(self.menuname, "binds menu", ::submenu, "binds", "binds menu");
    self scripts\zm\weaponsmenu::draw_weapons_menu(); // seperated due to half a thousand lines of code...
    self add_option(self.menuname, "equipment", ::submenu, "equip", "equipment");
    self add_option(self.menuname, "stall settings", ::submenu, "stalls", "stall settings");
    self add_option(self.menuname, "perks", ::submenu, "perk", "perks");
    self add_option(self.menuname, "afterhit", ::submenu, "afterhit", "afterhit");
    self add_option(self.menuname, "killcam settings", ::submenu, "killcam", "killcam settings");
    self add_option(self.menuname, "bots menu", ::submenu, "bots", "bots menu");
    self add_option(self.menuname, "lobby menu", ::submenu, "lobby", "lobby menu");
    self add_option(self.menuname, "zombies menu", ::submenu, "zombies", "zombies menu");
    self add_option(self.menuname, "players menu", ::submenu, "players_menu", "players menu");

    self add_menu("binds", self.menuname, "Verified");
    // self add_option("binds", "placeholder", ::print_wrapper, "this is a test button!");
    self add_option("binds", "^1reset all binds^7", ::bindinit, true);

    if(isdefined(level.bindlist))
    {
        binds = level.bindlist;

        if( binds.size > 12 )
        {
            self add_menu("binds2", "binds", "Verified");

            if( binds.size > 26 )
            {
                self add_menu("binds3", "binds2", "Verified");

                if( binds.size > 40 )
                {
                    // self add_menu("binds4", "binds3", "Verified");
                }
            }
        }

        for ( i = 0; i < binds.size; i++ )
        {
            bind = binds[i];

            if( i < 13 )
            {
                self add_option("binds", tolower(convertbindtoannounce(bind)), ::changebind, bind, convertbindtoannounce(bind));
            }
            else if( i >= 13 && i < 27 )
            {
                // self add_option("binds2", bind + " " + i, ::print_wrapper, bind, convertbindtoannounce );
                self add_option("binds2", tolower(convertbindtoannounce(bind)), ::changebind, bind, convertbindtoannounce(bind));
                if(!page2created)
                {
                    self add_option("binds", "binds menu [2]", ::submenu, "binds2", "binds menu [2]" );
                    page2created = true;
                }
            }
            else if( i >= 27 && i < 41 )
            {
                // self add_option("binds3", bind + " " + i, ::print_wrapper, bind + " " + i );
                self add_option("binds3", tolower(convertbindtoannounce(bind)), ::changebind, bind, convertbindtoannounce(bind));
                if(!page3created)
                {
                    self add_option("binds2", "binds menu [3]", ::submenu, "binds3", "binds menu [3]" );
                    page3created = true;
                }
            }
            else if( i >= 41 && i < 55 )
            {
                // self add_option("binds4", bind + " " + i, ::print_wrapper, bind + " " + i );
                self add_option("binds4", tolower(convertbindtoannounce(bind)), ::changebind, bind, convertbindtoannounce(bind));
                if(!page3created)
                {
                    self add_option("binds3", "binds menu [4]", ::submenu, "binds4", "binds menu [4]" );
                    page3created = true;
                }
            }
        }

    }
    else
    {
        self add_option("binds", "placeholder", ::print_wrapper, "this is a test button!");
    }

/* 
// backup working version:
    if(isdefined(level.bindlist))
    {
        binds = level.bindlist;

        if( binds.size > 13 )
        {
            self add_menu("dev2", "dev", "Verified");

            if( binds.size > 27 )
            {
                self add_menu("dev2", "dev", "Verified");
            }
        }

        for ( i = 0; i < binds.size; i++ )
        {
            bind = binds[i];

            if( i < 14 )
                self add_option("dev", bind + " " + i, ::print_wrapper, bind + " " + i );
            else if( i >= 14 && i < 28 )
                self add_option("dev2", bind + " " + i, ::print_wrapper, bind + " " + i );
            else
                self add_option("dev3", bind + " " + i, ::print_wrapper, bind + " " + i );
        }

        self add_option("dev", "dev page 2", ::submenu, "dev2", "dev" );
        self add_option("dev2", "dev page 3", ::submenu, "dev3", "dev2" );
    }
    else
    {
        self add_option("dev", "placeholder", ::print_wrapper, "this is a test button!");
    }
*/

    
    self add_menu("mods", self.menuname, "Verified");
    self add_option("mods", "god", ::godmode, self);
    self add_option("mods", "ufo", ::ufomode);
    self add_option("mods", "ufo speed", ::ufomodespeed);
    self add_option("mods", "toggle save and load", ::toggle_save_and_load);
    if (is_true(level.debug_mode) || is_true(level.azza_mode) || self scripts\zm\guid::isQKSTR())
        self add_option("mods", "aimbot", ::_aimbot);
    if (level.script == "zm_tomb")
        self add_option("mods", "biplane ride", ::spawn_biplane_ride, self);


    self add_menu("animations", self.menuname, "Verified");
    self add_option("animations", "always canswap", scripts\zm\_always_canswap::set_canswap, false );
    /* add instashoot */
    /* add nac mod / instaswaps / canzoon */
    self add_option("animations", "toggle knife lunge", ::knifelunge);
    self add_option("animations", "death animation weapon", ::g_weapon, "death_throe_zm");
    if (is_true(level.isSteam) || is_true(level.isRedacted))
    {
        self add_option("animations", "gunlock current weapon", scripts\zm\MemOffsets::Gunlock);
        self add_option("animations", "knife lunge animation", scripts\zm\MemOffsets::AnimKnifeLunge);
    }
    
    // killcam settings menu
    self add_menu("killcam", self.menuname, "Verified");
    self add_option("killcam", "(self) killcam rank", ::submenu, "killcam_rank", "killcam rank");
    self add_option("killcam", "killcam length", ::submenu, "killcam_length", "killcam length");
    self add_option("killcam", "end game screen", ::submenu, "end_screen", "end screen");

    // killcam:rank
    self add_menu("killcam_rank", "killcam", "Verified");
    self add_option("killcam_rank", "rank 1 (1 bone)", ::changerank, "1");
    self add_option("killcam_rank", "rank 2 (2 bones)", ::changerank, "2");
    self add_option("killcam_rank", "rank 3 (skull)", ::changerank, "3");
    self add_option("killcam_rank", "rank 4 (skull knife)", ::changerank, "4");
    self add_option("killcam_rank", "rank 5 (skull w/ spikes)", ::changerank, "5");
    self add_option("killcam_rank", "random rank", ::changerank);
    self add_option("killcam_rank", "twitter icon", ::changerank, "menu_lobby_icon_twitter", true);

    // killcam:length
    self add_menu("killcam_length", "killcam", "Verified");
    self add_option("killcam_length", "default time", ::changekctime, 5, true);
    self add_option("killcam_length", "+1 second", ::changekctime, 1);
    self add_option("killcam_length", "-1 second", ::changekctime, -1);
    self add_option("killcam_length", "+5 second", ::changekctime, 5);
    self add_option("killcam_length", "-5 second", ::changekctime, -5);

    // end screen
    self add_menu("end_screen", "killcam", "Verified");
    self add_option("end_screen", "round-based", ::change_screen, true);
    self add_option("end_screen", "victory", ::change_screen, false);
    for(i=0; i<5; i++)
    {
        self add_option("end_screen", "set enemy score to " + i, ::change_score, i);
    }

    // afterhit
    self add_menu("afterhit", self.menuname, "Verified");
    // self add_option("afterhit", "claymore r-mala", scripts\zm\afterhits::afterhitweapon, 0);
    self add_option("afterhit", "five-seven dual wield", scripts\zm\afterhits::afterhitweapon, 0);
    self add_option("afterhit", "knuckles", scripts\zm\afterhits::afterhitweapon, 1);
    self add_option("afterhit", "random perk bottle", scripts\zm\afterhits::afterhitweapon, 2);
    self add_option("afterhit", "syrette", scripts\zm\afterhits::afterhitweapon, 4);
    if (level.script == "zm_prison")
    {
        self add_option("afterhit", "syrette (afterlife)", scripts\zm\afterhits::afterhitweapon, 17);
        self add_option("afterhit", "afterlife hands", scripts\zm\afterhits::afterhitweapon, 6);
        self add_option("afterhit", "tomahawk", scripts\zm\afterhits::afterhitweapon, 5);
        self add_option("afterhit", "death machine", scripts\zm\afterhits::afterhitweapon, 18);
    }
    if (level.script == "zm_transit")
    {
        if(level.gametype != "zstandard") /* have not tested yet MIGHT CAUSES CRASHING ---- TEST LATER! */
        {
            self add_option("afterhit", "screecher arms", scripts\zm\afterhits::afterhitweapon, 16);
        }
    }
    if (level.script == "zm_tomb")
        self add_option("afterhit", "iron punch", scripts\zm\afterhits::afterhitweapon, 7);
    if( level.script == "zm_buried" )
    {
        self add_option("afterhit", "chalk", scripts\zm\afterhits::afterhitweapon, 3);
        self add_option("afterhit", "remington new model army", scripts\zm\afterhits::afterhitweapon, 8);
        self add_option("afterhit", "paralyzer", scripts\zm\afterhits::afterhitweapon, 9);
    }
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("afterhit", "bowie knife", scripts\zm\afterhits::afterhitweapon, 10);
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("afterhit", "galva knuckles", scripts\zm\afterhits::afterhitweapon, 11);
    self add_option("afterhit", "raygun", scripts\zm\afterhits::afterhitweapon, 13);
    self add_option("afterhit", "raygun mk-ii", scripts\zm\afterhits::afterhitweapon, 14);
    self add_option("afterhit", "death animation", scripts\zm\afterhits::afterhitweapon, 12);
    self add_option("afterhit", "toggle auto prone", scripts\zm\afterhits::autoProne);
    self add_option("afterhit", "toggle move after game end", scripts\zm\afterhits::allowMoveAfterhit);
    self add_option("afterhit", "toggle floaters", scripts\zm\afterhits::toggleFloaters);

    // equipment
    self add_menu("equip", self.menuname, "Verified");
    self add_option("equip", "give frag", ::_g_weapon, "frag_grenade_zm");
    if (is_valid_equipment("sticky_grenade_zm"))
    {
        self add_option("equip", "give semtex", ::_g_weapon, "sticky_grenade_zm");
        self add_option("equip", "toggle auto semtex", ::toggleSemtex);
    }
    if (is_valid_equipment("bouncing_tomahawk_zm"))
        self add_option("equip", "hell's retriever", ::__g_weapon, "bouncing_tomahawk_zm");
    if (is_valid_equipment("upgraded_tomahawk_zm"))
        self add_option("equip", "hell's redeemer", ::__g_weapon, "upgraded_tomahawk_zm");
    if (is_valid_equipment("emp_grenade_zm"))
        self add_option("equip", "give emp", ::__g_weapon, "emp_grenade_zm");
    if (is_valid_equipment("willy_pete_zm"))
        self add_option("equip", "give smokes", ::__g_weapon, "willy_pete_zm");
    if (is_valid_equipment("cymbal_monkey_zm"))
        self add_option("equip", "give monkey", ::__g_weapon, "cymbal_monkey_zm");
    if (is_valid_equipment("time_bomb_zm") && isdefined(level.zombiemode_time_bomb_give_func))
        self add_option("equip", "give time bomb", ::g_timebomb);
    if (is_valid_equipment("beacon_zm"))
        self add_option("equip", "give g strike", ::g_beacon);
    if (is_valid_equipment("claymore_zm"))
    {
        self add_option("equip", "give claymore", ::g_claymore);
        self add_option("equip", "toggle auto claymore", ::toggleClaymore);
    }
    self add_option("equip", "pickup radius", ::submenu, "pickup", "change pickup radius");
    self add_option("equip", "nade pickup radius", ::submenu, "nade", "nade pickup radius"); 
    // self add_option("equip", "toggle grenade refill", ::toggleGrenadeRefill); 

    /* pickup radius menu */
    self add_menu("pickup", "equip", "Verified");
    self add_option("pickup", "pickup radius 100", ::expickup, 100);
    self add_option("pickup", "pickup radius 200", ::expickup, 200);
    self add_option("pickup", "pickup radius 300", ::expickup, 300);
    self add_option("pickup", "pickup radius 400", ::expickup, 400);
    self add_option("pickup", "pickup radius 500", ::expickup, 500);
    self add_option("pickup", "pickup radius 600", ::expickup, 600);
    self add_option("pickup", "pickup radius 700", ::expickup, 700);
    self add_option("pickup", "pickup radius 800", ::expickup, 800);
    self add_option("pickup", "pickup radius 900", ::expickup, 900);
    self add_option("pickup", "pickup radius 1000", ::expickup, 1000);
    self add_option("pickup", "pickup radius 2000", ::expickup, 2000);
    self add_option("pickup", "pickup radius 3000", ::expickup, 3000);
    self add_option("pickup", "pickup radius 4000", ::expickup, 4000);
    self add_option("pickup", "page 2", ::submenu, "pickup2", "change pickup radius 2"); 
    /* pickup radius menu - page 2 */
    self add_menu("pickup2", "pickup", "Verified");
    self add_option("pickup2", "pickup radius 5000", ::expickup, 5000);
    self add_option("pickup2", "pickup radius 6000", ::expickup, 6000);
    self add_option("pickup2", "pickup radius 7000", ::expickup, 7000);
    self add_option("pickup2", "pickup radius 8000", ::expickup, 8000);
    self add_option("pickup2", "pickup radius 9000", ::expickup, 9000);
    self add_option("pickup2", "pickup radius 10000", ::expickup, 10000);

    /* nade radius menu */
    self add_menu("nade", "equip", "Verified");
    self add_option("nade", "nade radius 100", ::grenaderadius, 100);
    self add_option("nade", "nade radius 200", ::grenaderadius, 200);
    self add_option("nade", "nade radius 300", ::grenaderadius, 300);
    self add_option("nade", "nade radius 400", ::grenaderadius, 400);
    self add_option("nade", "nade radius 500", ::grenaderadius, 500);
    self add_option("nade", "nade radius 600", ::grenaderadius, 600);
    self add_option("nade", "nade radius 700", ::grenaderadius, 700);
    self add_option("nade", "nade radius 800", ::grenaderadius, 800);
    self add_option("nade", "nade radius 900", ::grenaderadius, 900);
    self add_option("nade", "nade radius 1000", ::grenaderadius, 1000);
    self add_option("nade", "nade radius 2000", ::grenaderadius, 2000);
    self add_option("nade", "nade radius 3000", ::grenaderadius, 3000);
    self add_option("nade", "nade radius 4000", ::grenaderadius, 4000);
    self add_option("nade", "page 2", ::submenu, "nade2", "nade pickup radius 2"); 
    /* nade radius menu - page 2 */
    self add_menu("nade2", "nade", "Verified");
    self add_option("nade2", "nade radius 5000", ::grenaderadius, 5000);
    self add_option("nade2", "nade radius 6000", ::grenaderadius, 6000);
    self add_option("nade2", "nade radius 7000", ::grenaderadius, 7000);
    self add_option("nade2", "nade radius 8000", ::grenaderadius, 8000);
    self add_option("nade2", "nade radius 9000", ::grenaderadius, 9000);
    self add_option("nade2", "nade radius 10000", ::grenaderadius, 10000);

    /* perks menu */
    self add_menu("perk", self.menuname, "Verified");
    self add_option("perk", "fast hands (weapon switch)", ::fasthands);
    // self add_option("perk", "fast hands (weapon switch)", ::doperks, "specialty_fastweaponswitch",1);
    self add_option("perk", "unlimited sprint", ::doperks, "specialty_unlimitedsprint",1);
    self add_option("perk", "lightweight (fall damage)", ::doperks, "specialty_fallheight",1);

    self _blank("perk",true);

    if (is_true(level.zombiemode_using_juggernaut_perk))
        self add_option("perk", "juggernaut", ::doperks, "specialty_armorvest",1);
    if (is_true(level.zombiemode_using_sleightofhand_perk))
        self add_option("perk", "fast reload", ::doperks, "specialty_fastreload",1);
    if (is_true(level.zombiemode_using_doubletap_perk))
        self add_option("perk", "double tap", ::doperks, "specialty_rof",1);
    if (is_true(level.zombiemode_using_deadshot_perk))
        self add_option("perk", "deadshot", ::doperks, "specialty_deadshot",1);
    if (is_true(level.zombiemode_using_tombstone_perk))
        self add_option("perk", "tombstone", ::doperks, "specialty_scavenger",1);
    if (is_true(level.zombiemode_using_additionalprimaryweapon_perk))
        self add_option("perk", "mule kick", ::doperks, "specialty_additionalprimaryweapon",1);
    if (level.script == "zm_highrise")
        self add_option("perk", "whos who", ::doperks, "specialty_finalstand",1);
    if (is_true(level.zombiemode_using_revive_perk))
        self add_option("perk", "quick revive", ::doperks, "specialty_quickrevive",1);
    if (level.script == "zm_prison" || level.script == "zm_tomb")
        self add_option("perk", "electric cherry", ::doperks, "specialty_grenadepulldeath",1);
    if (is_true(level.zombiemode_using_marathon_perk))
        self add_option("perk", "staminup", ::doperks, "specialty_longersprint",1);
    if (level.script == "zm_buried")
        self add_option("perk", "vulture aid", ::doperks, "specialty_nomotionsensor",1);
	// if ( level.zombiemode_using_divetonuke_perk )
    if (level.script == "zm_tomb")
        self add_option("perk", "phd flopper", ::doperks, "specialty_flakjacket",1);

    /* stalls menu */
    self add_menu("stalls", self.menuname, "Verified");
    
    self add_option("stalls", "revive radius", ::submenu, "revive", "change revive radius");
    /* revive radius menu */
    self add_menu("revive", "stalls", "Verified");
    self add_option("revive", "revive radius 100", ::reviveradius, 100);
    self add_option("revive", "revive radius 200", ::reviveradius, 200);
    self add_option("revive", "revive radius 300", ::reviveradius, 300);
    self add_option("revive", "revive radius 400", ::reviveradius, 400);
    self add_option("revive", "revive radius 500", ::reviveradius, 500);
    self add_option("revive", "revive radius 600", ::reviveradius, 600);
    self add_option("revive", "revive radius 700", ::reviveradius, 700);
    self add_option("revive", "revive radius 800", ::reviveradius, 800);
    self add_option("revive", "revive radius 900", ::reviveradius, 900);
    self add_option("revive", "revive radius 1000", ::reviveradius, 1000);
    self add_option("revive", "revive radius 2000", ::reviveradius, 2000);
    self add_option("revive", "revive radius 3000", ::reviveradius, 3000);
    self add_option("revive", "revive radius 4000", ::reviveradius, 4000);
    self add_option("revive", "page 2", ::submenu, "revive2", "change revive radius 2"); 
    /* revive radius menu - page 2 */
    self add_menu("revive2", "revive", "Verified");
    self add_option("revive2", "revive radius 5000", ::reviveradius, 5000);
    self add_option("revive2", "revive radius 6000", ::reviveradius, 6000);
    self add_option("revive2", "revive radius 7000", ::reviveradius, 7000);
    self add_option("revive2", "revive radius 8000", ::reviveradius, 8000);
    self add_option("revive2", "revive radius 9000", ::reviveradius, 9000);
    self add_option("revive2", "revive radius 10000", ::reviveradius, 10000);

    /* binds menu */
    // self add_menu("binds", self.menuname, "Verified");
    // /* buried will have 8 rn */
    // self add_option("binds", "^1reset all binds^7", ::bindinit, true);

    // self _blank("binds");

    // self add_option("binds", "change canswap bind", ::changebind, "canswap", "Canswap");
    // self add_option("binds", "knuckle crack bind", ::changebind, "knucklecrack", "Knuckle Crack Animation");
    // if (level.script != "zm_tomb" && level.script != "zm_prison")
    // {
    //     self add_option("binds", "bowie knife animation bind", ::changebind, "bowieanim", "Bowie Knife Animation");
    //     self add_option("binds", "galva knuckles animation bind", ::changebind, "galvaanim", "Galva Knuckles Animation");

    //     if (level.script == "zm_buried") {
    //         self add_option("binds", "chalk draw animation bind", ::changebind, "chalkdrawanim", "Chalk Draw Animation");
    //     }
    // }
    // if (level.script == "zm_tomb") {
    //         self add_option("binds", "iron fists animation bind", ::changebind, "oipanim", "Iron Fists Animation");
    // }
    // if (level.script == "zm_prison") {
    //     self add_option("binds", "tomahawk spin animation bind", ::changebind, "axeanim", "Tomahawk Spin Animation");
    // }

    // self add_option("binds", "flip binds menu", ::submenu, "flipbinds", "flip binds menu"); 
    // /* flips menu */
    // self add_menu("flipbinds", "binds", "Verified");
    // self add_option("flipbinds", "backflip bind", ::changebind, "backflip", "Backflip Bind");
    // self add_option("flipbinds", "frontflip bind", ::changebind, "frontflip", "Frontflip Bind");
    // self add_option("flipbinds", "leftflip bind", ::changebind, "leftflip", "Leftflip Bind");
    // self add_option("flipbinds", "rightflip bind", ::changebind, "rightflip", "Rightflip Bind");

    // self add_option("binds", "page 2", ::submenu, "binds2", "binds page 2");
    // /* binds menu - page 2 */
    // self add_menu("binds2", "binds", "Verified");
    // self add_option("binds2", "placeholder", ::print_wrapper, "placeholder button");

    // zombies
    self add_menu("zombies", self.menuname, "Verified");
    self add_option("zombies", "spawn zombie", ::spawn_zombie);
    // self add_option("zombies", "kick zombie", ::kick_zombie);
    if(level.script == "zm_tomb")
        self add_option("zombies", "spawn panzer", ::SpawnPanzer);
    if(level.script == "zm_prison")
        self add_option("zombies", "spawn brutus", ::SpawnBrutus);
    self add_option("zombies", "freeze zombie(s)", ::freezezm);
    self add_option("zombies", "zombie(s) ignore you", ::zmignoreme);
    self add_option("zombies", "zombie(s) -> crosshair", ::tp_zombies);
    self add_option("zombies", "load zombies position", ::loadzombiepos);
    self add_option("zombies", "individual zombies menu", ::submenu, "zombies_menu", "individual zombies menu");

    self add_menu("zombies_menu", "zombies", "Verified");
    for(i = 0; i < 17; i++)
    {
        self add_menu("zOzt " + i, "zombies_menu", "Verified");
    }

    // bots
    self add_menu("bots", self.menuname, "Verified");
    self add_option("bots", "spawn 1 bot", ::spawnbot);
    self add_option("bots", "bot(s) -> crosshair", ::tpbotstocrosshair);
    self add_option("bots", "toggle invisible bot(s)", ::makebotinvis);
    self add_option("bots", "bot(s) look @ me", ::makebotswatch);
    self add_option("bots", "bot(s) constant look @ me", ::constantlookbot);

    self add_menu("lobby", self.menuname, "admin");
    self add_option("lobby", "zombie counter", ::togglezmcounter);
    self add_option("lobby", "timescale 0.25", ::timescale, 0.25);
    self add_option("lobby", "timescale 0.5", ::timescale, 0.50);
    self add_option("lobby", "timescale 0.75", ::timescale, 0.75);
    self add_option("lobby", "timescale 1", ::timescale, 1);
    self add_option("lobby", "timescale 2", ::timescale, 2);
    if(verification_to_num(self.status) > verification_to_num("co"))
    {
        self add_option("lobby", "fast restart", ::fastrestart);
        self add_option("lobby", "end game", ::custom_end_game_f);
        self add_option("lobby", "instant end game", ::instantend);
    }
    self add_menu("players_menu", self.menuname, "Verified");
    for(i = 0; i < 17; i++)
    {
        self add_menu("pOpt " + i, "players_menu", "Verified");
    }
}

update_players_menu()
{
    level endon("game_ended");

    // clear data that still may possibly exist
    self.menu.menucount["players_menu"] = 0;
    self.menu.menuopt["players_menu"] = []; // fixes bugs with players that are no longer in game to be off the list

    players = getplayers();
    for(i=0; i<players.size; i++)
    {
        player = players[i];
        if (!isdefined(player))
            continue;

        player_name = player get_the_player_name();

        player_size_fixed = players.size - 1;
        if (self.menu.curs["players_menu"] > player_size_fixed)
        {
            self.menu.scrollerpos["players_menu"] = player_size_fixed;
            self.menu.curs["players_menu"] = player_size_fixed;
        }

        option_text = player_name;
        if (verification_to_num(player.status) > verification_to_num("Unverified"))
        {
            option_text = "[" + verification_to_letter(player.status) + "^7] " + player_name;
        }

        self add_option("players_menu", option_text, ::submenu, "pOpt " + i, option_text, false);
        self add_menu_alt("pOpt " + i, "players_menu");

        self add_option("pOpt " + i, "teleport to crosshair", ::teleport_crosshair, player);
        self add_option("pOpt " + i, "teleport to me", ::teleport_player, player, self);
        self add_option("pOpt " + i, "teleport to player", ::teleport_player, self, player);
        if (verification_to_num(self.status) > verification_to_num("co") && !player isBot() && verification_to_num(self.status) >= verification_to_num(player.status) || verification_to_num(self.status) > verification_to_num("Unverified") && player isBot() )
        {
            self add_option("pOpt " + i, "kick", ::kickplayer, player);
            self add_option("pOpt " + i, "kill", ::killplayer, player);
            self add_option("pOpt " + i, "god", ::godmode, player);
            self add_option("pOpt " + i, "switch player team", ::switchteams, player);
            if (level.script == "zm_prison")
                self add_option("pOpt " + i, "jumpscare player", ::__jumpscare, player);
        }
    }
}

update_zombies_menu()
{
    level endon("game_ended");

    // clear data that still may possibly exist
    self.menu.menucount["zombies_menu"] = 0;
    self.menu.menuopt["zombies_menu"] = []; // fixes bugs with players that are no longer in game to be off the list

    zombies = getaiarray(level.zombie_team);
    for(i=0; i<zombies.size; i++)
    {
        zombie = zombies[i];

        zombie_size_fixed = zombies.size - 1;
        if (self.menu.curs["zombies_menu"] > zombie_size_fixed)
        {
            self.menu.scrollerpos["zombies_menu"] = zombie_size_fixed;
            self.menu.curs["zombies_menu"] = zombie_size_fixed;
        }

        num = zombie get_ai_number();
        option_text = "[" + num + "^7] zombie";

        self add_option("zombies_menu", option_text, ::submenu, "zOzt " + i, option_text);

        self add_menu_alt("zOzt " + i, "zombies_menu");

        self add_option("zOzt " + i, "teleport to crosshair", ::tp_zombies, num);
        self add_option("zOzt " + i, "save zombie pos", ::savezombiepos, num);
        self add_option("zOzt " + i, "load zombie pos", ::loadzombiepos, num);
    }
}
