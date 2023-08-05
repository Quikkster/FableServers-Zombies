#include common_scripts\utility;

main()
{
	if(level.script == "zm_highrise")
	{
		replacefunc(maps\mp\zombies\_zm_utility::has_player_equipment, ::has_player_equipment_hook);

		// trample steam
		replacefunc(maps\mp\zombies\_zm_equip_springpad::pickupspringpad, ::pickupspringpad_hook);
		replacefunc(maps\mp\zombies\_zm_equip_springpad::watchspringpaduse, ::watchspringpaduse_hook);
	}
}

init()
{
	if(level.script != "zm_highrise")
		return;

    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread onPlayerSpawned();
    }
}

onPlayerSpawned()
{
    self endon("disconnect");
	level endon("end_game");
    for(;;)
    {
        self waittill( "spawned_player" );
        self thread elevator_key();
    }
}

elevator_key()
{
	level endon("end_game");
	self endon("disconnect");
	for(;;)
	{
		if (isDefined(self maps\mp\zombies\_zm_buildables::player_get_buildable_piece()) && self maps\mp\zombies\_zm_buildables::player_get_buildable_piece() == "keys_zm")
		{
			wait 1;
		}
		else
		{
			candidate_list = [];
			foreach (zone in level.zones)
			{
				if (isDefined(zone.unitrigger_stubs))
				{
					candidate_list = arraycombine(candidate_list, zone.unitrigger_stubs, 1, 0);
				}
			}
			foreach (stub in candidate_list)
			{
				if (isDefined(stub.piece) && stub.piece.buildablename == "keys_zm")
				{
					self thread maps\mp\zombies\_zm_buildables::player_take_piece(stub.piece);
					break;
				}
			}
		}
		wait 1;
	}
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
