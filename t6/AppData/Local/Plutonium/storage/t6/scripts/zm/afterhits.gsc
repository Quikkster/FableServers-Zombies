#include common_scripts\utility;
#include maps\mp\_utility;

#include scripts\zm\_utility;
#include scripts\zm\functions;

init()
{
    level thread Floaters();
    level thread autoReload();
}

setAfterhit(afterhit)
{
	self notify("changeAfterhit");
	self notify("disableRandomAfterhit");
	self.setAfterhit = afterhit;
	self.pers["myAfterhit"] = self.setAfterhit;
	self iprintln("Afterhit has been set to: " + self.setAfterhit);

	self thread doAfterhit();
}

doAfterhit()
{          
	self endon("changeAfterhit");
    level waittill_any("game_ended", "end_game");
	self freezecontrols(false);
	wait 0.18;
	self takeallweapons();

	if(isSubStr(self.pers["myAfterhit"], "_akimbo"))
		self giveWeapon(self.pers["myAfterhit"], 0, true); //self giveweapon(self.setAfterhit);
	else
		self giveweapon(self.pers["myAfterhit"]); //self giveweapon(self.setAfterhit);
	
	self switchToWeapon(self.pers["myAfterhit"]); //(self.setAfterhit);
	wait 0.02;
	self freezecontrols(true);
}


