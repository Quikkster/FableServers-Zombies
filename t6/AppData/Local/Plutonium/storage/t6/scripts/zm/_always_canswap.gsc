#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\functions;
#include scripts\zm\_utility;

set_canswap( threadFuncs )
{
    if(!isdefined(threadFuncs))
        threadFuncs = true;

    if(self getPlayerCustomDvar("canswapweap") == "none")
    {
        b = maps\mp\zombies\_zm_weapons::get_base_name(self getCurrentWeapon());

        self notify("stopalwayscanswapallloop");
        self setPlayerCustomDvar("canswapweap", b);
        self setPlayerCustomDvar("canswapweapfull", self getCurrentWeapon());
        // self setPlayerCustomDvar("canswapweap", self getCurrentWeapon());
        self setClientDvar("canswapweap", "[" + b + "]");
        self setClientDvar("canswapweapfull", "[" + self getCurrentWeapon() + "]");
        // self setClientDvar("canswapweap", "[" + self getCurrentWeapon() + "]");

        if(threadFuncs)
            self thread alwayscanswapspecificloop();

        self iPrintLn("Always Canswap: " + getPlayerCustomDvar("canswapweap"));
        
    }
    else if(self getPlayerCustomDvar("canswapweap") == "all")
    {
        if(threadFuncs)
            self notify("stopalwayscanswapspecificloop");
        
        self setPlayerCustomDvar("canswapweap","none");
        self setClientDvar("canswapweap","[none]");
        self iPrintLn("Always Canswap: " + getPlayerCustomDvar("canswapweap"));
    }
    else if(self getPlayerCustomDvar("canswapweap") != "none")
    {
        self setPlayerCustomDvar("canswapweap","all");
        self setClientDvar("canswapweap","[all]");

        if(threadFuncs)
            self thread alwayscanswapallloop();

        self iPrintLn("Always Canswap: " + getPlayerCustomDvar("canswapweap"));
    }
}


alwayscanswapspecificloop()
{
    self endon("stopalwayscanswapspecificloop");
    while(true)
    {
        // self waittill("weapon_change");
        // self waittill_any("weapon_change", "changed_class", "spawned_player");
    	event = self waittill_any_return( "weapon_change", "changed_class", "changed_kit", "spawned_player" );

        x = self getCurrentWeapon();
        b = maps\mp\zombies\_zm_weapons::get_base_name(self getCurrentWeapon());
        z = self getPlayerCustomDvar("canswapweapfull");
        // z = self getPlayerCustomDvar("canswapweap");

        if( event != "weapon_change" )
            wait 0.2;

        if(x != z && !isSubStr(z, b) && self hasWeapon(z))
        {
            self takeWeaponGood(z);
            self giveWeaponGood(z);
        }
    }
}

alwayscanswapallloop()
{
    self endon("stopalwayscanswapallloop");
    while(true)
    {
        // self waittill("weapon_change");
        // self waittill_any("weapon_change", "changed_class", "spawned_player");
    	event = self waittill_any_return( "weapon_change", "changed_class", "changed_kit", "spawned_player" );

        x = self getCurrentWeapon();
        y = self getnextweapon();
        z = self getPlayerCustomDvar("canswapweap");

        if( event != "weapon_change" )
            wait 0.2;

        if(z == "[all]" && x != y || z == "all" && x != y)
        {
            self takeWeaponGood(y);
            self giveWeaponGood(y);
        }
    }
}


