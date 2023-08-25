#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\functions;
#include scripts\zm\glitches;
#include scripts\zm\_utility;
#include scripts\zm\utils;

/* shoutout @plugwalker47 */

// bindIsAllowed( bind )
// {
//     switch( bind ) 
//     {
//         case "bowieknifeanim":
//         case "galvaknucklesanim":
//             if(level.script == "zm_tomb" || level.script == "zm_prison") return false;
//                 return false;    

//         case "chalkdrawanim":
//             if(level.script != "zm_buried")
//                 return false;    
    
//         case "ironfistanim":
//             if(level.script != "zm_tomb")
//                 return false;

//         case "tomahawkspinanim":
//             if(level.script != "zm_prison")
//                 return false;

//         default:
//             return true;    
//     }
// } 

bindIsAllowed( bind ) {
    if(bind == "bowieknifeanim" && ( level.script == "zm_tomb" || level.script == "zm_prison" ) ) return false;
    if(bind == "galvaknucklesanim" && ( level.script == "zm_tomb" || level.script == "zm_prison" ) ) return false;
    if(bind == "chalkdrawanim" && level.script != "zm_buried" ) return false;
    if(bind == "ironfistanim" && level.script != "zm_tomb" ) return false;
    if(bind == "tomahawkspinanim" && level.script != "zm_prison" ) return false;
    
    return true;
}

add_bind( bind )
{
    if(!isdefined(bind))
        return;

    if(!isdefined(level.binds))
        level.binds = "";

    if(!isdefined(level.disabledbinds))
        level.disabledbinds = "";
    
    if(!bindIsAllowed(bind))
    {
        if(!level.disabledbinds.size)
            level.disabledbinds = level.disabledbinds + bind;
        else
            level.disabledbinds = level.disabledbinds + "," + bind;

        return;
    }

    bindlist = strTok(level.binds, ",");

    foreach( bd in bindlist )
    {
        if( bd == bind ) {
            console( "^1error: add_bind - " + bind + " already added" );
            return;
        }
    }
        
    if(!level.binds.size)
        level.binds = level.binds + bind;
    else
        level.binds = level.binds + "," + bind;
}

bindinit( force )
{
    if(!isdefined(level.binds))
        level.binds = "";

    add_bind( "backflip" );
    add_bind( "bowieknifeanim" );
    add_bind( "canswap" );
    add_bind( "chalkdrawanim" );
    add_bind( "fakehitmarker" );
    add_bind( "fakehitmarker_red" );
    add_bind( "frontflip" );
    add_bind( "galvaknucklesanim" );
    add_bind( "ironfistanim" );
    add_bind( "knucklecrack" );
    add_bind( "leftflip" );
    add_bind( "rightflip" );
    add_bind( "tomahawkspinanim" );
    
    // add_bind( "backflip" );

    if(!isdefined(level.bindlist))
        level.bindlist = strTok(level.binds, ",");
    
    if(!isDefined(force))
        force = false;

    foreach( disabledbind in level.disabledbinds )
    {
        /* resets all binds that arent allowed on this specific map binds */
        self forcedefinepers(disabledbind,0);
    }

    foreach( bind in level.bindlist )
    {
        if(force)
        {
            /* resets all binds */
            self forcedefinepers(bind,0);
        }
        else
        {
            /* sets all binds to default if undefined */
            self definepers(bind,0);
        }
    }
}

resetBinds()
{
    self.pers["snlCombo"] = 1;

    foreach( bind in level.bindlist )
    {
        /* resets all binds */
        self forcedefinepers(bind,0);
    }

    foreach( disabledbind in level.disabledbinds )
    {
        self forcedefinepers(disabledbind,0);
    }

    self iPrintLn( "^1All binds have been reset to default or off" );
}

setupBindNotifies()
{
    self notifyOnPlayerCommand("dpad1", "+actionslot 1");
    self notifyOnPlayerCommand("dpad2", "+actionslot 2");
    self notifyOnPlayerCommand("dpad3", "+actionslot 3");
    self notifyOnPlayerCommand("dpad4", "+actionslot 4");
    self notifyOnPlayerCommand("knife", "+melee");
    self notifyOnPlayerCommand("knife", "+melee_zoom");
    self notifyOnPlayerCommand("usereload", "+usereload");
    self notifyOnPlayerCommand("usereload", "+reload");
}

