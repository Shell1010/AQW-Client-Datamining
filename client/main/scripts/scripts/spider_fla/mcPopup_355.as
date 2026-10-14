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

   [Embed(source="/_assets/assets.swf", symbol="symbol4196")]
   public dynamic class mcPopup_355 extends MovieClip
   {

      public var GuildBG:MovieClip;

      public var cnt:FactionsMC;

      public var mcBag:SimpleButton;

      public var mcBook:MovieClip;

      public var mcCharpanel:CharpanelMC;

      public var mcCustomize:MovieClip;

      public var mcCustomizeArmor:MovieClip;

      public var mcHouseItemHandle:HouseItemHandleMC;

      public var mcHouseMenu:HouseMenu;

      public var mcHouseOptions:MovieClip;

      public var mcHouseShop:HouseShop;

      public var mcMap:MovieClip;

      public var mcNews:MovieClip;

      public var mcPVPPanel:PVPPanelMC;

      public var mcTempInventory:TempInventory;

      public var reportMC:MovieClip;

      public var rootClass:MovieClip;

      public var world:MovieClip;

      public var fData:Object;

      public var layout:LPFLayout;

      public var guild:*;

      public var li:mcGuildListItem;

      public var onlineCount:int;

      public var Rank:int;

      public var maxGuildSlots:int;

      public var i:*;

      public var hRun:Number;

      public var dRun:Number;

      public var oy:Number;

      public var mbY:int;

      public var mhY:int;

      public var mbD:int;

      public var mDown:Boolean;

      public function mcPopup_355()
      {
         super();
         addFrameScript(1,this.frame2,2,this.frame3,6,this.frame7,15,this.frame16,23,this.frame24,29,this.frame30,39,this.frame40,48,this.frame49,58,this.frame59,65,this.frame66,72,this.frame73,78,this.frame79,87,this.frame88,95,this.frame96,103,this.frame104,112,this.frame113,121,this.frame122,129,this.frame130,139,this.frame140,149,this.frame150,160,this.frame161,168,this.frame169,175,this.frame176,182,this.frame183,189,this.frame190);
      }

      public function initRefs() : void
      {
         if(stage)
         {
            this.rootClass = stage.getChildAt(0) as MovieClip;
            this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         }
      }

      public function fOpen(param1:String, param2:Object = null) : void
      {
         trace("fOpen > " + param1);
         if(currentLabel != param1)
         {
            this.fClose();
            if(param2 != null)
            {
               this.fData = param2;
            }
            gotoAndPlay(param1);
            visible = true;
         }
      }

      public function fClose() : *
      {
         var _loc1_:MovieClip = MovieClip(this);
         if(_loc1_.mcHouseMenu != null && _loc1_.mcHouseMenu.fClose != null)
         {
            _loc1_.mcHouseMenu.fClose();
         }
         var _loc2_:MovieClip = getChildByName("mcInventory") as MovieClip;
         if(Boolean(_loc2_) && _loc2_.fClose != null)
         {
            _loc2_.fClose();
         }
         var _loc3_:MovieClip = getChildByName("mcShop") as MovieClip;
         if(Boolean(_loc3_) && _loc3_.fClose != null)
         {
            _loc3_.fClose();
         }
         var _loc4_:MovieClip = getChildByName("mcBank") as MovieClip;
         if((Boolean(_loc4_)) && _loc4_.fClose != null)
         {
            _loc4_.fClose();
         }
         var _loc5_:MovieClip = getChildByName("mcCharpanel") as MovieClip;
         if((Boolean(_loc5_)) && _loc5_.fClose != null)
         {
            _loc5_.fClose();
         }
         var _loc6_:MovieClip = getChildByName("mcO") as MovieClip;
         if((Boolean(_loc6_)) && _loc6_.fClose != null)
         {
            _loc6_.fClose();
         }
      }

      public function onClose(param1:Event = null) : void
      {
         trace("mcPopup.onClose >");
         if(currentLabel != "Init" && currentFrame != 1)
         {
            this.fClose();
            if(MovieClip(Game.root) != null && MovieClip(Game.root).mixer != null)
            {
               MovieClip(Game.root).mixer.playSound("Click");
            }
            if(Boolean(this.world && this.world.isMyHouse != null && this.world.isMyHouse()) && Boolean(!this.world.mapLoadInProgress) && currentLabel != "House")
            {
               gotoAndPlay("House");
            }
            else
            {
               trace(" > init");
               gotoAndPlay("Init");
            }
         }
      }

      public function loadMap(param1:String) : *
      {
         this.mcMap.removeChildAt(0);
         var _loc1_:Loader = new Loader();
         _loc1_.load(new URLRequest(Game.serverFilePath + param1),new LoaderContext(false,ApplicationDomain.currentDomain));
         this.mcMap.addChild(_loc1_);
      }

      public function loadNews(param1:String) : *
      {
         this.mcNews.removeChildAt(0);
         var _loc1_:Loader = new Loader();
         _loc1_.load(new URLRequest(Game.serverFilePath + param1),new LoaderContext(false,ApplicationDomain.currentDomain));
         this.mcNews.addChild(_loc1_);
      }

      public function loadBook(param1:String) : *
      {
         trace(Game.serverFilePath + param1);
         this.mcBook.removeChildAt(0);
         if(this.rootClass.newInstance)
         {
            this.rootClass.newInstance = false;
            this.rootClass.bolContent.gotoAndStop("NavMenu");
         }
         this.mcBook.addChild(this.rootClass.bolContent);
      }

      public function updateGuildWindow() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         if(this.rootClass.world.myAvatar.objData.guildRank == 3 && this.rootClass.world.myAvatar.objData.guild.MaxMembers < this.maxGuildSlots)
         {
            _loc1_ = this.GuildBG.mcBuyButtons;
            _loc2_ = this.maxGuildSlots - int(this.rootClass.world.myAvatar.objData.guild.MaxMembers);
            this.GuildBG.tSlots.text = String(this.rootClass.world.myAvatar.objData.guild.MaxMembers) + "/" + String(this.maxGuildSlots);
            _loc1_.txtRest.text = "(" + String(_loc2_) + ")";
            _loc1_.txtRestCost.text = String(_loc2_ * 200) + " AC";
            _loc1_.txtCoins.text = String(this.rootClass.world.myAvatar.objData.intCoins);
            _loc1_.btnOne.addEventListener(MouseEvent.CLICK,this.onBuyClick,false,0,true);
            _loc1_.btnRest.addEventListener(MouseEvent.CLICK,this.onBuyClick,false,0,true);
         }
         else
         {
            this.GuildBG.tSlots.text = String(this.rootClass.world.myAvatar.objData.guild.MaxMembers) + "/" + String(this.maxGuildSlots);
            this.GuildBG.mcBuyButtons.visible = false;
         }
      }

      public function onBuyClick(param1:MouseEvent) : void
      {
         var _loc1_:int = 0;
         switch(param1.currentTarget.name)
         {
            case "btnOne":
               _loc1_ = 1;
               break;
            case "btnRest":
               _loc1_ = this.maxGuildSlots - int(this.rootClass.world.myAvatar.objData.guild.MaxMembers);
         }
         if(_loc1_ * 200 > this.rootClass.world.myAvatar.objData.intCoins)
         {
            this.rootClass.MsgBox.notify("You do not have enough ACs to purchase this.");
         }
         else
         {
            this.rootClass.world.addMemSlots(_loc1_);
         }
      }

      public function getRank(param1:int) : String
      {
         var _loc1_:String = "";
         switch(Number(param1))
         {
            case 0:
               _loc1_ = "Duffer";
               break;
            case 1:
               _loc1_ = "Member";
               break;
            case 2:
               _loc1_ = "Officer";
               break;
            case 3:
               _loc1_ = "Leader";
         }
         return _loc1_;
      }

      public function onGClose(param1:MouseEvent) : void
      {
         this.GuildBG.scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onScrUp);
         this.GuildBG.scr.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
         this.GuildBG.guildDisplay.removeEventListener(Event.ENTER_FRAME,this.dEF);
         this.GuildBG.mcBuyButtons.btnOne.removeEventListener(MouseEvent.CLICK,this.onBuyClick);
         this.GuildBG.mcBuyButtons.btnFive.removeEventListener(MouseEvent.CLICK,this.onBuyClick);
         this.GuildBG.mcBuyButtons.btnRest.removeEventListener(MouseEvent.CLICK,this.onBuyClick);
         this.onClose();
      }

      public function onScrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(this.GuildBG.scr.h.y);
         this.mDown = true;
      }

      public function onScrUp(param1:MouseEvent) : void
      {
         this.mDown = false;
      }

      public function hEF(param1:Event) : *
      {
         var _loc1_:* = undefined;
         if(this.mDown)
         {
            _loc1_ = this.GuildBG.scr;
            this.mbD = int(mouseY) - this.mbY;
            _loc1_.h.y = this.mhY + this.mbD;
            if(_loc1_.h.y + _loc1_.h.height > _loc1_.b.height)
            {
               _loc1_.h.y = int(_loc1_.b.height - _loc1_.h.height);
            }
            if(_loc1_.h.y < 0)
            {
               _loc1_.h.y = 0;
            }
         }
      }

      public function dEF(param1:Event) : *
      {
         var _loc1_:* = this.GuildBG.scr;
         var _loc2_:* = this.GuildBG.guildDisplay;
         var _loc3_:* = -_loc1_.h.y / this.hRun;
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

      internal function frame2() : *
      {
         if(stage)
         {
            this.initRefs();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,function(param1:Event):void
            {
               removeEventListener(Event.ADDED_TO_STAGE,arguments.callee);
               initRefs();
            },false,0,true);
         }
         this.fData = {};
         trace("mcPopup init");
         visible = false;
         stop();
      }

      internal function frame3() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.fData = {};
         visible = false;
         if(this.rootClass.mcO != null && Boolean(this.rootClass.getChildByName("mcO")))
         {
            this.removeChild(this.rootClass.mcO);
         }
         stop();
      }

      internal function frame7() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.layout = addChild(new LPFLayoutInvShopEnh()) as LPFLayoutInvShopEnh;
         this.layout.name = "mcInventory";
         this.layout.fOpen({
            "fData":{
               "itemsInv":this.world.myAvatar.items,
               "objData":this.world.myAvatar.objData
            },
            "r":{
               "x":0,
               "y":0,
               "w":stage.stageWidth,
               "h":stage.stageHeight
            },
            "sMode":"inventory"
         });
         this.layout = null;
         stop();
      }

      internal function frame16() : *
      {
         stop();
      }

      internal function frame24() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.layout = addChild(new LPFLayoutInvShopEnh()) as LPFLayoutInvShopEnh;
         this.layout.name = "mcShop";
         this.layout.fOpen({
            "fData":{
               "itemsShop":this.world.shopinfo.items,
               "itemsInv":this.world.myAvatar.items,
               "objData":this.world.myAvatar.objData,
               "shopinfo":this.world.shopinfo
            },
            "r":{
               "x":0,
               "y":0,
               "w":stage.stageWidth,
               "h":stage.stageHeight
            },
            "sMode":"shopBuy"
         });
         this.layout = null;
         stop();
      }

      internal function frame30() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.layout = addChild(new LPFLayoutMergeShop()) as LPFLayoutMergeShop;
         this.layout.name = "mcShop";
         this.layout.fOpen({
            "fData":{
               "itemsShop":this.world.shopinfo.items,
               "itemsInv":this.world.myAvatar.items,
               "objData":this.world.myAvatar.objData
            },
            "r":{
               "x":0,
               "y":0,
               "w":stage.stageWidth,
               "h":stage.stageHeight
            },
            "sMode":"shopBuy"
         });
         this.layout = null;
         stop();
      }

      internal function frame40() : *
      {
         stop();
      }

      internal function frame49() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.layout = addChild(new LPFLayoutBank()) as LPFLayoutBank;
         this.layout.name = "mcBank";
         this.layout.fOpen({
            "fData":{
               "itemsB":this.world.bankinfo.items,
               "itemsI":this.world.myAvatar.items,
               "objData":this.world.myAvatar.objData
            },
            "r":{
               "x":0,
               "y":0,
               "w":stage.stageWidth,
               "h":stage.stageHeight
            },
            "sMode":"bank"
         });
         this.layout = null;
         stop();
      }

      internal function frame59() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         if(!this.rootClass.TRAVEL_DATA_READY)
         {
            this.rootClass.getTravelMapData();
         }
         else
         {
            this.loadMap(this.rootClass.world.objInfo.sMap);
         }
         stop();
      }

      internal function frame66() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.loadNews(this.rootClass.world.objInfo.sNews);
         stop();
      }

      internal function frame73() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         if(!this.rootClass.BOOK_DATA_READY)
         {
            this.rootClass.retrieveBook();
         }
         else
         {
            this.loadBook(this.rootClass.world.objInfo.sBook);
         }
         stop();
      }

      internal function frame79() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.rootClass.mcO = this.rootClass.mcO == null ? new mcOption(this.rootClass) as MovieClip : this.rootClass.mcO;
         this.addChild(this.rootClass.mcO);
         this.rootClass.mcO.name = "mcO";
         this.rootClass.mcO.x = 600;
         this.rootClass.mcO.y = 100;
         if(this.fData.Account == null)
         {
            this.rootClass.mcO.Init();
         }
         else if(this.fData.Account != null)
         {
            delete this.fData.Account;
            this.rootClass.mcO.InitAccount();
         }
         stop();
      }

      internal function frame88() : *
      {
         stop();
      }

      internal function frame96() : *
      {
         stop();
      }

      internal function frame104() : *
      {
         stop();
      }

      internal function frame113() : *
      {
         stop();
      }

      internal function frame122() : *
      {
         this.mcHouseMenu.visible = false;
         this.mcHouseItemHandle.visible = false;
         this.mcHouseMenu.fOpen("default");
         stop();
      }

      internal function frame130() : *
      {
         stop();
      }

      internal function frame140() : *
      {
         stop();
      }

      internal function frame150() : *
      {
         stop();
      }

      internal function frame161() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.GuildBG.btnClose.addEventListener(MouseEvent.CLICK,this.onGClose,false,0,true);
         this.guild = this.rootClass.world.myAvatar.objData.guild;
         this.GuildBG.tTitle.text = this.guild.Name;
         this.onlineCount = 0;
         this.maxGuildSlots = 225;
         this.i = 0;
         while(this.i < this.guild.ul.length)
         {
            this.li = new mcGuildListItem();
            this.li.x = 0;
            this.li.y = this.i * 17;
            this.li.tName.text = String(this.guild.ul[this.i].userName);
            this.li.tRank.text = this.getRank(this.guild.ul[this.i].Rank);
            this.li.tServer.text = this.guild.ul[this.i].Server;
            this.li.tLevel.text = String(this.guild.ul[this.i].Level);
            if(this.guild.ul[this.i].Server.toLowerCase() != "offline")
            {
               ++this.onlineCount;
            }
            this.GuildBG.guildDisplay.addChild(this.li);
            ++this.i;
         }
         this.GuildBG.tMemCount.text = String(this.onlineCount) + "/" + String(this.guild.ul.length) + " Online";
         this.GuildBG.guildDisplay.mask = this.GuildBG.cntMask;
         if(this.GuildBG.guildDisplay.height > this.GuildBG.cntMask.height)
         {
            this.GuildBG.scr.visible = true;
            this.GuildBG.scr.hit.alpha = 0;
            this.GuildBG.scr.h.height = int(this.GuildBG.cntMask.height / this.GuildBG.guildDisplay.height * this.GuildBG.scr.b.height);
            this.hRun = this.GuildBG.scr.b.height - this.GuildBG.scr.h.height;
            this.dRun = this.GuildBG.guildDisplay.height - this.GuildBG.cntMask.height + 5;
            this.oy = this.GuildBG.guildDisplay.y;
            this.GuildBG.scr.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.onScrDown,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onScrUp,false,0,true);
            this.GuildBG.scr.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            this.GuildBG.guildDisplay.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
         }
         else
         {
            this.GuildBG.scr.visible = false;
         }
         this.updateGuildWindow();
         this.mDown = false;
      }

      internal function frame169() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.layout = addChild(new LPFLayoutHouseInvShop()) as LPFLayoutHouseInvShop;
         this.layout.name = "mcInventory";
         this.layout.fOpen({
            "fData":{
               "itemsInv":this.world.myAvatar.houseitems,
               "objData":this.world.myAvatar.objData
            },
            "r":{
               "x":0,
               "y":0,
               "w":stage.stageWidth,
               "h":stage.stageHeight
            },
            "sMode":"inventory"
         });
         this.layout = null;
         stop();
      }

      internal function frame176() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.layout = addChild(new LPFLayoutHouseBank()) as LPFLayoutHouseBank;
         this.layout.name = "mcBank";
         this.layout.fOpen({
            "fData":{
               "itemsB":this.world.bankinfo.items,
               "itemsI":this.world.myAvatar.houseitems,
               "objData":this.world.myAvatar.objData
            },
            "r":{
               "x":0,
               "y":0,
               "w":stage.stageWidth,
               "h":stage.stageHeight
            },
            "sMode":"bank"
         });
         this.layout = null;
         stop();
      }

      internal function frame183() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.layout = addChild(new LPFLayoutHouseInvShop()) as LPFLayoutHouseInvShop;
         this.layout.name = "mcShop";
         this.layout.fOpen({
            "fData":{
               "itemsShop":this.world.shopinfo.items,
               "itemsInv":this.world.myAvatar.houseitems,
               "objData":this.world.myAvatar.objData,
               "shopinfo":this.world.shopinfo
            },
            "r":{
               "x":0,
               "y":0,
               "w":stage.stageWidth,
               "h":stage.stageHeight
            },
            "sMode":"shopBuy"
         });
         this.layout = null;
         stop();
      }

      internal function frame190() : *
      {
         this.rootClass = stage ? stage.getChildAt(0) as MovieClip : null;
         this.world = this.rootClass ? this.rootClass.world as MovieClip : null;
         this.rootClass.requestInterface("guild/guildpanel.swf","guildPanel");
         stop();
      }
   }
}
