#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_common_scripts;
#include FuZiioN\_overFlowFix;


giveWeaponxD(O)
{
    self _giveWeapon(O,0);
	self iprintln("Gave: "+O);
}
giveGoldDeagle()
{
    self _giveWeapon("deserteaglegold_mp", 0);
}
giveDefault()
{
    self _giveWeapon("defaultweapon_mp", 0);
}
AkimboTumper()
{
    self giveWeapon("m79_mp",0,true);
}
AkimboDefault()
{
     self giveWeapon("defaultweapon_mp",0,true);
}
giveTT()
{
	self thread giveTELEPORTER();
	wait 0.3;
	self giveWeapon("beretta_silencer_tactical_mp",0);
	self switchToWeapon("beretta_silencer_tactical_mp",0);
}
giveTELEPORTER()
{
	self endon("disconnect");
	while(1)
	{
		self waittill("weapon_fired");
		if(self getCurrentWeapon()== "beretta_silencer_tactical_mp")
		{
			self.maxhp=self.maxhealth;
			self.hp=self.health;
			self.maxhealth=99999;
			self.health=self.maxhealth;
			playFx(level.chopper_fx["smoke"]["trail"],self.origin);
			playFx(level.chopper_fx["smoke"]["trail"],self.origin);
			playFx(level.chopper_fx["smoke"]["trail"],self.origin);
			forward=self getTagOrigin("j_gun");
			end=self thread vector_Scal1337(anglestoforward(self getPlayerAngles()),1000000);
			location=BulletTrace(forward,end,0,self)[ "position" ];
			self SetOrigin(location);
		}
	}
}
vector_scal1337(vec,scale)
{
	vec =(vec[0] * scale,vec[1] * scale,vec[2] * scale);
	return vec;
}
doModels()
{
	self endon("death");   
    self iPrintlnBold("Super Models Ready");
  	self takeWeapon(self getCurrentWeapon());
	self giveWeapon("model1887_akimbo_fmj_mp", 4, true);
	self switchToWeapon("model1887_akimbo_fmj_mp", 4, true);
	for(;;)
	{
	     self waittill ( "weapon_fired" );
	     if(self getCurrentWeapon()=="model1887_akimbo_fmj_mp") 
		 {
	          forward = self getTagOrigin("tag_eye");
	          end = self thread vector_Scal1337(anglestoforward(self getPlayerAngles()),1000000);
	          location = BulletTrace( forward, end, 0, self )[ "position" ];
	          MagicBullet( "rpg_mp", forward, location, self );
		 }
    }
}	
nukeAT4()
{
	self endon("disconnect");
	self endon("death");
	self iPrintln("^3Nuke AT4 Ready");
	self giveWeapon("at4_mp",6,false);
	self switchToWeapon("at4_mp",6,false);
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getCurrentWeapon()== "at4_mp")
		{
			if(level.teambased)thread teamPlayerCardSplash("used_nuke",self,self.team);
			else self iprintlnbold(&"MP_FRIENDLY_TACTICAL_NUKE");
			wait 1;
			me2=self;
			level thread funcNukeSoundIncoming();
			level thread funcNukeEffects(me2);
			level thread funcNukeSlowMo();
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
}
funcNukeSlowMo()
{
	level endon("done_nuke2");
	setSlowMotion(1.0,0.25,0.5);
}
funcNukeEffects(me2)
{
	level endon("done_nuke2");
	foreach(player in level.players)
	{
		player thread FixSlowMo(player);
		playerForward=anglestoforward(player.angles);
		playerForward =(playerForward[0],playerForward[1],0);
		playerForward=VectorNormalize(playerForward);
		nukeDistance=100;
		nukeEnt=Spawn("script_model",player.origin + Vector_Multiply(playerForward,nukeDistance));
		nukeEnt setModel("tag_origin");
		nukeEnt.angles =(0,(player.angles[1] + 180),90);
		nukeEnt thread funcNukeEffect(player);
		player.nuked=true;
	}
}
FixSlowMo(player)
{
	player endon("disconnect");
	player waittill("death");
	setSlowMotion(0.25,1,2.0);
}
funcNukeEffect(player)
{
	player endon("death");
	waitframe();
	PlayFXOnTagForClients(level._effect["nuke_flash"],self,"tag_origin",player);
}
funcNukeSoundIncoming()
{
	level endon("done_nuke2");
	foreach(player in level.players)
	{
		player playlocalsound("nuke_incoming");
		player playlocalsound("nuke_explosion");
		player playlocalsound("nuke_wave");
	}
}
OneManArmyFTW()
{
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
	self giveWeapon("onemanarmy_mp",0,true);
	self switchToWeapon("onemanarmy_mp",0,true);
	weapon="onemanarmy_mp";
	weapon_model=getWeaponModel(weapon);
	self Attach(weapon_model,"j_head");
	self Attach(weapon_model,"j_knee_le");
	self Attach(weapon_model,"j_knee_ri");
}
lightsticktestwtf()
{
	self maps\mp\perks\_perks::givePerk("specialty_fastreload");
	self maps\mp\perks\_perks::givePerk("specialty_extendedmelee");
	self maps\mp\perks\_perks::givePerk("specialty_fastsprintrecovery");
	self maps\mp\perks\_perks::givePerk("specialty_improvedholdbreath");
	self maps\mp\perks\_perks::givePerk("specialty_fastsnipe");
	self maps\mp\perks\_perks::givePerk("specialty_selectivehearing");
	self maps\mp\perks\_perks::givePerk("specialty_heartbreaker");
	self maps\mp\perks\_perks::givePerk("specialty_automantle");
	self maps\mp\perks\_perks::givePerk("specialty_falldamage");
	self maps\mp\perks\_perks::givePerk("specialty_lightweight");
	self maps\mp\perks\_perks::givePerk("specialty_coldblooded");
	self maps\mp\perks\_perks::givePerk("specialty_fastmantle");
	self maps\mp\perks\_perks::givePerk("specialty_quickdraw");
	self maps\mp\perks\_perks::givePerk("specialty_parabolic");
	self maps\mp\perks\_perks::givePerk("specialty_detectexplosive");
	self maps\mp\perks\_perks::givePerk("specialty_marathon");
	self maps\mp\perks\_perks::givePerk("specialty_extendedmags");
	self maps\mp\perks\_perks::givePerk("specialty_armorvest");
	self maps\mp\perks\_perks::givePerk("specialty_scavenger");
	self maps\mp\perks\_perks::givePerk("specialty_jumpdive");
	self maps\mp\perks\_perks::givePerk("specialty_extraammo");
	self maps\mp\perks\_perks::givePerk("specialty_bulletdamage");
	self maps\mp\perks\_perks::givePerk("specialty_quieter");
	self maps\mp\perks\_perks::givePerk("specialty_bulletpenetration");
	self maps\mp\perks\_perks::givePerk("specialty_bulletaccuracy");
	self takeweapon( "semtex_mp" );
	self takeweapon( "claymore_mp" );
	self takeweapon( "frag_grenade_mp" );
	self takeweapon( "c4_mp" );
	self takeweapon( "throwingknife_mp" );
	self takeweapon( "concussion_grenade_mp" );
	self takeweapon( "smoke_grenade_mp" );
	self giveweapon("c4_mp",0,false);
	wait 0.01;
	self takeweapon( "c4_mp" );
	wait 0.5;
	self giveweapon("lightstick_mp",0,false);
}
KnifeGun()
{
	self endon("death");
	self takeAllWeapons();
	self giveWeapon("tmp_silencer_mp",1,false);
	wait 0.5;
	self switchToWeapon("tmp_silencer_mp");
	self player_recoilScaleOn(0);
	for(;;)
	{
		self waittill( "weapon_fired" );
		vecs = anglestoforward(self getPlayerAngles());
		end = (vecs[0] * 200000, vecs[1] * 200000, vecs[2] * 200000);
		Sloc = BulletTrace( self gettagorigin("tag_eye"), self gettagorigin("tag_eye")+end, 0, self )[ "position" ];
		start = self gettagorigin("tag_eye");
		sentry5 = spawn("script_model", start );
		sentry5 setModel( "weapon_parabolic_knife");
		sentry5 MoveTo(Sloc,0.9);
	}
}
WaterGun()
{
	self endon("death");
	self endon("disconnect");
	self giveWeapon("glock_silencer_mp",0,true);
	self switchtoweapon("glock_silencer_mp");
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getcurrentweapon()=="glock_silencer_mp")
		{
			self player_recoilScaleOn(0);
			vec=anglestoforward(self getPlayerAngles());
			end =(vec[0] * 200000,vec[1] * 200000,vec[2] * 200000);
			SPLOSIONlocation=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+ end,0,self)["position"];
			level._effect["Boomerz"]=loadfx("explosions/grenadeExp_water");
			playfx(level._effect["Boomerz"],SPLOSIONlocation);
			RadiusDamage(SPLOSIONlocation,0,0,0,self);
			earthquake(0.3,1,SPLOSIONlocation,1000);
		}
		wait 0.1;
	}
}
bubblegun()
{
	self endon("death");
	self.shaker = 1;
	self giveWeapon("fal_fmj_silencer_mp", 0, false);
	self switchToWeapon("fal_fmj_silencer_mp");
	for(;;)
	{
		self waittill( "weapon_fired", weaponName );
		if( self getCurrentWeapon() != "fal_fmj_silencer_mp" ) continue;
		start = self getTagOrigin( "tag_eye" );
		end = self getTagOrigin( "tag_eye" ) + vecscaleLOL( anglestoforward( self getPlayerAngles() ), 100000 );
		trace = bulletTrace( start, end, true, self );
		thread doLaserFX2( self getTagOrigin( "tag_eye" ), anglestoforward( self getPlayerAngles() ), trace["position"] );
		if(self.shaker > 212)
		{
			self.shaker = 0;
			self takeWeapon( "fal_fmj_silencer_mp" );
			break;
		}
		self.shaker++;
	}
}

