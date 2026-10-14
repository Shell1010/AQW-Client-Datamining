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

   public class LPFFrameShopAQ extends LPFFrame
   {

      private static const POOL_MAX:int = 16;

      private static const LIST_Y:int = 100;

      private static const TAB_Y:int = 70;

      private static const TAB_H:int = 24;

      private static const UNKNOWN_RANK:int = 10000;

      private static const EMPTY:Array = [];

      private static const SORT_ORDER:Array = ["Note","Resource","Item","Quest Item","ServerUse","Enhancement","Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand","Class","Armor","Helm","Cape","Misc","Earring","Amulet","Necklace","Belt","Ring","Pet"];

      private static const FILTER_MAP:Object = {
         "Weapon":["Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand"],
         "cl":["Class"],
         "ar":["Armor"],
         "he":["Helm"],
         "ba":["Cape"],
         "pe":["Pet"],
         "am":["Misc","Earring","Amulet","Necklace","Belt","Ring"],
         "it":["Note","Resource","Item","Quest Item","ServerUse"],
         "enh":["Enhancement"],
         "houseitems":["House","Wall Item","Floor Item"],
         "pots":["Item"]
      };

      private static var sortRank:Object = null;

      private static var mtx:Matrix = new Matrix();

      private static var goldIconClass:Class = null;

      private static var goldIconClassChecked:Boolean = false;

      private static var coinsIconClass:Class = null;

      private static var coinsIconClassChecked:Boolean = false;

      private static const ROW_FILL_MTX:Matrix = new Matrix();

      private var listH:int = 324;

      private var pillY:int = 432;

      private var rootClass:MovieClip;

      private var closed:Boolean = false;

      private var mode:String = "shopBuy";

      private var filterDefs:Array;

      private var subIdx:int = 0;

      private var subEnabled:Array = [];

      private var searchQ:String = "";

      private var searchFocused:Boolean = false;

      private var searchTimer:Timer;

      private var view:Array = [];

      private var selItem:Object;

      private var scrollY:int = 0;

      private var touchScroll:TouchScroll;

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

      private var tabBuy:Sprite;

      private var tabSell:Sprite;

      private var tfBuy:TextField;

      private var tfSell:TextField;

      private var subStrip:Sprite;

      private var subBtns:Array = [];

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

      private var tfItemSlots:TextField;

      private var tfMiscSlots:TextField;

      private var tfSlotSep:TextField;

      private var fmtTabName:TextFormat;

      private var fmtTabNameSel:TextFormat;

      private var fmtWhiteB12:TextFormat;

      private var fmtGoldB12:TextFormat;

      private var fmtSlotNum:TextFormat;

      private var fmtSlotRed:TextFormat;

      private var fmtSlotLabel:TextFormat;

      private var wheelStage:Stage;

      public function LPFFrameShopAQ()
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
         if(param2 == "*")
         {
            return true;
         }
         var _loc2_:Array = FILTER_MAP[param2] as Array;
         var _loc3_:Boolean = _loc2_ != null && _loc2_.indexOf(param1.sType) > -1 || param1.sType == "Enhancement" && String(param1.sES).indexOf(param2) > -1 || _loc2_ == null && param1.sType == param2;
         if(!_loc3_)
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

      private static function compareItems(param1:Object, param2:Object) : int
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:Number = Number(param1.SortIndex);
         var _loc4_:Number = Number(param2.SortIndex);
         var _loc5_:int = !isNaN(_loc3_) && _loc3_ >= 0 ? int(_loc3_) : -1;
         var _loc6_:int = !isNaN(_loc4_) && _loc4_ >= 0 ? int(_loc4_) : -1;
         if(_loc5_ != _loc6_)
         {
            if(_loc5_ < 0)
            {
               return 1;
            }
            if(_loc6_ < 0)
            {
               return -1;
            }
            return _loc5_ < _loc6_ ? -1 : 1;
         }
         var _loc7_:* = sortRank[param1.sType];
         var _loc8_:* = sortRank[param2.sType];
         var _loc9_:int = _loc7_ == null ? int(UNKNOWN_RANK) : int(_loc7_);
         var _loc10_:int = _loc8_ == null ? int(UNKNOWN_RANK) : int(_loc8_);
         if(_loc9_ != _loc10_)
         {
            return _loc9_ < _loc10_ ? -1 : 1;
         }
         if(_loc9_ == UNKNOWN_RANK)
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
         var _loc11_:int = int(param1.iLvl);
         var _loc12_:int = int(param2.iLvl);
         if(_loc11_ != _loc12_)
         {
            return _loc11_ > _loc12_ ? -1 : 1;
         }
         var _loc13_:int = int(param1.ItemID);
         var _loc14_:int = int(param2.ItemID);
         if(_loc13_ != _loc14_)
         {
            return _loc13_ < _loc14_ ? -1 : 1;
         }
         return 0;
      }

      override public function fOpen(param1:Object) : void
      {
         eventTypes = ["refreshItems","refreshInv","sModeSet","listItemASel","refreshCoins","refreshSlots"];
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
         FavStore.addListener(this.onFavChanged);
         this.mode = String(getLayout().sMode);
         if(this.mode != "shopBuy" && this.mode != "shopSell")
         {
            this.mode = "shopBuy";
         }
         this.buildFormats();
         this.filterDefs = MovieClip(getLayout()).getTabStates();
         this.buildSearch();
         this.setPlaceholderText();
         this.buildModeTabs();
         this.subStrip = new Sprite();
         this.subStrip.x = 14;
         this.subStrip.y = LIST_Y;
         addChild(this.subStrip);
         this.buildSubStrip();
         this.buildList();
         this.buildFooter();
         this.layoutList();
         this.drawPills();
         this.drawFooterSlots();
         this.rebuild();
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
               break;
            case "sModeSet":
               this.onModeChanged(param1);
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
               this.drawFooterSlots();
         }
      }

      private function onModeChanged(param1:Object) : void
      {
         var _loc1_:String = param1.sModeBroadcast != null ? String(param1.sModeBroadcast) : String(getLayout().sMode);
         if(_loc1_ != "shopBuy" && _loc1_ != "shopSell")
         {
            return;
         }
         this.mode = _loc1_;
         this.subIdx = 0;
         this.scrollY = 0;
         this.searchQ = "";
         if(this.tfSearch != null)
         {
            this.tfSearch.text = "";
         }
         this.updatePlaceholder();
         this.setPlaceholderText();
         this.selItem = null;
         this.rebuild();
      }

      private function buildFormats() : void
      {
         this.fmtTabName = new TextFormat("Arial",11,12303291,false);
         this.fmtTabNameSel = new TextFormat("Arial",11,16777215,true);
         this.fmtWhiteB12 = new TextFormat("Arial",12,16777215,true,false);
         this.fmtGoldB12 = new TextFormat("Arial",12,14725888,true,false);
         this.fmtSlotNum = new TextFormat("Arial",12,16777215,true);
         this.fmtSlotRed = new TextFormat("Arial",12,16729156,true);
         this.fmtSlotLabel = new TextFormat("Arial",12,10066329,false);
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
         this.tfSearch.embedFonts = false;
         this.tfSearch.type = TextFieldType.INPUT;
         this.tfSearch.selectable = true;
         this.tfSearch.mouseEnabled = true;
         this.tfSearch.multiline = false;
         this.tfSearch.wordWrap = false;
         this.tfSearch.maxChars = 40;
         this.tfSearch.restrict = null;
         this.tfSearch.defaultTextFormat = new TextFormat("Arial",12,16777215);
         this.tfSearch.text = "Wg";
         var _loc5_:Number = this.tfSearch.textHeight + 4;
         this.tfSearch.text = "";
         this.tfSearch.width = _loc1_ - 8 - 26;
         this.tfSearch.height = _loc5_;
         this.tfSearch.x = 8;
         this.tfSearch.y = Math.round((24 - _loc5_) / 2);
         this.tfPlaceholder = LPFElementInvAQRow.makeTF(12,7829367);
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

      private function setPlaceholderText() : void
      {
         this.tfPlaceholder.text = this.mode == "shopSell" ? "Search inventory" : "Search shop";
      }

      private function buildModeTabs() : void
      {
         this.tabBuy = new Sprite();
         this.tabBuy.name = "shopBuy";
         this.tabBuy.buttonMode = true;
         this.tabBuy.mouseChildren = false;
         this.tfBuy = LPFElementInvAQRow.makeTF(11,12303291);
         this.tabBuy.addChild(this.tfBuy);
         this.tabBuy.addEventListener(MouseEvent.CLICK,this.onModeTabClick,false,0,true);
         addChild(this.tabBuy);
         this.tabSell = new Sprite();
         this.tabSell.name = "shopSell";
         this.tabSell.buttonMode = true;
         this.tabSell.mouseChildren = false;
         this.tfSell = LPFElementInvAQRow.makeTF(11,12303291);
         this.tabSell.addChild(this.tfSell);
         this.tabSell.addEventListener(MouseEvent.CLICK,this.onModeTabClick,false,0,true);
         addChild(this.tabSell);
      }

      private function drawModeTab(param1:Sprite, param2:TextField, param3:Number, param4:Boolean) : void
      {
         var _loc1_:Graphics = param1.graphics;
         _loc1_.clear();
         mtx.createGradientBox(param3,TAB_H,Math.PI / 2,0,0);
         _loc1_.beginGradientFill(GradientType.LINEAR,param4 ? [7030051,3021836] : [1776411,986895],[1,1],[0,255],mtx);
         _loc1_.moveTo(0,TAB_H);
         _loc1_.lineTo(0,5);
         _loc1_.curveTo(0,0,5,0);
         _loc1_.lineTo(param3 - 5,0);
         _loc1_.curveTo(param3,0,param3,5);
         _loc1_.lineTo(param3,TAB_H);
         _loc1_.lineTo(0,TAB_H);
         _loc1_.endFill();
         _loc1_.lineStyle(1,param4 ? 13145646 : 4473924,1,true);
         _loc1_.moveTo(0.5,TAB_H);
         _loc1_.lineTo(0.5,5);
         _loc1_.curveTo(0.5,0.5,5,0.5);
         _loc1_.lineTo(param3 - 5,0.5);
         _loc1_.curveTo(param3 - 0.5,0.5,param3 - 0.5,5);
         _loc1_.lineTo(param3 - 0.5,TAB_H);
         param2.setTextFormat(param4 ? this.fmtTabNameSel : this.fmtTabName);
         param2.x = Math.round((param3 - param2.width) / 2);
         param2.y = Math.round((TAB_H - param2.height) / 2);
      }

      private function drawModeTabs() : void
      {
         var _loc1_:Object = getLayout();
         var _loc2_:Object = this.rootClass != null && this.rootClass.world != null ? this.rootClass.world.myAvatar : null;
         var _loc3_:int = _loc1_.itemsShop != null ? int(_loc1_.itemsShop.length) : 0;
         var _loc4_:Array = _loc2_ != null ? (this.isHouseShop() ? _loc2_.houseitems : _loc2_.items) : null;
         var _loc5_:int = _loc4_ != null ? int(_loc4_.length) : 0;
         this.tfBuy.text = "Buy (" + _loc3_ + ")";
         this.tfSell.text = "Sell (" + _loc5_ + ")";
         var _loc6_:Number = w - 28;
         var _loc7_:Number = 4;
         var _loc8_:Number = (_loc6_ - _loc7_) / 2;
         this.drawModeTab(this.tabBuy,this.tfBuy,_loc8_,this.mode == "shopBuy");
         this.drawModeTab(this.tabSell,this.tfSell,_loc8_,this.mode == "shopSell");
         this.tabBuy.x = 14;
         this.tabBuy.y = TAB_Y;
         this.tabSell.x = 14 + _loc8_ + _loc7_;
         this.tabSell.y = TAB_Y;
      }

      private function onModeTabClick(param1:MouseEvent) : void
      {
         var _loc1_:String = Sprite(param1.currentTarget).name;
         if(_loc1_ == this.mode)
         {
            return;
         }
         update({
            "eventType":"sModeSet",
            "sModeBroadcast":_loc1_
         });
      }

      private function buildSubStrip() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:int = Math.min(33,int((this.listH - 30) / Math.max(1,this.filterDefs.length - 1)));
         _loc1_ = 0;
         while(_loc1_ < this.filterDefs.length)
         {
            _loc2_ = new Sprite();
            _loc2_.name = String(_loc1_);
            _loc2_.y = _loc1_ * _loc3_;
            _loc2_.buttonMode = true;
            _loc2_.mouseChildren = false;
            this.addSubIcon(_loc2_,this.filterDefs[_loc1_].icon);
            _loc2_.addEventListener(MouseEvent.CLICK,this.onSubClick,false,0,true);
            _loc2_.addEventListener(MouseEvent.ROLL_OVER,this.onSubOver,false,0,true);
            _loc2_.addEventListener(MouseEvent.ROLL_OUT,this.onSubOut,false,0,true);
            this.subStrip.addChild(_loc2_);
            this.subBtns.push(_loc2_);
            _loc1_++;
         }
      }

      private function addSubIcon(param1:Sprite, param2:String) : void
      {
         var d:DisplayObject = null;
         var bw:Number = NaN;
         var bh:Number = NaN;
         var s:Number = NaN;
         var b:Sprite = param1;
         var link:String = param2;
         var c:Class = this.rootClass.world.getClass(link);
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
               s = 20 / bh;
               if(bw * s > 26)
               {
                  s = 26 / bw;
               }
               d.scaleX = d.scaleY = s;
            }
            LPFElementInvAQRow.centerAt(d,15,15);
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
         _loc1_ = 0;
         while(_loc1_ < this.subBtns.length)
         {
            _loc5_ = this.subBtns[_loc1_];
            _loc3_ = _loc1_ == this.subIdx;
            _loc4_ = _loc1_ < this.subEnabled.length ? Boolean(this.subEnabled[_loc1_]) : true;
            _loc2_ = _loc5_.graphics;
            _loc2_.clear();
            if(_loc3_)
            {
               rrect(_loc2_,0,0,30,30,5,4862488,13145646);
            }
            else
            {
               rrectRow(_loc2_,0,0,30,30,5,3815994);
            }
            _loc5_.buttonMode = _loc4_;
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
         var _loc1_:Object = this.filterDefs[int(DisplayObject(param1.currentTarget).name)];
         if(_loc1_ != null && this.rootClass != null)
         {
            this.rootClass.ui.ToolTip.openWith({"str":_loc1_.sTag});
         }
      }

      private function onSubOut(param1:MouseEvent) : void
      {
         if(this.rootClass != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
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

      private function layoutList() : void
      {
         this.listX = 50;
         this.listW = w - 14 - this.listX;
         this.rowW = this.listW - 10;
         this.listArea.x = this.listX;
         var _loc1_:Graphics = this.listBg.graphics;
         _loc1_.clear();
         _loc1_.beginFill(657930);
         _loc1_.drawRoundRect(0,0,this.listW,this.listH,8,8);
         _loc1_.endFill();
         _loc1_ = this.listBorder.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,2763306,1,true);
         _loc1_.drawRoundRect(0,0,this.listW,this.listH,8,8);
         this.sbTrack.x = this.listW - 10;
         this.sbTrack.y = 2;
         _loc1_ = this.sbTrack.graphics;
         _loc1_.clear();
         _loc1_.beginFill(1710618);
         _loc1_.drawRoundRect(0,0,8,this.listH - 4,8,8);
         _loc1_.endFill();
      }

      private function buildFooter() : void
      {
         var goldIconCls:Class;
         var coinsIconCls:Class;
         var tfPlus:TextField;
         var g:Graphics = null;
         this.goldPill = new Sprite();
         this.goldPill.x = 14;
         this.goldPill.y = this.pillY;
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
         this.acPill.y = this.pillY;
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
         tfPlus = LPFElementInvAQRow.makeTF(14,16777215,true);
         tfPlus.text = "+";
         tfPlus.x = Math.round((20 - tfPlus.width) / 2);
         tfPlus.y = Math.round((20 - tfPlus.height) / 2);
         this.btnPlus.addChild(tfPlus);
         this.btnPlus.buttonMode = true;
         this.btnPlus.mouseChildren = false;
         this.btnPlus.addEventListener(MouseEvent.CLICK,this.onPlusClick,false,0,true);
         addChild(this.btnPlus);
         this.tfItemSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         addChild(this.tfItemSlots);
         this.tfMiscSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         addChild(this.tfMiscSlots);
         this.tfSlotSep = LPFListFooter.makeSeparator();
         addChild(this.tfSlotSep);
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

      private function drawFooterSlots() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Object = this.getObjData();
         var _loc10_:Object = this.rootClass != null && this.rootClass.world != null ? this.rootClass.world.myAvatar : null;
         if(_loc9_ == null || _loc10_ == null)
         {
            return;
         }
         var _loc11_:Number = this.pillY + 26 + 8;
         if(this.isHouseShop())
         {
            _loc1_ = _loc10_.houseitems != null ? _loc10_.houseitems : EMPTY;
            _loc2_ = int(_loc1_.length);
            _loc3_ = int(_loc9_.iHouseSlots);
            LPFElementInvAQRow.setRuns(this.tfItemSlots,_loc2_ + " / " + _loc3_,_loc2_ >= _loc3_ ? this.fmtSlotRed : this.fmtSlotNum," House spaces",this.fmtSlotLabel);
            this.tfMiscSlots.visible = false;
         }
         else
         {
            _loc4_ = _loc10_.items != null ? _loc10_.items : EMPTY;
            _loc5_ = InvCat.countBag(_loc4_);
            _loc6_ = int(_loc9_.iBagSlots);
            _loc7_ = InvCat.countMisc(_loc4_);
            _loc8_ = _loc6_;
            LPFElementInvAQRow.setRuns(this.tfItemSlots,_loc5_ + " / " + _loc6_,_loc5_ >= _loc6_ ? this.fmtSlotRed : this.fmtSlotNum," Item spaces",this.fmtSlotLabel);
            LPFElementInvAQRow.setRuns(this.tfMiscSlots,_loc7_ + " / " + _loc8_,_loc7_ >= _loc8_ ? this.fmtSlotRed : this.fmtSlotNum," Misc spaces",this.fmtSlotLabel);
            this.tfMiscSlots.visible = true;
         }
         LPFListFooter.layoutSlotLine(this.btnPlus,true,this.tfItemSlots,this.tfSlotSep,this.tfMiscSlots,0,w,_loc11_);
      }

      private function onPlusClick(param1:MouseEvent) : void
      {
         update({"eventType":"buyBagSlots"});
      }

      private function isHouseShop() : Boolean
      {
         var _loc1_:Object = getLayout();
         return _loc1_.shopinfo != null && _loc1_.shopinfo.bHouse == 1;
      }

      private function currentItems() : Array
      {
         var _loc1_:Object = null;
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return EMPTY;
         }
         if(this.mode == "shopSell")
         {
            _loc1_ = this.rootClass.world.myAvatar;
            if(this.isHouseShop())
            {
               return _loc1_.houseitems != null ? _loc1_.houseitems : EMPTY;
            }
            return _loc1_.items != null ? _loc1_.items : EMPTY;
         }
         var _loc2_:Object = getLayout();
         return _loc2_.itemsShop != null ? _loc2_.itemsShop : EMPTY;
      }

      private function markFilterEnabled(param1:Array, param2:Object) : void
      {
         var _loc1_:int = 0;
         _loc1_ = 1;
         while(_loc1_ < this.filterDefs.length)
         {
            if(!param1[_loc1_] && Boolean(itemMatchesFilter(param2,String(this.filterDefs[_loc1_].filter))))
            {
               param1[_loc1_] = true;
            }
            _loc1_++;
         }
      }

      private function isLocked(param1:Object) : Boolean
      {
         if(this.mode != "shopBuy" || this.rootClass == null)
         {
            return false;
         }
         try
         {
            if(int(param1.bUpg) == 1 && !this.rootClass.world.myAvatar.isUpgraded())
            {
               return true;
            }
         }
         catch(e:Error)
         {
         }
         try
         {
            if(int(param1.FactionID) > 1 && Number(this.rootClass.world.myAvatar.getRep(param1.FactionID)) < Number(param1.iReqRep))
            {
               return true;
            }
         }
         catch(e:Error)
         {
         }
         if(InvCat.isQuestLocked(param1,this.rootClass.world))
         {
            return true;
         }
         try
         {
            if(!this.rootClass.validateArmor(param1))
            {
               return true;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }

      private function isEquipped(param1:Object) : Boolean
      {
         return param1 != null && (param1.bEquip == 1 || param1.bWear == 1);
      }

      private function isHiddenLocked(param1:Object) : Boolean
      {
         if(this.mode == "shopSell")
         {
            return FavStore.has(param1.ItemID);
         }
         return this.mode == "shopBuy" && int(param1.bHide) == 1 && InvCat.isQuestLocked(param1,this.rootClass.world);
      }

      private function isSilhouetted(param1:Object) : Boolean
      {
         return this.mode == "shopBuy" && int(param1.bSilhouette) == 1 && InvCat.isQuestLocked(param1,this.rootClass.world);
      }

      private function rebuild() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return;
         }
         if(sortRank == null)
         {
            sortRank = {};
            _loc3_ = 0;
            while(_loc3_ < SORT_ORDER.length)
            {
               sortRank[SORT_ORDER[_loc3_]] = _loc3_;
               _loc3_++;
            }
         }
         var _loc4_:Array = this.currentItems();
         var _loc5_:int = int(this.filterDefs.length);
         var _loc6_:Boolean = false;
         this.subEnabled = [];
         _loc1_ = 0;
         while(_loc1_ < _loc5_)
         {
            this.subEnabled.push(_loc1_ == 0);
            _loc1_++;
         }
         for each(_loc2_ in _loc4_)
         {
            if(!(_loc2_ == null || Boolean(this.isHiddenLocked(_loc2_))))
            {
               this.markFilterEnabled(this.subEnabled,_loc2_);
            }
         }
         if(_loc5_ > 0 && this.subIdx < _loc5_ && !this.subEnabled[this.subIdx])
         {
            this.subIdx = 0;
         }
         var _loc7_:String = _loc5_ > 0 ? String(this.filterDefs[this.subIdx].filter) : "*";
         var _loc8_:String = this.searchQ.toLowerCase();
         var _loc9_:Boolean = _loc8_.length > 0;
         this.view = [];
         for each(_loc2_ in _loc4_)
         {
            if(!(_loc2_ == null || Boolean(this.isHiddenLocked(_loc2_))))
            {
               if(_loc2_ === this.selItem)
               {
                  _loc6_ = true;
               }
               if(Boolean(itemMatchesFilter(_loc2_,_loc7_)) && (!_loc9_ || String(_loc2_.sName).toLowerCase().indexOf(_loc8_) > -1))
               {
                  this.view.push(_loc2_);
               }
            }
         }
         if(!_loc6_)
         {
            this.selItem = null;
         }
         this.view.sort(compareItems);
         this.drawModeTabs();
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
            this.tfEmpty.y = Math.round((this.listH - this.tfEmpty.height) / 2);
            this.tfEmpty.visible = true;
         }
         else
         {
            this.tfEmpty.visible = false;
         }
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

      private function bindRow(param1:LPFElementInvAQRow, param2:Object) : void
      {
         param1.priceText = null;
         param1.priceCoins = false;
         param1.locked = this.isLocked(param2);
         param1.silhouette = this.isSilhouetted(param2);
         param1.markCheck = this.mode == "shopBuy" && !param1.locked && InvCat.isOwned(param2,this.rootClass.world);
         var _loc1_:Object = getLayout().shopinfo;
         param1.limitedStock = this.mode == "shopBuy" && _loc1_ != null && Boolean(_loc1_.bLimited);
         param1.bind(param2,this.rootClass,param2 === this.selItem,this.isEquipped(param2));
      }

      private function layoutRows(param1:Boolean = false) : void
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:LPFElementInvAQRow = null;
         var _loc4_:Object = null;
         var _loc5_:int = int(this.view.length);
         var _loc6_:int = _loc5_ * LPFFrameInvAQ.ROW_H > this.listH ? int(this.listW - 12) : int(this.listW - 2);
         if(_loc6_ != this.rowW)
         {
            this.rowW = _loc6_;
            param1 = true;
         }
         var _loc7_:int = _loc5_ * LPFFrameInvAQ.ROW_H - this.listH;
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
         this.scrollRectR.height = this.listH;
         this.listHolder.scrollRect = this.scrollRectR;
         var _loc8_:int = int(this.scrollY / LPFFrameInvAQ.ROW_H);
         var _loc9_:int = int((this.scrollY + this.listH - 1) / LPFFrameInvAQ.ROW_H);
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
               this.bindRow(_loc3_,_loc4_);
               _loc3_.y = _loc2_ * LPFFrameInvAQ.ROW_H;
               this.listHolder.addChild(_loc3_);
            }
            else if(param1)
            {
               _loc3_.rowW = this.rowW;
               this.bindRow(_loc3_,_loc4_);
            }
            _loc2_++;
         }
         this.updateScrollbar();
      }

      private function onFavChanged() : void
      {
         if(Boolean(this.closed) || this.rootClass == null)
         {
            return;
         }
         if(this.mode == "shopSell")
         {
            this.rebuild();
         }
         else
         {
            this.refreshActiveRows();
         }
      }

      private function refreshActiveRows() : void
      {
         var _loc1_:String = null;
         var _loc2_:LPFElementInvAQRow = null;
         for(_loc1_ in this.activeRows)
         {
            _loc2_ = this.activeRows[_loc1_];
            this.bindRow(_loc2_,_loc2_.item);
         }
      }

      private function updateScrollbar() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:Matrix = null;
         var _loc3_:int = this.view.length * LPFFrameInvAQ.ROW_H;
         if(_loc3_ <= this.listH)
         {
            this.sbTrack.visible = false;
            return;
         }
         this.sbTrack.visible = true;
         var _loc4_:int = this.listH - 4;
         var _loc5_:int = int(this.listH * this.listH / _loc3_);
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
         this.sbThumb.y = int((_loc4_ - this.thumbH) * this.scrollY / (_loc3_ - this.listH));
      }

      private function hookStageInput() : void
      {
         if(this.wheelStage != null || stage == null)
         {
            return;
         }
         this.wheelStage = stage;
         this.wheelStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true,0,true);
      }

      private function unhookStageInput() : void
      {
         if(this.wheelStage == null)
         {
            return;
         }
         this.wheelStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true);
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
         return Math.max(0,this.view.length * LPFFrameInvAQ.ROW_H - this.listH);
      }

      private function onWheel(param1:MouseEvent) : void
      {
         if(this.view.length * LPFFrameInvAQ.ROW_H <= this.listH)
         {
            return;
         }
         this.scrollY -= param1.delta * (LPFFrameInvAQ.ROW_H / 3);
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
            this.scrollY += this.sbTrack.mouseY < this.sbThumb.y ? -this.listH : this.listH;
            this.layoutRows();
         }
      }

      private function onDragMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = this.listH - 4 - this.thumbH;
         var _loc2_:int = this.view.length * LPFFrameInvAQ.ROW_H - this.listH;
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
   }
}
