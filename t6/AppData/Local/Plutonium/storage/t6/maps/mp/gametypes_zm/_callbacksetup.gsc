#include maps\mp\gametypes_zm\_hostmigration;
#include maps\mp\gametypes_zm\_globallogic_actor;
#include maps\mp\gametypes_zm\_globallogic_player;
#include maps\mp\gametypes_zm\_globallogic;
#include maps\mp\_audio;
#include maps\mp\_utility;
#include common_scripts\utility;

codecallback_startgametype()
{
	if ( !isDefined( level.gametypestarted ) || !level.gametypestarted )
	{
		[[ level.callbackstartgametype ]]();
		level.gametypestarted = 1;
	}
}

codecallback_finalizeinitialization()
{
	maps\mp\_utility::callback( "on_finalize_initialization" );
}

codecallback_playerconnect()
{
	self endon( "disconnect" );
	self thread maps\mp\_audio::monitor_player_sprint();
	[[ level.callbackplayerconnect ]]();
}

codecallback_playerdisconnect()
{
	self notify( "disconnect" );
	client_num = self getentitynumber();
	[[ level.callbackplayerdisconnect ]]();
}

codecallback_hostmigration()
{
/#
	println( "****CodeCallback_HostMigration****" );
#/
	[[ level.callbackhostmigration ]]();
}

codecallback_hostmigrationsave()
{
/#
	println( "****CodeCallback_HostMigrationSave****" );
#/
	[[ level.callbackhostmigrationsave ]]();
}

codecallback_prehostmigrationsave()
{
/#
	println( "****CodeCallback_PreHostMigrationSave****" );
#/
	[[ level.callbackprehostmigrationsave ]]();
}

codecallback_playermigrated()
{
/#
	println( "****CodeCallback_PlayerMigrated****" );
#/
	[[ level.callbackplayermigrated ]]();
}

codecallback_playerdamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex )
{
	self endon( "disconnect" );

	// iPrintLn( eattacker.name );
	// iPrintLn( self.name );
	// iPrintLn( einflictor.name ); 
	// self iPrintLn( smeansofdeath );

	// eattacker scripts\zm\_utility::devp( weaponclass( sweapon ) );
	// eattacker scripts\zm\_utility::devp( sweapon );
	// eattacker scripts\zm\_utility::devp( smeansofdeath );
	// eattacker scripts\zm\_utility::devp( "Are we at last? " + level.is_last );

	if(eattacker.menu.is_open)
	{
		return;
	}

	if( smeansofdeath == "MOD_SUICIDE" )
	{
		return;
	}

	if( ( eattacker == self || eattacker == einflictor ) )
	{
		if( eattacker.health < 50 )
		{
			// devp( idamage );
			return;
		}
	}

	if(smeansofdeath == "MOD_PROJECTILE" && isSubStr(sweapon, "staff_revive") || smeansofdeath == "MOD_IMPACT" && scripts\zm\_utility::noobTube(sweapon) || scripts\zm\_utility::isSniper(sweapon) || scripts\zm\_utility::IsMarksmanRifle(sweapon) || scripts\zm\_utility::IsBallisticKnife(sweapon) && smeansofdeath != "MOD_MELEE" || scripts\zm\_utility::IsThrowingKnife(sweapon) || scripts\zm\_utility::IsCrossbow(sweapon) && smeansofdeath != "MOD_EXPLOSIVE" && !isSubStr(smeansofdeath, "SPLASH"))
	{
		idamage = 1000000;
	}

	if(smeansofdeath == "MOD_MELEE" && ( !is_true(level.is_last) || self isBot() ) )
	{
		idamage = 1000000;
	}
	
	if(is_true(level.is_last))
	{
		if(is_true(eattacker.limit_damage_weapons))
		{
			if(smeansofdeath == "MOD_PROJECTILE" && isSubStr(sweapon, "staff_revive") || smeansofdeath == "MOD_IMPACT" && scripts\zm\_utility::noobTube(sweapon) || scripts\zm\_utility::isSniper(sweapon) || scripts\zm\_utility::IsMarksmanRifle(sweapon) || scripts\zm\_utility::IsBallisticKnife(sweapon) && smeansofdeath != "MOD_MELEE" || scripts\zm\_utility::IsThrowingKnife(sweapon) || scripts\zm\_utility::IsCrossbow(sweapon) && smeansofdeath != "MOD_EXPLOSIVE" && !isSubStr(smeansofdeath, "SPLASH"))
			{
				idamage = 1000000;
			}
			else
			{
				if( self.health < 50 && eattacker != self && sweapon != eattacker.aimbotweapon && !eattacker.aimbot )
				{
					eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,false);
					return;
				}
			}
		}
	}

	if(idamage >= self.health)
		eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,true);
	else
		eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,false);

	[[ level.callbackplayerdamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex );
}

