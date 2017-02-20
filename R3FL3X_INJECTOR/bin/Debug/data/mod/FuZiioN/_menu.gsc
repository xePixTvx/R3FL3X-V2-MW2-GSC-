#include maps\mp\gametypes\_hud_util;
#include maps\mp\_utility;
#include common_scripts\utility;
#include FuZiioN\_overFlowFix;

#include FuZiioN\_common_scripts;
#include FuZiioN\_main;
#include FuZiioN\_menu_struct;


///MENU SETUP
_setUpMenu()
{
	//Menu Stuff
	self.FuZiioN = [];
	self.Scroller = [];
	self _load_menuStruct();
	self.ToggleTest = false;
	self.hasMenu = false;//player has menu bool
	self.instruct_done = false;//instructions created bool
	self.menu_Freeze = true;//menu freeze
	self.menu_scrollFlash = false;//scroll flash
	self.menu_scrollsmoothFlash = false;//scrollbar smooth flash
	self.menu_fastAnim = false;//fast open & close animations
	self.menu_widescreen = true;//menu widescreen mode
	self.menu_sounds = true;//menu open & close + scrolling sounds(for editors too)
	self.menu_widescreen_pos = 400;//x position of the menu background(rest of the hud is placed automaticly)
	self.UnlimitedScrollingAllowed = true;//allow unlimited scrolling
	self.menu_scrollType = "default";//unlimited or default
	self.MenuMaxSize = 20;//Max Shown options
	self.MenuMaxSizeHalf = 10;//Half of the Max Shown Options
	self.MenuMaxSizeHalfOne = 11;//Start Push Up Value
	self.textSize = 0;//Saves the Text Sizes
	self.ScrollbarColor = (0,0,0);//scrollbar default color
	
	//Mod stuff
	self.dvar = "cg_fov";
	self.min = 0;self.maxx = 160;self.max = 160/100;
	self.def = 65;self.multi = 1;self.DvarCurs = self.min;
	self.isGod = false;self.FullAuto = false;self.NoAmmoProb = false;
	self.CantSeeMe = false;self.SaveNLoad = false;self.toggleSN = false;
	self.FlashyDude = false;self.ThirdPersonView = false;self.RedBox = false;
	self.LaserLight = false;self.RadarHack = false;self.UfoMode = false;
	self.jetpack = false;self.MoneyFountain = false;self.BloodFountain = false;
	self.WaterFountain = false;self.AutoBag = false;self.ForceField = false;
	self.blueballs = false;self.ExpBullets = false;self.SuperInterventions2 = false;
	self.IsDOA = false;self.ShootBotsCross = false;self.Hell = false;
	self.WAC130 = false;self.chopper = false;self.masturbating = false;
	self.MultiJumping = false;self.Aimbot = false;self.RealAimbot = false;
	self.AimbotIsUnfair = true;self.AimbotIsFair = false;self.AutoAim = false;
	self.AimbotVisibleCheck = false;self.GunSideShow = "Default";self.GunSideVal = 1;
	self.ShootZombiesExplode = false;self.CrossHair = "";self.CrossCustom = false;
}


///GIVE MENU + REMOVE MENU
_giveMenu()
{
	if(!self.hasMenu)
	{
		self thread initMenu();
		self.hasMenu = true;
	}
}
_removeMenu()
{
	if(self.hasMenu==true)
	{
		if(self.FuZiioN["Menu"]["Open"])
		{
			self thread _destroyInstruct();
			self _menuResponse("openNclose","close");
		}
		self notify("Remove_Menu");
		self.hasMenu = false;
	}
}




///START MENU
initMenu()
{
	self.FuZiioN["Menu"]["Open"] = false;//Opened Bool
	self.FuZiioN["Menu"]["Locked"] = false;//Locked Bool
	self.FuZiioN["Menu"]["Loading"] = false;//Loading Bool(for open animation)
	self.FuZiioN["Menu"]["isWorking"] = false;//is currently closing or opening bool(cause of hud bug fix)
	self.FuZiioN["Menu"]["Type"] = "menu";//types = menu,dvar,prestige,widescreen editor   if unknown menu will restart in "menu" type
	self thread _createInstruct();//create instructions
	self thread _menuOpenMonitor();//start menu monitoring
}






