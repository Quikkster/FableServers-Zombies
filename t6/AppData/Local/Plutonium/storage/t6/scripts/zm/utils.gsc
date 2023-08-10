#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\gametypes_zm\_hud_message;
#include maps\mp\zombies\_zm;
#include maps\mp\zombies\_zm_audio;
#include maps\mp\zombies\_zm_score;
#include maps\mp\zombies\_zm_spawner;
#include maps\mp\gametypes_zm\_globallogic_spawn;
#include maps\mp\gametypes_zm\_spectating;
#include maps\mp\_challenges;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\gametypes_zm\_globallogic_audio;
#include maps\mp\gametypes_zm\_spawnlogic;
#include maps\mp\gametypes_zm\_rank;
#include maps\mp\gametypes_zm\_weapons;
#include maps\mp\gametypes_zm\_spawning;
#include maps\mp\gametypes_zm\_globallogic_utils;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_globallogic_ui;
#include maps\mp\gametypes_zm\_globallogic_score;
#include maps\mp\gametypes_zm\_persistence;
#include maps\mp\zombies\_zm_weapons;
#include maps\mp\zombies\_zm_utility;

#include scripts\zm\functions;
#include scripts\zm\killcam;
#include scripts\zm\_utility;

convertbindtoannounce( bind )
{
    switch( bind )
    {
        case "knucklecrack":
            return "Knuckle Crack";

        case "bowieanim":
            return "Bowie Knife Animation";

        case "galvaanim":
            return "Galva Knuckles Animation";

        case "chalkdrawanim":
            return "Chalk Draw Animation";

        case "oipanim":
            return "Iron Fists Animation";

        case "axeanim":
            return "Tomahawk Spin Animation";

        case "canswap":
        case "backflip":
        case "frontflip":
        case "leftflip":
        case "rightflip":
            return firstLetterToUpper(bind);
    }
    return bind;
}

