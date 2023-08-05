#include common_scripts\utility;

main()
{
    replacefunc(maps\mp\zombies\_zm_utility::has_player_equipment, ::has_player_equipment_hook);

    // trample steam
    replacefunc(maps\mp\zombies\_zm_equip_springpad::pickupspringpad, ::pickupspringpad_hook);
    replacefunc(maps\mp\zombies\_zm_equip_springpad::watchspringpaduse, ::watchspringpaduse_hook);

    replacefunc(maps\mp\zm_buried::collapsing_catwalk_init, ::__collapsing_catwalk_init);
    replacefunc(maps\mp\zm_buried_classic::hide_wallbuy, ::__hide_wallbuy);
}

init()
{
    if(level.script != "zm_buried")
		return;
		
    if ( isDefined( level.jail_open_door ) )
    {
	    players = get_players();
        level.cell_open = true;
        [[ level.jail_open_door ]]( players[0].got_booze );

        maps\mp\zm_buried_gamemodes::deleteslothbarricades(0);
        level notify( "jail_barricade_down" );

    	flag_set( "courtyard_fountain_broken" );
	    flag_set( "fountain_transport_active" );
        maps\mp\zm_buried_fountain::destroy_maze_fountain();
    }
}

__collapsing_catwalk_init()
{
    return;
}
__hide_wallbuy()
{
    return;
}

has_player_equipment_hook(weaponname)
{
    return 0; // allow unlimited player equipment
}

watchspringpaduse_hook()
{
	self notify("watchSpringPadUse");
	self endon("watchSpringPadUse");
	self endon("death");
	self endon("disconnect");
	for(;;)
	{
		self waittill("equipment_placed", weapon, weapname);
		if (weapname == level.springpad_name)
		{
            if (is_true(self.springpad_picked_up))
            {
                self.springpad_picked_up = false;
                self maps\mp\zombies\_zm_equip_springpad::cleanupoldspringpad();
            }
			self.buildablespringpad = weapon;
			self thread maps\mp\zombies\_zm_equip_springpad::startspringpaddeploy(weapon);
		}
	}
}

pickupspringpad_hook(item)
{
    self.springpad_kills = item.springpad_kills;
    item.springpad_kills =  undefined;
    self.springpad_picked_up = true;
}
