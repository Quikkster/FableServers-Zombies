#include maps\mp\zombies\_zm_zonemgr;
#include maps\mp\zombies\_zm_net;
#include maps\mp\zombies\_zm_utility;
#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	if(level.script == "zm_prison")
	{
		replacefunc(maps\mp\zm_prison_sq_wth::track_player_eyes, ::__track_player_eyes);
	}
}


init()
{
	if(level.script != "zm_prison")
		return;

    level thread onPlayerConnect();
}

onPlayerConnect()
{
    for(;;)
    {
        level waittill("connected", player);
        player thread jumpscarelul();
    }
}

jumpscarelul()
{
	self endon("disconnect");
    for(;;)
    {
		self waittill( "get_jump_scared_dumbass" );
		self do_player_general_vox( "general", "scare_react", undefined, 100 );
		self playsoundtoplayer( "zmb_easteregg_face", self );
		self.wth_elem = newclienthudelem( self );
		self.wth_elem.horzalign = "fullscreen";
		self.wth_elem.vertalign = "fullscreen";
		self.wth_elem.sort = 1000;
		self.wth_elem.foreground = 0;
		self.wth_elem setshader( "zm_al_wth_zombie", 640, 480 );
		self.wth_elem.hidewheninmenu = 1;
		wait 1.70;
		self.wth_elem destroy();
	}
}

__track_player_eyes()
{
	self endon( "disconnect" );
	b_saw_the_wth = 0;
	while ( !b_saw_the_wth )
	{
		n_time = 0;
		while ( self adsbuttonpressed() && n_time < 25 )
		{
			n_time++;
			wait 0.05;
		}
		if ( n_time >= 25 && self adsbuttonpressed() && self maps\mp\zombies\_zm_zonemgr::is_player_in_zone( "zone_roof" ) && maps\mp\zm_prison_sq_wth::sq_is_weapon_sniper( self getcurrentweapon() ) && is_player_looking_at( level.wth_lookat_point.origin, 0.9, 0, undefined ) )
		{
			self do_player_general_vox( "general", "scare_react", undefined, 100 );
			self playsoundtoplayer( "zmb_easteregg_face", self );
			self.wth_elem = newclienthudelem( self );
			self.wth_elem.horzalign = "fullscreen";
			self.wth_elem.vertalign = "fullscreen";
			self.wth_elem.sort = 1000;
			self.wth_elem.foreground = 0;
			self.wth_elem setshader( "zm_al_wth_zombie", 640, 480 );
			self.wth_elem.hidewheninmenu = 1;
			j_time = 0;
			while ( self adsbuttonpressed() && j_time < 5 )
			{
				j_time++;
				wait 0.05;
			}
			self.wth_elem destroy();
			b_saw_the_wth = 1;
			// reset jumpscare for multiple uses
			wait 5;
			b_saw_the_wth = 0;
		}
		wait 0.05;
	}
}
