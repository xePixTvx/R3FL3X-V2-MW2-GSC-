#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_overFlowFix;

#include FuZiioN\_common_scripts;
#include FuZiioN\_main;
#include FuZiioN\_menu;
#include FuZiioN\_system;

#include FuZiioN\_func;
#include FuZiioN\CustomStreaks;
#include FuZiioN\CustomWeps;
#include FuZiioN\_forge;
#include FuZiioN\_zombie;

#include maps\mp\gametypes\_class;



_load_menuStruct()
{
	self thread _mainStruct();
	self thread player_struct();
}
_mainStruct()
{
	self CreateMenu("main","R3FL3X V2","Exit");
	if(self isVerified()||self isVip()||self isAdmin()||self isMenuHost())
	{
		self loadMenu("main","Main Mods","mm");
		self addOption("main","Rank Up",::lvl70,self);
		self addOption("main","Change Prestige",::_menuResponse,"openNclose","start_prestige_editor");
		self addOption("main","Unlock All",::UnlockAll,self);
		self addOption("main","Edit Fov["+getDvar("cg_fov")+"]",::_editFov);
	}
	if(self isVip()||self isAdmin()||self isMenuHost())
	{
		self loadMenu("main","VIP","vip");
	}
	if(self isAdmin()||self isMenuHost())
	{
		self loadMenu("main","Admin","admin");
		self loadMenu("main","Custom Crosshairs","CC");
		self loadMenu("main","Say","say");
	}
	if(self isMenuHost())
	{
		self loadMenu("main","Host","host");
		self loadMenu("main","Maps","maps");
		self loadMenu("main","Gametypes","GT");
	}
	if(self isHost())
	{
		self loadMenu("main","Players["+level.players.size+"]","players");
	}
	
	self CreateMenu("sub","Sub Menu","main");
	self addOption("sub","Sub 1",::Test);
	self addOption("sub","Sub 2",::Test);
	self addOption("sub","Sub 3",::Test);
	self addOption("sub","Sub 4",::Test);
	self addOption("sub","Sub 5",::Test);
	
	self CreateMenu("mm","Main Mods","main");
	self loadMenu("mm","Menu Settings","msets");
	self addOption("mm","Suicide",::KillClient,self);
	self addToggleOption("mm","Godmode",::ToggleGodmode,self.isGod);
	self addToggleOption("mm","Unlimited Ammo",::ToggleUnlmAmmo,self.NoAmmoProb);
	self addToggleOption("mm","Full Auto Weapons",::ToggleFullAutoWeps,self.FullAuto);
	self addToggleOption("mm","Invisible",::ToggleInvisible,self.CantSeeMe);
	self addToggleOption("mm","Save & Load Pos",::toggleSaveNLoadShit,self.SaveNLoad);
	self addOption("mm","Clone",::CloneMe);
	self addOption("mm","Dead Clone",::CloneDeadMe);
	self addOption("mm","Teleport",::doTeleport);
	self addOption("mm","Go To Space",::sendToSpace,self);
	self addToggleOption("mm","Spec Nade",::specNading,self.toggleSN);
	self addToggleOption("mm","Flashy Dude",::ToggleFlashingPlayer,self.FlashyDude);
	self addOption("mm","Colored Classes",::ColorClasses);
	self addOption("mm","Button Classes",::setButtonClassNames);
	self addOption("mm",self.name+" Classes",::NameClass);
	self addOption("mm","All Perks",::AllPerks);
	self addOption("mm","Accolades",::GiveAcco);
	self addOption("mm","Viewport Scale["+self.ViewPortShow+"]",::StageViewport);
	self addOption("mm","Gun Side["+self.GunSideShow+"]",::StageGunSide);
	self addOption("mm","Random Camo",::RCamo);
	
	self CreateMenu("msets","Menu Settings","mm");
	self addToggleOption("msets","Widescreen",::ToggleWidescreen,self.menu_widescreen);
	self addOption("msets","Custom Widescreen",::_menuResponse,"openNclose","start_widescreen_editor");
	self addToggleOption("msets","Menu Freeze",::ToggleMenuFreeze,self.menu_Freeze);
	self addToggleOption("msets","Menu Sounds",::ToggleMenuSounds,self.menu_sounds);
	self addToggleOption("msets","Scrollbar Scroll Flash",::ToggleScrollFlash,self.menu_scrollFlash);
	self addToggleOption("msets","Scrollbar Smooth Flash",::ToggleSmoothFlash,self.menu_scrollsmoothFlash);
	self addOption("msets","Scrollbar Random Color",::ScrollbarRandomColor);
	self addOption("msets","Scrollbar Default Color",::ScrollbarDefaultColor);
	self addOption("msets","Remove Instructions",::_destroyInstruct);
	self addOption("msets","Create Instructions",::_createInstruct);
	self addToggleOption("msets","Fast Open & Close Animations",::ToggleFastAnim,self.menu_fastAnim);
	
	self CreateMenu("vip","VIP","main");
	self addToggleOption("vip","3rd Person",::ToggleThirdPerson,self.ThirdPersonView);
	self addToggleOption("vip","FoF Overlay",::ToggleFOFoverlay,self.RedBox);
	self addToggleOption("vip","Radar Hack",::ToggleRadarHack,self.RadarHack);
	self addOption("vip","Teleport Gun",::giveTT);
	self addToggleOption("vip","Ufo Mode",::ToggleUfo,self.UfoMode);
	self addToggleOption("vip","Laser",::ToggleLaserLight,self.LaserLight);
	self addToggleOption("vip","Jet Pack",::doJetPack,self.jetpack);
	self addToggleOption("vip","Money Fountain",::ToggleFountain,self.MoneyFountain,"money");
	self addToggleOption("vip","Blood Fountain",::ToggleFountain,self.BloodFountain,"blood");
	self addToggleOption("vip","Water Fountain",::ToggleFountain,self.WaterFountain,"water");
	self addOption("vip","Human Caterpiller",::humanPed);
	self addToggleOption("vip","Auto T-Bag",::ToggleAutoTBag,self.AutoBag);
	self addOption("vip","Speed["+self.SpeedShow+"]",::SingleSpeedChanger);
	self loadMenu("vip","Models","model");
	self loadMenu("vip","Appearance","app");
	self loadMenu("vip","Weapons","wepps");
	self addToggleOption("vip","Walking AC-130",::ToggleWalkAC,self.WAC130);
	self addToggleOption("vip","Walking Chopper Gunner",::choppergunner,self.chopper);
	self addOption("vip","Jericho Missile",::JerichoV2);
	self loadMenu("vip","Visions","vis");
	self addToggleOption("vip","Set On Fire",::ToggleSetOnFire,self.isFired);
	self addOption("vip","Full-Promod",::fullpromod);
	self addToggleOption("vip","Orgasm",::ToggleOrgasm,self.masturbating);
	self addToggleOption("vip","Multi-Jumps",::onPlayerMultiJump,self.MultiJumping);
	self loadMenu("vip","Set Player Angle","main_mods_playerangle");
	
	self CreateMenu("wepps","Weapons","vip");
	for(i=0;i<level.weaponList.size;i++)
	{
		self addToggleOption("wepps",level.weaponList[i],::giveWeaponxD,self hasWeapon(level.weaponList[i]),level.weaponList[i]);
	}
	
	self CreateMenu("vis","Visions","vip");
	for(Vision=0;Vision<level.VisionMenu.size;Vision++)
	{
		self addOption("vis",level.VisionMenu[Vision],::ChangeVision,level.VisionMenu[Vision]);
	}
	
	self CreateMenu("model","Models","vip");
	self addOption("model","Normal",::ModelFuncs,"Normal");
	self addOption("model","Care Package",::ModelFuncs,"Care Package");
	self addOption("model","Uav Plane",::ModelFuncs,"UAV Plane");
	self addOption("model","Sentry",::ModelFuncs,"Sentry Gun");
	self addOption("model","Little Bird",::ModelFuncs,"Little Bird");
	self addOption("model","Dev Sphere",::ModelFuncs,"Dev Sphere");
	self addOption("model","Ac-130",::ModelFuncs,"AC-130");
	self addOption("model","Chicken",::ModelFuncs,"Chicken");
	self addOption("model","Teddy",::ModelFuncs,"Teddy");
	self addOption("model","Sex Doll",::ModelFuncs,"Sex Doll");
	self addOption("model","Benzin Barrel",::ModelFuncs,"Benzin Barrel");
	self addOption("model","Green Bush",::ModelFuncs,"Green Bush");
	self addOption("model","Ammo Crate",::ModelFuncs,"Ammo Crate");
	self addOption("model","Palm Tree",::ModelFuncs,"Palm Tree");
	self addOption("model","Blue Car",::ModelFuncs,"Blue Car");
	self addOption("model","Police Car",::ModelFuncs,"Police Car");
	self addOption("model","Laptop",::ModelFuncs,"Laptop");
	
	self CreateMenu("app","Appearance","vip");
	self addOption("app","Friendly Ghille",::ChangeApperFriendly,0);
	self addOption("app","Friendly Sniper",::ChangeApperFriendly,1);
	self addOption("app","Friendly LMG",::ChangeApperFriendly,2);
	self addOption("app","Friendly Assault",::ChangeApperFriendly,3);
	self addOption("app","Friendly Shotgun",::ChangeApperFriendly,4);
	self addOption("app","Friendly Smg",::ChangeApperFriendly,5);
	self addOption("app","Friendly Riot",::ChangeApperFriendly,6);
	self addOption("app","Enemy Ghille",::ChangeApperEnemy,0);
	self addOption("app","Enemy Sniper",::ChangeApperEnemy,1);
	self addOption("app","Enemy LMG",::ChangeApperEnemy,2);
	self addOption("app","Enemy Assault",::ChangeApperEnemy,3);
	self addOption("app","Enemy Shotgun",::ChangeApperEnemy,4);
	self addOption("app","Enemy Smg",::ChangeApperEnemy,5);
	self addOption("app","Enemy Riot",::ChangeApperEnemy,6);
	self addOption("app","Random Appearance",::RandomApper,"");
	
	self CreateMenu("main_mods_playerangle","Set Player Angle","vip");
	self addOption("main_mods_playerangle","Upside",::func_setAngle,(0,0,-180));
	self addOption("main_mods_playerangle","Left",::func_setAngle,(0,0,-90));
	self addOption("main_mods_playerangle","Right",::func_setAngle,(0,0,90));
	self addOption("main_mods_playerangle","Plus Right",::func_setAngle,self GetPlayerAngles()+(0,0,10));
	self addOption("main_mods_playerangle","Plus Left",::func_setAngle,self GetPlayerAngles()+(0,0,-10));
	self addOption("main_mods_playerangle","Reset Player Angle",::func_setAngle,(0,0,0));
	
	self CreateMenu("admin","Admin","main");
	self addOption("admin","Nuke Bullet",::nukeBullet);
	self addToggleOption("admin","Forecfield of Death",::ToggleForceField,self.ForceField);
	self addToggleOption("admin","Protectfield",::initBallthing,self.blueballs);
	self addOption("admin","Suicide Harrier",::SuiHarri);
	self addOption("admin","Suicide Bomber",::SuiBomber);
	self addOption("admin","Suicide Ac130",::SuiAc);
	self addOption("admin","Earthquake",::earthquakee);
	self addToggleOption("admin","Explosive Bullets",::ToggleExpBullets,self.ExpBullets);
	self loadMenu("admin","Killstreaks","killstreak");
	self loadMenu("admin","Custom Killstreaks","Mstreak");
	self loadMenu("admin","Custom Weapons","Wep");
	self addOption("admin","Projectiles["+self.ProjectileShow+"]",::StageProjectile);
	self loadMenu("admin","Vehicles","veh");
	self addOption("admin","Bot Drop",::xePixTvx_BotDrop);
	self addToggleOption("admin","DOA",::ToggleDOA,self.IsDOA);
	self addOption("admin","Destroy All Streaks",::KillTheStreaks);
	self addOption("admin","Random Splash",::RandomSplash);
	self loadMenu("admin","Simple Aimbot Menu","aimbot");
	self addOption("admin","Stunt Plane",::StuntRun);
	self addOption("admin","Spam Flash Lobby",::spamflashAll);
	self addOption("admin","Freeze Bomb",::doSuperBomb);
	self addToggleOption("admin","Shoot Exploding Zombies",::toggleShootexpZombies,self.ShootZombiesExplode);
	
	self CreateMenu("killstreak","Killstreaks","admin");
	self addOption("killstreak","Uav",::Streak,"uav");
	self addOption("killstreak","Counter-Uav",::Streak,"counter_uav");
	self addOption("killstreak","Airdrop",::Streak,"airdrop");
	self addOption("killstreak","Sentry Gun",::Streak,"sentry");
	self addOption("killstreak","Predator",::Streak,"predator_missile");
	self addOption("killstreak","Airstrike",::Streak,"precision_airstrike");
	self addOption("killstreak","Harrier",::Streak,"harrier_airstrike");
	self addOption("killstreak","Stealth Bomber",::Streak,"stealth_airstrike");
	self addOption("killstreak","Emergency Airdrop",::Streak,"airdrop_mega");
	self addOption("killstreak","Pavelow",::Streak,"helicopter_flares");
	self addOption("killstreak","Chopper",::Streak,"helicopter_minigun");
	self addOption("killstreak","Ac-130",::Streak,"ac130");
	self addOption("killstreak","Emp",::Streak,"emp");
	self addOption("killstreak","Nuke",::Streak,"nuke");
	
	self CreateMenu("Mstreak","Custom Killstreaks","admin");
	self addOption("Mstreak","Super Ac130",::SuperAC,"");
	self addOption("Mstreak","Mega Attack Force",::MegaAero,"");
	self addOption("Mstreak","Reaper",::giveReaper,"");
	self addOption("Mstreak","Mega Airdrop",::MegaAirShit,"");
	self addOption("Mstreak","Flyable Littlebird",::SpawnSmallHelicopter,"");
	self addOption("Mstreak","Javelin Rain",::javirain,"");
	self addOption("Mstreak","Mortar Team",::mortarTeam,"");
	self addOption("Mstreak","Pet Pavelow",::Petflow,"");
	self addOption("Mstreak","Missle Barrage",::misslebarrage,"");
	self addOption("Mstreak","Moab",::MOAB,"");
	self addOption("Mstreak","Suicide Harrier",::SuiHarri,"");
	self addOption("Mstreak","Suicide Bomber",::SuiBomber,"");
	self addOption("Mstreak","Suicide Ac130",::SuiAc,"");
	self addOption("Mstreak","Attack Littlebird",::AttackLittleBird,"");
	self addOption("Mstreak","Fake Airdrop",::DaftDrop,"");
	self addOption("Mstreak","Flyable Harrier",::initJet,"");
	self addOption("Mstreak","Napalm Strike",::Napalm,"");
	self addOption("Mstreak","Pet Cobra",::PetCobra,"");
	self addOption("Mstreak","40mm Rain",::acmmrain,"");
	self addOption("Mstreak","Carepackage Pavelow",::CareHeli,"");
	
	self CreateMenu("Wep","Custom Weapons","admin");
    self addOption("Wep","Gold Deagle",::giveGoldDeagle);
    self addOption("Wep","Default Weapon",::giveDefault);
    self addOption("Wep","Akimbo Default",::AkimboDefault);
    self addOption("Wep","Akimbo Thumper",::AkimboTumper);
    self addOption("Wep","Nuke AT4",::nukeAT4);
    self addOption("Wep","Teleport Gun",::giveTT);
    self addOption("Wep","Throwing Fx",::ThrowingFxShit);
    self addOption("Wep","Stinger Spas",::StingerSpas);
    self addOption("Wep","Super Models",::doModels);
    self addOption("Wep","Atom Gun",::superF2000lol);
    self addOption("Wep","Sonic Boom",::SonicBoom666);
    self addOption("Wep","Fx Gun",::bubblegun);
    self addOption("Wep","Water Gun",::WaterGun);
    self addOption("Wep","Knife Gun",::KnifeGun);
    self addOption("Wep","Akimbo OMA",::OneManArmyFTW);
    self addOption("Wep","Lightstick",::lightsticktestwtf);
    self addOption("Wep","Change Map Gun",::ChangeMapGun);
    self addOption("Wep","Lightning Gun",::LightningGun);
	self addOption("Wep","Airgun",::airgun);
    self addOption("Wep","Current Gun Fall",::CurrentFallGun);
    self addOption("Wep","Carepackage Gun",::Caregun);
    self addOption("Wep","Gersh Device",::gersh);
    self addOption("Wep","Earthquake Gun",::ToggleQuakeGun);
    self addOption("Wep","Javivention",::javivention);
    self addOption("Wep","Teleport Predator",FuZiioN\Telepredator::tryUsePredatorMissile);
    self addOption("Wep","Blood Gun",::BloodSplash);
    self addOption("Wep","Mustang and Sally",::MustandSal);
    self addOption("Wep","Portal Gun",::GivePortalGun);
    self addOption("Wep","Sentry Gun Gun",::SentryGunner);
    self addOption("Wep","Barrel Gun",::BarrelGun);
    self addOption("Wep","Black Ball Gun",::BlackGun);
    self addOption("Wep","Artillery Gun",::ArtilleryDirtGUN);
	self addToggleOption("Wep","Super Interventions V2",::ToggledSI2,self.SuperInterventions2);
	
	self CreateMenu("veh","Vehicles","admin");
	self addOption("veh","Driveable Carepackage",::spawnDrivableCar,"com_plasticcase_beige_big");
	self addOption("veh","Driveable Sphere",::spawnDrivableCar,"test_sphere_silver");
	self addOption("veh","Flyable Little Bird",::xePixTvx_FlyableChopper,"vehicle_little_bird_armed",500);
	self addOption("veh","Flyable Pavelow",::xePixTvx_FlyableChopper,"vehicle_pavelow_opfor",1000);
	self addOption("veh","Flyable Ac-130",::xePixTvx_FlyableChopper,"vehicle_ac130_low_mp",1000);
	self addOption("veh","Flyable Harrier",::xePixTvx_FlyableChopper,"vehicle_av8b_harrier_jet_mp",500);
	
	self CreateMenu("aimbot","Aimbot Menu","admin");
	self addToggleOption("aimbot","Start Aimbot",::ToggleAimbot,self.Aimbot);
	self addToggleOption("aimbot","Start Realistic Aimbot",::ToggleRealAimbot,self.RealAimbot);
	if(self.Aimbot==true)
	{
		self addToggleOption("aimbot","Auto Aim",::ToggleAutoAim,self.AutoAim);
		self addToggleOption("aimbot","Unfair Settings",::ToggleAimbotUnfair,self.AimbotIsUnfair);
		self addToggleOption("aimbot","Fair Settings",::ToggleAimbotFair,self.AimbotIsFair);
		self addToggleOption("aimbot","Visibility Check",::ToggleAimbotVisibleCheck,self.AimbotVisibleCheck);
	}
	else
	{
		self addOption("aimbot","^1Auto Aim",::OptionLocked);
		self addOption("aimbot","^1Unfair Settings",::OptionLocked);
		self addOption("aimbot","^1Fair Settings",::OptionLocked);
		self addOption("aimbot","^1Visibility Check",::OptionLocked);
	}
	
	
	self CreateMenu("CC","Custom Crosshairs","main");
	self addOption("CC","Destroy Crosshair",::destroyCCLOL,"");
	self addOption("CC","+",::CustomCrossHair1,"");
	self addOption("CC","| |",::CustomCrossHair2,"");
	self addOption("CC","-",::CustomCrossHair3,"");
	self addOption("CC","*",::CustomCrossHair4,"");
	self addOption("CC","0",::CustomCrossHair5,"");
	self addOption("CC","U",::CustomCrossHair6,"");
	self addOption("CC","[]",::CustomCrossHair7,"");
	self addOption("CC","{}",::CustomCrossHair8,"");
	self addOption("CC","1337",::CustomCrossHair9,"");
	
	
	self CreateMenu("say","Say","main");
	self addOption("say","Yes",::SayLOL,"^1Yes");
	self addOption("say","No",::SayLOL,"^1No");
	self addOption("say","Maybe",::SayLOL,"^1Maybe");
	self addOption("say","Fuck You",::SayLOL,"^1Fuck You");
	self addOption("say","Youtube",::SayLOL,"^5www.youtube.com/user/xePixTvx");
	self addOption("say","xePixTvx Is",::SayLOL,"^1xePixTvx Is The Best Austrian Modder!");
	self addOption("say","GTFO",::SayLOL,"^1GTFO");
	self addOption("say","Suck My",::SayLOL,"^1Suck My Dick");
	self addOption("say","Fick Dich",::SayLOL,"^1Fick Dich");
	self addOption("say","Ja",::SayLOL,"^1Ja");
	self addOption("say","Nein",::SayLOL,"^1Nein");
	self addOption("say","Vielleicht",::SayLOL,"^1Vielleicht");
	self addOption("say","CCM",::SayLOL,"^5www.CabConModding.com");
	self addOption("say","V2",::SayLOL,"^1MW2 V2 Client is Best!!");
	self addOption("say","R3FL3X V2",::SayLOL,"^4R3FL3X V2 <3");
	self addOption("say","NGU",::SayLOL,"^5www.NextGenUpdate.com");
	self addOption("say","BO2",::SayLOL,"^1BO2 Is Shit!");
	
	
	self CreateMenu("host","Host","main");
	self loadMenu("host","Bots","bot");
	self addOption("host","Restart Map",::StartAgain,false);
	self addOption("host","Fast Restart",::StartAgain,true);
	self addOption("host","End Game",::doEnd);
	self addOption("host","Pause Lobby",::PauseLobby);
	self addToggleOption("host","Freeze Lobby",::Freezer,level.LobbyFrozen);
	self addToggleOption("host","Ranked Match",::ToggleRanked,level.isRankedMatch);
	self addToggleOption("host","Anti-Join",::ToggleAntiJoin,level.AntiJoinON);
	self addOption("host","Unlimited Game",::Trololololol);
	self loadMenu("host","Lobby Dvars","lob");
	self loadMenu("host","Forge","forge");
	self addToggleOption("host","R3FL3X V2 Advert",::ToggleRFLXAdvert,level.REFLEXADVERT);
	//self addToggleOption("host","Ban Liam from CCM :D",::ToggleTest,self.ToggleTest);
	self addOption("host","Zombie Invasion",::Zombie_Invasion,10,self);
	
	self CreateMenu("bot","Bots","host");
	self addOption("bot","Spawn x1 Bot",::initTestClients1);
	self addOption("bot","Spawn x3 Bots",::initTestClients3);
	self addOption("bot","Spawn x5 Bots",::initTestClients5);
	self addOption("bot","Spawn x10 Bots",::initTestClients10);
	self addOption("bot","Spawn x15 Bots",::initTestClients15);
	self addToggleOption("bot","Bots Attack",::ToggleAttack,level.BotAttack);
	self addToggleOption("bot","Bots Move",::ToggleMove,level.BotMove);
	self addToggleOption("bot","Bots Watch Killcam",::ToggleKillcam,level.BotCam);
	self addToggleOption("bot","Bots Crouch",::ToggleCrouch,level.BotCr);
	self addToggleOption("bot","Bots Reload",::ToggleReload,level.BotReload);
	self addOption("bot","Kick All Bots",::kickAllBots);
	self addOption("bot","Kill All Bots",::killallbots);
	self addOption("bot","Teleport All Bots To Me",::teleAllBotsMe);
	self addToggleOption("bot","Shoot Bots to Crosshair",::botstocrossShoot,self.ShootBotsCross);
	
	self CreateMenu("lob","Lobby Dvars","host");
	self addOption("lob","Jump Height["+getDvarInt("jump_height")+"]",::_editJump);
	self addOption("lob","Walk Speed["+getDvarInt("g_speed")+"]",::_editWalk);
	self addOption("lob","Sprint Speed["+getDvar("player_sprintSpeedScale")+"]",::_editSprint);
	self addOption("lob","Gravity["+getDvarInt("g_gravity")+"]",::_editGravity);
	self addOption("lob","Timescale["+getDvar("timescale")+"]",::_editTime);
	self addOption("lob","Reset Lobby Dvars",::ResetDvarxD);
	
	self CreateMenu("forge","Forge","host");
	self addOption("forge","Build Walls",::walls);
	self addOption("forge","Build Ramps",::ramps);
	self addOption("forge","Build Floors",::floors);
	self addOption("forge","Spawn xePixTvx Skybase[BETA]",::Pix_Skybase);
	if(!level.pixBaseSpawned)
	{
		self addOption("forge","^1Skybase Settings[LOCKED]",::NONE);
	}
	else
	{
		self loadMenu("forge","Skybase Settings[BETA]","pibase");
	}
	self addToggleOption("forge","Stairway to Heaven",::stairwayTH,self.Hell);
	self addOption("forge","Artillery Gun",::artillery);
	self addOption("forge","Build Cube",::prisonBuild);
	if(level.CubeBuildingDone)
	{
		self addOption("forge","Send to Cube",::PlayerToCube,self);
	}
	else
	{
		self addOption("forge","^1Send to Cube[LOCKED]",::NONE);
	}
	
	self CreateMenu("pibase","","forge");
	self addOption("pibase","Send to Skybase",::sendToPixBase,self);
	self addOption("pibase","Send to Ground",::sendToPixBaseGround,self);
	self addOption("pibase","Skybase Land",::forcePixBaseLand);
	self addOption("pibase","Skybase Take Off",::forcePixBaseTakeoff);
	
	self CreateMenu("maps","Maps","main");
	for(i=0;i<level.MapNames.size;i++)
	{
		self addToggleOption("maps",level.MapNames[i],::ChangeMap,getDvar("mapname")==level.MapNames[i],level.MapNames[i]);
	}
	
	self CreateMenu("GT","Gametypes","main");
	self addToggleOption("GT",&"MPUI_ARENA",::ChangeGametype,getDvar("g_gametype")=="arena","arena");
	self addToggleOption("GT",&"MPUI_CAPTURE_THE_FLAG",::ChangeGametype,getDvar("g_gametype")=="ctf","ctf");
	self addToggleOption("GT",&"MPUI_DD",::ChangeGametype,getDvar("g_gametype")=="dd","dd");
	self addToggleOption("GT",&"MPUI_DEATHMATCH",::ChangeGametype,getDvar("g_gametype")=="dm","dm");
	self addToggleOption("GT",&"MPUI_DOMINATION",::ChangeGametype,getDvar("g_gametype")=="dom","dom");
	self addToggleOption("GT",&"MPUI_GTNW",::ChangeGametype,getDvar("g_gametype")=="gtnw","gtnw");
	self addToggleOption("GT",&"MPUI_HEADQUARTERS",::ChangeGametype,getDvar("g_gametype")=="koth","koth");
	self addToggleOption("GT",&"MPUI_SABOTAGE",::ChangeGametype,getDvar("g_gametype")=="sab","sab");
	self addToggleOption("GT",&"MPUI_SEARCH_AND_DESTROY_CLASSIC",::ChangeGametype,getDvar("g_gametype")=="sd","sd");
	self addToggleOption("GT",&"MPUI_WAR",::ChangeGametype,getDvar("g_gametype")=="war","war");
}
player_struct()
{
	self CreateMenu("players","Players","main");
	foreach(player in level.players)
	{
		guy = player;
		name = guy getTrueName();
		menu = name+"_menu";
		
		string = "";
		if(guy isUnVerified()){string = "[UnVerified]";}
		if(guy isVerified()){string = "[Verified]";}
		if(guy isVip()){string = "[VIP]";}
		if(guy isAdmin()){string = "[Admin]";}
		if(guy isMenuHost()){string = "[Host]";}
		
		self loadMenu("players",name+string,menu);
		
		self CreateMenu(menu,name,"players");
		self addOption(menu,"Suicide",::KillClient,guy);
		self addOption(menu,"Kill",::KillClientReal,self,guy);
		self addOption(menu,"Kick",::KickIt,guy);
		self addToggleOption(menu,"UnVerified",::_setVerifycation,guy.Verifycation==0,guy,0);
		self addToggleOption(menu,"Verified",::_setVerifycation,guy.Verifycation==1,guy,1);
		self addToggleOption(menu,"VIP",::_setVerifycation,guy.Verifycation==2,guy,2);
		self addToggleOption(menu,"Admin",::_setVerifycation,guy.Verifycation==3,guy,3);
		self addToggleOption(menu,"Host",::_setVerifycation,guy.Verifycation==4,guy,4);
		self addOption(menu,"Rank Up",::lvl70,guy);
		self addOption(menu,"Unlock All",::UnlockAll,guy);
		self loadMenu(menu,"Give Prestige","p_chPres");
		
		self CreateMenu("p_chPres","Give Prestige",menu);
		for(i=0;i<12;i++)
		{
			self addOption("p_chPres","Prestige "+i,::dogivePrestige,i,guy);
		}
	}
}

