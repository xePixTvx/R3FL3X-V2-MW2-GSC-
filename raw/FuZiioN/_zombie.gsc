#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_overFlowFix;

#include FuZiioN\_common_scripts;
#include FuZiioN\_main;
#using_animtree("multiplayer");

_loadZombieStuff()
{
	PrecacheModel("com_plasticcase_beige_big");
	PrecacheModel("weapon_parabolic_knife");
	precacheMpAnim("pt_melee_pistol_1");
	precacheMpAnim("pb_stand_alert_akimbo");//Idle
	precacheMpAnim("pb_walk_forward_akimbo");//Walk
	precacheMpAnim("pb_combatrun_forward_akimbo");//Run
	precacheMpAnim("pb_sprint_akimbo");//Sprint
	precacheMpAnim("pb_stumble_forward");//Hit Pain
	precacheMpAnim("pb_death_run_stumble");
	precacheMpAnim("pb_stand_death_leg_kickup");
	precacheMpAnim("pb_stand_death_shoulderback");
	level.BotHit_bloodfx = loadfx("impacts/flesh_hit_body_fatal_exit");
	level.BotHit_bloodfx_two = loadfx("impacts/flesh_hit_head_fatal_exit");
	level.BotHit_bloodfx_three = loadfx("impacts/flesh_hit_splat_large");
	level.ZombieFroze = false;
}



toggleShootexpZombies()
{
	if(!self.ShootZombiesExplode)
	{
		self.ShootZombiesExplode = true;
		self thread doShootBulletsZombieExplode();
	}
	else
	{
		self.ShootZombiesExplode = false;
		self notify("stop_exp_zomb_shoot");
	}
}
doShootBulletsZombieExplode()
{
	self endon("disconnect");
	self endon("stop_exp_zomb_shoot");
	for(;;)
	{
		self waittill("weapon_fired");
		StartPoint=self getTagOrigin("j_head");
		EndPoint=self thread vector_scal_epx_zomb(anglestoforward(self getplayerangles()),1000000);
		Bullet=BulletTrace(StartPoint,EndPoint,0,self)[ "position" ];
		Model = spawn("script_model",Bullet);
		Model setModel(self.model);
		Model Solid();
		Model thread getRAndomAnim_ShootExp_Zomb();
		self thread doDeleteModels(Model);
		wait 0.05;
	}
}
doDeleteModels(i)
{
	self waittill("weapon_fired");
	wait 5;
	playfx(level._effect["ADGun"],i.origin);
	RadiusDamage(i.origin,130,130,130,self);
	i playsound("nuke_explosion");
	wait 0.05;
	i thread gfgfg_shootZombie();
}
gfgfg_shootZombie()
{
	switch(randomInt(3))
	{
		case 0: self scriptModelPlayAnim("pb_death_run_stumble");
		break;
		case 1: self scriptModelPlayAnim("pb_stand_death_leg_kickup");
		break;
		case 2: self scriptModelPlayAnim("pb_stand_death_shoulderback");
		break;
	}
	wait 2;
	self delete();
}
getRAndomAnim_ShootExp_Zomb()
{
	switch(randomInt(4))
	{
		case 0: self scriptModelPlayAnim("pb_stand_alert_akimbo");
		break;
		
		case 1: self scriptModelPlayAnim("pb_walk_forward_akimbo");
		break;
		
		case 2: self scriptModelPlayAnim("pb_combatrun_forward_akimbo");
		break;
		
		case 3: self scriptModelPlayAnim("pb_sprint_akimbo");
		break;
	}
}
vector_scal_epx_zomb(vec,scale)
{
	vec =(vec[0] * scale,vec[1] * scale,vec[2] * scale);
	return vec;
}



