#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_common_scripts;
#include FuZiioN\_overFlowFix;


SuperAC()
{
	owner=self;
	startNode=level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	heliOrigin=startnode.origin;
	heliAngles=startnode.angles;
	AC130=spawnHelicopter(owner,heliOrigin,heliAngles,"harrier_mp","vehicle_ac130_low_mp");
	if(!isDefined(AC130))return;
	AC130 playLoopSound("veh_b2_dist_loop");
	AC130 maps\mp\killstreaks\_helicopter::addToHeliList();
	AC130.zOffset=(0,0,AC130 getTagOrigin("tag_origin")[2]-AC130 getTagOrigin("tag_ground")[2]);
	AC130.team=owner.team;
	AC130.attacker=undefined;
	AC130.lifeId=0;
	AC130.currentstate="ok";
	AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_disconnect(owner);
	AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_changeTeams(owner);
	AC130 thread maps\mp\killstreaks\_helicopter::heli_leave_on_gameended(owner);
	AC130 endon("helicopter_done");
	AC130 endon("crashing");
	AC130 endon("leaving");
	AC130 endon("death");
	attackAreas=getEntArray("heli_attack_area","targetname");
	loopNode=level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
	AC130 maps\mp\killstreaks\_helicopter::heli_fly_simple_path(startNode);
	AC130 thread leave_on_timeou(100);
	AC130 thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path(loopNode);
	AC130 thread DropDaBomb(owner);
}
DropDaBomb(owner)
{
	self endon("death");
	self endon("helicopter_done");
	level endon("game_ended");
	self endon("crashing");
	self endon("leaving");
	waittime=5;
	for(;;)
	{
		wait(waittime);
		AimedPlayer=undefined;
		foreach(player in level.players)
		{
			if((player==owner)||(!isAlive(player))||(level.teamBased&&owner.pers["team"]==player.pers["team"])||(!bulletTracePassed(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),0,self)))continue;
			if(isDefined(AimedPlayer))
			{
				if(closer(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),AimedPlayer getTagOrigin("back_mid")))AimedPlayer=player;
			}
			else
			{
				AimedPlayer=player;
			}
		}
		if(isDefined(AimedPlayer))
		{
			AimLocation=(AimedPlayer getTagOrigin("back_mid"));
			Angle=VectorToAngles(AimLocation-self getTagOrigin("tag_origin"));
			MagicBullet("ac130_105mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
			wait .3;
			MagicBullet("ac130_40mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
			wait .3;
			MagicBullet("ac130_40mm_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
		}
	}
}
leave_on_timeou(T)
{
	self endon("death");
	self endon("helicopter_done");
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
	self thread ac130_leave();
}
ac130_leave()
{
	self notify("leaving");
	leaveNode=level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
	self maps\mp\killstreaks\_helicopter::heli_reset();
	self Vehicle_SetSpeed(100,45);
	self setvehgoalpos(leaveNode.origin,1);
	self waittillmatch("goal");
	self notify("death");
	wait .05;
	self stopLoopSound();
	self delete();
}
MegaAero(){
 self iPrintLnBold("^2Mega Attack Force Incoming^0!");
 o=self;
 b0=spawn("script_model",(15000,0,2300));
 b1=spawn("script_model",(15000,1000,2300));
 b2=spawn("script_model",(15000,-1000,2300));
 b3=spawn("script_model",(15000,2000,2300));
 b4=spawn("script_model",(15000,-2000,2300));
 b5=spawn("script_model",(15000,3000,2300));
 b6=spawn("script_model",(15000,-3000,2300));
 b0 setModel("vehicle_ac130_low_mp");
 b1 setModel("vehicle_av8b_harrier_jet_mp");
 b2 setModel("vehicle_pavelow_opfor");
 b3 setModel("vehicle_b2_bomber");
 b4 setModel("vehicle_little_bird_armed");
 b5 setModel("vehicle_ac130_coop");
 b6 setModel("vehicle_mi24p_hind_mp");
 b0.angles=(0,180,0);
 b1.angles=(0,180,0);
 b2.angles=(0,180,0);
 b3.angles=(0,180,0);
 b4.angles=(0,180,0);
 b5.angles=(0,180,0);
 b6.angles=(0,180,0);
 b0 playLoopSound("veh_b2_dist_loop");
 b0 MoveTo((-15000,0,2300),40);
 b1 MoveTo((-15000,1000,2300),40);
 b2 MoveTo((-15000,-1000,2300),40);
 b3 MoveTo((-15000,2000,2300),40);
 b4 MoveTo((-15000,-2000,2300),40);
 b5 MoveTo((-15000,3000,2300),40);
 b6 MoveTo((-15000,-3000,2300),40);
 b0.owner=o;
 b1.owner=o;
 b2.owner=o;
 b3.owner=o;
 b4.owner=o;
 b5.owner=o;
 b6.owner=o;
 b0.killCamEnt=o;
 b1.killCamEnt=o;
 b2.killCamEnt=o;
 b3.killCamEnt=o;
 b4.killCamEnt=o;
 b5.killCamEnt=o;
 b6.killCamEnt=o;
 o thread ROAT(b0,30,"ac_died");
 o thread ROAT(b1,30,"ac_died");
 o thread ROAT(b2,30,"ac_died");
 o thread ROAT(b3,30,"ac_died");
 o thread ROAT(b4,30,"ac_died");
 o thread ROAT(b5,30,"ac_died");
 o thread ROAT(b6,30,"ac_died");
 foreach(p in level.players){
 if(level.teambased){
 if((p!=o)&&(p.pers["team"]!=self.pers["team"]))
 if(isAlive(p))p thread RB0MB(b0,b1,b2,b3,b4,b5,b6,o,p);
 }
 else
 {
 if(p!=o)
 if(isAlive(p))p thread RB0MB(b0,b1,b2,b3,b4,b5,b6,o,p);
 }
 wait 0.3;
 }}
 ROAT(obj,time,reason){
 wait time;
 obj delete();
 self notify(reason);
 }
 RB0MB(b0,b1,b2,b3,b4,b5,b6,o,v){
 v endon("ac_died");
 s="stinger_mp";
 r="rpg_mp";
 a="javelin_mp";
 while(1){
 MagicBullet(s,b0.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b0.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b0.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b0.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b0.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b0.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b1.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b1.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b1.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b1.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b1.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b1.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b2.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b2.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b2.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b2.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b2.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b2.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b3.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b3.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b3.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b3.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b3.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b3.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b4.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b4.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b4.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b4.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b4.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b4.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b5.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b5.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b5.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b5.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b5.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b5.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b6.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b6.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b6.origin,v.origin,o);
 wait 0.43;
 MagicBullet(s,b6.origin,v.origin,o);
 wait 0.3;
 MagicBullet(r,b6.origin,v.origin,o);
 wait 0.3;
 MagicBullet(a,b6.origin,v.origin,o);
 wait 5.43;
 }}
 giveReaper()
{
	self endon( "disconnect" );
	self thread monitorButtonsReaper();
	self thread maps\mp\gametypes\_hud_message::hintMessage("Press [{+actionslot 4}] for Reaper");
	self endon( "death" );
	if( !isDefined( level.reaperInUse ) )
		level.reaperInUse = 0;
	self thread monitorDeath();
	self.inReaper = 0;
	self.showHUD = 0;
	self thread reaperHUD();
	cW = [];
	curWeapon = 0;
	for( ;; )
	{
		self waittillmatch( "buttonPress", "Right" );
		if( !self.isShooting )
		{
			if( !level.reaperInUse * !self.inReaper || level.reaperInUse * self.inReaper)
			{
				self.inReaper = !self.inReaper;
				level.reaperInUse = !level.reaperInUse;
				if( self.inReaper * level.reaperInUse )
				{
					cW[0] = self GetWeaponsListPrimaries();
					cW[1] = self getWeaponsListOffhands();
					curWeapon = self getCurrentWeapon();
					self takeAllWeapons();
					self giveWeapon( "killstreak_ac130_mp" );
					self switchToWeapon( "killstreak_ac130_mp" );
					wait 1.5;
					self VisionSetNakedForPlayer( "black_bw" );
					wait .25;
					self.showHUD = 1;
					self PlayerLinkWeaponviewToDelta( level.ac130, "tag_player", 1.0, 35, 35, 35, 35 );
					wait .15;
					self ThermalVisionFOFOverlayOn();
					self ThermalVisionOn();
					self VisionSetThermalForPlayer( getDvar( "mapname" ) );
					self thread monitorFire();
				}
				else if( !level.reaperInUse * !self.inReaper )
				{
					self thermalVisionOff();
					self notify( "closed" );
					self visionSetNakedForPlayer( "black_bw" );
					self.showHUD = 0;
					self unlink();self setClientDvar( "cg_fovmin", 1 );
					wait .25;
					self visionSetNakedForPlayer( getDvar( "mapname" ));
					self thermalvisionFOFOverlayOff();
					self takeWeapon( "killstreak_ac130_mp" );
					for( i = 0; i < cW[0].size; i++ )
						self giveWeapon( cW[0][i] );
					for( i = 0; i < cW[1].size; i++ )
						self giveWeapon( cW[1][i] );
					wait .25;
					self switchToWeapon( curWeapon );
				}
			}
		}
		else
			self iPrintlnBold( "^7ERROR: Can't close laptop while missile is being fired" );
	}
}


monitorFire()
{
	self endon( "disconnect" );
	self endon( "closed" );
	zoom = 60;
	self.isShooting = 0;
	for( ; isAlive( self ) * self.inReaper; )
	{
		self setClientDvar( "cg_fovmin", zoom );
		self waittill( "buttonPress", button );
		if( button == "RS" )
		{
			if( zoom == 60 )
				zoom = 10;
			else
				zoom = 60;
		}
		else if( button == "RT" )
		{
			self.isShooting = 1;
			earthquake( 0.2, 1, self getEye(), 1000 );
			self playLocalSound( "ac130_105mm_fire" );
			missile = spawn( "script_model", self getEye() - ( 0, 0, 30 ) );
			missile setModel( "projectile_cbu97_clusterbomb" );
			missile playLoopSound("veh_b2_dist_loop");
			missile missileControl( self );
			missile playSound("harrier_jet_crash");
			missile delete();
			self.isShooting = 0;
		}
	}
}


missileControl( shooter )
{
	turnSpeed = .05;
	rollAngle = 0;
	vecParts = 0;
	v = 0;
	vec = 0;
	for ( ;; )
	{
		for( i = 0; i < level.fx.size; i++ )
			playFX( level.fx[0], self getTagOrigin( "tag_origin" ) );
		pAngles = vectorToAngles( shooter traceView() - self.origin );
		self.angles = pAngles;
		flyLocation = self.origin + anglesToForward( pAngles ) * 100;
		self moveTo( flyLocation, .05 );
		if( distance( shooter traceView(), self.origin ) < 70 )
		{
			origins = "200 0 0|0 200 0|200 200 0|0 0 200|100 0 0|0 100 0|100 100 0|0 0 100";
			playFX( level.chopper_fx["explode"]["medium"], shooter traceView() );
			vecParts = strTok( origins, "|" );
			for ( i = 0; i < vecParts.size; i++ )
			{
				v = strTok( vecParts[i], " " );
				vec = ( int( v[0] ), int( v[1] ), int( v[2] ) );
				playFX( level.chopper_fx["explode"]["medium"], shooter traceView() - vec );
				playFX( level.chopper_fx["explode"]["medium"], shooter traceView() + vec );
			}
			earthquake( 3, 1.5, shooter traceView(), 800 );
			RadiusDamage( shooter traceView(), 500, 350, 50, shooter );
			break;
		}
		wait .05;
	}
}


reaperHUD()
{
	self endon( "disconnect" );
	reapHUD = newClientHudElem( self );
	reapHUD.x = 0;
	reapHUD.y = 0;
	reapHUD.alignX = "center";
	reapHUD.alignY = "middle";
	reapHUD.horzAlign = "center";
	reapHUD.vertAlign = "middle";
	reapHUD.foreground = true;
	reapHUD.alpha = 1;
	reapHUD setShader( "ac130_overlay_105mm", 640, 480 );
	for( ; isAlive( self ) ; )
	{
		reapHUD.alpha = self.showHUD;
		wait .05;
	}
	reapHUD destroy();
}


monitorDeath()
{
	self waittill( "death" );
	self unlink();
	if( self.inReaper )
	{
		level.reaperInUse = 0;
		self.inReaper = 0;
	}
}


TraceView()
{
	return BulletTrace(self getEye(), anglesToForward(self getPlayerAngles()) * 1000000, 1, self)["position"];
}


monitorButtonsReaper()
{
	self endon( "disconnect" );
	self endon( "death" );
	ent = spawnStruct();
	buttons = strTok( "Right|+actionslot 4;RS|+melee;RT|+attack", ";" );
	for( i = 0; i < buttons.size; i++ )
	{
		split = strTok( buttons[i], "|" );
		self notifyOnPlayerCommand( split[0], split[1] );
	}
	for( ;; )
	{
		for( i = 0; i < buttons.size; i++ )
		{
			button = strTok( buttons[i], "|" );
			self thread waittill_string( button[0], ent );
		}
		ent waittill( "returned", btn );
		ent notify( "die" );
		self notify( "buttonPress", btn );
	}
}
MegaAirShit()
{
self thread C("Mega Air Drop Incoming....", 5, (0, 1, 1));
            wait 5;
            self thread m();
}
m() {/*Created By x_DaftVader_x and EliteMossy*/
    self endon("death");
    self endon("disconnect");
    thread teamPlayerCardSplash("used_airdrop_mega", self);
    o = self;
    sn = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
    hO = sn.origin;
    hA = sn.angles;
    lb = spawnHelicopter(o, hO, hA, "cobra_mp", "vehicle_ac130_low_mp");
    if (!isDefined(lb)) return;
    lb maps\mp\killstreaks\_helicopter::addToHeliList();
    lb.zOffset = (0, 0, lb getTagOrigin("tag_origin")[2] - lb getTagOrigin("tag_ground")[2]);
    lb.team = o.team;
    lb.attacker = undefined;
    lb.lifeId = 0;
    lb.currentstate = "ok";
    lN = level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
    lb maps\mp\killstreaks\_helicopter::heli_fly_simple_path(sn);
    lb thread DCP(lb);
    lb thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path(lN);
    lb thread lu(20);
}
DCP(lb) {
    self endon("leaving");
    for (;;) {
        w(0.1);
        dC = maps\mp\killstreaks\_airdrop::createAirDropCrate(self.owner, "airdrop", maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"), lb.origin);
        dC.angles = lb.angles;
        dC PhysicsLaunchServer((0, 0, 0), anglestoforward(lb.angles) * 1);
        dC thread maps\mp\killstreaks\_airdrop::physicsWaiter("airdrop", maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"));
        w(0.1);
    }
}
lu(T) {
    self endon("death");
    self endon("helicopter_done");
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
    self thread ae();
}
ae() {
    self notify("leaving");
    lN = level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
    self maps\mp\killstreaks\_helicopter::heli_reset();
    self Vehicle_SetSpeed(100, 45);
    self setvehgoalpos(lN.origin, 1);
    self waittillmatch("goal");
    self notify("death");
    w(.05);
    self delete();
}
C(l, m, c) {
    self endon("std");
    P = createServerFontString("hudbig", 1.2);
    P setPoint("CENTER", "CENTER", 0, -40);
    P.sort = 1001;
    P.color = (c);
    P setSafeText(l);
    P.foreground = false;
    P1 = createServerFontString("hudbig", 1.4);
    P1 setPoint("CENTER", "CENTER", 0, 0);
    P1.sort = 1001;
    P1.color = (c);
    P1.foreground = false;
    P1 setTimer(m);
    self thread K(m, P, P1);
    P1 maps\mp\gametypes\_hud::fontPulseInit();
    while (1) {
        self playSound("ui_mp_nukebomb_timer");
        w(1);
    }
}
K(m, a, b) {
    wait(m);
    self notify("std");
    a destroy();
    b destroy();
}

w(V) {
    wait(V);
}
iButts()
{
	self.comboPressed=[];
	self.butN=[];
	self.butN[0]="X";
	self.butN[1]="Y";
	self.butN[2]="A";
	self.butN[3]="B";
	self.butN[4]="Up";
	self.butN[5]="Down";
	self.butN[6]="Left";
	self.butN[7]="Right";
	self.butN[8]="RT";
	self.butN[9]="O";
	self.butN[10]="F";
	self.butA=[];
	self.butA["X"]="+usereload";
	self.butA["Y"]="+breathe_sprint";
	self.butA["A"]="+frag";
	self.butA["B"]="+melee";
	self.butA["Up"]="+actionslot 1";
	self.butA["Down"]="+actionslot 2";
	self.butA["Left"]="+actionslot 3";
	self.butA["Right"]="+actionslot 4";
	self.butA["RT"]="weapnext";
	self.butA["O"]="+stance";
	self.butA["F"]="+gostand";
	self.butP=[];
	self.update=[];
	self.update[0]=1;
	for(i=0;i<11;i++)
	{
		self.butP[self.butN[i]]=0;
		self thread monButts(i);
	}
}
monButts(buttonI)
{
	self endon("disconnect");
	self endon("death");
	self endon("MenuChangePerms");
	butID=self.butN[buttonI];
	self notifyOnPlayerCommand(butID,self.butA[self.butN[buttonI]]);
	for(;;)
	{
		self waittill(butID);
		self.butP[butID]=1;
		wait .05;
		self.butP[butID]=0;
	}
}
isButP(butID)
{
	if(self.butP[butID]==1)
	{
		self.butP[butID]=0;
		return 1;
	}
	else return 0;
}
SpawnSmallHelicopter()
{
	lb=spawnHelicopter(self,self.origin+(0,0,110),self.angles,"littlebird_mp","vehicle_little_bird_armed");
	if(!isDefined(lb))return;
	lb.owner=self;
	lb.team=self.team;
	lb.Shoot=0;
	lb.Pilot=0;
	lb.Passanger=0;
	lb.AShoot=0;
	mgTurret1=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
	mgTurret1 setModel("weapon_minigun");
	mgTurret1 linkTo(lb,"tag_minigun_attach_right",(0,0,0),(0,0,0));
	mgTurret1.owner=self;
	mgTurret1.team=self.team;
	mgTurret1 makeTurretInoperable();
	mgTurret1 LaserOn();
	mgTurret1 SetDefaultDropPitch(8);
	mgTurret1 SetTurretMinimapVisible(0);
	mgTurret2=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
	mgTurret2 setModel("weapon_minigun");
	mgTurret2 linkTo(lb,"tag_minigun_attach_left",(0,0,0),(0,0,0));
	mgTurret2.owner=self;
	mgTurret2.team=self.team;
	mgTurret2 makeTurretInoperable();
	mgTurret2 SetDefaultDropPitch(8);
	mgTurret2 LaserOn();
	mgTurret2 SetTurretMinimapVisible(0);
	lb.mg1=mgTurret1;
	lb.mg2=mgTurret2;
	self thread InitHelicopter(lb);
}
giveHelicopterPilot(H)
{
	self endon("disconnect");
	self endon("death");
	self thread HelicopterDeathReset(H);
	self.Flying=1;
	S=16;
	H Vehicle_SetSpeed(1000,S);
	Me=spawn("script_origin",self.origin);
	Destination=spawn("script_origin",self.origin);
	self playerLinkTo(Me);
	level.p[self.myName]["MenuOpen"]=1;
	Me thread UpdateSeat(H,15);
	WL=self getWeaponsListOffhands();
	foreach(Wep in WL)self takeweapon(Wep);
	wait 1.5;
	H.mg1 SetSentryOwner(self);
	H.mg2 SetSentryOwner(self);
	if(level.teamBased)
	{
		H.mg1 setTurretTeam(self.team);
		H.mg2 setTurretTeam(self.team);
	}
	for(;;)
	{
		if(self.Flying)
		{
			forward=anglestoforward(self getPlayerAngles());
			right=anglestoright(self getPlayerAngles());
			up=anglestoup(self getPlayerAngles());
			if(self FragButtonPressed())
			{
				pos =(forward[0]*S,forward[1]*S,forward[2]*S);
				Destination.origin=Destination.origin+pos;
				H setVehGoalPos(Destination.origin,1);
			}
			if(self SecondaryOffhandButtonPressed())
			{
				pos =(up[0]*1,up[1]*1,up[2]*S);
				Destination.origin=Destination.origin+pos;
				H setVehGoalPos(Destination.origin,1);
			}
			if(self UseButtonPressed())
			{
				pos =(up[0]*1,up[1]*1,up[2]*S);
				Destination.origin=Destination.origin-pos;
				H setVehGoalPos(Destination.origin,1);
			}
			if(H.Shoot)
			{
				H.mg1 ShootTurret();
				H.mg2 ShootTurret();
			}
			if(self isButP("Left"))
			{
				self shootFrom("javelin_mp",H.mg1,S*4);
				self shootFrom("javelin_mp",H.mg2,S*4);
			}
			if(self isButP("Up"))
			{
				forward=H.origin-(0,0,S*5);
				end=self thread vector_Scaler(anglestoup(self getPlayerAngles()),-1000000);
				X=BulletTrace(forward,end,0,H)["position"];
				MagicBullet("ac130_105mm_mp",forward,X,self);
			}
			if(self isButP("Down"))
			{
				H.Shoot=0;
				if(H.AShoot)
				{
					H.AShoot=0;
				}
				else
				{
					H.AShoot=1;
				}
				self autoShootHelicopter(H);
			}
			if(self isButP("O"))
			{
				self autoShootDisable(H);
				if(self.Flying)self.Flying=0;
			}
		}
		else
		{
			self notify("endhelicopter");
			self unlink();
			level.p[self.myName]["MenuOpen"]=0;
			self HelicopterReset(H);
			break;
		}
		wait 0.05;
	}
	self.Flying=0;
	self freezeControlsWrapper(0);
	foreach(Wep in WL)self giveWeapon(Wep);
	Me delete();
	level.p[self.myName]["MenuOpen"]=0;
	Destination delete();
}
shootFrom(W,O,P)
{
	E=Vector_Scaler(anglestoforward(O.angles),99999);
	S=O.origin+vector_Scaler(anglestoforward(O.angles),P);
	L=BulletTrace(S,E,0,self)["position"];
	MagicBullet(W,S,L,self);
}
Vector_Scaler(vec,scale)
{
	vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);
	return vec;
}
InitHelicopter(H)
{
	Z=randomint(9999);
	for(;;)
	{
		if(!H.Pilot)
		{
			foreach(Pilot in level.players)
			{
				B=distance(GetHeliSeat(H,20),Pilot.origin);
				if(B<150)
				{
					if(!Pilot.Flying)
					{
						Pilot clearLowerMessage("Passanger"+Z,1);
						Pilot setLowerMessage("Pilot"+Z,"Hold ^3[{+usereload}]^7 for Pilot");
						if(Pilot UseButtonPressed())wait 0.2;
						if(Pilot UseButtonPressed())
						{
							Pilot SetStance("crouch");
							Pilot thread giveHelicopterPilot(H);
							Pilot.Pilot=H;
							H.Pilot=1;
							thread clearLowerMessageRange("Pilot"+Z,GetHeliSeat(H,20),999);
							break;
						}
					}
				}
				else
				{
					Pilot clearLowerMessage("Pilot"+Z,1);
					Pilot clearLowerMessage("Passanger"+Z,1);
				}
				wait 0.01;
			}
		}
		else if(!H.Passanger)
		{
			foreach(Passanger in level.players)
			{
				B=distance(GetHeliSeat(H,-20),Passanger.origin);
				if(!H.Pilot)B=999;
				if(B<150)
				{
					if(!Passanger.Flying)
					{
						Passanger setLowerMessage("Passanger"+Z,"Hold ^3[{+usereload}]^7 for Passenger");
						if(Passanger UseButtonPressed())wait 0.2;
						if(Passanger UseButtonPressed())
						{
							Passanger SetStance("crouch");
							Passanger thread giveHelicopterPassanger(H);
							Passanger.Passanger=H;
							H.Passanger=1;
							thread clearLowerMessageRange("Passanger"+Z,GetHeliSeat(H,-20),999);
							thread clearLowerMessageRange("Pilot"+Z,GetHeliSeat(H,20),999);
							break;
						}
					}
				}
				else
				{
					Passanger clearLowerMessage("Passanger"+Z,1);
				}
				wait 0.01;
			}
		}
		wait 0.2;
	}
}
autoShootDisable(H)
{
	H.mg1 notify("helicopter_done");
	H.mg2 notify("helicopter_done");
	H.mg1 notify("leaving");
	H.mg2 notify("leaving");
	H.mg1 setMode("manual");
	H.mg2 setMode("manual");
	H.mg1 SetDefaultDropPitch(8);
	H.mg2 SetDefaultDropPitch(8);
	H.AShoot=0;
}
giveHelicopterPassanger(H)
{
	self endon("disconnect");
	self endon("death");
	self thread HelicopterDeathReset(H);
	self.Flying=1;
	level.p[self.myName]["MenuOpen"]=1;
	Me=spawn("script_origin",self.origin);
	self playerLinkTo(Me);
	Me thread UpdateSeat(H,-15);
	for(;;)
	{
		if(self.Flying)
		{
			if(self isButP("Up"))
			{
				if(self.Flying)self.Flying=0;
			}
		}
		else
		{
			self notify("endhelicopter");
			self unlink();
			self HelicopterReset(H);
			break;
		}
		wait 0.1;
	}
	self.Flying=0;
	Me delete();
	level.p[self.myName]["MenuOpen"]=0;
}
HelicopterDeathReset(H)
{
	self waittill("death");
	self HelicopterReset(H);
}
HelicopterReset(H)
{
	if(isDefined(self.Pilot))
	{
		H.Pilot=0;
		self.Pilot=undefined;
		self.Flying=0;
	}
	if(isDefined(self.Passanger))
	{
		H.Passanger=0;
		self.Passanger=undefined;
		self.Flying=0;
	}
}
clearLowerMessageRange(Msg,Point,Radius)
{
	foreach(P in level.players)
	{
		B=distance(Point,P.origin);
		if(B<Radius)
		{
			P clearLowerMessage(Msg,1);
		}
		wait 0.01;
	}
}
autoShootHelicopter(H)
{
	if(H.AShoot)
	{
		H.mg1 setMode("auto_nonai");
		H.mg2 setMode("auto_nonai");
		H.mg1 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
		H.mg2 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
		self iPrintlnBold("^1Advanced Auto-Shooting : ON");
	}
	else
	{
		self autoShootDisable(H);
		self iPrintlnBold("^1Advanced Auto-Shooting : OFF");
	}
}
UpdateSeat(H,O)
{
	self endon("disconnect");
	self endon("death");
	self endon("endhelicopter");
	for(;;)
	{
		self.origin=GetHeliSeat(H,O);
		wait 0.01;
	}
}
GetHeliSeat(H,O)
{
	hforward=anglestoforward(H.angles);
	hright=anglestoright(H.angles);
	return((H.origin-(0,0,72))+(hforward[0]*35,hforward[1]*35,hforward[2]*35))-(hright[0]*O,hright[1]*O,hright[2]*O);
}
javirain()
{
	if (!self.IsRain)
	{
		self iPrintln("On");
		self thread rainbullets();
		self.IsRain=true;
	}
	else
	{
		self iPrintln("Off");
		self thread endbullets();
		self.IsRain=false;
	}
}
rainBullets()
{
	self endon("disconnect");
	self endon("redoTehBulletz");
	for(;;)
	{
		x = randomIntRange(-10000,10000);
		y = randomIntRange(-10000,10000);
		z = randomIntRange(8000,10000);
		MagicBullet( "javelin_mp", (x,y,z), (x,y,0), self );
		wait 0.05;
	}
}
endBullets()
{
	self notify("redoTehBulletz");
}
mortarTeam()
{
self endon("disconnect");
self endon("death");
self thread mtbs();
        self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
        self.selectingLocation = true;
        self waittill( "confirm_location", location, directionYaw );
    
        mortar1 = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
        mortar1 += (0, 0, 400);
        self endLocationSelection();
        self.selectingLocation = undefined;
        self.mortar1 = mortar1;
        self notify("1done");
}
mtbs()
{
	center = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	sky = center + (0,0,2500);
	self waittill("1done");
	s = "ac130_40mm_mp"; //bullet of shooting
	times = 3; //number of times mortar shoots
	self iPrintlnBold("Mortars Inbound");
	wait 5; //delay before firing (5 rec.)
		for(i = 0; i < times; i++)
        {
            xM = randomint(250);
            yM = randomint(250);
            zM = randomint(40);
            magicBullet(s,sky,self.mortar1 + (xM,yM,zM),self);
            wait 1;
        }
}
Petflow()
{
	self endon("death");
	self endon("disconnect");
    wait .1;
	self iprintln("^1Press [{+melee}] to Destroy");
	lb = spawnHelicopter(self, self.origin + (50, 0, 500), self.angles, "pavelow_mp", "vehicle_pavelow_opfor");
	if (!isDefined(lb)) return;
	lb.owner = self;
	lb.team = self.team;
	lb.AShoot = 1;
	mgTurret1 = spawnTurret("misc_turret", lb.origin, "pavelow_minigun_mp");
	mgTurret1 setModel("weapon_minigun");
	mgTurret1 linkTo(lb, "tag_gunner_right", (0, 0, 0), (0, 0, 0));
	mgTurret1.owner = self;
	mgTurret1.team = self.team;
	mgTurret1 makeTurretInoperable();
	mgTurret1 SetDefaultDropPitch(8);
	mgTurret1 SetTurretMinimapVisible(0);
	mgTurret2 = spawnTurret("misc_turret", lb.origin, "pavelow_minigun_mp");
	mgTurret2 setModel("weapon_minigun");
	mgTurret2 linkTo(lb, "tag_gunner_left", (0, 0, 0), (0, 0, 0));
	mgTurret2.owner = self;
	mgTurret2.team = self.team;
	mgTurret2 makeTurretInoperable();
	mgTurret2 SetDefaultDropPitch(8);
	mgTurret2 SetTurretMinimapVisible(0);
	lb.mg1 = mgTurret1;
	lb.mg2 = mgTurret2;
	if (level.teamBased)
	{
		mgTurret1 setTurretTeam(self.team);
		mgTurret2 setTurretTeam(self.team);
	}
	self iPrintln("^1Colin has arrived!!!!!");
	wait 3;
	self iPrintln("^1Press [{+melee}] to put Colin down");
	self thread ASH(lb);
	self thread CA(lb);
	self thread MG(mgTurret1);
	self thread MG1(mgTurret2);
	for (;;)
	{
		lb Vehicle_SetSpeed(1000, 16);
		lb setVehGoalPos(self.origin + (51, 0, 501), 1);
		wait 0.05;
	}
}
ASH(H)
{
	self endon("death");
	self endon("disconnect");
	if (H.AShoot)
	{
		H.mg1 setMode("auto_nonai");
		H.mg2 setMode("auto_nonai");
		H.mg1 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
		H.mg2 thread maps\mp\killstreaks\_helicopter::sentry_attackTargets();
	}
	else
	{
		self iPrintlnBold("^6aa");
	}
}
CA(lb)
{
	self endon("death");
	self notifyOnPlayerCommand("fukoffcol", "+melee");
	for (;;)
	{
		self waittill("fukoffcol");
		lb Delete();
	}
}
MG(mgTurret1)
{
	self endon("death");
	self notifyOnPlayerCommand("fukoffcol", "+melee");
	for (;;)
	{
		self waittill("fukoffcol");
		mgTurret1 Delete();
	}
}
MG1(mgTurret2)
{
	self endon("death");
	self notifyOnPlayerCommand("fukoffcol", "+melee");
	for (;;)
	{
		self waittill("fukoffcol");
		mgTurret2 Delete();
	}
}
misslebarrage()
{
	self endon("death");
	self.barraging=0;
	for(;;)
	{
		wait 0.05;
		if(self usebuttonpressed()&& self.barraging==0)
		{
			self beginLocationselection("map_artillery_selector",false,(level.mapSize / 5.625));
			self.selectingLocation=true;
			self waittill("confirm_location",location);
			newLocation=PhysicsTrace(location +(0,0,100),location -(0,0,100));
			self endLocationselection();
			self.selectingLocation=undefined;
			i=newLocation;
			self.barraging=1;
			for(;;)
			{
				x=randomIntRange(-7000,7000);
				y=randomIntRange(-7000,7000);
				z=randomIntRange(0,7000);
				MagicBullet("javelin_mp",(x,y,z),(i),self);
				wait 0.05;
			}
		}
	}
}
MOAB()
{
    self endon ( "disconnect" );
	Announcement( "MOAB Incoming" );
        self beginLocationSelection( "map_artillery_selector", true, ( level.mapSize / 5.625 ) );
        self.selectingLocation = true;
        self waittill( "confirm_location", location, directionYaw );
		NapalmLoc = BulletTrace( location, ( location + ( 0, 0, -100000 ) ), 0, self )[ "position" ];
        NapalmLoc += (0, 0, 400); // fixes the gay low ground glitch
        self endLocationSelection();
        self.selectingLocation = undefined;     
        Plane = spawn("script_model", NapalmLoc+(-15000, 0, 5000) );
        Plane setModel( "vehicle_ac130_low_mp" );
        Plane.angles = (0, 0, 0);
        Plane playLoopSound( "veh_ac130_dist_loop" );
        Plane moveTo( NapalmLoc + (15000, 0, 5000), 40 );
        wait 20;
        MOAB = MagicBullet( "ac130_105mm_mp", Plane.origin, NapalmLoc, self );
        wait 1.6;
        Plane playsound( "nuke_explosion" );
        Plane playsound( "nuke_explosion" );
        Plane playsound( "nuke_explosion" );
        MOAB delete();
        RadiusDamage( NapalmLoc, 1400, 5000, 4999, self );
        Earthquake( 1, 4, NapalmLoc, 4000 );
        level.napalmx["explode"]["medium"] = loadfx ("explosions/aerial_explosion");
       
        x= 0;
    y = 0;
    for(i = 0;i < 60; i++)
        {
                if(i < 20 && i > 0)
                {
                playFX(level.chopper_fx["explode"]["medium"], NapalmLoc+(x, y, 0));
                        playFX(level.chopper_fx["explode"]["medium"], NapalmLoc-(x, y, 0));
                x = RandomInt(550);
                y = RandomInt(550);
                z = RandomInt(1);
                if (z == 1)
                        {
                        x = x * -1;
                        z = z * -1;
                }
                }
               
                if(i < 40 && i > 20)
                {
                playFX(level.chopper_fx["explode"]["medium"], NapalmLoc+(x, y, 150));
                        playFX(level.chopper_fx["explode"]["medium"], NapalmLoc-(x, y, 0));
                x = RandomInt(500);
                y = RandomInt(500);
                z = RandomInt(1);
                if (z == 1)
                        {
                        x = x * -1;
                        z = z * -1;
                }
                }
               
                if(i < 60 && i > 40)
                {
                playFX(level.chopper_fx["explode"]["medium"], NapalmLoc+(x, y, 300));
                        playFX(level.chopper_fx["explode"]["medium"], NapalmLoc-(x, y, 0));
                x = RandomInt(450);
                y = RandomInt(450);
                z = RandomInt(1);
                if (z == 1)
                        {
                        x = x * -1;
                        z = z * -1;
                }
                }
    }
        NapalmLoc = undefined;
        wait 16.7;
        Plane delete();
       
        wait 30;
}
SuiHarri()
{
     self thread SuicideVehicel("vehicle_mig29_desert");
}
SuiBomber()
{
     self thread SuicideVehicel("vehicle_b2_bomber");
}
SuiAc()
{
   self thread SuicideVehicel("vehicle_ac130_low_mp");
}
SuicideVehicel(modelCmdX)////Function by Cmd-X
{
	if(self.Status=="Verify"||self.Status=="Vip"||self.Status=="Admin"||self.Status=="Host")
	{
		K=spawn("script_model",self.origin+(24000,15000,25000));
		K setModel(""+modelCmdX);
		self beginLocationselection("map_artillery_selector",true,(level.mapSize/5.625));
		self.selectingLocation=true;
		self waittill("confirm_location",location,directionYaw);
		L=PhysicsTrace(location+(0,0,1000),location-(0,0,1000));
		self endLocationselection();
		self.selectingLocation=undefined;
		A=vectorToAngles(L-(self.origin+(8000,5000,10000)));
		K.angles=A;
		K playLoopSound("veh_b2_dist_loop");
		playFxOnTag(level.harrier_smoke,self,"tag_engine_left");
		playFxOnTag(level.harrier_smoke,self,"tag_engine_right");
		wait 0.45;
		playFxontag(level.harrier_smoke,self,"tag_engine_left2");
		playFxontag(level.harrier_smoke,self,"tag_engine_right2");
		playFxOnTag(level.chopper_fx["damage"]["heavy_smoke"],self,"tag_engine_left");
		K moveto(L,5.9);
		wait 5.8;
		K playsound("nuke_explosion");
		wait .4;
		level._effect["cloud"]=loadfx("explosions/emp_flash_mp");
		playFx(level._effect["cloud"],K.origin+(0,0,200));
		K playSound("harrier_jet_crash");
		level.chopper_fx["explode"]["medium"]=loadfx("explosions/aerial_explosion");
		s=level.chopper_fx["explode"]["large"];
		playFX(s,K.origin);
		playFX(s,K.origin+(400,0,0));
		playFX(s,K.origin+(0,400,0));
		playFX(s,K.origin+(400,400,0));
		playFX(s,K.origin+(0,0,400));
		playFX(s,K.origin-(400,0,0));
		playFX(s,K.origin-(0,400,0));
		playFX(s,K.origin-(400,400,0));
		playFX(s,K.origin+(0,0,800));
		playFX(s,K.origin+(200,0,0));
		playFX(s,K.origin+(0,200,0));
		Earthquake(0.4,4,K.origin,800);
		foreach(p in level.players)
		{
			if(level.teambased)
			{
				if((p.name!=self.name)&&(p.pers["team"]!=self.pers["team"]))if(isAlive(p))p thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self,self,999999,0,"MOD_EXPLOSIVE","harrier_20mm_mp",p.origin,p.origin,"none",0,0);
			}
			else
			{
				if(p.name!=self.name)if(isAlive(p))p thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self,self,999999,0,"MOD_EXPLOSIVE","harrier_20mm_mp",p.origin,p.origin,"none",0,0);
			}
		}
		K delete();
	}
}
ALBDelete()
{
	self waittill("helicopter_done");
	self delete();
}
ALBSound()
{
	self endon("disconnect");
	level endon("game_ended");
	self endon("helicopter_done");
	CO=spawn("script_origin",self.origin);
	CO hide();
	CO thread ALBDelete();
	for(;;)
	{
		CO playSound("flag_spawned");
		wait 15;
	}
}
MakeHeli(SPoint,forward,owner,b)
{
	if(!isDefined(b))b=false;
	if(!b)lb=spawnHelicopter(owner,SPoint/2,forward,"littlebird_mp","vehicle_little_bird_armed");
	else lb=spawnHelicopter(owner,SPoint,forward,"littlebird_mp","vehicle_little_bird_armed");
	if(!isDefined(lb))return;
	lb.owner=owner;
	lb.team=owner.team;
	lb.pers["team"]=owner.team;
	mgTurret1=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
	mgTurret1 setModel("weapon_minigun");
	mgTurret1 linkTo(lb,"tag_minigun_attach_right",(0,0,0),(0,0,0));
	mgTurret1.owner=owner;
	mgTurret1.lifeId=0;
	mgTurret1.team=owner.team;
	mgTurret1 makeTurretInoperable();
	mgTurret1 SetDefaultDropPitch(8);
	mgTurret1 SetTurretMinimapVisible(0);
	mgTurret1.killCamEnt=lb;
	mgTurret1 SetSentryOwner(owner);
	mgTurret1.pers["team"]=owner.team;
	mgTurret2=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
	mgTurret2 setModel("weapon_minigun");
	mgTurret2 linkTo(lb,"tag_minigun_attach_left",(0,0,0),(0,0,0));
	mgTurret2.owner=owner;
	mgTurret2.lifeId=0;
	mgTurret2.team=owner.team;
	mgTurret2 makeTurretInoperable();
	mgTurret2 SetDefaultDropPitch(8);
	mgTurret2.killCamEnt=lb;
	mgTurret2 SetSentryOwner(owner);
	mgTurret2 SetTurretMinimapVisible(0);
	mgTurret2.pers["team"]=owner.team;
	if(level.teamBased)
	{
		mgTurret1 setTurretTeam(owner.team);
		mgTurret2 setTurretTeam(owner.team);
	}
	lb.mg1=mgTurret1;
	lb.mg2=mgTurret2;
	return lb;
}
AttackLittlebird()
{
	owner=self;
	startNode=level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
	heliOrigin=startnode.origin;
	heliAngles=startnode.angles;
	lb=MakeHeli(heliOrigin,heliAngles,owner,1);
	if(!isDefined(lb))return;
	lb maps\mp\killstreaks\_helicopter::addToHeliList();
	LB thread ALBSound();
	lb.zOffset=(0,0,lb getTagOrigin("tag_origin")[2]-lb getTagOrigin("tag_ground")[2]);
	lb.attractor=Missile_CreateAttractorEnt(lb,level.heli_attract_strength,level.heli_attract_range);
	lb.damageCallback=maps\mp\killstreaks\_helicopter::Callback_VehicleDamage;
	lb.maxhealth=level.heli_maxhealth*2;
	lb.team=owner.team;
	lb.attacker=undefined;
	lb.lifeId=0;
	lb.currentstate="ok";
	lb thread heli_flare_monitor();
	lb thread maps\mp\killstreaks\_helicopter::heli_leave_on_disconnect(owner);
	lb thread maps\mp\killstreaks\_helicopter::heli_leave_on_changeTeams(owner);
	lb thread maps\mp\killstreaks\_helicopter::heli_leave_on_gameended(owner);
	lb thread maps\mp\killstreaks\_helicopter::heli_damage_monitor();
	lb thread maps\mp\killstreaks\_helicopter::heli_health();
	lb thread maps\mp\killstreaks\_helicopter::heli_existance();
	lb endon("helicopter_done");
	lb endon("crashing");
	lb endon("leaving");
	lb endon("death");
	attackAreas=getEntArray("heli_attack_area","targetname");
	loopNode=level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
	lb maps\mp\killstreaks\_helicopter::heli_fly_simple_path(startNode);
	lb thread heli_leave_on_timeou(50);
	if(attackAreas.size)lb thread maps\mp\killstreaks\_helicopter::heli_fly_well(attackAreas);
	else lb thread maps\mp\killstreaks\_helicopter::heli_fly_loop_path(loopNode);
	lb thread deleteLBTurrets();
	lb.mg1 setMode("auto_nonai");
	lb.mg1 thread setry_attackTargets();
	lb.mg2 setMode("auto_nonai");
	lb.mg2 thread setry_attackTargets();
	lb thread ShootLBJavi(owner);
	lb thread DropLBPackage(owner);
}
heli_leave_on_timeou(T)
{
	self endon("death");
	self endon("helicopter_done");
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
	M=maps\mp\gametypes\_spawnlogic::findBoxCenter(level.spawnMins,level.spawnMaxs);
	level notify("chopGone");
	self.mg1 notify("helicopter_done");
	self.mg2 notify("helicopter_done");
	self.mg1 notify("leaving");
	self.mg2 notify("leaving");
	self.mg1 setMode("manual");
	self.mg2 setMode("manual");
	owner=self.owner;
	S=150;
	A=150;
	self Vehicle_SetSpeed(S,A);
	self setVehGoalPos(M+(0,0,1500),1);
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(2);
	C=spawn("script_model",M+(0,0,1500));
	C setModel("projectile_cbu97_clusterbomb");
	owner thread TimerNuke(C,M);
	owner thread NukeWait(C);
	self thread maps\mp\killstreaks\_helicopter::heli_leave();
}
NukeWait(O)
{
	level endon("game_ended");
	self endon("disconnect");
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(6);
	level.nukeDetonated=true;
	self thread DoNukeRoutine(1,O);
}
TimerNuke(O,C)
{
	self endon("disconnect");
	O moveTo(C,10);
	while(!isDefined(level.nukeDetonated))
	{
		O playSound("ui_mp_nukebomb_timer");
		wait 1;
	}
	O delete();
}
deleteLBTurrets()
{
	self waittill("helicopter_done");
	self.mg1 delete();
	self.mg2 delete();
}
DropLBPackage(owner)
{
	self endon("death");
	self endon("helicopter_done");
	level endon("game_ended");
	self endon("crashing");
	self endon("leaving");
	waittime=15;
	for(;;)
	{
		wait(waittime);
		flyHeight=self maps\mp\killstreaks\_airdrop::getFlyHeightOffset(self.origin);
		self thread maps\mp\killstreaks\_airdrop::dropTheCrate(self.origin+(0,0,-110),"airdrop_chop",flyHeight,false,undefined,self.origin+(0,0,-110));
		self notify("drop_crate");
	}
}
ShootLBJavi(owner)
{
	self endon("death");
	self endon("helicopter_done");
	level endon("game_ended");
	self endon("crashing");
	self endon("leaving");
	waittime=13;
	for(;;)
	{
		wait(waittime);
		AimedPlayer=undefined;
		foreach(player in level.players)
		{
			if((player==owner)||(!isAlive(player))||(level.teamBased&&owner.pers["team"]==player.pers["team"])||(!bulletTracePassed(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),0,self)))continue;
			if(isDefined(AimedPlayer))
			{
				if(closer(self getTagOrigin("tag_origin"),player getTagOrigin("back_mid"),AimedPlayer getTagOrigin("back_mid")))AimedPlayer=player;
			}
			else
			{
				AimedPlayer=player;
			}
		}
		if(isDefined(AimedPlayer))
		{
			AimLocation=(AimedPlayer getTagOrigin("back_mid"));
			Angle=VectorToAngles(AimLocation-self getTagOrigin("tag_origin"));
			MagicBullet("javelin_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
			wait 1;
			MagicBullet("javelin_mp",self getTagOrigin("tag_origin")-(0,0,180),AimLocation,owner);
		}
	}
}
setry_attackTargets()
{
	self endon("death");
	self endon("helicopter_done");
	level endon("game_ended");
	for(;;)
	{
		self waittill("turretstatechange");
		if(self isFiringTurret())self thread setry_burstFireStart();
		else self thread setry_burstFireStop();
	}
}
setry_burstFireStart()
{
	self endon("death");
	self endon("stop_shooting");
	self endon("leaving");
	level endon("game_ended");
	for(;;)
	{
		for(i=0;i<80;i++)
		{
			targetEnt=self getTurretTarget(false);
			if(isDefined(targetEnt))self shootTurret();
			wait .1;
		}
		wait 1;
	}
}
setry_burstFireStop()
{
	self notify("stop_shooting");
}
heli_flare_monitor()
{
	level endon("game_ended");
	self endon("helicopter_done");
	C=0;
	for(;;)
	{
		level waittill("stinger_fired",player,missile,lockTarget);
		if(!IsDefined(lockTarget)||(lockTarget!=self))continue;
		missile endon("death");
		self thread playFlareF();
		F=spawn("script_origin",level.ac130.planemodel.origin);
		F.angles=level.ac130.planemodel.angles;
		F moveGravity((0, 0, 0),5.0);
		F thread dAT(5.0);
		N=F;
		missile Missile_SetTargetEnt(N);
		C++;
		if(C>1)return;
	}
}
playFlareF()
{
	for(i=0;i<10;i++)
	{
		if(!isDefined(self))return;
		PlayFXOnTag(level._effect["ac130_flare"],self,"tag_origin");
		wait .15;
	}
}
dAT(d)
{
	wait(d);
	self delete();
}
DoNukeRoutine(B,M)
{
	if(!isDefined(B))B=0;
	if(B&&level.ChopEndsGame)B=1;
	else B=0;
	player=self;
	if(!isDefined(M))T=0;
	else T=1;
	if(!T)NukeWarhead=self GetCursorPos();
	else NukeWarhead=M.origin;
	if(!T)
	{
		nukeEnt=Spawn("script_model",NukeWarhead.origin);
		nukeEnt setModel("tag_origin");
		nukeEnt.angles=(0,(player.angles[1]+180),90);
	}
	else
	{
		nukeEnt=M;
	}
	player playsound("nuke_explosion");
	level._effect["cloud"]=loadfx("explosions/emp_flash_mp");
	if(!T)playFX(level._effect["cloud"],NukeWarhead+(0,0,200));
	else playFX(level._effect["cloud"],M.origin+(0,0,200));
	if(T)M hide();
	doExplosion(NukeWarhead.origin);
	player playsound("nuke_wave");
	PlayFXOnTagForClients(level._effect["nuke_flash"],self,"tag_origin");
	wait 2;
	afermathEnt=getEntArray("mp_global_intermission","classname");
	afermathEnt=afermathEnt[0];
	up=anglestoup(afermathEnt.angles);
	right=anglestoright(afermathEnt.angles);
	playFX(level._effect["nuke_aftermath"],afermathEnt.origin,up,right);
	level.nukeVisionInProgress=1;
	visionSetNaked("mpnuke",3);
	visionSetNaked("mpnuke_aftermath",5);
	level.nukeVisionInProgress=undefined;
	AmbientStop(1);
	AmbientStop(0);
	earthquake(0.4,4,NukeWarhead.origin,90000);
	wait 0.2;
	self DamageArea(NukeWarhead.origin,999999,99999,99999,"nuke_mp",1,B);
	wait 0.3;
	if(!B)visionSetNaked(getDvar("mapname"),5);
}
DamageArea(P,R,MAX,MIN,W,TK,B)
{
	KM=0;
	if(!isDefined(B))B=0;
	if(B)level.postRoundTime=10;
	D=MAX;
	foreach(player in level.players)
	{
		DR=distance(P,player.origin);
		if(DR<R)
		{
			if(MIN<MAX)D=int(MIN+((MAX-MIN)*(DR/R)));
			if((player!=self)&&((TK&&level.teamBased)||((self.pers["team"]!=player.pers["team"])&&level.teamBased)||!level.teamBased))player thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(player,self,D,0,"MOD_EXPLOSIVE",W,player.origin,player.origin,"none",0,0);
			if(player==self)KM=1;
		}
		wait 0.01;
	}
	RadiusDamage(P,R-(R*0.25),MAX,MIN,self);
	if(KM)self thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self,self,D,0,"MOD_EXPLOSIVE",W,self.origin,self.origin,"none",0,0);
	if(B)
	{
		foreach(p in level.players)p PlayRumbleOnEntity("damage_heavy");
		if(level.teamBased)thread maps\mp\gametypes\_gamelogic::endGame(self.team,game["strings"]["nuclear_strike"],true);
		else thread maps\mp\gametypes\_gamelogic::endGame(self,game["strings"]["nuclear_strike"],true);
	}
}
GetCursorPos()
{
	f=self getTagOrigin("tag_eye");
	e=self Vector_Scale(anglestoforward(self getPlayerAngles()),1000000);
	l=BulletTrace(f,e,0,self)["position"];
	return l;
}
Vector_Scale(vec,scale){
vec=(vec[0]*scale,vec[1]*scale,vec[2]*scale);
return vec;
}
doExplosion(Location)
{
	level.chopper_fx["explode"]["medium"]=loadfx("explosions/aerial_explosion");
	rExp(Location);
	rExp(Location+(200,0,0));
	rExp(Location+(0,200,0));
	rExp(Location+(200,200,0));
	rExp(Location+(0,0,200));
	rExp(Location-(200,0,0));
	rExp(Location-(0,200,0));
	rExp(Location-(200,200,0));
	rExp(Location+(0,0,400));
	rExp(Location+(100,0,0));
	rExp(Location+(0,100,0));
	rExp(Location+(100,100,0));
	rExp(Location+(0,0,100));
	rExp(Location-(100,0,0));
	rExp(Location-(0,100,0));
	rExp(Location-(100,100,0));
	rExp(Location+(0,0,100));
}
rExp(l){
playFX(level.chopper_fx["explode"]["medium"],l);
}
DaftDrop() {/*Created By x_DaftVader_x*/
    self endon("death");
    self endon("disconnect");

	streakName="airdrop";
	team = self.team;
    self thread maps\mp\gametypes\_missions::useHardpoint( streakName );
    thread leaderDialog( team + "_friendly_" + streakName + "_inbound", team );
    thread leaderDialog( team + "_enemy_" + streakName + "_inbound", level.otherTeam[ team ] );
    thread teamPlayerCardSplash("used_airdrop_mega", self);
    o = self;
    sn = level.heli_start_nodes[randomInt(level.heli_start_nodes.size)];
    hO = sn.origin;
    hA = sn.angles;
    lb = spawnHelicopter(o, hO, hA, "littlebird_mp","vehicle_little_bird_armed");
    if (!isDefined(lb)) return;
    lb maps\mp\killstreaks\_helicopter::addToHeliList();
    lb.zOffset = (0, 0, lb getTagOrigin("tag_origin")[2] - lb getTagOrigin("tag_ground")[2]);
    lb.team = o.team;
    lb.attacker = undefined;
    lb.lifeId = 0;
    lb.currentstate = "ok";
    lN = level.heli_loop_nodes[randomInt(level.heli_loop_nodes.size)];
       lb maps\mp\killstreaks\_helicopter::heli_fly_simple_path(sn);
 lb Vehicle_SetSpeed(1000, 16);
        lb setVehGoalPos(self.origin + (351, 0, 800), 1);
wait 5;
    self thread x_DaftVader_x(lb);
    lb thread lbleve(2);
}