///MENU MONITORING
_menuOpenMonitor()
{
	self endon("Remove_Menu");
	self endon("disconnect");
	for(;;)
	{
		if(!self.FuZiioN["Menu"]["Open"] && !self.FuZiioN["Menu"]["Locked"])
		{
			if(self isButtonPressed("+actionslot 1") && !self.FuZiioN["Menu"]["isWorking"])
			{
				self thread _menuMainMonitor();
				wait 0.05;
				self notify("Menu_Is_Opened");
				wait .2;
			}
			if(self isButtonPressed("+actionslot 2"))
			{
				self iprintlnBold("Menu: ^1Locked");
				self.FuZiioN["Menu"]["Locked"] = true;
				wait 0.05;
			}
		}
		if(!self.FuZiioN["Menu"]["Open"] && self.FuZiioN["Menu"]["Locked"])
		{
			if(self isButtonPressed("+actionslot 2"))
			{
				self iprintlnBold("Menu: ^2UnLocked");
				self.FuZiioN["Menu"]["Locked"] = false;
				wait 0.05;
			}
		}
		wait 0.05;
	}
	wait 0.05;
}
_menuMainMonitor()
{
	self endon("Remove_Menu");
	self endon("Menu_Is_Closed");
	self endon("disconnect");
	
	self waittill("Menu_Is_Opened");
	if(self.menu_sounds)
	{
		self playLocalSound("ui_mp_suitcasebomb_timer");
	}
	self _menuResponse("openNclose","open");
	
	while(self.FuZiioN["Menu"]["Open"])
	{
		if(self.menu_Freeze)
		{
			self freezeControls(true);
		}
		if(self.FuZiioN["Menu"]["Type"]=="menu")
		{
			if(self AdsButtonPressed()||self AttackButtonPressed())
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] -= self AdsButtonPressed();
				self.Scroller[self.FuZiioN["CurrentMenu"]] += self AttackButtonPressed();
				self _menuResponse("scroll","Update");
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .124;
			}
			if(self SecondaryOffHandButtonPressed()||self FragButtonPressed())
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] -= self SecondaryOffHandButtonPressed();
				self.Scroller[self.FuZiioN["CurrentMenu"]] += self FragButtonPressed();
				self _menuResponse("scroll","Update");
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
			}
			if(self UseButtonPressed())
			{
				if(!self.FuZiioN[self.FuZiioN["CurrentMenu"]].menuLoader[self.Scroller[self.FuZiioN["CurrentMenu"]]])
				{
					func = self.FuZiioN[self.FuZiioN["CurrentMenu"]].func[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					input1 = self.FuZiioN[self.FuZiioN["CurrentMenu"]].input1[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					input2 = self.FuZiioN[self.FuZiioN["CurrentMenu"]].input2[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					input3 = self.FuZiioN[self.FuZiioN["CurrentMenu"]].input3[self.Scroller[self.FuZiioN["CurrentMenu"]]];
					self thread [[func]](input1,input2,input3);
					wait 0.05;
					self _menuResponse("select","Update");
				}
				else
				{
					self _menuResponse("loadMenu",self.FuZiioN[self.FuZiioN["CurrentMenu"]].input1[self.Scroller[self.FuZiioN["CurrentMenu"]]]);
				}
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .4;
			}
			if(self MeleeButtonPressed())
			{
				if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].parent=="Exit" && !self.FuZiioN["Menu"]["isWorking"])
				{
					if(self.menu_sounds)
					{
						self playLocalSound("ui_mp_suitcasebomb_timer");
					}
					self _menuResponse("openNclose","close");
				}
				else
				{
					if(self.menu_sounds)
					{
						self playLocalSound("mouse_over");
					}
					self _menuResponse("loadMenu",self.FuZiioN[self.FuZiioN["CurrentMenu"]].parent);
				}
				wait .4;
			}
		}
		else if(self.FuZiioN["Menu"]["Type"]=="dvar_editor")
		{
			if(self AdsButtonPressed()||self isButtonPressed("+actionslot 2"))
			{
				self.DvarCurs -= self.multi;
				if(self.DvarCurs<self.min)
				{
					self.DvarCurs = self.maxx/self.max;
				}
				self.FuZiioN["dvar_arrow"].y = 295-(self.DvarCurs*1.98);
				self.FuZiioN["dvar_val"].y = self.FuZiioN["dvar_arrow"].y;
				self.FuZiioN["dvar_val"] setValue(self.DvarCurs*self.max);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
			}
			if(self AttackButtonPressed()||self isButtonPressed("+actionslot 1"))
			{
				self.DvarCurs += self.multi;
				if(self.DvarCurs>self.maxx/self.max)
				{
					self.DvarCurs = self.min;
				}
				self.FuZiioN["dvar_arrow"].y = 295-(self.DvarCurs*1.98);
				self.FuZiioN["dvar_val"].y = self.FuZiioN["dvar_arrow"].y;
				self.FuZiioN["dvar_val"] setValue(self.DvarCurs*self.max);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
			}
			if(self UseButtonPressed())
			{
				self setClientDvar(self.dvar,self.DvarCurs*self.max);
				setDvar(self.dvar,self.DvarCurs*self.max);
				self iprintln("^1"+self.dvar+"^7 Changed to: ^1"+self.DvarCurs*self.max);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .4;
			}
			if(self MeleeButtonPressed())
			{
				self.FuZiioN["Menu"]["Loading"] = true;
				self.FuZiioN["Menu"]["Type"] = "menu";
				self.FuZiioN["dvar_line"] elemFadeOverTime(.2,0);
				self.FuZiioN["dvar_arrow"] elemFadeOverTime(.2,0);
				self.FuZiioN["dvar_val"] notify("Update_Scroll");
				self.FuZiioN["dvar_val"].alpha = 1;
				self.FuZiioN["dvar_val"] elemFadeOverTime(.2,0);
				wait .3;
				self.FuZiioN["dvar_line"] destroy();
				self.FuZiioN["dvar_arrow"] destroy();
				self.FuZiioN["dvar_val"] destroy();
				self notify("Update_Info");
				self.FuZiioN["Scrollbar"] = createRectangle("CENTER","TOP",self.FuZiioN["BG"].x+2,self.FuZiioN["TOPLine"].y+10,500,20,self.ScrollbarColor,0,0,"white");
				thread ePxmonitor(self,self.FuZiioN["Scrollbar"],"Close");
				if(self.menu_scrollsmoothFlash)
				{
					thread doColorEffect(self.FuZiioN["Scrollbar"]);
				}
				self _createMenuText();
				self _menuTextFadeIn();
				self _menuResponse("scroll","Update");
				self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .4;
			}
		}
		else if(self.FuZiioN["Menu"]["Type"]=="prestige_editor")
		{
			if(self AdsButtonPressed()||self isButtonPressed("+actionslot 2"))
			{
				self.PresCursor --;
				if(self.PresCursor<0)
				{
					self.PresCursor = 11;
				}
				self.FuZiioN["Show_Pres"].x = -140+(self.PresCursor*25.45);
				self.FuZiioN["Pres_val"].x = self.FuZiioN["Show_Pres"].x;
				self.FuZiioN["Pres_val"] setValue(self.PresCursor);
				self.FuZiioN["Show_Pres"] setShader("rank_prestige"+self.PresCursor,15,15);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
			}
			if(self AttackButtonPressed()||self isButtonPressed("+actionslot 1"))
			{
				self.PresCursor ++;
				if(self.PresCursor>11)
				{
					self.PresCursor = 0;
				}
				self.FuZiioN["Show_Pres"].x = -140+(self.PresCursor*25.45);
				self.FuZiioN["Pres_val"].x = self.FuZiioN["Show_Pres"].x;
				self.FuZiioN["Pres_val"] setValue(self.PresCursor);
				self.FuZiioN["Show_Pres"] setShader("rank_prestige"+self.PresCursor,15,15);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
			}
			if(self UseButtonPressed())
			{
				self setPlayerData("prestige",self.PresCursor);
				self iprintln("Prestige Changed to: ^1Prestige "+self.PresCursor);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .4;
			}
			if(self MeleeButtonPressed())
			{
				self.FuZiioN["Menu"]["Loading"] = true;
				self.FuZiioN["Menu"]["Type"] = "menu";
				self.FuZiioN["Line_Pres"] elemFadeOverTime(.2,0);
				self.FuZiioN["Title_Pres"] elemFadeOverTime(.2,0);
				self.FuZiioN["Show_Pres"] elemFadeOverTime(.2,0);
				self.FuZiioN["Pres_val"] elemFadeOverTime(.2,0);
				wait .3;
				self.FuZiioN["BG_Pres"] elemFadeOverTime(.2,0);
				self notify("Update_Info");
				wait .4;
				self.FuZiioN["BG_Pres"] destroy();
				self.FuZiioN["Line_Pres"] destroy();
				self.FuZiioN["Title_Pres"] destroy();
				self.FuZiioN["Show_Pres"] destroy();
				self.FuZiioN["Pres_val"] destroy();
				self _createHud();
				self _hudFade_in();
				self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .4;
			}
		}
		else if(self.FuZiioN["Menu"]["Type"]=="custom_widescreen_editor")
		{
			if(self AdsButtonPressed()||self AttackButtonPressed())
			{
				self.FuZiioN["BG"].x -= self AdsButtonPressed();
				self.FuZiioN["BG"].x += self AttackButtonPressed();
				if(self.FuZiioN["BG"].x>500)
				{
					self.FuZiioN["BG"].x = 500;
				}
				if(self.FuZiioN["BG"].x<175)
				{
					self.FuZiioN["BG"].x = 175;
				}
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
			}
			if(self UseButtonPressed())
			{
				self.menu_widescreen = true;
				self.menu_widescreen_pos = self.FuZiioN["BG"].x;
				self iprintln("^1Custom Widescreen Set!");
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .4;
			}
			if(self MeleeButtonPressed())
			{
				self.FuZiioN["Menu"]["isWorking"] = true;
				self.FuZiioN["Menu"]["Loading"] = true;
				self.FuZiioN["Menu"]["Type"] = "menu";
				self.FuZiioN["BG"] elemFadeOverTime(.2,0);
				wait .3;
				self notify("destroy_hud_all");
				wait 0.05;
				self notify("Update_Info");
				self setClientDvar("g_hardcore",1);
				self _createHud();
				self _hudFade_in();
				self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
				self.FuZiioN["Menu"]["isWorking"] = false;
				if(self.menu_sounds)
				{
					self playLocalSound("mouse_over");
				}
				wait .4;
			}
		}
		else
		{
			self _menuResponse("openNclose","restart_menu");
		}
		wait 0.05;
	}
	wait 0.05;
}


