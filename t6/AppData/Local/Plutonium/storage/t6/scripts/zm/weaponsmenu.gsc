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

draw_weapons_menu()
{
    // weapons:main
    self add_option(self.menuname, "weapons menu", ::submenu, "weap", "weapons menu");
    self add_menu("weap", self.menuname, "Verified");

    self draw_giveweapons_menu();
    self draw_dropweapons_menu();

    // self _blank("weap",true);

    self add_option("weap", "ammo menu", ::submenu, "ammo", "ammo menu");
    self add_menu("ammo", "weap", "Verified");
    self add_option("ammo", "empty stock", ::emptyClip);
    self add_option("ammo", "max ammo", ::maxammo);
    if(verification_to_num(self.status) > verification_to_num("co"))
    {
        self add_option("ammo", "infinite ammo [lobby]", ::infiniteAmmo); 
        self add_option("ammo", "rapid fire [lobby]", ::RapidFire); 
    }
    self add_option("ammo", "auto grenade refill", ::toggleGrenadeRefill); 
    self add_option("ammo", "auto ammo refill", ::toggleAmmoRefill); 

    // self _blank("weap",true);

    self add_option("weap", "drop current weapon", ::dropweapon);
    self add_option("weap", "drop random weapon", ::dropCanswap);
    self add_option("weap", "upgrade/downgrade weapon (pap)", ::UpgradeDowngradeWeapon);

    self _blank("weap",true);

    self add_option("weap", "toggle limited damage at last", ::toggle_limit_weapons); 
    self add_option("weap", "toggle land protection at last", ::toggle_land_protection); 
    self add_option("weap", "toggle barrelstuff protection at last", ::toggle_barrel_protection); 
}