lbleve(T) {
    self endon("death");
    self endon("helicopter_done");
    maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(T);
    self thread lbleave();
}
lbleave() {
    self notify("leaving");
    lN = level.heli_leave_nodes[randomInt(level.heli_leave_nodes.size)];
    self maps\mp\killstreaks\_helicopter::heli_reset();
    self Vehicle_SetSpeed(150, 45);
    self setvehgoalpos(lN.origin, 1);
    self waittillmatch("goal");
    self notify("death");
    wait .05;
    self delete();
}

x_DaftVader_x(lb){/*created by x_DaftVader_x*/
self endon("boom");


xDaftVaderx=maps\mp\killstreaks\_airdrop::createAirDropCrate( self, "ammo", "airdrop", lb.origin );
xDaftVaderx.angles = lb.angles;
xDaftVaderx PhysicsLaunchServer((0, 0, 0), anglestoforward(lb.angles) * 1);
self thread endvader(xDaftVaderx);
wait 5;


newPos=xDaftVaderx getorigin(); 
xDaftVaderx maps\mp\killstreaks\_airdrop::crateSetupForUse( &"MP_AC130_PICKUP","all", maps\mp\killstreaks\_killstreaks::getKillstreakCrateIcon( "ac130" ) );
xDaftVaderx setWaypoint( true, true, false );

wait 1;

for(;;) {
foreach(x_DaftVader_x in level.players) {


wait 0.01;
Homer=distance(newPos,x_DaftVader_x.origin);
if(Homer<50) {

if(x_DaftVader_x UseButtonPressed())wait 0.1;
if(x_DaftVader_x UseButtonPressed()) {
xDaftVaderx setWaypoint( false, false, false );
RW="";
 x_DaftVader_x playerLinkTo(xDaftVaderx  );
    x_DaftVader_x playerLinkedOffsetEnable();
    
    x_DaftVader_x _disableWeapon();
self thread VaderBar();
wait 6;
 level.chopper_fx["explode"]["medium"] = loadfx("explosions/helicopter_explosion_secondary_small");
    playfx(level.chopper_fx["explode"]["medium"], xDaftVaderx.origin);
   x_DaftVader_x playSound(level.heli_sound[self.team]["crash"]);
 RadiusDamage(newPos, 150, 150, 1500, x_DaftVader_x);xDaftVaderx delete();
            earthquake(0.3, 1, x_DaftVader_x.origin, 1000);self notify("boom");
wait 0.1; }
} else {} } } }  
endvader(xDaftVaderx){wait 60;self notify("boom");xDaftVaderx setWaypoint( false, false, false );xDaftVaderx delete();}