Zombie_Invasion(count,player)
{
	player iprintln("^1"+count+" Zombies Incoming!!!");
	CreateNSpawnDefaultZombiee(count,player);
}
CreateNSpawnDefaultZombiee(count,player)
{
	for(i=0;i<count;i++)
	{
		level.epx_zombies[i] = spawn("script_model",player.origin+(400,300,0));
		level.epx_zombies[i] setModel(player.model);
		level.epx_zombies[i].crate1 = spawn("script_model", level.epx_zombies[i] getTagOrigin("j_spinelower")+(-5,0,-10)); 
		level.epx_zombies[i].crate1 setModel("com_plasticcase_beige_big");
		level.epx_zombies[i].crate1 CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		level.epx_zombies[i].crate1.angles = (90,0,0);
		level.epx_zombies[i].crate1 Solid();
		level.epx_zombies[i].crate1 hide();
		level.epx_zombies[i].crate1.team = "axis";
		level.epx_zombies[i].crate1.name = "botCrate"+i;
		level.epx_zombies[i].crate1 setCanDamage(true);
		level.epx_zombies[i].crate1.maxhealth = 100;
		level.epx_zombies[i].crate1.health = 100;
		level.epx_zombies[i].crate1 linkto( level.epx_zombies[i], "j_spinelower" );
		level.epx_zombies[i].hasMarker = false;
		level.epx_zombies[i].team = "axis";
		level.epx_zombies[i].name = "bot" + i;
		level.epx_zombies[i].targetname = "bot";
		level.epx_zombies[i].classname = "bot";
		level.epx_zombies[i].currentsurface = "default";
		level.epx_zombies[i].kills = 0;
		level.epx_zombies[i].pers["isAlive"] = true;
		level.epx_zombies[i].type = "normal_zombie";
		level.epx_zombies[i] Solid();
		level.epx_zombies[i].angry = false;
		level.epx_zombies[i].angryNotDone = true;
		level.epx_zombies[i].targett = player;
		level.Zombies_Alive += 1;
		wait 2;
		level.epx_zombies[i] thread zombieWakeUp(player);
	}
}
setAnimation(t)//Idle,Walk,Run,Sprint
{
	if(!isDefined(t))
	{
		if(self.Idle==true && self.Walk==false && self.Run==false && self.Sprint==false)//Idle
		{
			self.Speed = 0;
			self scriptModelPlayAnim("pb_stand_alert_akimbo");
		}
		else if(self.Idle==false && self.Walk==true && self.Run==false && self.Sprint==false)//Walk
		{
			self.Speed = 50;
			self scriptModelPlayAnim("pb_walk_forward_akimbo");
		}
		else if(self.Idle==false && self.Walk==false && self.Run==true && self.Sprint==false)//Run
		{
			self.Speed = 120;
			self scriptModelPlayAnim("pb_combatrun_forward_akimbo");
		}
		else if(self.Idle==false && self.Walk==false && self.Run==false && self.Sprint==true)//Sprint
		{
			self.Speed = 220;
			self scriptModelPlayAnim("pb_sprint_akimbo");
		}
		else
		{
			self.Idle = true;
			self.Walk = false;
			self.Run = false;
			self.Sprint = false;
			self.Speed = 0;
			self scriptModelPlayAnim("pb_stand_alert_akimbo");
		}
	}
	else
	{
		if(self.type=="normal_zombie")
		{
			if(t=="idle")
			{
				self.Idle = true;
				self.Walk = false;
				self.Run = false;
				self.Sprint = false;
				self scriptModelPlayAnim("pb_stand_alert_akimbo");
				self.Speed = 0;
			}
			else if(t=="walk")
			{
				self.Idle = false;
				self.Walk = true;
				self.Run = false;
				self.Sprint = false;
				self scriptModelPlayAnim("pb_walk_forward_akimbo");
				self.Speed = 50;
			}
			else if(t=="run")
			{
				self.Idle = false;
				self.Walk = false;
				self.Run = true;
				self.Sprint = false;
				self scriptModelPlayAnim("pb_combatrun_forward_akimbo");
				self.Speed = 120;
			}
			else if(t=="sprint")
			{
				self.Idle = false;
				self.Walk = false;
				self.Run = false;
				self.Sprint = true;
				self scriptModelPlayAnim("pb_sprint_akimbo");
				self.Speed = 220;
			}
			else
			{
				self.Idle = true;
				self.Walk = false;
				self.Run = false;
				self.Sprint = false;
				self scriptModelPlayAnim("pb_stand_alert_akimbo");
				self.Speed = 0;
			}
		}
	}
}
zombieWakeUp(target)
{
	self thread zombieWakeUpDone();
	self zombieRespawnAtBetterPoint(target);
	wait 0.05;
	self notify("zombie_spawned");
	wait 0.05;
}
zombieWakeUpDone()
{
	self waittill("zombie_spawned");
	wait .5;
	self thread setAnimation();
	self thread MonitorZombieHealth_defaultZombiee();
	self thread MonitorZombieAttack_defaultZombiee();
	self thread BotMoveMonitor_defaultZombiee();
}