codecallback_playerkilled( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, timeoffset, deathanimduration )
{
	self endon( "disconnect" );

	if( eattacker != self )
	{
		eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,true);
	}
	
	[[ level.callbackplayerkilled ]]( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, timeoffset, deathanimduration );
}

codecallback_playerlaststand( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, timeoffset, deathanimduration )
{
	self endon( "disconnect" );
	[[ level.callbackplayerlaststand ]]( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, timeoffset, deathanimduration );
}

codecallback_playermelee( eattacker, idamage, sweapon, vorigin, vdir, boneindex, shieldhit )
{
	self endon( "disconnect" );
	[[ level.callbackplayermelee ]]( eattacker, idamage, sweapon, vorigin, vdir, boneindex, shieldhit );
}

codecallback_actordamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex )
{
	// iPrintLn( eattacker.name );
	// iPrintLn( self.name );
	// iPrintLn( einflictor.name ); 
	// self iPrintLn( smeansofdeath );

	// eattacker scripts\zm\_utility::devp( weaponclass( sweapon ) );
	// eattacker scripts\zm\_utility::devp( sweapon );
	// eattacker scripts\zm\_utility::devp( smeansofdeath );
	// eattacker scripts\zm\_utility::devp( "Are we at last? " + level.is_last );

	if(eattacker.menu.is_open)
	{
		return;
	}

	if( smeansofdeath == "MOD_SUICIDE" )
	{
		return;
	}

	if( ( eattacker == self || eattacker == einflictor ) )
	{
		// eattacker devp(getdistance(eattacker,self));

		if( eattacker.health < 50 )
		{
			// eattacker devp( idamage );
			return;
		}
	}

	if(smeansofdeath == "MOD_PROJECTILE" && isSubStr(sweapon, "staff_revive") || smeansofdeath == "MOD_IMPACT" && scripts\zm\_utility::noobTube(sweapon) || scripts\zm\_utility::isSniper(sweapon) || scripts\zm\_utility::IsMarksmanRifle(sweapon) || scripts\zm\_utility::IsBallisticKnife(sweapon) && smeansofdeath != "MOD_MELEE" || scripts\zm\_utility::IsThrowingKnife(sweapon) || scripts\zm\_utility::IsCrossbow(sweapon) && smeansofdeath != "MOD_EXPLOSIVE" && !isSubStr(smeansofdeath, "SPLASH"))
	{
		idamage = 1000000;
	}

	if(smeansofdeath == "MOD_MELEE" && !is_true(level.is_last))
	{
		idamage = 1000000;
	}
	
	if(is_true(level.is_last))
	{
		if(is_true(eattacker.land_protection))
		{
			if(eattacker isonground())
			{
				if(getdistance(eattacker,self) >= 10)
				{
					eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,false);
					eattacker scripts\zm\_utility::EventPopup("you landed",game["colors"]["white"]);
				}
				return;
			}
		}

		if(is_true(eattacker.barrel_protection))
		{
			if(getdistance(eattacker,self) <= 9)
			{
				eattacker scripts\zm\_utility::EventPopup("too close [^5"+getdistance(eattacker,self)+"^7m]",game["colors"]["white"]);
				return;
			}
		}

		if(is_true(eattacker.limit_damage_weapons))
		{
			if(smeansofdeath == "MOD_PROJECTILE" && isSubStr(sweapon, "staff_revive") || smeansofdeath == "MOD_IMPACT" && scripts\zm\_utility::noobTube(sweapon) || scripts\zm\_utility::isSniper(sweapon) || scripts\zm\_utility::IsMarksmanRifle(sweapon) || scripts\zm\_utility::IsBallisticKnife(sweapon) && smeansofdeath != "MOD_MELEE" || scripts\zm\_utility::IsThrowingKnife(sweapon) || scripts\zm\_utility::IsCrossbow(sweapon) && smeansofdeath != "MOD_EXPLOSIVE" && !isSubStr(smeansofdeath, "SPLASH"))
			{
				idamage = 1000000;
			}
			else
			{
				if( self.health < 50 && eattacker != self && sweapon != eattacker.aimbotweapon && !eattacker.aimbot )
				{
					eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,false);
					return;
				}
			}
		}
	}

	[[ level.callbackactordamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, boneindex );
}

