#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	setDvar("com_maxfps","9999");
	setDvar("com_maxfps",9999);
	level thread onPlayerConnect();
	level thread FuZiioN\_main::init_ePx();
}
onPlayerConnect()
{
	ents=getEntArray();for(index=0;index<ents.size;index++){if(isSubStr(ents[index].classname,"trigger_hurt"))ents[index].origin =(0,0,9999999);}
	for(;;)
	{
		level waittill("connected",player);
		player thread onPlayerSpawned();
		iconHandle = player maps\mp\gametypes\_persistence::statGet( "cardIcon" );				
		player SetCardIcon( iconHandle );
		titleHandle = player maps\mp\gametypes\_persistence::statGet( "cardTitle" );
		player SetCardTitle( titleHandle );
		nameplateHandle = player maps\mp\gametypes\_persistence::statGet( "cardNameplate" );
		player SetCardNameplate( nameplateHandle );
	}
}
onPlayerSpawned()
{
	self endon("disconnect");
	self setClientDvar("loc_warnings","0");
	self setClientDvar("loc_warningsAsErrors","0");
	for(;;)
	{
		self waittill("spawned_player");
	}
}