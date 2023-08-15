#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;
#include common_scripts\utility;

/*================== Backflips ==================*/

/*
backflip()
{
    if(self.backflip==0)
    {
        self.backflip=1;
        self iPrintLn("Backflip ^2Enabled");
        self iPrintLn("Press [{+actionslot 2}] To Do A Backflip");
        self thread rotatePitch();
    } 
    else 
    {
        self.backflip=0;
        self notify("stop_backflip");
        self iPrintLn("Backflip ^1Disabled");
    }
}
*/

//Toggle All Flips
backflip()
{
    if( !(IsDefined( self.toggleBackflip )) )
    {
        self.toggleBackflip = 1;
        self iPrintln("Backflip Bind ^2Enabled");
        self iPrintln("[{+actionslot 2}] ^2to use!");
        self dobackflip();
    }
    else
    {
        if(!self.doingflip)
        {
            self.toggleBackflip = undefined;
            self iPrintln("Backflip Bind ^1Disabled");
            self notify("stopbackflip");
        }
    }
}
dobackflip()
{
    self endon( "end_Flip" );
    self endon( "game_ended" );
    self endon( "disconnect" );
    self endon("stopbackflip");
    for(;;)
    {
        if( self actionslottwobuttonpressed() && !self.menu.is_open && !self.doingflip )
        {
            self.doingflip = true;
            playeror = self getorigin();
            playeran = self getplayerangles();
            flip_crate = spawn( "script_model", playeror );
            flip_crate setmodel( "tag_origin" );
            flip_crate.angles = playeran;
            flip_crate.origin = playeror;
            self linkto( flip_crate );
            flip_crate rotatepitch( 2 * -200, 1.5 );
            wait 1.3;
            self unlink();
            flip_crate delete();
            self.doingflip = false;
        }
        wait 0.05;
    }
}
ToggleFrontflip()
{
    if( !(IsDefined( self.toggleFrontflip )) )
    {
        self.toggleFrontflip = 1;
        self iPrintln("Frontflip Bind ^2Enabled");
        self iPrintln("[{+actionslot 1}] ^2to use!");
        self dofrontflip();
    }
    else
    {
        if(!self.doingflip)
        {
            self.toggleFrontflip = undefined;
            self iPrintln("Front Flip Bind ^1Disabled");
            self notify("stopfrontflip");
        }
    }
}
dofrontflip()
{
	self endon( "end_Flip" );
	self endon( "game_ended" );
	self endon( "disconnect" );
	self endon("stopfrontflip");
	for(;;)
	{
        if( self actionslotonebuttonpressed() && !self.menu.is_open && !self.doingflip )
        {
            self.doingflip = true;
            playeror = self getorigin();
            playeran = self getplayerangles();
            flip_crate = spawn( "script_model", playeror );
            flip_crate setmodel( "tag_origin" );
            flip_crate.angles = playeran;
            flip_crate.origin = playeror;
            self linkto( flip_crate );
            flip_crate rotatepitch( 2 * 200, 1.5 );
            wait 1.3;
            self unlink();
            flip_crate delete();
            self.doingflip = false;
        }
        wait 0.05;
	}
}
ToggleLeftFlip()
{
    if( !(IsDefined( self.toggleLeftFlip )) )
    {
        self.toggleLeftFlip = 1;
        self iPrintln("Leftflip Bind ^2Enabled");
        self iPrintln("[{+actionslot 3}] ^2to use!");
        self doleftflip();
    }
    else
    {
        if(!self.doingflip)
        {
            self.toggleLeftFlip = undefined;
            self iPrintln("Leftflip Bind ^1Disabled");
            self notify("stopleftflip");
        }
    }
}

