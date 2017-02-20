#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_overFlowFix;

#include FuZiioN\_common_scripts;
#include FuZiioN\_menu;
#include FuZiioN\_system;

CreateGrids(corner1,corner2,angle)
{
	W=Distance((corner1[0],0,0),(corner2[0],0,0));
	L=Distance((0,corner1[1],0),(0,corner2[1],0));
	H=Distance((0,0,corner1[2]),(0,0,corner2[2]));
	CX=corner2[0] - corner1[0];
	CY=corner2[1] - corner1[1];
	CZ=corner2[2] - corner1[2];
	ROWS=roundUp(W/55);
	COLUMNS=roundUp(L/30);
	HEIGHT=roundUp(H/20);
	XA=CX/ROWS;
	YA=CY/COLUMNS;
	ZA=CZ/HEIGHT;
	center=spawn("script_model",corner1);
	for(r=0;r<=ROWS;r++)
	{
		for(c=0;c<=COLUMNS;c++)
		{
			for(h=0;h<=HEIGHT;h++)
			{
				block=spawn("script_model",(corner1 +(XA * r,YA * c,ZA * h)));
				block setModel("com_plasticcase_friendly");
				block.angles =(0,0,0);
				block Solid();
				block LinkTo(center);
				block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
				wait 0.01;
			}
		}
	}
	center.angles=angle;
}
roundUp(floatVal)
{
	if(int(floatVal)!= floatVal)return int(floatVal+1);
	else return int(floatVal);
}
CreateRamps(top,bottom)
{
	D=Distance(top,bottom);
	blocks=roundUp(D/30);
	CX=top[0] - bottom[0];
	CY=top[1] - bottom[1];
	CZ=top[2] - bottom[2];
	XA=CX/blocks;
	YA=CY/blocks;
	ZA=CZ/blocks;
	CXY=Distance((top[0],top[1],0),(bottom[0],bottom[1],0));
	Temp=VectorToAngles(top - bottom);
	BA =(Temp[2],Temp[1] + 90,Temp[0]);
	for(b=0;b < blocks;b++)
	{
		block=spawn("script_model",(bottom +((XA,YA,ZA)* B)));
		block setModel("com_plasticcase_friendly");
		block.angles=BA;
		block Solid();
		block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		wait 0.01;
	}
	block=spawn("script_model",(bottom +((XA,YA,ZA)* blocks)-(0,0,5)));
	block setModel("com_plasticcase_friendly");
	block.angles =(BA[0],BA[1],0);
	block Solid();
	block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	wait 0.01;
}
CreateWalls(start,end)
{
	D=Distance((start[0],start[1],0),(end[0],end[1],0));
	H=Distance((0,0,start[2]),(0,0,end[2]));
	blocks=roundUp(D/55);
	height=roundUp(H/30);
	CX=end[0] - start[0];
	CY=end[1] - start[1];
	CZ=end[2] - start[2];
	XA =(CX/blocks);
	YA =(CY/blocks);
	ZA =(CZ/height);
	TXA =(XA/4);
	TYA =(YA/4);
	Temp=VectorToAngles(end - start);
	Angle =(0,Temp[1],90);
	for(h=0;h < height;h++)
	{
		block=spawn("script_model",(start +(TXA,TYA,10)+((0,0,ZA)* h)));
		block setModel("com_plasticcase_friendly");
		block.angles=Angle;
		block Solid();
		block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		wait 0.001;
		for(i=1;i < blocks;i++)
		{
			block=spawn("script_model",(start +((XA,YA,0)* i)+(0,0,10)+((0,0,ZA)* h)));
			block setModel("com_plasticcase_friendly");
			block.angles=Angle;
			block Solid();
			block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
			wait 0.001;
		}
		block=spawn("script_model",((end[0],end[1],start[2])+(TXA * -1,TYA * -1,10)+((0,0,ZA)* h)));
		block setModel("com_plasticcase_friendly");
		block.angles=Angle;
		block Solid();
		block CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		wait 0.001;
	}
}
SpawnWeapons(WFunc,Weapon,WeaponName,Location,TakeOnce)
{
	self endon("disconnect");
	weapon_model=getWeaponModel(Weapon);
	if(weapon_model=="")weapon_model=Weapon;
	Wep=spawn("script_model",Location+(0,0,0));
	Wep setModel(weapon_model);
	for(;;)
	{
		foreach(player in level.players)
		{
			Radius=distance(Location,player.origin);
			if(Radius<60)
			{
				player setLowerMessage(WeaponName,"Press ^3[{+usereload}]^7 To Swap For "+WeaponName);
				if(player UseButtonPressed())wait 0.2;
				if(player UseButtonPressed())
				{
					if(!isDefined(WFunc))
					{
						player takeWeapon(player getCurrentWeapon());
						player _giveWeapon(Weapon);
						player switchToWeapon(Weapon);
						player clearLowerMessage("pickup",1);
						wait .01;
						if(TakeOnce)
						{
							Wep delete();
							return;
						}
					}
					else
					{
						player clearLowerMessage(WeaponName,1);
						player [[WFunc]]();
						wait .01;
					}
				}
			}
			else
			{
				player clearLowerMessage(WeaponName,1);
			}
			wait 0.1;
		}
		wait 0.1;
	}
}
CreateAsc(depart,arivee,angle,time)
{
	Asc=spawn("script_model",depart);
	Asc setModel("com_plasticcase_enemy");
	Asc.angles=angle;
	Asc Solid();
	Asc CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	Asc thread Escalator(depart,arivee,time);
}
Escalator(depart,arivee,time)
{
	while(1)
	{
		if(self.state=="open")
		{
			self MoveTo(depart,time);
			wait(time*3);
			self.state="close";
			continue;
		}
		if(self.state=="close")
		{
			self MoveTo(arivee,time);
			wait(time*3);
			self.state="open";
			continue;
		}
	}
}
CreateElevator(enter,exit,angle)
{
	flag=spawn("script_model",enter);
	flag setModel(level.elevator_model["enter"]);
	wait 0.01;
	flag=spawn("script_model",exit);
	flag setModel(level.elevator_model["exit"]);
	wait 0.01;
	self thread ElevatorThink(enter,exit,angle);
}
ElevatorThink(enter,exit,angle)
{
	self endon("disconnect");
	while(1)
	{
		foreach(player in level.players)
		{
			if(Distance(enter,player.origin)<= 50)
			{
				player SetOrigin(exit);
				player SetPlayerAngles(angle);
			}
		}
		wait .25;
	}
}
stairwayTH()
{
	if(!self.Hell)
	{
		if(level.StairWay==true)
		{
			self iprintlnBold("^1Only 1 Per Game!");
			return;
		}
		self thread HudElemSize();
		self thread heaven();
		self iprintln("^2Enabled");
		self.Hell=true;
		level.StairWay = true;
	}
	else
	{
		self thread hell();
		self iprintln("^1Disabled");
		self.Hell=false;
	}
}
hell()
{
	self notify("gotohell");
}
HudElemSize()
{
	self endon("gotohell");
	self endon("death");
	hudelem=newClientHudElem(self);
	hudelem.alignX="center";
	hudelem.alignY="top";
	hudelem.horzAlign="center";
	hudelem.vertAlign="top";
	hudelem.fontscale=1;
	hudelem.font="hudbig";
	hudelem.hideWhenInMenu=true;
	self thread destroyTHWEWHudOnEnd(hudelem);
	for(;;)
	{
		if(self FragButtonPressed())self.StairSize++;
		else if(self SecondaryOffhandButtonPressed())self.StairSize--;
		hudelem setSafeText("Size: "+self.StairSize);
		wait 0.05;
	}
}
destroyTHWEWHudOnEnd(elem)
{
	self waittill("gotohell");
	elem destroy();
}
floors()
{
	self endon("jw");
	self iPrintLnBold("Please press down at starting persission of [^1FLOOR^7]");
	self notifyOnPlayerCommand("SL","+actionslot 2");
	for(;;)
	{
		self waittill("SL");
		st=self getOrigin();
		self iPrintLn("Start persission saved.");
		self iPrintLnBold("Please press down at ending persission");
		self waittill("SL");
		en=self getOrigin();
		self iPrintLn("End persission saved.");
		self iPrintLnBold("ready,press down to start build.");
		self waittill("SL");
		self iPrintLn("started....");
		CreateGrids((st),(en),(0,0,0));
		self iPrintLn("Done.");
		self notify("jw");
	}
}
heaven()
{
	self endon("gotohell");
	self endon("death");
	wait 1;
	self iprintlnbold("Press [{+smoke}]/[{+frag}] to change stair height");
	wait 1.5;
	self iprintlnbold("Press [{+actionslot 3}] to spawn");
	wait 1.5;
	self notifyonplayercommand("change","+actionslot 3");
	self.StairSize=200;
	for(;;)
	{
		self waittill("change");
		vec=anglestoforward(self getPlayerAngles());
		center=BulletTrace(self gettagorigin("tag_eye"),self gettagorigin("tag_eye")+(vec[0] * 200000,vec[1] * 200000,vec[2] * 200000),0,self)[ "position" ];
		level.center=spawn("script_origin",center);
		level.stairs=[];
		origin=level.center.origin+(70,0,0);
		h=0;
		for(i=0;i<self.StairSize;i++)
		{
			level.center rotateyaw(22.5,0.05);
			wait 0.05;
			level.center moveto(level.center.origin+(0,0,18),0.05);
			wait 0.05;
			level.stairs[i]=spawn("script_model",origin);
			level.stairs[i] setmodel("com_plasticcase_friendly");
			level.stairs[i] linkto(level.center);
			level.stairs[i] CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
		}
		level.center moveto(level.center.origin-(0,0,10),0.05);
	}
}
prisonBuild()
{
	if(self ishost()&&(!self.PrisonRunOnce))
	{
		self.PrisonRunOnce=1;
		self thread testprison();
		self iprintln("^2Buiding prison Please wait");
		wait 5;
		self iprintln("^3Done");
		level.CubeBuildingDone = true;
		if(self.FuZiioN["Menu"]["Open"]==true)
		{
			self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
		}
	}
}
testprison()
{
	CreateWalls((990,3,3040),(790,3,3080));
	CreateWalls((990,3,3120),(790,3,3160));
	CreateWalls((790,3,3040),(790,-150,3080));
	CreateWalls((790,3,3120),(790,-150,3160));
	CreateGrids((990,3,3040),(790,-150,3040));
	CreateGrids((990,3,3160),(790,-150,3160));
	CreateWalls((790,-150,3040),(990,-150,3080));
	CreateWalls((790,-150,3120),(990,-150,3160));
	CreateWalls((990,3,3040),(990,-150,3080));
	CreateWalls((990,3,3120),(990,-150,3160));
	lt1=loadfx("misc/flare_ambient");
	playfx(lt1,(820,-27.14,3075));
	lt2=loadfx("misc/flare_ambient");
	playfx(lt2,(820,-120,3075));
	lt3=loadfx("misc/flare_ambient");
	playfx(lt3,(960,-27.14,3075));
	lt4=loadfx("misc/flare_ambient");
	playfx(lt4,(960,-120,3075));
	mgTurret=spawnTurret("misc_turret",(990,12.783,3070),"pavelow_minigun_mp");
	mgTurret setModel("weapon_minigun");
	mgTurret.angles =(0,-0,0);
	mgTurret=spawnTurret("misc_turret",(790,12.783,3070),"pavelow_minigun_mp");
	mgTurret setModel("weapon_minigun");
	mgTurret.angles =(0,-0,0);
	mgTurret=spawnTurret("misc_turret",(980,-140,3070),"pavelow_minigun_mp");
	mgTurret setModel("weapon_minigun");
	mgTurret.angles =(0,-0,0);
	mgTurret=spawnTurret("misc_turret",(780,-140,3070),"pavelow_minigun_mp");
	mgTurret setModel("weapon_minigun");
	mgTurret.angles =(0,-0,0);
}
SC22T()
{
	self endon("jw");
	self iPrintLnBold("Press [{+actionslot 2}] To Spawn Flag");
	self notifyOnPlayerCommand("SL","+actionslot 2");
	for(;;)
	{
		self waittill("SL");
		st=self getOrigin();
		self iPrintLn("Start persission saved.");
		self iPrintLnBold("Press [{+actionslot 2}] At Ending Persission");
		self waittill("SL");
		en=self getOrigin();
		self iPrintLn("End Persission Saved.");
		self iPrintLnBold("Ready,Press [{+actionslot 2}] To Start Build.");
		self waittill("SL");
		self iPrintLn("Started");
		CreateElevator((st),(en),(0,0,0));
		self iPrintLn("Done.");
		self notify("jw");
	}
}
artillery()
{
	if(level.forge_artillery_count>3)
	{
		self iprintlnBold("^1Max Artillery Gun Count Reached");
		return;
	}
	level.forge_artillery_count ++;
	center=spawn("script_origin",bullettrace(self gettagorigin("j_head"),self gettagorigin("j_head")+anglestoforward(self getplayerangles())*20000000,0,self)["position"]);
	org=center.origin;
	level.artillery=[];
	level.artillery[0]=cbox(org+(41.25,0,0));
	level.artillery[1]=cbox(org+(96.25,0,0));
	level.artillery[2]=cbox(org+(-41.25,0,0));
	level.artillery[3]=cbox(org+(-96.25,0,0));
	level.artillery[4]=cbox(org+(0,41.25,0));
	level.artillery[5]=cbox(org+(0,96.25,0));
	level.artillery[6]=cbox(org+(0,-41.25,0));
	level.artillery[7]=cbox(org+(0,-96.25,0));
	level.swivel=[];
	level.swivel[0]=cbox(org-(0,0,14));
	level.swivel[0].angles =(90,0,0);
	level.swivel[1]=cbox(org+(0,0,28));
	level.swivel[2]=cbox(org+(41.25,0,69));
	level.swivel[2].angles =(90,0,0);
	level.swivel[3]=cbox(org+(-41.25,0,69));
	level.swivel[3].angles =(-90,0,0);
	level.swivel[4]=cbox(org+(-41.25,0,29));
	level.swivel[4].angles =(0,90,0);
	level.swivel[5]=cbox(org+(41.25,0,29));
	level.swivel[5].angles =(0,-90,0);
	level.swivel[6]=cbox(org+(-41.25,0,110));
	level.swivel[6].angles =(0,90,0);
	level.swivel[7]=cbox(org+(41.25,0,110));
	level.swivel[7].angles =(0,-90,0);
	level.barrel=[];
	for(i=0;i<=6;i++)
	{
		level.barrel[i]=cbox(org+(0,i*55-110,110));
		level.barrel[i].angles =(0,90,0);
	}
	level.barrel[7]=cbox(org+(0,0,109.99));
	for(i=4;i<=7;i++)level.artillery[i].angles =(0,90,0);
	level.gunpos=spawn("script_origin",org+(0,245,110));
	level.gunpos.angles =(0,90,0);
	level.pitch=spawn("script_origin",org+(0,0,110));
	foreach(barrel in level.barrel)barrel linkto(level.pitch);
	level.gunpos linkto(level.pitch);
	level.turn=spawn("script_origin",org);
	foreach(swivel in level.swivel)swivel linkto(level.turn);
	level.turn linkto(level.pitch);
	level.computer=cbox(org+(-165,-165,14));
	level.computer.angles =(0,-45,0);
	level.pc=spawn("script_model",level.computer.origin+(0,0,14));
	level.pc setModel("com_laptop_2_open");
	level.pc.angles =(0,-135,0);
	level.pctrig=spawn("trigger_radius",level.computer.origin,0,70,70);
	level.pctrig thread managepc();
}
cbox(location)
{
	box=spawn("script_model",location);
	box setModel("com_plasticcase_enemy");
	box CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	return box;
}
PlayerToCube(guy)
{	
    guy.location = (900, -78, 3055.1);	
    guy setOrigin(guy.location);
    //guy thread doGodmode();
}
managepc()
{
	player="fsf";
	if(level.xenon||level.ps3)use="[{+usereload}]";
	else use="[{+activate}]";
	for(;;)
	{
		player clearlowermessage("artillery");
		pressed=0;
		self waittill("trigger",player);
		player setlowermessage("artillery","Push ^3[{+frag}]^7 or ^3[{+smoke}]^7 to change pitch\nPush ^3"+use+"^7 or ^3[{+melee}]^7 to turn\n Push ^3[{+attack}]^7 or ^3[{+speed_throw}]^7 to ^1FIRE");
		if(!pressed)while(player fragbuttonpressed())
		{
			pressed=1;
			level.turn unlink();
			if(level.pitch.angles[2]<=37.5)level.pitch rotateto(level.pitch.angles+(0,0,2),0.2);
			wait 0.2;
		}
		if(!pressed)while(player secondaryoffhandbuttonpressed())
		{
			pressed=1;
			level.turn unlink();
			if(level.pitch.angles[2]>=-22)level.pitch rotateto(level.pitch.angles-(0,0,2),0.2);
			wait 0.2;
		}
		if(!pressed)while(player meleebuttonpressed())
		{
			pressed=1;
			level.pitch rotateto(level.pitch.angles-(0,2,0),0.2);
			wait 0.2;
		}
		if(!pressed)while(player usebuttonpressed())
		{
			pressed=1;
			level.pitch rotateto(level.pitch.angles+(0,2,0),0.2);
			wait 0.2;
		}
		if(!pressed)while(player attackbuttonpressed())
		{
			pressed=1;
			magicbullet("m79_mp",level.gunpos.origin,level.gunpos.origin+anglestoforward(level.gunpos.angles)*10000);
			wait 0.5;
		}
		if(!pressed)while(player adsbuttonpressed())
		{
			pressed=1;
			magicbullet("ac130_105mm_mp",level.gunpos.origin,level.gunpos.origin+anglestoforward(level.gunpos.angles)*10000);
			earthquake(0.5,0.75,level.turn.origin,800);
			player playSound("exp_airstrike_bomb");
			playfx(level.chopper_fx["explode"]["medium"],level.gunpos.origin);
			for(i=0;i<=6;i++)
			{
				level.barrel[i] unlink();
				level.barrel[i] moveto(level.barrel[i].origin-anglestoforward(level.barrel[i].angles)*50,0.05);
			}
			wait 0.1;
			for(i=0;i<=6;i++)level.barrel[i] moveto(level.barrel[i].origin-anglestoforward(level.barrel[i].angles)*-50,0.5,0.4,0.1);
			wait 2;
		}
		foreach(swivel in level.swivel)swivel linkto(level.turn);
		level.turn linkto(level.pitch);
		foreach(barrel in level.barrel)barrel linkto(level.pitch);
		wait 0.05;
	}
}
walls()
{
	self endon("jw");
	self iPrintLnBold("Please press down at starting persission of [^1WALL^7]");
	self notifyOnPlayerCommand("SL","+actionslot 2");
	for(;;)
	{
		self waittill("SL");
		st=self getOrigin();
		self iPrintLn("Start persission saved.");
		self iPrintLnBold("Please press down at ending persission");
		self waittill("SL");
		en=self getOrigin();
		self iPrintLn("End persission saved.");
		self iPrintLnBold("ready,press down to start build.");
		self waittill("SL");
		self iPrintLn("started....");
		CreateWalls(st,en);
		self iPrintLn("Done.");
		self notify("jw");
	}
}
ramps()
{
	self endon("jw");
	self iPrintLnBold("Please press down at starting persission of [^1RAMP^7]");
	self notifyOnPlayerCommand("SL","+actionslot 2");
	for(;;)
	{
		self waittill("SL");
		st=self getOrigin();
		self iPrintLn("Start persission saved.");
		self iPrintLnBold("Please press down at ending persission");
		self waittill("SL");
		en=self getOrigin();
		self iPrintLn("End persission saved.");
		self iPrintLnBold("ready,press down to start build.");
		self waittill("SL");
		self iPrintLn("started....");
		CreateRamps(st,en);
		self iPrintLn("Done.");
		self notify("jw");
	}
}