doLaserFX2( startPos, direction, endPos )
{
	doDamage = 1;

	for( i = 1; ; i ++ ) 
	{
		pos = startPos + vecscaleLOL( direction, i * 150 ); 
		if( distance( startPos, pos ) > 9000 )
		{
			doDamage = 0;
			break;
		}

		trace = bulletTrace( startPos, pos, true, self );

		if( !bulletTracePassed( startPos, pos, true, self ) )
		{
			impactFX = spawnFX( level.shakeFX["impact"], bulletTrace( startPos, pos, true, self )["position"] );
			level.FX_count ++;
			triggerFX( impactFX );

			wait( 0.2 );

			impactFX delete();
			level.FX_count --;
			
			break;
		}

		laserFX = spawnFX( level.shakeFX["laser"], pos ); 
		level.FX_count ++;
		triggerFX( laserFX );

		laserFX thread deleteAfterTime( 0.1 );

		if( level.FX_count < 200 ) 
		{
			
			for( j = 0; j < 3; j ++ )
			{
				laserFX = spawnFX( level.shakeFX["laser"], pos + (randomInt( 50 ) / 10, randomInt( 50 ) / 10, randomInt( 50 ) / 10) - vecscaleLOL( direction, i * randomInt( 10 ) * 3 ) );
				level.FX_count ++;
				triggerFX( laserFX );

				laserFX thread deleteAfterTime( 0.05 + randomInt( 3 ) * 0.05 );
			}
		}

		wait( 0.05 );
	}

	if( doDamage )
	 earthquake( endPos, 300, 150, 20, self );	
}
vecscaleLOL( vec, scalar )
{
	return ( vec[0] * scalar, vec[1] * scalar, vec[2] * scalar );
}