init_afterhit()
{
    // after hit weap array
    for(i=0; i<20; i++)
    {
        self.afterhit[i] = [];
        self.afterhit[i]["on"] = false;
    }

    // get random perk bottle, and one that is being used
    level.perkBottles = [];
    if (is_true(level.zombiemode_using_juggernaut_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_jugg", level.perkBottles.size);
    if (is_true(level.zombiemode_using_sleightofhand_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_sleight", level.perkBottles.size);
    if (is_true(level.zombiemode_using_doubletap_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_doubletap", level.perkBottles.size);
    if (is_true(level.zombiemode_using_deadshot_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_deadshot", level.perkBottles.size);
    if (is_true(level.zombiemode_using_tombstone_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_tombstone", level.perkBottles.size);
    if (is_true(level.zombiemode_using_additionalprimaryweapon_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_additionalprimaryweapon", level.perkBottles.size);
    if (is_true(level.zombiemode_using_chugabud_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_revive", level.perkBottles.size);
    if (is_true(level.zombiemode_using_marathon_perk))
        arrayinsert(level.perkBottles, "zombie_perk_bottle_marathon", level.perkBottles.size);
    if (level.script == "zm_prison" || level.script == "zm_tomb")
        arrayinsert(level.perkBottles, "zombie_perk_bottle_cherry", level.perkBottles.size);
        // arrayinsert(level.perkBottles, "specialty_grenadepulldeath", level.perkBottles.size);
    if (level.script == "zm_buried")
        arrayinsert(level.perkBottles, "zombie_perk_bottle_vulture", level.perkBottles.size);
        // arrayinsert(level.perkBottles, "specialty_nomotionsensor", level.perkBottles.size);
    if (level.script == "zm_tomb")
        arrayinsert(level.perkBottles, "zombie_perk_bottle_nuke", level.perkBottles.size);
        // arrayinsert(level.perkBottles, "specialty_flakjacket", level.perkBottles.size);

    self.afterhit[0]["weapon"] = "fivesevendw_zm";
    self.afterhit[1]["weapon"] = "zombie_knuckle_crack";
    self.afterhit[2]["weapon"] = randomintrange(0, level.perkBottles.size);
    self.afterhit[3]["weapon"] = "chalk_draw_zm";
    self.afterhit[4]["weapon"] = "syrette_zm";
    self.afterhit[5]["weapon"] = "zombie_tomahawk_flourish";
    self.afterhit[6]["weapon"] = "lightning_hands_zm";
    self.afterhit[7]["weapon"] = "zombie_one_inch_punch_flourish";
    self.afterhit[8]["weapon"] = "rnma_zm";
    self.afterhit[9]["weapon"] = "slowgun_zm";
    self.afterhit[10]["weapon"] = "zombie_bowie_flourish";
    self.afterhit[11]["weapon"] = "zombie_tazer_flourish";
    self.afterhit[12]["weapon"] = "death_throe_zm";
    self.afterhit[13]["weapon"] = "ray_gun_zm";
    self.afterhit[14]["weapon"] = "raygun_mark2_zm";
    self.afterhit[15]["weapon"] = randomintrange(0, level.canswapWeapons.size);
    self.afterhit[16]["weapon"] = "screecher_arms_zm";
    self.afterhit[17]["weapon"] = "syrette_afterlife_zm";
    self.afterhit[18]["weapon"] = "minigun_alcatraz_zm";
    self.afterhit[19]["weapon"] = "claymore_zm";
}

can_toggle()
{
    foreach(weapon in self.afterhit)
    {
        if (weapon["on"])
        {
            return false;
        }
    }
    return true;
}

afterhitweapon(index)
{
    if (!self.afterhit[index]["on"])
    {
        if (!can_toggle())
        {
            self iprintln("cannot have more than ^1one^7 after hit on.");
            return;
        }

        if(index == 2)
        {
            self iPrintLn( "after hit ^2on ^7(" + convertperkbottle(level.perkBottles[self.afterhit[index]["weapon"]]) + ")" );
            self thread pullout_weapon(level.perkBottles[self.afterhit[index]["weapon"]], index);
        }        
        else if(index == 15)
        {
            self iPrintLn( "after hit ^2on ^7(" + level.canswapWeapons[self.afterhit[index]["weapon"]] + ")" );
            self thread pullout_weapon(level.canswapWeapons[self.afterhit[index]["weapon"]], index);
        }
        else
        {
            self iprintln("after hit ^2on ^7(" + self.afterhit[index]["weapon"] + ")");
            self thread pullout_weapon(self.afterhit[index]["weapon"], index);
        }
    }
    else if (self.afterhit[index]["on"])
    {
        self iprintln("after hit ^1off");
        self notify("KillAfterHit");
    }

    self.afterhit[index]["on"] = !self.afterhit[index]["on"];
}

pullout_weapon(weapon, index)
{
    self endon("disconnect");
    self endon("KillAfterHit");

    level waittill("game_ended");

    // self devp(index);
    // self devp(weapon);

    self takeweapon(self getcurrentweapon());
    self g_weapon(weapon,false);
}

/*=======================================================================================================================================*/


// toggle floaters
toggleautoreload()
{
    if(!self.pers["autoreload"])
    {
        self playSoundToPlayer( level.func_on, self );
        self.pers["autoreload"] = 1;
    }
    else
    {
        self playSoundToPlayer( level.func_off, self );
        self.pers["autoreload"] = 0;
    }

    /* end results */
    self setPlayerCustomDvar("autoreload", self.pers["floaters"] );
    self setClientDvar( "autoreload", self.pers["autoreload"]);
    self iPrintLn("Auto Reload Afterhit " + convertStatus(self.pers["autoreload"]));
}

autoReload()
{
	level waittill("game_ended");
	foreach(player in level.players)
	{
		if(player.pers["autoreload"] && !player isBot() && isAlive(player))
			player setWeaponAmmoClip(player getCurrentWeapon(), 0 );
	}
}


Floaters()
{
	level waittill("game_ended");
	foreach(player in level.players)
	{
		if(player.pers["floaters"] && !player isBot() && !player isOnGround() && isAlive(player))
			player thread FloatDown();
	}
}

// toggle floaters
toggleFloaters()
{
    if(!self.pers["floaters"])
    {
        self playSoundToPlayer( level.func_on, self );
        self.pers["floaters"] = 1;
    }
    else
    {
        self playSoundToPlayer( level.func_off, self );
        self.pers["floaters"] = 0;
    }

    /* end results */
    self setPlayerCustomDvar("floaters", self.pers["floaters"] );
    self setClientDvar( "floaters", self.pers["floaters"]);
    self iPrintLn("Floaters " + convertStatus(self.pers["floaters"]));
}

FloatDown()
{
	self endon("disconnect");
	self.Float = spawn("script_model",self.origin);
	self playerLinkTo(self.Float);
	wait 0.1;
	self freezeControls(true);
	for(;;)
	{
		self.Down = self.origin - (0,0,0.5);
		self.Float moveTo(self.Down, 0.01);
		wait 0.01;
	}
}

autoProne()
{
    if(self.AutoProne == 0)
    {
        self iPrintln("Auto Prone: ^2On");
        self endon("disconnect");
        level waittill_any("game_ended", "end_game");
        self thread LayDown();
        self.AutoProne = 1;
    }
    else
    {
        self iPrintln("Auto Prone: ^1Off");
        self notify("notprone");
        self.AutoProne = 0;
    }
}

LayDown()
{
    self endon("notprone");
    self endon("disconnect");
    
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
    self SetStance( "prone" );
    wait 0.5;
}


allowMoveAfterhit()
{
    if(self.allowMoveAfterhit == 0)
    {
        self iPrintln("Allow Move After Game Ends: ^2On");
        self endon("disconnect");
        level waittill_any("game_ended", "end_game");
        self thread allowMoveAfterGame();
        self.allowMoveAfterhit = 1;
    }
    else
    {
        self iPrintln("Allow Move After Game Ends: ^1Off");
        self notify("notmove");
        self.allowMoveAfterhit = 0;
    }
}

allowMoveAfterGame()
{
    self endon("notmove");
    self endon("disconnect");
    
    self freezeControls( false );
    wait 0.5;
    self freezeControls( false );
    wait 0.5;
    self freezeControls( false );
    wait 0.5;
    self freezeControls( false );
    wait 0.5;
    self freezeControls( false );
    wait 0.5;
    self freezeControls( false );
    wait 0.5;
}