///MENU RESPONSE
_menuResponse(in1,in2,in3,in4,in5)
{
	if(in1=="openNclose")
	{
		if(in2=="open")
		{
			self.FuZiioN["Menu"]["isWorking"] = true;
			self.FuZiioN["Menu"]["Loading"] = true;
			self.FuZiioN["Menu"]["Open"] = true;
			self notify("Update_Info");
			self setClientDvar("g_hardcore",1);
			if(!isDefined(self.FuZiioN["CurrentMenu"]))
			{
				self.FuZiioN["CurrentMenu"] = "main";
			}
			self _createHud();
			self _hudFade_in();
			self _menuResponse("loadMenu",self.FuZiioN["CurrentMenu"]);
			self.FuZiioN["Menu"]["isWorking"] = false;
		}
		else if(in2=="close")
		{
			self.FuZiioN["Menu"]["isWorking"] = true;
			self freezeControls(false);
			self.FuZiioN["Menu"]["Open"] = false;
			self notify("Update_Info");
			self _hudFade_out();
			self setClientDvar("g_hardcore",0);
			self.FuZiioN["Menu"]["isWorking"] = false;
			self notify("Menu_Is_Closed");
		}
		else if(in2=="restart_menu")
		{
			self _menuResponse("openNclose","close");
			wait .2;
			self.FuZiioN["Menu"]["Type"] = "menu";
			self thread FuZiioN\_menu::_menuMainMonitor();
			wait 0.05;
			self notify("Menu_Is_Opened");
			wait .2;
		}
		else if(in2=="start_dvar_editor")
		{
			self.FuZiioN["Menu"]["Type"] = "dvar_editor";
			self.FuZiioN["Title"] setSafeText("Dvar Editor");
			self.FuZiioN["Scrollbar"] elemFadeOverTime(.2,0);
			wait .3;
			self.FuZiioN["Scrollbar"] destroy();
			for(i=self.FuZiioN["Text"].size;i>-1;i--)
			{
				self.FuZiioN["Text"][i] notify("Update_Scroll");
				self.FuZiioN["Text"][i] elemFadeOverTime(0.05,0);
				wait 0.05;
				self.FuZiioN["Text"][i] destroy();
			}
			wait 0.05;
			self notify("Update_Info");
			self.FuZiioN["dvar_line"] = createRectangle("CENTER","TOP",self.FuZiioN["SideLine"].x+140,self.FuZiioN["TOPLine"].y+120,1,200,(1,1,1),0,0,"white");
			self.FuZiioN["dvar_line"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["dvar_line"],"Close");
			self.FuZiioN["dvar_arrow"] = createRectangle("CENTER","TOP",self.FuZiioN["dvar_line"].x+10,295,15,15,(1,0,0),0,0,"ui_scrollbar_arrow_left");
			self.FuZiioN["dvar_arrow"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["dvar_arrow"],"Close");
			thread doColorEffect(self.FuZiioN["dvar_arrow"]);
			self.FuZiioN["dvar_val"] = createText("default",1.5,"RIGHT","TOP",self.FuZiioN["dvar_line"].x-10,self.FuZiioN["dvar_arrow"].y,0,(1,1,1),0,(1,0,0),0,"");
			self.FuZiioN["dvar_val"] setValue(0);
			self.FuZiioN["dvar_val"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["dvar_val"],"Close");
			self.FuZiioN["dvar_line"] elemFadeOverTime(.2,1);
			self.FuZiioN["dvar_arrow"] elemFadeOverTime(.2,1);
			self.FuZiioN["dvar_val"] elemFadeOverTime(.2,1);
			wait .3;
			self.FuZiioN["dvar_val"] thread _selectedEffect();
			wait 0.05;
			if(self.DvarCurs<self.min)
			{
				self.DvarCurs = 100;
			}
			if(self.DvarCurs>100)
			{
				self.DvarCurs = self.min;
			}
			self.FuZiioN["dvar_arrow"].y = 295-(self.DvarCurs*1.98);
			self.FuZiioN["dvar_val"].y = self.FuZiioN["dvar_arrow"].y;
			self.FuZiioN["dvar_val"] setValue(self.DvarCurs*self.max);
		}
		else if(in2=="start_prestige_editor")
		{
			self.FuZiioN["Menu"]["Type"] = "prestige_editor";
			self _hudFade_out();
			self.PresCursor = 0;
			self.FuZiioN["Scrollbar"] destroy();
			for(i=0;i<self.FuZiioN["Text"].size;i++)
			{
				self.FuZiioN["Text"][i] destroy();
			}
			self.FuZiioN["BG"] destroy();
			self.FuZiioN["TOPLine"] destroy();
			self.FuZiioN["SideLine"] destroy();
			self.FuZiioN["Title"] destroy();
			self notify("Update_Info");
			self.FuZiioN["Line_Pres"] = createRectangle("CENTER","CENTER",0,0,290,1,(1,1,1),0,0,"white");
			self.FuZiioN["Line_Pres"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["Line_Pres"],"Close");
			self.FuZiioN["BG_Pres"] = createRectangle("CENTER","CENTER",0,self.FuZiioN["Line_Pres"].y-20,300,150,(0,0,0),0,0,"white");
			thread ePxmonitor(self,self.FuZiioN["BG_Pres"],"Close");
			self.FuZiioN["Title_Pres"] = createText("hudBig",1.0,"CENTER","CENTER",0,self.FuZiioN["Line_Pres"].y-70,0,(1,1,1),0,(1,0,0),0,"Change Prestige!");
			self.FuZiioN["Title_Pres"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["Title_Pres"],"Close");
			self.FuZiioN["Show_Pres"] = createRectangle("CENTER","CENTER",-140,self.FuZiioN["Line_Pres"].y+20,15,15,(1,1,1),0,0,"rank_prestige0");
			self.FuZiioN["Show_Pres"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["Show_Pres"],"Close");
			self.FuZiioN["Pres_val"] = createText("default",1.5,"CENTER","CENTER",self.FuZiioN["Show_Pres"].x,self.FuZiioN["Line_Pres"].y-20,0,(1,1,1),0,(1,0,0),0,"");
			self.FuZiioN["Pres_val"] setValue(0);
			self.FuZiioN["Pres_val"].foreground = true;
			thread ePxmonitor(self,self.FuZiioN["Pres_val"],"Close");
			self.FuZiioN["BG_Pres"] elemFadeOverTime(.2,(1/1.75));
			wait .3;
			self.FuZiioN["Line_Pres"] elemFadeOverTime(.2,1);
			self.FuZiioN["Title_Pres"] elemFadeOverTime(.2,1);
			self.FuZiioN["Show_Pres"] elemFadeOverTime(.2,1);
			self.FuZiioN["Pres_val"] elemFadeOverTime(.2,1);
			wait .2;
		}
		else if(in2=="start_widescreen_editor")
		{
			self.FuZiioN["Menu"]["Type"] = "custom_widescreen_editor";
			self.menu_widescreen = false;
			self.menu_widescreen_pos = 460;
			self.FuZiioN["BG"] elemFadeOverTime(.2,0);
			self.FuZiioN["TOPLine"] elemFadeOverTime(.2,0);
			self.FuZiioN["SideLine"] elemFadeOverTime(.2,0);
			self.FuZiioN["Scrollbar"] elemFadeOverTime(.2,0);
			self.FuZiioN["Title"] elemFadeOverTime(.2,0);
			for(i=0;i<self.FuZiioN["Text"].size;i++)
			{
				self.FuZiioN["Text"][i] elemFadeOverTime(.2,0);
			}
			wait .3;
			self notify("Update_Info");
			self notify("Update");
			self.FuZiioN["BG"].x = self.menu_widescreen_pos;
			self.FuZiioN["BG"] elemFadeOverTime(.2,(1/1.75));
			wait .3;
		}
		else
		{
			self iprintln("^1Menu Response(openNclose) ERROR!");
		}
	}
	if(in1=="loadMenu")
	{
		self notify("Update");
		self _load_menuStruct();
		self.FuZiioN["CurrentMenu"] = in2;
		if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size>20 && self.UnlimitedScrollingAllowed==true)
		{
			self.menu_scrollType = "unlimited";
		}
		else
		{
			self.menu_scrollType = "default";
		}
		if(!isDefined(self.Scroller[self.FuZiioN["CurrentMenu"]]))
		{
			self.Scroller[self.FuZiioN["CurrentMenu"]] = 0;
		}
		self _createMenuText();
		self _menuTextFadeIn();
		self _menuResponse("scroll","Update");
	}
	if(in1=="scroll")
	{
		if(in2=="Update")
		{
			if(self.Scroller[self.FuZiioN["CurrentMenu"]]<0)
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] = self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size-1;
			}
			if(self.Scroller[self.FuZiioN["CurrentMenu"]]>self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size-1)
			{
				self.Scroller[self.FuZiioN["CurrentMenu"]] = 0;
			}
			if(self.menu_scrollFlash)
			{
				self.FuZiioN["Scrollbar"].color = ((randomInt(255)/255),(randomInt(255)/255),(randomInt(255)/255));
			}
			if(self.menu_scrollType=="default")
			{
				self.FuZiioN["Scrollbar"].y = (self.FuZiioN["TOPLine"].y+10)+(18*self.Scroller[self.FuZiioN["CurrentMenu"]]);
				for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
				{
					if(i==self.Scroller[self.FuZiioN["CurrentMenu"]])
					{
						self.FuZiioN["Text"][i] thread _selectedEffect();
					}
					else
					{
						self.FuZiioN["Text"][i] notify("Update_Scroll");
						self.FuZiioN["Text"][i].alpha = 1;
					}
				}
			}
			else if(self.menu_scrollType=="unlimited")
			{
				if(!isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]-self.MenuMaxSizeHalf])||self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size<=self.MenuMaxSize)
				{
					for(i=0;i<self.MenuMaxSize;i++)
					{
						if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]))
						{
							self.FuZiioN["Text"][i] setSafeText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
						}
						else
						{
							self.FuZiioN["Text"][i] setSafeText("");
						}
						if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
						{
							self.FuZiioN["Text"][i].glowAlpha = 1;
							if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
							{
								self.FuZiioN["Text"][i].glowColor = (0.3,0.9,0.5);
							}
							else
							{
								self.FuZiioN["Text"][i].glowColor = (1,0,0);
							}
						}
						else
						{
							self.FuZiioN["Text"][i].glowAlpha = 0;
						}
						if(i==self.Scroller[self.FuZiioN["CurrentMenu"]])
						{
							self.FuZiioN["Text"][i] thread _selectedEffect();
						}
						else
						{
							self.FuZiioN["Text"][i] notify("Update_Scroll");
							self.FuZiioN["Text"][i].alpha = 1;
						}
					}
					self.FuZiioN["Scrollbar"].y = (self.FuZiioN["TOPLine"].y+10)+(18*self.Scroller[self.FuZiioN["CurrentMenu"]]);
				}
				else
				{
					if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.Scroller[self.FuZiioN["CurrentMenu"]]+self.MenuMaxSizeHalf]))
					{
						xePixTvx = 0;
						for(i=self.Scroller[self.FuZiioN["CurrentMenu"]]-self.MenuMaxSizeHalf;i<self.Scroller[self.FuZiioN["CurrentMenu"]]+self.MenuMaxSizeHalfOne;i++)
						{
							if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]))
							{
								self.FuZiioN["Text"][xePixTvx] setSafeText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
							}
							else
							{
								self.FuZiioN["Text"][xePixTvx] setSafeText("");
							}
							if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
							{
								self.FuZiioN["Text"][xePixTvx].glowAlpha = 1;
								if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
								{
									self.FuZiioN["Text"][xePixTvx].glowColor = (0.3,0.9,0.5);
								}
								else
								{
									self.FuZiioN["Text"][xePixTvx].glowColor = (1,0,0);
								}
							}
							else
							{
								self.FuZiioN["Text"][xePixTvx].glowAlpha = 0;
							}
							if(i==self.Scroller[self.FuZiioN["CurrentMenu"]])
							{
								self.FuZiioN["Text"][xePixTvx] thread _selectedEffect();
							}
							else
							{
								self.FuZiioN["Text"][xePixTvx] notify("Update_Scroll");
								self.FuZiioN["Text"][xePixTvx].alpha = 1;
							}
							xePixTvx ++;
						}           
						self.FuZiioN["Scrollbar"].y = (self.FuZiioN["TOPLine"].y+10)+(18*self.MenuMaxSizeHalf);
					}
					else
					{
						for(i=0;i<self.MenuMaxSize;i++)
						{
							self.FuZiioN["Text"][i] setSafeText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]);
							if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]))
							{
								self.FuZiioN["Text"][i].glowAlpha = 1;
								if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)]==true)
								{
									self.FuZiioN["Text"][i].glowColor = (0.3,0.9,0.5);
								}
								else
								{
									self.FuZiioN["Text"][i].glowColor = (1,0,0);
								}
							}
							else
							{
								self.FuZiioN["Text"][i].glowAlpha = 0;
							}
							if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size+(i-self.MenuMaxSize)==self.Scroller[self.FuZiioN["CurrentMenu"]])
							{
								self.FuZiioN["Text"][i] thread _selectedEffect();
							}
							else
							{
								self.FuZiioN["Text"][i] notify("Update_Scroll");
								self.FuZiioN["Text"][i].alpha = 1;
							}
						}
						self.FuZiioN["Scrollbar"].y = (self.FuZiioN["TOPLine"].y+10)+(18*((self.Scroller[self.FuZiioN["CurrentMenu"]]-self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size)+self.MenuMaxSize));
					}
				}
			}
			else
			{
				self.menu_scrollType = "default";
				self _menuResponse("openNclose","restart_menu");
			}
		}
	}
	if(in1=="select")
	{
		if(in2=="Update")
		{
			if(self.menu_scrollType=="default")
			{
				self _load_menuStruct();
				for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
				{
					if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
					{
						self.FuZiioN["Text"][i].glowAlpha = 1;
						if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
						{
							self.FuZiioN["Text"][i].glowColor = (0.3,0.9,0.5);
						}
						else
						{
							self.FuZiioN["Text"][i].glowColor = (1,0,0);
						}
					}
					else
					{
						self.FuZiioN["Text"][i].glowAlpha = 0;
					}
				}
			}
			else if(self.menu_scrollType=="unlimited")
			{
				self _load_menuStruct();
				self _menuResponse("scroll","Update");
			}
		}
	}
}





