#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\functions;
#include scripts\zm\glitches;
#include scripts\zm\_utility;
#include scripts\zm\utils;

/* shoutout @plugwalker47 */

bindinit( force )
{
    // EACH BIND NEEDS TO BE ADDED TO level.bindlist OR ELSE THIS SYSTEM WILL BREAK!
    level.bindlist = strTok("canswap,knucklecrack,bowieanim,galvaanim,chalkdrawanim,oipanim,axeanim,backflip,frontflip,leftflip,rightflip", ",");
    
    /* use this long one to test big menus */
    // level.bindlist = strTok("canswap,knucklecrack,bowieanim,galvaanim,chalkdrawanim,oipanim,axeanim,backflip,frontflip,leftflip,rightflip,testbinda,testbindb,testbindc,testbindd,testbinde,testbindf,testbindg,testbindh,testbindi,testbindj,testbindk,testbindl,testbindm,testbindn,testbindo,testbindp,testbindq", ",");
    
    // setdvar("bindsize", level.bindlist.size );

    if(!isDefined(force))
        force = false;

    foreach( bind in level.bindlist )
    {
        if(force)
        {
            /* resets all binds */
            self forcedefinepers(bind,0);
            // self forcedefinepers("canswap",0);
            // self forcedefinepers("knucklecrack",0);
            // self forcedefinepers("bowieanim",0);
            // self forcedefinepers("galvaanim",0);
            // self forcedefinepers("chalkdrawanim",0);
            // self forcedefinepers("oipanim",0);
            // self forcedefinepers("axeanim",0);
            // self forcedefinepers("backflip",0);
            // self forcedefinepers("frontflip",0);
            // self forcedefinepers("leftflip",0);
            // self forcedefinepers("rightflip",0);
            // self forcedefinepers("teststring","abc",0);
        }
        else
        {
            self definepers(bind,0);
            // self definepers("canswap",0);
            // self definepers("knucklecrack",0);
            // self definepers("bowieanim",0);
            // self definepers("galvaanim",0);
            // self definepers("chalkdrawanim",0);
            // self definepers("oipanim",0);
            // self definepers("axeanim",0);
            // self definepers("backflip",0);
            // self definepers("frontflip",0);
            // self definepers("leftflip",0);
            // self definepers("rightflip",0);
            // self definepers("teststring","abc",0);
        }
    }
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

        else if(!self.menu.is_open && isSubStr(command,self.pers["knucklecrack"]))
        {
            self domeleeflourish( "zombie_knuckle_crack", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["bowieanim"]))
        {
            if (level.script != "zm_tomb" && level.script != "zm_prison")
                self domeleeflourish( "bowie_knife_zm", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["chalkdrawanim"]))
        {
            if (level.script == "zm_buried")
                self domeleeflourish( "chalk_draw_zm", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["oipanim"]))
        {
            if (level.script == "zm_tomb")
                self domeleeflourish( "one_inch_punch_zm", false );
        }
        
        else if(!self.menu.is_open && isSubStr(command,self.pers["galvaanim"]))
        {
            if (level.script != "zm_tomb" && level.script != "zm_prison")
                self domeleeflourish( "tazer_knuckles_zm", false );
        }

        else if(!self.menu.is_open && isSubStr(command,self.pers["axeanim"]))
        {
            if (level.script == "zm_prison")
                self domeleeflourish( "bouncing_tomahawk_zm", false );
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

        // EACH BIND NEEDS TO BE ADDED TO level.bindlist OR ELSE THIS SYSTEM WILL BREAK!
        
        /* TODO: ADD STAFFS, ALL WONDER WEAPONS, AND PERKS (USE RANDOMIZED ARRAY FROM AFTERHITS TO MAKE LIFE EASIER) */

        else
        {
            /* ignore */
        }

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
        self devp(convertbindtoannounce(bind) + " set to ^5 [{+actionslot "+ self.pers[bind]+"}]");
        print(convertbindtoannounce(bind) + " set to ^5 [{+actionslot "+ self.pers[bind]+"}]");
    }
    else
    {
        self devp(convertbindtoannounce(bind) + " ^1Disabled");
        print(convertbindtoannounce(bind) + " ^1Disabled");
    }

    wait 1;
}


// changebind( bind, announcelabel )
// {
//     if(!isDefined(bind) || !isDefined(announcelabel))
//     {
//         self iPrintLn( "bind or announcelabel is not defined, aborting.." );
//         return;
//     }

//     if(!isDefined(self.pers[bind]))
//     {
//         self.pers[bind] = 0;
//     }
//     if(self.pers[bind] >= 4)
//     {
//         self.pers[bind] = 0;
//     }
//     else
//     {
//         self.pers[bind]++;
//         newbind = self.pers[bind];

//         level.bindlist = strTok("canswap,knucklecrack,bowieanim,chalkdrawanim", ",");

//         foreach(bind_ in level.bindlist)
//         {
//             if( bind_ != bind )
//             {
//                 if( self.pers[bind_] == newbind )
//                 {
//                     self iPrintLn( newbind );
//                     self iPrintLn( self.pers[bind_] );
//                     if( newbind > 4 || self.pers[bind_] > 4 )
//                     {
//                         self.pers[bind] = 0;
//                         newbind = 0;
//                     }
//                     else
//                     {
//                         self.pers[bind]++;
//                         newbind++;
//                     }
//                 }
//             }
//         }
//     }

//     // self.pers["button_"+self.pers[bind]+"_taken"] = true;


//     self setPlayerCustomDvar(bind, self.pers[bind] );
//     self setClientDvar( bind, self.pers[bind]);

//     if(self.pers[bind] != 0)
//     {
//         self iPrintLn(announcelabel + " Bind ^5[{+actionslot "+ self.pers[bind]+"}]");
//     }
//     else
//     {
//         self iPrintLn(announcelabel + " Bind ^1Disabled");
//     }

//     wait 1;
// }


/* 
// old example func
canswapbind()
{
    if(!isDefined(self.pers["canswap"]))
    {
        self.pers["canswap"] = 0;
    }
    if(self.pers["canswap"] == 4)
    {
        self.pers["canswap"] = 0;
    }
    else
    {
        self.pers["canswap"]++;
    }

    self setPlayerCustomDvar("canswap", self.pers["canswap"] );
    self setClientDvar( "canswap", self.pers["canswap"]);

    if(self.pers["canswap"] != 0)
        self iPrintLn("Canswap Bind ^5[{+actionslot "+ self.pers["canswap"]+"}]");
    else
        self iPrintLn("Canswap Bind ^1Disabled");
}

*/