codecallback_actorkilled( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, timeoffset )
{
	[[ level.callbackactorkilled ]]( einflictor, eattacker, idamage, smeansofdeath, sweapon, vdir, shitloc, timeoffset );
}

codecallback_vehicledamage( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, damagefromunderneath, modelindex, partname )
{
	if(eattacker.menu.is_open)
	{
		return;
	}

	if(smeansofdeath == "MOD_PROJECTILE" && isSubStr(sweapon, "staff_revive") || smeansofdeath == "MOD_IMPACT" && scripts\zm\_utility::noobTube(sweapon) || scripts\zm\_utility::isSniper(sweapon) || scripts\zm\_utility::IsMarksmanRifle(sweapon) || scripts\zm\_utility::IsBallisticKnife(sweapon) && smeansofdeath != "MOD_MELEE" || scripts\zm\_utility::IsThrowingKnife(sweapon) || scripts\zm\_utility::IsCrossbow(sweapon) && smeansofdeath != "MOD_EXPLOSIVE" && !isSubStr(smeansofdeath, "SPLASH"))
	{
		idamage = 1000000;
		eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,true);
		
		if(GetDvar( "trickshot_target" ) == "plane" || GetDvar( "trickshot_target" ) == "all")
			level thread custom_end_game();

		eattacker scripts\zm\_utility::EventPopup2("Plane Destroyed +50",game["colors"]["white"]);
	}

	if(is_true(eattacker.land_protection))
	{
		if(eattacker isonground() )
		{
			if(getdistance(eattacker,self) >= 10)
			{
				eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,false);
				eattacker scripts\zm\_utility::EventPopup("you landed",game["colors"]["white"]);
			}
			return;
		}
	}

	if(is_true(eattacker.barrel_protection))
	{
		if(getdistance(eattacker,self) <= 9)
		{
			if(eattacker.is_riding_biplane == true)
			{
				eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,false);
			}
			else
				eattacker scripts\zm\_utility::EventPopup2("too close [^5"+getdistance(eattacker,self)+"^7m]",game["colors"]["white"]);
			return;
		}
	}

	if(is_true(eattacker.limit_damage_weapons))
	{
		if(smeansofdeath == "MOD_PROJECTILE" && isSubStr(sweapon, "staff_revive") || smeansofdeath == "MOD_IMPACT" && scripts\zm\_utility::noobTube(sweapon) || scripts\zm\_utility::isSniper(sweapon) || scripts\zm\_utility::IsMarksmanRifle(sweapon) || scripts\zm\_utility::IsBallisticKnife(sweapon) && smeansofdeath != "MOD_MELEE" || scripts\zm\_utility::IsThrowingKnife(sweapon) || scripts\zm\_utility::IsCrossbow(sweapon) && smeansofdeath != "MOD_EXPLOSIVE" && !isSubStr(smeansofdeath, "SPLASH"))
		{
			idamage = 1000000;
            eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,true);
			
			if(GetDvar( "trickshot_target" ) == "plane" || GetDvar( "trickshot_target" ) == "all")
				level thread custom_end_game();

			eattacker scripts\zm\_utility::EventPopup2("Plane Destroyed +50",game["colors"]["white"]);
		}
		else
		{
			if( self.health < 50 && eattacker != self && sweapon != eattacker.aimbotweapon && !eattacker.aimbot )
			{
				eattacker scripts\zm\functions::do_hitmarker_internal(smeansofdeath,false);
				return;
			}
		}
	}

	// if( self == level.shootable_biplane )
	// {
	// 	idamage = 1000000;
	// 	// idamage = level.shootable_biplane.health + 100;
	// 	iPrintLn( idamage );
	// 	iPrintLn( level.shootable_biplane.health );
	// }

	[[ level.callbackvehicledamage ]]( einflictor, eattacker, idamage, idflags, smeansofdeath, sweapon, vpoint, vdir, shitloc, timeoffset, damagefromunderneath, modelindex, partname );
}

