package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.draw.*;
   import liteAssets.mobile.*;

   public class LPFFrameInvAQ extends LPFFrame
   {

      public static const ROW_H:int = 30;

      public static const LIST_W:int = 398;

      private static const POOL_MAX:int = 16;

      private static const TAB_ALL:int = 0;

      private static const TAB_ITEMS:int = 1;

      private static const TAB_CLASS:int = 2;

      private static const TAB_MISC:int = 3;

      private static const TAB_HOUSE:int = 4;

      private static const LIST_Y:int = 100;

      private static const LIST_H:int = 336;

      private static const TAB_Y:int = 70;

      private static const TAB_H:int = 24;

      private static const TAB_PAD:int = 3;

      private static const UNKNOWN_RANK:int = 10000;

      private static const SORT_ORDER:Array = ["Note","Resource","Item","Quest Item","ServerUse","Enhancement","Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand","Class","Armor","Helm","Cape","Misc","Earring","Amulet","Necklace","Belt","Ring","Pet"];

      private static const EMPTY:Array = [];

      private static const INV_SUBFILTERS:Array = [{
         "label":"Show All",
         "icon":"iipack",
         "k":"*"
      },{
         "label":"Show only equipped",
         "icon":"iCheck",
         "k":"eq"
      },{
         "label":"Show only weapons",
         "icon":"iwsword",
         "k":"Weapon"
      },{
         "label":"Show only armor",
         "icon":"iwarmor",
         "k":"ar"
      },{
         "label":"Show only helms",
         "icon":"iihelm",
         "k":"he"
      },{
         "label":"Show only capes",
         "icon":"iicape",
         "k":"ba"
      },{
         "label":"Show only pets",
         "icon":"iipet",
         "k":"pe"
      },{
         "label":"Show only accessories",
         "icon":"iin1",
         "k":"am"
      },{
         "label":"Show only items",
         "icon":"iibag",
         "k":"it"
      },{
         "label":"Show only potions & elixirs",
         "icon":"ich1",
         "k":"pots"
      },{
         "label":"Show only favorites",
         "icon":"favstar",
         "k":"fav"
      }];

      private static const HOUSE_SUBFILTERS:Array = [{
         "label":"Show All",
         "icon":"iipack",
         "k":"*"
      },{
         "label":"Show only equipped",
         "icon":"iCheck",
         "k":"eq"
      },{
         "label":"Show only houses",
         "icon":"ihhouse",
         "k":"House"
      },{
         "label":"Show only walls",
         "icon":"ihwall",
         "k":"Wall Item"
      },{
         "label":"Show only floors",
         "icon":"ihfloor",
         "k":"Floor Item"
      }];

      private static const INV_FILTER_MAP:Object = {
         "Weapon":["Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand"],
         "ar":["Class","Armor"],
         "he":["Helm"],
         "ba":["Cape"],
         "pe":["Pet"],
         "am":["Misc","Earring","Amulet","Necklace","Belt","Ring"],
         "it":["Note","Resource","Item","Quest Item","ServerUse"],
         "pots":["Item"]
      };

      private static var sortRank:Object = null;

      private static var lastTab:int = 0;

      private static var mtx:Matrix = new Matrix();

      private static var goldIconClass:Class = null;

      private static var goldIconClassChecked:Boolean = false;

      private static var coinsIconClass:Class = null;

      private static var coinsIconClassChecked:Boolean = false;

      private static const ROW_FILL_MTX:Matrix = new Matrix();

      private var rootClass:MovieClip;

      private var closed:Boolean = false;

      private var tabDefs:Array;

      private var tabIdx:int = 0;

      private var subIdx:int = 0;

      private var tabCounts:Array = [0,0,0,0,0,0];

      private var searchQ:String = "";

      private var searchFocused:Boolean = false;

      private var searchTimer:Timer;

      private var view:Array = [];

      private var selItem:Object;

      private var scrollY:int = 0;

      private var touchScroll:TouchScroll;

      private var tabTouch:TouchScroll;

      private var listX:int = 50;

      private var listW:int = 252;

      private var rowW:int = 242;

      private var activeRows:Object = {};

      private var rowPool:Array = [];

      private var tmpKeys:Array = [];

      private var scrollRectR:Rectangle = new Rectangle();

      private var thumbH:int = 0;

      private var dragOff:Number = 0;

      private var dragStage:Stage;

      private var searchBox:Sprite;

      private var tfSearch:TextField;

      private var tfPlaceholder:TextField;

      private var btnQ:Sprite;

      private var btnE:Sprite;

      private var tabClip:Sprite;

      private var tabSprites:Array = [];

      private var tabLabels:Array = [];

      private var tabW:Array = [];

      private var tabTotalW:int = 0;

      private var tabScroll:int = 0;

      private var stripW:int = 0;

      private var subStrip:Sprite;

      private var subSets:Array = [];

      private var subBtns:Array = [];

      private var subEnabled:Array = [];

      private var listArea:Sprite;

      private var listBg:Shape;

      private var listBorder:Shape;

      private var listHolder:Sprite;

      private var sbTrack:Sprite;

      private var sbThumb:Sprite;

      private var tfEmpty:TextField;

      private var goldPill:Sprite;

      private var acPill:Sprite;

      private var goldIcon:DisplayObject;

      private var coinsIcon:DisplayObject;

      private var goldCR:Rectangle;

      private var coinsCR:Rectangle;

      private var tfGold:TextField;

      private var tfCoins:TextField;

      private var btnPlus:Sprite;

      private var tfSlots:TextField;

      private var fmtTabName:TextFormat;

      private var fmtTabNameSel:TextFormat;

      private var fmtTabCountSel:TextFormat;

      private var fmtWhiteB12:TextFormat;

      private var fmtGoldB12:TextFormat;

      private var fmtSlotNum:TextFormat;

      private var fmtSlotRed:TextFormat;

      private var fmtSlotLabel:TextFormat;

      private var wheelStage:Stage;

      public function LPFFrameInvAQ()
      {
         super();
      }

      private static function getGoldIconClass() : Class
      {
         if(!goldIconClassChecked)
         {
            goldIconClassChecked = true;
            try
            {
               goldIconClass = getDefinitionByName("LPFIconGold") as Class;
            }
            catch(e:Error)
            {
               goldIconClass = null;
            }
         }
         return goldIconClass;
      }

      private static function getCoinsIconClass() : Class
      {
         if(!coinsIconClassChecked)
         {
            coinsIconClassChecked = true;
            try
            {
               coinsIconClass = getDefinitionByName("LPFIconCoins") as Class;
            }
            catch(e:Error)
            {
               coinsIconClass = null;
            }
         }
         return coinsIconClass;
      }

      private static function rrect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:uint, param8:uint) : void
      {
         param1.lineStyle(1,param8,1,true);
         param1.beginFill(param7);
         param1.drawRoundRect(param2,param3,param4,param5,param6 * 2,param6 * 2);
         param1.endFill();
      }

      private static function rrectRow(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:uint) : void
      {
         ROW_FILL_MTX.createGradientBox(param4,param5,Math.PI / 2,param2,param3);
         param1.lineStyle(1,param7,1,true);
         param1.beginGradientFill(GradientType.LINEAR,[1776411,986895],[1,1],[0,255],ROW_FILL_MTX);
         param1.drawRoundRect(param2,param3,param4,param5,param6 * 2,param6 * 2);
         param1.endFill();
      }

      private static function itemMatchesFilter(param1:Object, param2:String) : Boolean
      {
         var _loc1_:String = null;
         var _loc2_:Array = INV_FILTER_MAP[param2] as Array;
         var _loc3_:Boolean = _loc2_ != null && _loc2_.indexOf(param1.sType) > -1 || param1.sType == "Enhancement" && String(param1.sES).indexOf(param2) > -1;
         if(!_loc3_)
         {
            return false;
         }
         if(param2 == "it" && param1.sType == "Item" && InvCat.isBag(param1))
         {
            return false;
         }
         if(param2 == "pots")
         {
            _loc1_ = param1.sLink != null ? String(param1.sLink).toLowerCase() : "";
            return _loc1_ == "potion" || _loc1_ == "elixir" || _loc1_ == "tonic" || _loc1_ == "scroll";
         }
         return true;
      }

      private static function subFilterMatches(param1:Object, param2:Object, param3:Boolean) : Boolean
      {
         if(param1 == null || param1.k == "*")
         {
            return true;
         }
         if(param1.k == "eq")
         {
            return param2.bEquip == 1 || param2.bWear == 1;
         }
         if(param1.k == "fav")
         {
            return FavStore.has(param2.ItemID);
         }
         if(param3)
         {
            return param2.sType == param1.k;
         }
         return itemMatchesFilter(param2,String(param1.k));
      }

      private static function compareItems(param1:Object, param2:Object) : int
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = sortRank[param1.sType];
         var _loc4_:* = sortRank[param2.sType];
         var _loc5_:int = _loc3_ == null ? int(UNKNOWN_RANK) : int(_loc3_);
         var _loc6_:int = _loc4_ == null ? int(UNKNOWN_RANK) : int(_loc4_);
         if(_loc5_ != _loc6_)
         {
            return _loc5_ < _loc6_ ? -1 : 1;
         }
         if(_loc5_ == UNKNOWN_RANK)
         {
            _loc1_ = String(param1.sType);
            _loc2_ = String(param2.sType);
            if(_loc1_ != _loc2_)
            {
               return _loc1_ < _loc2_ ? -1 : 1;
            }
         }
         _loc1_ = String(param1.sName);
         _loc2_ = String(param2.sName);
         if(_loc1_ != _loc2_)
         {
            return _loc1_ < _loc2_ ? -1 : 1;
         }
         var _loc7_:int = int(param1.iLvl);
         var _loc8_:int = int(param2.iLvl);
         if(_loc7_ != _loc8_)
         {
            return _loc7_ > _loc8_ ? -1 : 1;
         }
         var _loc9_:int = int(param1.ItemID);
         var _loc10_:int = int(param2.ItemID);
         if(_loc9_ != _loc10_)
         {
            return _loc9_ < _loc10_ ? -1 : 1;
         }
         return 0;
      }

      override public function fOpen(param1:Object) : void
      {
         eventTypes = ["refreshItems","refreshInv","listItemASel","refreshCoins","refreshSlots"];
         super.fOpen(param1);
         if(stage != null && stage.numChildren > 0)
         {
            this.rootClass = MovieClip(stage.getChildAt(0));
         }
         if(this.rootClass == null)
         {
            this.rootClass = getLayout().rootClass as MovieClip;
         }
         if(this.rootClass == null)
         {
            return;
         }
         this.buildFormats();
         this.buildTabDefs();
         this.tabIdx = lastTab < this.tabDefs.length ? int(lastTab) : 0;
         this.buildSearch();
         this.buildTabs();
         this.subStrip = new Sprite();
         this.subStrip.x = 14;
         this.subStrip.y = LIST_Y;
         addChild(this.subStrip);
         this.buildList();
         this.buildFooter();
         this.showSubStrip();
         this.layoutList();
         this.drawPills();
         FavStore.addListener(this.onFavChanged);
         this.rebuild();
      }

      private function onFavChanged() : void
      {
         if(!this.closed && this.rootClass != null)
         {
            this.rebuild();
         }
      }

      override public function fClose() : void
      {
         var _loc1_:String = null;
         if(this.closed)
         {
            return;
         }
         this.closed = true;
         FavStore.removeListener(this.onFavChanged);
         if(this.searchTimer != null)
         {
            this.searchTimer.stop();
            this.searchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimer);
            this.searchTimer = null;
         }
         this.removeDragListeners();
         if(this.touchScroll != null)
         {
            this.touchScroll.detach();
            this.touchScroll = null;
         }
         if(this.tabTouch != null)
         {
            this.tabTouch.detach();
            this.tabTouch = null;
         }
         this.unhookStageInput();
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHook);
         if(stage != null && this.tfSearch != null && stage.focus == this.tfSearch)
         {
            stage.focus = null;
         }
         for(_loc1_ in this.activeRows)
         {
            this.destroyRow(this.activeRows[_loc1_]);
         }
         this.activeRows = {};
         while(this.rowPool.length > 0)
         {
            this.destroyRow(this.rowPool.pop());
         }
         if(this.rootClass != null && this.rootClass.ui != null && this.rootClass.ui.ToolTip != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
         this.rootClass = null;
         super.fClose();
      }

      override public function notify(param1:Object) : void
      {
         var _loc1_:Object = null;
         if(Boolean(this.closed) || this.rootClass == null)
         {
            return;
         }
         switch(String(param1.eventType))
         {
            case "refreshItems":
               if(param1.fData != null && param1.fData.iSel == null && param1.fData.eSel == null)
               {
                  this.selItem = null;
               }
               this.rebuild();
               break;
            case "refreshInv":
               this.rebuild();
               break;
            case "listItemASel":
               _loc1_ = param1.fData != null ? param1.fData.oSel || param1.fData.iSel || param1.fData.eSel : null;
               if(_loc1_ != null)
               {
                  this.selItem = _loc1_;
               }
               this.refreshActiveRows();
               break;
            case "refreshCoins":
               this.drawPills();
               break;
            case "refreshSlots":
               this.drawSlots();
         }
      }

      private function buildFormats() : void
      {
         this.fmtTabName = MailArt.fmt(11,12303291,false);
         this.fmtTabNameSel = MailArt.fmt(11,16777215,true);
         this.fmtTabCountSel = MailArt.fmt(11,14725888,true);
         this.fmtWhiteB12 = MailArt.fmt(12,16777215,true,false);
         this.fmtGoldB12 = MailArt.fmt(12,14725888,true,false);
         this.fmtSlotNum = MailArt.fmt(12,16777215,true);
         this.fmtSlotRed = MailArt.fmt(12,16729156,true);
         this.fmtSlotLabel = MailArt.fmt(12,10066329,false);
      }

      private function buildTabDefs() : void
      {
         this.tabDefs = [{
            "label":"All",
            "filters":INV_SUBFILTERS
         },{
            "label":"Items",
            "filters":INV_SUBFILTERS
         },{
            "label":"Class",
            "filters":INV_SUBFILTERS
         },{
            "label":"Misc",
            "filters":INV_SUBFILTERS
         },{
            "label":"House",
            "filters":HOUSE_SUBFILTERS
         }];
      }

      private function buildSearch() : void
      {
         var _loc1_:int = w - 28;
         this.searchBox = new Sprite();
         this.searchBox.x = 14;
         this.searchBox.y = 40;
         var _loc2_:Graphics = this.searchBox.graphics;
         rrect(_loc2_,0,0,_loc1_,24,6,855309,3815994);
         var _loc3_:Number = _loc1_ - 14;
         var _loc4_:Number = 11;
         _loc2_.lineStyle(2,10066329,1,true);
         _loc2_.drawCircle(_loc3_,_loc4_,5);
         _loc2_.moveTo(_loc3_ + 3.5,_loc4_ + 3.5);
         _loc2_.lineTo(_loc3_ + 6.5,_loc4_ + 6.5);
         this.tfSearch = new TextField();
         this.tfSearch.embedFonts = MailArt.embedded();
         if(this.tfSearch.embedFonts)
         {
            this.tfSearch.antiAliasType = AntiAliasType.ADVANCED;
         }
         this.tfSearch.type = TextFieldType.INPUT;
         this.tfSearch.selectable = true;
         this.tfSearch.mouseEnabled = true;
         this.tfSearch.multiline = false;
         this.tfSearch.wordWrap = false;
         this.tfSearch.maxChars = 40;
         this.tfSearch.restrict = null;
         this.tfSearch.defaultTextFormat = MailArt.fmt(12,16777215);
         this.tfSearch.text = "Wg";
         var _loc5_:Number = this.tfSearch.textHeight + 4;
         this.tfSearch.text = "";
         this.tfSearch.width = _loc1_ - 8 - 26;
         this.tfSearch.height = _loc5_;
         this.tfSearch.x = 8;
         this.tfSearch.y = Math.round((24 - _loc5_) / 2);
         this.tfPlaceholder = LPFElementInvAQRow.makeTF(12,7829367);
         this.tfPlaceholder.text = "Item Name";
         this.tfPlaceholder.x = 8;
         this.tfPlaceholder.y = this.tfSearch.y;
         this.searchBox.addChild(this.tfSearch);
         this.searchBox.addChild(this.tfPlaceholder);
         addChild(this.searchBox);
         this.tfSearch.addEventListener(Event.CHANGE,this.onSearchChange,false,0,true);
         this.tfSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onSearchKey,false,0,true);
         this.tfSearch.addEventListener(KeyboardEvent.KEY_UP,this.onSearchKey,false,0,true);
         this.tfSearch.addEventListener(FocusEvent.FOCUS_IN,this.onSearchFocusIn,false,0,true);
         this.tfSearch.addEventListener(FocusEvent.FOCUS_OUT,this.onSearchFocusOut,false,0,true);
         SearchAssist.attach(this.rootClass,this.searchBox,this.tfSearch,this.tfPlaceholder,_loc1_,24,855309);
         this.searchTimer = new Timer(150,1);
         this.searchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimer);
      }

      private function makeKeyBtn(param1:String) : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         rrect(_loc1_.graphics,0,0,20,22,4,2763306,5592405);
         var _loc2_:TextField = LPFElementInvAQRow.makeTF(11,16777215,true);
         _loc2_.text = param1;
         _loc2_.x = Math.round((20 - _loc2_.width) / 2);
         _loc2_.y = Math.round((22 - _loc2_.height) / 2);
         _loc1_.addChild(_loc2_);
         _loc1_.buttonMode = true;
         _loc1_.mouseChildren = false;
         return _loc1_;
      }

      private function buildTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TextField = null;
         this.btnQ = this.makeKeyBtn("Q");
         this.btnQ.x = 14;
         this.btnQ.y = TAB_Y + 1;
         this.btnE = this.makeKeyBtn("E");
         this.btnE.x = w - 34;
         this.btnE.y = TAB_Y + 1;
         this.stripW = w - 38 - 38;
         this.tabClip = new Sprite();
         this.tabClip.x = 38;
         this.tabClip.y = TAB_Y;
         _loc1_ = 0;
         while(_loc1_ < this.tabDefs.length)
         {
            _loc2_ = new Sprite();
            _loc2_.name = String(_loc1_);
            _loc2_.buttonMode = true;
            _loc2_.mouseChildren = false;
            _loc3_ = LPFElementInvAQRow.makeTF(11,12303291);
            _loc2_.addChild(_loc3_);
            this.tabClip.addChild(_loc2_);
            this.tabSprites.push(_loc2_);
            this.tabLabels.push(_loc3_);
            this.tabW.push(0);
            _loc2_.addEventListener(MouseEvent.CLICK,this.onTabClick,false,0,true);
            _loc1_++;
         }
         this.tabClip.scrollRect = this.tabRect();
         addChild(this.tabClip);
         this.tabTouch = TouchScroll.attach(this.tabClip,this.tabTouchGetPos,this.tabTouchSetPos,this.tabTouchGetMax,true);
         addChild(this.btnQ);
         addChild(this.btnE);
         this.btnQ.addEventListener(MouseEvent.CLICK,this.onQClick,false,0,true);
         this.btnE.addEventListener(MouseEvent.CLICK,this.onEClick,false,0,true);
      }

      private function buildList() : void
      {
         this.listArea = new Sprite();
         this.listArea.y = LIST_Y;
         this.listBg = new Shape();
         this.listBorder = new Shape();
         this.listHolder = new Sprite();
         this.sbTrack = new Sprite();
         this.sbThumb = new Sprite();
         this.sbTrack.addChild(this.sbThumb);
         this.tfEmpty = LPFElementInvAQRow.makeTF(12,7829367);
         this.tfEmpty.visible = false;
         this.listArea.addChild(this.listBg);
         this.listArea.addChild(this.listHolder);
         this.listArea.addChild(this.listBorder);
         this.listArea.addChild(this.sbTrack);
         this.listArea.addChild(this.tfEmpty);
         addChild(this.listArea);
         if(stage != null)
         {
            this.hookStageInput();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedHook,false,0,true);
         }
         this.touchScroll = TouchScroll.attach(this.listHolder,this.touchGetPos,this.touchSetPos,this.touchGetMax);
         this.sbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown,false,0,true);
      }

      private function buildFooter() : void
      {
         var goldIconCls:Class;
         var coinsIconCls:Class;
         var g:Graphics = null;
         var tf:TextField = null;
         this.goldPill = new Sprite();
         this.goldPill.x = 14;
         this.goldPill.y = 440;
         rrectRow(this.goldPill.graphics,0,0,this.halfPillW,26,13,3815994);
         goldIconCls = getGoldIconClass();
         if(goldIconCls != null)
         {
            try
            {
               this.goldIcon = new goldIconCls() as DisplayObject;
            }
            catch(e:Error)
            {
               goldIcon = null;
            }
            if(this.goldIcon != null)
            {
               this.goldCR = this.fitByContent(this.goldIcon,20);
               this.goldPill.addChild(this.goldIcon);
            }
         }
         this.tfGold = LPFElementInvAQRow.makeTF(12,16777215,true);
         this.goldPill.addChild(this.tfGold);
         addChild(this.goldPill);
         this.acPill = new Sprite();
         this.acPill.x = 20 + this.halfPillW;
         this.acPill.y = 440;
         rrectRow(this.acPill.graphics,0,0,this.halfPillW,26,13,3815994);
         coinsIconCls = getCoinsIconClass();
         if(coinsIconCls != null)
         {
            try
            {
               this.coinsIcon = new coinsIconCls() as DisplayObject;
            }
            catch(e:Error)
            {
               coinsIcon = null;
            }
            if(this.coinsIcon != null)
            {
               this.coinsCR = this.fitByContent(this.coinsIcon,16);
               this.acPill.addChild(this.coinsIcon);
            }
         }
         this.tfCoins = LPFElementInvAQRow.makeTF(12,16777215,true);
         this.acPill.addChild(this.tfCoins);
         addChild(this.acPill);
         this.btnPlus = new Sprite();
         g = this.btnPlus.graphics;
         g.lineStyle(1,12303291,1,true);
         g.beginFill(2763306);
         g.drawCircle(10,10,10);
         g.endFill();
         tf = LPFElementInvAQRow.makeTF(14,16777215,true);
         tf.text = "+";
         tf.x = Math.round((20 - tf.width) / 2);
         tf.y = Math.round((20 - tf.height) / 2);
         this.btnPlus.addChild(tf);
         this.btnPlus.buttonMode = true;
         this.btnPlus.mouseChildren = false;
         this.btnPlus.addEventListener(MouseEvent.CLICK,this.onPlusClick,false,0,true);
         addChild(this.btnPlus);
         this.tfSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         addChild(this.tfSlots);
      }

      private function getObjData() : Object
      {
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return null;
         }
         return this.rootClass.world.myAvatar.objData;
      }

      private function drawPills() : void
      {
         var _loc1_:Object = this.getObjData();
         if(_loc1_ == null)
         {
            return;
         }
         LPFElementInvAQRow.setRuns(this.tfGold,this.rootClass.strNumWithCommas(int(_loc1_.intGold)),this.fmtWhiteB12,"g",this.fmtGoldB12);
         this.positionPillContent(this.goldIcon,this.goldCR,this.tfGold,this.halfPillW);
         this.tfCoins.text = this.rootClass.strNumWithCommas(int(_loc1_.intCoins));
         this.positionPillContent(this.coinsIcon,this.coinsCR,this.tfCoins,this.halfPillW);
      }

      private function fitByContent(param1:DisplayObject, param2:Number) : Rectangle
      {
         var _loc1_:BitmapData = null;
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = param1.getBounds(param1);
         var _loc4_:Rectangle = _loc3_.clone();
         if(_loc3_.width >= 1 && _loc3_.height >= 1 && _loc3_.width < 2000 && _loc3_.height < 2000)
         {
            _loc1_ = new BitmapData(Math.ceil(_loc3_.width) + 2,Math.ceil(_loc3_.height) + 2,true,0);
            try
            {
               _loc1_.draw(param1,new Matrix(1,0,0,1,1 - _loc3_.x,1 - _loc3_.y));
               _loc1_.threshold(_loc1_,_loc1_.rect,new Point(0,0),"<",2147483648,0,4278190080,true);
               _loc2_ = _loc1_.getColorBoundsRect(4278190080,0,false);
               if(_loc2_.width > 0 && _loc2_.height > 0)
               {
                  _loc4_ = new Rectangle(_loc2_.x + _loc3_.x - 1,_loc2_.y + _loc3_.y - 1,_loc2_.width,_loc2_.height);
               }
            }
            catch(e:Error)
            {
            }
            _loc1_.dispose();
         }
         var _loc5_:Number = _loc4_.height > 0 ? param2 / _loc4_.height : 1;
         if(_loc4_.width * _loc5_ > param2 * 1.6)
         {
            _loc5_ = param2 * 1.6 / _loc4_.width;
         }
         param1.scaleX = param1.scaleY = _loc5_;
         return _loc4_;
      }

      private function get halfPillW() : int
      {
         return int((w - 34) / 2);
      }

      private function positionPillContent(param1:DisplayObject, param2:Rectangle, param3:TextField, param4:int) : void
      {
         var _loc1_:Number = 6;
         var _loc2_:Number = param1 != null && param2 != null ? param2.width * param1.scaleX : 0;
         param3.scaleX = param3.scaleY = 1;
         var _loc3_:Number = param4 - 16 - _loc2_ - (param1 != null ? _loc1_ : 0);
         if(param3.width > _loc3_ && param3.width > 0)
         {
            param3.scaleX = param3.scaleY = Math.max(0.7,_loc3_ / param3.width);
         }
         var _loc4_:Number = _loc2_ + (param1 != null ? _loc1_ : 0) + param3.width;
         var _loc5_:Number = Math.round((param4 - _loc4_) / 2);
         if(param1 != null)
         {
            param1.x = Math.round(_loc5_ - param2.x * param1.scaleX);
            param1.y = Math.round(13 - (param2.y + param2.height / 2) * param1.scaleY);
            param3.x = Math.round(_loc5_ + _loc2_ + _loc1_);
         }
         else
         {
            param3.x = _loc5_;
         }
         param3.y = Math.round((26 - param3.height) / 2);
      }

      private function drawSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Object = this.getObjData();
         var _loc6_:int = 0;
         var _loc7_:Boolean = true;
         switch(this.tabIdx)
         {
            case TAB_ALL:
            case TAB_ITEMS:
               _loc1_ = int(this.tabCounts[TAB_ITEMS]);
               _loc6_ = _loc5_ != null ? int(_loc5_.iBagSlots) : 0;
               _loc2_ = " Item spaces";
               break;
            case TAB_MISC:
               _loc1_ = int(this.tabCounts[TAB_MISC]);
               _loc6_ = _loc5_ != null ? int(_loc5_.iBagSlots) : 0;
               _loc2_ = " Misc spaces";
               break;
            case TAB_CLASS:
               _loc1_ = int(this.tabCounts[TAB_CLASS]);
               _loc7_ = false;
               _loc2_ = " Classes";
               break;
            default:
               _loc1_ = int(this.tabCounts[TAB_HOUSE]);
               _loc6_ = _loc5_ != null ? int(_loc5_.iHouseSlots) : 0;
               _loc2_ = " House spaces";
         }
         var _loc8_:String = _loc7_ ? _loc1_ + " / " + _loc6_ : String(_loc1_);
         LPFElementInvAQRow.setRuns(this.tfSlots,_loc8_,_loc7_ && _loc1_ >= _loc6_ ? this.fmtSlotRed : this.fmtSlotNum,_loc2_,this.fmtSlotLabel);
         var _loc9_:Boolean = this.tabIdx == TAB_ALL || this.tabIdx == TAB_ITEMS;
         this.btnPlus.visible = _loc9_;
         var _loc10_:Number = this.goldPill.y + 26;
         var _loc11_:Number = h - 6;
         var _loc12_:Number = Math.round((_loc10_ + _loc11_) / 2);
         var _loc13_:Number = 8;
         if(_loc9_)
         {
            _loc3_ = 20 + _loc13_ + this.tfSlots.width;
            _loc4_ = Math.round((w - _loc3_) / 2);
            this.btnPlus.x = _loc4_;
            this.btnPlus.y = _loc12_ - 10;
            this.tfSlots.x = _loc4_ + 20 + _loc13_;
         }
         else
         {
            this.tfSlots.x = Math.round((w - this.tfSlots.width) / 2);
         }
         this.tfSlots.y = Math.round(_loc12_ - this.tfSlots.height / 2);
      }

      private function drawTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TextField = null;
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         var _loc6_:Graphics = null;
         var _loc7_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.tabSprites.length)
         {
            _loc2_ = this.tabSprites[_loc1_];
            _loc3_ = this.tabLabels[_loc1_];
            _loc4_ = _loc1_ == this.tabIdx;
            LPFElementInvAQRow.setRuns(_loc3_,this.tabDefs[_loc1_].label,_loc4_ ? this.fmtTabNameSel : this.fmtTabName," (" + this.tabCounts[_loc1_] + ")",_loc4_ ? this.fmtTabCountSel : this.fmtTabName);
            _loc5_ = int(_loc3_.textWidth) + 16;
            _loc6_ = _loc2_.graphics;
            _loc6_.clear();
            mtx.createGradientBox(_loc5_,TAB_H,Math.PI / 2,0,0);
            _loc6_.beginGradientFill(GradientType.LINEAR,_loc4_ ? [7030051,3021836] : [1776411,986895],[1,1],[0,255],mtx);
            _loc6_.moveTo(0,TAB_H);
            _loc6_.lineTo(0,5);
            _loc6_.curveTo(0,0,5,0);
            _loc6_.lineTo(_loc5_ - 5,0);
            _loc6_.curveTo(_loc5_,0,_loc5_,5);
            _loc6_.lineTo(_loc5_,TAB_H);
            _loc6_.lineTo(0,TAB_H);
            _loc6_.endFill();
            _loc6_.lineStyle(1,_loc4_ ? 13145646 : 4473924,1,true);
            _loc6_.moveTo(0.5,TAB_H);
            _loc6_.lineTo(0.5,5);
            _loc6_.curveTo(0.5,0.5,5,0.5);
            _loc6_.lineTo(_loc5_ - 5,0.5);
            _loc6_.curveTo(_loc5_ - 0.5,0.5,_loc5_ - 0.5,5);
            _loc6_.lineTo(_loc5_ - 0.5,TAB_H);
            _loc3_.x = Math.round((_loc5_ - _loc3_.width) / 2);
            _loc3_.y = Math.round((TAB_H - _loc3_.height) / 2);
            _loc2_.x = _loc7_;
            if(Mobile.active)
            {
               TouchTargets.pad(_loc2_,_loc5_ + 2,Mobile.touchPx(9),new Rectangle(_loc7_ - 1,-TAB_PAD,_loc5_ + 2,TAB_H + TAB_PAD * 2));
            }
            else
            {
               TouchTargets.unpad(_loc2_);
            }
            this.tabW[_loc1_] = _loc5_;
            _loc7_ += _loc5_ + 3;
            _loc1_++;
         }
         this.tabTotalW = _loc7_ - 3;
         this.ensureTabVisible();
      }

      private function ensureTabVisible() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = int(this.tabSprites[this.tabIdx].x);
         var _loc3_:int = int(this.tabW[this.tabIdx]);
         if(_loc2_ < this.tabScroll)
         {
            this.tabScroll = _loc2_;
         }
         if(_loc2_ + _loc3_ > this.tabScroll + this.stripW)
         {
            _loc1_ = 0;
            while(_loc1_ <= this.tabIdx)
            {
               if(int(this.tabSprites[_loc1_].x) >= _loc2_ + _loc3_ - this.stripW)
               {
                  this.tabScroll = int(this.tabSprites[_loc1_].x);
                  break;
               }
               _loc1_++;
            }
         }
         if(this.tabTotalW <= this.stripW || this.tabScroll < 0)
         {
            this.tabScroll = 0;
         }
         this.tabClip.scrollRect = this.tabRect();
      }

      private function tabRect() : Rectangle
      {
         var _loc1_:int = Mobile.active ? int(TAB_PAD) : 0;
         return new Rectangle(this.tabScroll,-_loc1_,this.stripW,TAB_H + _loc1_ * 2);
      }

      private function tabTouchGetPos() : Number
      {
         return this.tabScroll;
      }

      private function tabTouchSetPos(param1:Number) : void
      {
         this.tabScroll = int(param1);
         this.tabClip.scrollRect = this.tabRect();
      }

      private function tabTouchGetMax() : Number
      {
         return Math.max(0,this.tabTotalW - this.stripW);
      }

      private function selectTab(param1:int) : void
      {
         this.tabIdx = lastTab = param1;
         this.subIdx = 0;
         this.scrollY = 0;
         this.showSubStrip();
         this.layoutList();
         this.rebuild();
      }

      private function onTabClick(param1:MouseEvent) : void
      {
         this.selectTab(int(DisplayObject(param1.currentTarget).name));
      }

      private function hookStageInput() : void
      {
         if(this.wheelStage != null || stage == null)
         {
            return;
         }
         this.wheelStage = stage;
         this.wheelStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true,0,true);
         this.wheelStage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,true,100,true);
         this.wheelStage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,false,100,true);
         this.wheelStage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,true,100,true);
         this.wheelStage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,false,100,true);
      }

      private function unhookStageInput() : void
      {
         if(this.wheelStage == null)
         {
            return;
         }
         this.wheelStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true);
         this.wheelStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,true);
         this.wheelStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,false);
         this.wheelStage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,true);
         this.wheelStage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,false);
         this.wheelStage = null;
      }

      private function onStageWheel(param1:MouseEvent) : void
      {
         if(Boolean(this.closed) || this.wheelStage == null || this.listArea == null || !visible)
         {
            return;
         }
         if(this.listArea.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            this.onWheel(param1);
         }
      }

      private function onAddedHook(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHook);
         this.hookStageInput();
      }

      private function isTypingFocus() : Boolean
      {
         var _loc1_:Object = this.wheelStage != null ? this.wheelStage.focus : null;
         return _loc1_ is TextField && TextField(_loc1_).type == TextFieldType.INPUT;
      }

      private function onStageKey(param1:KeyboardEvent) : void
      {
         if(Boolean(this.closed) || !visible || Boolean(this.isTypingFocus()))
         {
            return;
         }
         if(param1.keyCode == 81)
         {
            param1.stopImmediatePropagation();
            this.selectTab((this.tabIdx + this.tabDefs.length - 1) % this.tabDefs.length);
         }
         else if(param1.keyCode == 69)
         {
            param1.stopImmediatePropagation();
            this.selectTab((this.tabIdx + 1) % this.tabDefs.length);
         }
      }

      private function onStageKeyUp(param1:KeyboardEvent) : void
      {
         if(Boolean(this.closed) || !visible || Boolean(this.isTypingFocus()))
         {
            return;
         }
         if(param1.keyCode == 81 || param1.keyCode == 69)
         {
            param1.stopImmediatePropagation();
         }
      }

      private function onQClick(param1:MouseEvent) : void
      {
         this.selectTab((this.tabIdx + this.tabDefs.length - 1) % this.tabDefs.length);
      }

      private function onEClick(param1:MouseEvent) : void
      {
         this.selectTab((this.tabIdx + 1) % this.tabDefs.length);
      }

      private function showSubStrip() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < this.subSets.length)
         {
            if(this.subSets[_loc1_] != null)
            {
               Sprite(this.subSets[_loc1_]).visible = false;
            }
            _loc1_++;
         }
         this.subStrip.visible = true;
         if(this.subSets[this.tabIdx] == null)
         {
            this.buildSubSet(this.tabIdx);
         }
         Sprite(this.subSets[this.tabIdx]).visible = true;
      }

      private function buildSubSet(param1:int) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Array = [];
         var _loc5_:Array = this.tabDefs[param1].filters;
         var _loc6_:int = int(this.subPitch(_loc5_));
         _loc1_ = 0;
         while(_loc1_ < _loc5_.length)
         {
            _loc2_ = new Sprite();
            _loc2_.name = String(_loc1_);
            _loc2_.y = _loc1_ * _loc6_;
            _loc2_.buttonMode = true;
            _loc2_.mouseChildren = false;
            this.addSubIcon(_loc2_,_loc5_[_loc1_].icon,this.subSize(_loc5_) / 2);
            _loc2_.addEventListener(MouseEvent.CLICK,this.onSubClick,false,0,true);
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onSubOver,false,0,true);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onSubOut,false,0,true);
            _loc3_.addChild(_loc2_);
            _loc4_.push(_loc2_);
            _loc1_++;
         }
         this.subStrip.addChild(_loc3_);
         this.subSets[param1] = _loc3_;
         this.subBtns[param1] = _loc4_;
      }

      private function subPitch(param1:Array) : int
      {
         return param1.length > 10 ? 30 : 33;
      }

      private function subSize(param1:Array) : int
      {
         return param1.length > 10 ? 28 : 30;
      }

      private function addSubIcon(param1:Sprite, param2:String, param3:Number) : void
      {
         var c:Class;
         var star:Shape = null;
         var d:DisplayObject = null;
         var bw:Number = NaN;
         var bh:Number = NaN;
         var th:Number = NaN;
         var s:Number = NaN;
         var b:Sprite = param1;
         var link:String = param2;
         var mid:Number = param3;
         if(link == "favstar")
         {
            star = FavStore.starShape(18);
            b.addChild(star);
            LPFElementInvAQRow.centerAt(star,mid,mid);
            return;
         }
         c = this.rootClass.world.getClass(link);
         if(c == null)
         {
            return;
         }
         try
         {
            d = new c() as DisplayObject;
            if(d == null)
            {
               return;
            }
            b.addChild(d);
            bw = d.width;
            bh = d.height;
            if(bh > 0)
            {
               th = link == "iCheck" ? 16 : 20;
               s = th / bh;
               if(bw * s > 26)
               {
                  s = 26 / bw;
               }
               d.scaleX = d.scaleY = s;
            }
            LPFElementInvAQRow.centerAt(d,mid,mid);
         }
         catch(e:Error)
         {
            while(b.numChildren > 0)
            {
               b.removeChildAt(0);
            }
         }
      }

      private function drawSubStates() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Graphics = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Sprite = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:Array = this.subBtns[this.tabIdx];
         if(_loc7_ == null)
         {
            return;
         }
         var _loc8_:int = int(this.subPitch(this.tabDefs[this.tabIdx].filters));
         var _loc9_:int = int(this.subSize(this.tabDefs[this.tabIdx].filters));
         _loc1_ = 0;
         while(_loc1_ < _loc7_.length)
         {
            _loc5_ = _loc7_[_loc1_];
            _loc3_ = _loc1_ == this.subIdx;
            _loc4_ = _loc1_ < this.subEnabled.length ? Boolean(this.subEnabled[_loc1_]) : true;
            _loc2_ = _loc5_.graphics;
            _loc2_.clear();
            if(_loc3_)
            {
               rrect(_loc2_,0,0,_loc9_,_loc9_,5,4862488,13145646);
            }
            else
            {
               rrectRow(_loc2_,0,0,_loc9_,_loc9_,5,3815994);
            }
            _loc5_.buttonMode = _loc4_;
            if(Mobile.active)
            {
               TouchTargets.pad(_loc5_,40,_loc8_,new Rectangle(-6,_loc1_ * _loc8_ - 1,40,_loc8_));
            }
            else
            {
               TouchTargets.unpad(_loc5_);
            }
            _loc6_ = _loc5_.numChildren > 0 ? DisplayObject(_loc5_.getChildAt(0)) : null;
            if(_loc6_ != null)
            {
               _loc6_.alpha = _loc4_ ? 1 : 0.3;
            }
            _loc1_++;
         }
      }

      private function onSubClick(param1:MouseEvent) : void
      {
         var _loc1_:int = int(DisplayObject(param1.currentTarget).name);
         if(_loc1_ == this.subIdx)
         {
            return;
         }
         if(_loc1_ < this.subEnabled.length && !this.subEnabled[_loc1_])
         {
            return;
         }
         this.subIdx = _loc1_;
         this.scrollY = 0;
         this.rebuild();
      }

      private function onSubOver(param1:MouseEvent) : void
      {
         var _loc1_:Object = this.tabDefs[this.tabIdx].filters[int(DisplayObject(param1.currentTarget).name)];
         if(_loc1_ != null && this.rootClass != null)
         {
            this.rootClass.ui.ToolTip.openWith({"str":_loc1_.label});
         }
      }

      private function onSubOut(param1:MouseEvent) : void
      {
         if(this.rootClass != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
      }

      private function layoutList() : void
      {
         this.listX = 50;
         this.listW = w - 14 - this.listX;
         this.rowW = this.listW - 10;
         this.listArea.x = this.listX;
         var _loc1_:Graphics = this.listBg.graphics;
         _loc1_.clear();
         _loc1_.beginFill(657930);
         _loc1_.drawRoundRect(0,0,this.listW,LIST_H,8,8);
         _loc1_.endFill();
         _loc1_ = this.listBorder.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,2763306,1,true);
         _loc1_.drawRoundRect(0,0,this.listW,LIST_H,8,8);
         this.sbTrack.x = this.listW - 10;
         this.sbTrack.y = 2;
         _loc1_ = this.sbTrack.graphics;
         _loc1_.clear();
         _loc1_.beginFill(1710618);
         _loc1_.drawRoundRect(0,0,8,LIST_H - 4,8,8);
         _loc1_.endFill();
      }

      private function markSubEnabled(param1:Array, param2:Array, param3:Object, param4:Boolean) : void
      {
         var _loc1_:int = 0;
         _loc1_ = 1;
         while(_loc1_ < param1.length)
         {
            if(!param2[_loc1_] && Boolean(subFilterMatches(param1[_loc1_],param3,param4)))
            {
               param2[_loc1_] = true;
            }
            _loc1_++;
         }
      }

      private function poolContains(param1:int, param2:Boolean, param3:Boolean, param4:Boolean, param5:Object) : Boolean
      {
         switch(param1)
         {
            case TAB_ALL:
               return true;
            case TAB_ITEMS:
               return param4;
            case TAB_MISC:
               return param3;
            case TAB_CLASS:
               return param2;
            default:
               return false;
         }
      }

      private function rebuild() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Boolean = false;
         var _loc6_:Boolean = false;
         var _loc7_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:* = 0;
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return;
         }
         if(sortRank == null)
         {
            sortRank = {};
            _loc7_ = 0;
            while(_loc7_ < SORT_ORDER.length)
            {
               sortRank[SORT_ORDER[_loc7_]] = _loc7_;
               _loc7_++;
            }
         }
         var _loc10_:Object = this.rootClass.world.myAvatar;
         var _loc11_:Array = _loc10_.items != null ? _loc10_.items : EMPTY;
         var _loc12_:Array = _loc10_.houseitems != null ? _loc10_.houseitems : EMPTY;
         var _loc13_:Array = this.tabDefs[this.tabIdx].filters;
         var _loc14_:Boolean = this.tabIdx == TAB_HOUSE;
         var _loc15_:int = int(_loc13_.length);
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:Boolean = false;
         this.subEnabled = [];
         _loc1_ = 0;
         while(_loc1_ < _loc15_)
         {
            this.subEnabled.push(_loc1_ == 0);
            _loc1_++;
         }
         for each(_loc2_ in _loc11_)
         {
            if(_loc2_ != null)
            {
               if(_loc2_ === this.selItem)
               {
                  _loc19_ = true;
               }
               _loc3_ = InvCat.isClass(_loc2_);
               _loc4_ = !_loc3_ && InvCat.isMisc(_loc2_);
               _loc5_ = !_loc3_ && !_loc4_ && !InvCat.isHouse(_loc2_);
               if(_loc3_)
               {
                  _loc18_++;
               }
               else if(_loc4_)
               {
                  _loc17_++;
               }
               else if(_loc5_)
               {
                  _loc16_++;
               }
               if(this.poolContains(this.tabIdx,_loc3_,_loc4_,_loc5_,_loc2_))
               {
                  this.markSubEnabled(_loc13_,this.subEnabled,_loc2_,false);
               }
            }
         }
         for each(_loc2_ in _loc12_)
         {
            if(_loc2_ != null)
            {
               if(_loc2_ === this.selItem)
               {
                  _loc19_ = true;
               }
               if(this.tabIdx == TAB_ALL || this.tabIdx == TAB_HOUSE)
               {
                  this.markSubEnabled(_loc13_,this.subEnabled,_loc2_,_loc14_);
               }
            }
         }
         if(!_loc19_)
         {
            this.selItem = null;
         }
         this.tabCounts[TAB_ALL] = _loc11_.length + _loc12_.length;
         this.tabCounts[TAB_ITEMS] = _loc16_;
         this.tabCounts[TAB_MISC] = _loc17_;
         this.tabCounts[TAB_CLASS] = _loc18_;
         this.tabCounts[TAB_HOUSE] = _loc12_.length;
         if(_loc15_ > 0 && this.subIdx < _loc15_ && !this.subEnabled[this.subIdx])
         {
            this.subIdx = 0;
         }
         var _loc20_:Object = _loc15_ > 0 ? _loc13_[this.subIdx] : null;
         var _loc21_:String = this.searchQ.toLowerCase();
         var _loc22_:Boolean = _loc21_.length > 0;
         this.view = [];
         for each(_loc2_ in _loc11_)
         {
            if(_loc2_ != null)
            {
               _loc3_ = InvCat.isClass(_loc2_);
               _loc4_ = !_loc3_ && InvCat.isMisc(_loc2_);
               _loc5_ = !_loc3_ && !_loc4_ && !InvCat.isHouse(_loc2_);
               _loc6_ = Boolean(this.poolContains(this.tabIdx,_loc3_,_loc4_,_loc5_,_loc2_));
               if((_loc6_) && Boolean(subFilterMatches(_loc20_,_loc2_,false)) && (!_loc22_ || String(_loc2_.sName).toLowerCase().indexOf(_loc21_) > -1))
               {
                  this.view.push(_loc2_);
               }
            }
         }
         for each(_loc2_ in _loc12_)
         {
            if(_loc2_ != null)
            {
               if((this.tabIdx == TAB_ALL || this.tabIdx == TAB_HOUSE) && Boolean(subFilterMatches(_loc20_,_loc2_,_loc14_)) && (!_loc22_ || String(_loc2_.sName).toLowerCase().indexOf(_loc21_) > -1))
               {
                  this.view.push(_loc2_);
               }
            }
         }
         this.view.sort(compareItems);
         if(FavStore.count > 0)
         {
            _loc8_ = [];
            _loc9_ = 0;
            for each(_loc2_ in this.view)
            {
               if(FavStore.has(_loc2_.ItemID))
               {
                  var _loc23_:Number;
                  this.view[_loc23_ = _loc9_++] = _loc2_;
               }
               else
               {
                  _loc8_.push(_loc2_);
               }
            }
            for each(_loc2_ in _loc8_)
            {
               this.view[_loc23_ = _loc9_++] = _loc2_;
            }
         }
         this.drawTabs();
         this.drawSlots();
         this.drawSubStates();
         this.updateEmpty();
         this.layoutRows(true);
      }

      private function updateEmpty() : void
      {
         if(this.view.length == 0)
         {
            this.tfEmpty.text = this.searchQ.length > 0 ? "No results for \"" + this.searchQ + "\"" : "No items";
            this.tfEmpty.x = Math.round((this.listW - this.tfEmpty.width) / 2);
            this.tfEmpty.y = Math.round((LIST_H - this.tfEmpty.height) / 2);
            this.tfEmpty.visible = true;
         }
         else
         {
            this.tfEmpty.visible = false;
         }
      }

      private function isEquipped(param1:Object) : Boolean
      {
         return param1 != null && (param1.bEquip == 1 || param1.bWear == 1);
      }

      private function acquireRow() : LPFElementInvAQRow
      {
         if(this.rowPool.length > 0)
         {
            return this.rowPool.pop();
         }
         var _loc1_:LPFElementInvAQRow = new LPFElementInvAQRow();
         _loc1_.addEventListener(MouseEvent.CLICK,this.onRowClick,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.onRowOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.onRowOut,false,0,true);
         return _loc1_;
      }

      private function releaseRow(param1:LPFElementInvAQRow) : void
      {
         param1.setHover(false);
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         if(this.rowPool.length < POOL_MAX)
         {
            this.rowPool.push(param1);
         }
         else
         {
            this.destroyRow(param1);
         }
      }

      private function destroyRow(param1:LPFElementInvAQRow) : void
      {
         if(param1 == null)
         {
            return;
         }
         param1.removeEventListener(MouseEvent.CLICK,this.onRowClick);
         param1.removeEventListener(MouseEvent.ROLL_OVER,this.onRowOver);
         param1.removeEventListener(MouseEvent.ROLL_OUT,this.onRowOut);
         param1.destroy();
      }

      private function layoutRows(param1:Boolean = false) : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:LPFElementInvAQRow = null;
         var _loc4_:Object = null;
         var _loc5_:int = int(this.view.length);
         var _loc6_:int = _loc5_ * ROW_H > LIST_H ? int(this.listW - 12) : int(this.listW - 2);
         if(_loc6_ != this.rowW)
         {
            this.rowW = _loc6_;
            param1 = true;
         }
         var _loc7_:int = _loc5_ * ROW_H - LIST_H;
         if(_loc7_ < 0)
         {
            _loc7_ = 0;
         }
         if(this.scrollY > _loc7_)
         {
            this.scrollY = _loc7_;
         }
         if(this.scrollY < 0)
         {
            this.scrollY = 0;
         }
         this.scrollRectR.x = 0;
         this.scrollRectR.y = this.scrollY;
         this.scrollRectR.width = this.rowW;
         this.scrollRectR.height = LIST_H;
         this.listHolder.scrollRect = this.scrollRectR;
         var _loc8_:int = int(this.scrollY / ROW_H);
         var _loc9_:int = int((this.scrollY + LIST_H - 1) / ROW_H);
         if(_loc9_ > _loc5_ - 1)
         {
            _loc9_ = _loc5_ - 1;
         }
         this.tmpKeys.length = 0;
         for(_loc1_ in this.activeRows)
         {
            _loc2_ = int(_loc1_);
            if(_loc2_ < _loc8_ || _loc2_ > _loc9_)
            {
               this.tmpKeys.push(_loc2_);
            }
         }
         for each(_loc2_ in this.tmpKeys)
         {
            this.releaseRow(this.activeRows[_loc2_]);
            delete this.activeRows[_loc2_];
         }
         _loc2_ = _loc8_;
         while(_loc2_ <= _loc9_)
         {
            _loc4_ = this.view[_loc2_];
            _loc3_ = this.activeRows[_loc2_];
            if(_loc3_ == null)
            {
               _loc3_ = this.acquireRow();
               this.activeRows[_loc2_] = _loc3_;
               _loc3_.rowW = this.rowW;
               _loc3_.bind(_loc4_,this.rootClass,_loc4_ === this.selItem,this.isEquipped(_loc4_));
               _loc3_.y = _loc2_ * ROW_H;
               this.listHolder.addChild(_loc3_);
            }
            else if(param1)
            {
               _loc3_.rowW = this.rowW;
               _loc3_.bind(_loc4_,this.rootClass,_loc4_ === this.selItem,this.isEquipped(_loc4_));
            }
            _loc2_++;
         }
         this.updateScrollbar();
      }

      private function refreshActiveRows() : void
      {
         var _loc1_:String = null;
         var _loc2_:LPFElementInvAQRow = null;
         for(_loc1_ in this.activeRows)
         {
            _loc2_ = this.activeRows[_loc1_];
            _loc2_.bind(_loc2_.item,this.rootClass,_loc2_.item === this.selItem,this.isEquipped(_loc2_.item));
         }
      }

      private function updateScrollbar() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:Matrix = null;
         var _loc3_:int = this.view.length * ROW_H;
         if(_loc3_ <= LIST_H)
         {
            this.sbTrack.visible = false;
            return;
         }
         this.sbTrack.visible = true;
         var _loc4_:int = LIST_H - 4;
         var _loc5_:int = int(LIST_H * LIST_H / _loc3_);
         if(_loc5_ < 24)
         {
            _loc5_ = 24;
         }
         if(_loc5_ > _loc4_)
         {
            _loc5_ = _loc4_;
         }
         if(_loc5_ != this.thumbH)
         {
            this.thumbH = _loc5_;
            _loc1_ = this.sbThumb.graphics;
            _loc2_ = new Matrix();
            _loc2_.createGradientBox(8,this.thumbH,0,0,0);
            _loc1_.clear();
            _loc1_.lineStyle(1,13145646,1,true);
            _loc1_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc2_);
            _loc1_.drawRoundRect(0,0,8,this.thumbH,8,8);
            _loc1_.endFill();
         }
         this.sbThumb.y = int((_loc4_ - this.thumbH) * this.scrollY / (_loc3_ - LIST_H));
      }

      private function touchGetPos() : Number
      {
         return this.scrollY;
      }

      private function touchSetPos(param1:Number) : void
      {
         this.scrollY = int(param1);
         this.layoutRows();
      }

      private function touchGetMax() : Number
      {
         return Math.max(0,this.view.length * ROW_H - LIST_H);
      }

      private function onWheel(param1:MouseEvent) : void
      {
         if(this.view.length * ROW_H <= LIST_H)
         {
            return;
         }
         this.scrollY -= param1.delta * (ROW_H / 3);
         this.layoutRows();
      }

      private function onTrackDown(param1:MouseEvent) : void
      {
         if(param1.target == this.sbThumb)
         {
            this.removeDragListeners();
            this.dragOff = this.sbTrack.mouseY - this.sbThumb.y;
            this.dragStage = stage;
            if(this.dragStage != null)
            {
               this.dragStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
               this.dragStage.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
            }
         }
         else
         {
            this.scrollY += this.sbTrack.mouseY < this.sbThumb.y ? -LIST_H : LIST_H;
            this.layoutRows();
         }
      }

      private function onDragMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = LIST_H - 4 - this.thumbH;
         var _loc2_:int = this.view.length * ROW_H - LIST_H;
         if(_loc1_ <= 0 || _loc2_ <= 0)
         {
            return;
         }
         var _loc3_:Number = this.sbTrack.mouseY - this.dragOff;
         if(_loc3_ < 0)
         {
            _loc3_ = 0;
         }
         else if(_loc3_ > _loc1_)
         {
            _loc3_ = _loc1_;
         }
         this.scrollY = int(_loc3_ / _loc1_ * _loc2_);
         this.layoutRows();
         param1.updateAfterEvent();
      }

      private function onDragUp(param1:MouseEvent) : void
      {
         this.removeDragListeners();
      }

      private function removeDragListeners() : void
      {
         if(this.dragStage != null)
         {
            this.dragStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
            this.dragStage.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
            this.dragStage = null;
         }
      }

      private function onRowClick(param1:MouseEvent) : void
      {
         var _loc1_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc1_ == null || _loc1_.item == null || this.rootClass == null)
         {
            return;
         }
         if(this.rootClass.isGreedyModalInStack())
         {
            return;
         }
         var _loc2_:Object = _loc1_.item;
         this.selItem = _loc2_;
         update({
            "eventType":"listItemASel",
            "fData":_loc2_
         });
      }

      private function onRowOver(param1:MouseEvent) : void
      {
         var _loc1_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc1_ != null)
         {
            _loc1_.setHover(true);
         }
      }

      private function onRowOut(param1:MouseEvent) : void
      {
         var _loc1_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc1_ != null)
         {
            _loc1_.setHover(false);
         }
      }

      private function updatePlaceholder() : void
      {
         if(Boolean(this.searchFocused) && (stage == null || stage.focus != this.tfSearch))
         {
            this.searchFocused = false;
         }
         this.tfPlaceholder.visible = this.tfSearch.length == 0 && !this.searchFocused;
      }

      private function onSearchChange(param1:Event) : void
      {
         if(this.closed)
         {
            return;
         }
         MailArt.cover(this.tfSearch);
         this.updatePlaceholder();
         this.searchTimer.reset();
         this.searchTimer.start();
      }

      private function onSearchKey(param1:KeyboardEvent) : void
      {
         param1.stopPropagation();
         if(this.closed)
         {
            return;
         }
         if(param1.type == KeyboardEvent.KEY_DOWN && param1.keyCode == Keyboard.ENTER)
         {
            this.searchTimer.reset();
            this.applySearch();
         }
      }

      private function onSearchFocusIn(param1:FocusEvent) : void
      {
         this.searchFocused = true;
         this.updatePlaceholder();
      }

      private function onSearchFocusOut(param1:FocusEvent) : void
      {
         this.searchFocused = false;
         this.updatePlaceholder();
      }

      private function onSearchTimer(param1:TimerEvent) : void
      {
         if(this.closed)
         {
            return;
         }
         this.applySearch();
      }

      private function applySearch() : void
      {
         var _loc1_:String = this.tfSearch.text;
         if(_loc1_ == this.searchQ)
         {
            return;
         }
         this.searchQ = _loc1_;
         this.scrollY = 0;
         this.rebuild();
      }

      private function onPlusClick(param1:MouseEvent) : void
      {
         update({"eventType":"buyBagSlots"});
      }
   }
}
