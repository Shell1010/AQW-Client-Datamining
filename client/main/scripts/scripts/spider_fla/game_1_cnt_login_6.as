package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol3693")]
   public dynamic class game_1_cnt_login_6 extends MovieClip
   {

      public var ModalStack:MovieClip;

      public var btnCreate:SimpleButton;

      public var btnFBLogin:SimpleButton;

      public var btnLogin:SimpleButton;

      public var btnMac:SimpleButton;

      public var btnWindows:SimpleButton;

      public var chkPassword:MovieClip;

      public var chkUserName:MovieClip;

      public var fbConnect:MovieClip;

      public var il:MovieClip;

      public var mcDisplay:MovieClip;

      public var mcForgotPassword:SimpleButton;

      public var mcLogo:MovieClip;

      public var mcManageAccount:SimpleButton;

      public var mcOr:MovieClip;

      public var mcPassword:MovieClip;

      public var mcTitle:MovieClip;

      public var ni:TextField;

      public var pi:TextField;

      public var sl:ServerList;

      public var testClientAssets:MovieClip;

      public var warning:MovieClip;

      public var __setTabDict:Dictionary = new Dictionary(true);

      public var __lastFrameTab:int = -1;

      public function game_1_cnt_login_6()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,27,this.frame28,37,this.frame38,46,this.frame47,57,this.frame58);
         addEventListener(Event.FRAME_CONSTRUCTED,this.__setTab_handler,false,0,true);
      }

      public function onCreateClick(param1:MouseEvent) : void
      {
         navigateToURL(new URLRequest("https://www.aq.com/landing/"),"_blank");
         this.btnCreate.removeEventListener(MouseEvent.CLICK,this.onCreateClick);
      }

      public function getWin(param1:Event) : *
      {
         navigateToURL(new URLRequest("http://launch.artix.com/latest/ArtixSetup.msi"),"_blank");
      }

      public function getMac(param1:Event) : *
      {
         navigateToURL(new URLRequest("http://launch.artix.com/latest/ArtixGames.dmg"),"_blank");
      }

      internal function __setTab_btnCreate_game_1_cnt_login_fields_0(param1:int) : *
      {
         if(this.btnCreate != null && param1 >= 1 && param1 <= 9 && (this.__setTabDict[this.btnCreate] == undefined || !(int(this.__setTabDict[this.btnCreate]) >= 1 && int(this.__setTabDict[this.btnCreate]) <= 9)))
         {
            this.__setTabDict[this.btnCreate] = param1;
            this.btnCreate.tabIndex = 3;
         }
      }

      internal function __setTab_btnLogin_game_1_cnt_login_fields_0(param1:int) : *
      {
         if(this.btnLogin != null && param1 >= 1 && param1 <= 9 && (this.__setTabDict[this.btnLogin] == undefined || !(int(this.__setTabDict[this.btnLogin]) >= 1 && int(this.__setTabDict[this.btnLogin]) <= 9)))
         {
            this.__setTabDict[this.btnLogin] = param1;
            this.btnLogin.tabIndex = 3;
         }
      }

      internal function __setTab_btnFBLogin_game_1_cnt_login_loginbtn_0(param1:int) : *
      {
         if(this.btnFBLogin != null && param1 >= 1 && param1 <= 9 && (this.__setTabDict[this.btnFBLogin] == undefined || !(int(this.__setTabDict[this.btnFBLogin]) >= 1 && int(this.__setTabDict[this.btnFBLogin]) <= 9)))
         {
            this.__setTabDict[this.btnFBLogin] = param1;
            this.btnFBLogin.tabIndex = 3;
         }
      }

      internal function __setTab_handler(param1:Object) : *
      {
         var _loc1_:int = currentFrame;
         if(this.__lastFrameTab == _loc1_)
         {
            return;
         }
         this.__lastFrameTab = _loc1_;
         this.__setTab_btnCreate_game_1_cnt_login_fields_0(_loc1_);
         this.__setTab_btnLogin_game_1_cnt_login_fields_0(_loc1_);
         this.__setTab_btnFBLogin_game_1_cnt_login_loginbtn_0(_loc1_);
      }

      internal function frame1() : *
      {
         FacebookConnect.StopPoll();
         this.btnCreate.addEventListener(MouseEvent.CLICK,this.onCreateClick,false,0,true);
         MovieClip(parent).initLogin();
         try
         {
            this.mcLogo.txtTitle.htmlText = "<font color=\"#FFB231\">New Release:</font> " + MovieClip(parent).sTitle;
         }
         catch(e:Error)
         {
            trace("no sTitle");
         }
         stop();
      }

      internal function frame10() : *
      {
         stop();
      }

      internal function frame28() : *
      {
         MovieClip(parent).showTracking("3");
         FacebookConnect.StopPoll();
         stop();
      }

      internal function frame38() : *
      {
         this.btnWindows.addEventListener(MouseEvent.CLICK,this.getWin);
         this.btnMac.addEventListener(MouseEvent.CLICK,this.getMac);
      }

      internal function frame47() : *
      {
         stop();
      }

      internal function frame58() : *
      {
         stop();
      }
   }
}