/* work inn progress, i think the func part is what breaks it */
createArrayMenu( leveldotarray, startingpoint, menuname, menudesc, func, arg1, arg2, arg3, statusRequired )
{
    if(!isdefined(leveldotarray))
        return;

    if(!isdefined(func))
        func = ::print_wrapper;

    if(!isdefined(statusRequired))
        statusRequired = "Verified";

    /* add menu to starting point */
    self add_option(startingpoint, menuname, ::submenu, menuname, menudesc );

    if(isdefined(leveldotarray))
    {
        array = leveldotarray;

        if( array.size > 12 )
        {
            /* if page 1 is full, make a second page */
            self add_menu(menuname+"2", menuname, statusRequired);

            if( array.size > 26 )
            {
                /* if page 2 is full, make a third page */
                self add_menu(menuname+"3", menuname+"2", statusRequired);

                if( array.size > 40 )
                {
                    /* if page 3 is full, make a fourth page */
                    self add_menu(menuname+"4", menuname+"3", statusRequired);

                    if( array.size > 54 )
                    {
                        /* if page 4 is full, make a fifth page */
                        self add_menu(menuname+"5", menuname+"4", statusRequired);

                        if( array.size > 68 )
                        {
                            /* if page 5 is full, make a sixth page */
                            self add_menu(menuname+"6", menuname+"5", statusRequired);

                            if( array.size > 82 )
                            {
                                /* if page 6 is full, make a seventh page */
                                self add_menu(menuname+"7", menuname+"6", statusRequired);

                                if( array.size > 96 )
                                {
                                    /* if page 7 is full, make a eigth page */
                                    self add_menu(menuname+"8", menuname+"7", statusRequired);

                                    if( array.size > 110 )
                                    {
                                        /* if page 8 is full, make a ninth page */
                                        self add_menu(menuname+"9", menuname+"8", statusRequired);

                                        if( array.size > 124 )
                                        {
                                            /* if page 9 is full, make a tenth page */
                                            self add_menu(menuname+"10", menuname+"9", statusRequired);
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        for ( i = 0; i < array.size; i++ )
        {
            _array = array[i];

            /* page 1 */
            if( i < 13 )
            {
                // self add_option(menuname, _array + " " + i, /* ::callfunc,  */[[func]]( _array, _array + i ) );
                self add_option(menuname, _array + " " + i, /* ::callfunc,  */func, _array, _array + i );
            }
            /* page 2 */
            else if( i >= 13 && i < 27 )
            {
                self add_option(menuname+"2", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page2created)
                {
                    self add_option(menuname, menuname+"2", ::submenu, menuname+"2", menudesc + " [2]" );
                    page2created = true;
                }
            }
            /* page 3 */
            else if( i >= 27 && i < 41 )
            {
                self add_option(menuname+"3", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page3created)
                {
                    self add_option(menuname+"2", menuname+"3", ::submenu, menuname+"3", menudesc + " [3]" );
                    page3created = true;
                }
            }
            /* page 4 */
            else if( i >= 41 && i < 55 )
            {
                self add_option(menuname+"4", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page4created)
                {
                    self add_option(menuname+"3", menuname+"4", ::submenu, menuname+"4", menudesc + " [4]" );
                    page4created = true;
                }
            }
            /* page 5 */
            else if( i >= 55 && i < 67 )
            {
                self add_option(menuname+"5", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page5created)
                {
                    self add_option(menuname+"4", menuname+"5", ::submenu, menuname+"5", menudesc + " [5]" );
                    page5created = true;
                }
            }
            /* page 6 */
            else if( i >= 67 && i < 81 )
            {
                self add_option(menuname+"6", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page6created)
                {
                    self add_option(menuname+"5", menuname+"6", ::submenu, menuname+"6", menudesc + " [6]" );
                    page6created = true;
                }
            }
            /* page 7 */
            else if( i >= 81 && i < 95 )
            {
                self add_option(menuname+"7", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page7created)
                {
                    self add_option(menuname+"6", menuname+"7", ::submenu, menuname+"7", menudesc + " [7]" );
                    page7created = true;
                }
            }
            /* page 8 */
            else if( i >= 95 && i < 109 )
            {
                self add_option(menuname+"8", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page8created)
                {
                    self add_option(menuname+"7", menuname+"8", ::submenu, menuname+"8", menudesc + " [8]" );
                    page8created = true;
                }
            }
            /* page 9 */
            else if( i >= 109 && i < 123 )
            {
                self add_option(menuname+"9", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page9created)
                {
                    self add_option(menuname+"8", menuname+"9", ::submenu, menuname+"9", menudesc + " [9]" );
                    page9created = true;
                }
            }
            /* page 10 */
            else if( i >= 123 && i < 137 )
            {
                self add_option(menuname+"10", _array + " " + i, ::print_wrapper, _array + " " + i );
                if(!page10created)
                {
                    self add_option(menuname+"9", menuname+"10", ::submenu, menuname+"10", menudesc + " [10]" );
                    page10created = true;
                }
            }
            /* limit reached */
            else if( i >= 137 )
            {
                iPrintLn( "^1limit reached (^3"+i+"^1), aborting.. [" + menuname + "]" );
                return;
            }
        }

    }
    else
    {
        self add_option(menuname, "placeholder", ::print_wrapper, "this is a test button!");
    }
}

_blank(menu,seperator)
{
    if(!isdefined(seperator))
        seperator = false;
    
    if(!seperator)
        self add_option(menu, " ", ::donothing);
    else
        self add_option(menu, "-----------------", ::donothing); //-----------------------------
}

// fake_scroller(x, y, color)
// {
//     if(!isdefined(x))
//         x = 800;

//      if(!isdefined(y))
//         y = -100;
    
//     if(!isdefined(color))
//         color = (0.749, 0, 0);

//     if(!isdefined(alpha))
//         alpha = 255;

//     self drawShader("white", x, y, 155, 12, color, alpha, 1);
// }

donothing(){}

setDvarIfUninitialized(dvar, value){
	if(!IsInizialized(dvar))
		setDvar(dvar, value);
}

SetDvarIfNotInitialized(dvar, value){
	if(!IsInizialized(dvar))
		setDvar(dvar, value);
}

SetDvarIfNotInizialized(dvar, value){
	if(!IsInizialized(dvar))
		setDvar(dvar, value);
}

IsInizialized(dvar){
	result = getDvar(dvar);
	return result != undefined || result != "";
} 

get_number_of_zombies()
{
    return (maps\mp\zombies\_zm_utility::get_round_enemy_array().size + level.zombie_total);
}

// birchy utils
draw_text_2(text, align, relative, x, y, fontscale, font, color, alpha, sort)
{
    //element = self createfontstring(font, fontscale);
    element = self createfontstring(font, fontscale);
    element setpoint(align, relative, x, y);
    element settext(text);
    element.hidewheninmenu = false;
    element.color = color;
    element.alpha = alpha;
    element.sort = sort;
    return element;
}

draw_shader(align, relative, x, y, shader, width, height, color, alpha, sort)
{
    element = newclienthudelem(self);
    element.elemtype = "bar";
    element.hidewheninmenu = false;
    element.shader = shader;
    element.width = width;
    element.height = height;
    element.align = align;
    element.relative = relative;
    element.xoffset = 0;
    element.yoffset = 0;
    element.children = [];
    element.sort = sort;
    element.color = color;
    element.alpha = alpha;
    element setparent(level.uiparent);
    element setshader(shader, width, height);
    element setpoint(align, relative, x, y);
    return element;
}

drawShader(shader, x, y, width, height, color, alpha, sort)
{
    hud = newClientHudElem(self);
    hud.elemtype = "icon";
    hud.color = color;
    hud.alpha = alpha;
    hud.sort = sort;
    hud.children = [];
    hud setParent(level.uiParent);
    hud setShader(shader, width, height);
    hud.x = x;
    hud.y = y;
    return hud;
}

draw_text(text, font, fontScale, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = self createFontString(font, fontScale);
    hud.x = x;
    hud.y = y;
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    hud set_safe_text(self, text);
    return hud;
}

draw_value(value, font, fontScale, align, relative, x, y, color, alpha, glowColor, glowAlpha, sort)
{
    hud = self createFontString(font, fontScale);

    hud setpoint(align, relative, x, y);
    hud.color = color;
    hud.alpha = alpha;
    hud.glowColor = glowColor;
    hud.glowAlpha = glowAlpha;
    hud.sort = sort;
    hud.alpha = alpha;
    hud setvalue(value);
    return hud;
}

/*
    overflow fix
*/

overflow_fix()
{
    self.stringTable = [];
    self.stringTableEntryCount = 0;
    self.textTable = [];
    self.textTableEntryCount = 0;
    if (!isdefined(level.anchorText))
    {
        level.anchorText = createServerFontString("default", 1.5);
        level.anchorText setText("anchor");
        level.anchorText.alpha = 0;
        level.stringCount = 0;
        level thread overflow_monitor();
    }
}

overflow_monitor()
{
    level endon("disconnect");
    level endon("game_ended");
    for(;;)
    {
        wait 0.05;

        if (level.stringCount >= 50)
        {
            level.anchorText clearAllTextAfterHudElem();
            level.stringCount = 0;

            players = getplayers();
            foreach(player in players)
            {
                if (!isdefined(player))
                    continue;

                player purge_text_table();
                player purge_string_table();
                player recreate_text();
            }
        }
    }
}

set_safe_text(player, text)
{
    stringId = player get_string_id(text);
    if (stringId == -1)
    {
        player add_string_table_entry(text);
        stringId = player get_string_id(text);
    }
    player edit_text_table_entry(self.textTableIndex, stringId);
    self setText(text);
}

recreate_text()
{
    foreach(entry in self.textTable)
        entry.element set_safe_text(self, lookup_string_by_id(entry.stringId));
}

add_string_table_entry(string)
{
    entry = spawnStruct();
    entry.id = self.stringTableEntryCount;
    entry.string = string;
    self.stringTable[self.stringTable.size] = entry;
    self.stringTableEntryCount++;
    level.stringCount++;
}

lookup_string_by_id(id)
{
    string = "";
    foreach(entry in self.stringTable)
    {
        if (entry.id == id)
        {
            string = entry.string;
            break;
        }
    }
    return string;
}

get_string_id(string)
{
    id = -1;
    foreach(entry in self.stringTable)
    {
        if (entry.string == string)
        {
            id = entry.id;
            break;
        }
    }
    return id;
}

get_string_table_entry(id)
{
    stringTableEntry = -1;
    foreach(entry in self.stringTable)
    {
        if (entry.id == id)
        {
            stringTableEntry = entry;
            break;
        }
    }
    return stringTableEntry;
}

purge_string_table()
{
    stringTable = [];
    foreach(entry in self.textTable)
    {
        stringTable[stringTable.size] = get_string_table_entry(entry.stringId);
    }
    self.stringTable = stringTable;
}

purge_text_table()
{
    textTable = [];
    foreach(entry in self.textTable)
    {
        if (entry.id != -1)
        {
            textTable[textTable.size] = entry;
        }
    }
    self.textTable = textTable;
}

edit_text_table_entry(id, stringId)
{
    foreach(entry in self.textTable)
    {
        if (entry.id == id)
        {
            entry.stringId = stringId;
            break;
        }
    }
}

delete_text_table_entry(id)
{
    foreach(entry in self.textTable)
    {
        if (entry.id == id)
        {
            entry.id = -1;
            entry.stringId = -1;
        }
    }
}

clear(player)
{
    if (self.type == "text")
        player delete_text_table_entry(self.textTableIndex);

    if (isdefined(self))
        self destroy();
}