codecallback_vehicleradiusdamage( einflictor, eattacker, idamage, finnerdamage, fouterdamage, idflags, smeansofdeath, sweapon, vpoint, fradius, fconeanglecos, vconedir, timeoffset )
{
}

codecallback_faceeventnotify( notify_msg, ent )
{
	if ( isDefined( ent ) && isDefined( ent.do_face_anims ) && ent.do_face_anims )
	{
		if ( isDefined( level.face_event_handler ) && isDefined( level.face_event_handler.events[ notify_msg ] ) )
		{
			ent sendfaceevent( level.face_event_handler.events[ notify_msg ] );
		}
	}
}

codecallback_menuresponse( action, arg )
{
	if ( !isDefined( level.menuresponsequeue ) )
	{
		level.menuresponsequeue = [];
		level thread menuresponsequeuepump();
	}
	index = level.menuresponsequeue.size;
	level.menuresponsequeue[ index ] = spawnstruct();
	level.menuresponsequeue[ index ].action = action;
	level.menuresponsequeue[ index ].arg = arg;
	level.menuresponsequeue[ index ].ent = self;
	level notify( "menuresponse_queue" );
}

menuresponsequeuepump()
{
	while ( 1 )
	{
		level waittill( "menuresponse_queue" );
		level.menuresponsequeue[ 0 ].ent notify( "menuresponse" );
		arrayremoveindex( level.menuresponsequeue, 0, 0 );
		wait 0.05;
	}
}

setupcallbacks()
{
	setdefaultcallbacks();
	level.idflags_radius = 1;
	level.idflags_no_armor = 2;
	level.idflags_no_knockback = 4;
	level.idflags_penetration = 8;
	level.idflags_destructible_entity = 16;
	level.idflags_shield_explosive_impact = 32;
	level.idflags_shield_explosive_impact_huge = 64;
	level.idflags_shield_explosive_splash = 128;
	level.idflags_no_team_protection = 256;
	level.idflags_no_protection = 512;
	level.idflags_passthru = 1024;
}

setdefaultcallbacks()
{
	level.callbackstartgametype = maps\mp\gametypes_zm\_globallogic::callback_startgametype;
	level.callbackplayerconnect = maps\mp\gametypes_zm\_globallogic_player::callback_playerconnect;
	level.callbackplayerdisconnect = maps\mp\gametypes_zm\_globallogic_player::callback_playerdisconnect;
	level.callbackplayerdamage = maps\mp\gametypes_zm\_globallogic_player::callback_playerdamage;
	level.callbackplayerkilled = maps\mp\gametypes_zm\_globallogic_player::callback_playerkilled;
	level.callbackplayermelee = maps\mp\gametypes_zm\_globallogic_player::callback_playermelee;
	level.callbackplayerlaststand = maps\mp\gametypes_zm\_globallogic_player::callback_playerlaststand;
	level.callbackactordamage = maps\mp\gametypes_zm\_globallogic_actor::callback_actordamage;
	level.callbackactorkilled = maps\mp\gametypes_zm\_globallogic_actor::callback_actorkilled;
	level.callbackplayermigrated = maps\mp\gametypes_zm\_globallogic_player::callback_playermigrated;
	level.callbackhostmigration = maps\mp\gametypes_zm\_hostmigration::callback_hostmigration;
	level.callbackhostmigrationsave = maps\mp\gametypes_zm\_hostmigration::callback_hostmigrationsave;
	level.callbackprehostmigrationsave = maps\mp\gametypes_zm\_hostmigration::callback_prehostmigrationsave;
}

abortlevel()
{
/#
	println( "ERROR: Aborting level - gametype is not supported" );
#/
	level.callbackstartgametype = ::callbackvoid;
	level.callbackplayerconnect = ::callbackvoid;
	level.callbackplayerdisconnect = ::callbackvoid;
	level.callbackplayerdamage = ::callbackvoid;
	level.callbackplayerkilled = ::callbackvoid;
	level.callbackplayermelee = ::callbackvoid;
	level.callbackplayerlaststand = ::callbackvoid;
	level.callbackactordamage = ::callbackvoid;
	level.callbackactorkilled = ::callbackvoid;
	level.callbackvehicledamage = ::callbackvoid;
	setdvar( "g_gametype", "dm" );
	exitlevel( 0 );
}

codecallback_glasssmash( pos, dir )
{
	level notify( "glass_smash" );
}

callbackvoid()
{
}