bindwatch()
{
    self endon("disconnect");
    for(;;)
    {
        command = self waittill_any_return("dpad1", "dpad2", "dpad3", "dpad4");

        if(!self.menu.is_open && isSubStr(command,self.pers["canswap"]))
        {
            self thread docanswapt6();
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["backflip"]))
        {
            self dobackflip();
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["frontflip"]))
        {
            self dofrontflip();
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["frontflip"]))
        {
            self dofrontflip();
        }
        
        else if(!self.menu.is_open && isSubStr(command,self.pers["leftflip"]))
        {
            self doleftflip();
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["rightflip"]))
        {
            self dorightflip();
        }
        
        else if(!self.menu.is_open && isSubStr(command,self.pers["fakehitmarker"]))
        {
            self do_hitmarker_internal("MOD_RIFLE_BULLET",false);
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["fakehitmarker_red"]))
        {
            self do_hitmarker_internal("MOD_RIFLE_BULLET",true);
        }
        
        else if(!self.menu.is_open && isSubStr(command,self.pers["knucklecrack"]))
        {
            self domeleeflourish( "zombie_knuckle_crack", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["bowieknifeanim"]))
        {
            if (level.script != "zm_tomb" && level.script != "zm_prison")
                self domeleeflourish( "bowie_knife_zm", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["chalkdrawanim"]))
        {
            if (level.script == "zm_buried")
                self domeleeflourish( "chalk_draw_zm", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["ironfistanim"]))
        {
            if (level.script == "zm_tomb")
                self domeleeflourish( "one_inch_punch_zm", false );
        }
        
        else if(!self.menu.is_open && isSubStr(command,self.pers["galvaknucklesanim"]))
        {
            if (level.script != "zm_tomb" && level.script != "zm_prison")
                self domeleeflourish( "tazer_knuckles_zm", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["tomahawkspinanim"]))
        {
            if (level.script == "zm_prison")
                self domeleeflourish( "bouncing_tomahawk_zm", false );
        }

        // EACH BIND NEEDS TO BE ADDED TO level.bindlist OR ELSE THIS SYSTEM WILL BREAK!
        
        /* TODO: ADD STAFFS, ALL WONDER WEAPONS, AND PERKS (USE RANDOMIZED ARRAY FROM AFTERHITS TO MAKE LIFE EASIER) */

        // else
        // {
            /* ignore */
        // }

        wait 0.05;
    }
}

changebind( bind, announcelabel )
{
    if(!isDefined(bind) || !isDefined(announcelabel))
    {
        self iPrintLn( "bind or announcelabel is not defined, aborting.." );
        return;
    }
    
    changebind = bind;

    if(!isDefined(self.pers[bind]))
    {
        self.pers[bind] = 0;
    }
    if(self.pers[bind] >= 4)
    {
        self.pers[bind] = 0;
    }
    else
    {
        // self devp( self.pers[bind] );
        self.pers[bind]++;
        // self devp( self.pers[bind] );
        newbind = self.pers[bind];
        // self devp( newbind );

        // EACH BIND NEEDS TO BE ADDED TO level.bindlist OR ELSE THIS SYSTEM WILL BREAK!

        foreach(b in level.bindlist)
        {
            if( b != changebind )
            {
                // if( self.pers[b] == newbind )
                if( self.pers[b] == self.pers[changebind] )
                {
                    if( self.pers[b] == 0 && self.pers[changebind] == 0 )
                    {
                        /* ignore */
                    }
                    else
                    {
                        if( self.pers[changebind] >= 4 )
                        {
                            self.pers[changebind] = 0;
                        }
                        else
                        {
                            self.pers[changebind]++;
                            // self devp(self.pers[changebind]);
                        }
                    }
                }
            }
        }
    }

    // self.pers["button_"+self.pers[bind]+"_taken"] = true;


    self setPlayerCustomDvar(bind, self.pers[bind] );
    self setClientDvar( bind, self.pers[bind]);

    // if(self.pers[bind] != 0)
    // {
    //     self iPrintLn(announcelabel + " Bind ^5[{+actionslot "+ self.pers[bind]+"}]");
    // }
    // else
    // {
    //     self iPrintLn(announcelabel + " Bind ^1Disabled");
    // }

    if(self.pers[bind] != 0)
    {
        self iprintln(convertbindtoannounce(bind) + " set to ^5 [{+actionslot "+ self.pers[bind]+"}]");
        console(convertbindtoannounce(bind) + " set to ^5 [{+actionslot "+ self.pers[bind]+"}]");
    }
    else
    {
        self iprintln(convertbindtoannounce(bind) + " ^1Disabled");
        console(convertbindtoannounce(bind) + " ^1Disabled");
    }

    wait 1;
}

