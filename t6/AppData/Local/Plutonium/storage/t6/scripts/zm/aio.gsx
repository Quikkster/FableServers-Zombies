#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes_zm\_hud_util;
#include maps\mp\zombies\_zm_utility;

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

#include scripts\zm\functions;
#include scripts\zm\killcam;
#include scripts\zm\utils;
#include scripts\zm\_utility;

init() {
    level.strings = [];
    level.creator = "Quikkster";
    level.creator2 = "snoop pogg";
    level.shaders = array( "menu_mp_contract_expired", "menu_mp_killstreak_select", "ui_scrollbar_arrow_up_a", "ui_scrollbar_arrow_dwn_a", "ui_arrow_left", "ui_arrow_right", "gradient_fadein" );
    for( a = 0; a < level.shaders.size; a++ ) {
        precacheshader( level.shaders[ a ] );
    }
    level thread on_player_connect();
}
on_player_connect() {
    self endon( "disconnect" );
    level endon( "end_game" );
    while( true ) {
        level waittill( "connected", player );
        if( get_player( player ) == level.creator || get_player( player ) == level.creator2 ) {
            player.access = "Dev";
        }
        else {
            if( player ishost() ) {
                player.access = "Host";
            }
            else {
                player.access = "None";
            }
        }
        player thread on_player_spawned();
    }
}
on_player_spawned() {
    self waittill( "spawned_player" );
    if( !isdefined( level.overflowfix ) ) {
        level.overflowfix = true;
        level thread overflowfix();
    }
    if( !isdefined( self.menu_access ) && self get_access() ) {
        self.menu_access = true;
        self thread init_menu();
    }
}
init_preload() {
    if( !isdefined( self.color_palette ) ) {
        self.color_palette = [];
        self.color_palette[ 0 ] = divide_color( 0, 0, 0 );          // black
        self.color_palette[ 1 ] = divide_color( 255, 255, 255 );    // white
        self.color_palette[ 2 ] = divide_color( 255, 0, 255 );      // gradient right
        self.color_palette[ 3 ] = divide_color( 0, 191, 255 );      // gradient left
    }
}
init_menu() {
    self endon( "disconnect" );
    level endon( "end_game" );

    self.eminence           = [];
    self.eminence[ "menu" ] = "Welcome " + get_player( self );
    self.menu               = spawnstruct();
    self.menu.current_menu  = self.eminence[ "menu" ];

    self init_preload();
    self menu_option();
    while( true ) {
        // if( !isdefined( self.menu.is_open ) ) {
        if( !self.menu.is_open ) {
            if( self adsbuttonpressed() && ( self ActionSlotOneButtonPressed() || self ActionSlotTwoButtonPressed() ) /* self meleebuttonpressed() */ ) {
                self open_menu();
                self playlocalsound( "fly_rgunmk2_magin" );
                wait .15;
            }
        }
        else {
            if( self meleebuttonpressed() ) {
                menu = self get_menu();
                if( isdefined( self.menu.previous[ menu ] ) ) {
                    self new_menu( self.menu.previous[ menu ] );
                    self playlocalsound( "fly_rgunmk2_raise" );
                }
                else {
                    self close_menu();
                    self playlocalsound( "fly_rgunmk2_magout" );
                }
                wait .15;
            }
            if( self adsbuttonpressed() || self attackbuttonpressed() ) {
                menu = self get_menu();
                if( !self adsbuttonpressed() || !self attackbuttonpressed() ) {
                    self.menu.cursor[ menu ] += self attackbuttonpressed();
                    self.menu.cursor[ menu ] -= self adsbuttonpressed();
                    if( self.menu.option[ menu ].size >= 2 || !self.menu.option[ menu ].size <= 0 ) {
                        self playlocalsound( "fly_1911_mag_in" );
                    }
                    self update_scroller();
                    self update_utilities();
                    wait .125;
                }
            }
            if( self actionslotthreebuttonpressed() || self actionslotfourbuttonpressed() ) {
                menu   = self get_menu();
                cursor = self get_cursor();
                if( isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] ) ) {
                    self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] += self actionslotthreebuttonpressed();
                    self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] -= self actionslotfourbuttonpressed();
                    if( self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] < 0 ) {
                        self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] = self.menu.slider[ menu ][ "array" ][ cursor ].size - 1;
                    }
                    if( self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] > self.menu.slider[ menu ][ "array" ][ cursor ].size - 1 ) {
                        self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] = 0;
                    }
                    if( self.menu.slider[ menu ][ "array" ][ cursor ].size >= 2 ) {
                        self playlocalsound( "fly_shotgun_push" );
                    }
                    self.menu.slider[ menu ][ "slider" ][ cursor ] = self.menu.slider[ menu ][ "array" ][ cursor ][ self.menu.slider_cursor[ menu + "_cursor" ][ cursor ] ];
                    self update_slider( self.menu.slider[ menu ][ "slider" ][ cursor ] );
                    wait .125;
                }
            }
            if( self usebuttonpressed() || self jumpbuttonpressed() ) {
                menu   = self get_menu();
                cursor = self get_cursor();
                if( isdefined( self.menu.slider[ menu ][ "slider" ][ cursor ] ) ) {
                    self thread [[ self.menu.function[ menu ][ cursor ] ]]( self.menu.slider[ menu ][ "slider" ][ cursor ], self.menu.input_a[ menu ][ cursor ], self.menu.input_b[ menu ][ cursor ], self.menu.input_c[ menu ][ cursor ], self.menu.input_d[ menu ][ cursor ], self.menu.input_e[ menu ][ cursor ] );
                }
                else {
                    self thread [[ self.menu.function[ menu ][ cursor ] ]]( self.menu.input_a[ menu ][ cursor ], self.menu.input_b[ menu ][ cursor ], self.menu.input_c[ menu ][ cursor ], self.menu.input_d[ menu ][ cursor ], self.menu.input_e[ menu ][ cursor ] );
                }
                self playlocalsound( "fly_1911_slide_forward" );
                wait .25;
            }
        }
        wait .05;
    }
}
// structure
menu( menu, previous, title ) {
    self.menu.get[ menu ]      = menu;
    self.menu.count[ menu ]    = 0;
    self.menu.cursor[ menu ]   = 0;
    self.menu.scroller[ menu ] = 0;
    self.menu.slider[ menu ]   = [];
    self.menu.previous[ menu ] = previous;
    self.menu.title[ menu ]    = title;
}
new_menu( menu ) {
    if( !isdefined( menu ) ) {
        menu = self.menu.previous[ self.menu.previous.size -1 ];
        self.menu.previous[ self.menu.previous.size -1 ] = undefined;
    }
    else {
        self.menu.previous[ self.menu.previous.size ] = self get_menu();
    }
    self set_menu( menu );
    self store_text( self.menu.title[ menu ] );
    self update_utilities();
    self update_text();
    self update_scroller();
}
option( menu, text, function, a, b, c, d, e ) {
    menu                                 = self.menu.get[ menu ];
    number                               = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]   = text;
    self.menu.function[ menu ][ number ] = function;
    self.menu.input_a[ menu ][ number ]  = a;
    self.menu.input_b[ menu ][ number ]  = b;
    self.menu.input_c[ menu ][ number ]  = c;
    self.menu.input_d[ menu ][ number ]  = d;
    self.menu.input_e[ menu ][ number ]  = e;
    self.menu.count[ menu ]++;
}
toggle( menu, text, function, toggle, a, b, c, d, e ) {
    menu                                   = self.menu.get[ menu ];
    number                                 = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]     = text;
    self.menu.function[ menu ][ number ]   = function;
    if( isdefined( toggle ) ) {
        self.menu.toggle[ menu ][ number ] = toggle;
    }
    else {
        self.menu.toggle[ menu ][ number ] = undefined;
    }
    self.menu.input_a[ menu ][ number ]    = a;
    self.menu.input_b[ menu ][ number ]    = b;
    self.menu.input_c[ menu ][ number ]    = c;
    self.menu.input_d[ menu ][ number ]    = d;
    self.menu.input_e[ menu ][ number ]    = e;
    self.menu.count[ menu ]++;
}
slider( menu, text, function, ary, a, b, c, d, e ) {
    menu                                                      = self.menu.get[ menu ];
    number                                                    = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]                        = text;
    self.menu.function[ menu ][ number ]                      = function;
    if( !isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ number ] ) ) {
        self.menu.slider_cursor[ menu + "_cursor" ][ number ] = 0;
    }
    self.menu.slider[ menu ][ "array" ][ number ]             = ary;
    self.menu.slider[ menu ][ "slider" ][ number ]            = self.menu.slider[ menu ][ "array" ][ number ][ self.menu.slider_cursor[ menu + "_cursor" ][ number ] ];
    self.menu.menu_array[ menu ][ number ]                    = "";
    self.menu.input_a[ menu ][ number ]                       = a;
    self.menu.input_b[ menu ][ number ]                       = b;
    self.menu.input_c[ menu ][ number ]                       = c;
    self.menu.input_d[ menu ][ number ]                       = d;
    self.menu.input_e[ menu ][ number ]                       = e;
    self.menu.count[ menu ]++;
}
shader( menu, text, function, shader, a, b, c, d, e ) {
    menu                                   = self.menu.get[ menu ];
    number                                 = self.menu.count[ menu ];
    self.menu.option[ menu ][ number ]     = text;
    self.menu.function[ menu ][ number ]   = function;
    if( isdefined( shader ) ) {
        self.menu.shader[ menu ][ number ] = shader;
    }
    self.menu.input_a[ menu ][ number ]    = a;
    self.menu.input_b[ menu ][ number ]    = b;
    self.menu.input_c[ menu ][ number ]    = c;
    self.menu.input_d[ menu ][ number ]    = d;
    self.menu.input_e[ menu ][ number ]    = e;
    self.menu.count[ menu ]++;
}
update_toggle( toggle, menu, cursor ) {
    if( !isdefined( menu ) ) {
        menu = self get_menu();
    }
    if( !isdefined( cursor ) ) {
        cursor = self get_cursor();
    }
    self.menu.toggle[ menu ][ cursor ] = toggle;
    self update_menu();
}
update_slider( slider, menu, cursor ) {
    self notify( "slider_update" );
    if( !isdefined( menu ) ) {
        menu = self get_menu();
    }
    if( !isdefined( cursor ) ) {
        cursor = self get_cursor();
    }
    self.menu.menu_array[ menu ][ cursor ] = slider;
    self thread update_scroller();
}
update_menu() {
    saved_cursor = [];
    foreach( key in getarraykeys( self.menu.cursor ) ) {
        saved_cursor[ key ] = self.menu.cursor[ key ];
    }
    self menu_option();
    foreach( key in getarraykeys( saved_cursor ) ) {
        self.menu.cursor[ key ] = saved_cursor[ key ];
    }
    if( self in_menu() ) {
        self update_text();
        self update_scroller();
    }
}
clear_all( menu_array ) {
    keys = getarraykeys( menu_array );
    for( i = 0; i < keys.size; i++ ) {
        if( isdefined( menu_array[ keys[ i ] ][ 0 ] ) ) {
            for( b = 0; b < menu_array[ keys[ i ] ].size; b++ ) {
                menu_array[ keys[ i ] ][ b ] destroy();
            }
        }
        else {
            menu_array[ keys[ i ] ] destroy();
        }
    }
}
clear_menu( all ) {
    if( isdefined( all ) ) {
        foreach( hud in array( "aio", "option_left", "option_right" ) ) {
            if( isdefined( self.eminence[ hud ] ) ) {
                self clear_all( self.eminence[ hud ] );
            }
        }
    }
}
// huds
open_menu() {
    self.menu.is_open       = true;
    self.recreate_option = true;
    self store_huds();
    self store_text( self.menu.current_title );
    self update_menu();
    self update_scroller();
    self.recreate_option = undefined;
}
close_menu() {
    option = array( "option_left", "option_right" );
    for( i = 0; i < option.size; i++ ) {
        if( isdefined( self.eminence[ option[ i ] ] ) ) {
            for( x = 0; x < self.eminence[ option[ i ] ].size; x++ ) {
                self.eminence[ option[ i ] ][ x ] destroy();
            }
        }
    }
    self clear_menu( true );
    // self.menu.is_open = undefined;
    self.menu.is_open = false;
}
store_huds() {
    self.eminence[ "aio" ][ "gradient_left" ]  = self shape( "TOP", "CENTER", 0, -234, 180, 24, self.color_palette[ 2 ], "white", 2, 1 );
    self.eminence[ "aio" ][ "gradient_right" ] = self shape( "TOP", "CENTER", 0, -234, 180, 24, self.color_palette[ 3 ], "gradient_fadein", 3, 1 );
    self.eminence[ "aio" ][ "header" ]         = self shape( "TOP", "CENTER", 0, -210, 180, 16, self.color_palette[ 0 ], "white", 4, 1 );
    self.eminence[ "aio" ][ "background" ]     = self shape( "TOP", "CENTER", 0, -194, 180, 16, self.color_palette[ 0 ], "white", 5, .9 );
    if( !isdefined( self.scrollbar_cache ) ) {
        self.eminence[ "aio" ][ "scrollbar" ]  = self shape( "TOP", "CENTER", 0, -194, 180, 16, self.color_palette[ 1 ], "white", 6, 1 );
    }
    else {
        self.eminence[ "aio" ][ "scrollbar" ]  = self shape( "TOP", "CENTER", 0, self.scrollbar_cache, 180, 16, self.color_palette[ 1 ], "white", 6, 1 );
    }
    self.eminence[ "aio" ][ "footer" ]         = self shape( "TOP", "CENTER", 0, -178, 180, 2, self.color_palette[ 0 ], "white", 7, 1 );
    self.eminence[ "aio" ][ "up_arrow" ]       = self shape( "TOP", "CENTER", 0, -175, 3, 3, self.color_palette[ 1 ], "ui_scrollbar_arrow_up_a", 8, 0 );
    self.eminence[ "aio" ][ "down_arrow" ]     = self shape( "TOP", "CENTER", 0, -168, 3, 3, self.color_palette[ 1 ], "ui_scrollbar_arrow_dwn_a", 9, 0 );
    self.eminence[ "aio" ][ "title" ]          = self text( tolower( self.menuname ), "objective", 1.2, "CENTER", "TOP", 0, -19, self.color_palette[ 1 ], 1, 10, true );
    self.eminence[ "aio" ][ "subtitle" ]       = self text( "", "objective", 1, "LEFT", "TOP", -84, 2, self.color_palette[ 1 ], 1, 10, true );
    self.eminence[ "aio" ][ "counter" ]        = self text( "", "objective", 1, "RIGHT", "TOP", 84, 2, self.color_palette[ 1 ], 1, 10, true );
}
store_text( menu ) {
    if( !isdefined( menu ) ) {
        self.eminence[ "aio" ][ "subtitle" ] stext( self.eminence[ "menu" ] );
    }
    else {
        self.eminence[ "aio" ][ "subtitle" ] stext( menu );
    }
    if( isdefined( self.recreate_option ) ) {
        for( a = 0; a < 5; a++ ) {
            self.eminence[ "option_left" ][ a ] = self text( "", "objective", 1, "LEFT", "TOP", -84, ( ( a * 16 ) + 18 ), self.color_palette[ 1 ], 1, 10, true );
            self.eminence[ "option_right" ][ a ] = self shape( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ), 5, 5, self.color_palette[ 1 ], "white", 10, 1 );
        }
    }
}
update_text() {
    foreach( hud in array( "title", "counter" ) ) {
        if( isdefined( self.eminence[ "aio" ][ hud ] ) )
            self.eminence[ "aio" ][ hud ] destroy();
    }
    self.eminence[ "aio" ][ "title" ] = self text( tolower( self.menuname ), "objective", 1.2, "CENTER", "TOP", 0, -19, self.color_palette[ 1 ], 1, 10, true );
    self.eminence[ "aio" ][ "counter" ] = self text( "", "objective", 1, "RIGHT", "TOP", 84, 2, self.color_palette[ 1 ], 1, 10, true );
    self resize_huds();
    self update_utilities();
}
update_utilities() {
    if( isdefined( self.menu.option[ self.menu.current_menu ][ self.menu.cursor[ self.menu.current_menu ] ] ) )
        self.eminence[ "aio" ][ "counter" ] stext( "[" + ( self.menu.cursor[ self.menu.current_menu ] + 1 ) + "/" + self.menu.option[ self.menu.current_menu ].size + "]" );
    else
        self.eminence[ "aio" ][ "counter" ] stext( "[0/0]" );
}
update_scroller() {
    if( self.menu.cursor[ self.menu.current_menu ] < 0 ) {
        self.menu.cursor[ self.menu.current_menu ] = self.menu.option[ self.menu.current_menu ].size - 1;
    }
    if( self.menu.cursor[ self.menu.current_menu ] > self.menu.option[ self.menu.current_menu ].size - 1 ) {
        self.menu.cursor[ self.menu.current_menu ] = 0;
    }
    if( !isdefined( self.menu.option[ self.menu.current_menu ][ self.menu.cursor[ self.menu.current_menu ] - 2 ] ) || self.menu.option[ self.menu.current_menu ].size <= 5 ) {
        menu   = self get_menu();
        cursor = self get_cursor();
        for( a = 0; a < 5; a++ ) {
            if( isdefined( self.menu.option[ menu ][ a ] ) ) {
                self.eminence[ "option_left" ][ a ] stext( self.menu.option[ menu ][ a ] );
            }
            else {
                self.eminence[ "option_left" ][ a ] stext( "" );
            }
            if( cursor == a ) {
                foreach( hud in array( "option_left", "option_right" ) ) {
                    if( self.menu.option[ menu ].size <= 1 ) {
                        self.eminence[ hud ][ a ].color = self.color_palette[ 1 ];
                    }
                    else {
                        self.eminence[ hud ][ a ].color = self.color_palette[ 0 ];
                    }
                }
            }
            else {
                foreach( hud in array( "option_left", "option_right" ) ) {
                    if( self.menu.option[ menu ].size <= 1 ) {
                        self.eminence[ hud ][ a ].color = self.color_palette[ 0 ];
                    }
                    else {
                        self.eminence[ hud ][ a ].color = self.color_palette[ 1 ];
                    }
                }
            }
            if( isdefined( self.menu.toggle[ menu ][ a ] ) ) {
                self.eminence[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                self.eminence[ "option_right" ][ a ].color = divide_color( 255, 255, 255 );
                if( self.menu.toggle[ menu ][ a ] == true ) {
                    self.eminence[ "option_right" ][ a ] setshader( "menu_mp_killstreak_select", 5, 5 );
                }
                else {
                    self.eminence[ "option_right" ][ a ] setshader( "menu_mp_contract_expired", 5, 5 );
                }
            }
            else {
                if( isdefined( self.menu.function[ menu ][ a ] ) && self.menu.function[ menu ][ a ] == ::new_menu ) {
                    self.eminence[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 19 ) );
                    if( cursor == a ) {
                        self.eminence[ "option_right" ][ a ] setshader( "ui_arrow_right", 5, 5 );
                    }
                    else {
                        self.eminence[ "option_right" ][ a ] setshader( "ui_arrow_left", 5, 5 );
                    }
                }
                else if( isdefined( self.menu.shader[ menu ][ a ] ) ) {
                    self.eminence[ "option_right" ][ a ] setpoint( "CENTER", "TOP", 0, ( ( a * 16 ) + 18 ) );
                    self.eminence[ "option_right" ][ a ].color = self.menu.input_b[ menu ][ a ];
                    self.eminence[ "option_right" ][ a ] setshader( self.menu.shader[ menu ][ a ], self.menu.input_c[ menu ][ a ], self.menu.input_d[ menu ][ a ] );
                }
                else if( isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ a ] ) ) {
                    self.eminence[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                    self.eminence[ "option_right" ][ a ] stext(  "< " + self.menu.slider[ menu ][ "slider" ][ a ] + " > [" + ( self.menu.slider_cursor[ menu + "_cursor" ][ a ] + 1 ) + "/" + self.menu.slider[ menu ][ "array" ][ a ].size + "]" );
                }
                else {
                    self.eminence[ "option_right" ][ a ] stext( "" );
                }
            }
        }
        self.scrollbar_cache = ( ( 16 * cursor ) + -194 );
        self.eminence[ "aio" ][ "scrollbar" ].y = ( ( 16 * cursor ) + -194 );
    }
    else {
        if( isdefined( self.menu.option[ self.menu.current_menu ][ self.menu.cursor[ self.menu.current_menu ] + 2 ] ) ) {
            xepixtvx = 0;
            menu     = self get_menu();
            cursor   = self get_cursor();
            for( a = cursor - 2; a < cursor + 3; a++ ) {
                if( isdefined( self.menu.option[ menu ][ a ] ) ) {
                    self.eminence[ "option_left" ][ xepixtvx ] stext( self.menu.option[ menu ][ a ] );
                }
                else {
                    self.eminence[ "option_left" ][ xepixtvx ] stext( "" );
                }
                if( cursor == a ) {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.eminence[ hud ][ xepixtvx ].color = self.color_palette[ 1 ];
                        }
                        else {
                            self.eminence[ hud ][ xepixtvx ].color = self.color_palette[ 0 ];
                        }
                    }
                }
                else {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.eminence[ hud ][ xepixtvx ].color = self.color_palette[ 0 ];
                        }
                        else {
                            self.eminence[ hud ][ xepixtvx ].color = self.color_palette[ 1 ];
                        }
                    }
                }
                if( isdefined( self.menu.toggle[ menu ][ a ] ) ) {
                    self.eminence[ "option_right" ][ xepixtvx ] setpoint( "RIGHT", "TOP", 84, ( ( xepixtvx * 16 ) + 18 ) );
                    self.eminence[ "option_right" ][ xepixtvx ].color = divide_color( 255, 255, 255 );
                    if( self.menu.toggle[ menu ][ a ] == true ) {
                        self.eminence[ "option_right" ][ xepixtvx ] setshader( "menu_mp_killstreak_select", 5, 5 );
                    }
                    else {
                        self.eminence[ "option_right" ][ xepixtvx ] setshader( "menu_mp_contract_expired", 5, 5 );
                    }
                }
                else {
                    if( isdefined( self.menu.function[ menu ][ a ] ) && self.menu.function[ menu ][ a ] == ::new_menu ) {
                        self.eminence[ "option_right" ][ xepixtvx ] setpoint( "RIGHT", "TOP", 84, ( ( xepixtvx * 16 ) + 19 ) );
                        if( self.menu.cursor[ menu ] == a ) {
                            self.eminence[ "option_right" ][ xepixtvx ] setshader( "ui_arrow_right", 5, 5 );
                        }
                        else {
                            self.eminence[ "option_right" ][ xepixtvx ] setshader( "ui_arrow_left", 5, 5 );
                        }
                    }
                    else if( isdefined( self.menu.shader[ menu ][ a ] ) ) {
                        self.eminence[ "option_right" ][ xepixtvx ] setpoint( "CENTER", "TOP", 0, ( ( xepixtvx * 16 ) + 18 ) );
                        self.eminence[ "option_right" ][ xepixtvx ].color = self.menu.input_b[ menu ][ a ];
                        self.eminence[ "option_right" ][ xepixtvx ] setshader( self.menu.shader[ menu ][ a ], self.menu.input_c[ menu ][ a ], self.menu.input_d[ menu ][ a ] );
                    }
                    else if( isdefined( self.menu.slider_cursor[ menu + "_cursor" ][ a ] ) ) {
                        self.eminence[ "option_right" ][ xepixtvx ] setpoint( "RIGHT", "TOP", 84, ( ( xepixtvx * 16 ) + 18 ) );
                        self.eminence[ "option_right" ][ xepixtvx ] stext( "< " + self.menu.slider[ menu ][ "slider" ][ a ] + " > [" + ( self.menu.slider_cursor[ menu + "_cursor" ][ a ] + 1 ) + "/" + self.menu.slider[ menu ][ "array" ][ a ].size + "]" );
                    }
                    else {
                        self.eminence[ "option_right" ][ xepixtvx ] stext( "" );
                    }
                }
                xepixtvx++;
            }
            self.scrollbar_cache = ( ( 16 * 2 ) + -194 );
            self.eminence[ "aio" ][ "scrollbar" ].y = ( ( 16 * 2 ) + -194 );
        }
        else {
            menu   = self get_menu();
            cursor = self get_cursor();
            for( a = 0; a < 5; a++ ) {
                self.eminence[ "option_left" ][ a ] stext( self.menu.option[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] );
                if( cursor == self.menu.option[ menu ].size + ( a - 5 ) ) {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.eminence[ hud ][ a ].color = self.color_palette[ 1 ];
                        }
                        else {
                            self.eminence[ hud ][ a ].color = self.color_palette[ 0 ];
                        }
                    }
                }
                else {
                    foreach( hud in array( "option_left", "option_right" ) ) {
                        if( self.menu.option[ menu ].size <= 1 ) {
                            self.eminence[ hud ][ a ].color = self.color_palette[ 0 ];
                        }
                        else {
                            self.eminence[ hud ][ a ].color = self.color_palette[ 1 ];
                        }
                    }
                }
                if( isdefined( self.menu.toggle[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) ) {
                    self.eminence[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                    self.eminence[ "option_right" ][ a ].color = divide_color( 255, 255, 255 );
                    if( self.menu.toggle[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] == true ) {
                        self.eminence[ "option_right" ][ a ] setshader( "menu_mp_killstreak_select", 5, 5 );
                    }
                    else {
                        self.eminence[ "option_right" ][ a ] setshader( "menu_mp_contract_expired", 5, 5 );
                    }
                }
                else {
                    if( isdefined( self.menu.function[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) && self.menu.function[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] == ::new_menu ) {
                        self.eminence[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 19 ) );
                        if( cursor == self.menu.option[ menu ].size + ( a - 5 ) ) {
                            self.eminence[ "option_right" ][ a ] setshader( "ui_arrow_right", 5, 5 );
                        }
                        else {
                            self.eminence[ "option_right" ][ a ] setshader( "ui_arrow_left", 5, 5 );
                        }
                    }
                    else if( isdefined( self.menu.shader[ menu ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) ) {
                        option = ( self get_option().size + ( a - 5 ) );
                        self.eminence[ "option_right" ][ a ] setpoint( "CENTER", "TOP", 0, ( ( a * 16 ) + 18 ) );
                        self.eminence[ "option_right" ][ a ].color = self.menu.input_b[ menu ][ option ];
                        self.eminence[ "option_right" ][ a ] setshader( self.menu.shader[ menu ][ option ], self.menu.input_c[ menu ][ option ], self.menu.input_d[ menu ][ option ] );
                    }
                    else if( isdefined( self.menu.slider[ menu ][ "slider" ][ self.menu.option[ menu ].size + ( a - 5 ) ] ) ) {
                        self.eminence[ "option_right" ][ a ] setpoint( "RIGHT", "TOP", 84, ( ( a * 16 ) + 18 ) );
                        self.eminence[ "option_right" ][ a ] stext( "< " + self.menu.slider[ menu ][ "slider" ][ self.menu.option[ menu ].size + ( a - 5 ) ] + " > [" + ( self.menu.slider_cursor[ menu + "_cursor" ][ self.menu.option[ menu ].size + ( a - 5 ) ] + 1 ) + "/" + self.menu.slider[ menu ][ "array" ][ self.menu.option[ menu ].size + ( a - 5 ) ].size + "]" );
                    }
                    else {
                        self.eminence[ "option_right" ][ a ] stext( "" );
                    }
                }
            }
            self.scrollbar_cache = ( 16 * ( ( cursor - self.menu.option[ menu ].size ) + 5 ) + -194 );
            self.eminence[ "aio" ][ "scrollbar" ].y = ( 16 * ( ( cursor - self.menu.option[ menu ].size ) + 5 ) + -194 );
        }
    }
}
resize_huds() {
    size = self.menu.option[ self.menu.current_menu ].size;
    foreach( shader in array( "up_arrow", "down_arrow" ) ) {
        self.eminence[ "aio" ][ shader ].alpha = 0;
    }
    if( size <= 5 ) {
        if( size <= 0 ) {
            self store_text( "Currently No Options To Display!" );
            foreach( shader in array( "background", "scrollbar", "counter", "footer" ) ) {
                self.eminence[ "aio" ][ shader ].alpha = 0;
            }
        }
        else {
            if( size >= 0 ) {
                foreach( shader in array( "counter", "footer" ) ) {
                    self.eminence[ "aio" ][ shader ].alpha = 1;
                }
                self.eminence[ "aio" ][ "background" ].alpha = .9;
                if( size == 1 ) {
                    self.eminence[ "aio" ][ "scrollbar" ].alpha = 0;
                }
                else {
                    self.eminence[ "aio" ][ "scrollbar" ].alpha = 1;
                }
            }
        }
        self.eminence[ "aio" ][ "footer" ] setshader( "white", 180, 2 );
    }
    else {
        size = 5;
        foreach( shader in array( "scrollbar", "counter", "footer", "up_arrow", "down_arrow" ) ) {
            self.eminence[ "aio" ][ shader ].alpha = 1;
        }
        self.eminence[ "aio" ][ "background" ].alpha = .9;
        self.eminence[ "aio" ][ "footer" ] setshader( "white", 180, 16 );
    }
    self.eminence[ "aio" ][ "background" ] setshader( "white", 180, ( size * 16 ) );
    self.eminence[ "aio" ][ "footer" ].y = ( ( size * 16 ) - 194 );
    self.eminence[ "aio" ][ "up_arrow" ].y = ( ( size * 16 ) -191 );
    self.eminence[ "aio" ][ "down_arrow" ].y = ( ( size * 16 ) -184 );
}
text( text, font, scale, align, relative, x, y, color, alpha, sort, server, number ) {
    if( isdefined( server ) ) {
        textelem = level createserverfontstring( font, scale );
    }
    else {
        textelem = self createfontstring( font, scale );
    }
    textelem setpoint( align, relative, x, y );
    textelem.color          = color;
    textelem.alpha          = alpha;
    textelem.sort           = sort;
    textelem.hidewheninmenu = true;
    textelem.foreground     = true;
    textelem.archived       = true;
    if( isdefined( text ) ) {
        if( !isdefined( number ) ) {
            textelem stext( text );
        }
        else {
            textelem setvalue( text );
        }
    }
    return textelem;
}
shape( align, relative, x, y, width, height, color, shader, sort, alpha, server ) {
    if( isdefined( server ) ) {
        boxelem = newhudelem();
    }
    else {
        boxelem = newclienthudelem( self );
    }
    boxelem.elemtype = "icon";
    boxelem.children = [];
    boxelem setparent( level.uiparent );
    boxelem setpoint( align, relative, x, y );
    boxelem setshader( shader, width, height );
    boxelem.color          = color;
    boxelem.sort           = sort;
    boxelem.alpha          = alpha;
    boxelem.hidewheninmenu = true;
    boxelem.foreground     = true;
    boxelem.archived       = true;
    return boxelem;
}
convert( string ) {
    if( string[ 0 ] == toupper( string[ 0 ] ) ) {
        if( issubstr( string, " " ) && !issubstr( string, "_") ) {
            return string;
        }
    }
    string = strtok( tolower( string ), "_" );
    str    = "";
    for( a = 0; a < string.size; a++ ) {
        strings = array( "specialty", "zombie", "zm", "vending" );
        replacement = " ";
        if( !isinarray( strings, string[ a ] ) ) {
            for( b = 0; b < string[ a ].size; b++ ) {
                if( b != 0 ) {
                    str += string[ a ][ b ];
                }
                else {
                    str += toupper( string[ a ][ b ] );
                }
            }
            if( a != ( string.size - 1 ) ) {
                str += replacement;
            }
        }
    }
    return str;
}
// utility
bool( bool ) {
    if( isdefined( bool ) && bool ) {
        return true;
    }
    return false;
}
return_bool( bool ) {
    return ( !isdefined( bool ) ? true : undefined );
}
bool_state( bool ) {
    return ( isdefined( bool ) && isalive( self ) );
}
get_access() {
    if( self.access == "Dev" || self.access == "Host" || self.access == "Admin" || self.access == "Access" ) {
        return true;
    }
    return false;
}
get_menu() {
    return self.menu.current_menu;
}
get_cursor() {
    return self.menu.cursor[ self.menu.current_menu ];
}
set_menu( menu ) {
    self.menu.current_menu = menu;
}
set_cursor( cursor ) {
    self.menu.cursor[ self.menu.current_menu ] = cursor;
}
get_option() {
    return self.menu.option[ self.menu.current_menu ];
}
get_function() {
    return self.menu.function[ self.menu.current_menu ];
}
get_argument_a() {
    return self.menu.input_a[ self.menu.current_menu ];
}
get_argument_b() {
    return self.menu.input_b[ self.menu.current_menu ];
}
get_argument_c() {
    return self.menu.input_c[ self.menu.current_menu ];
}
get_argument_d() {
    return self.menu.input_d[ self.menu.current_menu ];
}
get_argument_e() {
    return self.menu.input_e[ self.menu.current_menu ];
}
get_shader() {
    return self.menu.shader[ self.menu.current_menu ];
}
get_player( player ) {
    client = getsubstr( player.name, 0, player.name.size );
    for( i = 0; i < client.size; i++ )
        if( client[ i ] == "]" )
            break;
    if( client.size != i )
        client = getsubstr( client, i + 1, client.size );
    return client;
}
get_health() {
    if( self hasperk( "specialty_armorvest" ) ) {
        if( isdefined( self.pers_upgrades_awarded[ "jugg" ] ) && self.pers_upgrades_awarded[ "jugg" ] ) {
            health = level.zombie_vars[ "zombie_perk_juggernaut_health" ] + level.pers_jugg_upgrade_health_bonus;
        }
        else {
            health = level.zombie_vars[ "zombie_perk_juggernaut_health" ];
        }
    }
    else {
        if( isdefined( self.pers_upgrades_awarded[ "jugg" ] ) && self.pers_upgrades_awarded[ "jugg" ] ) {
            health = level.pers_jugg_upgrade_health_bonus;
        }
        else {
            health = 100;
        }
    }
    return health;
}
in_menu() {
    // if( isdefined( self.menu_access ) && isdefined( self.menu.is_open ) ) {
    if( isdefined( self.menu_access ) && isdefined( self.menu.is_open ) && self.menu.is_open ) {
        return true;
    }
    return false;
}
divide_color( r, g, b ) {
    return ( r / 255, g / 255, b / 255 );
}
change_color( element, color ) {
    if( element == "gradient_left" ) {
        self.color_palette[ 2 ] = color;
    }
    if( element == "gradient_right" ) {
        self.color_palette[ 3 ] = color;
    }
    self.eminence[ "aio" ][ element ] fadeovertime( .2 );
    self.eminence[ "aio" ][ element ].color = color;
    wait .125;
}
stext( text ) {
    if( !isinarray( level.strings, text ) ) {
        level.strings[ level.strings.size ] = text;
        self settext( text );
        if( level.strings.size >= 60 ) {
            level notify( "clear_strings" );
        }
    }
    else {
        self settext( text );
    }
}
overflowfix() {
    level endon( "end_game" );
    level endon( "host_migration_begin" );
    test       = level createserverfontstring( "objective", 1 );
    test.alpha = 0;
    test settext( "xtul" );
    while( true ) {
        level waittill( "clear_strings" );
        test clearalltextafterhudelem();
        level.strings = [];
    }
}
// option
menu_option() {
    if( self get_access() ) {
        main = self.eminence[ "menu" ];
        self menu( main, undefined );

        a1 = "scripts"; a2 = "kill_aura";
        self option( main, convert( a1 ), ::new_menu, a1, convert( a1 ) );
        self menu( a1, main, convert( a1 ) );
            self toggle( a1, "God Mode", ::func_system, bool( self.god_mode ), undefined, self, 0 );
            self slider( a1, "Infinite Ammo", ::func_system, strtok( "Default;Reload;Continuous", ";" ), self, 1 );
            self toggle( a1, "Infinite Equipment", ::func_system, bool( self.infinite_equipment ), undefined, self, 2 );
            self option( a1, convert( a2 ), ::new_menu, a2, convert( a2 ) );
            self menu( a2, a1, convert( a2 ) );
                self toggle( a2, "Kill Aura", ::func_system, bool( self.kill_aura ), undefined, self, 3 );
                self slider( a2, "Aura Range", ::kill_aura, strtok( "Default;100;150;200;250;300;350;400;450;500", ";" ) );

        z1 = "customization"; z2 = "gradient_color"; z3 = "gradient_left"; z4 = "gradient_right";
        self option( main, convert( z1 ), ::new_menu, z1, convert( z1 ) );
        self menu( z1, main, convert( z1 ) );
            self option( z1, convert( z2 ), ::new_menu, z2, convert( z2 ) );
            self menu( z2, z1, convert( z2 ) );
                color_display = strtok( "deep_pink;hot_pink;violet;indigo;deep_sky_blue;dodger_blue;slate_blue;lime;spring_green;yellow;orange;coral;crimson;maroon;salmon", ";" );
                color_value   = strtok( "255;20;147;255;105;180;128;0;255;75;0;130;0;191;255;30;144;255;106;90;205;0;255;0;0;255;127;255;255;0;255;127;0;255;127;80;220;20;60;128;0;0;250;128;114", ";" );
                self option( z2, convert( z3 ), ::new_menu, z3, convert( z3 ) );
                self menu( z3, z2, convert( z3 ) );
                for( a = 0; a < color_display.size; a++ ) {
                    self shader( z3, "", ::change_color, "white", "gradient_left", divide_color( int( color_value[ 3 * a ] ), int( color_value[ ( 3 * a ) + 1 ] ), int( color_value[ ( 3 * a ) + 2 ] ) ), 140, 10 );
                }
                self option( z2, convert( z4 ), ::new_menu, z4, convert( z4 ) );
                self menu( z4, z2, convert( z4 ) );
                for( a = 0; a < color_display.size; a++ ) {
                    self shader( z4, "", ::change_color, "white", "gradient_right", divide_color( int( color_value[ 3 * a ] ), int( color_value[ ( 3 * a ) + 1 ] ), int( color_value[ ( 3 * a ) + 2 ] ) ), 140, 10 );
                }
    }
}
// scripts
func_system( array, player, index, argument_a, argument_b ) {
    if( !isplayer( player ) ) {
        foreach( player in level.players ) {
            player func_system( array, player, index, argument_a, argument_b );
        }
        return;
    }
    switch( index ) {
        case 0:
            player.god_mode = return_bool( player.god_mode );
            if( isdefined( player.god_mode ) ) {
                player enableinvulnerability();
                player thread god_mode( 9999999 );
            }
            else {
                player disableinvulnerability();
                self.maxhealth = get_health();
                self.health    = self.maxhealth;
                self notify( "god_mode" );
            }
            update_toggle( bool( player.god_mode ) );
        break;
        case 1:
            if( !isdefined( player.infinite_ammo ) ) {
                player.infinite_ammo = true;
                menu               = get_menu();
                cursor             = get_cursor();
                while( bool_state( player.infinite_ammo ) ) {
                    weapon = player getcurrentweapon();
                    if( get_menu() == menu ) {
                        infinite      = player.menu.slider[ menu ][ "slider" ][ cursor ];
                        infinite_type = infinite;
                    }
                    if( infinite_type == "Reload" ) {
                        player givemaxammo( weapon );
                    }
                    if( infinite_type == "Continuous" ) {
                        player setweaponammoclip( weapon, weaponclipsize( weapon ) );
                        player setweaponammostock( weapon, weaponmaxammo( weapon ) );
                        if( weapon != "none" ) {
                            player setweaponoverheating( 0, 0 );
                        }
                    }
                    player waittill_any( "weapon_fired", "new_weapon", "reload", "weapon_change", "slider_update" );
                }
            }
            else {
                player.infinite_ammo = undefined;
            }
        break;
        case 2:
            player.infinite_equipment = return_bool( player.infinite_equipment );
            if( isdefined( player.infinite_equipment ) )
                player thread infinite_equipment();
            else
                player notify( "infinite_equipment" );
            update_toggle( bool( player.infinite_equipment ) );
        break;
        case 3:
            player.kill_aura = return_bool( player.kill_aura );
            if( isdefined( player.kill_aura ) ) {
                player thread kill_aura();
            }
            else {
                player notify( "kill_aura" );
            }
            update_toggle( bool( player.kill_aura ) );
        break;
    }
}
god_mode( health ) {
    self endon( "god_mode" );
    while( bool_state( self.god_mode ) ) {
        self.maxhealth = health;
        self.health    = self.maxhealth;
        self enableinvulnerability();
        self waittill( "damage" );
    }
}
infinite_equipment() {
    self endon( "infinite_equipment" );
    while( bool_state( self.infinite_equipment ) ) {
        foreach( grenade in array( self get_player_lethal_grenade(), self get_player_tactical_grenade() ) ) {
            self givemaxammo( grenade );
        }
        foreach( tomahawk in array( "bouncing_tomahawk_zm", "upgraded_tomahawk_zm" ) ) {
            if( self hasweapon( tomahawk ) ) {
                self setweaponammostock( tomahawk, 1 );
            }
        }
        self waittill( "grenade_fire" );
    }
}
kill_aura() {
    if( !isdefined( self.kill_aura ) ) {
        self iprintln( "Kill Aura needs to be enabled to adjust values." );
    }
    else {
        if( !isdefined( aura_range ) ) {
            aura_range = 50;
        }
        else {
            menu   = get_menu();
            cursor = get_cursor();
            if( get_menu() == menu ) {
                adjust_aura    = self.menu.slider_cursor[ menu + "_cursor" ][ cursor ];
                increment_aura = adjust_aura;
            }
            aura_range = int( 50 + adjust_aura * 50 );
        }
        self notify( "kill_aura" );
        self endon( "kill_aura" );
        while( bool_state( self.kill_aura ) ) {
            foreach( zombie in getaiarray( level.zombie_team ) ) {
                if( isalive( zombie ) && distance( self.origin, zombie.origin ) < aura_range ) {
                    zombie dodamage( zombie.health + 1, self.origin, self, self );
                }
            }
            wait .05;
        }
    }
}