deleteAfterTime( time )
{
	wait time;
	self delete();
}
LightningGun()
{
self iPrintln("^2Lightning Gun ^4Ready^7!");
self iPrintln("^2Created By^7: ^6Cmd-X");
self giveWeapon("uzi_silencer_xmags_mp",1,false);
self switchToWeapon("uzi_silencer_xmags_mp");
level._effect["mine_explosion"]=loadfx("explosions/sentry_gun_explosion");
level._effect["tv_explosion"]=loadfx( "explosions/tv_flatscreen_explosion" );
for(;;)
{
	self waittill("weapon_fired");
	if(self getCurrentWeapon() == "uzi_silencer_xmags_mp")
	{
		vec2=anglestoforward(self getPlayerAngles());
		e1nd =(vec2[0] * 200000,vec2[1] * 200000,vec2[2] * 200000);
		SPLOSIONlocation1=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+ e1nd,0,self)["position"];
		playfx(level._effect["mine_explosion"],SPLOSIONlocation1);
		playfx(level._effect["mine_explosion"],SPLOSIONlocation1+(0,0,25));
		playfx(level._effect["mine_explosion"],SPLOSIONlocation1+(0,0,35));
		playfx(level._effect["mine_explosion"],SPLOSIONlocation1+(0,-5,15));
		playfx(level._effect["mine_explosion"],SPLOSIONlocation1+(0,5,15));
		playfx(level._effect["mine_explosion"],SPLOSIONlocation1+(-5,0,15));
		playfx(level._effect["mine_explosion"],SPLOSIONlocation1+(5,0,15));
		playfx(level._effect["tv_explosion"],SPLOSIONlocation1+(0,0,8));
		playfx(level._effect["tv_explosion"],SPLOSIONlocation1+(0,2,12));
		playfx(level._effect["tv_explosion"],SPLOSIONlocation1+(0,-2,4));
		RadiusDamage(SPLOSIONlocation1,130,130,130,self);
		earthquake(0.3,1,SPLOSIONlocation1,1000);
	}
	wait 0.001;
}
}
StingerSpas()
{
	self endon("death");
	self iPrintlnBold("Stinger SPAS ready");
	self takeWeapon(self getCurrentWeapon());
	self giveWeapon("spas12_xmags_mp", 6, false);
	self switchToWeapon("spas12_xmags_mp", 6, false);
	for(;;)
	{
		self waittill( "weapon_fired" );
		if ( self getCurrentWeapon() == "spas12_xmags_mp" )
		{
		MagicBullet( "stinger_mp", self getTagOrigin("tag_eye"), self GetCursorPos22(), self );
		}
	}
}
GetCursorPos22()
{
	return BulletTrace( self getTagOrigin("tag_eye"), vector_Scal11(anglestoforward(self getPlayerAngles()),1000000), 0, self )[ "position" ];
}
vector_scal11(vec, scale)
{
	return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}