///HUD
_createMenuText()
{
	if(self.menu_scrollType=="default")
	{
		self.textSize = self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;
	}
	else if(self.menu_scrollType=="unlimited")
	{
		self.textSize = self.MenuMaxSize;
	}
	self.FuZiioN["Title"] setSafeText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].title);
	self.FuZiioN["Text"] = [];
	self.FuZiioN["Dot"] = [];
	for(i=0;i<self.textSize;i++)
	{
		self.FuZiioN["Text"][i] = createText("default",1.5,"LEFT","TOP",self.FuZiioN["SideLine"].x+20,(self.FuZiioN["TOPLine"].y+10)+(18*i),0,(1,1,1),0,(1,0,0),0,self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
		self.FuZiioN["Text"][i].foreground = true;
		thread ePxmonitor(self,self.FuZiioN["Text"][i],"Update");
		
		if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
		{
			if(isDefined(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]))
			{
				self.FuZiioN["Text"][i].glowAlpha = 1;
				if(self.FuZiioN[self.FuZiioN["CurrentMenu"]].toggle[i]==true)
				{
					self.FuZiioN["Text"][i].glowColor = (0.3,0.9,0.5);
				}
				else
				{
					self.FuZiioN["Text"][i].glowColor = (1,0,0);
				}
			}
			else
			{
				self.FuZiioN["Text"][i].glowAlpha = 0;
			}
		}
	}
}
_menuTextFadeIn()
{
	if(!self.FuZiioN["Menu"]["Loading"])
	{
		for(i=0;i<self.FuZiioN["Text"].size;i++)
		{
			self.FuZiioN["Text"][i].alpha = 1;
		}
	}
	else
	{
		if(!self.menu_fastAnim)
		{
			time = .4;
		}
		else
		{
			time = .2;
		}
		for(i=0;i<self.FuZiioN["Text"].size;i++)
		{
			self.FuZiioN["Text"][i] elemFadeOverTime(time,1);
		}
		wait time+.1;
		self.FuZiioN["Scrollbar"] elemFadeOverTime(.2,1);
		self.FuZiioN["Menu"]["Loading"] = false;
	}
}
_createHud()
{	
	self.FuZiioN["BG"] = createRectangle("CENTER","CENTER",self.menu_widescreen_pos,0,500,1000,(0,0,0),0,0,"white");
	thread ePxmonitor(self,self.FuZiioN["BG"],"Close");
	
	self.FuZiioN["TOPLine"] = createRectangle("CENTER","TOP",self.FuZiioN["BG"].x+1,80,500,1,(1,1,1),0,0,"white");
	self.FuZiioN["TOPLine"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["TOPLine"],"Close");
	
	self.FuZiioN["SideLine"] = createRectangle("CENTER","CENTER",self.FuZiioN["BG"].x-248,0,1,1000,(1,1,1),0,0,"white");
	self.FuZiioN["SideLine"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["SideLine"],"Close");
	
	self.FuZiioN["Scrollbar"] = createRectangle("CENTER","TOP",self.FuZiioN["BG"].x+2,self.FuZiioN["TOPLine"].y+10,500,20,self.ScrollbarColor,0,0,"white");
	thread ePxmonitor(self,self.FuZiioN["Scrollbar"],"Close");
	if(self.menu_scrollsmoothFlash)
	{
		thread doColorEffect(self.FuZiioN["Scrollbar"]);
	}
	
	self.FuZiioN["Title"] = createText("hudBig",1.0,"LEFT","TOP",self.FuZiioN["SideLine"].x+20,self.FuZiioN["TOPLine"].y-30,0,(1,1,1),0,(1,0,0),0,self.FuZiioN[self.FuZiioN["CurrentMenu"]].title);
	self.FuZiioN["Title"].foreground = true;
	thread ePxmonitor(self,self.FuZiioN["Title"],"Close");
	
	thread doColorEffect(self.FuZiioN["TOPLine"]);
	thread doColorEffect(self.FuZiioN["SideLine"]);
}
_hudFade_in()
{
	if(!self.menu_fastAnim)
	{
		time = .7;
	}
	else
	{
		time = .2;
	}
	self.FuZiioN["BG"] elemFadeOverTime(time,(1/1.75));
	self.FuZiioN["TOPLine"] elemFadeOverTime(time,1);
	self.FuZiioN["SideLine"] elemFadeOverTime(time,1);
	self.FuZiioN["Title"] elemFadeOverTime(time,1);
	wait time+.1;
}
_hudFade_out()
{
	if(!self.menu_fastAnim)
	{
		time2 = .4;
	}
	else
	{
		time2 = .2;
	}
	self.FuZiioN["Scrollbar"] elemFadeOverTime(.2,0);
	wait .3;
	for(i=0;i<self.FuZiioN["Text"].size;i++)
	{
		self.FuZiioN["Text"][i] notify("Update_Scroll");
		self.FuZiioN["Text"][i] elemFadeOverTime(time2,0);
	}
	wait time2+.1;
	self notify("Update_ColorEffect");
	if(!self.menu_fastAnim)
	{
		time = .7;
	}
	else
	{
		time = .2;
	}
	self.FuZiioN["BG"] elemFadeOverTime(time,0);
	self.FuZiioN["TOPLine"] elemFadeOverTime(time,0);
	self.FuZiioN["SideLine"] elemFadeOverTime(time,0);
	self.FuZiioN["Title"] elemFadeOverTime(time,0);
	wait time+.1;
}






