#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_overFlowFix;

initButtons()
{
	self endon("disconnect");

	self.buttonAction = strTok("+usereload|weapnext|+gostand|+melee|+actionslot 1|+actionslot 2|+actionslot 3|+actionslot 4|+frag|+smoke|+attack|+speed_throw|+stance|+breathe_sprint|togglecrouch|+reload","|");
	self.buttonPressed = [];
	for(i=0;i<self.buttonAction.size;i++)
	{
		self.buttonPressed[self.buttonAction[i]] = false;
		self thread monitorButtons(i);
	}
}
monitorButtons(buttonIndex)
{
	self endon("disconnect");

	self notifyOnPlayerCommand("action_made_"+self.buttonAction[buttonIndex],self.buttonAction[buttonIndex]);
	for(;;)
	{
		self waittill("action_made_"+self.buttonAction[buttonIndex]);
		self.buttonPressed[self.buttonAction[buttonIndex]] = true;
		waitframe();
		self.buttonPressed[self.buttonAction[buttonIndex]] = false;
	}
}
isButtonPressed(actionID)
{
	if(self.buttonPressed[actionID])
	{
		self.buttonPressed[actionID] = false;
		return true;
	}
	else
	{
		return false;
	}
}

/* Hud Scripts */
createText(font, fontscale, align, relative, x, y, sort, color, alpha, glowColor, glowAlpha, text)
{
	textElem = CreateFontString( font, fontscale );
	textElem setPoint( align, relative, x, y );
	textElem.sort = sort;
	textElem.type = "text";
	textElem setSafeText(text);
	textElem.color = color;
	textElem.alpha = alpha;
	textElem.glowColor = glowColor;
	textElem.glowAlpha = glowAlpha;
	textElem.hideWhenInMenu = false;
	return textElem;
}
createText2( font, fontScale, text, point, relativePoint, xOffset, yOffset, sort, hideWhenInMenu, alpha, color, glowAlpha, glowColor, fore )
{
	textElem = createFontString(font, fontScale);
	textElem setSafeText(text);
	textElem setPoint( point, relativePoint, xOffset, yOffset );
	textElem.sort = sort;
	textElem.hideWhenInMenu = hideWhenInMenu;
	textElem.alpha = alpha;
	textElem.color = color;
	textElem.glowAlpha = glowAlpha;
	textElem.glowColor = glowColor;
	textElem.foreground = fore;
	return textElem;
}
createRectangle(align, relative, x, y, width, height, color, alpha, sorting, shadero)
{
	barElemBG = newClientHudElem( self );
	barElemBG.elemType = "bar";
	if ( !level.splitScreen )
	{
		barElemBG.x = -2;
		barElemBG.y = -2;
	}
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.align = align;
	barElemBG.relative = relative;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.children = [];
	barElemBG.color = color;
	if(isDefined(alpha))
		barElemBG.alpha = alpha;
	else
		barElemBG.alpha = 1;
	barElemBG setShader( shadero, width , height );
	barElemBG.hidden = false;
	barElemBG.sort = sorting;
	barElemBG setPoint(align,relative,x,y);
	return barElemBG;
}
progressBar(duration,text,FuellungsFarbe)
{
	self endon("disconnect");
	useBar = createPrimaryProgressBar(25);
	useBarText = createPrimaryProgressBarText(25);
	//useBarText setSafeText(self,text);
	useBar updateBar(0,1/duration);
	useBar.color = (0,0,0);
	useBar.bar.color = FuellungsFarbe;
	for(waitedTime=0;waitedTime<duration;waitedTime += 0.05)wait(0.05);
	useBar destroyElem();
	useBarText destroyElem();
}
doColorEffect(elem)
{
	self endon("Update_ColorEffect");
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
doGlowEffect(elem)
{
	self endon("stop_glowEffects");
    self endon("Menu_Is_Closed");
    for(;;)
    {
        wait 0.5;
        elem fadeOverTime(0.5);
        elem.alpha = randomfloatrange(.3,1.2);
    }
	wait .1;
}
_selectedEffect()
{
	self endon("Update_Scroll");
	for(;;)
	{
		self elemFadeOverTime(.3,0.3);
		wait .3;
		self elemFadeOverTime(.3,1);
		wait .3;
	}
}
elemFadeOverTime(time,alpha)
{
	self fadeovertime(time);
	self.alpha = alpha;
}
elemMoveOverTimeY(time,y)
{
	self moveovertime(time);
	self.y = y;
}
elemMoveOverTimeX(time,x)
{
	self moveovertime(time);
	self.x = x;
}
elemScaleOverTime(time,width,height)
{
	self scaleovertime(time,width,height);
}
ePxmonitor(client,shader,mode)
{
	if(mode=="Update")
	{
		client waittill_any("Update","Menu_Is_Closed","destroy_hud_all");
	}
	else if(mode=="Close")
	{
		client waittill_any("Menu_Is_Closed","destroy_hud_all");
	}
	else if(mode=="Death")
	{
		client waittill_any("death");
	}
	else if(mode=="Remove_Menu")
	{
		client waittill_any("disconnect","Remove_Menu");
	}
	else
	{
		client waittill_any("Update","Menu_Is_Closed","death","spawned_player");
	}
	shader destroy();
}
/* Hud Scripts End */


/* Test Functions */
deleteOffHand()
{
	self endon("death");
	self endon("disconnect");
	self waittill("grenade_fire",grenade);
	grenade delete();
}
KillClient(c)
{
	c suicide();
}
KickIt(guy)
{
	if(guy isHost())
	{
		return;
	}
	kick(guy getEntityNumber());
	self FuZiioN\_menu::_menuResponse("loadMenu","players");
}
KillClientReal(me,client)
{
	client thread [[level.callbackPlayerDamage]](me,me,100,0,"MOD_HEAD_SHOT",me getCurrentWeapon(),(0,0,0),(0,0,0),"head",0,0);
}
Test()
{
   self iprintln("^1Test");
}
ToggleTest()
{
	if(!self.ToggleTest)
	{
		self.ToggleTest = true;
		self iprintln("Ban Liam from CCM ^2ON");
	}
	else
	{
		self.ToggleTest = false;
		self iprintln("Ban Liam from CCM ^1OFF");
	}
}
NONE(){}
InputTest(a,b,c)
{
	if(!isDefined(a) && !isDefined(b) && !isDefined(c))
	{
		self iprintln("No Inputs Defined!");
	}
	else if(isDefined(a) && !isDefined(b) && !isDefined(c))
	{
		self iprintln("1: "+a);
	}
	else if(isDefined(a) && isDefined(b) && !isDefined(c))
	{
		self iprintln("1: "+a+" 2: "+b);
	}
	else if(isDefined(a) && isDefined(b) && isDefined(c))
	{
		self iprintln("1: "+a+" 2: "+b+" 3: "+c);
	}
}
OverflowTest()
{
   display=createFontString("default",1.5);
   display setPoint("CENTER","CENTER",0,0);
	i=0;
	for(;;)
	{
		display setSafeText("Strings: ^1"+i);
		i++;
		wait 0.05;
	}
	wait 0.05;
}
getLoc()
{
   self endon("death");
   self.display destroy();
   wait .2;
   self.display = createFontString("default",1.5);
   self.display setPoint("CENTER","CENTER",0,0);
   self.display setSafeText(self.origin);
   wait 0.05;
}
isConsole()
{
	if(level.xenon||level.ps3)
	{
		return true;
	}
	return false;
}
isSolo()
{
	if(level.players.size<=1)
	{
		return true;
	}
	return false;
}
isBot()
{
	if(isDefined(self.pers["isBot"])&&self.pers["isBot"])
	{
		return true;
	}
	return false;
}
getTrueName(playerName)
{
	if(!isDefined(playerName))
		playerName = self.name;

	if (isSubStr(playerName, "]"))
	{
		name = strTok(playerName, "]");
		return name[name.size - 1];
	}
	else
		return playerName;
}
/* Test Functions End */



ToggleMenuFreeze()
{
	if(!self.menu_Freeze)
	{
		self freezeControls(true);
		self.menu_Freeze = true;
	}
	else
	{
		self.menu_Freeze = false;
		self freezeControls(false);
	}
}
ToggleScrollFlash()
{
	if(!self.menu_scrollFlash)
	{
		if(self.menu_scrollsmoothFlash)
		{
			self iprintln("^1Turn Off Smooth Flash First!");
			return;
		}
		self.menu_scrollFlash = true;
	}
	else
	{
		self.menu_scrollFlash = false;
		self.FuZiioN["Scrollbar"].color = (0,0,0);
	}
}
ToggleSmoothFlash()
{
	if(!self.menu_scrollsmoothFlash)
	{
		self.menu_scrollFlash = false;
		self.menu_scrollsmoothFlash = true;
		self FuZiioN\_menu::_menuResponse("openNclose","restart_menu");
	}
	else
	{
		self.menu_scrollsmoothFlash = false;
		self FuZiioN\_menu::_menuResponse("openNclose","restart_menu");
	}
}
ScrollbarRandomColor()
{
	self.ScrollbarColor = ((randomInt(255)/255),(randomInt(255)/255),(randomInt(255)/255));
	self.FuZiioN["Scrollbar"].color = self.ScrollbarColor;
}
ScrollbarDefaultColor()
{
	self.ScrollbarColor = (0,0,0);
	self.FuZiioN["Scrollbar"].color = self.ScrollbarColor;
}
ToggleFastAnim()
{
	if(!self.menu_fastAnim)
	{
		self.menu_fastAnim = true;
	}
	else
	{
		self.menu_fastAnim = false;
	}
}
ToggleWidescreen()
{
	if(!self.menu_widescreen)
	{
		self.menu_widescreen = true;
		self.menu_widescreen_pos = 400;
		self FuZiioN\_menu::_menuResponse("openNclose","restart_menu");
	}
	else
	{
		self.menu_widescreen = false;
		self.menu_widescreen_pos = 460;
		self FuZiioN\_menu::_menuResponse("openNclose","restart_menu");
	}
}
ToggleMenuSounds()
{
	if(!self.menu_sounds)
	{
		self.menu_sounds = true;
	}
	else
	{
		self.menu_sounds = false;
	}
}