MonitorZombieAttack_defaultZombiee()
{
	self endon("im_dead");
	for(;;)
	{
		pTarget = self.targett;
		if(distancesquared(pTarget.origin, self.origin) <= 729 && pTarget.inLastStand != true && pTarget.inFinalStand != true && pTarget.pers["team"] == "allies")
		{
			self.knife = spawn("script_model", self getTagOrigin("tag_inhand"));
			self.knife setModel("weapon_parabolic_knife");
			self.knife.angles = (0,0,0);
			self.knife linkto( self, "tag_inhand" );
			self scriptModelPlayAnim("pt_melee_pistol_1");
			wait 0.15;
			self playSound("melee_knife_stab");
			playFx(level.bloodfx,self.origin+(0,0,30));
			pTarget thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper( self, self, 50, 0, "MOD_MELEE", "none", pTarget.origin, pTarget.origin, "none", 0, 0 );
			wait 1;
			self.knife delete();
			self setAnimation();
			}
		wait 0.01;
	}
}


MonitorZombieHealth_defaultZombiee()
{
	self endon("im_dead");
	for(;;)
	{
		self.crate1 waittill("damage",iDamage,attacker,iDFlags,vPoint,type,victim,vDir,sHitLoc,psOffsetTime,sWeapon);
		if(attacker==self.targett)
		{
			self notify("hit");
			if(!self.angry && self.angryNotDone==true)
			{
				self.angry = true;
			}
			playFx(level.BotHit_bloodfx,vPoint);playFx(level.BotHit_bloodfx_two,vPoint);playFx(level.BotHit_bloodfx_three,vPoint);
			playFx(level.BotHit_bloodfx,vPoint);playFx(level.BotHit_bloodfx_two,vPoint);playFx(level.BotHit_bloodfx_three,vPoint);
			playFx(level.BotHit_bloodfx,vPoint);playFx(level.BotHit_bloodfx_two,vPoint);playFx(level.BotHit_bloodfx_three,vPoint);
			self thread HitPainAnim_defaultZombiee();
			self thread [[level.callbackplayerdamage]](undefined,attacker,iDamage,iDFlags,type,sWeapon,Vpoint,vDir,sHitLoc,psOffsetTime,undefined);
			if((self.crate1.health <= 0)&&(self.name!=""))
			{
				self.pers["isAlive"] = false;
				self.crate1 delete();
				self thread DeathReguler_defaultZombiee();
				level.Zombies_Alive -= 1;
				self notify("im_dead");
			}
		}
		wait 0.01;
	}
}
HitPainAnim_defaultZombiee()
{
	self endon("im_dead");
	self endon("hit");
	self scriptModelPlayAnim("pb_stumble_forward");
	wait 0.4;
	self setAnimation();
}
DeathReguler_defaultZombiee()
{
	switch(randomInt(3))
	{
		case 0: self scriptModelPlayAnim("pb_death_run_stumble");
		break;
		case 1: self scriptModelPlayAnim("pb_stand_death_leg_kickup");
		break;
		case 2: self scriptModelPlayAnim("pb_stand_death_shoulderback");
		break;
	}
	wait 2;
	self delete();
}