Pix_Skybase()
{
	if(level.pixBaseSpawned==true)
	{
		self iprintlnBold("^1Already Spawned!");
		return;
	}
	origin = self.origin+(40,40,0);
	level.baseBox = [];
	for(i=0;i<7;i++){level.baseBox[0][i] = pixBox(origin+(i*60,0,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[1][i] = pixBox(origin+(i*60,35,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[2][i] = pixBox(origin+(i*60,70,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[3][i] = pixBox(origin+(i*60,105,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[4][i] = pixBox(origin+(i*60,140,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[5][i] = pixBox(origin+(i*60,175,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[6][i] = pixBox(origin+(i*60,210,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[7][i] = pixBox(origin+(i*60,245,0));wait .2;}
	wait .2;
	for(i=0;i<7;i++){level.baseBox[8][i] = pixBox(origin+(i*60,280,0));wait .2;}
	wait .2;
	level.baseBox_Control = pixBox(origin+(60,0,22));
	level.baseStartPoint = origin;
	level.pixBase_TakeOff = false;
	level.pixBase_Controller_Used = false;
	level.controll_master = "";
	
	level.baseBox_ACweap_Control = pixBox(origin+(6*60,0,22));
	level.pixBaseACweapon_Used = false;
	level.pixBaseACweapon_master = "";
	
	thread pixBaseMonitor();
	level.pixBaseSpawned = true;
	if(self.FuZiioN["Menu"]["Open"]==true)
	{
		self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
	}
}
pixBaseMonitor()
{
	for(;;)
	{
		foreach(player in level.players)
		{
			//Base Controll Start
			if(distance(player.origin,level.baseBox_Control.origin)<70 && !level.pixBase_Controller_Used)
			{
				player setLowerMessage("activate","^3[{+activate}]^7 - Controll Skybase");
				if(player UseButtonPressed())
				{
					level.pixBase_Controller_Used = true;
					level.controll_master = player;
					level.controll_master freezeControls(true);
					level.controll_master.Camera = spawn("script_model",level.controll_master.origin+(0,0,500));
					level.controll_master.Camera setModel("c130_zoomrig");
					level.controll_master.Camera.angles = (90,90,0);
					level.controll_master.Camera NotSolid();
					level.controll_master.Camera EnableLinkTo();
					wait 0.001;
					level.controll_master CameraLinkTo(level.controll_master.Camera,"tag_origin");
					level.controll_master thread camMover();
					player clearLowerMessage("activate",.1);
					wait .1;
					level.controll_master setLowerMessage("controll_info","^3[{+frag}]^7/^3[{+smoke}]^7/^3[{+attack}]^7/^3[{+aim}]^7 - Move Skybase\n^3[{+activate}]^7 - Take Off or Land Skybase\n^3[{+melee}]^7 - Exit Controll Mode");
					wait .4;
				}
			}
			if(distance(player.origin,level.baseBox_Control.origin)>80)
			{
				player clearLowerMessage("activate",.1);
			}
			if(level.pixBase_Controller_Used==true)
			{
				if(level.controll_master UseButtonPressed())
				{
					if(!level.pixBase_TakeOff)
					{
						iprintln("^1Taking OFF");
						baseTakeOFF();
						level.pixBase_TakeOff = true;
					}
					else
					{
						iprintln("^1Landing");
						baseLand();
						level.pixBase_TakeOff = false;
					}
					wait .4;
				}
				if(level.controll_master AdsButtonPressed() && level.pixBase_TakeOff==true)
				{
					moveBaseXPlus(50,.5);
				}
				if(level.controll_master AttackButtonPressed() && level.pixBase_TakeOff==true)
				{
					moveBaseXMinus(50,.5);
				}
				if(level.controll_master SecondaryOffHandButtonPressed() && level.pixBase_TakeOff==true)
				{
					moveBaseYMinus(50,.5);
				}
				if(level.controll_master FragButtonPressed() && level.pixBase_TakeOff==true)
				{
					moveBaseYPlus(50,.5);
				}
				if(level.controll_master MeleeButtonPressed())
				{
					level.controll_master clearLowerMessage("controll_info",.1);
					level.controll_master notify("Exit_ControllMode");
					level.controll_master.Camera delete();
					level.controll_master CameraUnlink();
					level.controll_master freezeControls(false);
					level.pixBase_Controller_Used = false;
					level.controll_master = "";
					wait .4;
				}
			}
			//Base Controll End
			if(distance(player.origin,level.baseBox_ACweap_Control.origin)<70 && !level.pixBaseACweapon_Used && level.pixBase_TakeOff==true)
			{
				player setLowerMessage("activate_ac","^3[{+activate}]^7 - Controll AC-130 Weapon");
				if(player UseButtonPressed())
				{
					player clearLowerMessage("activate",.1);
					level.pixBaseACweapon_Used = true;
					level.pixBaseACweapon_master = player;
					//level.pixBaseACweapon_master freezeControls(true);
					level.pixBaseACweapon_master setLowerMessage("controll_ac","^3[{+melee}]^7 - Exit AC-130 Weapon");
					level.pixBaseACweapon_master.oldOrigin = level.pixBaseACweapon_master.origin;
					level.pixBaseACweapon_master.AC = spawn("script_model",level.baseBox_ACweap_Control.origin-(0,0,100));
					level.pixBaseACweapon_master.AC setModel("c130_zoomrig");
					level.pixBaseACweapon_master.AC NotSolid();
					level.pixBaseACweapon_master thread ACGun();
					level.pixBaseACweapon_master PlayerLinkTo(level.pixBaseACweapon_master.AC);
					wait .4;
				}
			}
			if(distance(player.origin,level.baseBox_ACweap_Control.origin)>80)
			{
				player clearLowerMessage("activate_ac",.1);
			}
			if(level.pixBaseACweapon_Used==true)
			{
				if(level.pixBaseACweapon_master MeleeButtonPressed())
				{
					level.pixBaseACweapon_master notify("Exit_ControllMode");
					level.pixBaseACweapon_master ThermalVisionFOFOverlayOff();
					level.pixBaseACweapon_master takeWeapon("ac130_105mm_mp");
					level.pixBaseACweapon_master takeWeapon("ac130_40mm_mp");
					level.pixBaseACweapon_master takeWeapon("ac130_25mm_mp");
					level.pixBaseACweapon_master switchToWeapon(level.pixBaseACweapon_master.weapTemp);
					level.pixBaseACweapon_master.weapTemp="";
					level.pixBaseACweapon_master unlink();
					level.pixBaseACweapon_master setOrigin(level.pixBaseACweapon_master.oldOrigin);
					level.pixBaseACweapon_master.AC delete();
					level.pixBaseACweapon_master clearLowerMessage("controll_ac",.1);
					level.pixBaseACweapon_master freezeControls(false);
					level.pixBaseACweapon_master = "";
					level.pixBaseACweapon_Used = false;
					wait .4;
				}
			}
			
			
			
		}
		wait 0.05;
	}
}
baseTakeOFF()
{
	level.controll_master.Taker = spawn("script_origin",level.controll_master.origin);
	level.controll_master playerlinkto(level.controll_master.Taker);
	level.controll_master.Taker moveto(level.controll_master.Taker.origin+(0,0,1500),15);
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[0][i] moveto(level.baseBox[0][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[1][i] moveto(level.baseBox[1][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[2][i] moveto(level.baseBox[2][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[3][i] moveto(level.baseBox[3][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[4][i] moveto(level.baseBox[4][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[5][i] moveto(level.baseBox[5][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[6][i] moveto(level.baseBox[6][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[7][i] moveto(level.baseBox[7][i].origin+(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[8][i] moveto(level.baseBox[8][i].origin+(0,0,1500),15);}
	level.baseBox_Control moveto(level.baseBox_Control.origin+(0,0,1500),15);
	level.baseBox_ACweap_Control moveto(level.baseBox_ACweap_Control.origin+(0,0,1500),15);
	wait 15;
	level.controll_master unlink();
	level.controll_master.Taker delete();
	level.controll_master freezeControls(true);
}
baseLand()
{
	level.controll_master.Taker = spawn("script_origin",level.controll_master.origin);
	level.controll_master playerlinkto(level.controll_master.Taker);
	level.controll_master.Taker moveto(level.controll_master.Taker.origin-(0,0,1500),15);
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[0][i] moveto(level.baseBox[0][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[1][i] moveto(level.baseBox[1][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[2][i] moveto(level.baseBox[2][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[3][i] moveto(level.baseBox[3][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[4][i] moveto(level.baseBox[4][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[5][i] moveto(level.baseBox[5][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[6][i] moveto(level.baseBox[6][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[7][i] moveto(level.baseBox[7][i].origin-(0,0,1500),15);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[8][i] moveto(level.baseBox[8][i].origin-(0,0,1500),15);}
	level.baseBox_Control moveto(level.baseBox_Control.origin-(0,0,1500),15);
	level.baseBox_ACweap_Control moveto(level.baseBox_ACweap_Control.origin-(0,0,1500),15);
	wait 15;
	level.controll_master unlink();
	level.controll_master.Taker delete();
	level.controll_master freezeControls(true);
}
moveBaseXPlus(x,speed)
{
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[0][i] moveto(level.baseBox[0][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[1][i] moveto(level.baseBox[1][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[2][i] moveto(level.baseBox[2][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[3][i] moveto(level.baseBox[3][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[4][i] moveto(level.baseBox[4][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[5][i] moveto(level.baseBox[5][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[6][i] moveto(level.baseBox[6][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[7][i] moveto(level.baseBox[7][i].origin+(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[8][i] moveto(level.baseBox[8][i].origin+(x,0,0),speed);}
	level.baseBox_Control moveto(level.baseBox_Control.origin+(x,0,0),speed);
	level.baseBox_ACweap_Control moveto(level.baseBox_ACweap_Control.origin+(x,0,0),speed);
}
moveBaseXMinus(x,speed)
{
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[0][i] moveto(level.baseBox[0][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[1][i] moveto(level.baseBox[1][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[2][i] moveto(level.baseBox[2][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[3][i] moveto(level.baseBox[3][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[4][i] moveto(level.baseBox[4][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[5][i] moveto(level.baseBox[5][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[6][i] moveto(level.baseBox[6][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[7][i] moveto(level.baseBox[7][i].origin-(x,0,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[8][i] moveto(level.baseBox[8][i].origin-(x,0,0),speed);}
	level.baseBox_Control moveto(level.baseBox_Control.origin-(x,0,0),speed);
	level.baseBox_ACweap_Control moveto(level.baseBox_ACweap_Control.origin-(x,0,0),speed);
}
moveBaseYPlus(y,speed)
{
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[0][i] moveto(level.baseBox[0][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[1][i] moveto(level.baseBox[1][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[2][i] moveto(level.baseBox[2][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[3][i] moveto(level.baseBox[3][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[4][i] moveto(level.baseBox[4][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[5][i] moveto(level.baseBox[5][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[6][i] moveto(level.baseBox[6][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[7][i] moveto(level.baseBox[7][i].origin+(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[8][i] moveto(level.baseBox[8][i].origin+(0,y,0),speed);}
	level.baseBox_Control moveto(level.baseBox_Control.origin+(0,y,0),speed);
	level.baseBox_ACweap_Control moveto(level.baseBox_ACweap_Control.origin+(0,y,0),speed);
}
moveBaseYMinus(y,speed)
{
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[0][i] moveto(level.baseBox[0][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[1][i] moveto(level.baseBox[1][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[2][i] moveto(level.baseBox[2][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[3][i] moveto(level.baseBox[3][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[4][i] moveto(level.baseBox[4][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[5][i] moveto(level.baseBox[5][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[6][i] moveto(level.baseBox[6][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[7][i] moveto(level.baseBox[7][i].origin-(0,y,0),speed);}
	for(i=0;i<level.baseBox[0].size;i++){level.baseBox[8][i] moveto(level.baseBox[8][i].origin-(0,y,0),speed);}
	level.baseBox_Control moveto(level.baseBox_Control.origin-(0,y,0),speed);
	level.baseBox_ACweap_Control moveto(level.baseBox_ACweap_Control.origin-(0,y,0),speed);
}
camMover()
{
	self endon("Exit_ControllMode");
	while(1)
	{
		self.Camera MoveTo(self.origin+(0,0,500),0.1);
		wait 0.1;
	}
}
ACGun()
{
	self endon("Exit_ControllMode");
	self ThermalVisionFOFOverlayOn();
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
pixBox(ori)
{
	pixBox = spawn("script_model",ori);
	pixBox setmodel("com_plasticcase_friendly");
	pixBox CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	return pixBox;
}
sendToPixBase(c)
{
	c setOrigin(level.baseBox[5][4].origin+(0,0,20));
	self iprintln("Sent "+c.name+" to Skybase");
}
sendToPixBaseGround(c)
{
	c setOrigin(level.baseBox[5][4].origin-(0,0,700));
	self iprintln("Sent "+c.name+" to Ground");
}
forcePixBaseLand()
{
	if(level.pixBase_TakeOff==true)
	{
		iprintln("^1Landing");
		baseLand();
		level.pixBase_TakeOff = false;
	}
}
forcePixBaseTakeoff()
{
	if(!level.pixBase_TakeOff)
	{
		iprintln("^1Taking OFF");
		baseTakeOFF();
		level.pixBase_TakeOff = true;
	}
}



//xePixTvx's Shooting Range
#using_animtree("multiplayer");
_teleportToShootRange(client)
{
	client setOrigin((-952.201,4333.07,40.9716));
}
_startShootingRange()
{
	if(level.ShootRange_Spawned==true)
	{
		self iprintlnBold("^1Already Spawned");
		return;
	}
	thread shoot_range_waypoints();
	Pos = (-803.529,3931.95,40.125);
	Pos_Two = Pos+(0,0,15);
	Pos_Third = Pos+(400,0,15);
	level.Range_Barrier = [];
	level.Range_Barrier_Two = [];
	level.Range_Barrier_Third = [];
	level.Range_Barrier_Four = [];
	for(i=0;i<7;i++){level.Range_Barrier[i] = pixBox_range(Pos+(i*60,0,15));wait .2;}
	for(i=0;i<7;i++){level.Range_Barrier_Two[i] = pixBox_range(Pos+(i*60,-960,15));wait .2;}
	for(i=0;i<17;i++){level.Range_Barrier_Third[i] = pixBox_range_two(Pos_Two-(40,i*60,0));wait .2;}
	for(i=0;i<17;i++){level.Range_Barrier_Four[i] = pixBox_range_two(Pos_Third-(0,i*60,0));wait .2;}
	level.pc_range = spawn("script_model",level.Range_Barrier_Third[0].origin+(0,0,14));
	level.pc_range setModel("com_laptop_2_open");
	level.pc_range.angles =(0,35,0);
	level.pc_range thread _shootrang_pcMonitor();
	level.ShootRange_Spawned = true;
	level.ShootRange_ShootingRunning = false;
	level.Zombies_Alive = 0;
}
_shootrang_pcMonitor()
{
	for(;;)
	{
		foreach(player in level.players)
		{
			if(distance(level.pc_range.origin,player.origin)<=70 && !level.ShootRange_ShootingRunning)
			{
				player setLowerMessage("use","^3[{+activate}]^7 - Start Shooting");
				if(player UseButtonPressed())
				{
					level.ShootRange_ShootingRunning = true;
					thread StartShootingOnRange();
					player clearLowerMessage("use",.1);
					wait .4;
				}
			}
			if(distance(level.pc_range.origin,player.origin)>=71)
			{
				player clearLowerMessage("use",.1);
			}
		}
		wait 0.05;
	}
}
pixBox_range(ori)
{
	pixBox = spawn("script_model",ori);
	pixBox setmodel("com_plasticcase_friendly");
	pixBox CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	return pixBox;
}
pixBox_range_two(ori)
{
	pixBox = spawn("script_model",ori);
	pixBox setmodel("com_plasticcase_friendly");
	pixBox.angles = (0,90,0);
	pixBox CloneBrushmodelToScriptmodel(level.airDropCrateCollision);
	return pixBox;
}
shoot_range_waypoints()
{
/*  2:36 */level.waypoints[0] = spawnstruct();
/*  2:36 */level.waypoints[0].origin =(-488.988, 3056.57, 40.125);
/*  2:36 */level.waypoints[0].type = "stand";
/*  2:36 */level.waypoints[0].childCount = 0;
/*  2:36 */level.waypoints[1] = spawnstruct();
/*  2:36 */level.waypoints[1].origin =(-603.81, 3066, 40.125);
/*  2:36 */level.waypoints[1].type = "stand";
/*  2:36 */level.waypoints[1].childCount = 0;
/*  2:36 */level.waypoints[2] = spawnstruct();
/*  2:36 */level.waypoints[2].origin =(-754.854, 3052.73, 40.125);
/*  2:36 */level.waypoints[2].type = "stand";
/*  2:36 */level.waypoints[2].childCount = 0;
/*  2:36 */level.waypoints[3] = spawnstruct();
/*  2:36 */level.waypoints[3].origin =(-766.39, 3223.44, 40.125);
/*  2:36 */level.waypoints[3].type = "stand";
/*  2:36 */level.waypoints[3].childCount = 0;
/*  2:36 */level.waypoints[4] = spawnstruct();
/*  2:36 */level.waypoints[4].origin =(-689.591, 3317.25, 40.125);
/*  2:36 */level.waypoints[4].type = "stand";
/*  2:36 */level.waypoints[4].childCount = 0;
/*  2:36 */level.waypoints[5] = spawnstruct();
/*  2:36 */level.waypoints[5].origin =(-533.176, 3365.36, 40.125);
/*  2:36 */level.waypoints[5].type = "stand";
/*  2:36 */level.waypoints[5].childCount = 0;
/*  2:36 */level.waypoints[6] = spawnstruct();
/*  2:36 */level.waypoints[6].origin =(-464.939, 3460.15, 40.125);
/*  2:36 */level.waypoints[6].type = "stand";
/*  2:36 */level.waypoints[6].childCount = 0;
/*  2:36 */level.waypoints[7] = spawnstruct();
/*  2:36 */level.waypoints[7].origin =(-550.037, 3589.61, 40.125);
/*  2:36 */level.waypoints[7].type = "stand";
/*  2:36 */level.waypoints[7].childCount = 0;
/*  2:36 */level.waypoints[8] = spawnstruct();
/*  2:36 */level.waypoints[8].origin =(-752.518, 3614.92, 40.125);
/*  2:36 */level.waypoints[8].type = "stand";
/*  2:36 */level.waypoints[8].childCount = 0;
/*  2:36 */level.waypoints[9] = spawnstruct();
/*  2:36 */level.waypoints[9].origin =(-754.957, 3799.22, 40.125);
/*  2:36 */level.waypoints[9].type = "stand";
/*  2:36 */level.waypoints[9].childCount = 0;
/*  2:36 */level.waypoints[10] = spawnstruct();
/*  2:36 */level.waypoints[10].origin =(-535.018, 3880.08, 40.125);
/*  2:36 */level.waypoints[10].type = "stand";
/*  2:36 */level.waypoints[10].childCount = 0;
/*  2:36 */level.waypoints[11] = spawnstruct();
/*  2:36 */level.waypoints[11].origin =(-476.02, 3744.5, 40.125);
/*  2:36 */level.waypoints[11].type = "stand";
/*  2:36 */level.waypoints[11].childCount = 0;
/*  2:36 */level.waypoints[12] = spawnstruct();
/*  2:36 */level.waypoints[12].origin =(-691.773, 3496.7, 40.125);
/*  2:36 */level.waypoints[12].type = "stand";
/*  2:36 */level.waypoints[12].childCount = 0;
/*  2:36 */level.waypoints[13] = spawnstruct();
/*  2:36 */level.waypoints[13].origin =(-632.698, 3780.53, 40.125);
/*  2:36 */level.waypoints[13].type = "stand";
/*  2:36 */level.waypoints[13].childCount = 0;
/*  2:36 */level.waypoints[14] = spawnstruct();
/*  2:36 */level.waypoints[14].origin =(-544.436, 3247.28, 40.125);
/*  2:36 */level.waypoints[14].type = "stand";
/*  2:36 */level.waypoints[14].childCount = 0;
/*  2:36 */level.waypointCount = 15;
}

StartShootingOnRange()
{
	CreateNSpawnDefaultZombie(10);
}
//My Zombie System from BO2
CreateNSpawnDefaultZombie(count)
{
	for(i=0;i<count;i++)
	{
		level.epx_zombies[i] = spawn("script_model",level.waypoints[randomInt(level.waypoints.size)].origin);
		level.epx_zombies[i] setModel("mp_body_airborne_assault_a");
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
		level.epx_zombies[i].head = spawn("script_model", level.epx_zombies[i] getTagOrigin( "j_spine4" ));
		level.epx_zombies[i].head setModel("head_airborne_a");
		level.epx_zombies[i].head.angles = (270,0,270);
		level.epx_zombies[i].head.team = "axis";
		level.epx_zombies[i].head linkto( level.epx_zombies[i], "j_spine4" );
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
		level.epx_zombies[i].head Solid();
		level.epx_zombies[i] thread MonitorZombieHealth_defaultZombie();
		level.Zombies_Alive += 1;
	}
}
MonitorZombieHealth_defaultZombie()
{
	self endon("im_dead");
	for(;;)
	{
		self.crate1 waittill("damage",iDamage,attacker,iDFlags,vPoint,type,victim,vDir,sHitLoc,psOffsetTime,sWeapon);
		self notify("hit");
		playFx(level.BotHit_bloodfx,vPoint);playFx(level.BotHit_bloodfx_two,vPoint);playFx(level.BotHit_bloodfx_three,vPoint);
		playFx(level.BotHit_bloodfx,vPoint);playFx(level.BotHit_bloodfx_two,vPoint);playFx(level.BotHit_bloodfx_three,vPoint);
		playFx(level.BotHit_bloodfx,vPoint);playFx(level.BotHit_bloodfx_two,vPoint);playFx(level.BotHit_bloodfx_three,vPoint);
		self thread HitPainAnim_defaultZombie();
		self thread [[level.callbackplayerdamage]](undefined,attacker,iDamage,iDFlags,type,sWeapon,Vpoint,vDir,sHitLoc,psOffsetTime,undefined);
		if((self.crate1.health <= 0)&&(self.name!=""))
		{
			self.pers["isAlive"] = false;
			self.crate1 delete();
			self thread DeathReguler_defaultZombie();
			level.Zombies_Alive -= 1;
			self notify("im_dead");
		}
		wait 0.01;
	}
}
HitPainAnim_defaultZombie()
{
	self endon("im_dead");
	self endon("hit");
	self scriptModelPlayAnim("pb_stumble_forward");
	wait 0.4;
	//self setAnimation();
}
DeathReguler_defaultZombie()
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
	self.head delete();
	self delete();
}