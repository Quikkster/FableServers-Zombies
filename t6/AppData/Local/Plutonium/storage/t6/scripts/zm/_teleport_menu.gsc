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

draw_teleport_menu()
{
    self add_option(self.menuname, "teleport", ::submenu, "teleport", "teleport");
    self add_menu("teleport", self.menuname, "Verified");

    if (level.script == "zm_transit")
    {
        if (level.gametype != "zm_standard")
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
        self add_option("teleport", "prison roof", ::teleportPlayer, ( -1003.98, 8594.36, 1704.13 ));
        // self add_option("teleport", "prison roof (old)", ::teleportPlayer, ( 952, 9414, 1704));
        self add_option("teleport", "spiral staircase", ::teleportPlayer, ( -21, 7879, -127));
        self add_option("teleport", "spiral stair center", ::teleportPlayer, ( 414,8436,832));
        self add_option("teleport", "harbor", ::teleportPlayer, ( -425, 5418, -71));
        self add_option("teleport", "harbor bars", ::teleportPlayer, ( -678,6983,240));
        self add_option("teleport", "gaurd tower", ::teleportPlayer, ( -39, 5572, 593));
        self add_option("teleport", "dog 1", ::teleportPlayer, ( 826.87, 9672.88, 1443.13));
        self add_option("teleport", "dog 2", ::teleportPlayer, ( 3731.16, 9705.97, 1532.84));
        self add_option("teleport", "dog 3", ::teleportPlayer, ( 49.1354, 6093.95, 19.5609));
        self add_option("teleport", "pack a punch (bridge)", ::teleportPlayer, (-1146.29, -3393.42, -8447.88));
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
        self add_option("teleport", "biplane ride", ::spawn_biplane_ride, self);
        self _blank("teleport",true);

        if(isDefined(level.random_perk_start_machine))
            self add_option("teleport", "wunderfizz machine", ::___tp, level.random_perk_start_machine.origin );

        self add_option("teleport", "tank 1st spot", ::teleportPlayer, (160.635, -2755.65, 43.5474));
        self add_option("teleport", "tank 2nd spot", ::teleportPlayer, (-86.3847, 4654.54, -288.052));
        self add_option("teleport", "no mans land", ::teleportPlayer, (-760.179, 1121.94, 119.175));
        self add_option("teleport", "inside church", ::teleportPlayer, (459.258, -2644.85, 365.342));
        self add_option("teleport", "pack-a-punch", ::teleportPlayer, (-199.079, -11.0947, 320.125));
        // self add_option("teleport", "spawn panzer", ::spawnpanzer);
    
        self _blank("teleport",true);

        //generators
        self add_option("teleport", "generators menu", ::submenu, "generators", "generators menu");
        self add_menu("generators", "teleport", "Verified"); 
        self add_option("generators", "generator 1", ::teleportPlayer, (-86.3847, 4654.54, -288.052));
        self add_option("generators", "generator 2", ::teleportPlayer, (2170.5, 4660.37, -299.875));
        self add_option("generators", "generator 3", ::teleportPlayer, (-356.707, 3579.11, -291.875));
        self add_option("generators", "generator 4", ::teleportPlayer, (518.721, 2500.87, -121.875));
        self add_option("generators", "generator 5", ::teleportPlayer, (-2493.36, 178.245, 236.625));
        self add_option("generators", "generator 6", ::teleportPlayer, (952.098, -3554.39, 306.125));
        self add_menu_alt("generators", "teleport");
        //crazy places
        self add_option("teleport", "crazy places menu", ::submenu, "crazy place", "crazy place menu");
        self add_menu("crazy place", "teleport", "Verified");
        self add_option("crazy place", "ice staff", ::teleportPlayer, (11242.1, -7033.06, -345.875));
        self add_option("crazy place", "fire staff", ::teleportPlayer, (9429.59, -8560.03, -397.875));
        self add_option("crazy place", "wind staff", ::teleportPlayer, (11285.9, -8679.08, -407.875));
        self add_option("crazy place", "lightning staff", ::teleportPlayer, (9621.84, -6989.4, -345.875));
        self add_menu_alt("crazy place", "teleport");
        //perks
        self add_option("teleport", "perk machines menu", ::submenu, "perks", "perk machines menu");
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
}