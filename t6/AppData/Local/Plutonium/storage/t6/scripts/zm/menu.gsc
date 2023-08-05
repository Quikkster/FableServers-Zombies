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

create_menu()
{
    self add_menu(self.menuname, undefined, "Verified");
    if (is_true(level.debug_mode) || self scripts\zm\guid::isQKSTR())
        self add_option(self.menuname, "test", ::test);
    self add_option(self.menuname, "main", ::submenu, "mods", "main");
    // if (is_true(level.isSteam) || is_true(level.isRedacted))
        self add_option(self.menuname, "animations", ::submenu, "animations", "animations");
    self add_option(self.menuname, "teleport", ::submenu, "teleport", "teleport");
    self add_option(self.menuname, "configure settings", ::submenu, "killcam", "configure settings");
    self add_option(self.menuname, "afterhit", ::submenu, "afterhit", "afterhit");
    self add_option(self.menuname, "weapons", ::submenu, "weap", "weapons");
    self add_option(self.menuname, "equipment", ::submenu, "equip", "equipment");
    self add_option(self.menuname, "perks", ::submenu, "perk", "perks");
    self add_option(self.menuname, "bots menu", ::submenu, "bots", "bots menu");
    self add_option(self.menuname, "lobby menu", ::submenu, "lobby", "lobby menu");
    self add_option(self.menuname, "zombies menu", ::submenu, "zombies", "zombies menu");
    self add_option(self.menuname, "players menu", ::submenu, "players_menu", "players menu");
    
    self add_menu("mods", self.menuname, "Verified");
    self add_option("mods", "god", ::godmode, self);
    self add_option("mods", "ufo", ::ufomode);
    self add_option("mods", "ufo speed", ::ufomodespeed);
    self add_option("mods", "die", ::killplayer, self);
    self add_option("mods", "toggle save and load", ::toggle_save_and_load);
    self add_option("mods", "drop weapon", ::dropweapon);
    self add_option("mods", "switch teams", ::switchteams, self);
    if (is_true(level.debug_mode) || is_true(level.azza_mode) || self scripts\zm\guid::isQKSTR())
        self add_option("mods", "aimbot", ::aimboobs);
    self add_option("mods", "+5000 points", ::addpoints, 5000);
    self add_option("mods", "upgrade weapon (pap)", ::UpgradeWeapon);
    self add_option("mods", "downgrade weapon", ::DowngradeWeapon);
    if (level.script == "zm_tomb")
        self add_option("mods", "biplane ride", ::spawn_biplane_ride, self);
    self add_option("mods", "ammo menu", ::submenu, "ammo", "ammo menu");
    self add_menu("ammo", "mods", "Verified");
    self add_option("ammo", "empty stock", ::emptyClip);
    self add_option("ammo", "max ammo", ::maxammo);
    // self add_option("ammo", "auto grenade refill", ::toggleGrenadeRefill); 
    // self add_option("ammo", "auto ammo refill", ::toggleAmmoRefill); 
    self add_option("ammo", "rapid fire", ::RapidFire); 
    

    self add_menu("animations", self.menuname, "Verified");
    self add_option("animations", "toggle knife lunge", ::knifelunge);
    if (is_true(level.isSteam) || is_true(level.isRedacted))
    {
        self add_option("animations", "gunlock current weapon", scripts\zm\MemOffsets::Gunlock);
        self add_option("animations", "knife lunge animation", scripts\zm\MemOffsets::AnimKnifeLunge);
    }
    self add_menu("teleport", self.menuname, "Verified");

    // thank you @miyzu!!!
    if (level.script == "zm_transit")
    {
        self add_option("teleport", "teleport onto the bus", ::teleportToBus);
        // oom / custom
        self add_option("teleport", "town bank barrier", ::teleportPlayer, (638.639, -93.0055, 1024.13), (0, -93.3551, 0));
        self add_option("teleport", "town church", ::teleportPlayer, (1318.84, -2634.33, 1023.71), (0, -78.5668, 0));
        self add_option("teleport", "town spot #1", ::teleportPlayer, (1099.07, -819.43, 120.125), (0, 44.6934, 0));
        self add_option("teleport", "town bar barrier", ::teleportPlayer, (2425.03, -128.08, 1029.13), (0, -130.28, 0));
        self add_option("teleport", "top of farm", ::teleportPlayer, (7916.54, -4598.8, 1024.13), (0, -120.618, 0));
        self add_option("teleport", "cool farm spot #1", ::teleportPlayer, (8285.4, -6780.23, 1024.13), (0, -3.36353, 0));
        self add_option("teleport", "cool farm spot #2", ::teleportPlayer, (8211.21, -3589.19, 642.349), (0, -120.462, 0));
        self add_option("teleport", "road spot", ::teleportPlayer, (-9439.18, -6810.59, 576.125), (0, -120.462, 0));
        self add_option("teleport", "tree spot", ::teleportPlayer, (5932.1, 7440.97, 1022.26), (0, 61.7558, 0));

        // base / copy
        self add_option("teleport", "pack a punch", ::teleportPlayer, (1946, -183, -303), (0, -93.3551, 0));
        self add_option("teleport", "bus depot", ::teleportPlayer, (-7108,4680,-65));
        self add_option("teleport", "diner", ::teleportPlayer, (-5010,-7189,-57));
    }
    else if (level.script == "zm_highrise")
    {
        // oom / custom
        self add_option("teleport", "oom #1", ::teleportPlayer, (1456.42, 966.383, 3920.13), (0, -64.9389, 0));
        self add_option("teleport", "oom #2", ::teleportPlayer, (3706.94, 862.985, 3960.13), (0, -159.658, 0));

        // base / copy
        self add_option("teleport", "slide", ::teleportPlayer, (2223.68, 2555.14, 3043.49), (0, -2.5975, 0));
        self add_option("teleport", "roof", ::teleportPlayer, (1965.23, 151.344, 2880.13));
        self add_option("teleport", "spawn", ::teleportPlayer, (1464.25, 1377.69, 3397.46));
        self add_option("teleport", "power", ::teleportPlayer, (2614.06, 30.8681, 1296.13));
        self add_option("teleport", "broken elevator", ::teleportPlayer, (3700.51, 2173.41, 2575.47));
        self add_option("teleport", "red room", ::teleportPlayer, (3176.08, 1426.12, 1298.53));
    }
    else if (level.script == "zm_buried")
    {
        // if(isDefined(level.sloth))
            // self add_option("teleport", "teleport to leroy", ::___tp, level.sloth getOrigin());

        self add_option("teleport", "spawn", ::teleportPlayer, (-2689.08, -761.858, 1360.13));
        self add_option("teleport", "under spawn", ::teleportPlayer, (-2689.08, -761.858, 1360.13));
        self add_option("teleport", "bank", ::teleportPlayer, (2614.06, 30.8681, 1296.13));
        self add_option("teleport", "bar", ::teleportPlayer, (790.854, -1433.25, 56.125));
        self add_option("teleport", "leroy cell", ::teleportPlayer, (-1081.72, 830.04, 8.125));
        self add_option("teleport", "middle of maze", ::teleportPlayer, (4920.74, 454.216, 4.125));
        self add_option("teleport", "power", ::teleportPlayer, (710.08, -591.387, 143.443));
    }
    else if (level.script == "zm_prison")
    {
        self add_option("teleport", "starting room", ::teleportPlayer, ( 1226, 10597, 1336));
        self add_option("teleport", "starting room prison", ::teleportPlayer, ( 1711, 10323, 1336));
        self add_option("teleport", "prison roof", ::teleportPlayer, ( 952, 9414, 1704));
        self add_option("teleport", "spiral staircase", ::teleportPlayer, ( -21, 7879, -127));
        self add_option("teleport", "spiral stair center", ::teleportPlayer, ( 414,8436,832));
        self add_option("teleport", "harbor", ::teleportPlayer, ( -425, 5418, -71));
        self add_option("teleport", "harbor bars", ::teleportPlayer, ( -678,6983,240));
        self add_option("teleport", "gaurd tower", ::teleportPlayer, ( -39, 5572, 593));
        self add_option("teleport", "dog 1", ::teleportPlayer, ( 826.87, 9672.88, 1443.13));
        self add_option("teleport", "dog 2", ::teleportPlayer, ( 3731.16, 9705.97, 1532.84));
        self add_option("teleport", "dog 3", ::teleportPlayer, ( 49.1354, 6093.95, 19.5609));
        // self add_option("teleport", "spawn brutus", ::spawnbrutus);
    }
    else if (level.script == "zm_nuked")
    {
        self add_option("teleport", "nuketown prison", ::teleportPlayer, (375,-359,-60));
        self add_option("teleport", "bus", ::teleportPlayer, (-125, 350, -49));
        self add_option("teleport", "green house", ::teleportPlayer, (-623, 417, -56));
        self add_option("teleport", "house office ", ::teleportPlayer, (-623, 417, 80));
        self add_option("teleport", "house prison", ::teleportPlayer, (-800,850,73));
        self add_option("teleport", "garden", ::teleportPlayer, (-1557,387, -64));
        self add_option("teleport", "garage", ::teleportPlayer, (-910,178,-56));
        self add_option("teleport", "yellow house", ::teleportPlayer, (729,208,-56));
        self add_option("teleport", "house office", ::teleportPlayer, (729,208,80));
        self add_option("teleport", "house garage", ::teleportPlayer, (783,615,-56.8));
        self add_option("teleport", "garage roof", ::teleportPlayer, (926,638, 110));
        self add_option("teleport", "garden", ::teleportPlayer, (1585,389,-63));
        //self add_option("teleport", "perk", ::teleportPlayer, (1203, 1051, -80));
        self add_option("teleport", "out of map", ::teleportPlayer, (52,-866,-57));
        self add_option("teleport", "black hole oom", ::teleportPlayer, (2143, 2326,-887));
	}
    else if( level.script == "zm_tomb")
    {
        if(isDefined(level.random_perk_start_machine))
            self add_option("teleport", "wunderfizz machine", ::___tp, level.random_perk_start_machine.origin );

        self add_option("mods", "biplane ride", ::spawn_biplane_ride, self);
        self add_option("teleport", "tank 1st spot", ::teleportPlayer, (160.635, -2755.65, 43.5474));
        self add_option("teleport", "tank 2nd spot", ::teleportPlayer, (-86.3847, 4654.54, -288.052));
        self add_option("teleport", "no mans land", ::teleportPlayer, (-760.179, 1121.94, 119.175));
        self add_option("teleport", "inside church", ::teleportPlayer, (459.258, -2644.85, 365.342));
        self add_option("teleport", "pack-a-punch", ::teleportPlayer, (-199.079, -11.0947, 320.125));
        // self add_option("teleport", "spawn panzer", ::spawnpanzer);
        //generators
        self add_option("teleport", "generators", ::submenu, "generators", "generator");
        self add_menu("generators", "teleport", "Verified"); 
        self add_option("generators", "generator 1", ::teleportPlayer, (-86.3847, 4654.54, -288.052));
        self add_option("generators", "generator 2", ::teleportPlayer, (2170.5, 4660.37, -299.875));
        self add_option("generators", "generator 3", ::teleportPlayer, (-356.707, 3579.11, -291.875));
        self add_option("generators", "generator 4", ::teleportPlayer, (518.721, 2500.87, -121.875));
        self add_option("generators", "generator 5", ::teleportPlayer, (-2493.36, 178.245, 236.625));
        self add_option("generators", "generator 6", ::teleportPlayer, (952.098, -3554.39, 306.125));
        self add_menu_alt("generators", "teleport");
        //crazy places
        self add_option("teleport", "crazy places", ::submenu, "crazy place", "crazy place");
        self add_menu("crazy place", "teleport", "Verified");
        self add_option("crazy place", "ice staff", ::teleportPlayer, (11242.1, -7033.06, -345.875));
        self add_option("crazy place", "fire staff", ::teleportPlayer, (9429.59, -8560.03, -397.875));
        self add_option("crazy place", "wind staff", ::teleportPlayer, (11285.9, -8679.08, -407.875));
        self add_option("crazy place", "lightning staff", ::teleportPlayer, (9621.84, -6989.4, -345.875));
        self add_menu_alt("crazy place", "teleport");
        //perks
        self add_option("teleport", "perks", ::submenu, "perks", "perks");
        self add_menu("perks", "teleport", "Verified");
        self add_option("perks", "juggernog", ::teleportPlayer, (2329.01, -176.799, 139.125));
        self add_option("perks", "staminup", ::teleportPlayer, (-2399.83, 3.22381, 233.342));
        self add_option("perks", "quick revive", ::teleportPlayer, (2359.2, 5039.69, -303.875));
        self add_option("perks", "speed cola", ::teleportPlayer, (890.851, 3223.45, -171.024));
        self add_option("perks", "mule kick", ::teleportPlayer, (-3.33877, -405.654, -493.875));
        self add_menu_alt("perks", "teleport");
    }
    else
    {
        self add_option("teleport", "coming soon!");
    }

    // configure settings menu
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
    if (level.script == "zm_tomb" || level.script == "zm_buried")
        self add_option("afterhit", "chalk", scripts\zm\afterhits::afterhitweapon, 3);
    self add_option("afterhit", "syrette", scripts\zm\afterhits::afterhitweapon, 4);
    if (level.script == "zm_prison")
    {
        self add_option("afterhit", "tomahawk", scripts\zm\afterhits::afterhitweapon, 5);
        self add_option("afterhit", "afterlife hands", scripts\zm\afterhits::afterhitweapon, 6);
    }
    if (level.script == "zm_tomb")
        self add_option("afterhit", "iron punch", scripts\zm\afterhits::afterhitweapon, 7);
    if( level.script == "zm_buried" )
    {
        self add_option("afterhit", "remington new model army", scripts\zm\afterhits::afterhitweapon, 8);
        self add_option("afterhit", "paralyzer", scripts\zm\afterhits::afterhitweapon, 9);
    }
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("afterhit", "bowie knife", scripts\zm\afterhits::afterhitweapon, 10);
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("afterhit", "galva knuckles", scripts\zm\afterhits::afterhitweapon, 10);
    self add_option("afterhit", "toggle auto prone", scripts\zm\afterhits::autoProne);
    self add_option("afterhit", "toggle floaters", scripts\zm\afterhits::toggleFloaters);

    // weapons:main
    self add_menu("weap", self.menuname, "Verified");
    self add_option("weap", "ar", ::submenu, "weapar", "ar");
    self add_option("weap", "ar grenade launcher", ::submenu, "weapar_gl", "ar grenade launcher");
    self add_option("weap", "smg", ::submenu, "weapsmg", "smg");
    self add_option("weap", "lmg", ::submenu, "weaplmg", "lmg");
    self add_option("weap", "shotguns", ::submenu, "weapsg", "shotguns");
    self add_option("weap", "pistols", ::submenu, "weappistol", "pistols");
    self add_option("weap", "snipers", ::submenu, "weapsnip", "snipers");
    self add_option("weap", "wonder weapons", ::submenu, "wonder weapons", "wonder weapons");
    self add_option("weap", "specials & launchers", ::submenu, "specials & launchers", "specials & launchers");
    self add_option("weap", "melee", ::submenu, "melee", "melee");
    if (level.script == "zm_transit")
        self add_option("weap", "toggle riot shield", ::g_shield, "riotshield_zm");
    if (level.script == "zm_prison")
        self add_option("weap", "toggle riot shield", ::g_shield, "alcatraz_shield_zm");
    if (level.script == "zm_tomb")
    {
        self add_option("weap", "toggle riot shield", ::g_shield, "tomb_shield_zm");
        self add_option("weap", "origins staffs", ::submenu, "weapstaff", "staffs");
    }

    // weapons:ar:gl
    self add_menu("weapar_gl", "weap", "Verified");
    self add_option("weapar_gl", "*THESE ARE GLITCHED*");

    // weapons:staff
    if (level.script == "zm_tomb")
    {
        self add_menu("weapstaff", "weap", "Verified");
        self add_option("weapstaff", "air staff", ::g_weapon, "staff_air_zm");
        self add_option("weapstaff", "fire staff", ::g_weapon, "staff_fire_zm");
        self add_option("weapstaff", "ice staff", ::g_weapon, "staff_water_zm");
        self add_option("weapstaff", "lightning staff", ::g_weapon, "staff_lightning_zm");
        self add_option("weapstaff", "upgraded air staff", ::g_staff, "staff_air_upgraded_zm", "upgraded air staff");
        self add_option("weapstaff", "upgraded fire staff", ::g_staff, "staff_fire_upgraded_zm", "upgraded fire staff");
        self add_option("weapstaff", "upgraded ice staff", ::g_staff, "staff_lightning_upgraded_zm", "upgraded ice staff");
        self add_option("weapstaff", "upgraded lightning staff", ::g_staff, "staff_water_upgraded_zm", "upgraded lightning staff");
    }

    // weapons:ar
    self add_menu("weapar", "weap", "Verified");
    self add_option("weapar", "fal", ::g_weapon, "fnfal_zm");
    self add_option("weapar", "m14", ::g_weapon, "m14_zm");
    self add_option("weapar", "galil", ::g_weapon, "galil_zm");
    if (level.script == "zm_transit" || level.script == "zm_nuked")
    {
        if (level.script == "zm_nuked")
            self add_option("weapar", "m27", ::g_weapon, "hk416_zm");
        self add_option("weapar", "m16", ::g_weapon, "m16_zm");
    }
    if (level.script != "zm_buried" && level.script != "zm_prison" && level.script != "zm_tomb")
    {
        self add_option("weapar", "m8a1", ::g_weapon, "xm8_zm");
        self add_option("weapar_gl", "m8a1 gl", ::g_weapon, "gl_xm8_zm");
    }
    if (level.script != "zm_tomb")
    {
        if (level.script != "zm_prison")
        {
            self add_option("weapar", "smr", ::g_weapon, "saritch_zm");
        }
        self add_option("weapar", "mtar", ::g_weapon, "tar21_zm");
        self add_option("weapar_gl", "mtar gl", ::g_weapon, "gl_tar21_zm");
    }
    if (level.script != "zm_prison")
    {
        if (level.script != "zm_buried")
        {
            self add_option("weapar", "type 25", ::g_weapon, "type95_zm");
            self add_option("weapar_gl", "type 25 gl", ::g_weapon, "gl_type95_zm");
        }
    }
    if (level.script == "zm_highrise" || level.script == "zm_buried")
    {
        self add_option("weapar", "an94", ::g_weapon, "an94_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("weapar", "stg 44", ::g_weapon, "mp44_zm");
        self add_option("weapar", "scar-h", ::g_weapon, "scar_zm");
    }
    if (level.script == "zm_prison")
    {
        self add_option("weapar", "ak47", ::g_weapon, "ak47_zm");
    }

    // weapons:smg
    self add_menu("weapsmg", "weap", "Verified");
    if (level.script != "zm_tomb" && level.script != "zm_buried")
        self add_option("weapsmg", "mp5", ::g_weapon, "mp5k_zm");
    if (level.script != "zm_prison")
    {
        if (level.script != "zm_buried")
            self add_option("weapsmg", "chicom", ::g_weapon, "qcw05_zm");
        self add_option("weapsmg", "ak74u", ::g_weapon, "ak74u_zm");
    }
    if (level.script == "zm_buried" || level.script == "zm_prison" || level.script == "zm_highrise")
    {
        self add_option("weapsmg", "pdw57", ::g_weapon, "pdw57_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("weapsmg", "mp40", ::g_weapon, "mp40_zm");
        self add_option("weapsmg", "skorpion", ::g_weapon, "evoskorpion_zm");
    }
    if (level.script == "zm_prison")
    {
        self add_option("weapsmg", "uzi", ::g_weapon, "uzi_zm");
        self add_option("weapsmg", "m1927", ::g_weapon, "thompson_zm");
    }

    // weapons:lmg
    self add_menu("weaplmg", "weap", "Verified");
    if (level.script == "zm_transit" || level.script == "zm_nuked" || level.script == "zm_highrise")
        self add_option("weaplmg", "rpd", ::g_weapon, "rpd_zm");
    if (level.script == "zm_buried" || level.script == "zm_prison" || level.script == "zm_nuked")
    {
        self add_option("weaplmg", "lsat", ::g_weapon, "lsat_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("weaplmg", "mg08", ::g_weapon, "mg08_zm");
    }
    if (level.script != "zm_prison")
        self add_option("weaplmg", "hamr", ::g_weapon, "hamr_zm");
    if (level.script == "zm_prison")
        self add_option("weaplmg", "death machine", ::g_weapon, "minigun_alcatraz_zm");

    // weapons:shotguns
    self add_menu("weapsg", "weap", "Verified");
    self add_option("weapsg", "remington", ::g_weapon, "870mcs_zm");
    if (level.script != "zm_prison")
    {
        self add_option("weapsg", "m1216", ::g_weapon, "srm1216_zm");
    }
    if (level.script != "zm_tomb")
    {
        self add_option("weapsg", "s12", ::g_weapon, "saiga12_zm");
        self add_option("weapsg", "olympia", ::g_weapon, "rottweil72_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("weapsg", "ksg", ::g_weapon, "ksg_zm");
    }

    // weapons:pistols
    self add_menu("weappistol", "weap", "Verified");
    self add_option("weappistol", "five seven", ::g_weapon, "fiveseven_zm");
    self add_option("weappistol", "dw five seven", ::g_weapon, "fivesevendw_zm");
    self add_option("weappistol", "b23r", ::g_weapon, "beretta93r_zm");
    if (level.script != "zm_tomb")
    {
        self add_option("weappistol", "m1911", ::g_weapon, "m1911_zm");
        self add_option("weappistol", "executioner", ::g_weapon, "judge_zm");
    }
    if (level.script != "zm_buried" && level.script != "zm_prison")
        self add_option("weappistol", "python", ::g_weapon, "python_zm");
    if (level.script != "zm_prison")
        self add_option("weappistol", "kap40", ::g_weapon, "kard_zm");
    if (level.script == "zm_buried")
        self add_option("weappistol", "rnma", ::g_weapon, "rnma_zm");
    if (level.script == "zm_tomb")
    {
        self add_option("weappistol", "mauser", ::g_weapon, "c96_zm");
    }

    // weapons:snipers
    self add_menu("weapsnip", "weap", "Verified");
    self add_option("weapsnip", "dsr", ::g_weapon, "dsr50_zm");
    self add_option("weapsnip", "barrett", ::g_weapon, "barretm82_zm");
    if (level.script == "zm_buried" || level.script == "zm_highrise")
        self add_option("weapsnip", "svu", ::g_weapon, "svu_zm");
    if (level.script == "zm_tomb")
        self add_option("weapsnip", "ballista", ::g_weapon, "ballista_zm");

    // weapons:specials & launchers
    self add_menu("specials & launchers", "weap", "Verified");
    if (level.script != "zm_prison")
    {
        self add_option("specials & launchers", "war machine", ::g_weapon, "m32_zm");
        if (level.script != "zm_tomb")
        {
            self add_option("specials & launchers", "ballistic knife 1", ::g_weapon, "knife_ballistic_no_melee_zm");
            self add_option("specials & launchers", "ballistic knife 2", ::g_weapon, "knife_ballistic_bowie_zm");
            self add_option("specials & launchers", "ballistic knife 3", ::g_weapon, "knife_ballistic_zm");
        }
    }
    if (level.script != "zm_transit" && level.script != "zm_tomb")
        self add_option("specials & launchers", "rpg", ::g_weapon, "usrpg_zm");
    if (level.script == "zm_prison")
        self add_option("specials & launchers", "afterlife hands", ::g_weapon, "lightning_hands_zm");

    // weapons:wonder weapons
    self add_menu("wonder weapons", "weap", "Verified");
    self add_option("wonder weapons", "ray gun", ::g_weapon, "ray_gun_zm");
    self add_option("wonder weapons", "ray gun mk2", ::g_weapon, "raygun_mark2_zm");

    if (level.script == "zm_transit")
    {
        self add_option("wonder weapons", "jetgun", ::g_weapon, "jetgun_zm");
        self add_option("wonder weapons", "jetgun (upgraded)", ::g_weapon, "jetgun_upgraded_zm");
    }
    if (level.script == "zm_buried")
        self add_option("wonder weapons", "paralyzer", ::g_weapon, "slowgun_zm");
    if (level.script == "zm_highrise")
        self add_option("wonder weapons", "sliquifier", ::g_weapon, "slipgun_zm");
    if (level.script == "zm_prison")
    {
        self add_option("wonder weapons", "blundergat", ::g_weapon, "blundergat_zm");
        self add_option("wonder weapons", "acidgat", ::g_weapon, "blundersplat_zm");
    }
    
    // weapons:melee
    self add_menu("melee", "weap", "Verified");
    self add_option("melee", "combat knife", ::g_melee, "knife_zm");
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("melee", "galva knuckles", ::g_melee, "tazer_knuckles_zm");
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("melee", "bowie knife", ::g_melee, "bowie_knife_zm");
    if (level.script == "zm_tomb")
    {
        self add_option("melee", "one inch punch", ::g_melee, "one_inch_punch_zm");
        self add_option("melee", "one inch punch (upgraded)", ::g_melee, "one_inch_punch_upgraded_zm");
        self add_option("melee", "one inch punch (fire)", ::g_melee, "one_inch_punch_fire_zm");
        self add_option("melee", "one inch punch (wind)", ::g_melee, "one_inch_punch_air_zm");
        self add_option("melee", "one inch punch (ice)", ::g_melee, "one_inch_punch_ice_zm");
        self add_option("melee", "one inch punch (lightning)", ::g_melee, "one_inch_punch_lightning_zm");
        
    }
    if (level.script == "zm_prison")
    {
        self add_option("melee", "spoon", ::g_melee, "spork_zm_alcatraz");
        self add_option("melee", "spork", ::g_melee, "spork_zm_alcatraz");
    }

    // equipment
    self add_menu("equip", self.menuname, "Verified");
    self add_option("equip", "give frag", ::_g_weapon, "frag_grenade_zm");
    if (is_valid_equipment("sticky_grenade_zm"))
    {
        self add_option("equip", "give semtex", ::_g_weapon, "sticky_grenade_zm");
        self add_option("equip", "toggle auto semtex", ::toggleSemtex);
    }
    if (is_valid_equipment("bouncing_tomahawk_zm"))
        self add_option("equip", "hell's retriever", ::g_weapon, "bouncing_tomahawk_zm");
    if (is_valid_equipment("upgraded_tomahawk_zm"))
        self add_option("equip", "hell's redeemer", ::g_weapon, "upgraded_tomahawk_zm");
    if (is_valid_equipment("emp_grenade_zm"))
        self add_option("equip", "give emp", ::g_weapon, "emp_grenade_zm");
    if (is_valid_equipment("willy_pete_zm"))
        self add_option("equip", "give smokes", ::g_weapon, "willy_pete_zm");
    if (is_valid_equipment("cymbal_monkey_zm"))
        self add_option("equip", "give monkey", ::g_weapon, "cymbal_monkey_zm");
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

    self add_menu("pickup2", "pickup", "Verified");
    self add_option("pickup2", "pickup radius 5000", ::expickup, 5000);
    self add_option("pickup2", "pickup radius 6000", ::expickup, 6000);
    self add_option("pickup2", "pickup radius 7000", ::expickup, 7000);
    self add_option("pickup2", "pickup radius 8000", ::expickup, 8000);
    self add_option("pickup2", "pickup radius 9000", ::expickup, 9000);
    self add_option("pickup2", "pickup radius 10000", ::expickup, 10000);
    
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

    self add_menu("nade2", "nade", "Verified");
    self add_option("nade2", "nade radius 5000", ::grenaderadius, 5000);
    self add_option("nade2", "nade radius 6000", ::grenaderadius, 6000);
    self add_option("nade2", "nade radius 7000", ::grenaderadius, 7000);
    self add_option("nade2", "nade radius 8000", ::grenaderadius, 8000);
    self add_option("nade2", "nade radius 9000", ::grenaderadius, 9000);
    self add_option("nade2", "nade radius 10000", ::grenaderadius, 10000);

    // perks
    self add_menu("perk", self.menuname, "Verified");
    self add_option("perk", "fast hands (weapon switch)", ::fasthands);
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
    // if (is_true(level.zombiemode_using_chugabud_perk))
    if (level.script == "zm_highrise")
        self add_option("perk", "whos who", ::doperks, "specialty_finalstand",1);
    if (is_true(level.zombiemode_using_revive_perk))
        self add_option("perk", "quick revive", ::doperks, "specialty_quickrevive",1);
    // if (is_true(level.zombiemode_using_electric_cherry_perk))
    if (level.script == "zm_prison" || level.script == "zm_tomb")
        self add_option("perk", "electric cherry", ::doperks, "specialty_grenadepulldeath",1);
    if (is_true(level.zombiemode_using_marathon_perk))
        self add_option("perk", "staminup", ::doperks, "specialty_longersprint",1);
    // if (is_true(level.zombiemode_using_vulture_perk))
    if (level.script == "zm_buried")
        self add_option("perk", "vulture aid", ::doperks, "specialty_nomotionsensor",1);
	if ( level.zombiemode_using_divetonuke_perk )
        self add_option("perk", "phd flopper", ::doperks, "specialty_flakjacket",1);

    // zombies
    self add_menu("zombies", self.menuname, "Verified");
    self add_option("zombies", "spawn zombie", ::spawn_zombie);
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

    self add_menu("lobby", self.menuname, "Verified");
    self add_option("lobby", "end game", ::custom_end_game_f);
    self add_option("lobby", "instant end game", ::instantend);
    self add_option("lobby", "zombie counter", ::togglezmcounter);
    self add_option("lobby", "timescale 0.25", ::timescale, 0.25);
    self add_option("lobby", "timescale 0.5", ::timescale, 0.50);
    self add_option("lobby", "timescale 0.75", ::timescale, 0.75);
    self add_option("lobby", "timescale 1", ::timescale, 1);
    self add_option("lobby", "timescale 2", ::timescale, 2);

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
        self add_option("pOpt " + i, "kick", ::kickplayer, player);
        self add_option("pOpt " + i, "kill", ::killplayer, player);
        self add_option("pOpt " + i, "god", ::godmode, player);
        self add_option("pOpt " + i, "switch player team", ::switchteams, player);
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