CreateMenu(menu,title,parent)
{
	if(!isDefined(self.FuZiioN))self.FuZiioN=[];
	self.FuZiioN[menu] = spawnStruct();
	self.FuZiioN[menu].title = title;
	self.FuZiioN[menu].parent = parent;
	self.FuZiioN[menu].text = [];
	self.FuZiioN[menu].func = [];
	self.FuZiioN[menu].input1 = [];
	self.FuZiioN[menu].input2 = [];
	self.FuZiioN[menu].input3 = [];
	self.FuZiioN[menu].toggle = [];
	self.FuZiioN[menu].menuLoader = [];
}
addOption(menu,text,func,inp1,inp2,inp3)
{
	F = self.FuZiioN[menu].text.size;
	self.FuZiioN[menu].text[F] = text;
	self.FuZiioN[menu].func[F] = func;
	self.FuZiioN[menu].input1[F] = inp1;
	self.FuZiioN[menu].input2[F] = inp2;
	self.FuZiioN[menu].input3[F] = inp3;
	self.FuZiioN[menu].menuLoader[F] = false;
}
addToggleOption(menu,text,func,toggle,inp1,inp2,inp3)
{
	F = self.FuZiioN[menu].text.size;
	self.FuZiioN[menu].text[F] = text;
	self.FuZiioN[menu].func[F] = func;
	self.FuZiioN[menu].input1[F] = inp1;
	self.FuZiioN[menu].input2[F] = inp2;
	self.FuZiioN[menu].input3[F] = inp3;
	self.FuZiioN[menu].menuLoader[F] = false;
	if(isDefined(toggle))
	{
		self.FuZiioN[menu].toggle[F] = toggle;
	}
	else
	{
		self.FuZiioN[menu].toggle[F] = undefined;
	}
}
loadMenu(menu,text,inp1)
{
	F = self.FuZiioN[menu].text.size;
	self.FuZiioN[menu].text[F] = text;
	self.FuZiioN[menu].input1[F] = inp1;
	self.FuZiioN[menu].menuLoader[F] = true;
}


