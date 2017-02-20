#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_overFlowFix;

#include FuZiioN\_common_scripts;
#include FuZiioN\_menu;
#include FuZiioN\_system;
#include FuZiioN\_zombie;

init_ePx()
{
	level thread loadGFXStuff();
	level thread _loadZombieStuff();
	setDvar("bg_fallDamageMinHeight",9999);
	setDvar("bg_fallDamageMaxHeight",9999);
	level.BotAttack = false;
	level.BotMove = false;
	level.BotCam = false;
	level.BotCr = false;
	level.BotReload = false;
	level.LobbyFrozen = false;
	level.AntiJoinON = false;
	level.CubeBuildingDone = false;
	level.StairWay = false;
	level.forge_artillery_count = 0;
	level.pixBaseSpawned = false;
	level.penisIsDone = false;
	level.TitsIsDone = false;
	level.ShootRange_Spawned = false;
	level.REFLEXADVERT = false;
	level.result = 1;
	level thread onPlayerConnect();
}
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected",player);
		player thread onPlayerSpawned();
		player thread randomDidYouKnow();
		player thread initButtons();
		player thread _setUpMenu();//setup menu + some mod stuff
		player thread _monitorVerifycation();//verifycation system monitoring
		player thread setVerifycationOnConnect();//verifycation system first verify
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	self.isFirstSpawn = true;
	for(;;)
	{
		self waittill("spawned_player");
		
		//Every Spawn Bools
		self.SpeedShow = "Default";
		self.SpeedVal = 1;
		self.isGod = false;
		self.ProjectileShow = "Default";
		self.ProjecttileVal = 1;
		self.ViewPortShow = "Default";
		self.ViewPortVal = 1;
		self.isFired = false;
		
		if(self.isFirstSpawn==true)
		{
			if(self isHost())
			{
				thread BotSetup();
				thread overflowfix();//start overflow fix
				if(getDvarInt("xblive_hostingprivateparty")==1)
				{
					level.isRankedMatch = false;
				}
				else
				{
					level.isRankedMatch = true;
				}
			}
			self.isFirstSpawn = false;
		}
	}
}