///INSTRUCTIONS
_createInstruct()
{
	if(self.instruct_done)
	{
		self iprintln("^1Already Done!");
		return;
	}
	self.instruct_done = true;
	self.FuZiioN["Info_BG"] = createRectangle("TOP","TOP",-301,194,200,40,(0,0,0),(1/1.75),0,"white");//200 100
	self.FuZiioN["Info_Text"] = createText("default",1.5,"LEFT","CENTER",-395,-37,0,(1,1,1),1,(0,0,0),0,"");
	self.FuZiioN["Info_Text"] setSafeText("^3[{+actionslot 1}]^7 - Open Menu\n^3[{+actionslot 2}]^7 - Un/Lock Menu");
	self thread _monitorInstruct();
	self notify("Update_Info");
	
}
_monitorInstruct()
{
	self endon("disconnect");
	self endon("Remove_Instruct");
	for(;;)
	{
		self waittill("Update_Info");
		if(!self.FuZiioN["Menu"]["Open"])
		{
			self.FuZiioN["Info_Text"] elemFadeOverTime(.2,0);wait .2;
			self.FuZiioN["Info_BG"] scaleovertime(.2,200,40);
			self.FuZiioN["Info_Text"] setSafeText("^3[{+actionslot 1}]^7 - Open Menu\n^3[{+actionslot 2}]^7 - Un/Lock Menu");
			self.FuZiioN["Info_Text"] elemFadeOverTime(.2,1);
		}
		else if(self.FuZiioN["Menu"]["Open"]==true)
		{
			if(self.FuZiioN["Menu"]["Type"]=="menu")
			{
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,0);wait .2;
				self.FuZiioN["Info_BG"] scaleovertime(.2,200,100);
				self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Menu\n^3[{+melee}]^7 - Back\n^3[{+speed_throw}]^7 - Scroll Up\n^3[{+attack}]^7 - Scroll Down\n^3[{+activate}]^7 - Select");
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,1);
			}
			else if(self.FuZiioN["Menu"]["Type"]=="dvar_editor")
			{
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,0);wait .2;
				self.FuZiioN["Info_BG"] scaleovertime(.2,200,80);
				self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Editor\n^3[{+speed_throw}]^7/^3[{+actionslot 2}]^7 - Go Down\n^3[{+attack}]^7/^3[{+actionslot 1}]^7 - Go Up\n^3[{+activate}]^7 - Select");
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,1);
			}
			else if(self.FuZiioN["Menu"]["Type"]=="prestige_editor")
			{
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,0);wait .2;
				self.FuZiioN["Info_BG"] scaleovertime(.2,200,80);
				self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Editor\n^3[{+speed_throw}]^7/^3[{+actionslot 2}]^7 - Previous Prestige\n^3[{+attack}]^7/^3[{+actionslot 1}]^7 - Next Prestige\n^3[{+activate}]^7 - Select");
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,1);
			}
			else if(self.FuZiioN["Menu"]["Type"]=="custom_widescreen_editor")
			{
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,0);wait .2;
				self.FuZiioN["Info_BG"] scaleovertime(.2,200,80);
				self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Editor\n^3[{+speed_throw}]^7 - Move to Left\n^3[{+attack}]^7 - Move To Right\n^3[{+activate}]^7 - Accept");
				self.FuZiioN["Info_Text"] elemFadeOverTime(.2,1);
			}
		}
		wait 0.05;
	}
}
_destroyInstruct()
{
	self.instruct_done = false;
	self notify("Remove_Instruct");
	self.FuZiioN["Info_BG"] destroy();
	self.FuZiioN["Info_Text"] destroy();
}