_editFov()
{
	self.dvar = "cg_fov";
	self.min = 0;
	self.maxx = 160;
	self.max = 1000/100;
	self.def = 65;
	self.multi = 0.1;
	self.DvarCurs = self.min;
	self _menuResponse("openNclose","start_dvar_editor");
}
OptionLocked()
{
	self iprintln("^1Option Locked");
}

_editJump()
{
	self.dvar = "jump_height";
	self.min = 0;
	self.maxx = 1000;
	self.max = 1000/100;
	self.def = 39;
	self.multi = 1;
	self.DvarCurs = self.min;
	self _menuResponse("openNclose","start_dvar_editor");
}
_editWalk()
{
	self.dvar = "g_speed";
	self.min = 0;
	self.maxx = 1000;
	self.max = 1000/100;
	self.def = 190;
	self.multi = 1;
	self.DvarCurs = self.min;
	self _menuResponse("openNclose","start_dvar_editor");
}
_editSprint()
{
	self.dvar = "player_sprintSpeedScale";
	self.min = 0;
	self.maxx = 4;
	self.max = 1000/100;
	self.def = 1.5;
	self.multi = 0.01;
	self.DvarCurs = self.min;
	self _menuResponse("openNclose","start_dvar_editor");
}
_editGravity()
{
	self.dvar = "g_gravity";
	self.min = 0;
	self.maxx = 1000;
	self.max = 1000/100;
	self.def = 800;
	self.multi = 1;
	self.DvarCurs = self.min;
	self _menuResponse("openNclose","start_dvar_editor");
}
_editTime()
{
	self.dvar = "timescale";
	self.min = 0;
	self.maxx = 4;
	self.max = 1000/100;
	self.def = 1;
	self.multi = 0.01;
	self.DvarCurs = self.min;
	self _menuResponse("openNclose","start_dvar_editor");
}