canswaps()
{
    for(;;)
    {
        self waittill("weapon_change");
        // self waittill_any("weapon_change", "grenade_fire", "grenade_pullback" );
        if(self getPlayerCustomDvar("canswapweap") == "all")
        {
            x = self getCurrentWeapon();
            z = self getWeaponsListPrimaries();
            foreach(gun in z)
            {
                //  ALWAYS barrel roll, tac knife flip - (when set to "all") - since these weapons have no canswap.
                if(isSubStr(gun, "spas12") && isSubStr(x, "spas12") && self hasWeapon(gun) && self getnextweapon() == gun
                || isSubStr(gun, "tactical") && isSubStr(x, "tactical") && self hasWeapon(gun) && self getnextweapon() == gun
                || isSubStr(gun, "striker") && isSubStr(x, "striker") && self hasWeapon(gun) && self getnextweapon() == gun
                || isSubStr(gun, "m1014") && isSubStr(x, "m1014") && self hasWeapon(gun) && self getnextweapon() == gun
                )
                {
                    self takeWeaponGood(gun);
                    self giveWeaponGood(gun);
                    wait 0.1;
                    self smooth();
                }
                else if(x != gun)
                {
                    if(self getPlayerCustomDvar("smoothcanswaps") == "1")
                    {
                        self takeWeaponGood(gun);
                        self giveWeaponGood(gun);
                        wait 0.1;
                        self smooth();
                    }
                    else if(isSubStr(gun, "spas12") && isSubStr(x, "spas12") && self hasWeapon(gun) && self getnextweapon() == gun
                    || isSubStr(gun, "tactical") && isSubStr(x, "tactical") && self hasWeapon(gun) && self getnextweapon() == gun
                    || isSubStr(gun, "striker") && isSubStr(x, "striker") && self hasWeapon(gun) && self getnextweapon() == gun
                    || isSubStr(gun, "m1014") && isSubStr(x, "m1014") && self hasWeapon(gun) && self getnextweapon() == gun
                    )
                    {
                        self takeWeaponGood(gun);
                        self giveWeaponGood(gun);
                        wait 0.1;
                        self smooth();
                    }
                    else
                    {
                        self takeWeaponGood(gun);
                        self giveWeaponGood(gun);
                    }
                }
            }
        }
        if(self getPlayerCustomDvar("canswapweap") != "all" && self getPlayerCustomDvar("canswapweap") != "none")
        {
            x = self getCurrentWeapon();
            z = self getPlayerCustomDvar("canswapweap");
            //  ALWAYS barrel roll, tac knife flip - (when set to "specifiedweaponsname") - since these weapons have no canswap.
            if(isSubStr(z, "spas12") && isSubStr(x, "spas12") && self hasWeapon(z) && self getnextweapon() == z
            || isSubStr(z, "tactical") && isSubStr(x, "tactical") && self hasWeapon(z) && self getnextweapon() == z
            || isSubStr(z, "striker") && isSubStr(x, "striker") && self hasWeapon(z) && self getnextweapon() == z
            || isSubStr(z, "m1014") && isSubStr(x, "m1014") && self hasWeapon(z) && self getnextweapon() == z
            )
            {
                self takeWeaponGood(z);
                self giveWeaponGood(z);
                self smooth();
                // self iPrintLn(self getnextweapon());
            }
            else if(x != z && self hasWeapon(z))
            {
                if(self getPlayerCustomDvar("smoothcanswaps") == "1")
                {
                    self takeWeaponGood(z);
                    self giveWeaponGood(z);
                    wait 0.1;
                    self smooth();
                }
                else if(isSubStr(z, "spas12") && isSubStr(x, "spas12") && self hasWeapon(z) && self getnextweapon() == z
                || isSubStr(z, "tactical") && isSubStr(x, "tactical") && self hasWeapon(z) && self getnextweapon() == z
                || isSubStr(z, "striker") && isSubStr(x, "striker") && self hasWeapon(z) && self getnextweapon() == z
                || isSubStr(z, "m1014") && isSubStr(x, "m1014") && self hasWeapon(z) && self getnextweapon() == z
                )
                {
                    self takeWeaponGood(z);
                    self giveWeaponGood(z);
                    wait 0.1;
                    self smooth();
                }
                else
                {
                    self takeWeaponGood(z);
                    self giveWeaponGood(z);
                }
            }
        }
    }
}


// canswaps()
// {
//     for(;;)
//     {
//         self waittill("weapon_change");
//         if(getDvar("canswapweap") == "all")
//         {
//             x = self getCurrentWeapon();
//             z = self getWeaponsListPrimaries();
//             weaps = self getweaponslist();

//             for (i = 0; i < zs.size; i++)
//             {
//                 z = zs[i];
//             foreach(gun in z)
//             {
//                 if(x != gun)
//                 {
//                     self takeWeaponGood(gun);
//                     self giveWeaponGood();
//                 }
//             }
//         }
//         if(getDvar("canswapweap") != "all" && getDvar("canswapweap") != "none")
//         {
//             x = self getCurrentWeapon();
//             z = getDvar("canswapweap");
//             if(x != z && self hasWeapon(z))
//             {
//                 self takeWeaponGood(z);
//                 self giveWeaponGood();
//             }
//         }
//     }
// }