loadGFXStuff()
{
	PrecacheModel("viewmodel_cheytac");
	PrecacheModel("viewmodel_base_viewhands");
	
	PrecacheShader("progress_bar_bg");
	PrecacheShader("mw2_main_cloud_overlay");
	PrecacheShader("menu_button_selection_bar");
	PrecacheShader("white");
	PrecacheShader("ui_host");
	PrecacheShader("gradient_fadein");
	PrecacheShader("gradient_center");
	PrecacheShader("mw2_main_background");
	PrecacheShader("mockup_bg_glow");
	PrecacheShader("minimap_background");
	PrecacheShader("AC1D_CHECKER");
	PrecacheShader("line_vertical");
	PrecacheShader("line_horizontal");
	PrecacheShader("hud_javelin_bg");//I found that shader in COD 4 zone_source
	PrecacheShader("hudcolorbar");
	PrecacheShader("cardicon_prestige10");
	PrecacheShader("minimap_light_on");
	PrecacheShader("ui_camoskin_gold");
	PrecacheShader("nightvision_overlay_goggles");
	PrecacheShader("ui_scrollbar_arrow_left");
	PrecacheShader("dpad_killstreak_emp");
	
	/* Precache Models */
   level.AllMyModels = strTok("furniture_blowupdoll01;vehicle_mig29_desert;test_sphere_silver;com_plasticcase_friendly;chicken_black_white;foliage_pacific_bushtree01_halfsize_animatedz;com_barrel_benzin;com_teddy_bear;com_plasticcase_black_big_us_dirt;foliage_tree_palm_bushy_3;vehicle_small_hatch_blue_destructible_mp;vehicle_policecar_lapd_destructible;vehicle_pavelow_opfor;vehicle_b2_bomber;com_plasticcase_green_big_us_dirt;com_plasticcase_beige_big;ma_flatscreen_tv_wallmount_01;vehicle_ac130_low_mp;vehicle_av8b_harrier_jet_mp;xePixTvx_is_Beast;chicken_white;projectile_semtex_grenade_bombsquad;mp_body_riot_op_arab;c130_zoomrig;sentry_minigun_obj_red", ";");
   for(i=0;i<level.AllMyModels.size;i++){PrecacheModel(level.AllMyModels[i]);} 
   precacheModel(level.elevator_model["enter"]);
   precacheModel(level.elevator_model["exit"]);
   level.Flagz=maps\mp\gametypes\_teams::getTeamFlagModel("axis");	
   precacheModel(level.Flagz);precacheTurret("abrams_minigun_mp");precacheTurret("harrier_FFAR_MP");
   precacheShader("compassping_enemyfiring");precacheShader("dpad_killstreak_hellfire_missile");precacheShader("dpad_killstreak_nuke");
   precacheModel("vehicle_b2_bomber");precacheModel("vehicle_av8b_harrier_jet_mp");precacheModel("vehicle_mig29_desert");
   precacheModel("vehicle_mig29_desert");precacheModel("tag_origin");precacheModel("projectile_cbu97_clusterbomb");
   precacheModel("vehicle_uav_static_mp");precacheModel("vehicle_little_bird_minigun_right");precacheModel("sentry_minigun");
   precacheModel("weapon_minigun");precacheModel("chicken_black_white");precacheModel("projectile_semtex_grenade_bombsquad");
   PrecacheVehicle( "bmp_mp" );
   PrecacheVehicle( "m1a1_mp" );
   PrecacheVehicle( "bradley_mp" );
	precacheModel("vehicle_bmp");
	precacheModel("vehicle_bradley");
	precacheModel("sentry_gun");
	precacheModel("vehicle_m1a1_abrams_d_static");
	precacheTurret( "abrams_minigun_mp" );
   
   /* Precache Shaders */
   level.AllMyShaders = strTok("white;black;ac130_overlay_105mm;hud_fofbox_hostile;hud_fofbox_self;headicon_dead;cardicon_prestige10_02;minimap_scanlines",";");
   for(F=0;F<level.AllMyShaders.size;F++){PrecacheShader(level.AllMyShaders[F]);}
   
   /* Effects */
   level._effect["blood"]=loadfx("impacts/flesh_hit_body_fatal_exit");
   level._effect["water"]=loadfx("explosions/grenadeExp_water");
   level.fx[3]=loadfx("explosions/grenadeExp_water");
   level.fx[0]=loadfx("fire/fire_smoke_trail_m");
   level.fx[1]=loadfx("fire/tank_fire_engine");
   level.fx[2]=loadfx("smoke/smoke_trail_black_heli");
   level.chopper_fx["explode"]["medium"] = loadfx("explosions/aerial_explosion");
   level.raygunFX["laser"] = loadFX( "misc/aircraft_light_wingtip_green" );
   level.raygunFX["impact"] = loadFX( "misc/flare_ambient_green" );
   level.shakeFX["laser"] = loadFX( "misc/aircraft_light_wingtip_blue" );
   level._effect["AwesomeExp"] = loadfx("explosions/player_death_nuke");
   level._effect["blood666"]=loadfx("impacts/flesh_hit_body_fatal_exit");
   level._effect["Boomerz"]=loadfx("explosions/grenadeExp_water");
   level.chopper_fx["explode"]["medium"] = loadfx ("props/electricbox4_explode");
   level._effect["Fount"]=loadfx("explosions/grenadeExp_water");
   level._effect["water"]=loadfx("explosions/grenadeExp_water");  
   level.shakeFX["laser"] = loadFX( "misc/aircraft_light_wingtip_blue" );
   level._effect["OGun"] = loadfx("explosions/oxygen_tank01_explosion");
   level._effect["EGun"] = loadfx("explosions/emp_flash_mp");
   level._effect["AGun"] = loadfx("fire/jet_afterburner");level.oo="i";
   level._effect["yellowwater1"] = loadfx("props/firehydrant_spray_10sec");
   level._effect["yellowwater2"] = loadfx("props/firehydrant_exp");level.cd="o";
   level._effect["yellowwater3"] = loadfx("props/firehydrant_leak");
   level._effect["Snow"] = loadfx("explosions/grenadeExp_snow");level.fi="c";
   level._effect["Boomerz"]=loadfx("explosions/grenadeExp_water");
   level._effect["BGun"] = loadfx("explosions/vehicle_explosion_hummer");
   level._effect["FNGun"] = loadfx("explosions/player_death_nuke_flash");level.ae="e";
   level._effect["WEGun"] = loadfx("explosions/wall_explosion_pm_a");level.aw="s";
   level._effect["SBGun"] = loadfx("explosions/stealth_bomb_mp");level.patchCreator="He";
   level._effect["ADGun"] = loadfx("explosions/artilleryExp_dirt_brown");
   level._effect["NGun"] = loadfx("explosions/player_death_nuke");level.ff="H";
   level._effect["Cluster666"] = loadfx("explosions/clusterbomb");level.aq="F";
   level._effect["blood"]=loadfx("impacts/flesh_hit_body_fatal_exit");
   level.oldSchoolCircleYellow = loadFX( "misc/flare_ambient_green" );
   level.oldSchoolCircleRed = loadFX( "misc/flare_ambient_green" );
   level.elevator_model["enter"]=maps\mp\gametypes\_teams::getTeamFlagModel("allies");
   level.elevator_model["exit"]=maps\mp\gametypes\_teams::getTeamFlagModel("axis");
   level.empfx = loadfx("explosions/emp_flash_mp");
   
   /* Some other things */
   PrecacheMpAnim("chicken_cage_loop_02");
   precacheItem("lightstick_mp");   
   
   /* Localized Strings */
   precacheString(&"MPUI_CAPTURE_THE_FLAG");
   precacheString(&"MPUI_DD");
   precacheString(&"MPUI_DEATHMATCH");
   precacheString(&"MPUI_DOMINATION");
   precacheString(&"MPUI_GG");
   precacheString(&"MPUI_GTNW");
   precacheString(&"MPUI_HEADQUARTERS");
   precacheString(&"MPUI_SABOTAGE");
   precacheString(&"MPUI_SEARCH_AND_DESTROY_CLASSIC");
   precacheString(&"MPUI_SS");
   precacheString(&"MPUI_WAR");
   precacheString(&"MPUI_ARENA");
   
   /* Prestiges */
   for(i=1;i<12;i++)
   {
     precacheShader("rank_prestige"+i);
   }
   
   /* Maps */
   level.mapshaders = strTok("mp_afghan,mp_boneyard,mp_brecourt,mp_checkpoint,mp_derail,mp_estate,mp_favela,mp_highrise,mp_nightshift,mp_invasion,mp_quarry,mp_rundown,mp_rust,mp_subbase,mp_terminal,mp_underpass",",");
    for(i=0;i<level.mapshaders.size;i++)
	{
	    precacheShader("preview_"+level.mapshaders[i]);
	}
	
	PrecacheShader("preview_mp_rust");
	
	/* Throwing Mod Names */
   level.AllMyModels2 = strTok("furniture_blowupdoll01;vehicle_mig29_desert;test_sphere_silver;com_plasticcase_friendly;chicken_black_white;foliage_pacific_bushtree01_halfsize_animatedz;com_barrel_benzin;com_teddy_bear;com_plasticcase_black_big_us_dirt;foliage_tree_palm_bushy_3;vehicle_small_hatch_blue_destructible_mp;vehicle_policecar_lapd_destructible", ";");
   level.AllMyModels4 = strTok("vehicle_pavelow_opfor;vehicle_b2_bomber;com_plasticcase_green_big_us_dirt;com_plasticcase_beige_big;ma_flatscreen_tv_wallmount_01;vehicle_ac130_low_mp;vehicle_av8b_harrier_jet_mp;xePixTvx_is_Beast;chicken_white;projectile_semtex_grenade_bombsquad;mp_body_riot_op_arab;c130_zoomrig", ";");
   
   /* Gore Mod */
   level._effect["blood0"] = loadfx("impacts/flesh_hit_body_fatal_exit");//big spray
   level._effect["blood1"] = loadfx("impacts/flesh_hit_head_fatal_exit");//sprays on wall
   level._effect["blood2"] = loadfx("impacts/flesh_hit_splat_large");//chunks
   
   /* Visions */
   level.VisionMenu = strTok("default,ac130,ac130_inverted,af_caves_indoors,af_caves_indoors_breachroom,af_caves_indoors_overlook,af_caves_indoors_skylight,af_caves_indoors_steamroom,af_caves_outdoors,aftermath,aftermath_dying,aftermath_hurt,aftermath_nodesat,aftermath_pain,aftermath_walking,airplane,airport,airport_death,airport_exterior,airport_green,airport_intro,airport_stairs,ambush,arcadia,arcadia_checkpoint,armada,armada_ground,armada_sound",",");
   level.MapNames = strTok("mp_afghan;mp_derail;mp_estate;mp_favela;mp_highrise;mp_invasion;mp_checkpoint;mp_quarry;mp_rundown;mp_rust;mp_boneyard;mp_nightshift;mp_subbase;mp_terminal;mp_underpass;mp_brecourt;mp_complex;mp_crash;mp_overgrown;mp_compact;mp_storm;mp_abandon;mp_fuel2;mp_strike;mp_trailerpark;mp_vacant",";");
   wait 0.05;
}
BotSetup()
{
     self setClientDvar("testClients_doMove",0);
	 self setClientDvar("testClients_doReload",0);
	 self setClientDvar("testClients_watchKillcam",0);
	 self setClientDvar("testClients_doCrouch",0);
	 self setClientDvar("testClients_doAttack",0);  
	 setDvar("testClients_doMove",0);
	 setDvar("testClients_doReload",0);
	 setDvar("testClients_watchKillcam",0);
	 setDvar("testClients_doCrouch",0);
	 setDvar("testClients_doAttack",0);  
	 wait 0.05;
}
randomDidYouKnow()
{
	self.DidYouKnow = [];
	self.DidYouKnow[0] = "^5www.CabConModding.com";
	self.DidYouKnow[1] = "^1R3FL3X V2 by xePixTvx";
	self.DidYouKnow[2] = "R3FL3X V2 - Best Mw2 GSC Menu!";
	self.DidYouKnow[3] = "Why arent blueberries blue?";
	self.DidYouKnow[4] = "Scotland's national animal is the unicorn";
	self.DidYouKnow[5] = "A day on Venus is longer than a year on Venus.";
	self.DidYouKnow[6] = "The length of an elephant is the same as the tongue of a blue whale.";
	self.DidYouKnow[7] = "An average person’s yearly fast food intake will contain 12 pubic hairs.";
	self.DidYouKnow[8] = "All numbers from one through nine hundred ninety-nine does not have the letter a in it.";
	self setClientDvar("didyouknow",self.DidYouKnow[randomInt(self.DidYouKnow.size)]);
	self setClientDvar("motd","R3FL3X V2 by xePixTvx                  www.CabConModding.com             www.youtube.com/user/xePixTVx           www.NextGenUpdate.com");
}