draw_giveweapons_menu()
{
    // weapons:give weapons
    self add_option("weap", "^3give weapons menu^7", ::submenu, "giveweapons", "give weapons menu");
    self add_menu("giveweapons", "weap", "Verified");
    
    self add_option("giveweapons", "ar", ::submenu, "weapar", "ar");
    self add_option("giveweapons", "ar grenade launcher", ::submenu, "weapar_gl", "ar grenade launcher");
    self add_option("giveweapons", "smg", ::submenu, "weapsmg", "smg");
    self add_option("giveweapons", "lmg", ::submenu, "weaplmg", "lmg");
    self add_option("giveweapons", "shotguns", ::submenu, "weapsg", "shotguns");
    self add_option("giveweapons", "pistols", ::submenu, "weappistol", "pistols");
    self add_option("giveweapons", "snipers", ::submenu, "weapsnip", "snipers");
    self add_option("giveweapons", "wonder weapons", ::submenu, "wonder weapons", "wonder weapons");
    self add_option("giveweapons", "specials & launchers", ::submenu, "specials & launchers", "specials & launchers");
    self add_option("giveweapons", "melee", ::submenu, "melee", "melee");
    self add_option("giveweapons", "misc", ::submenu, "misc", "misc");
    if (level.script == "zm_transit")
        self add_option("giveweapons", "toggle riot shield", ::g_shield, "riotshield_zm");
    if (level.script == "zm_prison")
        self add_option("giveweapons", "toggle riot shield", ::g_shield, "alcatraz_shield_zm");
    if (level.script == "zm_tomb")
    {
        self add_option("giveweapons", "toggle riot shield", ::g_shield, "tomb_shield_zm");
        self add_option("giveweapons", "origins staffs", ::submenu, "weapstaff", "staffs");
    }

    // weapons:ar:gl
    self add_menu("weapar_gl", "giveweapons", "Verified");
    self add_option("weapar_gl", "*THESE ARE GLITCHED*");

    // weapons:staff
    if (level.script == "zm_tomb")
    {
        self add_menu("weapstaff", "giveweapons", "Verified");
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
    self add_menu("weapar", "giveweapons", "Verified");
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
    self add_menu("weapsmg", "giveweapons", "Verified");
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
    self add_menu("weaplmg", "giveweapons", "Verified");
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
    self add_menu("weapsg", "giveweapons", "Verified");
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
    self add_menu("weappistol", "giveweapons", "Verified");
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
    self add_menu("weapsnip", "giveweapons", "Verified");
    self add_option("weapsnip", "dsr", ::g_weapon, "dsr50_zm");
    self add_option("weapsnip", "barrett", ::g_weapon, "barretm82_zm");
    if (level.script == "zm_buried" || level.script == "zm_highrise")
        self add_option("weapsnip", "svu", ::g_weapon, "svu_zm");
    if (level.script == "zm_tomb")
        self add_option("weapsnip", "ballista", ::g_weapon, "ballista_zm");

    // weapons:specials & launchers
    self add_menu("specials & launchers", "giveweapons", "Verified");
    if (level.script != "zm_prison")
    {
        self add_option("specials & launchers", "war machine", ::g_weapon, "m32_zm");
        // if (level.script != "zm_tomb")
        if (level.script != "zm_tomb" && level.script != "zm_prison")
        {
            self add_option("specials & launchers", "ballistic knife 1", ::g_weapon, "knife_ballistic_no_melee_zm");
            self add_option("specials & launchers", "ballistic knife 2", ::g_weapon, "knife_ballistic_bowie_zm");
            self add_option("specials & launchers", "ballistic knife 3", ::g_weapon, "knife_ballistic_zm");
        }
    }
    if (level.script != "zm_transit" && level.script != "zm_tomb")
        self add_option("specials & launchers", "rpg", ::g_weapon, "usrpg_zm");

    // weapons:wonder weapons
    self add_menu("wonder weapons", "giveweapons", "Verified");
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
    self add_menu("melee", "giveweapons", "Verified");
	if ( level.gametype == "zcleansed" )
    {
        self add_option("melee", "zombie hands", ::g_melee, "zombiemelee_zm");
        self add_option("melee", "zombie hands (glitched)", ::g_melee, "zombiemelee_dw");
    }
    self add_option("melee", "combat knife", ::g_melee, "knife_zm");
    // self add_option("melee", "zombie_fists_zm", ::g_melee, "zombie_fists_zm");
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("melee", "galva knuckles", ::g_melee, "tazer_knuckles_zm");
    if (level.script != "zm_tomb" && level.script != "zm_prison")
        self add_option("melee", "bowie knife", ::g_melee, "bowie_knife_zm");
    if (level.script == "zm_transit" && level.gametype != "zstandard")
        self add_option("melee", "screecher arms", ::g_melee, "screecher_arms_zm");
    if (level.script == "zm_tomb")
    {
        self _blank("melee");
        self add_option("melee", "one inch punch", ::g_melee, "one_inch_punch_zm");
        self add_option("melee", "one inch punch (upgraded)", ::g_melee, "one_inch_punch_upgraded_zm");
        self add_option("melee", "one inch punch (fire)", ::g_melee, "one_inch_punch_fire_zm");
        self add_option("melee", "one inch punch (wind)", ::g_melee, "one_inch_punch_air_zm");
        self add_option("melee", "one inch punch (ice)", ::g_melee, "one_inch_punch_ice_zm");
        self add_option("melee", "one inch punch (lightning)", ::g_melee, "one_inch_punch_lightning_zm");
        self _blank("melee");
        self add_option("melee", "staff melee (fire)", ::g_melee, "staff_fire_melee_zm");
        self add_option("melee", "staff melee (ice)", ::g_melee, "staff_water_melee_zm");
        self add_option("melee", "staff melee (wind)", ::g_melee, "staff_air_melee_zm");
        self add_option("melee", "staff melee (lightning)", ::g_melee, "staff_lightning_melee_zm");
    }
    if (level.script == "zm_prison")
    {
        self add_option("melee", "spoon", ::g_melee, "spork_zm_alcatraz");
        self add_option("melee", "spork", ::g_melee, "spork_zm_alcatraz");
    }

    // weapons:misc
    self add_menu("misc", "giveweapons", "Verified");
    // self add_option("misc", "no hands", ::g_weapon, "no_hands_zm"); // didn't work
    self add_option("misc", "death animation weapon", ::g_weapon, "death_throe_zm");
    self add_option("misc", "knuckle crack", ::g_weapon, "zombie_knuckle_crack");
    if ( level.gametype == "zcleansed" )
    {
        self add_option("melee", "zombie hands", ::g_weapon, "zombiemelee_zm");
        self add_option("melee", "zombie hands (glitched)", ::g_weapon, "zombiemelee_dw");
    }
    if (level.script == "zm_buried")
        self add_option("misc", "chalk draw", ::g_weapon, "chalk_draw_zm");
    if (level.script == "zm_prison")
        self add_option("misc", "afterlife hands", ::g_weapon, "lightning_hands_zm");
    if (level.script == "zm_transit" && level.gametype != "zstandard")
        self add_option("misc", "screecher arms", ::g_weapon, "screecher_arms_zm");
}

draw_dropweapons_menu()
{
    // weapons:give weapons
    self add_option("weap", "^3drop weapons menu^7", ::submenu, "dropweapons", "drop weapons menu");
    self add_menu("dropweapons", "weap", "Verified");

    self add_option("dropweapons", "ar", ::submenu, "drop_weapar", "ar");
    self add_option("dropweapons", "smg", ::submenu, "drop_weapsmg", "smg");
    self add_option("dropweapons", "lmg", ::submenu, "weaplmg", "lmg");
    self add_option("dropweapons", "shotguns", ::submenu, "drop_weapsg", "shotguns");
    self add_option("dropweapons", "pistols", ::submenu, "drop_weappistol", "pistols");
    self add_option("dropweapons", "snipers", ::submenu, "drop_weapsnip", "snipers");
    self add_option("dropweapons", "wonder weapons", ::submenu, "drop_wonderweapons", "drop wonder weapons");
    self add_option("dropweapons", "specials & launchers", ::submenu, "drop_specialslaunchers", "drop specials & launchers");
    if (level.script == "zm_tomb")
    {
        self add_option("dropweapons", "origins staffs", ::submenu, "drop_weapstaff", "staffs");
    }

    // weapons:staff
    if (level.script == "zm_tomb")
    {
        self add_menu("drop_weapstaff", "dropweapons", "Verified");
        self add_option("drop_weapstaff", "air staff", ::drop_weapon, "staff_air_zm");
        self add_option("drop_weapstaff", "fire staff", ::drop_weapon, "staff_fire_zm");
        self add_option("drop_weapstaff", "ice staff", ::drop_weapon, "staff_water_zm");
        self add_option("drop_weapstaff", "lightning staff", ::drop_weapon, "staff_lightning_zm");
        self add_option("drop_weapstaff", "upgraded air staff", ::drop_staff, "staff_air_upgraded_zm", "upgraded air staff");
        self add_option("drop_weapstaff", "upgraded fire staff", ::drop_staff, "staff_fire_upgraded_zm", "upgraded fire staff");
        self add_option("drop_weapstaff", "upgraded ice staff", ::drop_staff, "staff_lightning_upgraded_zm", "upgraded ice staff");
        self add_option("drop_weapstaff", "upgraded lightning staff", ::drop_staff, "staff_water_upgraded_zm", "upgraded lightning staff");
    }

    // weapons:ar
    self add_menu("drop_weapar", "dropweapons", "Verified");
    self add_option("drop_weapar", "fal", ::drop_weapon, "fnfal_zm");
    self add_option("drop_weapar", "m14", ::drop_weapon, "m14_zm");
    self add_option("drop_weapar", "galil", ::drop_weapon, "galil_zm");
    if (level.script == "zm_transit" || level.script == "zm_nuked")
    {
        if (level.script == "zm_nuked")
            self add_option("drop_weapar", "m27", ::drop_weapon, "hk416_zm");
        self add_option("drop_weapar", "m16", ::drop_weapon, "m16_zm");
    }
    if (level.script != "zm_buried" && level.script != "zm_prison" && level.script != "zm_tomb")
    {
        self add_option("drop_weapar", "m8a1", ::drop_weapon, "xm8_zm");
    }
    if (level.script != "zm_tomb")
    {
        if (level.script != "zm_prison")
        {
            self add_option("drop_weapar", "smr", ::drop_weapon, "saritch_zm");
        }
        self add_option("drop_weapar", "mtar", ::drop_weapon, "tar21_zm");
    }
    if (level.script != "zm_prison")
    {
        if (level.script != "zm_buried")
        {
            self add_option("drop_weapar", "type 25", ::drop_weapon, "type95_zm");
        }
    }
    if (level.script == "zm_highrise" || level.script == "zm_buried")
    {
        self add_option("drop_weapar", "an94", ::drop_weapon, "an94_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("drop_weapar", "stg 44", ::drop_weapon, "mp44_zm");
        self add_option("drop_weapar", "scar-h", ::drop_weapon, "scar_zm");
    }
    if (level.script == "zm_prison")
    {
        self add_option("drop_weapar", "ak47", ::drop_weapon, "ak47_zm");
    }

    // weapons:smg
    self add_menu("drop_weapsmg", "dropweapons", "Verified");
    if (level.script != "zm_tomb" && level.script != "zm_buried")
        self add_option("drop_weapsmg", "mp5", ::drop_weapon, "mp5k_zm");
    if (level.script != "zm_prison")
    {
        if (level.script != "zm_buried")
            self add_option("drop_weapsmg", "chicom", ::drop_weapon, "qcw05_zm");
        self add_option("drop_weapsmg", "ak74u", ::drop_weapon, "ak74u_zm");
    }
    if (level.script == "zm_buried" || level.script == "zm_prison" || level.script == "zm_highrise")
    {
        self add_option("drop_weapsmg", "pdw57", ::drop_weapon, "pdw57_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("drop_weapsmg", "mp40", ::drop_weapon, "mp40_zm");
        self add_option("drop_weapsmg", "skorpion", ::drop_weapon, "evoskorpion_zm");
    }
    if (level.script == "zm_prison")
    {
        self add_option("drop_weapsmg", "uzi", ::drop_weapon, "uzi_zm");
        self add_option("drop_weapsmg", "m1927", ::drop_weapon, "thompson_zm");
    }

    // weapons:lmg
    self add_menu("weaplmg", "dropweapons", "Verified");
    if (level.script == "zm_transit" || level.script == "zm_nuked" || level.script == "zm_highrise")
        self add_option("weaplmg", "rpd", ::drop_weapon, "rpd_zm");
    if (level.script == "zm_buried" || level.script == "zm_prison" || level.script == "zm_nuked")
    {
        self add_option("weaplmg", "lsat", ::drop_weapon, "lsat_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("weaplmg", "mg08", ::drop_weapon, "mg08_zm");
    }
    if (level.script != "zm_prison")
        self add_option("weaplmg", "hamr", ::drop_weapon, "hamr_zm");
    if (level.script == "zm_prison")
        self add_option("weaplmg", "death machine", ::drop_weapon, "minigun_alcatraz_zm");

    // weapons:shotguns
    self add_menu("drop_weapsg", "dropweapons", "Verified");
    self add_option("drop_weapsg", "remington", ::drop_weapon, "870mcs_zm");
    if (level.script != "zm_prison")
    {
        self add_option("drop_weapsg", "m1216", ::drop_weapon, "srm1216_zm");
    }
    if (level.script != "zm_tomb")
    {
        self add_option("drop_weapsg", "s12", ::drop_weapon, "saiga12_zm");
        self add_option("drop_weapsg", "olympia", ::drop_weapon, "rottweil72_zm");
    }
    if (level.script == "zm_tomb")
    {
        self add_option("drop_weapsg", "ksg", ::drop_weapon, "ksg_zm");
    }

    // weapons:pistols
    self add_menu("drop_weappistol", "dropweapons", "Verified");
    self add_option("drop_weappistol", "five seven", ::drop_weapon, "fiveseven_zm");
    self add_option("drop_weappistol", "dw five seven", ::drop_weapon, "fivesevendw_zm");
    self add_option("drop_weappistol", "b23r", ::drop_weapon, "beretta93r_zm");
    if (level.script != "zm_tomb")
    {
        self add_option("drop_weappistol", "m1911", ::drop_weapon, "m1911_zm");
        self add_option("drop_weappistol", "executioner", ::drop_weapon, "judge_zm");
    }
    if (level.script != "zm_buried" && level.script != "zm_prison")
        self add_option("drop_weappistol", "python", ::drop_weapon, "python_zm");
    if (level.script != "zm_prison")
        self add_option("drop_weappistol", "kap40", ::drop_weapon, "kard_zm");
    if (level.script == "zm_buried")
        self add_option("drop_weappistol", "rnma", ::drop_weapon, "rnma_zm");
    if (level.script == "zm_tomb")
    {
        self add_option("drop_weappistol", "mauser", ::drop_weapon, "c96_zm");
    }

    // weapons:snipers
    self add_menu("drop_weapsnip", "dropweapons", "Verified");
    self add_option("drop_weapsnip", "dsr", ::drop_weapon, "dsr50_zm");
    self add_option("drop_weapsnip", "barrett", ::drop_weapon, "barretm82_zm");
    if (level.script == "zm_buried" || level.script == "zm_highrise")
        self add_option("drop_weapsnip", "svu", ::drop_weapon, "svu_zm");
    if (level.script == "zm_tomb")
        self add_option("drop_weapsnip", "ballista", ::drop_weapon, "ballista_zm");

    // weapons:drop_specialslaunchers
    self add_menu("drop_specialslaunchers", "dropweapons", "Verified");
    if (level.script != "zm_prison")
    {
        self add_option("drop_specialslaunchers", "war machine", ::drop_weapon, "m32_zm");
        if (level.script != "zm_tomb")
        {
            self add_option("drop_specialslaunchers", "ballistic knife 1", ::drop_weapon, "knife_ballistic_no_melee_zm");
            self add_option("drop_specialslaunchers", "ballistic knife 2", ::drop_weapon, "knife_ballistic_bowie_zm");
            self add_option("drop_specialslaunchers", "ballistic knife 3", ::drop_weapon, "knife_ballistic_zm");
        }
    }
    if (level.script != "zm_transit" && level.script != "zm_tomb")
        self add_option("drop_specialslaunchers", "rpg", ::drop_weapon, "usrpg_zm");

    // weapons:drop_wonderweapons
    self add_menu("drop_wonderweapons", "dropweapons", "Verified");
    self add_option("drop_wonderweapons", "ray gun", ::drop_weapon, "ray_gun_zm");
    self add_option("drop_wonderweapons", "ray gun mk2", ::drop_weapon, "raygun_mark2_zm");

    if (level.script == "zm_transit")
    {
        self add_option("drop_wonderweapons", "jetgun", ::drop_weapon, "jetgun_zm");
        self add_option("drop_wonderweapons", "jetgun (upgraded)", ::drop_weapon, "jetgun_upgraded_zm");
    }
    if (level.script == "zm_buried")
        self add_option("drop_wonderweapons", "paralyzer", ::drop_weapon, "slowgun_zm");
    if (level.script == "zm_highrise")
        self add_option("drop_wonderweapons", "sliquifier", ::drop_weapon, "slipgun_zm");
    if (level.script == "zm_prison")
    {
        self add_option("drop_wonderweapons", "blundergat", ::drop_weapon, "blundergat_zm");
        self add_option("drop_wonderweapons", "acidgat", ::drop_weapon, "blundersplat_zm");
    }
}