VaderBar(){wduration = 5.0;
xDaftVader = createPrimaryProgressBar( 25 );
xDaftVaderText = createPrimaryProgressBarText( 25 );
xDaftVaderText setSafeText( &"MP_CAPTURING_CRATE"  );
xDaftVader updateBar( 0, 1 / wduration );

for ( waitedTime = 0; waitedTime < wduration && isAlive( self ) && !level.gameEnded; waitedTime += 0.05 )
wait ( 0.05 );
xDaftVader destroyElem();
xDaftVaderText destroyElem();}

toggleJetSpeedUp()
{
        self endon( "disconnect" );
        self endon( "death" );
        self endon( "endjet" );
        self thread toggleJetUpPress();
        for(;;) {
                s = 0;
                if(self FragButtonPressed()) {
                        wait 1;
                        while(self FragButtonPressed()) {
                                if(s<4) { 
                                        wait 2;
                                        s++; 
                                }
                                if(s>3&&s<7) { 
                                        wait 1;
                                        s++; 
                                }
                                if(s>6) { 
                                        wait .5;
                                        s++; 
                                }
                                if(s==10) wait .5;
                                if(self FragButtonPressed()) {
                                        if(s<4) self.flyingJetSpeed = self.flyingJetSpeed + 50;
                                        if(s>3&&s<7) self.flyingJetSpeed = self.flyingJetSpeed + 100;
                                        if(s>6) self.flyingJetSpeed = self.flyingJetSpeed + 200;
                                        self.speedHUD setSafeText( "SPEED: " + self.flyingJetSpeed + " MPH" );
                                }
                        }
                        s = 0;
                }
                wait .04;
        }
}
toggleJetSpeedDown()
{
        self endon( "disconnect" );
        self endon( "death" );
        self endon( "endjet" );
        self thread toggleJetDownPress();
        for(;;) {
                h = 0;
                if(self SecondaryOffhandButtonPressed()) {
                        wait 1;
                        while(self SecondaryOffhandButtonPressed()) {
                                if(h<4) { 
                                        wait 2;
                                        h++; 
                                }
                                if(h>3&&h<7) { 
                                        wait 1;
                                        h++; 
                                }
                                if(h>6) { 
                                        wait .5;
                                        h++; 
                                }
                                if(h==10) wait .5;
                                if(self SecondaryOffhandButtonPressed()) {
                                        if(h<4) self.flyingJetSpeed = self.flyingJetSpeed - 50;
                                        if(h>3&&h<7) self.flyingJetSpeed = self.flyingJetSpeed - 100;
                                        if(h>6) self.flyingJetSpeed = self.flyingJetSpeed - 200;
                                        self.speedHUD setSafeText( "SPEED: " + self.flyingJetSpeed + " MPH" );
                                }
                        }
                        h = 0;
                }
                wait .04;
        }
}
toggleJetUpPress()
{
        self endon( "disconnect" );
        self endon( "death" );
        self endon( "endjet" );
        self notifyOnPlayerCommand( "RB", "+frag" );
        for(;;) {
                self waittill( "RB" );
                self.flyingJetSpeed = self.flyingJetSpeed + 10;
                self.speedHUD setSafeText( "SPEED: " + self.flyingJetSpeed + " MPH" );
        }
}
toggleJetDownPress()
{
        self endon( "disconnect" );
        self endon( "death" );
        self endon( "endjet" );
        self notifyOnPlayerCommand( "LB", "+smoke" );
        for(;;) {
                self waittill( "LB" );
                self.flyingJetSpeed = self.flyingJetSpeed - 10;
                self.speedHUD setSafeText( "SPEED: " + self.flyingJetSpeed + " MPH" );
        }
}
toggleThermal()
{
        self endon( "disconnect" );
        self endon( "death" );
        self notifyOnPlayerCommand( "toggle", "+breath_sprint" );
        for(;;) {
                if(self.harrierOn==1) {
                        self waittill( "toggle" ); {
                                self maps\mp\perks\_perks::givePerk("specialty_thermal");
                                self VisionSetNakedForPlayer("thermal_mp", 2);
                                self ThermalVisionFOFOverlayOn();
                                self iPrintLnBold( "Thermal Overlay ^2On" );
                        }
                        self waittill( "toggle" ); {
                                self _clearPerks();
                                self ThermalVisionFOFOverlayOff();
                                self visionSetNakedForPlayer(getDvar( "mapname" ), 2);
                                self iPrintLnBold( "Thermal Overlay ^1Off" );
                        }
                } else {
                        self waittill( "toggle" ); {
                                if ( self GetStance() == "prone" ) {
                                        self maps\mp\perks\_perks::givePerk("specialty_thermal");
                                        self VisionSetNakedForPlayer("thermal_mp", 2);
                                        self ThermalVisionFOFOverlayOn();
                                        self iPrintLnBold( "Thermal Overlay ^2On" );
                                }
                        }
                        self waittill( "toggle" ); {
                                if ( self GetStance() == "prone" ) {
                                        self _clearPerks();
                                        self ThermalVisionFOFOverlayOff();
                                        self visionSetNakedForPlayer(getDvar( "mapname" ), 2);
                                        self iPrintLnBold( "Thermal Overlay ^1Off" );
                                }
                        }
                }
        }
}
initJet()
{
        self thread jetStartup(1, 0, 1, 1);
        self thread toggleJetSpeedDown();
        self thread toggleJetSpeedUp();
        self thread initHudElems();
        self thread iniGod();
}
iniGod()
{
        self endon ( "disconnect" );
        self endon ( "death" );
        self.maxhealth = 90000;
        self.health = self.maxhealth;
        while ( 1 ) {
                wait .4;
                if ( self.health < self.maxhealth )
                        self.health = self.maxhealth;
        }
}
jetStartup(UseWeapons, Speed, Silent, ThirdPerson)
{
        //basic stuff
        self takeAllWeapons();
        self thread forwardMoveTimer(Speed); //make the jet always move forward
       
        if(ThirdPerson == 1)
        {
                wait 0.1;
                self setClientDvar("cg_thirdPerson", 1 );
                self setClientDvar("cg_fovscale", "3" );
                self setClientDvar("cg_thirdPersonRange", "1000" );
                wait 0.1;
        }
        jetflying111 = "vehicle_mig29_desert";
        self attach(jetflying111, "tag_weapon_left", false);
        self thread engineSmoke();
       
        if(UseWeapons == 1)
        {
                self useMinigun(); //setup the system :D
                self thread makeHUD(); //weapon HUD
                self thread migTimer(); //timer to get status
                self thread makeJetWeapons(); //weapon timer
                self thread fixDeathGlitch(); //kinda working
               
                self setClientDvar( "compassClampIcons", "999" );
               
        }
       
        if(Silent == 0)
        {              
                self playLoopSound( "veh_b2_dist_loop" );
        }      
}
useMinigun()
{
        self.minigun = 1;
        self.carpet = 0;
        self.explosives = 0;
        self.missiles = 0;
}
useCarpet()
{
        self.minigun = 0;
        self.carpet = 1;
        self.explosives = 0;
        self.missiles = 0;
}
useExplosives()
{
        self.minigun = 0;
        self.carpet = 0;
        self.explosives = 1;
        self.missiles = 0;
}
useMissiles()
{
        self.minigun = 0;
        self.carpet = 0;
        self.explosives = 0;
        self.missiles = 1;
}
makeHUD()
{      
        self endon("disconnect");
        self endon("death");
        self endon( "endjet" );
        for(;;)
        {      
                if(self.minigun == 1)
                {
                       self.weaponHUD setSafeText( "CURRENT WEAPON: ^1AC130" );
                }
               
                else if(self.carpet == 1)
                {
                       
                        self.weaponHUD setSafeText( "CURRENT WEAPON: ^1RPG" );
                       
                }
               
                else if(self.explosives == 1)
                {
                        self.weaponHUD setSafeText( "CURRENT WEAPON: ^1JAVELIN" );
                       
                }
               
                else if(self.missiles == 1)
                {
                        self.weaponHUD setSafeText( "CURRENT WEAPON: ^1STINGER" );
                }
               
                wait 0.5;
 
        }
}
initHudElems()
{
        self.weaponHUD = self createFontString( "objective", 1.4 );
        self.weaponHUD setPoint( "TOPRIGHT", "TOPRIGHT", 0, 23 );
        self.weaponHUD setSafeText( "CURRENT WEAPON: ^AC130" );

        self.speedHUD = self createFontString( "objective", 1.4 );
        self.speedHUD setPoint( "CENTER", "TOP", -65, 9 );
        self.speedHUD setSafeText( "SPEED: " + self.flyingJetSpeed + " MPH" );
       
        self thread destroyOnDeath1( self.weaponHUD );
        self thread destroyOnDeath1( self.speedHUD );
        self thread destroyOnEndJet( self.weaponHUD );
        self thread destroyOnEndJet( self.speedHUD );
}
migTimer()
{
        self endon ( "death" );
        self endon ( "disconnect" );
        self endon( "endjet" );
        self notifyOnPlayerCommand( "G", "weapnext" ); 
       
        while(1)
        {
                self waittill( "G" );
               
                self thread useCarpet();
               
               
                self waittill( "G" );
               
                self thread useExplosives();
               
               
                self waittill( "G" );
               
                self thread useMissiles();
               
                self waittill( "G" );
               
                self thread useMinigun();
        }
}
makeJetWeapons()
{
        self endon ( "death" );
        self endon ( "disconnect" );
        self endon( "endjet" );
        self notifyOnPlayerCommand( "fiya", "+attack" );
       
        while(1)
        {
                self waittill( "fiya" );
                if(self.minigun == 1)
                {
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "ac130_105mm_mp", self.origin, firing, self );
                        wait 0.1;                                               
                }
               
                else if(self.carpet == 1)
                {
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait 0.2;
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait 0.2;
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait .01;
                        firing = GetCursorPosLOL();
                        MagicBullet( "rpg_mp", self.origin, firing, self );
                        wait 0.2;
                }
               
                else if(self.explosives == 1)
                {
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        firing = GetCursorPosLOL();
                        MagicBullet( "javelin_mp", self.origin, firing, self );
                        wait 0.1;
                       
                }
               
                else if(self.missiles == 1)
                {
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                        firing = GetCursorPosLOL();
                        MagicBullet( "stinger_mp", self.origin, firing, self );
                        wait 0.1;
                }
                wait 0.1;
        }
}
GetCursorPosLOL()
{
        forward = self getTagOrigin("tag_eye");
        end = self thread vector_Scal(anglestoforward(self getPlayerAngles()),1000000);
        location = BulletTrace( forward, end, 0, self)[ "position" ];
        return location;
}
vector_scal(vec, scale)
{
        vec = (vec[0] * scale, vec[1] * scale, vec[2] * scale);
        return vec;
}      
fixDeathGlitch()
{
        self waittill( "death" );
       
        self thread useMinigun();
}
destroyOnDeath1( waaat )
{
        self waittill( "death" );
       
        waaat destroy();
}
destroyOnEndJet( waaat )
{
        self waittill( "endjet" );
       
        waaat destroy();
}
forwardMoveTimer(SpeedToMove)
{
        self endon("death");
        self endon( "endjet" );
        if(isdefined(self.jetflying))
        self.jetflying delete();
        self.jetflying = spawn("script_origin", self.origin);
        self.flyingJetSpeed = SpeedToMove;
        while(1)
        {      
                self.jetflying.origin = self.origin;
                self playerlinkto(self.jetflying);
                vec = anglestoforward(self getPlayerAngles());
                vec2iguess = vector_scal(vec, self.flyingJetSpeed);
                self.jetflying.origin = self.jetflying.origin+vec2iguess;
                wait 0.05;
        }
}      
engineSmoke()
{
        self endon( "endjet" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_left" );
        playFxOnTag( level.harrier_smoke, self, "tag_engine_right" );
}
Napalm(high)
{
	self endon("disconnect");
	weapon=undefined;
	self beginLocationSelection("map_artillery_selector",true,(level.mapSize / 5.625));
	self.selectingLocation=true;
	self waittill("confirm_location",location,directionYaw);
	self endLocationSelection();
	self.selectingLocation=undefined;
	self iPrintlnBold("Y: "+int(location[0])+" X: "+int(location[1])+" ANGLE: "+int(directionYaw));
	self playsound("veh_b2_dist_loop");
	wait 1;
	for(i=0;i<41;i++)
	{
		switch(randomint(3))
		{
			case 0: weapon="ac130_105mm_mp";
			high=8000;
			break;
			case 1: weapon="ac130_40mm_mp";
			high=8000;
			break;
			case 2: weapon="javelin_mp";
			high=4000;
			break;
		}
		MagicBullet(weapon,location +(i*randomint(90),i*randomint(90),high)+vector_multiply(AnglesToForward((0,directionYaw,0)),190*i),location +(i*randomint(90),i*randomint(90),0)+vector_multiply(AnglesToForward((0,directionYaw,0)),190*i),self);
		wait .25;
	}
}
PetCobra()
{
	self endon("death");
	self endon("disconnect");
    wait .1;
	self iprintln("^1Press [{+melee}] to Destroy");
	lb=spawnHelicopter(self,self.origin +(50,0,500),self.angles,"cobra_mp","vehicle_mi24p_hind_mp");
	if(!isDefined(lb))return;
	lb.owner=self;
	lb.team=self.team;
	lb.AShoot=1;
	mgTurret1=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
	mgTurret1 setModel("weapon_minigun");
	mgTurret1 linkTo(lb,"tag_gunner_right",(0,0,0),(0,0,0));
	mgTurret1.owner=self;
	mgTurret1.team=self.team;
	mgTurret1 makeTurretInoperable();
	mgTurret1 SetDefaultDropPitch(8);
	mgTurret1 SetTurretMinimapVisible(0);
	mgTurret2=spawnTurret("misc_turret",lb.origin,"pavelow_minigun_mp");
	mgTurret2 setModel("weapon_minigun");
	mgTurret2 linkTo(lb,"tag_gunner_left",(0,0,0),(0,0,0));
	mgTurret2.owner=self;
	mgTurret2.team=self.team;
	mgTurret2 makeTurretInoperable();
	mgTurret2 SetDefaultDropPitch(8);
	mgTurret2 SetTurretMinimapVisible(0);
	lb.mg1=mgTurret1;
	lb.mg2=mgTurret2;
	if(level.teamBased)
	{
		mgTurret1 setTurretTeam(self.team);
		mgTurret2 setTurretTeam(self.team);
	}
	self iPrintln("^7Press [{+melee}] to Disable");
	self thread ASH(lb);
	self thread CA(lb);
	self thread MG(mgTurret1);
	self thread MG1(mgTurret2);
	for(;;)
	{
		lb Vehicle_SetSpeed(1000,16);
		lb setVehGoalPos(self.origin +(51,0,501),1);
		wait 0.05;
	}
}
acmmrain()
{
	if(!self.mmrain)
	{
		self iPrintln("On");
		self thread rainmmbullets();
		self.mmrain=true;
	}
	else
	{
		self iPrintln("Off");
		self thread endmmbullets();
		self.mmrain=false;
	}
}
rainmmbullets()
{
	self endon("disconnect");
	self endon("FuZiioN Is a Monster!!!!");
	for(;;)
	{
		x = randomIntRange(-10000,10000);
		y = randomIntRange(-10000,10000);
		z = randomIntRange(8000,10000);
		MagicBullet( "ac130_40mm_mp", (x,y,z), (x,y,0), self );
		wait 0.05;
	}
}
endmmBullets()
{
	self notify("FuZiioN Is a Monster!!!!");
}

CareHeli()
{
    self endon("death");
	self iprintln("^1Created By xePixTvx");
	self iprintln("Press [{+smoke}] to drop carepackages!!");
	self iprintln("Press [{+melee}] + [{+frag}] to Delete the Heli!!");
    self takeAllWeapons();
	wait .2;
    self GiveWeapon("deserteaglegold_mp");
    wait 0.4;
    self switchToWeapon("deserteaglegold_mp");
    wait 0.4;
	Heli = spawnHelicopter(self,self.origin+(50,0,800),self.angles,"pavelow_mp","vehicle_pavelow_opfor");
	Heli thread deleteOnDeath(Heli);
	if(!isDefined(Heli)){return;}
	Heli.owner = self;
	Heli.team = self.team;
	self thread WeaponMonitor(Heli);
	for(;;)
	{
		if(self SecondaryOffHandButtonPressed())
		{
		   Heli thread DropDaPackage(Heli);
		   wait .2;
		}
		if(self MeleeButtonPressed() && self FragButtonPressed())
		{
		   Heli delete();
		   self suicide();
		}
		waitframe();
	}
	wait 0.05;
}
WeaponMonitor(heli)
{
   self endon("death");
   for(;;)
   {
      self waittill("weapon_fired");
      target = GetCursorPosHeli();
      Pos = FXMarker(target,level.oldSchoolCircleYellow);
	  location = target;
	  heli Vehicle_SetSpeed(1000,16);
	  heli setVehGoalPos(location+(51,0,801),1);
	  wait 0.05;
   }
}
DropDaPackage(heli) 
{
    wait 0.05;
    care = maps\mp\killstreaks\_airdrop::createAirDropCrate(self.owner,"airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"),heli.origin);
    care.angles = heli.angles;
    care PhysicsLaunchServer((0,0,0),anglestoforward(heli.angles)*1);
    care thread maps\mp\killstreaks\_airdrop::physicsWaiter("airdrop",maps\mp\killstreaks\_airdrop::getCrateTypeForDropType("airdrop"));
	wait 0.05;
}
FXMarker(groundpoint,fx)
{
        effect = spawnFx(fx,groundpoint,(0,0,1),(1,0,0));
		self thread deleteFxafterTime(5,effect);
        triggerFx(effect);
        return effect;
}
deleteFxafterTime(Time,lol)
{
   maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause(Time);
   lol delete();
}
deleteOnDeath(model)
{
   self waittill("death");
   model delete();
}
GetCursorPosHeli()
{
    return bulletTrace(self getEye(),self getEye()+vectorScaleHeli(anglesToForward(self getPlayerAngles()),1000000),false,self)["position"];
}
vectorScaleHeli(vector,scale)
{
	return(vector[0]*scale,vector[1]*scale,vector[2]*scale);
}