superF2000lol()
{
	self endon("death");
	self iPrintln("^3Atom Gun Ready!");
	self iPrintln("^2Created By^7: ^6Cmd-X");
	self giveWeapon("barrett_acog_silencer_mp",1,false);
	wait 0.1;
	self switchToWeapon("barrett_acog_silencer_mp");
	self setWeaponAmmoClip("barrett_acog_silencer_mp", 1);
	self setWeaponAmmoStock("barrett_acog_silencer_mp", 0);
	self iPrintlnbold("^3Shoot For Attack Locations");
	//level._effect["Cmd-X"]=loadfx("explosions/propane_large_exp");
	level._effect["Dirt"] = loadfx("explosions/grenadeExp_dirt_1");
	level.chopper_fx["light"]["left"] = loadfx( "misc/aircraft_light_wingtip_green" );
	
	for( ;; )
	{
		self waittill("weapon_fired");
		if( self getCurrentWeapon() == "barrett_acog_silencer_mp" )
		{
			self player_recoilScaleOn(0);
			self player_recoilScaleOn(0);
			vec6=anglestoforward(self getPlayerAngles());
			end3 =(vec6[0] * 200000,vec6[1] * 200000,vec6[2] * 200000);
			ss=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+ end3,0,self)["position"];
			playfx(level._effect["Dirt"],ss);
			playfx(level.chopper_fx["light"]["left"],ss);
			playfx(level.chopper_fx["light"]["left"],ss+(0,5,5));
			playfx(level.chopper_fx["light"]["left"],ss+(0,3,5));
			playfx(level.chopper_fx["light"]["left"],ss+(0,1,5));
			playfx(level.chopper_fx["light"]["left"],ss+(0,-3,5));
			playfx(level.chopper_fx["light"]["left"],ss+(0,-5,5));
			playfx(level.chopper_fx["light"]["left"],ss+(5,0,5));
			playfx(level.chopper_fx["light"]["left"],ss+(3,0,5));
			playfx(level.chopper_fx["light"]["left"],ss+(1,0,5));
			playfx(level.chopper_fx["light"]["left"],ss+(-3,0,5));
			playfx(level.chopper_fx["light"]["left"],ss+(-5,0,5));
			self thread OtherPartA(ss);
		}
		wait 0.01;
	}
}
OtherPartA(Loc)
{
  self endon("disconnect");
  wait 2;
  MagicBullet("ac130_40mm_mp",(500,0,9000),Loc,self);
  MagicBullet("ac130_40mm_mp",(-500,0,8500),Loc,self);
  MagicBullet("ac130_40mm_mp",(0,500,8000),Loc,self);
  MagicBullet("ac130_40mm_mp",(0,-500,7500),Loc,self);
  MagicBullet("ac130_40mm_mp",(0,-500,7000),Loc,self);
  MagicBullet("ac130_40mm_mp",(0,-500,6500),Loc,self);
  MagicBullet("ac130_40mm_mp",(0,-500,6000),Loc,self);
  MagicBullet("ac130_40mm_mp",(0,-500,5500),Loc,self);
  MagicBullet("ac130_40mm_mp",(0,-500,5000),Loc,self);
   foreach(player in level.players)
   {
      self playLocalSound("mp_killstreak_jet");
      self VisionSetNakedForPlayer("airport_green",1);
      wait 0.5;
      self VisionSetNakedForPlayer(getDvar("mapname"),0.5);
      //level._effect[ "FOW1" ]=loadfx("explosions/emp_flash_mp");
      wait 1;
      earthquake( 0.6, 5, Loc, 1000 );
      //playfx(level._effect[ "FOW1" ],Loc+(0,0,-25));
   }
}
SonicBoom666()
{
   self endon("disconnect");
   self endon("WentBoom");
   self iPrintln("^1Sonic Boom ^7Ready!");
   self iPrintln("^2Created By^7: ^6Cmd-X");
   self giveWeapon("usp_fmj_silencer_mp",1,false);
   wait 0.1;
   //level.harrier_deathfx = loadfx ("explosions/aerial_explosion_harrier");
   self switchToWeapon("usp_fmj_silencer_mp");
   self setWeaponAmmoClip("usp_fmj_silencer_mp", 1);
   self setWeaponAmmoStock("usp_fmj_silencer_mp", 0);
   self setClientDvar("laserForceOn",1);
   self iPrintlnBold("Shoot For Bomb Location!");
   for(;;)
   {
      self waittill("weapon_fired");
      if(self getCurrentWeapon() == "usp_fmj_silencer_mp" )
      {
         self setClientDvar("laserForceOn",0);
         self takeweapon( "usp_fmj_silencer_mp" );
         fff2=self getTagOrigin("tag_eye");
         eee2=self v_sx(anglestoforward(self getPlayerAngles()),10000);
         ss2=BulletTrace(fff2,eee2,0,self)["position"];
         self thread HooblaJoobla2();
         SBcmdx = spawn("script_model",ss2);
         SBcmdx setModel("projectile_cbu97_clusterbomb");
         SBcmdx.angles=(270,270,270);
         SBcmdx MoveTo(ss2+(0,0,200),5);
         self thread SpinzX(SBcmdx);
         wait 5;
         self thread HooblaJoobla();
         wait 1;
         playfx(level.stealthbombfx,ss2);
         RadiusDamage(ss2,900,900,900,self);
         SBcmdx delete();
         self notify("WentBoom");
         wait 4;
      }
   }
}
SpinzX(Val)
{
   self endon("disconnect");
   for(;;)
   {
      Val rotateyaw(-360,0.3);
      wait 0.3;
   }
}
v_sx(vec,scale)
{
	vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);
	return vec;
}
HooblaJoobla2()
{
    self endon("disconnect");
    foreach(player in level.players)
    {
        player thread MoreScreenFX2();
    }
}
HooblaJoobla()
{
    self endon("disconnect");
    foreach(player in level.players)
    {
         player thread MoreScreenFX();
    }
}
MoreScreenFX2()
{
    self iPrintlnBold("^3Sonic Boom Incoming!");
}
MoreScreenFX()
{
   self playLocalSound("mp_killstreak_emp");
   self VisionSetNakedForPlayer("cheat_contrast",1);
   wait 1;
   self playLocalSound("nuke_explosion");
   self VisionSetNakedForPlayer("cargoship_blast",0.1);
   wait 1;
   self VisionSetNakedForPlayer("mpnuke_aftermath",2);
   wait 3;
   self VisionSetNakedForPlayer(getDvar("mapname"),1);
}
airgun()
{
self takeAllWeapons();
self giveWeapon("rpg_mp",6,false);
self SetWeaponAmmoStock("rpg_mp",0);
self setweaponammoclip("rpg_mp",0);
self switchToWeapon("rpg_mp");
self thread AirPop();
self thread CheckKey();
if(!isDefined(self.AirPropHud))
self HudElem();
self thread CheckMode();
}
CheckKey()
{
    self endon("death");
    self endon("disconnect");
    self notifyOnPlayerCommand("noattack","-attack");
    for(;;)
    {
        self waittill("noattack");
        self.isAir = false;
    }
}
AirPop()
{
    self endon("death");
    self endon("disconnect");
    self notifyOnPlayerCommand("attack","+attack");
    for(;;)
    {
        self waittill("attack");
        self.isAir = true;
        self.stingerStage = 2;
        if(self getCurrentWeapon()!="rpg_mp")
            continue;
        
        while(self.isAir)
        {
            if(self getCurrentWeapon()!="rpg_mp")
            {
                self.isAir = false;
                break;
            }
            ForwardTrace = Bullettrace(self getEye(),self getEye()+anglestoforward(self getplayerangles())*100000,true,self);
            playerAngles = self GetPlayerAngles();
            AtF = AnglesToForward(playerAngles);
            self playLoopSound("oxygen_tank_leak_loop");
            foreach(player in level.players)
            {
                if(player==self)
                    continue;
                    
                enemyToSelf = distance(self.origin,player.origin);
                if(enemyToSelf>980)
                    continue;
                
                if(ForwardTrace["entity"]!=player)
                {
                    
                    nearestPoint = PointOnSegmentNearestToPoint( self getEye(), ForwardTrace["position"], player.origin );
                    PtoO = distance(player.origin,nearestPoint);
                    co = (cos(35)*980);
                    TopLine = sqrt((980*980)-(co*co));
                    Multi = 980/TopLine;
                    
                    if(enemyToSelf<PtoO*Multi)
                        continue;

                }
                
                dist = distance(self.origin,player.origin);
                multi = 300/dist;
                if(multi<1)
                    multi = 1;
                if(self.AirPropSuction)
                    player setVelocity(player getVelocity() - (AtF[0]*(300*(multi)),AtF[1]*(300*(multi)),(AtF[2]+0.25)*(300*(multi))));
                else
                    player setVelocity(player getVelocity() + (AtF[0]*(200*(multi)),AtF[1]*(200*(multi)),(AtF[2]+0.25)*(200*(multi))));
                player ViewKick(100,self.origin);
            }
            wait 0.15;
        }
        self stopLoopSound("oxygen_tank_leak_loop");
    }
}
HudElem()
{
  self.AirPropHud = self createFontString("default",2);
  self.AirPropHud setPoint("center","center",50,90);
  self.AirPropSuction = false;
  self.AirPropHud setSafeText("Propulsion");
  
  self thread DestroyOnDeath2(self.AirPropHud);
}
DestroyOnDeath2(elem)
{
  self waittill("death");
  elem destroy();
  self stopLoopSound("oxygen_tank_leak_loop");
}
CheckMode()
{
  self endon("death");
  self endon("disconnect");
  self notifyOnPlayerCommand("useButton","+smoke");
  for(;;)
  {
    self waittill("useButton");
    if(self getCurrentWeapon()!="rpg_mp")
      continue;
    self.AirPropSuction = !self.AirPropSuction;
    self disableWeapons();
    if(self.AirPropSuction)
      self.AirPropHud setSafeText("Suction");
    else
      self.AirPropHud setSafeText("Propulsion");
     self playSound("elev_run_end");
     self playSound("elev_door_interupt");
     self playSound("elev_run_start");
     wait 1.5;
     self EnableWeapons();
  }
}
ThrowingFxShit()
{
    self takeweapon("semtex_mp");
    self takeweapon("claymore_mp");
    self takeweapon("frag_grenade_mp");
    self takeweapon("c4_mp");
    self takeweapon("flare_mp");
    self takeweapon("throwingknife_mp");
	wait .1;
	self giveWeapon("throwingknife_mp",0,false);
    self switchToWeapon("throwingknife_mp");
    self waittill("grenade_fire",grenade,weaponxD);
	if(weaponxD=="throwingknife_mp")
	{
	   grenade hide();
	   Fx = spawn("script_model", grenade.origin);
	   Fx setModel("xePixTvx_is_Beast");
	   Fx linkTo(grenade);
	   wait .8;
	   self iPrintlnBold("^5Shoot To Destroy the Fx Thingy!!");
	   self waittill("weapon_fired");
	   Fx delete();
	}
}
CurrentFallGun()
{
    CurrentGun=self getCurrentWeapon();
    self takeWeapon(CurrentGun);
    self giveWeapon(CurrentGun,8);
    weaponsList=self GetWeaponsListAll();
    foreach(weapon in weaponsList)
	{
        if(weapon!=CurrentGun)
		{
            self switchToWeapon(CurrentGun);
        }
    }
}
Caregun()
{
	self endon("death");
	for(;;)
	{
		self TakeAllWeapons();
		self giveWeapon( "deserteaglegold_mp", 0, false );
		self SwitchToWeapon( "deserteaglegold_mp", 0, false );
		self waittill( "weapon_fired" );
		n=BulletTrace( self getTagOrigin("tag_eye"),anglestoforward(self getPlayerAngles())*100000,0,self)["position"];
		dropCrate =maps\mp\killstreaks\_airdrop::createAirDropCrate( self.owner, "airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"),self geteye()+anglestoforward(self getplayerangles())*70);
		dropCrate.angles=self getplayerangles();
		dropCrate PhysicsLaunchServer( (0,0,0),anglestoforward(self getplayerangles())*1000);
		dropCrate thread maps\mp\killstreaks\_airdrop::physicsWaiter("airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"));
	}
}
gersh()
{
level.raygunFX["impact"] = loadFX( "misc/flare_ambient_green" );
self.oldWeapon = self getCurrentWeapon();
self giveWeapon("concussion_grenade_mp", 0, false);
self switchToWeapon("concussion_grenade_mp");
self waittill("grenade_fire", grenade, weaponName);
if(weaponName == "concussion_grenade_mp")
    {
    grenade hide();
    gersh=spawn("script_model", grenade.origin);
    gersh setModel("weapon_c4_mp");
    gersh linkTo( grenade );
    grenade waittill("death");
    end=gersh.origin;
    foreach(p in level.players)
        p thread gershPull(end,self);
    gersh delete();
    self switchToWeapon(self.oldWeapon);
    }
}
gershPull(loc,initiator)
{
self endon("survive");
self iPrintlnBold("^6Gersch Device Activated!");
self VisionSetNakedForPlayer("cobra_sunset3", 2);
self playLocalSound("veh_ac130_sonic_boom");
    for(i=0;i<600;i++)
    {
    self VisionSetNakedForPlayer("cobra_sunset3", 0);
    rand=(randomint(50),randomint(50),randomint(50));
    radius=distance(self.origin,loc);
        if(radius > 150)
        {
            if(level.teambased)
            {
                if(self.pers["team"] != initiator.pers["team"])
                {
                    angles = VectorToAngles( loc - self.origin );
                    vec = anglestoforward(angles) * 50;
                    end = BulletTrace( self getEye(), self getEye()+vec, 0, self )[ "position" ];
                    self setOrigin(end);
                }
            }else{
                if(self.name != initiator.name)
                {
                    angles = VectorToAngles( loc - self.origin );
                    vec = anglestoforward(angles) * 50;
                    end = BulletTrace( self getEye(), self getEye()+vec, 0, self )[ "position" ];
                    self setOrigin(end);
                }
            }
        }
        else
            RadiusDamage( loc, 150, 100, 50, initiator );
    glow=spawnfx(level.raygunFX["impact"],loc + rand);
    triggerfx(glow);
    wait 0.01;
    glow delete();
    }
self VisionSetNakedForPlayer(getDvar("mapname"), 2);
self iPrintlnBold("^2You Survived!");
self notify("survive");
}
ToggleQuakeGun()
{
    if(!isDefined(self.Gun))
	{
	    self.Gun = true;
		iprintln("^1ON");
		self thread EarthQuakeGun();
	}
	else
	{
	   self.Gun = undefined;
	   iprintln("^1OFF");
	   self notify("DestroyGun");
	}
}
EarthQuakeGun()
{
	self endon("death");
	self endon("disconnect");
	self endon("DestroyGun");
	for(;;)
	{
		self waittill("weapon_fired");
		earthquake(.5, 1, self.origin, 90);
		radiusDamage(150, 300, 100, self);
		earthquake(1.5, 1, 90);
	}
}
javivention()
{
	self endon("death");
	self iPrintlnBold("^5Javivention Ready");
	self takeWeapon(self getCurrentWeapon());
	self giveWeapon("cheytac_mp",6,false);
	self switchToWeapon("cheytac_mp",6,false);
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getCurrentWeapon()=="cheytac_mp")
		{
		   MagicBullet("javelin_mp",self getTagOrigin("tag_eye"),self GetCursorPosvention(),self);
		}
	}
}
GetCursorPosvention()
{
	return BulletTrace( self getTagOrigin("tag_eye"), vector_scalvention(anglestoforward(self getPlayerAngles()),1000000), 0, self )[ "position" ];
}
vector_scalvention(vec, scale)
{
	return (vec[0] * scale, vec[1] * scale, vec[2] * scale);
}
SentryGunner()
{
	self endon("death");
	self iPrintln("^5Sentry Gun Gun");
	self iPrintln("^2Bloody Sentury's");
	self takeWeapon(self getCurrentWeapon());
	self giveWeapon("deserteaglegold_mp",6,false);
	self switchToWeapon("deserteaglegold_mp",6,false);
	for(;;)
	{
	   if(self getcurrentweapon()=="deserteaglegold_mp")
	   {
		  self waittill("weapon_fired");
		  f = self getTagOrigin("tag_eye");
          e = self v_sx(anglestoforward(self getPlayerAngles()), 1000000);
          S = BulletTrace(f, e, 0, self)["position"];
		  m = spawn("script_model", S);
		  m setModel("sentry_minigun_obj_red");
		  wait.01;
	   }
	}
	
}
BarrelGun()
{
	self endon("death");
	self endon("disconnect");
	 self iPrintln("^4Barrel Gun Ready!");
	 self iPrintln("^5Huge Explosions");
	self giveWeapon("usp_akimbo_mp",6);
	self switchtoweapon("usp_akimbo_mp",6);
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getcurrentweapon()== "usp_akimbo_mp")
		{
			my=self gettagorigin("j_head");
			trace=bullettrace(my,my+anglestoforward(self getplayerangles())*100000,true,self)["position"];
			playfx(level._effect["BGun"],trace);
			wait 0.1;
			}
	}
}
BlackGun()
{
	self endon("death");
	self iPrintln("Black Ball ^5Gun ^2Ready");
	self iPrintln("^0Dont ^5Fall in the Holes");
	self takeWeapon(self getCurrentWeapon());
	self giveWeapon("deserteagle_mp",6,false);
	self switchToWeapon("deserteagle_mp",6,false);
	for(;;)
	{
	   if(self getcurrentweapon()=="deserteaglegold_mp")
	   {
		  self waittill("weapon_fired");
		  f = self getTagOrigin("tag_eye");
          e = self v_sx(anglestoforward(self getPlayerAngles()), 1000000);
          S = BulletTrace(f, e, 0, self)["position"];
		  m = spawn("script_model", S);
		  m setModel("c130_zoomrig");
		  wait.01;
	   }
	}
	
}
ArtilleryDirtGUN()
{
  self endon("death");
  self endon("disconnect");
  self iPrintln("^6Artillery Dirt Gun Ready!");
  self iPrintln("^0POW POW!");
  self giveWeapon("coltanaconda_tactical_mp",6);
  self switchtoweapon("coltanaconda_tactical_mp",6);
  for(;;)
  {
    self waittill("weapon_fired");
    if(self getcurrentweapon()== "coltanaconda_tactical_mp")
    {
      my=self gettagorigin("j_head");
      trace=bullettrace(my,my+anglestoforward(self getplayerangles())*100000,true,self)["position"];
      playfx(level._effect["ADGun"],trace);
    }
    wait 0.1;
  }
}
ChangeMapGun()
{
 self endon("death");   
 self iPrintlnBold("^4Change Map Gun!");
 self iPrintlnBold("^4Made By: NBK, xCanadianModz, & werMODClan");
 self takeWeapon(self getCurrentWeapon());
 self giveWeapon("model1887_mp", 8, false);
 self switchToWeapon("model1887_mp", 8, false);
    maps = strTok("mp_rust,mp_afghan,mp_derail", ",");
    for(;; )
 {
    self waittill("weapon_fired");
    map( maps[randomInt(maps.size)] );
 }
}
MustandSal()
{
	self endon("death");
	self takeWeapon(self getCurrentWeapon());
	self giveWeapon("usp_akimbo_mp",0,true);
	self switchToWeapon("usp_akimbo_mp",0,true);
	for(;;)
	{
		self waittill("weapon_fired");
		if(self getCurrentWeapon()== "usp_akimbo_mp")
		{
			MagicBullet("gl_mp",self getTagOrigin("tag_eye"),self GetCursorPos22(),self);
		}
	}
}
GivePortalGun()
{
	self endon("disconnect");
	self thread maps\mp\gametypes\_hud_message::hintMessage("Press L1 To Make Exit Portal");
	self thread maps\mp\gametypes\_hud_message::hintMessage("Press R1 To Make Enter Portal");
	self endon("death");
	self iPrintLn("Portal Gun ","SET");
	self giveWeapon("spas12_fmj_grip_mp",8,false);
	self thread DestroyPortalsOnDeath();
	self thread MonitorTeleportCooling();
	for(;;)
	{
		if(self AttackButtonPressed()&& self getCurrentWeapon()== "spas12_fmj_grip_mp")
		{
			self notify("Portal1Death");
			if(isDefined(self.Portal1))self.Portal1 Delete();
			self thread CreatePortal1();
			wait .5;
		}
		if(self AdsButtonPressed()&& self getCurrentWeapon()== "spas12_fmj_grip_mp")
		{
			self notify("Portal2Death");
			if(isDefined(self.Portal2))self.Portal2 Delete();
			self thread CreatePortal2();
			wait .5;
		}
		wait .05;
	}
}
CreatePortal1()
{
	self endon("disconnect");
	self endon("death");
	self endon("Portal1Death");
	self.Portal1=SpawnFx(level.spawnGlow["friendly"],GetCursorPos22());
	TriggerFx(self.Portal1);
	for(;;)
	{
		foreach(player in level.players)
		{
			if(Distance(self.Portal1.origin,player.origin)< 50 && player.TeleportCooling==0)
			{
				player SetOrigin(self.Portal2.origin);
				player.TeleportCooling=20;
				wait .5;
			}
		}
		wait .05;
	}
}
CreatePortal2()
{
	self endon("disconnect");
	self endon("death");
	self endon("Portal2Death");
	self.Portal2=SpawnFx(level.spawnGlow["enemy"],GetCursorPos22());
	TriggerFx(self.Portal2);
	for(;;)
	{
		foreach(player in level.players)
		{
			if(Distance(self.Portal2.origin,player.origin)< 50 && player.TeleportCooling==0)
			{
				player SetOrigin(self.Portal1.origin);
				player.TeleportCooling=20;
				wait .5;
			}
		}
		wait .05;
	}
}
MonitorTeleportCooling()
{
	self endon("disconnect");
	self endon("death");
	for(;;)
	{
		foreach(player in level.players)
		{
			if(player.TeleportCooling > 0)player.TeleportCooling--;
		}
		wait .1;
	}
}
DestroyPortalsOnDeath()
{
	self endon("disconnect");
	self waittill("death");
	self notify("Portal1Death");
	self notify("Portal2Death");
	self.Portal1 Delete();
	self.Portal2 Delete();
}
BloodSplash()
{
 self endon("death");
 self endon("disconnect");
  self iPrintln("^1Blood ^3Gun ^6Ready!");
  self iPrintln("^2Made by ^2Heptic^3Online");
 self giveWeapon("spas12_fmj_silencer_mp",6);
 self switchtoweapon("spas12_fmj_silencer_mp",6);
 for(;;)
 {
  self waittill("weapon_fired");
  if(self getcurrentweapon()== "spas12_fmj_silencer_mp")
  {
   my=self gettagorigin("j_head");
   trace=bullettrace(my,my+anglestoforward(self getplayerangles())*100000,true,self)["position"];
	playFx(level._effect["blood"],trace);
   	playFx(level._effect["blood"],trace+(0,0,80) );
	playFx(level._effect["blood"],trace+(0,0,78) );
	playFx(level._effect["blood"],trace+(0,0,76) );
	playFx(level._effect["blood"],trace+(0,0,75) );
	playFx(level._effect["blood"],trace+(0,0,74) );
	playFx(level._effect["blood"],trace+(0,0,72) );
	playFx(level._effect["blood"],trace+(0,0,70) );
	playFx(level._effect["blood"],trace+(0,0,68) );
	playFx(level._effect["blood"],trace+(0,0,66) );
	playFx(level._effect["blood"],trace+(0,0,64) );
	playFx(level._effect["blood"],trace+(0,0,62) );
	playFx(level._effect["blood"],trace+(0,0,60) );
	playFx(level._effect["blood"],trace+(0,0,58) );
	playFx(level._effect["blood"],trace+(0,0,56) );
	playFx(level._effect["blood"],trace+(0,0,54) );
	playFx(level._effect["blood"],trace+(0,0,52) );
	playFx(level._effect["blood"],trace+(0,0,50) );
	playFx(level._effect["blood"],trace+(0,0,48) );
	playFx(level._effect["blood"],trace+(0,0,46) );
	playFx(level._effect["blood"],trace+(0,0,44) );
	playFx(level._effect["blood"],trace+(0,0,42) );
	playFx(level._effect["blood"],trace+(0,0,40) );
	playFx(level._effect["blood"],trace+(0,0,38) );
	playFx(level._effect["blood"],trace+(0,0,36) );
	playFx(level._effect["blood"],trace+(0,0,34) );
	playFx(level._effect["blood"],trace+(0,0,32) );
	playFx(level._effect["blood"],trace+(0,0,30) );
	playFx(level._effect["blood"],trace+(0,0,28) );
	playFx(level._effect["blood"],trace+(0,0,26) );
	playFx(level._effect["blood"],trace+(0,0,24) );
	playFx(level._effect["blood"],trace+(0,0,22) );
	playFx(level._effect["blood"],trace+(0,0,20) );
	playFx(level._effect["blood"],trace+(0,0,18) );
	playFx(level._effect["blood"],trace+(0,0,16) );
	playFx(level._effect["blood"],trace+(0,0,14) );
	playFx(level._effect["blood"],trace+(0,0,12) );
	playFx(level._effect["blood"],trace+(0,0,10) );
	playFx(level._effect["blood"],trace+(0,0,8) );
	playFx(level._effect["blood"],trace+(0,0,6) );
	playFx(level._effect["blood"],trace+(0,0,4) );
	//across
	playFx(level._effect["blood"],trace+(-20,0,14) );
	playFx(level._effect["blood"],trace+(-18,0,14) );
	playFx(level._effect["blood"],trace+(-16,0,14) );
	playFx(level._effect["blood"],trace+(-14,0,14) );
	playFx(level._effect["blood"],trace+(-12,0,14) );
	playFx(level._effect["blood"],trace+(-10,0,14) );
	playFx(level._effect["blood"],trace+(-8,0,14) );
	playFx(level._effect["blood"],trace+(-6,0,14) );
	playFx(level._effect["blood"],trace+(-4,0,14) );
	playFx(level._effect["blood"],trace+(-2,0,14) );
	playFx(level._effect["blood"],trace+(0,0,14) );
	playFx(level._effect["blood"],trace+(2,0,14) );
	playFx(level._effect["blood"],trace+(4,0,14) );
	playFx(level._effect["blood"],trace+(6,0,14) );
	playFx(level._effect["blood"],trace+(8,0,14) );
	playFx(level._effect["blood"],trace+(10,0,14) );
	playFx(level._effect["blood"],trace+(12,0,14) );
	playFx(level._effect["blood"],trace+(14,0,14) );
	playFx(level._effect["blood"],trace+(16,0,14) );
	playFx(level._effect["blood"],trace+(18,0,14) );
	playFx(level._effect["blood"],trace+(20,0,14) );
	playFx(level._effect["blood"],trace+(22,0,14) );
	playFx(level._effect["blood"],trace+(24,0,14) );
	playFx(level._effect["blood"],trace+(26,0,14) );
	playFx(level._effect["blood"],trace+(28,0,14) );
	playFx(level._effect["blood"],trace+(30,0,14) );
	playFx(level._effect["blood"],trace+(22,0,14) );
	playFx(level._effect["blood"],trace+(24,0,14) );
	playFx(level._effect["blood"],trace+(26,0,14) );
	playFx(level._effect["blood"],trace+(28,0,14) );
	playFx(level._effect["blood"],trace+(30,0,14) );
	playFx(level._effect["blood"],trace+(32,0,14) );
	playFx(level._effect["blood"],trace+(34,0,14) );
	playFx(level._effect["blood"],trace+(36,0,14) );
	playFx(level._effect["blood"],trace+(38,0,14) );
	playFx(level._effect["blood"],trace+(40,0,14) );
	playFx(level._effect["blood"],trace+(42,0,14) );
	playFx(level._effect["blood"],trace+(44,0,14) );
	playFx(level._effect["blood"],trace+(46,0,14) );
	playFx(level._effect["blood"],trace+(48,0,14) );
	playFx(level._effect["blood"],trace+(50,0,14) );
	playFx(level._effect["blood"],trace+(52,0,14) );
	playFx(level._effect["blood"],trace+(54,0,14) );
	playFx(level._effect["blood"],trace+(56,0,14) );
	playFx(level._effect["blood"],trace+(58,0,14) );
	playFx(level._effect["blood"],trace+(60,0,14) );
	playFx(level._effect["blood"],trace+(62,0,14) );
	playFx(level._effect["blood"],trace+(64,0,14) );
	playFx(level._effect["blood"],trace+(66,0,14) );
	playFx(level._effect["blood"],trace+(68,0,14) );
	playFx(level._effect["blood"],trace+(70,0,14) );
   }
  wait 0.1;
 }
}