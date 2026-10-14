package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;
   import liteAssets.listOptionsItem.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol868")]
   public class mcOption extends MovieClip
   {

      private static const SECTIONS:Array = ["Controls","Interface","Chat","Combat","Quests","Drops","Graphics & Performance","Developer","Other"];

      private static const SECTION_OF:Object = {
         "Keybinds":"Controls",
         "Mobile Controls":"Controls",
         "Gamepad Controls":"Controls",
         "Hide UI":"Interface",
         "Reset UI Positions":"Interface",
         "Class Actives/Auras UI":"Interface",
         "Visual Skill CDs":"Interface",
         "Display FPS":"Interface",
         "Show Monster Type":"Interface",
         "Travel Menu":"Interface",
         "Battle Analyzer":"Interface",
         "Char Page":"Interface",
         "Character Select Screen":"Interface",
         "Color Sets":"Interface",
         "Comic Sans Font":"Interface",
         "Chat Settings":"Chat",
         "Chat UI":"Chat",
         "Disable Chat Scrolling":"Chat",
         "Auto-Untarget Dead Targets":"Combat",
         "Auto-Untarget Self":"Combat",
         "Battlepets":"Combat",
         "Disable Damage Numbers":"Combat",
         "Disable Damage Strobe":"Combat",
         "Freeze / Lock Monster Position":"Combat",
         "Allow Quest Log Turn-Ins":"Quests",
         "Reaccept Quest After Turn-In":"Quests",
         "Disable Quest Popup":"Quests",
         "Disable Quest Tracker":"Quests",
         "Quest Pinner":"Quests",
         "Quest Progress Notifications":"Quests",
         "Custom Drops UI":"Drops",
         "Draggable Drops":"Drops",
         "Decline All Drops":"Drops",
         "Item Drops Block List":"Drops",
         "Hide Ground Items":"Drops",
         "Max FPS":"Graphics & Performance",
         "Disable Monster Animations":"Graphics & Performance",
         "Disable Self Animations":"Graphics & Performance",
         "Disable Skill Animations":"Graphics & Performance",
         "Disable Weapon Animations":"Graphics & Performance",
         "Disable Aura Animations":"Graphics & Performance",
         "Hide Healing Bubbles":"Graphics & Performance",
         "Smooth Background":"Graphics & Performance",
         "Static Player Art":"Graphics & Performance",
         "Invisible Monsters":"Graphics & Performance",
         "Hide Players":"Graphics & Performance",
         "Hide Player Names":"Graphics & Performance",
         "@ Debugger":"Developer"
      };

      public var bg:MovieClip;

      public var bg2:MovieClip;

      public var bgProf:MovieClip;

      public var btnAcc:SimpleButton;

      public var btnAccount:MovieClip;

      public var btnAdvOptions:SimpleButton;

      public var btnAllSound:SimpleButton;

      public var btnCameraTool:SimpleButton;

      public var btnChange:SimpleButton;

      public var btnChat:MovieClip;

      public var btnFBFriends:SimpleButton;

      public var btnFX:SimpleButton;

      public var btnFriend:SimpleButton;

      public var btnFullscreen:SimpleButton;

      public var btnGame:MovieClip;

      public var btnGeneral:MovieClip;

      public var btnGuild:SimpleButton;

      public var btnHelp:SimpleButton;

      public var btnIgnore:SimpleButton;

      public var btnLeftAllCloak:MovieClip;

      public var btnLeftAnim:MovieClip;

      public var btnLeftCloak:MovieClip;

      public var btnLeftDuel:MovieClip;

      public var btnLeftFriend:MovieClip;

      public var btnLeftGoto:MovieClip;

      public var btnLeftGuild:MovieClip;

      public var btnLeftHelm:MovieClip;

      public var btnLeftOtherPet:MovieClip;

      public var btnLeftParty:MovieClip;

      public var btnLeftPet:MovieClip;

      public var btnLeftProf:MovieClip;

      public var btnLeftTool:MovieClip;

      public var btnLeftWhisp:MovieClip;

      public var btnLink:SimpleButton;

      public var btnLogout:SimpleButton;

      public var btnLogoutFB:MovieClip;

      public var btnLore:SimpleButton;

      public var btnMusic:SimpleButton;

      public var btnPlayer:SimpleButton;

      public var btnRightAllCloak:MovieClip;

      public var btnRightAnim:MovieClip;

      public var btnRightCloak:MovieClip;

      public var btnRightDuel:MovieClip;

      public var btnRightFriend:MovieClip;

      public var btnRightGoto:MovieClip;

      public var btnRightGuild:MovieClip;

      public var btnRightHelm:MovieClip;

      public var btnRightOtherPet:MovieClip;

      public var btnRightParty:MovieClip;

      public var btnRightPet:MovieClip;

      public var btnRightProf:MovieClip;

      public var btnRightTool:MovieClip;

      public var btnRightWhisp:MovieClip;

      public var btnScreen:SimpleButton;

      public var btnShare:SimpleButton;

      public var btnShowAdv:SimpleButton;

      public var fbText:TextField;

      public var latencyStatus:MovieClip;

      public var mcServer:MovieClip;

      public var mcVis:MovieClip;

      public var txtAllCloak:TextField;

      public var txtAnim:TextField;

      public var txtBGProf:TextField;

      public var txtCVersion:TextField;

      public var txtCloak:TextField;

      public var txtDuel:TextField;

      public var txtFBLink:TextField;

      public var txtFriend:TextField;

      public var txtFriendsList:TextField;

      public var txtGoto:TextField;

      public var txtGuild:TextField;

      public var txtHelm:TextField;

      public var txtLatency:TextField;

      public var txtOtherPet:TextField;

      public var txtParty:TextField;

      public var txtPet:TextField;

      public var txtProf:TextField;

      public var txtShare:TextField;

      public var txtTool:TextField;

      public var txtWhisp:TextField;

      private var rootClass:MovieClip;

      private const arrQuality:Array = new Array("AUTO","LOW","MEDIUM","HIGH");

      private var ptrQ:uint = 0;

      private var serverTimer:Timer = new Timer(1000);

      private var strFriend:String = "{app_id:163679093835836, redirect_uri:\'www.aq.com/?something=something\', title=\'title 50 max characters\', data=\'requestTrackingID=5125136\'}";

      private var strExclude:String = "";

      private var passMC:MovieClip;

      private var ArrowButtons:Object;

      public var optObj:*;

      public var optItem:*;

      public var Len:*;

      public var optionList:*;

      public var hRun:Number;

      public var dRun:Number;

      public var oy:Number;

      public var mDown:Boolean;

      public var mbY:int;

      public var mbD:int;

      public var mhY:int;

      public var pos:int;

      public var i:int;

      private var touch:TouchScroll;

      private var toolTip:ToolTipMC;

      private var toolTipMC:*;

      public var latency:Number;

      internal var sDown:Boolean;

      private var sbTrack:Sprite;

      private var sbThumb:Sprite;

      private var sbTrackH:int = 0;

      private var sbThumbH:int = -1;

      private var sbDragOff:Number = 0;

      private var sbStage:Stage;

      private var searchBox:Sprite;

      private var searchHint:TextField;

      private var searchClear:Sprite;

      private var sbTouch:Boolean = false;

      public function mcOption(param1:MovieClip)
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,17,this.frame18,25,this.frame26);
         this.rootClass = param1;
      }

      public function Init() : void
      {
         this.btnGeneral.gotoAndStop(1);
         this.btnChat.gotoAndStop(1);
         this.btnAccount.gotoAndStop(1);
         this.btnGame.gotoAndStop(1);
         if(this.currentLabel != "General")
         {
            this.gotoAndStop("General");
         }
         this.btnGeneral.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGeneral.gotoAndStop(2);
         this.btnGeneral.buttonMode = true;
         this.btnChat.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnChat.buttonMode = true;
         this.btnAccount.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnAccount.buttonMode = true;
         this.btnGame.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGame.buttonMode = true;
         this.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnChange.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnLogout.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.setUpFrame("General");
         this.btnShowAdv.visible = false;
         this.btnAdvOptions.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.bg2.visible = this.rootClass.litePreference.data.bVisible;
         this.bg2.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.bg2.bg.btnClose.visible = true;
         this.toolTipMC = this.rootClass.ui.ToolTip;
         this.rootClass.initlitePref();
         this.redraw(this.rootClass.litePref);
         this.bg2.SBar.h.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown,false,0,true);
         this.bg2.addEventListener(MouseEvent.MOUSE_UP,this.onScrUp,false,0,true);
         this.bg2.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
         this.optionList.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
         this.optionList.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
         this.touch = TouchScroll.attach(this.bg2,this.touchGet,this.touchSet,this.touchMax);
         this.bg2.txtSearch.addEventListener(Event.CHANGE,this.onSearch,false,0,true);
         this.bg2.txtSearch.text = "";
         this.buildScrollbar();
         this.buildSearch();
         this.serverTimer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this.serverTimer.start();
         this.txtCVersion.visible = true;
         this.txtCVersion.text = this.rootClass.cVersion;
         if(int(this.rootClass.world.myAvatar.objData.iAge) < 18)
         {
            this.rootClass.uoPref.bProf = true;
         }
         this.latency = new Date().getTime();
         var _loc1_:ColorTransform = new ColorTransform();
         _loc1_.color = 16711680;
         this.latencyStatus.transform.colorTransform = _loc1_;
         this.rootClass.sfc.sendXtMessage("zm","hi",[],"str",1);
      }

      public function fClose() : void
      {
         if(this.touch != null)
         {
            this.touch.detach();
            this.touch = null;
         }
         this.endThumbDrag();
         if(this.optionList != null)
         {
            this.optionList.removeEventListener(Event.ENTER_FRAME,this.hEF);
            this.optionList.removeEventListener(Event.ENTER_FRAME,this.dEF);
         }
         this.serverTimer.stop();
         this.serverTimer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         var _loc1_:MovieClip = MovieClip(parent);
         _loc1_.removeChild(this);
         if(_loc1_.currentLabel != "Init")
         {
            _loc1_.gotoAndPlay("Init");
         }
      }

      public function setProfanity(param1:Boolean) : void
      {
         this.bgProf.visible = param1;
         this.txtBGProf.visible = param1;
         this.txtProf.visible = param1;
         this.btnLeftProf.visible = param1;
         this.btnRightProf.visible = param1;
      }

      public function InitAccount() : void
      {
         this.btnGeneral.gotoAndStop(1);
         this.btnChat.gotoAndStop(1);
         this.btnAccount.gotoAndStop(1);
         this.btnGame.gotoAndStop(1);
         if(this.currentLabel != "Account")
         {
            this.gotoAndPlay("Account");
         }
         this.btnGeneral.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGeneral.buttonMode = true;
         this.btnChat.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnChat.buttonMode = true;
         this.btnGame.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnGame.buttonMode = true;
         this.btnAccount.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
         this.btnAccount.buttonMode = true;
         this.btnChange.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnLogout.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
         this.btnAccount.gotoAndStop(2);
         this.serverTimer.addEventListener(TimerEvent.TIMER,this.timerHandler,false,0,true);
         this.serverTimer.start();
      }

      private function timerHandler(param1:TimerEvent) : void
      {
         if(stage == null)
         {
            this.serverTimer.stop();
            this.serverTimer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         }
         else if(this.mcServer != null)
         {
            this.mcServer.txtTime.text = this.rootClass.date_server.toLocaleTimeString();
         }
         if(MovieClip(parent) != null)
         {
            if(MovieClip(parent).currentLabel != "Option")
            {
               MovieClip(parent).removeChild(this);
               this.serverTimer.stop();
               this.serverTimer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
            }
         }
      }

      public function updateLatency() : void
      {
         this.txtLatency.text = String(this.latency) + " ms";
         var _loc1_:ColorTransform = new ColorTransform();
         if(Number(this.latency) < 100)
         {
            _loc1_.color = 65280;
         }
         else if(Number(this.latency) < 200)
         {
            _loc1_.color = 16776960;
         }
         else
         {
            _loc1_.color = 16711680;
         }
         this.latencyStatus.transform.colorTransform = _loc1_;
      }

      private function wireTabs() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Array = [this.btnGeneral,this.btnGame,this.btnChat,this.btnAccount];
         var _loc3_:uint = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc1_ = MovieClip(_loc2_[_loc3_]);
            if(_loc1_ != null)
            {
               _loc1_.buttonMode = true;
               if(!_loc1_.hasEventListener(MouseEvent.CLICK))
               {
                  _loc1_.addEventListener(MouseEvent.CLICK,this.onClick,false,0,true);
               }
               _loc1_.gotoAndStop(1);
            }
            _loc3_++;
         }
         var _loc4_:MovieClip = null;
         switch(this.currentLabel)
         {
            case "General":
               _loc4_ = MovieClip(this.btnGeneral);
               break;
            case "Gameplay":
               _loc4_ = MovieClip(this.btnGame);
               break;
            case "Social":
               _loc4_ = MovieClip(this.btnChat);
               break;
            case "Account":
               _loc4_ = MovieClip(this.btnAccount);
         }
         if(_loc4_ != null)
         {
            _loc4_.gotoAndStop(2);
         }
      }

      private function setUpFrame(param1:String) : void
      {
         var _loc1_:uint = 0;
         this.wireTabs();
         VolumePanel.soundButton(this,this.onArrowClick);
         switch(param1)
         {
            case "General":
               if(this.mcVis == null || this.mcServer == null)
               {
                  break;
               }
               this.rootClass.userPreference.data.bSoundOn = true;
               this.mcVis.txtQuality.text = this.rootClass.userPreference.data.quality;
               this.mcServer.txtServer.text = this.rootClass.objServerInfo.sName;
               if(!this.mcVis.btnLeftQual.hasEventListener(MouseEvent.CLICK))
               {
                  this.mcVis.btnLeftQual.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.mcVis.btnRightQual.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnScreen.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnFullscreen.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnMusic.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnFX.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnAllSound.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnCameraTool.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnFriend.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnGuild.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnIgnore.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnAdvOptions.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  _loc1_ = 0;
                  while(_loc1_ < this.arrQuality.length)
                  {
                     if(this.mcVis.txtQuality.text == this.arrQuality[_loc1_])
                     {
                        this.ptrQ = _loc1_;
                        break;
                     }
                     _loc1_++;
                  }
               }
               this.setQual();
               break;
            case "Gameplay":
               if(this.btnRightTool == null)
               {
                  break;
               }
               if(!this.btnRightTool.hasEventListener(MouseEvent.CLICK))
               {
                  this.btnRightTool.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftTool.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightHelm.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftHelm.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftAllCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightAllCloak.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightGoto.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftGoto.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftOtherPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightOtherPet.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightAnim.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftAnim.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
               }
               this.txtTool.text = this.rootClass.uoPref.bTT ? "On" : "Off";
               this.txtPet.text = this.rootClass.uoPref.bPet ? "Yes" : "No";
               this.txtHelm.text = this.rootClass.uoPref.bHelm ? "Yes" : "No";
               this.txtCloak.text = this.rootClass.uoPref.bCloak ? "Yes" : "No";
               this.txtGoto.text = this.rootClass.uoPref.bGoto ? "On" : "Off";
               this.txtAnim.text = this.rootClass.world.showAnimations ? "On" : "Off";
               this.txtAllCloak.text = this.rootClass.world.hideAllCapes ? "Yes" : "No";
               this.txtOtherPet.text = this.rootClass.world.hideOtherPets ? "Yes" : "No";
               break;
            case "Social":
               if(this.btnRightParty == null)
               {
                  break;
               }
               this.setProfanity(int(this.rootClass.world.myAvatar.objData.iAge) >= 18);
               if(!this.btnRightParty.hasEventListener(MouseEvent.CLICK))
               {
                  this.btnRightParty.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftParty.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightFriend.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftFriend.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightDuel.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftDuel.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightGuild.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftGuild.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightWhisp.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftWhisp.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnRightProf.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLeftProf.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
               }
               this.txtParty.text = this.rootClass.uoPref.bParty ? "On" : "Off";
               this.txtFriend.text = this.rootClass.uoPref.bFriend ? "On" : "Off";
               this.txtDuel.text = this.rootClass.uoPref.bDuel ? "On" : "Off";
               this.txtGuild.text = this.rootClass.uoPref.bGuild ? "On" : "Off";
               this.txtWhisp.text = this.rootClass.uoPref.bWhisper ? "On" : "Off";
               this.txtProf.text = this.rootClass.uoPref.bProf ? "On" : "Off";
               break;
            case "Account":
               if(this.btnAcc == null)
               {
                  break;
               }
               if(!this.btnAcc.hasEventListener(MouseEvent.CLICK))
               {
                  this.btnAcc.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnHelp.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnPlayer.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  this.btnLore.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  if(this.rootClass.world.myAvatar.objData.iAge < 13 || Game.objLogin.FBID > 0 && !FacebookConnect.isLoggedIn)
                  {
                     this.btnLink.visible = false;
                     this.txtFBLink.visible = false;
                     this.fbText.visible = false;
                  }
                  else
                  {
                     this.btnLink.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
                  }
                  this.btnLink.visible = false;
                  this.txtFBLink.visible = false;
               }
               this.checkFBStatus();
               this.txtFBLink.mouseEnabled = false;
               this.btnLogoutFB.visible = FacebookConnect.isLoggedIn;
               this.btnLogoutFB.addEventListener(MouseEvent.CLICK,this.onArrowClick,false,0,true);
               this.btnLogoutFB.buttonMode = true;
               this.btnFBFriends.visible = false;
               this.txtFriendsList.visible = false;
               this.btnShare.visible = false;
               this.txtShare.visible = false;
         }
      }

      private function onClick(param1:MouseEvent) : void
      {
         this.btnGeneral.gotoAndStop(1);
         this.btnChat.gotoAndStop(1);
         this.btnAccount.gotoAndStop(1);
         this.btnGame.gotoAndStop(1);
         param1.currentTarget.gotoAndStop(2);
         var _loc1_:String = "";
         switch(param1.currentTarget.name)
         {
            case "btnGeneral":
               _loc1_ = "General";
               break;
            case "btnGame":
               _loc1_ = "Gameplay";
               break;
            case "btnChat":
               _loc1_ = "Social";
               break;
            case "btnAccount":
               _loc1_ = "Account";
         }
         if(_loc1_ != "")
         {
            if(this.currentLabel != _loc1_)
            {
               this.gotoAndStop(_loc1_);
            }
            this.setUpFrame(_loc1_);
         }
      }

      public function musicVolume(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.litePreference.data.dOptions["iSoundMusic"] = Number(param1.iQty / 100);
            this.rootClass.litePreference.flush();
            if(Boolean(this.rootClass.world.sController) && Boolean(this.rootClass.world.sController.mChannel))
            {
               this.rootClass.world.sController.mChannel.soundTransform = new SoundTransform(param1.iQty / 100);
            }
         }
      }

      public function fxVolume(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.litePreference.data.dOptions["iSoundFX"] = Number(param1.iQty / 100);
            this.rootClass.litePreference.flush();
            this.rootClass.mixer.stf = new SoundTransform(param1.iQty / 100);
         }
      }

      public function allVolume(param1:Object) : void
      {
         if(param1.accept)
         {
            this.rootClass.litePreference.data.dOptions["iSoundAll"] = Number(param1.iQty / 100);
            this.rootClass.litePreference.flush();
            SoundMixer.soundTransform = new SoundTransform(param1.iQty / 100);
         }
      }

      private function onArrowClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         switch(param1.currentTarget.name)
         {
            case "btnAdvOptions":
               this.bg2.visible = !this.bg2.visible;
               this.rootClass.litePreference.data.bVisible = this.bg2.visible;
               break;
            case "btnLeftQual":
               this.ptrQ = --this.ptrQ < 0 ? 3 : uint(this.ptrQ);
               this.setQual();
               break;
            case "btnRightQual":
               this.ptrQ = ++this.ptrQ > 3 ? 0 : uint(this.ptrQ);
               this.setQual();
               break;
            case "btnScreen":
               this.rootClass.stage.addChild(new worldCamera(this.rootClass));
               break;
            case "btnFullscreen":
               this.rootClass.toggleFullScreen();
               break;
            case "btnMusic":
            case "btnFX":
            case "btnAllSound":
            case "btnSoundSettings":
               VolumePanel.open(this.rootClass);
               break;
            case "btnLeftPet":
            case "btnRightPet":
               this.txtPet.text = this.txtPet.text == "Yes" ? "No" : "Yes";
               if(this.rootClass.uoPref.bPet)
               {
                  this.rootClass.uoPref.bPet = false;
                  this.rootClass.world.hideAllPets();
               }
               else
               {
                  this.rootClass.uoPref.bPet = true;
                  this.rootClass.world.showAllPets();
                  if(this.rootClass.world.hideOtherPets)
                  {
                     this.rootClass.world.hideAllPets(false);
                  }
               }
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bPet",String(this.rootClass.uoPref.bPet)],"str",1);
               break;
            case "btnLeftOtherPet":
            case "btnRightOtherPet":
               this.txtOtherPet.text = this.txtOtherPet.text == "Yes" ? "No" : "Yes";
               if(this.rootClass.world.hideOtherPets)
               {
                  this.rootClass.world.hideOtherPets = false;
                  this.rootClass.world.showAllPets(false);
               }
               else
               {
                  this.rootClass.world.hideOtherPets = true;
                  this.rootClass.world.hideAllPets(false);
               }
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bOtherPets",String(this.rootClass.world.hideOtherPets)],"str",1);
               break;
            case "btnLeftHelm":
            case "btnRightHelm":
               this.txtHelm.text = this.txtHelm.text == "Yes" ? "No" : "Yes";
               this.rootClass.uoPref.bHelm = !this.rootClass.uoPref.bHelm;
               this.rootClass.world.myAvatar.dataLeaf.showHelm = this.rootClass.uoPref.bHelm;
               this.rootClass.world.myAvatar.pMC.setHelmVisibility(this.rootClass.uoPref.bHelm);
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bHelm",String(this.rootClass.uoPref.bHelm)],"str",1);
               break;
            case "btnLeftCloak":
            case "btnRightCloak":
               this.txtCloak.text = this.txtCloak.text == "Yes" ? "No" : "Yes";
               this.rootClass.uoPref.bCloak = !this.rootClass.uoPref.bCloak;
               this.rootClass.world.myAvatar.dataLeaf.showCloak = this.rootClass.uoPref.bCloak;
               this.rootClass.world.myAvatar.pMC.setCloakVisibility(this.rootClass.uoPref.bCloak);
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bCloak",String(this.rootClass.uoPref.bCloak)],"str",1);
               break;
            case "btnLeftAllCloak":
            case "btnRightAllCloak":
               this.txtAllCloak.text = this.txtAllCloak.text == "Yes" ? "No" : "Yes";
               this.rootClass.world.hideAllCapes = !this.rootClass.world.hideAllCapes;
               this.rootClass.world.setAllCloakVisibility();
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bAllCloak",String(this.rootClass.world.hideAllCapes)],"str",1);
               break;
            case "btnLeftTool":
            case "btnRightTool":
               this.txtTool.text = this.txtTool.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bTT = !this.rootClass.uoPref.bTT;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bTT",String(this.rootClass.uoPref.bTT)],"str",1);
               break;
            case "btnLeftGoto":
            case "btnRightGoto":
               this.txtGoto.text = this.txtGoto.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bGoto = !this.rootClass.uoPref.bGoto;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bGoto",String(this.rootClass.uoPref.bGoto)],"str",1);
               break;
            case "btnLeftParty":
            case "btnRightParty":
               this.txtParty.text = this.txtParty.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bParty = !this.rootClass.uoPref.bParty;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bParty",String(this.rootClass.uoPref.bParty)],"str",1);
               break;
            case "btnLeftDuel":
            case "btnRightDuel":
               this.txtDuel.text = this.txtDuel.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bDuel = !this.rootClass.uoPref.bDuel;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bDuel",String(this.rootClass.uoPref.bDuel)],"str",1);
               break;
            case "btnLeftAnim":
            case "btnRightAnim":
               this.txtAnim.text = this.txtAnim.text == "On" ? "Off" : "On";
               this.rootClass.world.showAnimations = !this.rootClass.world.showAnimations;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bAnim",String(this.rootClass.world.showAnimations)],"str",1);
               break;
            case "btnLeftFriend":
            case "btnRightFriend":
               this.txtFriend.text = this.txtFriend.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bFriend = !this.rootClass.uoPref.bFriend;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bFriend",String(this.rootClass.uoPref.bFriend)],"str",1);
               break;
            case "btnLeftGuild":
            case "btnRightGuild":
               this.txtGuild.text = this.txtGuild.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bGuild = !this.rootClass.uoPref.bGuild;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bGuild",String(this.rootClass.uoPref.bGuild)],"str",1);
               break;
            case "btnLeftWhisp":
            case "btnRightWhisp":
               this.txtWhisp.text = this.txtWhisp.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bWhisper = !this.rootClass.uoPref.bWhisper;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bWhisper",String(this.rootClass.uoPref.bWhisper)],"str",1);
               break;
            case "btnLeftProf":
            case "btnRightProf":
               this.txtProf.text = this.txtProf.text == "On" ? "Off" : "On";
               this.rootClass.uoPref.bProf = !this.rootClass.uoPref.bProf;
               this.rootClass.sfc.sendXtMessage("zm","cmd",["uopref","bProf",String(this.rootClass.uoPref.bProf)],"str",1);
               break;
            case "btnFriend":
               this.rootClass.world.showFriendsList();
               break;
            case "btnGuild":
               this.rootClass.world.showGuildList();
               break;
            case "btnIgnore":
               this.rootClass.world.showIgnoreList();
               break;
            case "btnAcc":
               navigateToURL(new URLRequest("https://account.aq.com/"),"_blank");
               break;
            case "btnChar":
               break;
            case "btnHelp":
               navigateToURL(new URLRequest("https://www.aq.com/help/"),"_blank");
               break;
            case "btnCameraTool":
               this.rootClass.cameraToolMC = new cameraTool(this.rootClass);
               this.rootClass.cameraToolMC.x = -7;
               this.rootClass.addChild(this.rootClass.cameraToolMC);
               this.rootClass.world.visible = false;
               break;
            case "btnLogout":
               this.rootClass.logout();
               break;
            case "btnClose":
               this.rootClass.ui.mcPopup.onClose();
               this.rootClass.stage.focus = null;
               break;
            case "btnLore":
               navigateToURL(new URLRequest("https://www.aq.com/lore"),"_blank");
               break;
            case "btnChange":
               this.rootClass.showServerList();
               break;
            case "btnPlayer":
               navigateToURL(new URLRequest("https://www.aq.com/info/handbook/"),"_blank");
               break;
            case "btnLink":
               if(FacebookConnect.isLoggedIn)
               {
                  this.passMC = new mcFBPassword(this.rootClass) as MovieClip;
                  this.passMC.x = 268;
                  this.passMC.y = 30;
                  this.rootClass.ui.addChild(this.passMC);
               }
               break;
            case "btnLogoutFB":
               FacebookConnect.Logout();
               this.rootClass.logout();
         }
      }

      private function setQual() : void
      {
         this.mcVis.txtQuality.text = this.rootClass.userPreference.data.quality = this.arrQuality[this.ptrQ];
         if(this.rootClass.userPreference.data.quality == "AUTO")
         {
            stage.quality = "HIGH";
         }
         else
         {
            stage.quality = this.rootClass.userPreference.data.quality;
         }
         try
         {
            this.rootClass.userPreference.flush();
         }
         catch(e:Error)
         {
            trace("[Game] ERR userPreference flush: " + e.message);
         }
      }

      public function checkFBStatus() : void
      {
         if(this.currentLabel == "Account")
         {
            this.txtFBLink.text = FacebookConnect.isLoggedIn ? "Unlink" : "Link";
         }
      }

      public function closeUnlink() : void
      {
         try
         {
            this.rootClass.ui.removeChild(this.passMC);
         }
         catch(e:*)
         {
         }
      }

      public function onOver(param1:MouseEvent) : void
      {
         try
         {
            if(!param1.target.parent.sDesc)
            {
               return;
            }
            this.toolTipMC.openWith({"str":param1.target.parent.sDesc});
         }
         catch(e:*)
         {
         }
      }

      public function onOut(param1:MouseEvent) : *
      {
         try
         {
            this.toolTipMC.close();
         }
         catch(e:*)
         {
         }
      }

      public function orderName(param1:*, param2:*) : int
      {
         var _loc1_:* = this.sortKey(param1["strName"]);
         var _loc2_:* = this.sortKey(param2["strName"]);
         if(_loc1_ < _loc2_)
         {
            return -1;
         }
         if(_loc1_ > _loc2_)
         {
            return 1;
         }
         return 0;
      }

      private function sortKey(param1:String) : String
      {
         return param1 == "Gamepad Controls" ? "Mobile ControlsuFFFF" : param1;
      }

      private function sectionOf(param1:String) : String
      {
         var _loc1_:int = param1.indexOf(": ");
         var _loc2_:String = SECTION_OF[_loc1_ > 0 ? param1.substr(0,_loc1_) : param1];
         return _loc2_ != null ? _loc2_ : "Other";
      }

      private function addRow(param1:Object, param2:Number, param3:Number, param4:int) : int
      {
         var _loc1_:* = undefined;
         if(param1.hasOwnProperty("special"))
         {
            this.optItem = new listOptionsItemTxt(this.rootClass,param1.sDesc);
         }
         else if(param1.hasOwnProperty("extra") && param1.extra is String || param1.btn == true)
         {
            this.optItem = new listOptionsItemBtn(this.rootClass,param1.sDesc);
         }
         else
         {
            this.optItem = new listOptionsItem(this.rootClass,param1.bEnabled,param1.sDesc);
         }
         this.optItem.txtName.text = param1.strName;
         _loc1_ = this.optionList.addChild(this.optItem);
         _loc1_.x = param2;
         _loc1_.y = param3 + param4;
         _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
         param4 += 35;
         if(!(param1.hasOwnProperty("extra") && param1.extra is Array))
         {
            return param4;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.extra.length)
         {
            if(param1.extra[_loc2_].hasOwnProperty("extra"))
            {
               this.optItem = new listOptionsItemExtraBtn(this.rootClass,param1.extra[_loc2_].sDesc);
            }
            else
            {
               this.optItem = new listOptionsItemExtra(this.rootClass,param1.extra[_loc2_].bEnabled,param1.extra[_loc2_].sDesc);
            }
            this.optItem.txtName.text = param1.extra[_loc2_].strName;
            _loc1_ = this.optionList.addChild(this.optItem);
            _loc1_.x = param2 + 9;
            _loc1_.y = param3 + param4;
            _loc1_.addEventListener(MouseEvent.MOUSE_OVER,this.onOver,false,0,true);
            _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.onOut,false,0,true);
            param4 += 35;
            _loc2_++;
         }
         return param4;
      }

      public function redraw(param1:Array) : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:RowHeader = null;
         this.bg2.SBar.h.y = 0;
         if(this.optionList != null)
         {
            this.optionList.removeEventListener(Event.ENTER_FRAME,this.hEF);
            this.optionList.removeEventListener(Event.ENTER_FRAME,this.dEF);
            this.bg2.removeChild(this.optionList);
            this.optionList = null;
         }
         this.optionList = this.bg2.addChild(new MovieClip());
         this.Len = param1.length;
         param1.sort(this.orderName);
         var _loc5_:Number = Number(this.bg2.cntMask.x);
         var _loc6_:Number = Number(this.bg2.cntMask.y);
         var _loc7_:int = 0;
         for each(_loc1_ in SECTIONS)
         {
            _loc2_ = true;
            _loc3_ = 0;
            while(_loc3_ < this.Len)
            {
               this.optObj = param1[_loc3_];
               if(this.sectionOf(this.optObj.strName) == _loc1_)
               {
                  if(!(Boolean(this.optObj.hasOwnProperty("minAccess")) && Game.objLogin.iAccess < this.optObj.minAccess))
                  {
                     if(_loc2_)
                     {
                        _loc4_ = new RowHeader(_loc1_,288);
                        _loc4_.x = _loc5_;
                        _loc4_.y = _loc6_ + _loc7_;
                        this.optionList.addChild(_loc4_);
                        _loc7_ += RowHeader.H;
                        _loc2_ = false;
                     }
                     _loc7_ = int(this.addRow(this.optObj,_loc5_,_loc6_,_loc7_));
                  }
               }
               _loc3_++;
            }
         }
         this.optionList.mask = this.bg2.cntMask;
         this.mDown = false;
         this.hRun = this.bg2.SBar.b.height - this.bg2.SBar.h.height;
         this.dRun = this.optionList.height - this.bg2.cntMask.height + 5;
         this.oy = this.optionList.y;
         this.optionList.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
         this.optionList.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
      }

      public function onSearch(param1:Event) : void
      {
         this.rootClass.initlitePref();
         var _loc1_:Number = 0;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < this.rootClass.litePref.length)
         {
            if(this.optionMatches(this.rootClass.litePref[_loc3_],this.bg2.txtSearch.text.toLowerCase()))
            {
               _loc2_.push(this.rootClass.litePref[_loc3_]);
               _loc1_ += this.rootClass.litePref[_loc3_].extra ? 1 + this.rootClass.litePref[_loc3_].extra.length : 1;
            }
            _loc3_++;
         }
         this.redraw(!this.bg2.txtSearch.text ? this.rootClass.litePref : _loc2_);
         _loc2_ = null;
         this.refreshSearchChrome();
         if(this.optionList.height <= this.bg2.cntMask.height + 2)
         {
            this.bg2.SBar.h.removeEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown);
            this.bg2.removeEventListener(MouseEvent.MOUSE_UP,this.onScrUp);
            this.bg2.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel);
         }
         else if(!this.bg2.SBar.h.hasEventListener(MouseEvent.MOUSE_DOWN))
         {
            this.bg2.SBar.h.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown,false,0,true);
            this.bg2.addEventListener(MouseEvent.MOUSE_UP,this.onScrUp,false,0,true);
            this.bg2.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
         }
      }

      private function optionMatches(param1:Object, param2:String) : Boolean
      {
         var _loc1_:Object = null;
         if(String(param1.strName).toLowerCase().indexOf(param2) > -1)
         {
            return true;
         }
         if(!(param1.extra is Array))
         {
            return false;
         }
         for each(_loc1_ in param1.extra)
         {
            if(String(_loc1_.strName).toLowerCase().indexOf(param2) > -1)
            {
               return true;
            }
         }
         return false;
      }

      private function onWheel(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.bg2.SBar;
         _loc1_.h.y = int(this.bg2.SBar.h.y) + param1.delta * 3 * -1;
         if(_loc1_.h.y + _loc1_.h.height > _loc1_.b.height)
         {
            _loc1_.h.y = int(_loc1_.b.height - _loc1_.h.height);
         }
         if(_loc1_.h.y < 0)
         {
            _loc1_.h.y = 0;
         }
      }

      private function touchMax() : Number
      {
         if(!this.bg2.SBar.h.hasEventListener(MouseEvent.MOUSE_DOWN) || this.hRun <= 0 || this.dRun <= 0)
         {
            return 0;
         }
         return this.dRun;
      }

      private function touchGet() : Number
      {
         if(this.hRun <= 0)
         {
            return 0;
         }
         return (this.bg2.SBar.h.y - 1) / this.hRun * this.dRun;
      }

      private function touchSet(param1:Number) : void
      {
         if(this.mDown || Boolean(this.sbTouch) || this.hRun <= 0 || this.dRun <= 0)
         {
            return;
         }
         this.bg2.SBar.h.y = 1 + param1 / this.dRun * this.hRun;
      }

      private function onScrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(this.bg2.SBar.h.y);
         this.mDown = true;
      }

      private function onScrUp(param1:MouseEvent) : void
      {
         this.mDown = false;
      }

      private function hEF(param1:Event) : *
      {
         var _loc1_:* = undefined;
         if(this.mDown)
         {
            _loc1_ = this.bg2.SBar;
            this.mbD = int(mouseY) - this.mbY;
            _loc1_.h.y = this.mhY + this.mbD;
            if(_loc1_.h.y + 1 + _loc1_.h.height > _loc1_.b.height + 1)
            {
               _loc1_.h.y = int(_loc1_.b.height + 1 - _loc1_.h.height);
            }
            if(_loc1_.h.y < 1)
            {
               _loc1_.h.y = 1;
            }
         }
      }

      private function buildScrollbar() : void
      {
         if(this.sbTrack != null && this.sbTrack.parent == this.bg2)
         {
            this.syncThumb();
            return;
         }
         var _loc1_:* = this.bg2.SBar;
         var _loc2_:Number = this.bg2.cntMask.y + 2;
         var _loc3_:Number = this.bg2.cntMask.y + this.bg2.cntMask.height - 2;
         _loc1_.visible = false;
         this.bg2.a1.visible = false;
         this.bg2.a2.visible = false;
         this.sbTrack = new Sprite();
         this.sbThumb = new Sprite();
         this.sbThumb.buttonMode = true;
         this.sbTrack.addChild(this.sbThumb);
         this.sbTrack.x = Math.round(_loc1_.x + (_loc1_.width - 8) / 2);
         this.sbTrack.y = Math.round(_loc2_);
         this.sbTrackH = Math.round(_loc3_ - _loc2_);
         var _loc4_:Graphics = this.sbTrack.graphics;
         _loc4_.beginFill(1710618);
         _loc4_.drawRoundRect(0,0,8,this.sbTrackH,8,8);
         _loc4_.endFill();
         this.bg2.addChild(this.sbTrack);
         this.sbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown,false,0,true);
         this.bg2.addEventListener(MouseEvent.MOUSE_DOWN,this.onBgDown,true,1,true);
         this.syncThumb();
      }

      private function onBgDown(param1:MouseEvent) : void
      {
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         this.sbTouch = _loc1_ != null && this.sbTrack != null && (_loc1_ == this.sbTrack || Boolean(this.sbTrack.contains(_loc1_)));
      }

      private function scrollable() : Boolean
      {
         return Boolean(this.bg2.SBar.h.hasEventListener(MouseEvent.MOUSE_DOWN)) && this.hRun > 0 && this.dRun > 0;
      }

      private function syncThumb() : void
      {
         var _loc1_:Matrix = null;
         var _loc2_:Graphics = null;
         if(this.sbTrack == null)
         {
            return;
         }
         this.sbTrack.visible = this.scrollable();
         if(!this.sbTrack.visible)
         {
            return;
         }
         var _loc3_:Number = Number(this.bg2.cntMask.height);
         var _loc4_:int = int(this.sbTrackH * _loc3_ / (this.dRun + _loc3_));
         if(_loc4_ < 24)
         {
            _loc4_ = 24;
         }
         if(_loc4_ > this.sbTrackH)
         {
            _loc4_ = int(this.sbTrackH);
         }
         if(_loc4_ != this.sbThumbH)
         {
            this.sbThumbH = _loc4_;
            _loc1_ = new Matrix();
            _loc1_.createGradientBox(8,_loc4_,0,0,0);
            _loc2_ = this.sbThumb.graphics;
            _loc2_.clear();
            _loc2_.lineStyle(1,13145646,1,true);
            _loc2_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc1_);
            _loc2_.drawRoundRect(0,0,8,_loc4_,8,8);
            _loc2_.endFill();
         }
         var _loc5_:Number = (this.bg2.SBar.h.y - 1) / this.hRun;
         if(_loc5_ < 0)
         {
            _loc5_ = 0;
         }
         else if(_loc5_ > 1)
         {
            _loc5_ = 1;
         }
         this.sbThumb.y = Math.round((this.sbTrackH - this.sbThumbH) * _loc5_);
      }

      private function setRatio(param1:Number) : void
      {
         if(param1 < 0)
         {
            param1 = 0;
         }
         else if(param1 > 1)
         {
            param1 = 1;
         }
         this.bg2.SBar.h.y = 1 + param1 * this.hRun;
         this.syncThumb();
      }

      private function onTrackDown(param1:MouseEvent) : void
      {
         if(!this.scrollable())
         {
            return;
         }
         if(param1.target == this.sbThumb)
         {
            this.endThumbDrag();
            this.sbDragOff = this.sbTrack.mouseY - this.sbThumb.y;
            this.sbStage = stage;
            if(this.sbStage != null)
            {
               this.sbStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove,false,0,true);
               this.sbStage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbUp,false,0,true);
            }
            return;
         }
         var _loc1_:Number = this.bg2.cntMask.height / this.dRun * 0.9;
         var _loc2_:Number = (this.bg2.SBar.h.y - 1) / this.hRun;
         this.setRatio(_loc2_ + (this.sbTrack.mouseY < this.sbThumb.y ? -_loc1_ : _loc1_));
      }

      private function onThumbMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = this.sbTrackH - this.sbThumbH;
         if(_loc1_ <= 0)
         {
            return;
         }
         this.setRatio((this.sbTrack.mouseY - this.sbDragOff) / _loc1_);
         param1.updateAfterEvent();
      }

      private function onThumbUp(param1:MouseEvent) : void
      {
         this.endThumbDrag();
      }

      private function endThumbDrag() : void
      {
         if(this.sbStage == null)
         {
            return;
         }
         this.sbStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove);
         this.sbStage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbUp);
         this.sbStage = null;
      }

      private function buildSearch() : void
      {
         var _loc1_:DisplayObject = null;
         if(this.searchBox != null && this.searchBox.parent == this.bg2)
         {
            this.drawSearchBox(false,this.bg2.cntMask.width,28);
            this.refreshSearchChrome();
            return;
         }
         var _loc2_:TextField = this.bg2.txtSearch;
         var _loc3_:* = _loc2_.getBounds(this.bg2);
         var _loc4_:int = 0;
         while(_loc4_ < this.bg2.numChildren)
         {
            _loc1_ = this.bg2.getChildAt(_loc4_);
            if(_loc1_ is Shape && _loc1_.getBounds(this.bg2).intersects(_loc3_))
            {
               _loc1_.visible = false;
            }
            _loc4_++;
         }
         var _loc5_:Number = Number(this.bg2.cntMask.x);
         var _loc6_:Number = Number(this.bg2.cntMask.width);
         var _loc7_:int = 28;
         var _loc8_:Number = Math.round(_loc3_.y + (_loc3_.height - _loc7_) / 2);
         this.searchBox = new Sprite();
         this.searchBox.x = _loc5_;
         this.searchBox.y = _loc8_;
         this.bg2.addChildAt(this.searchBox,this.bg2.getChildIndex(_loc2_));
         this.drawSearchBox(false,_loc6_,_loc7_);
         var _loc9_:Shape = new Shape();
         _loc9_.graphics.lineStyle(2,9079434,1,true);
         _loc9_.graphics.drawCircle(15,13,5);
         _loc9_.graphics.moveTo(19,17);
         _loc9_.graphics.lineTo(23,21);
         this.searchBox.addChild(_loc9_);
         this.searchHint = MailArt.tf(13,7829367);
         this.searchHint.text = "Search options";
         this.searchHint.x = 30;
         this.searchHint.y = Math.round((_loc7_ - this.searchHint.height) / 2);
         this.searchBox.addChild(this.searchHint);
         var _loc10_:TextFormat = new TextFormat("Arial",13,16777215);
         _loc2_.defaultTextFormat = _loc10_;
         _loc2_.setTextFormat(_loc10_);
         _loc2_.x = _loc5_ + 28;
         _loc2_.width = _loc6_ - 28 - 26;
         _loc2_.height = 20;
         _loc2_.y = _loc8_ + Math.round((_loc7_ - 20) / 2);
         _loc2_.addEventListener(FocusEvent.FOCUS_IN,this.onSearchFocus,false,0,true);
         _loc2_.addEventListener(FocusEvent.FOCUS_OUT,this.onSearchFocus,false,0,true);
         this.searchClear = new Sprite();
         this.searchClear.buttonMode = true;
         var _loc11_:Graphics = this.searchClear.graphics;
         _loc11_.beginFill(3815994);
         _loc11_.drawCircle(0,0,8);
         _loc11_.endFill();
         _loc11_.lineStyle(2,14540253,1,true);
         _loc11_.moveTo(-3,-3);
         _loc11_.lineTo(3,3);
         _loc11_.moveTo(3,-3);
         _loc11_.lineTo(-3,3);
         this.searchClear.x = _loc5_ + _loc6_ - 15;
         this.searchClear.y = _loc8_ + _loc7_ / 2;
         this.searchClear.addEventListener(MouseEvent.CLICK,this.onSearchClear,false,0,true);
         this.bg2.addChild(this.searchClear);
         this.refreshSearchChrome();
      }

      private function drawSearchBox(param1:Boolean, param2:Number, param3:int) : void
      {
         var _loc1_:Graphics = this.searchBox.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,param1 ? 13145646 : 3815994,1,true);
         _loc1_.beginFill(657930);
         _loc1_.drawRoundRect(0,0,param2,param3,param3,param3);
         _loc1_.endFill();
      }

      private function onSearchFocus(param1:FocusEvent) : void
      {
         this.drawSearchBox(param1.type == FocusEvent.FOCUS_IN,this.bg2.cntMask.width,28);
      }

      private function onSearchClear(param1:MouseEvent) : void
      {
         this.bg2.txtSearch.text = "";
         this.bg2.txtSearch.dispatchEvent(new Event(Event.CHANGE));
         if(stage != null)
         {
            stage.focus = this.bg2.txtSearch;
         }
      }

      private function refreshSearchChrome() : void
      {
         if(this.searchHint == null)
         {
            return;
         }
         var _loc1_:Boolean = this.bg2.txtSearch.text.length == 0;
         this.searchHint.visible = _loc1_;
         this.searchClear.visible = !_loc1_;
      }

      private function dEF(param1:Event) : *
      {
         this.syncThumb();
         var _loc1_:* = this.bg2.SBar;
         var _loc2_:* = this.optionList;
         var _loc3_:* = -(_loc1_.h.y - 1) / this.hRun;
         var _loc4_:* = int(_loc3_ * this.dRun) + this.oy;
         if(Math.abs(_loc4_ - _loc2_.y) > 0.2)
         {
            _loc2_.y += (_loc4_ - _loc2_.y) / 4;
         }
         else
         {
            _loc2_.y = _loc4_;
         }
      }

      internal function frame1() : *
      {
         this.setUpFrame(this.currentLabel);
         stop();
      }

      internal function frame10() : *
      {
         this.setUpFrame(this.currentLabel);
         stop();
      }

      internal function frame18() : *
      {
         this.setUpFrame(this.currentLabel);
         stop();
      }

      internal function frame26() : *
      {
         this.setUpFrame(this.currentLabel);
         stop();
      }
   }
}