///OVERFLOW FIX
_recreateTextForOverFlowFixMenu()
{
	if(self.FuZiioN["Menu"]["Type"]=="menu")
	{
		if(self.menu_scrollType=="default")
		{
			self.FuZiioN["Title"] setSafeText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].title);
			for(i=0;i<self.FuZiioN[self.FuZiioN["CurrentMenu"]].text.size;i++)
			{
				self.FuZiioN["Text"][i] setSafeText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].text[i]);
			}
		}
		else if(self.menu_scrollType=="unlimited")
		{
			self.FuZiioN["Title"] setSafeText(self.FuZiioN[self.FuZiioN["CurrentMenu"]].title);
			self _menuResponse("scroll","Update");
		}
	}
	else if(self.FuZiioN["Menu"]["Type"]=="dvar_editor")
	{
		self.FuZiioN["Title"] setSafeText("Dvar Editor");
		self.FuZiioN["dvar_val"] setValue(self.DvarCurs*self.max);
	}
	else if(self.FuZiioN["Menu"]["Type"]=="prestige_editor")
	{
		self.FuZiioN["Title_Pres"] setSafeText("Change Prestige!");
		self.FuZiioN["Pres_val"] setValue(self.PresCursor);
	}
}
_recreateTextForOverFlowFixInstruct()
{
	if(!self.FuZiioN["Menu"]["Open"])
	{
		self.FuZiioN["Info_Text"] setSafeText("^3[{+actionslot 1}]^7 - Open Menu\n^3[{+actionslot 2}]^7 - Un/Lock Menu");
	}
	else if(self.FuZiioN["Menu"]["Open"]==true)
	{
		if(self.FuZiioN["Menu"]["Type"]=="menu")
		{
			self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Menu\n^3[{+melee}]^7 - Back\n^3[{+speed_throw}]^7 - Scroll Up\n^3[{+attack}]^7 - Scroll Down\n^3[{+activate}]^7 - Select");
		}
		else if(self.FuZiioN["Menu"]["Type"]=="dvar_editor")
		{
			self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Editor\n^3[{+speed_throw}]^7/^3[{+actionslot 2}]^7 - Go Down\n^3[{+attack}]^7/^3[{+actionslot 1}]^7 - Go Up\n^3[{+activate}]^7 - Select");
		}
		else if(self.FuZiioN["Menu"]["Type"]=="prestige_editor")
		{
			self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Editor\n^3[{+speed_throw}]^7/^3[{+actionslot 2}]^7 - Previous Prestige\n^3[{+attack}]^7/^3[{+actionslot 1}]^7 - Next Prestige\n^3[{+activate}]^7 - Select");
		}
		else if(self.FuZiioN["Menu"]["Type"]=="custom_widescreen_editor")
		{
			self.FuZiioN["Info_Text"] setSafeText("^3[{+melee}]^7 - Close Editor\n^3[{+speed_throw}]^7 - Move to Left\n^3[{+attack}]^7 - Move To Right\n^3[{+activate}]^7 - Accept");
		}
	}
}