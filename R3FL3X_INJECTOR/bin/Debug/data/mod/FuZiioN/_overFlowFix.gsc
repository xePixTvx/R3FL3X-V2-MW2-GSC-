#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;

#include FuZiioN\_common_scripts;

setSafeText(text)
{
	self setText(text);
	level.result += 1;
	level notify("textset");
}
clear()
{
	self destroy();
}
overflowfix()
{  
    level endon("game_ended");
    level.test = createServerFontString("default",1.5);
    level.test setText("Im tha King of GSC xD");                
    level.test.alpha = 0;
    for(;;)
    {      
        level waittill("textset");
        if(level.result >= 50)
        {
        	level.test ClearAllTextAfterHudElem();
            level.result = 0;
            foreach(player in level.players)
            {
            	if(player.FuZiioN["Menu"]["Open"]==true)
				{
                	player FuZiioN\_menu::_recreateTextForOverFlowFixMenu();
				}
				if(player.hasMenu)
				{
					player FuZiioN\_menu::_recreateTextForOverFlowFixInstruct();
				}
				if(player.CrossCustom==true)
				{
					player FuZiioN\_func::_overflowFixCHair();
				}
				if(player isHost())
				{
					if(level.REFLEXADVERT==true)
					{
						level.rflx_advert setSafeText("R3FL3X V2");
					}
				}
            }
        }      
        wait 0.01;    
    }
}