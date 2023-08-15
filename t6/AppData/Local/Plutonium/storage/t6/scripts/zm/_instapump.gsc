#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\_utility;

toggleinstapump()
{
    if(self.pers["instapump"] == false)
    {
        self thread instapump(); // 0.1 delay
		self setClientDvar("instapump", 1 );
		self setPlayerCustomDvar("instapump", 1 );
		self iprintln("Shotgun Instapumps [^2ON^7]");
		self playSoundToPlayer( level.func_on, self );
        self.pers["instapump"] = true;
    }
    else if(self.pers["instapump"] == true)
    {
        self notify("stopinstapump");
		self setClientDvar("instapump", 0 );
		self setPlayerCustomDvar("instapump", 0 );
		self iprintln("Shotgun Instapumps [^1OFF^7]");
		self playSoundToPlayer( level.func_off, self );
        self.pers["instapump"] = false;
    }
}
instapump()
{
    self endon("stopinstapump");
    for(;;)
    {
        self waittill("weapon_fired");
        // self devp(self getcurrentweapon());
        if(self.pers["instapump"] == true)
        {
            if(isSubStr(self getCurrentWeapon(),"870mcs") || isSubStr(self getCurrentWeapon(),"ksg"))
            {
                cw = self getcurrentweapon();
                stock = self getWeaponAmmoStock(self getCurrentWeapon());   
                clip = self getWeaponAmmoClip(self getCurrentWeapon());  
                if( clip >= 1 ) { // ignore when in need of a reload
                self instashoot2();
                } else {
                self setWeaponAmmoClip(self getCurrentWeapon(), clip + 1);
                self setWeaponAmmoStock(self getCurrentWeapon(), stock + 2 );
                self instashoot2();
                }
            }
        }
    }
}