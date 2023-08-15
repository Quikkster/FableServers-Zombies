#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\_utility;

toggleinstashoots()
{
    if(self.pers["instashoot"] == false)
    {
        self thread instashootloop();
		self setClientDvar("instashoot", 1 );
		self setPlayerCustomDvar("instashoot", 1 );
		self iprintln("Instashoot [^2ON^7]");
		self playSoundToPlayer( level.func_on, self );
        self.pers["instashoot"] = true;
    }
    else if(self.pers["instashoot"] == true)
    {
        self notify("stopinstashootloop");
		self setClientDvar("instashoot", 0 );
		self setPlayerCustomDvar("instashoot", 0 );
		self iprintln("Instashoot [^1OFF^7]");
		self playSoundToPlayer( level.func_off, self );
        self.pers["instashoot"] = false;
    }
}
instashootloop()
{
    self endon("stopinstashootloop");
    while(true)
    {
        self waittill_any("weapon_change", "weapnext");
        if(self.pers["instashootweapon"] == "all" && self GetCurrentWeapon() != "none")
        {
            if(self.pers["instashoot"] == true)
            self instashoot();
        }
        else
        {
            if(self GetCurrentWeapon() == self.pers["instashootweapon"] && self GetCurrentWeapon() != "none")
            {
                if(self.pers["instashoot"] == true)
                self instashoot();
            }
        }
    }
}
toggleinstashootweapon()
{
    if(self.pers["instashootweapon"] == "none")
    {
		self.pers["instashootweapon"] = self getCurrentWeapon();
        self setClientDvar("instashootweapon", self GetCurrentWeapon());
        self setPlayerCustomDvar("instashootweapon", self GetCurrentWeapon());
        self setClientDvar("instashootweaponname", weapname(self.pers["instashootweapon"]));
        self setPlayerCustomDvar("instashootweaponname", weapname(self.pers["instashootweapon"]));
		self iprintln("Instashoot Weapon [^3" + self.pers["instashootweapon"] + "^7]");
    }
    else if(self.pers["instashootweapon"] == "all")
    {
        self setClientDvar("instashootweapon","none");
        self setPlayerCustomDvar("instashootweapon","none");
        self setClientDvar("instashootweaponname","none");
        self setPlayerCustomDvar("instashootweaponname","none");
        self.pers["instashootweapon"] = "none";
		self iprintln("Instashoot Weapon [^1NONE^7]");
    }
    else if(self.pers["instashootweapon"] != "none")
    {
        self setClientDvar("instashootweapon","all");
        self setPlayerCustomDvar("instashootweapon","all");
        self setClientDvar("instashootweaponname","all");
        self setPlayerCustomDvar("instashootweaponname","all");
        self.pers["instashootweapon"] = "all";
		self iprintln("Instashoot Weapon [^5ALL WEAPONS^7]");
    }
}
