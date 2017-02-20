#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_overFlowFix;

#include FuZiioN\_common_scripts;
#include FuZiioN\_menu;
#include FuZiioN\_main;
#include FuZiioN\_system;
#using_animtree("multiplayer");

lvl70(client)
{
    client setPlayerData("experience",2516000);
	client thread maps\mp\gametypes\_rank::scorePopup(10,2515990,(1,1,1),0);
	client maps\mp\gametypes\_hud_message::oldNotifyMessage("Ranked Up To","LvL 70","rank_prestige0",(0,0,0),"mp_level_up",7);
}
UnlockAll( player )
{
	player endon("disconnect");
	//player freezeControls(true);
	player thread progressBar(25,"Unlocking All...",(0,1,1));
	player setPlayerData("iconUnlocked","cardicon_prestige10_02",1);
	foreach(challengeRef,challengeData in level.challengeInfo)
	{
		finalTarget = 0;
		finalTier = 0;

		for( tierId = 1; isDefined( challengeData[ "targetval" ][ tierId ] ); tierId++ )
		{
			finalTarget = challengeData[ "targetval" ][ tierId ];
			finalTier = tierId+1;
		}
		if( player isItemUnlocked( challengeRef ) )
		{
			player setPlayerData( "challengeProgress", challengeRef, finalTarget );
			player setPlayerData( "challengeState", challengeRef, finalTier );
			player iprintln("^"+randomInt(9)+challengeRef+" Done");
		}
		wait ( 0.04 );
	}
}
ToggleGodmode()
{
	if(!self.isGod)
	{
		self.isGod = true;
		self thread doGodmode();
	}
	else
	{
		self.isGod = false;
		self notify("God_End");
		self suicide();
	}
}
doGodmode()
{
	self endon("God_End");
	self endon("death");
	self.maxHealth = 99999;
	self.health = self.maxHealth;
	while(self.isGod==true)
    {
        if(self.health<self.maxhealth)
		{
            self.health = self.maxhealth;
		}
		wait 0.05;
    }
}
ToggleUnlmAmmo()
{
	if(!self.NoAmmoProb)
	{
		if(self.FullAuto==true)
		{
			self.FullAuto = false;
			self setclientDvar("perk_weapReloadMultiplier",0.5);
			self notify("Kill_FullAuto");
		}
		self.NoAmmoProb = true;
		self thread infinite_ammo();
	}
	else
	{
		self.NoAmmoProb = false;
		self notify("noinf");
	}
}
infinite_ammo()
{
	self endon("noinf");
	for(;;)
	{
		currentWeapon = self getCurrentWeapon();
		if(currentWeapon!="none")
		{
			if(isSubStr(self getCurrentWeapon(),"_akimbo_"))
			{
				self setWeaponAmmoClip(currentweapon,9999,"left");
				self setWeaponAmmoClip(currentweapon,9999,"right");
			}
			else
			{
				self setWeaponAmmoClip(currentWeapon,9999);
			}
			self GiveMaxAmmo(currentWeapon);
		}
 
		currentoffhand = self GetCurrentOffhand();
		if(currentoffhand!="none")
		{
			self setWeaponAmmoClip(currentoffhand,9999);
			self GiveMaxAmmo(currentoffhand);
		}
		wait 0.05;
	}
}
ToggleFullAutoWeps()
{
	if(!self.FullAuto)
	{
		if(self.NoAmmoProb==true)
		{
			self.NoAmmoProb = false;
			self notify("noinf");
		}
		self.FullAuto = true;
		self thread maps\mp\perks\_perks::givePerk("specialty_fastreload");
		self setclientDvar("perk_weapReloadMultiplier",0.01);
		self iprintln("^1Press [{+reload}]/[{+usereload}] and [{+attack}]");
		self thread FullAutoAmmo();
	}
	else
	{
		self.FullAuto = false;
		self setclientDvar("perk_weapReloadMultiplier",0.5);
		self notify("Kill_FullAuto");
	}
}
FullAutoAmmo()
{
    self endon("Kill_FullAuto");
    for(;;)
    {
       currentWeapon=self getCurrentWeapon();
       currentoffhand=self GetCurrentOffhand();
       self GiveMaxAmmo(currentWeapon);
	   self GiveMaxAmmo(currentoffhand);
	   wait 0.01;
    }
	waitframe();
}
ToggleInvisible()
{
	if(!self.CantSeeMe)
	{
		self.CantSeeMe = true;
		self hide();
	}
	else
	{
		self.CantSeeMe = false;
		self show();
	}
}
toggleSaveNLoadShit()
{
	if(!self.SaveNLoad)
	{
		self thread doSaveandLoad();
		self iprintln("Press [{+melee}] to Save or Load Pos!");
		self iprintlnbold("Save and Load[^2ON^7]");
		self.SaveNLoad=true;
	}
	else
	{
		self notify("SaveandLoad");
		self iprintlnbold("Save and Load[^1OFF^7]");
		self.SaveNLoad=false;
	}
}
doSaveandLoad()
{
	self endon("disconnect");
	self endon("SaveandLoad");
	Load=0;
	for(;;)
	{
		if(self MeleeButtonPressed()&& Load==0)
		{
			self.O=self.origin;
			self.A=self.angles;
			self iPrintln("^2Position Saved");
			Load=1;
			wait 2;
		}
		if(self MeleeButtonPressed()&& Load==1)
		{
			self setPlayerAngles(self.A);
			self setOrigin(self.O);
			self iPrintln("^2Position Loaded");
			Load=0;
			wait 2;
		}
		wait .05;
	}
}
CloneMe()
{
	self ClonePlayer(99999);
	self iprintln("^1Cloned");
}
CloneDeadMe()
{
   xD = self ClonePlayer (99999999);
   xD startRagDoll();
}
doTeleport()
{
	self _menuResponse("openNclose","close");
	wait .2;
	self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
    self.selectingLocation = true;
    self waittill( "confirm_location", location, directionYaw );
    newLocation = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
    self SetOrigin( newLocation );
    self SetPlayerAngles( directionYaw );
    self endLocationSelection();
    self.selectingLocation = undefined;
	self.FuZiioN["Menu"]["Type"] = "menu";
	self thread FuZiioN\_menu::_menuMainMonitor();
	wait 0.05;
	self notify("Menu_Is_Opened");
	wait .2;
}
sendToSpace(p)
{
	p endon("disconnect");
	p iPrintln("Lost In Space!");
	x=randomIntRange(-75,75);
	y=randomIntRange(-75,75);
	z=45;
	p.location =(0+x,0+y,500000+z);
	p.angle =(0,176,0);
	p setOrigin(p.location);
	p setPlayerAngles(p.angle);
}
specNading()
{
	if(self.toggleSN == false)
	{
		self.toggleSN = true;
		self iprintln("Spec Nade ^2Enabled");
		self thread specNading1();
	}
	else
	{
		self.toggleSN = false;
		self notify("stop");
		self iprintln("Spec Nade ^1Disabled");
	}
}
specNading1()
{
	self endon("disconnect");
	self endon("death");
	self endon("stop");
	for(;;)
	{
		self waittill("grenade_fire",grenadeWeapon,weapname);
		if(weapname=="concussion_grenade_mp"||weapname=="frag_grenade_mp"||weapname=="flash_grenade_mp"||weapname=="smoke_grenade_mp")
		{
			self _disableWeapon();
			self _disableOffhandWeapons();
			self freezeControls(true);
			origmh=self.maxhealth;
			self.maxhealth=999999999;
			self.health=self.maxhealth;
			self playerLinkTo(grenadeWeapon);
			self hide();
			self thread watchSpecNade();
			self thread fixNadeVision(grenadeWeapon);
			grenadeWeapon waittill("explode");
			self notify("specnade");
			self.maxhealth=origmh;
			self.health=self.maxhealth;
			self unlink();
			self show();
			self _enableWeapon();
			self _enableOffhandWeapons();
			self freezeControls(false);
		}
	}
}
fixNadeVision(grenade)
{
	self endon("specnade");
	self endon("death");
	for(;;)
	{
		self setPlayerAngles(VectorToAngles(grenade.origin - self.origin));
		wait .01;
	}
}
watchSpecNade()
{
	self setClientDvar("cg_drawgun",0);
	self setClientDvar("cg_fov",80);
	self waittill_any("death","specnade");
	self setClientDvar("cg_drawgun",1);
	self setClientDvar("cg_fov",65);
}
ToggleFlashingPlayer()
{
	if(!self.FlashyDude)
	{
		self.FlashyDude=true;
		self iprintlnbold("Flashy Dude[^2ON^7]");
		self thread doFlashyDude();
	}
	else
	{
		self.FlashyDude=false;
		self iprintlnbold("Flashy Dude[^1OFF^7]");
		self notify("end_flashPlayer");
		self show();
	}
}
doFlashyDude()
{
	self endon("end_flashPlayer");
	for(;;)
	{
		self hide();
		wait .1;
		self show();
		self iprintln("^"+randomInt(9)+" You are Flashing!");
		wait 0.05;
	}
	wait 0.05;
}
ToggleThirdPerson()
{
	if(!self.ThirdPersonView)
	{
		self.ThirdPersonView = true;
		self setClientDvar("cg_thirdperson",1);
	}
	else
	{
		self setClientDvar("cg_thirdperson",0);
		self.ThirdPersonView = false;
	}
}
ToggleFOFoverlay()
{
	if(!self.RedBox)
	{
		self.RedBox = true;
		self ThermalVisionFOFOverlayOn();
	}
	else
	{
		self.RedBox = false;
		self ThermalVisionFOFOverlayOff();
	}
}
ToggleLaserLight()
{
	if(!self.LaserLight)
	{
		self.LaserLight = true;
		self iPrintln("Laser ^2ON");
		self setClientDvar("laserForceOn",1);
	}
	else
	{
		self.LaserLight = false;
		self iPrintln("Laser ^1OFF");
		self setClientDvar("laserForceOn",0);
	}
}
ToggleRadarHack()
{
	if(!self.RadarHack)
	{
		self.RadarHack = true;
		self setclientDvar("g_compassshowenemies",1);
	}
	else
	{
		self.RadarHack = false;
		self setclientDvar("g_compassshowenemies",0);
	}
}
ToggleUfo()
{
	if(!self.UfoMode)
	{
		self.UfoMode=true;
		self thread toggleufoMode();
	}
	else
	{
		self.UfoMode=false;
		self notify("UfoMode_End");
		if(isdefined(self.newufo))
		{
			self.newufo delete();
		}
	}
}
toggleufoMode()
{
	self endon("UfoMode_End");
	if(isdefined(self.newufo))
	{
		self.newufo delete();
	}
	self iPrintln("^1Press [{+activate}] + [{+melee}] to toggle Ufo/NoClip\n[{+frag}]/[{+smoke}] - Fast/Slow Moving");
	self.newufo=spawn("script_origin",self.origin);
	self.UfoOn=0;
	for(;;)
	{
		if(self usebuttonpressed()&& self meleeButtonPressed())
		{
			if(self.UfoOn==0)
			{
				self iPrintln("Noclip/Ufo ON");
				self.UfoOn=1;
				self.newufo.origin=self.origin;
				self playerlinkto(self.newufo);
			}
			else
			{
				self iPrintln("Noclip/Ufo OFF");
				self.UfoOn=0;
				self unlink();
			}
			wait 0.5;
		}
		if(self.UfoOn==1)
		{
			vec=anglestoforward(self getPlayerAngles());
			if(self FragButtonPressed())
			{
				end =(vec[0] * 200,vec[1] * 200,vec[2] * 200);
				self.newufo.origin=self.newufo.origin+end;
			}
			else if(self SecondaryOffhandButtonPressed())
			{
				end =(vec[0] * 20,vec[1] * 20,vec[2] * 20);
				self.newufo.origin=self.newufo.origin+end;
			}
		}
		wait 0.05;
	}
	wait .2;
}
doJetPack()
{
	if(self.jetpack==false)
	{
		self thread StartJetPack();
		self iPrintln("JetPack [^2ON^7]");
		self iPrintln("Press [{+use_button}] foruse jetpack");
		self.jetpack=true;
	}
	else if(self.jetpack==true)
	{
		self.jetpack=false;
		self notify("jetpack_off");
		self iPrintln("JetPack [^1OFF^7]");
	}
}
StartJetPack()
{
	self endon("jetpack_off");
	self.jetboots= 100;
	for(i=0;;i++)
	{
		if(self usebuttonpressed() && self.jetboots>0)
		{
			//playFX(level._effect["lght_marker_flare"],self getTagOrigin("J_Ankle_RI"));
			//playFx(level._effect["lght_marker_flare"],self getTagOrigin("J_Ankle_LE"));
			earthquake(.15,.2,self gettagorigin("j_spine4"),50);
			self.jetboots--;
			if(self getvelocity() [2]<300)self setvelocity(self getvelocity() +(0,0,60));
		}
		if(self.jetboots<100 &&!self usebuttonpressed())self.jetboots++;
		wait .05;
	}
}
ToggleFountain(inp)
{
	switch(inp)
	{
		case "money":
			if(!self.MoneyFountain)
			{
				self.MoneyFountain = true;
				self setClientDvar("cg_thirdperson",1);
				self thread BleedMoney();
			}
			else
			{
				self.MoneyFountain = false;
				self setClientDvar("cg_thirdperson",0);
				self notify("KillFountain");
			}
		break;
		
		case "blood":
			if(!self.BloodFountain)
			{
				self.BloodFountain = true;
				self setClientDvar("cg_thirdperson",1);
				self thread BloodFountain();
			}
			else
			{
				self.BloodFountain = false;
				self setClientDvar("cg_thirdperson",0);
				self notify("KillFountain");
			}
		break;
		
		case "water":
			if(!self.WaterFountain)
			{
				self.WaterFountain = true;
				self setClientDvar("cg_thirdperson",1);
				self thread WaterFountain();
			}
			else
			{
				self.WaterFountain = false;
				self setClientDvar("cg_thirdperson",0);
				self notify("KillFountain");
			}
		break;
	}
}
BleedMoney()
{
	self endon("KillFountain");
	while(1)
	{
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		playFx(level._effect["money"],self getTagOrigin("j_spine4"));
		wait .001;
	}
}
BloodFountain()
{
    self endon("KillFountain");
	while(1)
	{
		playFx(level._effect["blood"],self getTagOrigin("j_spine4"));
		wait .001;
	}
	wait .001;
}
WaterFountain()
{
    self endon("KillFountain");
	while(1)
	{
		playfx(level._effect["water"],self getTagOrigin("j_spine4"));
		wait .001;
	}
	wait .001;
}
humanPed()
{
    self endon("disconnect");
    self endon("death");
	self iprintln("^1Kill yourself to stop it :)");
    for(;;)
    {
	    self setClientDvar("cg_thirdPerson", 1);
		self iPrintln("^1Human Caterpiller");
		while(1)
        {
		    self cloneplayer(9999999);
			wait .0001;
		}
    } 
    wait .01; 
}
ToggleAutoTBag()
{
    if(!self.AutoBag)
	{
	    self.AutoBag = true;
		self thread TBag();
	}
	else
	{
	    self.AutoBag = false;
		self notify("NoTea");
	}
}
TBag()
{
	self endon("disconnect");
	//self endon("death");
	self endon("NoTea");
	for (;;)
	{
		self setstance("stand");
		wait (0.5);
		self setstance("crouch");
		wait (0.5);
	}
}
SingleSpeedChanger()
{
	self.SpeedVal ++;
	if(self.SpeedVal>8)
	{
		self.SpeedVal = 1;
	}
	if(self.SpeedVal==1)
	{
		self.SpeedShow = "Default";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	if(self.SpeedVal==2)
	{
		self.SpeedShow = "x2";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	if(self.SpeedVal==3)
	{
		self.SpeedShow = "x3";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	if(self.SpeedVal==4)
	{
		self.SpeedShow = "x4";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	if(self.SpeedVal==5)
	{
		self.SpeedShow = "x5";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	if(self.SpeedVal==6)
	{
		self.SpeedShow = "x6";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	if(self.SpeedVal==7)
	{
		self.SpeedShow = "x7";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	if(self.SpeedVal==8)
	{
		self.SpeedShow = "x8";
		self SetMoveSpeedScale(self.SpeedVal);
	}
	self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
}
ChangeMap(mapr)
{
	self iPrintlnBold("Changing map to: "+mapr);
	setDvar("mapname",mapr);
	setDvar("ui_mapname",mapr);
	setDvar("party_mapname",mapr);
	wait 3;
	map(mapr);
}
ChangeGametype(gametype)
{
	setDvar("g_gametype",gametype);
	map_restart(false);
}
ModelFuncs(Model)
{
	schwanz = Model;
	fotzen = self;
	if( schwanz == "Normal" )
	{
		fotzen thread SetSelfNormal();
	}
	else if( schwanz == "Care Package" )
	{
		fotzen thread SetSelfModel("com_plasticcase_friendly",5);
	}
	else if( schwanz == "UAV Plane" )
	{
		fotzen thread SetSelfModel("vehicle_uav_static_mp",0);
	}
	else if( schwanz == "Sentry Gun" )
	{
		fotzen thread SetSelfModel("sentry_minigun",5);
	}
	else if( schwanz == "Little Bird" )
	{
		fotzen thread SetSelfModel("vehicle_little_bird_armed",5);
	}
	else if( schwanz == "Dev Sphere" )
	{
		fotzen thread SetSelfModel("test_sphere_silver",5);
	}
	else if( schwanz == "AC-130" )
	{
		fotzen thread SetSelfModel("vehicle_ac130_low_mp",5);
	}
	else if( schwanz == "Chicken" )
	{
		fotzen thread SetSelfModel("chicken_black_white",5);
	}
	else if( schwanz == "Teddy")
	{
		fotzen thread SetSelfModel("com_teddy_bear",5);
	}
	else if( schwanz == "Sex Doll" )
	{
		fotzen thread SetSelfModel("furniture_blowupdoll01",5);
	}
	else if( schwanz == "Benzin Barrel" )
	{
		fotzen thread SetSelfModel("com_barrel_benzin",5);
	}
	else if( schwanz == "Green Bush" )
	{
		fotzen thread SetSelfModel("foliage_pacific_bushtree01_halfsize_animatedz",5);
	}
	else if( schwanz == "Ammo Crate" )
	{
		fotzen thread SetSelfModel("com_plasticcase_black_big_us_dirt",5);
	}
	else if( schwanz == "Palm Tree" )
	{
		fotzen thread SetSelfModel("foliage_tree_palm_bushy_3",5);
	}
	else if( schwanz == "Blue Car" )
	{
		fotzen thread SetSelfModel("vehicle_small_hatch_blue_destructible_mp",5);
	}
	else if( schwanz == "Police Car" )
	{
		fotzen thread SetSelfModel("vehicle_policecar_lapd_destructible",5);
	}
	else if( schwanz == "Laptop" )
	{
		fotzen thread SetSelfModel("com_laptop_2_open",5);
	}
}
SetSelfModel(model,offset)
{
	carryon=1;
	if(model=="furniture_blowupdoll01")
	{
		if(!self CheckDollMap())
		{
			carryon=0;
		}
	}
	if(carryon==1)
	{
		self notify("StopModel");
		if(isDefined(self.WCM))self.WCM delete();
		self.WCM=spawn("script_model",self.origin);
		self.WCM setModel(model);
		if(model=="furniture_blowupdoll01")self.IsDoll=1;
		else self.IsDoll=0;
		self hide();
		self setClientDvar("camera_thirdPerson",1);
		self setClientDvar("cg_thirdPerson",1);
		self setClientDvar("scr_thirdPerson",1);
		self setClientDvar("cg_thirdPersonRange",200);
		self.moveSpeedScaler=2;
		self setMoveSpeedScale(self.moveSpeedScaler);
		self thread ObjectMonitor(offset);
	}
}
CheckDollMap()
{
	switch(getDvar("mapname"))
	{
		case "mp_afghan":case "mp_terminal":case "mp_quarry":case "mp_compact":case "mp_trailerpark":case "mp_vacant":case "mp_estate":return true;
		default:return false;
	}
}
ObjectMonitor(OffsetFromGround)
{
	self endon("disconnect");
	self endon("death");
	self endon("StopModel");
	for(;;)
	{
		if(self.IsDoll==1)self.WCM RotateTo(self getPlayerAngles()+(0,90,0),0.1);
		else self.WCM RotateTo(self getPlayerAngles(),0.1);
		wait 0.05;
		self.WCM MoveTo(self.origin+(0,0,OffsetFromGround),0.1);
		wait 0.05;
	}
}
SetSelfNormal()
{
	self notify("StopModel");
	if(isDefined(self.WCM))self.WCM delete();
	self.WCM=undefined;
	self.IsDoll=0;
	self show();
	self setClientDvar("camera_thirdPerson",0);
	self setClientDvar("cg_thirdPerson",0);
	self setClientDvar("scr_thirdPerson",0);
	self.moveSpeedScaler=1;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale("primary");
}
RandomApper()
{
  i = randomint(2);
  if(i==0)
  {
     self ChangeApperFriendly(randomint(7));
  }
  else
  {
     self ChangeApperEnemy(randomint(7));
  }   
}
ChangeApperFriendly(T)
{
  M=[];
  M[0]="GHILLIE";
  M[1]="SNIPER";
  M[2]="LMG";
  M[3]="ASSAULT";
  M[4]="SHOTGUN";
  M[5]="SMG";
  M[6]="RIOT";
  self iprintln("^1Appearance : Friendly "+M[T]);
  team=get_enemy_team(self.team);
  self detachAll();
  [[game[team+"_model"][M[T]]]]();
  [[game[team+"_model"]["GHILLIE"[0]]]]();
}
ChangeApperEnemy(T)
{
  M=[];
  M[0]="GHILLIE";
  M[1]="SNIPER";
  M[2]="LMG";
  M[3]="ASSAULT";
  M[4]="SHOTGUN";
  M[5]="SMG";
  M[6]="RIOT";
  self iprintln("^1Appearance : Enemy "+M[T]);
  team=self.team;
  self detachAll();
  [[game[team+"_model"][M[T]]]]();
} 
nukeBullet()
{
	self endon("disconnect");
	self endon("death");
	self iPrintln("^3Nuke Bullet Ready");
	for(;;)
	{
		self waittill("weapon_fired");
		if(level.teambased)thread teamPlayerCardSplash("used_nuke",self,self.team);
		else self iprintlnbold(&"MP_FRIENDLY_TACTICAL_NUKE");
		wait 1;
		me2=self;
		level thread funcNukeSoundIncoming_bullet();
		level thread funcNukeEffects_bullet(me2);
		level thread funcNukeSlowMo_bullet();
		wait 1.5;
		foreach(player in level.players)
		{
			if(player.name!=me2.name)if(isAlive(player))player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(me2,me2,999999,0,"MOD_EXPLOSIVE","nuke_mp",player.origin,player.origin,"none",0,0);
		}
		wait .1;
		level notify("done_nuke2");
		self suicide();
	}
}
funcNukeSlowMo_bullet()
{
	level endon("done_nuke2");
	setSlowMotion(1.0,0.25,0.5);
}
funcNukeEffects_bullet(me2)
{
	level endon("done_nuke2");
	foreach(player in level.players)
	{
		player thread FixSlowMo_bullet(player);
		playerForward=anglestoforward(player.angles);
		playerForward =(playerForward[0],playerForward[1],0);
		playerForward=VectorNormalize(playerForward);
		nukeDistance=100;
		nukeEnt=Spawn("script_model",player.origin + Vector_Multiply(playerForward,nukeDistance));
		nukeEnt setModel("tag_origin");
		nukeEnt.angles =(0,(player.angles[1] + 180),90);
		nukeEnt thread funcNukeEffect_bullet(player);
		player.nuked=true;
	}
}
FixSlowMo_bullet(player)
{
	player endon("disconnect");
	player waittill("death");
	setSlowMotion(0.25,1,2.0);
}
funcNukeEffect_bullet(player)
{
	player endon("death");
	waitframe();
	PlayFXOnTagForClients(level._effect["nuke_flash"],self,"tag_origin",player);
}
funcNukeSoundIncoming_bullet()
{
	level endon("done_nuke2");
	foreach(player in level.players)
	{
		player playlocalsound("nuke_incoming");
		player playlocalsound("nuke_explosion");
		player playlocalsound("nuke_wave");
	}
}
ToggleForceField()
{
	if(!self.ForceField)
	{
		self.ForceField = true;
		self iprintlnbold("Forcefield of Death[^2ON^7]");
		self thread doThaForceField();
	}
	else
	{
		self.ForceField = false;
		self iprintlnbold("Forcefield of Death[^1OFF^7]");
		self notify("ForceField_End_xePixTvx");
	}
}
doThaForceField()
{
	self endon("ForceField_End_xePixTvx");
	for(;;)
	{
		Enemy=level.players;
		for(i=0;i<Enemy.size;i++)
		{
			if(Enemy[i]!=self)
			{
				if(Distance(Enemy[i].origin,self.origin)<=200)
				{
					Enemy[i] thread [[level.callbackPlayerDamage]](self,self,100,0,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0,0);
				}
			}
		}
		wait 0.05;
	}
	wait 0.05;
}
initBallthing()
{
	if(!self.blueballs)
	{
		self thread ballThing();
		self.blueballs=true;
	}
	else
	{
		self.blueballs=false;
		self notify("forceend");
		self detachall();
	}
}
ballThing()
{
	self endon("disconnect");
	//self endon("death");
	self endon("forceend");
	ball=spawn("script_model",self.origin +(0,0,20));
	ball setModel("test_sphere_silver");
	ball.angles =(0,115,0);
	self thread monBall(ball);
	self thread monPlyr();
	self thread DOD(ball);
	for(;;)
	{
		ball rotateyaw(-360,2);
		wait 1;
	}
}
monBall(obj)
{
	self endon("death");
	self endon("forceend");
	while(1)
	{
		obj.origin=self.origin +(0,0,120);
		wait 0.05;
	}
}
monPlyr()
{
	self endon("death");
	self endon("forceend");
	while(1)
	{
		foreach(p in level.players)
		{
			if(distance(self.origin,p.origin)<= 200)
			{
				AtF=AnglesToForward(self getPlayerAngles());
				if(p!=self)p setVelocity(p getVelocity()+(AtF[0]*(300*(2)),AtF[1]*(300*(2)),(AtF[2]+0.25)*(300*(2))));
			}
		}
		wait 0.05;
	}
}
DOD(ent)
{
	self waittill("forceend");
	ent delete();
}
earthquakee()
{
	earthquake(1.5,1,self.origin,1000);
	earthquake(1.5,1,self.origin,1000);
	earthquake(1.5,1,self.origin,1000);
	earthquake(1.5,1,self.origin,1000);
	earthquake(1.5,1,self.origin,1000);
	earthquake(1.5,1,self.origin,1000);
}
ToggleExpBullets()
{
	if(!self.ExpBullets)
	{
		self.ExpBullets = true;
		self thread ExplosiveBullets();
	}
	else
	{
		self.ExpBullets = false;
		self notify("end_exp_bullets_pix");
	}
}
ExplosiveBullets()
{
	self endon("disconnect");
	self endon("end_exp_bullets_pix");
	for(;;)
	{
		self waittill("weapon_fired");
		my=self gettagorigin("j_head");
		trace=bullettrace(my,my+anglestoforward(self getplayerangles())*100000,true,self)["position"];
		playfx(level._effect["ADGun"],trace);
		RadiusDamage(trace,130,130,130,self);
		wait 0.1;
	}
}
Streak(s)
{ 
      self maps\mp\killstreaks\_killstreaks::giveKillstreak(s,false); 
}
ToggledSI2()
 {
	 if(!self.SuperInterventions2)
	 {
		 self.SuperInterventions2 = true;
		 self thread doSuperInterventions2();
	 }
	 else
	 {
		 self notify("End_xePixTvxsSuperVentions2");
		 self takeWeapon("cheytac_mp");
		 self setClientDvar("cg_gun_y",0);
		 self.SuperInterventions2 = false;
	 }
 }
 doSuperInterventions2()
 {
	self notify("End_xePixTvxsSuperVentions2");
	self iprintLnBold("Javivention[Super Interventions] V2 by xePixTvx :)");
	self setClientDvar("cg_gun_y",200);
	self giveWeapon("cheytac_mp");
	self switchToWeapon("cheytac_mp");
	Hands = spawn("script_model",self.origin);
	Hands setModel("viewmodel_base_viewhands");
	GunLeft = spawn("script_model",self.origin+(15,6,48));
	GunLeft setModel("viewmodel_cheytac");
	GunRight = spawn("script_model",self.origin+(15,-6,48));
	GunRight setModel("viewmodel_cheytac");
	GunLeft LinkTo(Hands);
	GunRight LinkTo(Hands);
	self thread SuperInterventionsDeath(Hands,GunLeft,GunRight);
	self thread SuperInterventionsShootMonitor();
	//player = self;
	//Hands linkto(player);
	self endon("End_xePixTvxsSuperVentions2");
	for(;;)
	{
		Hands.origin = self.origin;
		Hands.angles = self.angles;
		wait 0.01;
	}
	wait 0.05;
 }
 SuperInterventionsDeath(model1,model2,model3)
 {
	 self waittill("End_xePixTvxsSuperVentions2");
	 model1 delete();
	 model2 delete();
	 model3 delete();
 }
 SuperInterventionsShootMonitor()
 {
	 self endon("End_xePixTvxsSuperVentions2");
	 for(;;)
	 {
		 if(self MeleeButtonPressed())
		 {
			 self suicide();
		 }
		 if(self AttackButtonPressed())
		 {
			 earthquake(.15,.2,self gettagorigin("j_spine4"),50);
			 maps\mp\_fx::GrenadeExplosionfx((self.origin));
			 MagicBullet("javelin_mp",self getTagOrigin("tag_eye"),self getCursorPosProjectile2(),self);
		 }
		 wait 0.05;
	 }
	 wait 0.05;
 }
getCursorPosProjectile2()
{
        return BulletTrace(self getTagOrigin("tag_eye"),vector_ScalProjectile2(anglestoforward(self getPlayerAngles()),1000000),0,self)["position"];
}
vector_ScalProjectile2(vec,scale)
{
        return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
StageProjectile()
{
	self.ProjecttileVal ++;
	if(self.ProjecttileVal>10)
	{
		self.ProjecttileVal = 1;
	}
	if(self.ProjecttileVal==1)
	{
		self.ProjectileShow = "Default";
		self thread RemoveProjectile();
	}
	if(self.ProjecttileVal==2)
	{
		self.ProjectileShow = "105mm";
		self thread ProjectileSelctor("ac130_105mm_mp");
	}
	if(self.ProjecttileVal==3)
	{
		self.ProjectileShow = "40mm";
		self thread ProjectileSelctor("ac130_40mm_mp");
	}
	if(self.ProjecttileVal==4)
	{
		self.ProjectileShow = "25mm";
		self thread ProjectileSelctor("ac130_25mm_mp");
	}
	if(self.ProjecttileVal==5)
	{
		self.ProjectileShow = "AT4";
		self thread ProjectileSelctor("at4_mp");
	}
	if(self.ProjecttileVal==6)
	{
		self.ProjectileShow = "RPG";
		self thread ProjectileSelctor("rpg_mp");
	}
	if(self.ProjecttileVal==7)
	{
		self.ProjectileShow = "Javelin";
		self thread ProjectileSelctor("javelin_mp");
	}
	if(self.ProjecttileVal==8)
	{
		self.ProjectileShow = "Stinger";
		self thread ProjectileSelctor("stinger_mp");
	}
	if(self.ProjecttileVal==9)
	{
		self.ProjectileShow = "GL";
		self thread ProjectileSelctor("gl_mp");
	}
	if(self.ProjecttileVal==10)
	{
		self.ProjectileShow = "Predator";
		self thread ProjectileSelctor("remotemissile_projectile_mp");
	}
	self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
}
ProjectileSelctor( type )/////By Mr-Modded-Clan //// do not remove this!!!!!
{
	self endon("disconnect");
	self endon("death");
	self notify("EndModBullet");
	wait 0.5;
	self endon("EndModBullet");
	for(;;)
	{
		self waittill("weapon_fired");
		MagicBullet(type,self getTagOrigin("tag_eye"),self getCursorPosProjectile(),self);
	}
}
getCursorPosProjectile()
{
        return BulletTrace(self getTagOrigin("tag_eye"),vector_ScalProjectile(anglestoforward(self getPlayerAngles()),1000000),0,self)["position"];
}
vector_ScalProjectile(vec,scale)
{
        return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
RemoveProjectile()
{
    self notify("EndModBullet");
}
xePixTvx_BotDrop()
{
	self iprintlnbold("Shoot to select Heli landing point!");
	self waittill("weapon_fired");
	LandPoint=GetCursorPosBotDrop();
	FXMarker_BotDrop(LandPoint,level.oldSchoolCircleYellow);
	Heli=spawnHelicopter(self,self.origin+(15000,0,2300),self.angles,"pavelow_mp","vehicle_pavelow_opfor");
	if(!isDefined(Heli))
	{
		return;
	}
	Heli.owner=self;
	Heli.team=self.team;
	Heli Vehicle_SetSpeed(1000,16);
	Heli setVehGoalPos(LandPoint+(51,0,801),1);
	wait 15;
	Heli setVehGoalPos(LandPoint+(51,0,110),1);
	wait 8;
	self SpawnBotsForBotDrop(LandPoint);
	Heli setVehGoalPos(LandPoint+(51,0,801),1);
	wait 5;
	Heli setVehGoalPos(LandPoint+(15000,0,2300),1);
	wait 15;
	Heli delete();
	self notify("BotDrop_Done");
}
FXMarker_BotDrop(groundpoint,fx)
{
	effect=spawnFx(fx,groundpoint,(0,0,1),(1,0,0));
	self thread deleteFxOnNotify_Two(effect);
	triggerFx(effect);
	return effect;
}
deleteFxOnNotify_Two(lol)
{
	self waittill("BotDrop_Done");
	lol delete();
}
GetCursorPosBotDrop()
{
	return bulletTrace(self getEye(),self getEye()+vectorScaleBotDrop(anglesToForward(self getPlayerAngles()),1000000),false,self)["position"];
}
vectorScaleBotDrop(vector,scale)
{
	return(vector[0]*scale,vector[1]*scale,vector[2]*scale);
}
SpawnBotsForBotDrop(point)
{
	for(i=0;i<6;i++)
	{
		ent[i] = addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread initIndividualBotForBotDrop(point);
		wait 0.1;
	}
}
initIndividualBotForBotDrop(point)
{
	self endon( "disconnect" );
	while(!isdefined(self.pers["team"]))
		wait .05;
	self notify("menuresponse", game["menu_team"], "autoassign");
	wait 0.5;
	self notify("menuresponse", "changeclass", "class" + randomInt( 5 ));
	self waittill("spawned_player");
	self setOrigin(point);
}
ToggleDOA()
{
	if(!self.IsDOA)
	{
		self thread doDOA();
		self.IsDOA = true;
	}
	else
	{
		self thread endDOA();
		self.IsDOA = false;
	}
}
doDOA()
{
	self.Camera = spawn("script_model",self.origin+(0,0,500));
	self.Camera setModel("c130_zoomrig");
	self.Camera.angles = (90,90,0);
	self.Camera NotSolid();
	self.Camera EnableLinkTo();
	wait 0.001;
	self CameraLinkTo(self.Camera,"tag_origin");
	self thread camMoverDOA();
}
endDOA()
{
	self notify("Exit_DOA");
	self.Camera delete();
	self CameraUnlink();
}
camMoverDOA()
{
	self endon("Exit_DOA");
	while(1)
	{
		self.Camera MoveTo(self.origin+(0,0,500),0.1);
		wait 0.1;
	}
}
KillTheStreaks()
{
	level maps\mp\killstreaks\_emp::destroyActiveVehicles();
	self iprintln("^1Destroyed All Killstreaks");
}
RandomSplash()
{
	S=[];
	S[0]="callout_3xpluskill";
	S[1]="callout_3xkill";
	S[2]="callout_firstblood";
	S[3]="callout_lastteammemberalive";
	self thread GiveSplash(S[randomint(S.size)]);
}
GiveSplash(s)
{
	thread teamPlayerCardSplash(s,self);
}
spawnDrivableCar(model)
{
	if(!isDefined(self.car["spawned"]))
	{
		self setClientDvar("cg_thirdPersonRange",300);
		self.car["carModel"] = model;
		self.car["spawned"] = true;
		self.car["runCar"] = true;
		self.car["spawnPosition"] = self.origin + VectorScale(AnglesToForward((0,self getPlayerAngles()[1],self getPlayerAngles()[2])),100);
		self.car["spawnAngles"] = (0,self getPlayerAngles()[1],self getPlayerAngles()[2]);
		self.car["carEntity"] = spawn("script_model",self.car["spawnPosition"]);
		self.car["carEntity"].angles = self.car["spawnAngles"];
		self.car["carEntity"] setModel(self.car["carModel"]);
		wait .2;
		self thread Vehicle_Wait_Think();
	}
	else
	{ 
		self iPrintln("You Can Only Spawn One Car At A Time!");
	}
}
Vehicle_Wait_Think()
{
	self endon("disconnect");
	self endon("end_car");
	while(self.car["runCar"])
	{
		if(distance(self.origin,self.car["carEntity"].origin)< 120)
		{
			if(self useButtonPressed())
			{
				if(!self.car["inCar"])
				{
					self iPrintln("Press [{+attack}] To Accelerate");
					self iPrintln("Press [{+speed_throw}] To Reverse/Break");
					self iPrintln("Press [{+reload}] To Exit Car");
					self.car["speed"]=0;
					self.car["inCar"]=true;
					self disableWeapons();
					self detachAll();
					self setOrigin(((self.car["carEntity"].origin)+(AnglesToForward(self.car["carEntity"].angles)* 20)+(0,0,3)));
					self hide();
					//self setClientThirdPerson(true);
					self setClientDvar("camera_thirdPerson",1);
					self setClientDvar("cg_thirdPerson",1);
					self setClientDvar("scr_thirdPerson",1);
					self setPlayerAngles(self.car["carEntity"].angles +(0,0,0));
					self PlayerLinkTo(self.car["carEntity"]);
					thread Vehicle_Physics_Think();
					thread Vehicle_Death_Think();
					wait 1;
				}
				else thread Vehicle_Exit_Think();
			}
		}
		wait .05;
	}
}
Vehicle_Physics_Think()
{
	self endon("disconnect");
	self endon("end_car");
	carPhysics=undefined;
	carTrace=undefined;
	newCarAngles=undefined;
	while(self.car["runCar"])
	{
		carPhysics =((self.car["carEntity"].origin)+((AnglesToForward(self.car["carEntity"].angles)*(self.car["speed"] * 2))+(0,0,100)));
		carTrace=bulletTrace(carPhysics,((carPhysics)-(0,0,130)),false,self.car["carEntity"])["position"];
		if(self attackButtonPressed())
		{
			if(self.car["speed"] < 0)self.car["speed"]=0;
			if(self.car["speed"] < 50)self.car["speed"] += 0.4;
			newCarAngles=vectorToAngles(carTrace - self.car["carEntity"].origin);
			self.car["carEntity"] moveTo(carTrace,0.2);
			self.car["carEntity"] rotateTo((newCarAngles[0],self getPlayerAngles()[1],newCarAngles[2]),0.2);
		}
		else
		{
			if(self.car["speed"] > 0)
			{
				newCarAngles=vectorToAngles(carTrace - self.car["carEntity"].origin);
				self.car["speed"] -= 0.7;
				self.car["carEntity"] moveTo(carTrace,0.2);
				self.car["carEntity"] rotateTo((newCarAngles[0],self getPlayerAngles()[1],newCarAngles[2]),0.2);
			}
		}
		if(self adsButtonPressed())
		{
			if(self.car["speed"] > -20)
			{
				if(self.car["speed"] < 0)newCarAngles=vectorToAngles(self.car["carEntity"].origin - carTrace);
				self.car["speed"] -= 0.5;
				self.car["carEntity"] moveTo(carTrace,0.2);
			}
			else self.car["speed"] += 0.5;
			self.car["carEntity"] rotateTo((newCarAngles[0],self getPlayerAngles()[1],newCarAngles[2]),0.2);
		}
		else
		{
			if(self.car["speed"] < -1)
			{
				if(self.car["speed"] < 0)newCarAngles=vectorToAngles(self.car["carEntity"].origin - carTrace);
				self.car["speed"] += 0.8;
				self.car["carEntity"] moveTo(carTrace,0.2);
				self.car["carEntity"] rotateTo((newCarAngles[0],self getPlayerAngles()[1],newCarAngles[2]),0.2);
			}
		}
		wait 0.05;
	}
}
Vehicle_Death_Think()
{
	self endon("disconnect");
	self endon("end_car");
	self waittill("death");
	if(self.car["inCar"])thread Vehicle_Exit_Think();
	else self.car["carEntity"] delete();
	wait 0.2;
}
Vehicle_Exit_Think()
{
	self.car["speed"]=0;
	self.car["inCar"]=false;
	self.car["runCar"]=false;
	self.car["spawned"]=undefined;
	self.car["carEntity"] delete();
	self unlink();
	self enableWeapons();
	self show();
	//self setClientThirdPerson(false);
	self setClientDvar("camera_thirdPerson",0);
	self setClientDvar("cg_thirdPerson",0);
	self setClientDvar("scr_thirdPerson",0);
	wait 0.3;
	self notify("end_car");
}
traceBulletCar(distance)
{
	if(!isDefined(distance))distance=10000000;
	return bulletTrace(self getEye(),self getEye()+ vectorScale(AnglesToForward(self getPlayerAngles()),distance),false,self)["position"];
}
vectorScale(vector,scale)
{
	return(vector[0]*scale,vector[1]*scale,vector[2]*scale);
}
xePixTvx_FlyableChopper(model,LOL)
{
	self setClientDvar("cg_thirdPersonRange",LOL);
	self iprintlnbold("Shoot to select Heli landing point!");
	self waittill("weapon_fired");
	LandPoint=GetCursorPosFlyableChopper();
	FXMarker_FlyableChopper(LandPoint,level.oldSchoolCircleYellow);
	Heli = spawnHelicopter(self,self.origin+(15000,0,2300),self.angles,"littlebird_mp",model);
	if(!isDefined(Heli)){
		return;}
	Heli.owner = self;
	Heli.team = self.team;
	Heli Vehicle_SetSpeed(1000,16);
	Heli setVehGoalPos(LandPoint+(51,0,801),1);
	wait 15;
	Heli setVehGoalPos(LandPoint+(51,0,110),1);
	wait 8;
	self notify("WLALALALAL");
	self thread Chopper_Monitor(Heli,LandPoint,model);
}
FXMarker_FlyableChopper(groundpoint,fx)
{
	effect=spawnFx(fx,groundpoint,(0,0,1),(1,0,0));
	self thread deleteFxOnNotify(effect);
	triggerFx(effect);
	return effect;
}
deleteFxOnNotify(lol)
{
	self waittill("WLALALALAL");
	lol delete();
}
GetCursorPosFlyableChopper()
{
	return bulletTrace(self getEye(),self getEye()+vectorScaleFlyableChopper(anglesToForward(self getPlayerAngles()),1000000),false,self)["position"];
}
vectorScaleFlyableChopper(vector,scale)
{
	return(vector[0]*scale,vector[1]*scale,vector[2]*scale);
}
Chopper_Monitor(helii,leavePoint,model)
{
	self endon("disconnect");
	self endon("End_FlyChopper");
	self.inChopper = false;
	for(;;)
	{
		if(!self.inChopper)
		{
			if(Distance(helii.origin,self.origin)<170)
			{
				if(self UseButtonPressed())
				{
					self hide();
                    self setClientDvar("camera_thirdPerson",1);
					self setClientDvar("cg_thirdPerson",1);
					self setClientDvar("scr_thirdPerson",1);
                    self disableWeapons();
                    self setPlayerAngles(helii.angles+(0,0,0));
                    self PlayerlinkTo(helii);
                    self.Destination = spawn("script_origin",self.origin);
                    self.inChopper = true;
					wait .3;
				}
				if(self MeleeButtonPressed())
				{
					helii setVehGoalPos(leavePoint+(15000,0,2300),1);
					wait 15;
					helii delete();
					self notify("End_FlyChopper");
					wait .3;
				}
			}
		}
		else if(self.inChopper)
		{
			forward=anglestoforward(self getPlayerAngles());
			if(self MeleeButtonPressed())
			{
				self show();
                self setClientDvar("camera_thirdPerson",0);
				self setClientDvar("cg_thirdPerson",0);
				self setClientDvar("scr_thirdPerson",0);
                self unlink();
                self enableWeapons();
                self.Destination delete();
                self.inChopper = false;
				wait .3;
			}
			if(self AttackButtonPressed())
			{
				self.Destination.origin = (self.Destination.origin[0]+forward[0]*16,self.Destination.origin[1]+forward[1]*16,self.Destination.origin[2]);
				helii setVehGoalPos(self.Destination.origin,1);
			}
			if(self SecondaryOffHandButtonPressed())
			{
				self.Destination.origin = (self.Destination.origin[0],self.Destination.origin[1],self.Destination.origin[2]-10);
				helii setVehGoalPos(self.Destination.origin,1);
			}
			if(self FragButtonPressed())
			{
				self.Destination.origin = (self.Destination.origin[0],self.Destination.origin[1],self.Destination.origin[2]+10);
				helii setVehGoalPos(self.Destination.origin,1);
			}
		}
		else{}
		wait 0.05;
	}
	wait 0.05;
}

//I dont give a fuck about aimbots
ToggleAimbot()
{
	if(!self.Aimbot)
	{
		if(self.RealAimbot==true)
		{
			self iprintln("^1Turn Realistic Aimbot Off First!");
			return;
		}
		self.Aimbot = true;
		self thread epx_aimBot();
	}
	else
	{
		self notify("Aimbot_End");
		self.Aimbot = false;
	}
	self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
}
ToggleRealAimbot()
{
	if(!self.RealAimbot)
	{
		if(self.Aimbot==true)
		{
			self iprintln("^1Turn Normal Aimbot Off First!");
			return;
		}
		self.RealAimbot = true;
		self thread epx_aimBot();
	}
	else
	{
		self notify("Aimbot_End");
		self.RealAimbot = false;
	}
	self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
}
epx_aimBot()
{
	self notify("Aimbot_End");
	wait 0.05;
	self endon("disconnect");
	self endon("Aimbot_End");
	for(;;)
	{
		target = undefined;
		foreach(player in level.players){
			if((player==self)||(!isAlive(player))||(level.teamBased&&self.pers["team"]==player.pers["team"])){
				continue;}
			if(isDefined(target)){
				if(closer(self getTagOrigin("j_head"), player getTagOrigin("j_head"), target getTagOrigin("j_head"))){
					target = player;}}
			else {
				target = player; }}
		if(isDefined(target)) 
		{
			if(self.Aimbot==true)
			{
				if(self.AimbotIsUnfair && !self.AimbotIsFair){
					if(self.AutoAim==true){
						self setplayerangles(VectorToAngles((target getTagOrigin("j_head"))-(self getTagOrigin("j_head")))); 
						if(self attackbuttonpressed()){
							if(self.AimbotVisibleCheck==true){
								if(bulletTracePassed(self getTagOrigin("j_head"), target getTagOrigin("j_head"), false, self)){
									if(distance(self.origin,target.origin)<=1800){
										target thread [[level.callbackPlayerDamage]](self,self,100,0,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0,0);}}}
							else{
								target thread [[level.callbackPlayerDamage]](self,self,100,0,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0,0);}}}
					else{
						if(self adsbuttonpressed()){
							self setplayerangles(VectorToAngles((target getTagOrigin("j_head"))-(self getTagOrigin("j_head")))); 
							if(self attackbuttonpressed()){
								if(self.AimbotVisibleCheck==true){
									if(bulletTracePassed(self getTagOrigin("j_head"), target getTagOrigin("j_head"), false, self)){
										if(distance(self.origin,target.origin)<=1800){
											target thread [[level.callbackPlayerDamage]](self,self,100,0,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0,0);}}}
								else{
									target thread [[level.callbackPlayerDamage]](self,self,100,0,"MOD_HEAD_SHOT",self getCurrentWeapon(),(0,0,0),(0,0,0),"head",0,0);}}}}}
				if(self.AimbotIsFair && !self.AimbotIsUnfair){
					if(self.AutoAim==true){
						self setplayerangles(VectorToAngles((target getTagOrigin("j_spinelower"))-(self getTagOrigin("j_spinelower"))));
						if(self AttackButtonPressed()){
							if(self.AimbotVisibleCheck==true){
								if(bulletTracePassed(self getTagOrigin("j_spinelower"), target getTagOrigin("j_spinelower"), false, self)){
									if(distance(self.origin,target.origin)<=1800){
										MagicBullet(self getcurrentweapon(),(target getTagOrigin("j_spinelower"))+(0,0,10),(target getTagOrigin("j_spinelower")),self);}}}
							else{
								MagicBullet(self getcurrentweapon(),(target getTagOrigin("j_spinelower"))+(0,0,10),(target getTagOrigin("j_spinelower")),self);}}}
					else{
						if(self AdsButtonPressed()){
							self setplayerangles(VectorToAngles((target getTagOrigin("j_spinelower"))-(self getTagOrigin("j_spinelower"))));
							if(self AttackButtonPressed()){
								if(self.AimbotVisibleCheck==true){
									if(bulletTracePassed(self getTagOrigin("j_spinelower"), target getTagOrigin("j_spinelower"), false, self)){
										if(distance(self.origin,target.origin)<=1800){
											MagicBullet(self getcurrentweapon(),(target getTagOrigin("j_spinelower"))+(0,0,10),(target getTagOrigin("j_spinelower")),self);}}}
								else{
									MagicBullet(self getcurrentweapon(),(target getTagOrigin("j_spinelower"))+(0,0,10),(target getTagOrigin("j_spinelower")),self);}}}}}
			}
			else if(self.RealAimbot==true)
			{
				if(self AdsButtonPressed()){
					if(bulletTracePassed(self getTagOrigin("j_spinelower"),target getTagOrigin("j_spinelower"),false,self)){
						if(distance(self.origin,target.origin)<=1800){
							if(self isCorssHairCheck(target)){
								self setplayerangles(VectorToAngles((target getTagOrigin("j_spinelower"))-(self getTagOrigin("j_spinelower"))));}}}}
			}
			else
			{
				self iprintln("xePixTvx Aimbot Type Error!");
			}
		}
		wait 0.05;
	}
}
isCorssHairCheck(target)
{
	self.angles = self getPlayerAngles();
	LOLOLOLOL = VectorToAngles(target getTagOrigin("j_spinelower")-self getTagOrigin("j_spinelower"));
	cross = length(LOLOLOLOL-self.angles);
	if(cross<25){
		return true;}
	else{
		return false;}
}
ToggleAimbotUnfair()
{
	if(!self.AimbotIsUnfair)
	{
		self.AimbotIsFair = false;
		self.AimbotIsUnfair = true;
	}
	else
	{
		self.AimbotIsUnfair = false;
		self.AimbotIsFair = true;
	}
}
ToggleAimbotFair()
{
	if(!self.AimbotIsFair)
	{
		self.AimbotIsUnfair = false;
		self.AimbotIsFair = true;
	}
	else
	{
		self.AimbotIsFair = false;
		self.AimbotIsUnfair = true;
	}
}
ToggleAutoAim()
{
	if(!self.AutoAim)
	{
		self.AutoAim = true;
	}
	else
	{
		self.AutoAim = false;
	}
}
ToggleAimbotVisibleCheck()
{
	if(!self.AimbotVisibleCheck)
	{
		self.AimbotVisibleCheck = true;
	}
	else
	{
		self.AimbotVisibleCheck = false;
	}
}

initTestClients1()
{
	for(i = 0; i < 1; i++)
	{
		ent[i] = addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread initIndividualBot();
		wait 0.1;
	}
}
initTestClients3()
{
	for(i = 0; i < 3; i++)
	{
		ent[i] = addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread initIndividualBot();
		wait 0.1;
	}
}
initTestClients5()
{
	for(i = 0; i < 5; i++)
	{
		ent[i] = addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread initIndividualBot();
		wait 0.1;
	}
}
initTestClients10()
{
	for(i = 0; i < 10; i++)
	{
		ent[i] = addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread initIndividualBot();
		wait 0.1;
	}
}
initTestClients15()
{
	for(i = 0; i < 15; i++)
	{
		ent[i] = addtestclient();
		if (!isdefined(ent[i]))
		{
			wait 1;
			continue;
		}
		ent[i].pers["isBot"] = true;
		ent[i] thread initIndividualBot();
		wait 0.1;
	}
}
initIndividualBot()
{
	self endon( "disconnect" );
	while(!isdefined(self.pers["team"]))
		wait .05;
	self notify("menuresponse", game["menu_team"], "autoassign");
	wait 0.5;
	self notify("menuresponse", "changeclass", "class" + randomInt( 5 ));
	self waittill( "spawned_player" );
}
ToggleAttack()
{
     if(!level.BotAttack)
	 {
	     level.BotAttack = true;
		 self setClientDvar("testClients_doAttack",1); 
	 }
	 else
	 {
	    level.BotAttack = false;
		self setClientDvar("testClients_doAttack",0); 
	 }
}
ToggleMove()
{
     if(!level.BotMove)
	 {
	     level.BotMove = true;
		 self setClientDvar("testClients_doMove",1); 
	 }
	 else
	 {
	    level.BotMove = false;
		self setClientDvar("testClients_doMove",0); 
	 }
}
ToggleReload()
{
     if(!level.BotReload)
	 {
	     level.BotReload = true;
		 self setClientDvar("testClients_doReload",1); 
	 }
	 else
	 {
	    level.BotReload = false;
		self setClientDvar("testClients_doReload",0); 
	 }
}
ToggleKillcam()
{
     if(!level.BotCam)
	 {
	     level.BotCam = true;
		 self setClientDvar("testClients_watchKillcam",1); 
	 }
	 else
	 {
	    level.BotCam = false;
		self setClientDvar("testClients_watchKillcam",0); 
	 }
}
ToggleCrouch()
{
     if(!level.BotCr)
	 {
	     level.BotCr = true;
		 self setClientDvar("testClients_doCrouch",1); 
	 }
	 else
	 {
	    level.BotCr = false;
		self setClientDvar("testClients_doCrouch",0); 
	 }
}
kickAllBots()
{
	foreach ( player in level.players )
	{
		if ( isDefined ( player.pers [ "isBot" ] ) && player.pers [ "isBot" ] )
		kick ( player getEntityNumber(), "EXE_PLAYERKICKED" );
	}
}
teleAllBotsMe()
{
	foreach(player in level.players)
	{
		if(isDefined(player.pers["isBot"]) && player.pers["isBot"])
		{
			player SetOrigin(self.origin);
		}
	}
}
killallbots()
{
	foreach(player in level.players)
	{
		if(isDefined(player.pers["isBot"]) && player.pers["isBot"])
		{
			player suicide();
		}
	}
}
botstocrossShoot()
{
	if(!self.ShootBotsCross)
	{
		self.ShootBotsCross = true;
		self thread doShootBotsCross();
	}
	else
	{
		self notify("BotsCrossShoot");
		self.ShootBotsCross = false;
	}
}
doShootBotsCross()
{
	self endon("disconnect");
	self endon("BotsCrossShoot");
	for(;;)
	{
		self waittill("weapon_fired");
		foreach(player in level.players)
		{
			if(player isBot())
			{
				player SetOrigin(self GetCursorPosCrossShoot());
			}
		}
		waitframe();
	}
	wait 0.05;
}
GetCursorPosCrossShoot()
{
	return BulletTrace( self getTagOrigin("tag_eye"), vector_ScalCrossShoot(anglestoforward(self getPlayerAngles()),1000000), 0, self )[ "position" ];
}
vector_scalCrossShoot(vec, scale)
{
	return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
StartAgain(lol)
{
   map_restart(lol);
}
doEnd()
{
    level thread maps\mp\gametypes\_gamelogic::forceEnd();
}
PauseLobby()
{
   self thread maps\mp\gametypes\_hostmigration::Callback_HostMigration();
}
Freezer()
{
	if(!level.LobbyFrozen)
	{
		level.LobbyFrozen = true;
		foreach(player in level.players)
		{
			player freezeControlsWrapper(true);
		}
	}
	else
	{
		level.LobbyFrozen = false;
		foreach(player in level.players)
		{
			player freezeControlsWrapper(false);
		}
	}
}
ToggleRanked()
{
     if(!level.isRankedMatch)
	 {
	     level.isRankedMatch = true;
		 self setClientDvar("xblive_hostingprivateparty","1");
		 setDvar("xblive_privatematch",1);
		 self iprintln("Ranked Match ^4ON");
	 }
	 else
	 {
	    level.isRankedMatch = false;
		self setClientDvar("xblive_hostingprivateparty","0");
		setDvar("xblive_privatematch",0);
		self iprintln("Ranked Match ^4OFF");
	 }
}
ToggleAntiJoin()
{
	if(!level.AntiJoinON)
	{
		setDvar("g_password", "#ePx");
		level.AntiJoinON = true;
		self iPrintln("Anti-Join ^4ON");
	}
	else
	{
		setDvar("g_password", "");
	    level.AntiJoinON = false;
		self iPrintln("Anti-Join ^4OFF");
	}
}
ResetDvarxD()
{
   setDvar("jump_height",39);
   setDvar("g_speed",190);
   setDvar("player_sprintSpeedScale",1.5);
   self setClientDvar("g_gravity",800);
   setDvar("timescale",1);
   self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
}
ColorClasses()
{
	self setPlayerData("customClasses",0,"name","^"+randomInt(9)+"xePixTvx");
	self setPlayerData("customClasses",1,"name","^"+randomInt(9)+"Is");
	self setPlayerData("customClasses",2,"name","^"+randomInt(9)+"AWESOME!!");
	self setPlayerData("customClasses",3,"name","^"+randomInt(9)+"www.CabconModding.com");
	self setPlayerData("customClasses",4,"name","^"+randomInt(9)+"Subscribe");
	self setPlayerData("customClasses",5,"name","^"+randomInt(9)+"www.youtube.com/user/xePixTvx");
	self setPlayerData("customClasses",6,"name","^"+randomInt(9)+"Created");
	self setPlayerData("customClasses",7,"name","^"+randomInt(9)+"By");
	self setPlayerData("customClasses",8,"name","^"+randomInt(9)+"xePixTvx/xFuZiioN_x3");
	self setPlayerData("customClasses",9,"name","^"+randomInt(9)+"AWESOME!!!");
}
setButtonClassNames()
{
	self setPlayerData("customClasses",0,"name","[{+gostand}]");//Button X
	self setPlayerData("customClasses",1,"name","[{+stance}]");//Button Circle
	self setPlayerData("customClasses",2,"name","[{weapnext}]");//Button Triangle
	self setPlayerData("customClasses",3,"name","[{+usereload}]");//Button Square
	self setPlayerData("customClasses",4,"name","[{+melee}]");//Button Knife
	self setPlayerData("customClasses",5,"name","[{+frag}]");//Button R2
	self setPlayerData("customClasses",6,"name","[{+smoke}]");//Button L3
	self setPlayerData("customClasses",7,"name","[{+actionslot 3}]");//Dpad Down
	self setPlayerData("customClasses",8,"name","[{+actionslot 2}]");//Dpad Right
	self setPlayerData("customClasses",9,"name","[{+actionslot 1}]");//Dpad Up
}
NameClass()
{
	i = 0;
	j = 1;
	while (i < 10)
	{
		self setPlayerData("customClasses", i, "name", "^" + j + self.name + " " + (i + 1));
		i++;
		j++;
		if (j == 7) j = 1;
	}
}
AllPerks()
{
	PerkList = strTok("specialty_fastreload,,specialty_extendedmelee,specialty_fastsprintrecovery,specialty_improvedholdbreath,specialty_fastsnipe,specialty_selectivehearing,specialty_heartbreaker,specialty_automantle,specialty_falldamage,specialty_lightweight,specialty_coldblooded,specialty_fastmantle,specialty_quickdraw,specialty_parabolic,specialty_detectexplosive,specialty_marathon,specialty_extendedmags,specialty_armorvest,specialty_scavenger,specialty_jumpdive,specialty_extraammo,specialty_bulletdamage,specialty_quieter,specialty_bulletpenetration,specialty_bulletaccuracy",",");
	for(i=0;i<PerkList.size;i++)
	{
		self maps\mp\perks\_perks::givePerk(PerkList[i]);
		self iprintln("^1"+PerkList[i]+" ","^5Set");
		wait 1;
	}
	self iprintln("^5All Perks Set :D");
}
GiveAcco()
{
	foreach(ref,award in level.awards)self dotheAcco(ref);
	self dotheAcco("targetsdestroyed");
	self dotheAcco("bombsplanted");
	self dotheAcco("bombsdefused");
	self dotheAcco("bombcarrierkills");
	self dotheAcco("bombscarried");
	self dotheAcco("killsasbombcarrier");
	self dotheAcco("flagscaptured");
	self dotheAcco("flagsreturned");
	self dotheAcco("flagcarrierkills");
	self dotheAcco("flagscarried");
	self dotheAcco("killsasflagcarrier");
	self dotheAcco("hqsdestroyed");
	self dotheAcco("hqscaptured");
	self dotheAcco("pointscaptured");
	self iprintln("^1Accolades Set");
}
dotheAcco(ref)
{
	self setPlayerData("awards",ref,self getPlayerData("awards",ref) + 1000);
}
StageViewport()
{
	self.ViewPortVal ++;
	if(self.ViewPortVal>4)
	{
		self.ViewPortVal = 1;
	}
	if(self.ViewPortVal==1)
	{
		self.ViewPortShow = "Default";
		self ViewPortScaleChange("Fullscreen");
	}
	if(self.ViewPortVal==2)
	{
		self.ViewPortShow = "0.5";
		self ViewPortScaleChange("0.5");
	}
	if(self.ViewPortVal==3)
	{
		self.ViewPortShow = "0.3";
		self ViewPortScaleChange("0.3");
	}
	if(self.ViewPortVal==4)
	{
		self.ViewPortShow = "0.1";
		self ViewPortScaleChange("NotFullscreen");
	}
	self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
}
ViewPortScaleChange(lol)
{
   switch(lol)
   {
      case "Fullscreen":
	      self setclientDvar("r_scaleviewport",0.2);wait 0.05;
		  self setclientDvar("r_scaleviewport",0.3);wait 0.05;
	      self setclientDvar("r_scaleviewport",0.4);wait 0.05;
		  self setclientDvar("r_scaleviewport",0.5);wait 0.05;
		  self setclientDvar("r_scaleviewport",0.6);wait 0.05;
		  self setclientDvar("r_scaleviewport",0.7);wait 0.05;
		  self setclientDvar("r_scaleviewport",0.8);wait 0.05;
		  self setclientDvar("r_scaleviewport",0.9);wait 0.05;
		  self setclientDvar("r_scaleviewport",1);wait 0.05;
	  break;
	  
	  case "NotFullscreen":
		  self setclientDvar("r_scaleviewport",0.2);wait 0.05;
		  self setclientDvar("r_scaleviewport",0.1);wait 0.05;
	  break;
	  
	  case "0.5":
		  self setclientDvar("r_scaleviewport",0.9);wait 0.05;
          self setclientDvar("r_scaleviewport",0.8);wait 0.05;
          self setclientDvar("r_scaleviewport",0.7);wait 0.05;
	      self setclientDvar("r_scaleviewport",0.6);wait 0.05;
	      self setclientDvar("r_scaleviewport",0.5);wait 0.05;
	  break;
	  
	  case "0.3":
	      self setclientDvar("r_scaleviewport",0.4);wait 0.05;
	      self setclientDvar("r_scaleviewport",0.3);wait 0.05;
	  break;
   }
}
StageGunSide()
{
	self.GunSideVal ++;
	if(self.GunSideVal>4)
	{
		self.GunSideVal = 1;
	}
	if(self.GunSideVal==1)
	{
		self.GunSideShow = "Default";
		self setClientDvar( "cg_gun_y", 0 );
		self setClientDvar( "cg_gun_x", 0 );
		self notify("endon_MoveGun");
	}
	if(self.GunSideVal==2)
	{
		self.GunSideShow = "Left";
		self setClientDvar( "cg_gun_y", 5 );
		self setClientDvar( "cg_gun_x", 0 );
		self notify("endon_MoveGun");
	}
	if(self.GunSideVal==3)
	{
		self.GunSideShow = "Right";
		self setClientDvar( "cg_gun_y", -5 );
		self setClientDvar( "cg_gun_x", 0 );
		self notify("endon_MoveGun");
	}
	if(self.GunSideVal==4)
	{
		self.GunSideShow = "Moving";
		self thread MoveGun();
	}
	self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
}
MoveGun()
{
	self endon ( "disconnect" );
	self endon ( "endon_MoveGun" );
	self setClientDvar( "cg_gun_y", 0 );
	self setClientDvar( "cg_gun_x", 10 );
	i = -30;
	for( ;; )
	{
		i++;
		self setClientDvar( "cg_gun_y", i );
		
		if( getdvar ( "cg_gun_y" ) == "30" )
		{
			i=-30;
		}
		
		wait .1;
	}
}
ToggleWalkAC()
{
	if(!self.WAC130)
	{
		self.WAC130=true;
		self ThermalVisionFOFOverlayOn();
		self thread WalkAC130();
		self iPrintln("Walking AC-130 : ON");
	}
	else
	{
		self notify("StopWalkAC");
		self iPrintln("Walking AC-130 : OFF");
		self ThermalVisionFOFOverlayOff();
		self takeWeapon("ac130_105mm_mp");
		self takeWeapon("ac130_40mm_mp");
		self takeWeapon("ac130_25mm_mp");
		self switchToWeapon(self.weapTemp);
		self.weapTemp="";
		self.WAC130=false;
	}
}
WalkAC130()
{
	self endon("disconnect");
	//self endon("death");
	self endon("StopWalkAC");
	self.weapTemp="";
	for(;;)
	{
		C=self getCurrentWeapon();
		if(self.weapTemp=="")self.weapTemp=self getCurrentWeapon();
		if(C!="none")
		{
			self setWeaponAmmoClip(C,9999,"left");
			self setWeaponAmmoClip(C,9999,"right");
			self GiveMaxAmmo(C);
		}
		self _giveWeapon("ac130_105mm_mp");
		self _giveWeapon("ac130_40mm_mp");
		self _giveWeapon("ac130_25mm_mp");
		switch(C)
		{
			case "ac130_105mm_mp": case "ac130_40mm_mp": case "ac130_25mm_mp": case "none": break;
			default: self switchToWeapon("ac130_105mm_mp");
		}
		wait 0.05;
	}
}
JerichoV2()
{
  weap = "deserteaglegold_mp";
  self GiveWeapon(weap);
  visionSetNaked("blacktest");
  wait 0.4;
  self switchToWeapon(weap);
  wait 0.4;
  visionSetNaked(getDvar("mapname"));
  wait 0.2;
  iprintln("^5JMV_02 Status: ^1[^2ONLINE^1] ^5Fire To Select Nodes");
  setDvar("cg_laserforceon", "1");
  self playsound("item_nightvision_on");
  for(i=0;i<=9;i++)
  {
    self waittill("weapon_fired");
    target=GetCursorPosYAYAYAYAY();
    x= markerfx(target, level.oldSchoolCircleYellow );
    self thread jericoMissile(target,x);
  }
  {
     iprintln("^5All Missile Paths Initialized Sir ^5Fire Your Weapon To Launch");
     self waittill("weapon_fired");
     self notify("fuckingBoom");
  }
}
jericomissile(target,x)
{
        self waittill("fuckingBoom");
        x delete();
        x= markerfx(target, level.oldschoolcirclered );
        location= target+(0,3500,5000);
        bomb = spawn("script_model",location );
        bomb playsound("mp_ingame_summary");
        bomb setModel("projectile_rpg7");
        //other models ("projectile_cbu97_clusterbomb"); or ( "projectile_rpg7" );
        bomb.angles = bomb.angles+(90,90,90);
        self.killCamEnt=bomb;
        ground=target;
        target = VectorToAngles(ground - bomb.origin );
        bomb rotateto(target,0.01);
        wait 0.01;
		speed = 3000;
		time = calc(speed,bomb.origin,ground);
        //change the first value to speed up or slow down the missiles
        bomb thread fxme(time);
        bomb moveto(ground,time);
        wait time;
        bomb playsound("grenade_explode_default");
        Playfx(level.expbullt,bomb.origin+(0,0,1) );  
        // change this explosion effect to whatever you use!  
        RadiusDamage(bomb.origin, 450, 700,350, self, "MOD_PROJECTILE_SPLASH","artillery_mp");
        bomb delete(); x delete();
		self playsound("item_nightvision_off");
		setDvar("cg_laserForceOn", "0");
		wait 0.4;
		self takeWeapon("deserteaglegold_mp");
}
MarkerFX( groundpoint, fx )
{
        effect = spawnFx( fx, groundpoint, (0,0,1), (1,0,0) );
        triggerFx( effect );
       
        return effect;
}
fxme(time)
{
   for(i=0;i<time;i++)
   {
       playFxOnTag(level.rpgeffect,self,"tag_origin");
       wait 0.2;
   }
}
calc(speed,origin,moveTo)
{
   return (distance(origin,moveTo)/speed);
}
GetCursorPosYAYAYAYAY()
{
       	return bulletTrace(self getEye(),self getEye()+vectorScale147(anglesToForward(self getPlayerAngles()),1000000),false,self)["position"];
}
vectorScale147( vector, scale )
{
	return ( vector[0] * scale, vector[1] * scale, vector[2] * scale );
}
StuntRun()
{
	gun=self getcurrentweapon();
	self iprintLn("Press [{+actionslot 4}] To Activate");
	self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
	self.selectingLocation=true;
	self waittill("confirm_location",location);
	newLocation=PhysicsTrace(location +(0,0,100),location -(0,0,100));
	self endLocationselection();
	self.selectingLocation=undefined;
	wait 0.5;
	self takeweapon("briefcase_bomb_mp");
	wait 0.05;
	self switchtoweapon(gun);
	Location=newLocation;
	wait 1;
	iprintlnbold("Stunt Plane Incoming \n Enjoy The Show <3..");
	wait 1.5;
	clear_two();
	locationYaw = getBestPlaneDirection( location );
	flightPath = getFlightPath( location, locationYaw, 0 );
	level thread doStuntRun( self, flightPath,location );
}
doStuntRun( owner, flightPath, location )
{
	level endon( "game_ended" );
	if ( !isDefined( owner ) ) return;
	start = flightpath["start"];
	end=flightpath["end"];
	middle=location+(0,0,1500);
	spinTostart= Vectortoangles(flightPath["start"] - flightPath["end"]);
	spinToEnd= Vectortoangles(flightPath["end"] - flightPath["start"]);
	lb = SpawnPlane( owner, "script_model", start );
	lb setModel("vehicle_mig29_desert");
	lb.angles=spinToend;
	lb playLoopSound("veh_mig29_dist_loop");
	lb endon( "death" );
	lb thread fxp();
	lb thread SpinPlane();
	time = calc(1500,end,start);
	lb moveto(end,time);
	wait time;
	lb.angles=spinToStart;
	wait 3;
	time=calc(1500,lb.origin,middle);
	lb moveto(middle,time);
	wait time;
	lb thread planeyaw();
	lb waittill("yawdone");
	lb.angles=spinToStart;
	time=calc(1500,lb.origin,start);
	lb moveto(start,time);
	wait time;
	lb.angles=spinToEnd;
	wait 3;
	time=calc(1500,lb.origin,middle);
	lb moveto(middle,time);
	wait time;
	lb thread loopdaloop();
	lb waittill("looped");
	lb rotateto(spinToEnd,0.5);
	time=calc(1500,lb.origin,end);
	lb thread spinPlane();
	lb moveto(end,time);
	wait time;
	lb.angles=spinTostart;
	wait 3;
	time=calc(1500,lb.origin,middle);
	lb moveto(middle,time);
	wait time;
	wait 2;
	lb thread planebomb(owner);
	wait 5;
	lb moveto(start,time);
	wait time;
	lb notify("planedone");
	lb delete();
}
fxp()
{
	self endon("planedone");
	for(;;)
	{
		playfxontag( level.noobeffect, self, "tag_engine_right" );
		playfxontag( level.noobeffect, self, "tag_engine_left" );
		playfxontag( level.noobeffect, self, "tag_right_wingtip" );
		playfxontag( level.noobeffect, self, "tag_left_wingtip" );
		wait 0.3;
	}
}
SpinPlane()
{
	self endon("stopspinning");
	for(i=0;i<10;i++)
	{
		self rotateroll(360,2);
		wait 2;
	}
	self notify("stopspinning");
}
clear_two()
{
}
PlaneYaw()
{
	self endon("yawdone");
	move=80;
	for(i=0;i<60;i++)
	{
		vec = anglestoforward(self.angles);
		speed = (vec[0] * move, vec[1] * move, vec[2] * move);
		self moveto(self.origin+speed,0.05);
		self rotateYaw(6,0.05);
		wait 0.05;
	}
	for(i=0;i<60;i++)
	{
	vec = anglestoforward(self.angles);
	speed = (vec[0] * move, vec[1] * move, vec[2] * move);
		self moveto(self.origin+speed,0.05);
		self rotateYaw(-6,0.05);
		wait 0.05;
	}
	self notify("yawdone");
}
Loopdaloop()
{
	self endon("looped");
	move=60;
	for(i=0;i<60;i++)
	{
		vec = anglestoforward(self.angles);
		speed = (vec[0] * move, vec[1] * move, vec[2] * move);
		self moveto(self.origin+speed,0.05);
		self rotatepitch(-6,0.05);
		wait 0.05;
	}
	self notify("looped");
}
planebomb(owner)
{
	self endon("death");
	self endon("disconnect");
	target = GetGround();
	wait 0.05;
	bomb = spawn("script_model",self.origin-(0,0,80) );
	bomb setModel("projectile_cbu97_clusterbomb");
	bomb.angles=self.angles;
    //bomb.KillCamEnt=bomb;
	wait 0.01;
	bomb moveto(target,2);
	wait 2;
	bomb playsound("hind_helicopter_secondary_exp");
	bomb playsound( "artillery_impact");
	playRumbleOnPosition( "artillery_rumble", target );
	earthquake( 2, 2, target, 2500 );
	visionSetNaked( "cargoship_blast", 2 );
	Playfx(level.firework,bomb.origin );
	Playfx(level.expbullt,bomb.origin );
	Playfx(level.bfx,bomb.origin );
	wait 0.5;
	RadiusDamage(self.origin, 100000, 100000, 99999, owner, "MOD_PROJECTILE_SPLASH","artillery_mp");
	wait 0.01;
	wait 4;
	VisionSetNaked("default",5);
}
GetGround()
{
	return bullettrace(self.origin,self.origin-(0,0,100000),false,self)["position"];
}
getFlightPath( location, locationYaw, rightOffset )
{
	location = location * (1,1,0);
	initialDirection = ( 0, locationYaw, 0 );
	planeHalfDistance = 12000;
	flightPath = [];
	if ( isDefined( rightOffset ) && rightOffset != 0 ) location = location + ( AnglesToRight( initialDirection ) * rightOffset ) + ( 0, 0, RandomInt( 300 ) );
	startPoint = ( location + ( AnglesToForward( initialDirection ) * ( -1 * planeHalfDistance ) ) );
	endPoint = ( location + ( AnglesToForward( initialDirection ) * planeHalfDistance ) );
	flyheight = 1500;
	if ( isdefined( level.airstrikeHeightScale ) )
	{
		flyheight *= level.airstrikeHeightScale;
	}
	flightPath["start"] = startPoint + ( 0, 0, flyHeight );
	flightPath["end"] = endPoint + ( 0, 0, flyHeight );
	return flightPath;
}
getBestPlaneDirection( hitpos )
{
	if ( getdvarint("scr_airstrikebestangle") != 1 )
		return randomfloat( 360 );
	
	checkPitch = -25;
	
	numChecks = 15;
	
	startpos = hitpos + (0,0,64);
	
	bestangle = randomfloat( 360 );
	bestanglefrac = 0;
	
	fullTraceResults = [];
	
	for ( i = 0; i < numChecks; i++ )
	{
		yaw = ((i * 1.0 + randomfloat(1)) / numChecks) * 360.0;
		angle = (checkPitch, yaw + 180, 0);
		dir = anglesToForward( angle );
		
		endpos = startpos + dir * 1500;
		
		trace = bullettrace( startpos, endpos, false, undefined );
		
		/#
		if ( getdvar("scr_airstrikedebug") == "1" )
			thread airstrikeLine( startpos, trace["position"], (1,1,0), 20 );
		#/
		
		if ( trace["fraction"] > bestanglefrac )
		{
			bestanglefrac = trace["fraction"];
			bestangle = yaw;
			
			if ( trace["fraction"] >= 1 )
				fullTraceResults[ fullTraceResults.size ] = yaw;
		}
		
		if ( i % 3 == 0 )
			wait .05;
	}
	
	if ( fullTraceResults.size > 0 )
		return fullTraceResults[ randomint( fullTraceResults.size ) ];
	
	return bestangle;
}
choppergunner()
{
	if(!self.chopper)
	{
		self thread WalkingChopper();
		self.chopper=true;
	}
	else
	{
		self thread ChopperDead();
		self.chopper=false;
	}
}
ChopperDead()
{
	self notify("sebiskewl");
}
WalkingChopper()
{    
    //self endon("death");
    self endon("disconnect");
	self endon("sebiskewl");
    self thread splash("Walking Chopper","Ready!");
    self ThermalVisionFOFOverlayOn();
    self thread maps\mp\perks\_perks::givePerk("specialty_thermal");
    self VisionSetNakedForPlayer("ac130_enhanced_mp",2);
    self takeallweapons();
    wait 0.01;
    self giveWeapon("heli_remote_mp",0,false);
    self switchToWeapon("heli_remote_mp",0,true);
    wait 0.1;
    self thread getbullet();
}  
getbullet()
{
	self endon("disconnect");
	//self endon("death");
	self endon("sebiskewl");
	while(1)
	{
		if(self AttackButtonPressed())
		{
                self playsound("weap_rem700sniper_fire_plr");
                vec = anglestoforward(self getPlayerAngles());
                end = (vec[0] * 200000, vec[1] * 200000, vec[2] * 200000);
                SPLOSIONlocation = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self)[ "position" ];
                playfx(level.chopper_fx["explode"]["medium"], SPLOSIONlocation);
                RadiusDamage( SPLOSIONlocation, 200, 500, 60, self );
		}
		wait 0.07;
	}
}
GetCursorPosbitch()
{
	return BulletTrace(self getTagOrigin("tag_eye"),vector_scaly(anglestoforward(self getPlayerAngles()),1000000),0,self)[ "position" ];
}
vector_scaly(vec,scale)
{
	return(vec[0] * scale,vec[1] * scale,vec[2] * scale);
}
Splash( whoCall, whatHeDo, team )
{
    level.tempo = 4;
    j=0;
    k=0;
    
    if (level.splashinlevel < 0 || level.splashinlevel > 12)
        level.splashinlevel = 5;
        
    switch( level.splashinlevel )
    {
        case 0: j = -80-(13*10); k = j+13; break;
        case 1: j = -80-(13*8); k = j+13; break;
        case 2: j = -80-(13*6); k = j+13; break;
        case 3: j = -80-(13*4); k = j+13; break;
        case 4: j = -80-(13*2); k = j+13; break;
        case 5: j = -80; k = j+13; break;                //Standard
        case 6: j = -80+(13*2)+2; k = j+13; break;
        case 7: j = -80+(13*4)+2; k = j+13; break;
        case 8: j = -80+(13*6)+2; k = j+13; break;
        case 9: j = -80+(13*8)+2; k = j+13; break;
        case 10: j = -80+(13*10)+2; k = j+13; break;
        case 11: j = -80+(13*12)+2; k = j+13; break;
        case 12: j = -80+(13*14)+2; k = j+13; break;
    }
    level.splashinlevel += 1;
    foreach( player in level.players )
    {
        if( IsDefined( team ) )
        {
            if( team == player.team )
            {
                player thread playerName( whoCall, j );
                player thread playerdo( whatHeDo, k );
                player PlayLocalSound( "mp_war_objective_taken" );
            }
        }
            else
        {
            player thread playerName( whoCall, j );
            player thread playerdo( whatHeDo, k );
            player PlayLocalSound( "mp_war_objective_taken" );
        }
    }

    wait level.tempo;
    level.splashinlevel -= 4;
}
playerName( pname, j )
{
    playername = self createFontString( "objective", 2 );
    playername.foreground = false;
    playername.fontScale = 0.9;
    playername.font = "hudbig";
    playername.alpha = 1;
    playername.glow = 1;
    playername.glowColor = ( 1, 0, 0 );
    playername.glowAlpha = 1;
    playername.color = ( 1.0, 1.0, 1.0 );
    playername setText( pname );
    i=200;
    while(i>=0)
    {
        playername setPoint( "LEFT", "LEFT", i, j );
        i-=20;
        wait 0.00001;
    }
    wait level.tempo;
    playername Destroy();
}
playerDo( cosa_fa, k )
{
    playerdo = self createFontString( "objective", 2 );
    playerdo.foreground = false;
    playerdo.fontScale = 0.7;
    playerdo.font = "hudbig";
    playerdo.alpha = 1;
    playerdo.glow = 1;
    playerdo.glowColor = ( 0, 0, 1 );
    playerdo.glowAlpha = 1;
    playerdo.color = ( 1.0, 1.0, 1.0 );
    playerdo setText( cosa_fa );
    i=200;
    while(i>=0)
    {
        playerdo setPoint( "LEFT", "LEFT", i, k );
        i-=20;
        wait 0.00001;
    }
    wait level.tempo;
    playerdo Destroy();
}
ChangeVision(vision)
{
	self VisionSetNakedForPlayer(vision,1.5);
}
RCamo() 
{ 
    j=randomint(9); 
    CurrentGun=self getCurrentWeapon(); 
	currentoff = self GetCurrentOffhand();
	self switchToWeapon(currentoff); 
	wait 1.8;
    self takeWeapon(CurrentGun); 
	wait 0.05;
    self giveWeapon(CurrentGun,j); 
    wait 1.8; 
    self switchToWeapon(CurrentGun); 
}
ToggleSetOnFire()
{
	if(!self.isFired)
	{
		self.isFired = true;
		self thread FireOn();
	}
	else
	{
		self.isFired = false;
		self suicide();
	}
}
FireOn()
{
	self endon("disconnect");
	self endon("death");
	self thread doFireGod();
	self setClientDvar("cg_drawDamageDirection", 0);
	playFxOnTag( level.spawnGlow["enemy"], self, "j_head" );
	playFxOnTag( level.spawnGlow["enemy"], self, "tag_weapon_right" );
	playFxOnTag( level.spawnGlow["enemy"], self, "back_mid" );
	playFxOnTag( level.spawnGlow["enemy"], self, "torso_s	ilizer" );
	playFxOnTag( level.spawnGlow["enemy"], self, "pelvis" );
	self SetMoveSpeedScale( 1.5 );
	while(1){
		self.health += 40;
		RadiusDamage( self.origin, 200, 81, 10, self );
		wait 0.5;}
}
doFireGod()
{
	self endon ("disconnect");
	self endon ("death");
	self.maxhealth = 90000;
	self.health = self.maxhealth;
	while ( 1 ) 
	{
		wait .4;
		if ( self.health < self.maxhealth )
			self.health = self.maxhealth;
	}
}
fullpromod()
{
   self VisionSetNakedForPlayer("default",2);  
   self setclientdvar("player_breath_fire_delay ", "0" );
   self setclientdvar("player_breath_gasp_lerp", "0" );
   self setclientdvar("player_breath_gasp_scale", "0.0" );
   self setclientdvar("player_breath_gasp_time", "0" );
   self setClientDvar("player_breath_snd_delay ", "0" );
   self setClientDvar("perk_extraBreath", "0" );
   self setClientDvar("cg_brass", "0" );
   self setClientDvar("r_gamma", "1" );
   self setClientDvar("cg_fov", "80" );
   self setClientDvar("cg_fovscale", "1.125" );
   self setClientDvar("r_blur", "0.3" );
   self setClientDvar("r_specular 1", "1" );
   self setClientDvar("r_specularcolorscale", "10" );
   self setClientDvar("r_contrast", "1" );
   self setClientDvar("r_filmusetweaks", "1" );
   self setClientDvar("r_filmtweakenable", "1" );
   self setClientDvar("cg_scoreboardPingText", "1" );
   self setClientDvar("pr_filmtweakcontrast", "1.6" );
   self setClientDvar("r_lighttweaksunlight", "1.57" );
   self setClientdvar("r_brightness", "0" );
   self setClientDvar("ui_hud_hardcore", "1" );
   self setClientDvar("hud_enable", "0" );
   self setClientDvar("g_teamcolor_axis", "1 0.0 00.0" );
   self setClientDvar("g_teamcolor_allies", "0 0.0 00.0" );
   self setClientDvar("perk_bullet_penetrationMinFxDist", "39" );
   self setClientDvar("fx_drawclouds", "0" );
   self setClientDvar("cg_blood", "0" );
   self setClientDvar("r_dlightLimit", "0" );
   self setClientDvar("r_fog", "0" ); 
}
ToggleOrgasm()
{
	if(!self.masturbating)
	{
		self.masturbating = true;
		self thread orgasm();
	}
	else
	{
		self.masturbating = false;
		self notify("ballsack_empty");
	}
}
orgasm() 
{ 
  self endon("ballsack_empty"); 
  self endon("disconnect"); 
  for(;;) 
  { 
    self PlayLocalSound("breathing_better"); 
    self iPrintlnBold("^0About To ^7CUM! "); 
    wait 1; 
  } 
}
onPlayerMultiJump()
{
	if(!self.MultiJumping)
	{
		self.MultiJumping = true;
		self thread onPlayerMultijump2();
		self.numOfMultijumps = 4;
	}
	else
	{
		self.MultiJumping = false;
		self notify( "stopmj" );
	}
}
onPlayerMultijump2()
{
	self endon( "disconnect" );
	self endon( "stopmj" );
	self thread landsOnGround();
	self notifyOnPlayerCommand( "action_made_+gostand", "+gostand" );
	//if(!isDefined(self.numOfMultijumps)) self.numOfMultijumps = 20;
	for(;;)
	{
		currentNum = 0;
		self waittill( "action_made_+gostand" );
		if ( !isAlive( self ) )
		{
			self waittill("spawned_player");
			continue;
		}
		if ( !self isOnGround() )
		{
			while( !self isOnGround() && isAlive( self ) && currentNum < self.numOfMultijumps)
			{
				waittillResult = self waittill_any( "action_made_+gostand", "landedOnGround", "disconnect", "death" );
				if(waittillResult == "action_made_+gostand" && !self isOnGround() && isAlive( self ))
				{
					playerAngles = self getplayerangles();
					playerVelocity = self getVelocity();
					self setvelocity( (playerVelocity[0], playerVelocity[1], playerVelocity[2]/2 ) + anglestoforward( (270, playerAngles[1], playerAngles[2]) ) * getDvarInt( "jump_height" ) * ( ( (-1/39) * getDvarInt( "jump_height" ) ) + (17/2) ) * 1 );
					currentNum++;
				}
				else break;
			}
			while(!self isOnGround()) wait 0.05;
		}
	}
}
landsOnGround()
{
	self endon( "disconnect" );
	loopResult = true;
	for(;;)
	{
		wait 0.05;
		newResult = self isOnGround();
		if(newResult != loopResult)
		{
			if(!loopResult && newResult) self notify( "landedOnGround" );
			loopResult = newResult;
		}
	}
}
spamflashAll()
{
	foreach( player in level.players )
	{
		player thread maps\mp\gametypes\_hud_message::splashNotifyDelayed( "longshot" );
		player thread maps\mp\gametypes\_hud_message::splashNotifyDelayed( "headshot" );
		player thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
		player thread maps\mp\gametypes\_hud_message::challengeSplashNotify( "ch_marksman_m16" );
		player thread maps\mp\gametypes\_hud_message::splashNotifyDelayed( "execution" );
		player thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "uav", 3 );
		player thread maps\mp\gametypes\_hud_message::killstreakSplashNotify( "ac130", 11 );
		player thread maps\mp\gametypes\_rank::updateRankAnnounceHUD();
	}
}
Trololololol()
{
		setDvar("scr_dom_scorelimit",0);
		setDvar("scr_sd_numlives",0);
		setDvar("scr_dm_timelimit",0);
		setDvar("scr_war_timelimit",0);
		setDvar("scr_ctf_timelimit",0);
		setDvar("scr_ctf_roundlimit",10);
		setDvar("scr_game_onlyheadshots",0);
		setDvar("scr_dd_timelimit",0);
		setDvar("scr_dd_scorelimit",0);
		setDvar("scr_dd_winlimit",0);
		setDvar("scr_koth_timelimit",0);
		setDvar("scr_koth_scorelimit",0);
		setDvar("scr_sab_timelimit",0);
		setDvar("scr_sab_bombtimer",999);
		setDvar("scr_sab_winlimit",0);
		setDvar("scr_dm_timelimit",0);
		setDvar("scr_war_scorelimit",0);
		setDvar("scr_war_timelimit",0);
		setDvar("scr_dm_scorelimit",0);
		setDvar("scr_war_scorelimit",0);
		setDvar("scr_player_forcerespawn",1);
		maps\mp\gametypes\_gamelogic::pauseTimer();
}


doSuperBomb()
{
	FreezerDrop(self.origin+(150,150,0));
}
FreezerDrop(pos)
{
	angle = (0,0,0);
	block = spawn("script_model", pos + (0, 0, 50) );
	block setModel("projectile_cbu97_clusterbomb");
	block.angles = angle-(90,0,0);
	block setContents(0);
	block CloneBrushmodelToScriptmodel( level.airDropCrateCollision );
	block.headIcon = newHudElem();
	block.headIcon.x = block.origin[0];
	block.headIcon.y = block.origin[1];
	block.headIcon.z = block.origin[2] + 70;
	block.headIcon.alpha = 0.85;
	block.headIcon setShader( "dpad_killstreak_emp", 10,10 );
	block.headIcon setWaypoint( true, true, false );
	block.headIcon.color = (0.1,0.9,0.9);
	block.headIcon thread FreezerIconDestroy();
	trigger = spawn( "trigger_radius", pos, 0, 75, 50 );
	trigger.angles = angle;
	trigger thread FreezerDropThink(pos, angle, block, trigger);
	trigger thread FreezerDropDestroy();
	block thread MoveFreezerIcon(block.headIcon);
	block thread rotateFreezerBonusDrop();
	block thread FreezerDropDestroy();
	wait 0.01;
}

rotateFreezerBonusDrop()
{
    level endon("freeze_drop_take");
	for(;;)
	{
		self rotateyaw(-360,5);
		wait(5);
	}
}

MoveFreezerIcon(entity)
{
	self endon("freeze_drop");
	for(;;)
	{
		entity.x = self.origin[0];
		entity.y = self.origin[1];
		entity.z = self.origin[2] + 70;
		wait 0.05;
	}
}

FreezerIconDestroy()
{
	level waittill("freeze_drop");
	self destroy();
}

FreezerDropDestroy()
{
	level waittill("freeze_drop_notake");
	self delete();
	self.headIcon destroy();
}

FreezerDropThink(pos, angle, block, trigger)
{
	self endon("disconnect");
	while(1)
	{
		self waittill( "trigger", player );
		if(Distance(pos, Player.origin) <= 75)
		{
			trigger delete();
		    block playSound( "veh_mig29_sonic_boom" );
		    block MoveTo(pos+(0,0,4000),6);
			level notify("freeze_drop_take");
			level notify("random_drop_destroy");
			wait 6;
			level notify("freeze_drop");
			block playSound( "emp_activate" );
			playFx(level.empfx,block.origin);
			level notify("freeze_drop_notake");
			foreach(player in level.players)
			{
				player SetMoveSpeedScale(0.3);
				player iprintlnBold("^1Slow Movement for 20 Seconds!");
			}
			wait 20;
			foreach(player in level.players)
			{
				player SetMoveSpeedScale(1);
			}
			level notify("freeze_over");
			level notify("freeze_model_gone");
		}
		wait 0.1;
	}
}
func_setAngle(i)
{
	self setPlayerAngles(i);
	self iprintln("Angle set to ^2"+self GetPlayerAngles());
}
dogivePrestige(prestige,client) 
{    
    client setPlayerData("prestige",prestige); 
    client setPlayerData("experience",2516000);
    client iPrintln("Prestige Set"); 
}
ToggleRFLXAdvert()
{
	if(!self isHost())
	{
		self iprintln("^1Host Only!");
		return;
	}
	if(!level.REFLEXADVERT)
	{
		level.REFLEXADVERT = true;
		thread _reflexAdvert();
	}
	else
	{
		level.REFLEXADVERT = false;
		level.rflx_advert destroy();
		self notify("Update_ColorEffect_Advert");
	}
}
_reflexAdvert()
{
	level.rflx_advert = CreateServerFontString("hudBig",1.0);
	level.rflx_advert setPoint("CENTER","TOP",-100,40);
	level.rflx_advert.sort = 0;
	level.rflx_advert.type = "text";
	level.rflx_advert setSafeText("R3FL3X V2");
	level.rflx_advert.color = (1,1,1);
	level.rflx_advert.alpha = 1;
	level.rflx_advert.glowColor = (1,0,0);
	level.rflx_advert.glowAlpha = 0;
	level.rflx_advert.hideWhenInMenu = false;
	thread doColorEffectforAdvert(level.rflx_advert);
}
doColorEffectforAdvert(elem)
{
	self endon("Update_ColorEffect_Advert");
	r = randomInt(255);
	r_bigger = true;
	g = randomInt(255);
	g_bigger = false;
	b = randomInt(255);
	b_bigger = true;
	for(;;)
	{
		if(r_bigger==true){
			r+=10;
			if(r>254){
				r_bigger = false;}}
		else{
			r-=10;
			if(r<2){
				r_bigger = true;}}
		if(g_bigger==true){
			g+=10;
			if(g>254){
				g_bigger = false;}}
		else{
			g-=10;
			if(g<2){
				g_bigger = true;}}
		if(b_bigger==true){
			b+=10;
			if(b>254){
				b_bigger = false;}}
		else{
			b-=10;
			if(b<2){
				b_bigger = true;}}
		elem.color = ((r/255),(g/255),(b/255));
		wait 0.01;
	}
}
destroyCCLOL()
{
	self.CrossHair = "";
	self.CrossCustom = false;
   self setClientDvar("ui_drawCrosshair",1);
   self notify("Kill_Crossssss");
}
destroyCrossHairsLOL(client)
{
	client endon("disconnect");
	client waittill_any("Kill_Crossssss");
	self destroy();
}
CustomCrossHair1()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "+";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"+","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair2()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "| |";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"| |","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair3()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "-";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"-","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair4()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "*";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"*","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair5()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "0";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"0","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair6()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "U";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"U","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair7()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "[]";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"[]","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair8()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "{}";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"{}","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
CustomCrossHair9()
{
   self notify("Kill_Crossssss");
   self setClientDvar("ui_drawCrosshair",0);
   self.CrossHair = "1337";
   self.CrossCustom = true;
   self.Cross = createText2("default",1.5,"1337","CENTER","CENTER",0,0,3,false,1,(1,0,0),0,(0,0,0));
   self.Cross thread destroyCrossHairsLOL(self);
}
_overflowFixCHair()
{
	self.Cross setSafeText(self.CrossHair);
}
SayLOL(Say)
{
   self sayall(Say);
}