doleftflip()
{
	self endon( "end_Flip" );
	self endon( "game_ended" );
	self endon( "disconnect" );
	self endon("stopleftflip");
	for(;;)
	{
        if( self actionslotthreebuttonpressed() && !self.menu.is_open && !self.doingflip )
        {
            self.doingflip = true;
            playeror = self getorigin();
            playeran = self getplayerangles();
            flip_crate = spawn( "script_model", playeror );
            flip_crate setmodel( "tag_origin" );
            flip_crate.angles = playeran;
            flip_crate.origin = playeror;
            self linkto( flip_crate );
            flip_crate rotateroll( 2 * 200, 1.5 );
            wait 1.3;
            self unlink();
            flip_crate delete();
            self.doingflip = false;
        }
        wait 0.05;
	}
}
ToggleRightflip()
{
    if( !(IsDefined( self.toggleRightflip )) )
    {
        self.toggleRightflip = 1;
        self iPrintln("Rightflip Bind ^2Enabled");
        self iPrintln("[{+actionslot 4}] ^2to use!");
        self dorightflip();
    }
    else
    {
        if(!self.doingflip)
        {
            self.toggleRightflip = undefined;
            self iPrintln("Rightflip Bind ^1Disabled");
            self notify("stoprightflip");
        }
    }
}
dorightflip()
{
	self endon( "end_Flip" );
	self endon( "game_ended" );
	self endon( "disconnect" );
	self endon("stoprightflip");
	for(;;)
	{
        if( self actionslotfourbuttonpressed() && !self.menu.is_open && !self.doingflip )
        {
            self.doingflip = true;
            playeror = self getorigin();
            playeran = self getplayerangles();
            flip_crate = spawn( "script_model", playeror );
            flip_crate setmodel( "tag_origin" );
            flip_crate.angles = playeran;
            flip_crate.origin = playeror;
            self linkto( flip_crate );
            flip_crate rotateroll( 2 * -200, 1.5 );
            wait 1.3;
            self unlink();
            flip_crate delete();
            self.doingflip = false;
        }
        wait 0.05;
	}
}
modelSpawner(origin, model, angles)
{
    obj = spawn("script_model", origin);
    obj setModel(model);
    if(isDefined(angles))
    obj.angles = angles;
    return obj;
}

/*================== Reset Angles ==================*/

doReset()
{
    self setPlayerAngles(self.angles+(0,0,0));
}

/*================== Cowboy ==================*/

doCowboy()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.rcowboy)
    {
        self setClientDvar("cg_gun_z", "0");
        self.rcowboy = false;
    }
    if(self.cowboy == false)
    {
        self.cowboy = true;
        self setClientDvar("cg_gun_z", "10");
        self iprintln("Cowboy ^1enabled");
    }
    else
    {
        self.cowboy = false;
        self setClientDvar("cg_gun_z", "0");
        self iprintln("Cowboy ^1disabled");
    }
}

/*================== Reverse Cowboy ==================*/

doReverseCowboy()
{
    self endon("game_ended");
    self endon( "disconnect" );
    if(self.cowboy)
    {
        self setClientDvar("cg_gun_z", "0");
        self.cowboy = false;
    }
    if(self.rcowboy == false)
    {
        self.rcowboy = true;
        self setClientDvar("cg_gun_z", "-5");
        self iprintln("Reverse Cowboy ^1enabled");
    }
    else
    {
        self.rcowboy = false;
        self setClientDvar("cg_gun_z", "0");
        self iprintln("Reverse Cowboy ^1disabled");
    }
}

/*================== Bounce ==================*/

doBounce(strength)
{
    self setvelocity(self getvelocity() + (0,0,strength));
}

/*================== Shield Bounces ==================*/

// cmdBounces() {
// 	self endon( "disconnect" );
	
// 	for(;;) {
// 		self waittill( "cmd_bounces" );
		
// 		self enablebounces();

// 	}
// }

// enablebounces()
// {
//     if (!self.bouncescmd)
//     {
//         self iprintln("Easier Riot Shield Bounces ^2ON");
//         self thread riotshieldPlacement();
//         self.bouncescmd = true;
//     }
//     else if (self.bouncescmd)
//     {
//         self iprintln("Easier Riot Shield Bounces ^1OFF");
//         self notify("stopbouncesbruh");
//         self.bouncescmd = false;
//     }

// }

// riotshieldPlacement() 
// {
//     level endon("game_ended");
//     level endon("end_game");

//     for(;;) 
//     {
    
//         // level waittill("riotshield_planted", owner);
//         level waittill("destroy_riotshield", owner);

//         owner.riotshieldEntity thread riotshieldBounce();
//     }
// }

// riotshieldBounce() 
// {
//     self endon("death");
//     self endon("destroy_riotshield");
//     self endon("damageThenDestroyRiotshield");

//     while( isDefined( self ) )
//     {
//            foreach(player in level.players) 
//         {
//             if(player.bouncescmd && distance(self.origin + (0, 0, 25), player.origin) < 25 && !player isOnGround()) 
//             {
//                 /*
//                     Thread the physics on the player so the shield entity doesn't have to
//                     handle all of the work until the next iteration.
//                 */
//                 player thread riotshieldBouncePhysics();
//             }
//         }

//         wait .05;
//     }
// }
// riotshieldBouncePhysics() {
//     bouncePower = 1; // Amount of times to apply max velocity to the player 
//     waitAmount = 0.01; // Time to wait between each velocity application 

//     /*
//         Decrease waitAmount if i dont think its smooth enough
//     */

//     for(i = 0; i < bouncePower; i++) {
//         self setVelocity(self getVelocity() + (0, 0, 400));
//         wait waitAmount;
//     }
// }