//Move
BotMoveMonitor_defaultZombiee()
{
	self endon("im_dead");
	self setAnimation("walk");
	self.TargetKillGoal = false;
	self.TargetKillGoalNotDone = true;
	for(;;)
	{
		self PushOutOfPlayers();
		target = self.targett;
		if(!level.ZombieFroze)
		{
			if(isDefined(target))
			{
				if(distance(self.origin,target.origin)<1300)
				{
					if(!self.TargetKillGoal && self.TargetKillGoalNotDone==true && distance(self.origin,target.origin)<270 && !self.angry)
					{
						self setAnimation("run");
						self.TargetKillGoal = true;
						self.TargetKillGoalNotDone = false;
					}
					if(self.angry==true && self.angryNotDone==true)
					{
						self setAnimation("sprint");
						self.angryNotDone = false;
					}
					if(self.Idle==true)
					{
						self setAnimation("walk");
					}
					self MoveTo(target.origin,(distance(self.origin,target.origin)/self.Speed));
					movetoLoc = VectorToAngles(target getTagOrigin("j_head")-self getTagOrigin("j_head"));
					self RotateTo((0,movetoLoc[1],0),0.1);
				}
				else if(distance(self.origin,target.origin)>1300)
				{
					if(!self.Idle)
					{
						self setAnimation("idle");
					}
					self thread zombieRespawnAtBetterPoint(target);
				}
				else
				{
					wait .2;
				}
			}
			else
			{
				self zombieSuicide();
			}
		}
		else
		{
			if(!self.Idle)
			{
				self setAnimation("idle");
			}
		}
		wait 0.01;
	}
	wait 0.05;
}
zombieRespawnAtBetterPoint(target)
{
	self.origin = target.origin+(400,300,0);
	wait 0.01;
}
zombieSuicide()
{
	self.pers["isAlive"] = false;
	self.crate1 delete();
	self thread DeathReguler_defaultZombiee();
	level.Zombies_Alive -= 1;
	self notify("im_dead");
	iprintln("suicide");
}
ClampToGround()
{
	wait 0.001;
	trace = bulletTrace(self.origin + (0,0,50), self.origin + (0,0,-40), false, self);
	if(isdefined(trace["entity"]) && isDefined(trace["entity"].targetname) && trace["entity"].targetname == "bot")
		trace = bulletTrace(self.origin + (0,0,50), self.origin + (0,0,-40), false, trace["entity"]);
	self.origin = (trace["position"]);
	self.currentsurface = trace["surfacetype"];
	if(self.currentsurface == "none")
		self.currentsurface = "default";
}
PushOutOfPlayers()
{
	wait 0.001;
	trace = bulletTrace(self.origin+(0,0,50),self.origin+(0,0,-40),false,self);
	if(isdefined(trace["entity"])&&isDefined(trace["entity"].targetname)&&trace["entity"].targetname=="bot")
		trace = bulletTrace(self.origin+(0,0,50),self.origin+(0,0,-40),false,trace["entity"]);
	self.origin = (trace["position"]);
	self.currentsurface = trace["surfacetype"];
	if(self.currentsurface == "none")
		self.currentsurface = "default";
	self endon("im_dead");
	self endon("respawn_done");
	players = level.epx_zombies;
	for(i=0;i<players.size;i++)
	{
		player = players[i];
		if(player == self)
			continue;
		if(!self.pers["isAlive"])
			continue;
		distance = distance(player.origin,self.origin);
		minDistance = 25;
		if(distance < minDistance)
		{
			pushOutDir = VectorNormalize((self.origin[0],self.origin[1],0)-(player.origin[0],player.origin[1],0));
			trace = bulletTrace(self.origin+(0,0,20),(self.origin+(0,0,20))+(pushOutDir*((minDistance-distance)+10)),false,self);
			if(trace["fraction"]==1)
			{
				pushoutPos = self.origin+(pushOutDir*(minDistance-distance));
				self.origin = (pushoutPos[0],pushoutPos[1],self.origin[2]); 
				self notify("push_out_done");
			}
		}
	}
}