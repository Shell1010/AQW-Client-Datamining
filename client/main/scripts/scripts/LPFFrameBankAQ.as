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

   public class LPFFrameBankAQ extends LPFFrame
   {

      public static var active:LPFFrameBankAQ;

      private static const LIST_Y:int = 118;

      private static const LIST_H:int = 324;

      private static const BANK_LIST_X:int = 14;

      private static const BANK_LIST_W:int = 300;

      private static const CENTER_X:int = 322;

      private static const CENTER_W:int = 256;

      private static const INV_LIST_X:int = 586;

      private static const INV_LIST_W:int = 300;

      private static const ROW_RIGHT:int = 886;

      private static const SEARCH_X:int = 14;

      private static const SEARCH_Y:int = 40;

      private static const SEARCH_W:int = 420;

      private static const SEARCH_H:int = 24;

      private static const TAB_Y:int = 70;

      private static const TAB_H:int = 24;

      private static const ROW_X0:int = 14;

      private static const LINK_H:int = 18;

      private static const HEADER_Y:int = 98;

      private static const BTN_X:int = 330;

      private static const BTN_W:int = 240;

      private static const BTN_H:int = 30;

      private static const BTN_GAP:int = 6;

      private static const HALF_BTN_W:int = (BTN_W - BTN_GAP) / 2;

      private static const TRANSFER_Y:int = 340;

      private static const SWAP_Y:int = 374;

      private static const HINT_Y:int = 408;

      private static const SPACE_LABEL_Y1:int = LIST_Y + LIST_H + 6;

      private static const PILL_W:int = 124;

      private static const PILL_H:int = 26;

      private static const PILL_Y:int = 430;

      private static const CIRCLE_D:int = 20;

      private static const RARITY_ROW_H:int = 22;

      private static const RARITY_LIST_MAXH:int = 220;

      private static const RARITY_LIST_MINW:int = 190;

      private static const BATCH_MIN_GAP:int = 150;

      private static const BATCH_TIMEOUT:int = 5000;

      private static const RESULT_MS:int = 3000;

      private static const TABS:Array = [{
         "label":"All",
         "icon":"iipack",
         "k":"*"
      },{
         "label":"Weapons",
         "icon":"iwsword",
         "k":"Weapon"
      },{
         "label":"Armor",
         "icon":"iiclass",
         "k":"ar"
      },{
         "label":"Helms",
         "icon":"iihelm",
         "k":"he"
      },{
         "label":"Capes",
         "icon":"iicape",
         "k":"ba"
      },{
         "label":"Pets",
         "icon":"iipet",
         "k":"pe"
      },{
         "label":"Accessories",
         "icon":"iin1",
         "k":"am"
      },{
         "label":"Items",
         "icon":"iibag",
         "k":"it"
      },{
         "label":"Enhance",
         "icon":"iidesign",
         "k":"enh"
      },{
         "label":"Favs",
         "icon":"favstar",
         "k":"fav"
      },{
         "label":"Houses",
         "icon":"ihhouse",
         "k":"ho"
      },{
         "label":"Walls",
         "icon":"ihwall",
         "k":"wa"
      },{
         "label":"Floors",
         "icon":"ihfloor",
         "k":"fl"
      }];

      private static const HOUSE_FILTER_KEYS:Array = ["ho","wa","fl"];

      private static const SORT_ORDER:Array = ["Note","Resource","Item","Quest Item","ServerUse","Enhancement","Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand","Class","Armor","Helm","Cape","Misc","Earring","Amulet","Necklace","Belt","Ring","Pet"];

      private static const FILTER_MAP:Object = {
         "Weapon":["Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand"],
         "ar":["Class","Armor"],
         "he":["Helm"],
         "ba":["Cape"],
         "pe":["Pet"],
         "am":["Misc","Earring","Amulet","Necklace","Belt","Ring"],
         "it":["Note","Resource","Item","Quest Item","ServerUse"],
         "enh":["Enhancement"],
         "ho":["House"],
         "wa":["Wall Item"],
         "fl":["Floor Item"]
      };

      private static var sortRank:Object = null;

      private static var mtx:Matrix = new Matrix();

      private static var goldIconClass:Class = null;

      private static var goldIconClassChecked:Boolean = false;

      private static var coinsIconClass:Class = null;

      private static var coinsIconClassChecked:Boolean = false;

      private static const ROW_FILL_MTX:Matrix = new Matrix();

      private static const REBUILD_BATCH_GAP:int = 500;

      private var rootClass:MovieClip;

      private var closed:Boolean = false;

      private var bankMaster:Array = [];

      private var invMaster:Array = [];

      private var bankView:Array = [];

      private var invView:Array = [];

      private var bankLoaded:Boolean = false;

      private var tabIdx:int = 0;

      private var tabCounts:Array = [];

      private var typeTabs:Object = {};

      private var catOn:Array = [];

      private var tabRow:BankTabRow;

      private var keyStage:Stage;

      private var chipKeys:Array = ["AC","Gold","Legend","Free","Rare"];

      private var chipOn:Object = {
         "AC":false,
         "Gold":false,
         "Legend":false,
         "Free":false,
         "Rare":false
      };

      private var chipSprites:Array = [];

      private var chipLabels:Array = [];

      private var rarityDD:Sprite;

      private var rarityDDLabel:TextField;

      private var rarityListPanel:Sprite;

      private var rarityListBg:Shape;

      private var rarityListBorder:Shape;

      private var rarityListHolder:Sprite;

      private var raritySbTrack:Sprite;

      private var raritySbThumb:Sprite;

      private var rarityRows:Array = [];

      private var rarityOpen:Boolean = false;

      private var rarityFilter:int = -1;

      private var rarityCounts:Object = {};

      private var rarityKeys:Array = [];

      private var rarityScrollY:int = 0;

      private var rarityListW:int = 190;

      private var rarityDDW:Number = 0;

      private var rarityRowsDirty:Boolean = true;

      private var rarityScrollRect:Rectangle = new Rectangle();

      private var rarityTrackH:int = 0;

      private var rarityThumbH:int = 0;

      private var rarityMaxScroll:int = 0;

      private var rarityTouch:TouchScroll;

      private var rarityDragOffset:Number = 0;

      private var rarityPt:Point = new Point();

      private var rarityPanelW:Number = 0;

      private var searchQ:String = "";

      private var searchFocused:Boolean = false;

      private var searchTimer:Timer;

      private var searchBox:Sprite;

      private var tfSearch:TextField;

      private var tfPlaceholder:TextField;

      private var selBank:Dictionary;

      private var selInv:Dictionary;

      private var selBankCount:int = 0;

      private var selInvCount:int = 0;

      private var selectionOrder:Array = [];

      private var anchorBank:int = -1;

      private var anchorInv:int = -1;

      private var bankList:BankAQList;

      private var invList:BankAQList;

      private var headerBank:TextField;

      private var headerCenter:TextField;

      private var headerInv:TextField;

      private var allBankTf:Sprite;

      private var noneBankTf:Sprite;

      private var allInvTf:Sprite;

      private var noneInvTf:Sprite;

      private var withdrawBtn:Sprite;

      private var withdrawLabel:TextField;

      private var depositBtn:Sprite;

      private var depositLabel:TextField;

      private var swapBtn:Sprite;

      private var swapLabel:TextField;

      private var hintTf:TextField;

      private var centerLinkTf:TextField;

      private var resultMessage:String = null;

      private var swapPending:Boolean = false;

      private var swapBankId:int = 0;

      private var swapInvId:int = 0;

      private var swapTimer:Timer;

      private var batchRunning:Boolean = false;

      private var batchCancelled:Boolean = false;

      private var batchWaitingResponse:Boolean = false;

      private var batchDirection:String = "";

      private var batchVerb:String = "";

      private var batchQueue:Array = [];

      private var batchTotal:int = 0;

      private var batchMovedCount:int = 0;

      private var batchSkippedCount:int = 0;

      private var batchTimedOut:Dictionary = new Dictionary();

      private var rebuildDirty:Boolean = false;

      private var rebuildListening:Boolean = false;

      private var lastRebuildTime:int = 0;

      private var batchSkipReasons:Object = {};

      private var batchLastSendTime:int = 0;

      private var batchStartTime:int = 0;

      private var busy:Sprite;

      private var busyTitle:TextField;

      private var busyInfo:TextField;

      private var busyBar:Shape;

      private var busyCancel:Sprite;

      private var busyCancelTF:TextField;

      private var batchInFlightItem:Object;

      private var batchInFlightId:int = 0;

      private var batchTimer:Timer;

      private var statusTimer:Timer;

      private var tfBankSlots:TextField;

      private var goldPill:Sprite;

      private var acPill:Sprite;

      private var goldIcon:DisplayObject;

      private var coinsIcon:DisplayObject;

      private var goldCR:Rectangle;

      private var coinsCR:Rectangle;

      private var tfGold:TextField;

      private var tfCoins:TextField;

      private var helpBtn:Sprite;

      private var plusBtn:Sprite;

      private var bankPlusBtn:Sprite;

      private var tfItemSlots:TextField;

      private var tfMiscSlots:TextField;

      private var tfSlotSep:TextField;

      private var fmtWhiteB12:TextFormat;

      private var fmtGoldB12:TextFormat;

      private var fmtSlotNum:TextFormat;

      private var fmtSlotRed:TextFormat;

      private var fmtSlotLabel:TextFormat;

      public function LPFFrameBankAQ()
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

      private static function ensureSortRank() : void
      {
         if(sortRank != null)
         {
            return;
         }
         sortRank = {};
         var _loc1_:int = 0;
         while(_loc1_ < SORT_ORDER.length)
         {
            sortRank[SORT_ORDER[_loc1_]] = _loc1_;
            _loc1_++;
         }
      }

      public static function rrect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:uint, param8:uint) : void
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

      private static function itemMatchesTab(param1:Object, param2:String) : Boolean
      {
         if(param2 == "*")
         {
            return true;
         }
         if(param2 == "fav")
         {
            return FavStore.has(param1.ItemID);
         }
         var _loc1_:Array = FILTER_MAP[param2] as Array;
         return _loc1_ != null && _loc1_.indexOf(param1.sType) > -1 || param1.sType == "Enhancement" && String(param1.sES).indexOf(param2) > -1;
      }

      override public function fOpen(param1:Object) : void
      {
         eventTypes = ["refreshItems","refreshBank","refreshInventory","refreshInv","refreshCoins","refreshSlots","previewButton1Update"];
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
         active = this;
         FavStore.addListener(this.onFavChanged);
         this.buildFormats();
         this.selBank = new Dictionary(false);
         this.selInv = new Dictionary(false);
         this.selectionOrder = [];
         this.selBankCount = 0;
         this.selInvCount = 0;
         this.anchorBank = -1;
         this.anchorInv = -1;
         this.batchSkipReasons = {};
         this.swapPending = false;
         this.rarityFilter = -1;
         this.rarityOpen = false;
         this.rarityScrollY = 0;
         if("bankOpenHouse" in this.rootClass.world && this.rootClass.world.bankOpenHouse == true)
         {
            this.tabIdx = 10;
            this.rootClass.world.bankOpenHouse = false;
         }
         this.buildSearch();
         this.buildChips();
         this.buildRarityDropdown();
         this.buildTabs();
         this.buildHeaders();
         this.bankList = new BankAQList("bank");
         this.bankList.x = BANK_LIST_X;
         this.bankList.y = LIST_Y;
         this.bankList.onItemClick = this.onBankRowClick;
         this.bankList.selSet = this.selBank;
         this.bankList.setup(this.rootClass,BANK_LIST_W,LIST_H);
         addChild(this.bankList);
         this.invList = new BankAQList("inv");
         this.invList.x = INV_LIST_X;
         this.invList.y = LIST_Y;
         this.invList.onItemClick = this.onInvRowClick;
         this.invList.isRowEquipped = this.isInvEquipped;
         this.invList.selSet = this.selInv;
         this.invList.setup(this.rootClass,INV_LIST_W,LIST_H);
         addChild(this.invList);
         this.buildCenterControls();
         this.buildFooter();
         this.bankLoaded = this.rootClass.world.bankinfo.BankArray.length > 0;
         this.rebuildMasters();
         this.lastRebuildTime = getTimer();
         this.rebuildViews(true);
         this.drawPills();
         this.drawFooterSlots();
         this.afterSelectionChange();
      }

      override public function fClose() : void
      {
         if(this.closed)
         {
            return;
         }
         this.closed = true;
         FavStore.removeListener(this.onFavChanged);
         if(active == this)
         {
            active = null;
         }
         this.hideBusy();
         this.stopBatchTimer();
         this.stopStatusTimer();
         this.stopSwapTimer();
         if(this.rebuildListening)
         {
            this.rebuildListening = false;
            removeEventListener(Event.ENTER_FRAME,this.onRebuildFrame);
         }
         this.rebuildDirty = false;
         this.batchQueue = [];
         this.batchRunning = false;
         this.swapPending = false;
         if(this.searchTimer != null)
         {
            this.searchTimer.stop();
            this.searchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimer);
            this.searchTimer = null;
         }
         if(stage != null && this.tfSearch != null && stage.focus == this.tfSearch)
         {
            stage.focus = null;
         }
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDownRarity,true);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDownRarity);
            stage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheelRarity,true);
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRarityDragMove);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.onRarityDragUp);
         }
         if(this.rarityTouch != null)
         {
            this.rarityTouch.detach();
            this.rarityTouch = null;
         }
         if(this.tabRow != null)
         {
            this.tabRow.destroy();
            this.tabRow = null;
         }
         this.unhookStageKeys();
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHook);
         if(this.bankList != null)
         {
            this.bankList.destroy();
            this.bankList = null;
         }
         if(this.invList != null)
         {
            this.invList.destroy();
            this.invList = null;
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
         if(Boolean(this.closed) || this.rootClass == null)
         {
            return;
         }
         switch(String(param1.eventType))
         {
            case "refreshItems":
               this.markRebuild();
               if(Boolean(this.batchRunning) && Boolean(this.batchWaitingResponse))
               {
                  this.checkBatchConfirmation();
               }
               if(this.swapPending)
               {
                  this.checkSwapConfirmation();
               }
               break;
            case "refreshBank":
               this.bankLoaded = true;
               this.markRebuild();
               if(Boolean(this.batchRunning) && Boolean(this.batchWaitingResponse))
               {
                  this.checkBatchConfirmation();
               }
               if(this.swapPending)
               {
                  this.checkSwapConfirmation();
               }
               break;
            case "refreshInventory":
               this.markRebuild();
               break;
            case "refreshInv":
               break;
            case "refreshCoins":
               this.drawPills();
               break;
            case "refreshSlots":
               this.drawFooterSlots();
               break;
            case "previewButton1Update":
         }
      }

      private function onFavChanged() : void
      {
         if(!this.closed && this.rootClass != null)
         {
            this.markRebuild();
         }
      }

      private function markRebuild() : void
      {
         this.rebuildDirty = true;
         if(this.rebuildListening)
         {
            return;
         }
         this.rebuildListening = true;
         addEventListener(Event.ENTER_FRAME,this.onRebuildFrame,false,0,true);
      }

      private function onRebuildFrame(param1:Event) : void
      {
         if(Boolean(this.closed) || this.rootClass == null)
         {
            this.rebuildListening = false;
            removeEventListener(Event.ENTER_FRAME,this.onRebuildFrame);
            return;
         }
         if(Boolean(this.batchRunning) && getTimer() - this.lastRebuildTime < REBUILD_BATCH_GAP)
         {
            return;
         }
         this.flushRebuild();
      }

      private function flushRebuild() : void
      {
         if(this.rebuildListening)
         {
            this.rebuildListening = false;
            removeEventListener(Event.ENTER_FRAME,this.onRebuildFrame);
         }
         if(!this.rebuildDirty || Boolean(this.closed) || this.rootClass == null)
         {
            return;
         }
         this.rebuildDirty = false;
         this.lastRebuildTime = getTimer();
         this.rebuildMasters();
         this.rebuildViews(false);
         this.afterSelectionChange();
      }

      private function buildFormats() : void
      {
         this.fmtWhiteB12 = new TextFormat("Arial",12,16777215,true,false);
         this.fmtGoldB12 = new TextFormat("Arial",12,14725888,true,false);
         this.fmtSlotNum = new TextFormat("Arial",12,16777215,true);
         this.fmtSlotRed = new TextFormat("Arial",12,16729156,true);
         this.fmtSlotLabel = new TextFormat("Arial",12,10066329,false);
      }

      private function buildSearch() : void
      {
         this.searchBox = new Sprite();
         this.searchBox.x = SEARCH_X;
         this.searchBox.y = SEARCH_Y;
         var _loc1_:Graphics = this.searchBox.graphics;
         rrect(_loc1_,0,0,SEARCH_W,SEARCH_H,6,855309,3815994);
         var _loc2_:Number = SEARCH_W - 14;
         var _loc3_:Number = SEARCH_H / 2;
         _loc1_.lineStyle(2,10066329,1,true);
         _loc1_.drawCircle(_loc2_,_loc3_,5);
         _loc1_.moveTo(_loc2_ + 3.5,_loc3_ + 3.5);
         _loc1_.lineTo(_loc2_ + 6.5,_loc3_ + 6.5);
         this.tfSearch = new TextField();
         this.tfSearch.embedFonts = false;
         this.tfSearch.type = TextFieldType.INPUT;
         this.tfSearch.selectable = true;
         this.tfSearch.mouseEnabled = true;
         this.tfSearch.multiline = false;
         this.tfSearch.wordWrap = false;
         this.tfSearch.maxChars = 60;
         this.tfSearch.restrict = null;
         this.tfSearch.defaultTextFormat = new TextFormat("Arial",12,16777215);
         this.tfSearch.text = "Wg";
         var _loc4_:Number = this.tfSearch.textHeight + 4;
         this.tfSearch.text = "";
         this.tfSearch.width = SEARCH_W - 8 - 26;
         this.tfSearch.height = _loc4_;
         this.tfSearch.x = 8;
         this.tfSearch.y = Math.round((SEARCH_H - _loc4_) / 2);
         this.tfPlaceholder = LPFElementInvAQRow.makeTF(12,7829367);
         this.tfPlaceholder.text = "Search bank & inventory";
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
         this.searchTimer = new Timer(150,1);
         this.searchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimer);
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
         this.rebuildViews(true);
      }

      private function buildChips() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TextField = null;
         _loc1_ = 0;
         while(_loc1_ < this.chipKeys.length)
         {
            _loc2_ = new Sprite();
            _loc2_.buttonMode = true;
            _loc2_.mouseChildren = false;
            _loc2_.name = this.chipKeys[_loc1_];
            _loc3_ = LPFElementInvAQRow.makeTF(11,12303291);
            _loc3_.text = this.chipKeys[_loc1_];
            _loc2_.addChild(_loc3_);
            _loc2_.addEventListener(MouseEvent.CLICK,this.onChipClick,false,0,true);
            addChild(_loc2_);
            this.chipSprites.push(_loc2_);
            this.chipLabels.push(_loc3_);
            _loc1_++;
         }
         this.layoutChips();
      }

      private function layoutChips() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:TextField = null;
         var _loc4_:Number = NaN;
         var _loc5_:Boolean = false;
         var _loc6_:Number = SEARCH_X + SEARCH_W + 8;
         _loc1_ = 0;
         while(_loc1_ < this.chipSprites.length)
         {
            _loc2_ = this.chipSprites[_loc1_];
            _loc3_ = this.chipLabels[_loc1_];
            _loc5_ = Boolean(this.chipOn[this.chipKeys[_loc1_]]);
            _loc4_ = _loc3_.textWidth + 20;
            _loc2_.x = _loc6_;
            _loc2_.y = SEARCH_Y;
            _loc2_.graphics.clear();
            if(_loc5_)
            {
               rrect(_loc2_.graphics,0,0,_loc4_,SEARCH_H,12,4862488,13145646);
            }
            else
            {
               rrectRow(_loc2_.graphics,0,0,_loc4_,SEARCH_H,12,3815994);
            }
            _loc3_.textColor = _loc5_ ? 16777215 : 12303291;
            _loc3_.x = Math.round((_loc4_ - _loc3_.width) / 2);
            _loc3_.y = Math.round((SEARCH_H - _loc3_.height) / 2);
            _loc6_ += _loc4_ + 8;
            _loc1_++;
         }
      }

      private function onChipClick(param1:MouseEvent) : void
      {
         var _loc1_:String = Sprite(param1.currentTarget).name;
         switch(_loc1_)
         {
            case "AC":
               this.chipOn.AC = !this.chipOn.AC;
               if(this.chipOn.AC)
               {
                  this.chipOn.Gold = false;
               }
               break;
            case "Gold":
               this.chipOn.Gold = !this.chipOn.Gold;
               if(this.chipOn.Gold)
               {
                  this.chipOn.AC = false;
               }
               break;
            case "Legend":
               this.chipOn.Legend = !this.chipOn.Legend;
               if(this.chipOn.Legend)
               {
                  this.chipOn.Free = false;
               }
               break;
            case "Free":
               this.chipOn.Free = !this.chipOn.Free;
               if(this.chipOn.Free)
               {
                  this.chipOn.Legend = false;
               }
               break;
            case "Rare":
               this.chipOn.Rare = !this.chipOn.Rare;
         }
         this.layoutChips();
         this.rebuildViews(true);
      }

      private function chipMatches(param1:Object) : Boolean
      {
         var _loc1_:Boolean = true;
         if(this.chipOn.AC)
         {
            _loc1_ = int(param1.bCoins) == 1;
         }
         else if(this.chipOn.Gold)
         {
            _loc1_ = int(param1.bCoins) == 0;
         }
         if(this.chipOn.Legend)
         {
            _loc1_ &&= int(param1.bUpg) == 1;
         }
         else if(this.chipOn.Free)
         {
            _loc1_ &&= int(param1.bUpg) == 0;
         }
         if(this.chipOn.Rare)
         {
            _loc1_ &&= int(param1.iRty) == 30;
         }
         return _loc1_;
      }

      private function normalizeRty(param1:int) : int
      {
         return param1 == 10 ? 0 : param1;
      }

      private function rarityMatches(param1:Object) : Boolean
      {
         return this.rarityFilter == -1 || this.normalizeRty(int(param1.iRty)) == this.rarityFilter;
      }

      private function getRarityLabel(param1:int) : String
      {
         return this.rootClass != null ? String(this.rootClass.getRarityString(param1)) : "Unknown";
      }

      private function rarityEntryLabel(param1:int, param2:int) : String
      {
         var _loc1_:String = param1 == -1 ? "All rarities" : this.getRarityLabel(param1);
         return _loc1_ + " (" + this.rootClass.strNumWithCommas(param2) + ")";
      }

      private function buildRarityDropdown() : void
      {
         this.rarityDD = new Sprite();
         this.rarityDD.buttonMode = true;
         this.rarityDD.mouseChildren = false;
         this.rarityDDLabel = LPFElementInvAQRow.makeTF(11,12303291,true);
         this.rarityDD.addChild(this.rarityDDLabel);
         this.rarityDD.addEventListener(MouseEvent.CLICK,this.onRarityDDClick,false,0,true);
         addChild(this.rarityDD);
         this.rarityListPanel = new Sprite();
         this.rarityListPanel.visible = false;
         this.rarityListBg = new Shape();
         this.rarityListHolder = new Sprite();
         this.rarityListBorder = new Shape();
         this.raritySbTrack = new Sprite();
         this.raritySbThumb = new Sprite();
         this.raritySbTrack.addChild(this.raritySbThumb);
         this.raritySbThumb.buttonMode = true;
         this.raritySbThumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onRarityThumbDown,false,0,true);
         this.raritySbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onRarityTrackDown,false,0,true);
         this.rarityListPanel.addChild(this.rarityListBg);
         this.rarityListPanel.addChild(this.rarityListHolder);
         this.rarityListPanel.addChild(this.rarityListBorder);
         this.rarityListPanel.addChild(this.raritySbTrack);
         addChild(this.rarityListPanel);
         this.rarityTouch = TouchScroll.attach(this.rarityListHolder,this.rarityTouchGetPos,this.rarityTouchSetPos,this.rarityTouchGetMax);
         this.layoutRarityDropdown();
         if(stage != null)
         {
            stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onStageMouseDownRarity,true,0,true);
            stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKeyDownRarity,false,0,true);
            stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheelRarity,true,0,true);
         }
      }

      private function rarityTouchGetPos() : Number
      {
         return this.rarityScrollY;
      }

      private function rarityTouchSetPos(param1:Number) : void
      {
         this.rarityScrollY = int(param1);
         this.layoutRarityListPanel();
      }

      private function rarityTouchGetMax() : Number
      {
         var _loc1_:int = this.rarityRows.length * RARITY_ROW_H;
         return Math.max(0,_loc1_ - Math.min(_loc1_,RARITY_LIST_MAXH));
      }

      private function currentRarityLabel() : String
      {
         return (this.rarityFilter == -1 ? "All rarities" : this.getRarityLabel(this.rarityFilter)) + " ▼";
      }

      private function layoutRarityDropdown() : void
      {
         var _loc1_:Boolean = this.rarityFilter != -1;
         this.rarityDDLabel.text = this.currentRarityLabel();
         this.rarityDDLabel.textColor = _loc1_ ? 16777215 : 12303291;
         var _loc2_:Sprite = this.chipSprites[this.chipSprites.length - 1];
         var _loc3_:Number = _loc2_.x + _loc2_.width + 8;
         var _loc4_:Number = Math.min(Math.max(this.rarityDDLabel.textWidth + 28,120),ROW_RIGHT - _loc3_);
         var _loc5_:Number = ROW_RIGHT - _loc4_;
         this.rarityDD.x = _loc5_;
         this.rarityDD.y = SEARCH_Y;
         this.rarityDD.graphics.clear();
         if(_loc1_)
         {
            rrect(this.rarityDD.graphics,0,0,_loc4_,SEARCH_H,6,4862488,13145646);
         }
         else
         {
            rrectRow(this.rarityDD.graphics,0,0,_loc4_,SEARCH_H,6,3815994);
         }
         this.rarityDDLabel.x = Math.round((_loc4_ - this.rarityDDLabel.width) / 2);
         this.rarityDDLabel.y = Math.round((SEARCH_H - this.rarityDDLabel.height) / 2);
         this.rarityDDW = _loc4_;
         this.rarityListPanel.x = _loc5_ + _loc4_ - Math.max(_loc4_,this.rarityPanelW);
         this.rarityListPanel.y = SEARCH_Y + SEARCH_H + 4;
      }

      private function onRarityDDClick(param1:MouseEvent) : void
      {
         this.setRarityOpen(!this.rarityOpen);
      }

      private function setRarityOpen(param1:Boolean) : void
      {
         if(this.rarityOpen == param1)
         {
            return;
         }
         this.rarityOpen = param1;
         this.rarityListPanel.visible = param1;
         if(param1)
         {
            if(this.rarityRowsDirty)
            {
               this.rarityRowsDirty = false;
               this.rebuildRarityRows();
            }
            this.rarityScrollY = 0;
            this.layoutRarityListPanel();
            setChildIndex(this.rarityListPanel,numChildren - 1);
         }
      }

      private function markRarityRowsDirty() : void
      {
         if(this.rarityOpen)
         {
            this.rebuildRarityRows();
            this.layoutRarityListPanel();
         }
         else
         {
            this.rarityRowsDirty = true;
         }
      }

      private function rebuildRarityCounts() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Object = {};
         var _loc4_:Array = [];
         for each(_loc1_ in this.bankMaster)
         {
            if(_loc1_ != null)
            {
               _loc2_ = int(this.normalizeRty(int(_loc1_.iRty)));
               if(_loc3_[_loc2_] == undefined)
               {
                  _loc3_[_loc2_] = 0;
                  _loc4_.push(_loc2_);
               }
               ++_loc3_[_loc2_];
            }
         }
         _loc4_.sort(Array.NUMERIC);
         this.rarityCounts = _loc3_;
         this.rarityKeys = _loc4_;
         if(this.rarityFilter != -1 && _loc3_[this.rarityFilter] == undefined)
         {
            this.rarityFilter = -1;
         }
         this.markRarityRowsDirty();
         this.layoutRarityDropdown();
      }

      private function clearRarityRows() : void
      {
         var _loc1_:Sprite = null;
         for each(_loc1_ in this.rarityRows)
         {
            _loc1_.removeEventListener(MouseEvent.CLICK,this.onRarityRowClick);
            _loc1_.removeEventListener(MouseEvent.ROLL_OVER,this.onRarityRowOver);
            _loc1_.removeEventListener(MouseEvent.ROLL_OUT,this.onRarityRowOut);
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
         this.rarityRows = [];
      }

      private function drawRarityRowBg(param1:Sprite, param2:int, param3:int, param4:Boolean) : void
      {
         var _loc1_:Graphics = param1.graphics;
         _loc1_.clear();
         var _loc2_:Boolean = param3 == this.rarityFilter;
         var _loc3_:uint = param4 ? 2763306 : (_loc2_ ? 3351567 : 657930);
         var _loc4_:Number = param4 || _loc2_ ? 1 : 0;
         _loc1_.beginFill(_loc3_,_loc4_);
         _loc1_.drawRect(0,0,param2,RARITY_ROW_H);
         _loc1_.endFill();
      }

      private function buildRarityRow(param1:int, param2:String, param3:int, param4:int) : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.name = String(param1);
         _loc1_.buttonMode = true;
         _loc1_.mouseChildren = false;
         var _loc2_:TextField = LPFElementInvAQRow.makeTF(12,param1 == this.rarityFilter ? 14725888 : 13421772,true);
         _loc2_.text = param2;
         _loc1_.addChild(_loc2_);
         _loc2_.x = 10;
         _loc2_.y = Math.round((RARITY_ROW_H - _loc2_.height) / 2);
         this.drawRarityRowBg(_loc1_,param4,param1,false);
         _loc1_.y = param3;
         _loc1_.addEventListener(MouseEvent.CLICK,this.onRarityRowClick,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.onRarityRowOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.onRarityRowOut,false,0,true);
         return _loc1_;
      }

      private function rebuildRarityRows() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         var _loc3_:Number = NaN;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         var _loc6_:Sprite = null;
         this.clearRarityRows();
         if(this.rootClass == null)
         {
            return;
         }
         var _loc7_:Array = [{
            "key":-1,
            "label":this.rarityEntryLabel(-1,this.bankMaster.length)
         }];
         for each(_loc1_ in this.rarityKeys)
         {
            _loc7_.push({
               "key":_loc1_,
               "label":this.rarityEntryLabel(_loc1_,int(this.rarityCounts[_loc1_]))
            });
         }
         _loc2_ = LPFElementInvAQRow.makeTF(12,16777215,true);
         _loc3_ = 0;
         for each(_loc4_ in _loc7_)
         {
            _loc2_.text = String(_loc4_.label);
            if(_loc2_.textWidth > _loc3_)
            {
               _loc3_ = _loc2_.textWidth;
            }
         }
         this.rarityListW = Math.max(RARITY_LIST_MINW - 20,int(_loc3_)) + 20;
         _loc5_ = 0;
         for each(_loc4_ in _loc7_)
         {
            _loc6_ = this.buildRarityRow(int(_loc4_.key),String(_loc4_.label),_loc5_,this.rarityListW);
            this.rarityListHolder.addChild(_loc6_);
            this.rarityRows.push(_loc6_);
            _loc5_ += RARITY_ROW_H;
         }
         this.layoutRarityListPanel();
      }

      private function layoutRarityListPanel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = int(this.rarityRows.length);
         var _loc4_:int = _loc3_ * RARITY_ROW_H;
         var _loc5_:int = Math.min(_loc4_,RARITY_LIST_MAXH);
         if(_loc5_ <= 0)
         {
            _loc5_ = int(RARITY_ROW_H);
         }
         var _loc6_:Boolean = _loc4_ > _loc5_;
         var _loc7_:int = this.rarityListW + (_loc6_ ? 10 : 0);
         this.rarityPanelW = _loc7_;
         this.rarityListPanel.x = this.rarityDD.x + this.rarityDDW - Math.max(this.rarityDDW,_loc7_);
         var _loc8_:Graphics = this.rarityListBg.graphics;
         _loc8_.clear();
         _loc8_.beginFill(657930);
         _loc8_.drawRoundRect(0,0,_loc7_,_loc5_,8,8);
         _loc8_.endFill();
         _loc8_ = this.rarityListBorder.graphics;
         _loc8_.clear();
         _loc8_.lineStyle(1,2763306,1,true);
         _loc8_.drawRoundRect(0,0,_loc7_,_loc5_,8,8);
         var _loc9_:int = Math.max(0,_loc4_ - _loc5_);
         if(this.rarityScrollY > _loc9_)
         {
            this.rarityScrollY = _loc9_;
         }
         if(this.rarityScrollY < 0)
         {
            this.rarityScrollY = 0;
         }
         this.rarityScrollRect.x = 0;
         this.rarityScrollRect.y = this.rarityScrollY;
         this.rarityScrollRect.width = _loc6_ ? _loc7_ - 10 : _loc7_;
         this.rarityScrollRect.height = _loc5_;
         this.rarityListHolder.scrollRect = this.rarityScrollRect;
         this.raritySbTrack.visible = _loc6_;
         if(_loc6_)
         {
            this.raritySbTrack.x = _loc7_ - 10;
            this.raritySbTrack.y = 2;
            _loc8_ = this.raritySbTrack.graphics;
            _loc8_.clear();
            _loc8_.beginFill(1710618);
            _loc8_.drawRoundRect(0,0,8,_loc5_ - 4,8,8);
            _loc8_.endFill();
            _loc1_ = _loc5_ - 4;
            _loc2_ = Math.max(24,Math.min(_loc1_,int(_loc5_ * _loc5_ / _loc4_)));
            mtx.createGradientBox(8,_loc2_,0,0,0);
            _loc8_ = this.raritySbThumb.graphics;
            _loc8_.clear();
            _loc8_.lineStyle(1,13145646,1,true);
            _loc8_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],mtx);
            _loc8_.drawRoundRect(0,0,8,_loc2_,8,8);
            _loc8_.endFill();
            this.raritySbThumb.y = _loc9_ > 0 ? int((_loc1_ - _loc2_) * this.rarityScrollY / _loc9_) : 0;
            this.rarityTrackH = _loc1_;
            this.rarityThumbH = _loc2_;
            this.rarityMaxScroll = _loc9_;
         }
         this.rarityListPanel.y = SEARCH_Y + SEARCH_H + 4;
      }

      private function onRarityRowOver(param1:MouseEvent) : void
      {
         var _loc1_:Sprite = Sprite(param1.currentTarget);
         this.drawRarityRowBg(_loc1_,this.rarityListW,int(_loc1_.name),true);
      }

      private function onRarityRowOut(param1:MouseEvent) : void
      {
         var _loc1_:Sprite = Sprite(param1.currentTarget);
         this.drawRarityRowBg(_loc1_,this.rarityListW,int(_loc1_.name),false);
      }

      private function onRarityRowClick(param1:MouseEvent) : void
      {
         this.selectRarity(int(Sprite(param1.currentTarget).name));
      }

      private function selectRarity(param1:int) : void
      {
         this.setRarityOpen(false);
         if(param1 == this.rarityFilter)
         {
            return;
         }
         this.rarityFilter = param1;
         this.markRarityRowsDirty();
         this.layoutRarityDropdown();
         this.rebuildViews(true);
      }

      private function onStageWheelRarity(param1:MouseEvent) : void
      {
         if(!this.rarityOpen)
         {
            return;
         }
         if(!this.rarityListPanel.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc1_:int = this.rarityRows.length * RARITY_ROW_H;
         var _loc2_:int = Math.min(_loc1_,RARITY_LIST_MAXH);
         if(_loc1_ <= _loc2_)
         {
            return;
         }
         this.rarityScrollY -= param1.delta * (RARITY_ROW_H / 3);
         this.layoutRarityListPanel();
      }

      private function localYIn(param1:DisplayObject, param2:MouseEvent) : Number
      {
         this.rarityPt.x = param2.stageX;
         this.rarityPt.y = param2.stageY;
         return param1.globalToLocal(this.rarityPt).y;
      }

      private function onRarityThumbDown(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         if(stage == null)
         {
            return;
         }
         this.rarityDragOffset = this.localYIn(this.raritySbThumb,param1);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onRarityDragMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onRarityDragUp,false,0,true);
      }

      private function onRarityDragMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = this.rarityTrackH - this.rarityThumbH;
         if(!this.rarityOpen || _loc1_ <= 0)
         {
            return;
         }
         var _loc2_:Number = Math.max(0,Math.min(_loc1_,this.localYIn(this.raritySbTrack,param1) - this.rarityDragOffset));
         this.rarityScrollY = int(_loc2_ / _loc1_ * this.rarityMaxScroll);
         this.layoutRarityListPanel();
         param1.updateAfterEvent();
      }

      private function onRarityDragUp(param1:MouseEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRarityDragMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onRarityDragUp);
      }

      private function onRarityTrackDown(param1:MouseEvent) : void
      {
         if(param1.target == this.raritySbThumb)
         {
            return;
         }
         this.rarityScrollY += this.localYIn(this.raritySbTrack,param1) < this.raritySbThumb.y ? -(this.rarityTrackH + 4) : this.rarityTrackH + 4;
         this.layoutRarityListPanel();
      }

      private function onStageMouseDownRarity(param1:MouseEvent) : void
      {
         if(!this.rarityOpen)
         {
            return;
         }
         if(this.rarityDD.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         if(this.rarityListPanel.hitTestPoint(param1.stageX,param1.stageY,true))
         {
            return;
         }
         this.setRarityOpen(false);
      }

      private function onStageKeyDownRarity(param1:KeyboardEvent) : void
      {
         if(!this.rarityOpen)
         {
            return;
         }
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.setRarityOpen(false);
         }
      }

      private function buildTabIcon(param1:String, param2:int, param3:int) : DisplayObject
      {
         var holder:Sprite;
         var d:DisplayObject = null;
         var c:Class = null;
         var bh:Number = NaN;
         var bw:Number = NaN;
         var sc:Number = NaN;
         var link:String = param1;
         var box:int = param2;
         var maxW:int = param3;
         if(this.rootClass == null || this.rootClass.world == null)
         {
            return null;
         }
         holder = new Sprite();
         if(link == "favstar")
         {
            d = FavStore.starShape(box);
         }
         else
         {
            c = this.rootClass.world.getClass(link);
            if(c == null)
            {
               return null;
            }
            try
            {
               d = new c() as DisplayObject;
            }
            catch(e:Error)
            {
               return null;
            }
            if(d == null)
            {
               return null;
            }
            bh = d.height;
            bw = d.width;
            if(bh > 0)
            {
               sc = link == "iCheck" ? 16 / bh : box / bh;
               if(bw * sc > maxW)
               {
                  sc = maxW / bw;
               }
               d.scaleX = d.scaleY = sc;
            }
         }
         holder.addChild(d);
         LPFElementInvAQRow.centerAt(d,Math.round(maxW / 2),Math.round(box / 2));
         return holder;
      }

      private function buildTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < TABS.length)
         {
            _loc2_.push(TABS[_loc1_].label);
            _loc3_.push(this.buildTabIcon(TABS[_loc1_].icon,14,14));
            _loc1_++;
         }
         this.tabRow = new BankTabRow("Q","E",TAB_H,ROW_X0,ROW_RIGHT,14);
         this.tabRow.y = TAB_Y;
         this.tabRow.onSelect = this.selectTab;
         this.tabRow.setTabs(_loc2_,_loc3_);
         addChild(this.tabRow);
         if(stage != null)
         {
            this.hookStageKeys();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedHook,false,0,true);
         }
      }

      private function selectTab(param1:int) : void
      {
         if(param1 == this.tabIdx)
         {
            return;
         }
         if(param1 < this.catOn.length && !this.catOn[param1])
         {
            return;
         }
         this.tabIdx = param1;
         this.tabRow.reveal();
         this.applyFilterChange();
      }

      private function applyFilterChange() : void
      {
         this.rebuildViews(true);
         this.pruneToView("bank",this.selBank,this.bankView);
         this.pruneToView("inv",this.selInv,this.invView);
         this.bankList.refreshHighlight();
         this.invList.refreshHighlight();
         this.afterSelectionChange();
      }

      private function hookStageKeys() : void
      {
         if(this.keyStage != null || stage == null)
         {
            return;
         }
         this.keyStage = stage;
         this.keyStage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,true,100,true);
         this.keyStage.addEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,false,100,true);
         this.keyStage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,true,100,true);
         this.keyStage.addEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,false,100,true);
      }

      private function unhookStageKeys() : void
      {
         if(this.keyStage == null)
         {
            return;
         }
         this.keyStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,true);
         this.keyStage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onStageKey,false);
         this.keyStage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,true);
         this.keyStage.removeEventListener(KeyboardEvent.KEY_UP,this.onStageKeyUp,false);
         this.keyStage = null;
      }

      private function onAddedHook(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHook);
         this.hookStageKeys();
      }

      private function isTypingFocus() : Boolean
      {
         var _loc1_:Object = this.keyStage != null ? this.keyStage.focus : null;
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
            this.tabRow.step(-1);
         }
         else if(param1.keyCode == 69)
         {
            param1.stopImmediatePropagation();
            this.tabRow.step(1);
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

      private function pruneToView(param1:String, param2:Dictionary, param3:Array) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:Dictionary = new Dictionary(false);
         for each(_loc1_ in param3)
         {
            _loc4_[_loc1_] = true;
         }
         _loc2_ = [];
         for(_loc3_ in param2)
         {
            if(!(_loc3_ in _loc4_))
            {
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc3_ in _loc2_)
         {
            this.removeFromSelection(param1,_loc3_);
         }
      }

      private function buildLinkBtn(param1:String, param2:Function) : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.buttonMode = true;
         _loc1_.mouseChildren = false;
         var _loc2_:TextField = LPFElementInvAQRow.makeTF(11,12303291,true);
         _loc2_.text = param1;
         _loc1_.addChild(_loc2_);
         var _loc3_:int = int(_loc2_.textWidth) + 14;
         _loc2_.x = Math.round((_loc3_ - _loc2_.width) / 2);
         _loc2_.y = Math.round((LINK_H - _loc2_.height) / 2);
         this.drawLinkBtn(_loc1_,false);
         _loc1_.addEventListener(MouseEvent.CLICK,param2,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OVER,this.onHeaderLinkOver,false,0,true);
         _loc1_.addEventListener(MouseEvent.ROLL_OUT,this.onHeaderLinkOut,false,0,true);
         return _loc1_;
      }

      private function drawLinkBtn(param1:Sprite, param2:Boolean) : void
      {
         var _loc1_:TextField = TextField(param1.getChildAt(0));
         var _loc2_:int = int(_loc1_.textWidth) + 14;
         param1.graphics.clear();
         if(param2)
         {
            rrect(param1.graphics,0,0,_loc2_,LINK_H,5,4862488,13145646);
         }
         else
         {
            rrectRow(param1.graphics,0,0,_loc2_,LINK_H,5,3815994);
         }
         _loc1_.textColor = param2 ? 16777215 : 12303291;
      }

      private function onHeaderLinkOver(param1:MouseEvent) : void
      {
         this.drawLinkBtn(Sprite(param1.currentTarget),true);
      }

      private function onHeaderLinkOut(param1:MouseEvent) : void
      {
         this.drawLinkBtn(Sprite(param1.currentTarget),false);
      }

      private function buildHeaders() : void
      {
         this.headerBank = LPFElementInvAQRow.makeTF(12,16777215,true);
         this.headerBank.text = "Bank (0)";
         this.headerBank.x = BANK_LIST_X;
         this.headerBank.y = HEADER_Y;
         addChild(this.headerBank);
         this.headerCenter = LPFElementInvAQRow.makeTF(12,16777215,true);
         this.headerCenter.text = "Preview";
         this.headerCenter.x = Math.round(CENTER_X + CENTER_W / 2 - this.headerCenter.width / 2);
         this.headerCenter.y = HEADER_Y;
         addChild(this.headerCenter);
         this.headerInv = LPFElementInvAQRow.makeTF(12,16777215,true);
         this.headerInv.text = "Inventory (0)";
         this.headerInv.x = INV_LIST_X;
         this.headerInv.y = HEADER_Y;
         addChild(this.headerInv);
         this.allBankTf = this.buildLinkBtn("All",this.onAllBankClick);
         addChild(this.allBankTf);
         this.noneBankTf = this.buildLinkBtn("None",this.onNoneBankClick);
         addChild(this.noneBankTf);
         this.allInvTf = this.buildLinkBtn("All",this.onAllInvClick);
         addChild(this.allInvTf);
         this.noneInvTf = this.buildLinkBtn("None",this.onNoneInvClick);
         addChild(this.noneInvTf);
         this.updateHeaders();
      }

      private function updateHeaders() : void
      {
         var _loc1_:String = this.selBankCount > 0 ? " · " + this.selBankCount + " selected" : "";
         var _loc2_:String = this.selInvCount > 0 ? " · " + this.selInvCount + " selected" : "";
         LPFElementInvAQRow.setRuns(this.headerBank,"Bank (" + this.bankView.length + ")",this.fmtWhiteB12,_loc1_,this.fmtGoldB12);
         LPFElementInvAQRow.setRuns(this.headerInv,"Inventory (" + this.invView.length + ")",this.fmtWhiteB12,_loc2_,this.fmtGoldB12);
         this.noneBankTf.y = HEADER_Y;
         this.noneBankTf.x = BANK_LIST_X + BANK_LIST_W - int(this.noneBankTf.width);
         this.allBankTf.y = HEADER_Y;
         this.allBankTf.x = this.noneBankTf.x - 6 - int(this.allBankTf.width);
         this.noneInvTf.y = HEADER_Y;
         this.noneInvTf.x = ROW_RIGHT - int(this.noneInvTf.width);
         this.allInvTf.y = HEADER_Y;
         this.allInvTf.x = this.noneInvTf.x - 6 - int(this.allInvTf.width);
      }

      private function buildCenterControls() : void
      {
         this.depositBtn = new Sprite();
         this.depositBtn.x = BTN_X;
         this.depositBtn.y = TRANSFER_Y;
         this.depositBtn.mouseChildren = false;
         this.depositLabel = LPFElementInvAQRow.makeTF(14,16777215,true);
         this.depositBtn.addChild(this.depositLabel);
         this.depositBtn.addEventListener(MouseEvent.CLICK,this.onDepositClick,false,0,true);
         addChild(this.depositBtn);
         this.withdrawBtn = new Sprite();
         this.withdrawBtn.x = BTN_X + HALF_BTN_W + BTN_GAP;
         this.withdrawBtn.y = TRANSFER_Y;
         this.withdrawBtn.mouseChildren = false;
         this.withdrawLabel = LPFElementInvAQRow.makeTF(14,16777215,true);
         this.withdrawBtn.addChild(this.withdrawLabel);
         this.withdrawBtn.addEventListener(MouseEvent.CLICK,this.onWithdrawClick,false,0,true);
         addChild(this.withdrawBtn);
         this.swapBtn = new Sprite();
         this.swapBtn.x = BTN_X;
         this.swapBtn.y = SWAP_Y;
         this.swapBtn.mouseChildren = false;
         this.swapLabel = LPFElementInvAQRow.makeTF(14,16777215,true);
         this.swapBtn.addChild(this.swapLabel);
         this.swapBtn.addEventListener(MouseEvent.CLICK,this.onSwapClick,false,0,true);
         addChild(this.swapBtn);
         this.hintTf = LPFElementInvAQRow.makeTF(11,8947848);
         addChild(this.hintTf);
         this.centerLinkTf = LPFElementInvAQRow.makeTF(11,14725888,true);
         this.centerLinkTf.mouseEnabled = false;
         this.centerLinkTf.visible = false;
         this.centerLinkTf.addEventListener(MouseEvent.CLICK,this.onCenterLinkClick,false,0,true);
         addChild(this.centerLinkTf);
         this.updateCenterButtons();
         this.drawCenterLine();
      }

      private function drawCenterButton(param1:Sprite, param2:TextField, param3:Boolean, param4:Number, param5:Number) : void
      {
         var _loc1_:Graphics = param1.graphics;
         _loc1_.clear();
         mtx.createGradientBox(param4,param5,Math.PI / 2,0,0);
         _loc1_.lineStyle(2,param3 ? 13145646 : 5592405,1,true);
         _loc1_.beginGradientFill(GradientType.LINEAR,param3 ? [11740702,7212811] : [3815994,2236962],[1,1],[0,255],mtx);
         _loc1_.drawRoundRect(0,0,param4,param5,16,16);
         _loc1_.endFill();
         param2.textColor = param3 ? 16777215 : 8947848;
         param2.x = Math.round((param4 - param2.width) / 2);
         param2.y = Math.round((param5 - param2.height) / 2);
         param1.buttonMode = param3;
         param1.mouseEnabled = param3;
      }

      private function updateCenterButtons() : void
      {
         var _loc1_:Boolean = !this.batchRunning && !this.swapPending && this.selBankCount > 0;
         var _loc2_:Boolean = !this.batchRunning && !this.swapPending && this.selInvCount > 0;
         var _loc3_:Boolean = !this.batchRunning && !this.swapPending && this.selBankCount == 1 && this.selInvCount == 1;
         this.withdrawLabel.text = this.selBankCount > 0 ? "Withdraw " + this.selBankCount + " →" : "Withdraw →";
         this.depositLabel.text = this.selInvCount > 0 ? "← Deposit " + this.selInvCount : "← Deposit";
         this.swapLabel.text = "⇄ Swap";
         this.drawCenterButton(this.depositBtn,this.depositLabel,_loc2_,HALF_BTN_W,BTN_H);
         this.drawCenterButton(this.withdrawBtn,this.withdrawLabel,_loc1_,HALF_BTN_W,BTN_H);
         this.drawCenterButton(this.swapBtn,this.swapLabel,_loc3_,BTN_W,BTN_H);
      }

      private function setCenterLine(param1:String, param2:String) : void
      {
         this.hintTf.text = param1;
         this.hintTf.textColor = 8947848;
         if(param2.length > 0)
         {
            this.centerLinkTf.text = param2;
            this.centerLinkTf.textColor = 14725888;
            this.centerLinkTf.visible = true;
            this.centerLinkTf.mouseEnabled = true;
         }
         else
         {
            this.centerLinkTf.text = "";
            this.centerLinkTf.visible = false;
            this.centerLinkTf.mouseEnabled = false;
         }
         var _loc1_:Number = param1.length > 0 && param2.length > 0 ? 4 : 0;
         var _loc2_:Number = this.hintTf.width + _loc1_ + this.centerLinkTf.width;
         var _loc3_:Number = Math.round(BTN_X + BTN_W / 2 - _loc2_ / 2);
         this.hintTf.x = _loc3_;
         this.hintTf.y = HINT_Y;
         this.centerLinkTf.x = _loc3_ + this.hintTf.width + _loc1_;
         this.centerLinkTf.y = HINT_Y;
      }

      private function drawCenterLine() : void
      {
         if(this.batchRunning)
         {
            this.setCenterLine(this.batchVerb + " " + this.batchMovedCount + " / " + this.batchTotal + "…","Cancel");
            return;
         }
         if(this.swapPending)
         {
            this.setCenterLine("Swapping…","");
            return;
         }
         if(this.resultMessage != null)
         {
            this.setCenterLine(this.resultMessage,"");
            return;
         }
         this.setCenterLine("Click to select · Shift+click for a range","");
      }

      private function onCenterLinkClick(param1:MouseEvent) : void
      {
         if(this.batchRunning)
         {
            this.batchCancelled = true;
         }
      }

      public function serverWarning(param1:String) : Boolean
      {
         if(param1 != "Inventory Bag Full" && param1 != "Misc inventory is full!")
         {
            return false;
         }
         if(!(Boolean(this.batchRunning) && this.batchDirection == "withdraw") && !this.swapPending)
         {
            return false;
         }
         return this.serverFailed(param1,0);
      }

      public function serverFailed(param1:String, param2:int = 0) : Boolean
      {
         if(this.closed)
         {
            return false;
         }
         if(Boolean(this.batchRunning) && param2 > 0 && param2 != this.batchInFlightId)
         {
            return true;
         }
         if(Boolean(this.batchRunning) && Boolean(this.batchWaitingResponse))
         {
            this.recordSkip(param1 != null && param1 != "" ? param1 : "failed");
            this.advanceBatchFromResponse();
            this.drawCenterLine();
            return true;
         }
         if(this.swapPending)
         {
            this.stopSwapTimer();
            this.hideBusy();
            this.swapPending = false;
            this.resultMessage = param1 != null && param1 != "" ? param1 : "Swap failed";
            this.afterSelectionChange();
            this.startStatusTimer();
            return true;
         }
         return false;
      }

      private function showBusy(param1:String, param2:Boolean) : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.rootClass == null || this.rootClass.ui == null)
         {
            return;
         }
         if(this.busy == null)
         {
            this.busy = new Sprite();
            this.busy.graphics.beginFill(0,0.5);
            this.busy.graphics.drawRect(0,0,960,550);
            this.busy.graphics.endFill();
            _loc1_ = 330;
            _loc2_ = 205;
            this.busy.graphics.lineStyle(1,10254908,1,true);
            this.busy.graphics.beginFill(1381653,0.95);
            this.busy.graphics.drawRoundRect(_loc1_,_loc2_,300,130,12,12);
            this.busy.graphics.endFill();
            this.busyTitle = LPFElementInvAQRow.makeTF(15,16777215,true);
            this.busyTitle.x = _loc1_ + 16;
            this.busyTitle.y = _loc2_ + 14;
            this.busy.addChild(this.busyTitle);
            this.busyInfo = LPFElementInvAQRow.makeTF(12,13421772,false);
            this.busyInfo.x = _loc1_ + 16;
            this.busyInfo.y = _loc2_ + 40;
            this.busy.addChild(this.busyInfo);
            this.busyBar = new Shape();
            this.busyBar.x = _loc1_ + 16;
            this.busyBar.y = _loc2_ + 64;
            this.busy.addChild(this.busyBar);
            this.busyCancel = new Sprite();
            this.busyCancel.graphics.lineStyle(1,12303291,1,true);
            this.busyCancel.graphics.beginFill(7999504);
            this.busyCancel.graphics.drawRoundRect(0,0,90,26,8,8);
            this.busyCancel.graphics.endFill();
            this.busyCancelTF = LPFElementInvAQRow.makeTF(12,16777215,true);
            this.busyCancel.addChild(this.busyCancelTF);
            this.busyCancel.x = _loc1_ + 105;
            this.busyCancel.y = _loc2_ + 90;
            this.busyCancel.buttonMode = true;
            this.busyCancel.mouseChildren = false;
            this.busyCancel.addEventListener(MouseEvent.CLICK,this.onBusyCancel,false,0,true);
            this.busy.addChild(this.busyCancel);
         }
         this.busyTitle.text = param1;
         this.busyCancelTF.text = "Cancel";
         this.busyCancelTF.x = Math.round((90 - this.busyCancelTF.width) / 2);
         this.busyCancelTF.y = Math.round((26 - this.busyCancelTF.height) / 2);
         this.busyCancel.visible = param2;
         this.busyCancel.mouseEnabled = true;
         this.rootClass.ui.addChild(this.busy);
         this.updateBusy();
      }

      private function updateBusy() : void
      {
         var _loc1_:int = 0;
         if(this.busy == null || this.busy.parent == null)
         {
            return;
         }
         var _loc2_:Graphics = this.busyBar.graphics;
         _loc2_.clear();
         _loc2_.beginFill(3355443);
         _loc2_.drawRoundRect(0,0,268,8,6,6);
         _loc2_.endFill();
         if(!this.batchRunning)
         {
            this.busyInfo.text = "Please wait…";
            return;
         }
         var _loc3_:int = this.batchMovedCount + this.batchSkippedCount;
         var _loc4_:String = _loc3_ + " / " + this.batchTotal;
         if(_loc3_ > 0 && _loc3_ < this.batchTotal)
         {
            _loc1_ = Math.ceil((getTimer() - this.batchStartTime) / _loc3_ * (this.batchTotal - _loc3_) / 1000);
            _loc4_ += "  ·  about " + (_loc1_ >= 60 ? int(_loc1_ / 60) + "m " + _loc1_ % 60 + "s" : _loc1_ + "s") + " left";
         }
         if(this.batchCancelled)
         {
            _loc4_ += "  ·  stopping…";
         }
         this.busyInfo.text = _loc4_;
         var _loc5_:int = this.batchTotal > 0 ? int(Math.round(268 * _loc3_ / this.batchTotal)) : 0;
         if(_loc5_ > 0)
         {
            _loc2_.beginFill(12597547);
            _loc2_.drawRoundRect(0,0,Math.max(8,_loc5_),8,6,6);
            _loc2_.endFill();
         }
      }

      private function hideBusy() : void
      {
         if(this.busy != null && this.busy.parent != null)
         {
            this.busy.parent.removeChild(this.busy);
         }
      }

      private function onBusyCancel(param1:MouseEvent) : void
      {
         if(!this.batchRunning || Boolean(this.batchCancelled))
         {
            return;
         }
         this.batchCancelled = true;
         if(this.batchTimer == null)
         {
            this.finishBatch();
            return;
         }
         this.busyCancelTF.text = "Stopping…";
         this.busyCancelTF.x = Math.round((90 - this.busyCancelTF.width) / 2);
         this.busyCancel.mouseEnabled = false;
         this.updateBusy();
      }

      private function onSwapClick(param1:MouseEvent) : void
      {
         if(Boolean(this.batchRunning) || Boolean(this.swapPending) || this.selBankCount != 1 || this.selInvCount != 1 || this.rootClass == null)
         {
            return;
         }
         var _loc1_:Object = this.soleSelected(this.selBank);
         var _loc2_:Object = this.soleSelected(this.selInv);
         if(_loc1_ == null || _loc2_ == null)
         {
            return;
         }
         this.swapBankId = int(_loc1_.ItemID);
         this.swapInvId = int(_loc2_.ItemID);
         this.swapPending = true;
         this.resultMessage = null;
         this.stopStatusTimer();
         this.showBusy("Swapping items…",false);
         this.rootClass.world.sendBankSwapInvRequest(_loc1_,_loc2_);
         this.clearSide("bank");
         this.clearSide("inv");
         this.startSwapTimer();
      }

      private function startSwapTimer() : void
      {
         this.stopSwapTimer();
         this.swapTimer = new Timer(BATCH_TIMEOUT,1);
         this.swapTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSwapTimeout);
         this.swapTimer.start();
      }

      private function stopSwapTimer() : void
      {
         if(this.swapTimer != null)
         {
            this.swapTimer.stop();
            this.swapTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onSwapTimeout);
            this.swapTimer = null;
         }
      }

      private function onSwapTimeout(param1:TimerEvent) : void
      {
         this.stopSwapTimer();
         this.hideBusy();
         this.swapPending = false;
         this.resultMessage = "No response";
         this.afterSelectionChange();
         this.startStatusTimer();
      }

      private function checkSwapConfirmation() : void
      {
         if(this.rootClass == null)
         {
            return;
         }
         var _loc1_:Boolean = Boolean(this.idInInventory(this.swapBankId));
         var _loc2_:Boolean = Boolean(this.rootClass.world.bankinfo.isItemInBank(this.swapInvId));
         if(!_loc1_ || !_loc2_)
         {
            return;
         }
         this.stopSwapTimer();
         this.hideBusy();
         this.swapPending = false;
         this.resultMessage = "Swapped";
         this.afterSelectionChange();
         this.startStatusTimer();
      }

      private function soleSelected(param1:Dictionary) : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:* = param1;
         for(_loc1_ in _loc3_)
         {
            return _loc1_;
         }
         return null;
      }

      private function onWithdrawClick(param1:MouseEvent) : void
      {
         if(Boolean(this.batchRunning) || Boolean(this.swapPending) || this.selBankCount == 0)
         {
            return;
         }
         this.startBatch("withdraw");
      }

      private function onDepositClick(param1:MouseEvent) : void
      {
         if(Boolean(this.batchRunning) || Boolean(this.swapPending) || this.selInvCount == 0)
         {
            return;
         }
         this.startBatch("deposit");
      }

      private function afterSelectionChange() : void
      {
         this.updateHeaders();
         this.updateCenterButtons();
         this.updatePreview();
         this.drawCenterLine();
      }

      private function updatePreview() : void
      {
         if(this.rootClass == null)
         {
            return;
         }
         var _loc1_:MovieClip = getLayout();
         if(_loc1_ == null || !("previewPanel" in _loc1_) || _loc1_.previewPanel == null)
         {
            return;
         }
         if(this.selectionOrder.length > 0)
         {
            _loc1_.previewPanel.Show(this.selectionOrder[this.selectionOrder.length - 1]);
         }
         else
         {
            _loc1_.previewPanel.Hide();
         }
      }

      private function addToSelection(param1:String, param2:Object) : void
      {
         var _loc1_:Dictionary = param1 == "bank" ? this.selBank : this.selInv;
         if(param2 in _loc1_)
         {
            return;
         }
         _loc1_[param2] = true;
         if(param1 == "bank")
         {
            ++this.selBankCount;
         }
         else
         {
            ++this.selInvCount;
         }
         this.selectionOrder.push(param2);
      }

      private function removeFromSelection(param1:String, param2:Object) : void
      {
         var _loc1_:Dictionary = param1 == "bank" ? this.selBank : this.selInv;
         if(!(param2 in _loc1_))
         {
            return;
         }
         delete _loc1_[param2];
         if(param1 == "bank")
         {
            --this.selBankCount;
         }
         else
         {
            --this.selInvCount;
         }
         var _loc2_:int = int(this.selectionOrder.indexOf(param2));
         if(_loc2_ > -1)
         {
            this.selectionOrder.splice(_loc2_,1);
         }
      }

      private function moveToEndOfOrder(param1:Object) : void
      {
         var _loc1_:int = int(this.selectionOrder.indexOf(param1));
         if(_loc1_ > -1)
         {
            this.selectionOrder.splice(_loc1_,1);
         }
         this.selectionOrder.push(param1);
      }

      private function clearSide(param1:String) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         if(this.batchRunning)
         {
            return;
         }
         var _loc4_:Dictionary = param1 == "bank" ? this.selBank : this.selInv;
         var _loc5_:Array = [];
         for each(_loc1_ in this.selectionOrder)
         {
            if(!(_loc1_ in _loc4_))
            {
               _loc5_.push(_loc1_);
            }
         }
         this.selectionOrder = _loc5_;
         _loc2_ = [];
         for(_loc3_ in _loc4_)
         {
            _loc2_.push(_loc3_);
         }
         for each(_loc3_ in _loc2_)
         {
            delete _loc4_[_loc3_];
         }
         if(param1 == "bank")
         {
            this.selBankCount = 0;
            this.anchorBank = -1;
         }
         else
         {
            this.selInvCount = 0;
            this.anchorInv = -1;
         }
         if(param1 == "bank")
         {
            this.bankList.refreshHighlight();
         }
         else
         {
            this.invList.refreshHighlight();
         }
         this.afterSelectionChange();
      }

      private function selectAll(param1:String) : void
      {
         var _loc1_:Object = null;
         if(this.batchRunning)
         {
            return;
         }
         var _loc2_:Array = param1 == "bank" ? this.bankView : this.invView;
         for each(_loc1_ in _loc2_)
         {
            this.addToSelection(param1,_loc1_);
         }
         if(param1 == "bank")
         {
            this.bankList.refreshHighlight();
         }
         else
         {
            this.invList.refreshHighlight();
         }
         this.afterSelectionChange();
      }

      private function onAllBankClick(param1:MouseEvent) : void
      {
         this.selectAll("bank");
      }

      private function onNoneBankClick(param1:MouseEvent) : void
      {
         this.clearSide("bank");
      }

      private function onAllInvClick(param1:MouseEvent) : void
      {
         this.selectAll("inv");
      }

      private function onNoneInvClick(param1:MouseEvent) : void
      {
         this.clearSide("inv");
      }

      private function handleRowClick(param1:String, param2:Object, param3:int, param4:Boolean) : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(Boolean(this.batchRunning) || param2 == null)
         {
            return;
         }
         var _loc4_:Dictionary = param1 == "bank" ? this.selBank : this.selInv;
         var _loc5_:Array = param1 == "bank" ? this.bankView : this.invView;
         var _loc6_:int = param1 == "bank" ? int(this.anchorBank) : int(this.anchorInv);
         if(param4 && _loc6_ > -1 && _loc6_ < _loc5_.length && param3 > -1)
         {
            _loc1_ = _loc6_ < param3 ? _loc6_ : param3;
            _loc2_ = _loc6_ < param3 ? param3 : _loc6_;
            _loc3_ = _loc1_;
            while(_loc3_ <= _loc2_)
            {
               this.addToSelection(param1,_loc5_[_loc3_]);
               _loc3_++;
            }
            this.moveToEndOfOrder(param2);
         }
         else if(param2 in _loc4_)
         {
            this.removeFromSelection(param1,param2);
         }
         else
         {
            this.addToSelection(param1,param2);
         }
         if(param1 == "bank")
         {
            this.anchorBank = param3;
         }
         else
         {
            this.anchorInv = param3;
         }
         if(param1 == "bank")
         {
            this.bankList.refreshHighlight();
         }
         else
         {
            this.invList.refreshHighlight();
         }
         this.afterSelectionChange();
      }

      private function onBankRowClick(param1:Object, param2:int, param3:Boolean) : void
      {
         this.handleRowClick("bank",param1,param2,param3);
      }

      private function onInvRowClick(param1:Object, param2:int, param3:Boolean) : void
      {
         this.handleRowClick("inv",param1,param2,param3);
      }

      private function isInvEquipped(param1:Object) : Boolean
      {
         return param1 != null && (int(param1.bEquip) == 1 || int(param1.bWear) == 1);
      }

      private function setControlsEnabled(param1:Boolean) : void
      {
         if(this.bankList != null)
         {
            this.bankList.clicksEnabled = param1;
         }
         if(this.invList != null)
         {
            this.invList.clicksEnabled = param1;
         }
      }

      private function recordSkip(param1:String) : void
      {
         ++this.batchSkippedCount;
         this.batchSkipReasons[param1] = (this.batchSkipReasons[param1] != null ? int(this.batchSkipReasons[param1]) : 0) + 1;
      }

      private function buildSkipReasonText() : String
      {
         var _loc1_:String = null;
         var _loc2_:Array = [];
         for(_loc1_ in this.batchSkipReasons)
         {
            _loc2_.push(_loc1_);
         }
         return _loc2_.join(", ");
      }

      private function buildBatchOrder(param1:Dictionary, param2:Array, param3:Array) : Array
      {
         var _loc1_:Object = null;
         var _loc2_:Array = [];
         var _loc3_:Dictionary = new Dictionary(false);
         for each(_loc1_ in param2)
         {
            if(_loc1_ in param1)
            {
               _loc2_.push(_loc1_);
               _loc3_[_loc1_] = true;
            }
         }
         for each(_loc1_ in param3)
         {
            if(_loc1_ in param1 && !(_loc1_ in _loc3_))
            {
               _loc2_.push(_loc1_);
            }
         }
         return _loc2_;
      }

      private function prepareWithdrawQueue(param1:Array) : Array
      {
         var _loc1_:Object = null;
         var _loc2_:* = 0;
         var _loc3_:* = 0;
         var _loc4_:* = 0;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:Object = this.rootClass.world.myAvatar;
         var _loc8_:Object = this.getObjData();
         var _loc9_:Array = _loc7_.houseitems != null ? _loc7_.houseitems : [];
         var _loc10_:Object = {};
         for each(_loc1_ in _loc7_.items)
         {
            if(_loc1_ != null)
            {
               _loc10_[int(_loc1_.ItemID)] = true;
            }
         }
         for each(_loc1_ in _loc9_)
         {
            if(_loc1_ != null)
            {
               _loc10_[int(_loc1_.ItemID)] = true;
            }
         }
         _loc2_ = int(int(_loc8_.iBagSlots) - InvCat.countBag(_loc7_.items));
         _loc3_ = int(int(_loc8_.iBagSlots) - InvCat.countMisc(_loc7_.items));
         _loc4_ = int(int(_loc8_.iHouseSlots) - _loc9_.length);
         _loc5_ = [];
         for each(_loc6_ in param1)
         {
            if(_loc10_[int(_loc6_.ItemID)])
            {
               this.recordSkip("already in inventory");
            }
            else
            {
               if(InvCat.isHouse(_loc6_))
               {
                  if(_loc4_ <= 0)
                  {
                     this.recordSkip("house full");
                     continue;
                  }
                  _loc4_--;
               }
               else if(InvCat.isMisc(_loc6_))
               {
                  if(_loc3_ <= 0)
                  {
                     this.recordSkip("misc full");
                     continue;
                  }
                  _loc3_--;
               }
               else if(InvCat.isBag(_loc6_))
               {
                  if(_loc2_ <= 0)
                  {
                     this.recordSkip("bag full");
                     continue;
                  }
                  _loc2_--;
               }
               _loc5_.push(_loc6_);
            }
         }
         return _loc5_;
      }

      private function prepareDepositQueue(param1:Array) : Array
      {
         var _loc1_:Object = null;
         var _loc2_:Object = this.rootClass.world.myAvatar;
         var _loc3_:Object = this.getObjData();
         var _loc4_:* = int(int(_loc3_.iBankSlots) - int(_loc2_.iBankCount));
         var _loc5_:Array = [];
         for each(_loc1_ in param1)
         {
            if(int(_loc1_.bEquip) == 1)
            {
               this.recordSkip("equipped");
            }
            else
            {
               if(int(_loc1_.bCoins) != 1)
               {
                  if(_loc4_ <= 0)
                  {
                     this.recordSkip("bank full");
                     continue;
                  }
                  _loc4_--;
               }
               _loc5_.push(_loc1_);
            }
         }
         return _loc5_;
      }

      private function startBatch(param1:String) : void
      {
         if(Boolean(this.batchRunning) || Boolean(this.swapPending) || this.rootClass == null)
         {
            return;
         }
         this.flushRebuild();
         var _loc1_:Dictionary = param1 == "withdraw" ? this.selBank : this.selInv;
         var _loc2_:Array = param1 == "withdraw" ? this.bankView : this.invView;
         var _loc3_:Array = param1 == "withdraw" ? this.bankMaster : this.invMaster;
         var _loc4_:Array = this.buildBatchOrder(_loc1_,_loc2_,_loc3_);
         if(_loc4_.length == 0)
         {
            return;
         }
         this.resultMessage = null;
         this.stopStatusTimer();
         this.batchSkippedCount = 0;
         this.batchSkipReasons = {};
         this.batchTimedOut = new Dictionary();
         this.batchMovedCount = 0;
         this.batchDirection = param1;
         this.batchVerb = param1 == "withdraw" ? "Withdrawing" : "Depositing";
         this.batchQueue = param1 == "withdraw" ? this.prepareWithdrawQueue(_loc4_) : this.prepareDepositQueue(_loc4_);
         this.batchTotal = this.batchQueue.length;
         this.batchCancelled = false;
         this.batchWaitingResponse = false;
         this.batchLastSendTime = 0;
         if(this.batchTotal == 0)
         {
            this.setControlsEnabled(true);
            this.afterSelectionChange();
            this.showResult();
            return;
         }
         this.batchRunning = true;
         this.batchStartTime = getTimer();
         this.setControlsEnabled(false);
         this.afterSelectionChange();
         this.showBusy(this.batchVerb + " items…",true);
         this.sendNextBatchItem();
      }

      private function sendNextBatchItem() : void
      {
         if(Boolean(this.batchCancelled) || this.batchQueue.length == 0)
         {
            this.finishBatch();
            return;
         }
         var _loc1_:int = int(getTimer());
         var _loc2_:int = _loc1_ - this.batchLastSendTime;
         if(this.batchLastSendTime > 0 && _loc2_ < BATCH_MIN_GAP)
         {
            this.stopBatchTimer();
            this.batchTimer = new Timer(BATCH_MIN_GAP - _loc2_,1);
            this.batchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onBatchGapTimer);
            this.batchTimer.start();
            return;
         }
         this.doSendBatchItem();
      }

      private function onBatchGapTimer(param1:TimerEvent) : void
      {
         this.stopBatchTimer();
         this.sendNextBatchItem();
      }

      private function doSendBatchItem() : void
      {
         if(this.closed)
         {
            return;
         }
         if(this.rootClass == null || this.rootClass.world == null)
         {
            this.finishBatch();
            return;
         }
         var _loc1_:Object = this.batchQueue.shift();
         this.batchLastSendTime = getTimer();
         this.batchInFlightItem = _loc1_;
         this.batchInFlightId = int(_loc1_.ItemID);
         this.batchWaitingResponse = true;
         this.stopBatchTimer();
         this.batchTimer = new Timer(BATCH_TIMEOUT,1);
         this.batchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onBatchResponseTimeout);
         this.batchTimer.start();
         if(this.batchDirection == "withdraw")
         {
            this.rootClass.world.sendBankToInvRequest(_loc1_);
         }
         else
         {
            this.rootClass.world.sendBankFromInvRequest(_loc1_);
         }
         this.drawCenterLine();
         this.updateBusy();
         this.drawFooterSlots();
      }

      private function idInInventory(param1:int) : Boolean
      {
         var _loc1_:Object = null;
         var _loc2_:Object = this.rootClass.world.myAvatar;
         var _loc3_:Array = _loc2_.items != null ? _loc2_.items : [];
         var _loc4_:Array = _loc2_.houseitems != null ? _loc2_.houseitems : [];
         for each(_loc1_ in _loc3_)
         {
            if(_loc1_ != null && int(_loc1_.ItemID) == param1)
            {
               return true;
            }
         }
         for each(_loc1_ in _loc4_)
         {
            if(_loc1_ != null && int(_loc1_.ItemID) == param1)
            {
               return true;
            }
         }
         return false;
      }

      private function isBatchItemMoved(param1:int) : Boolean
      {
         var _loc1_:Boolean = Boolean(this.rootClass.world.bankinfo.isItemInBank(param1));
         var _loc2_:Boolean = Boolean(this.idInInventory(param1));
         return this.batchDirection == "withdraw" ? !_loc1_ && _loc2_ : !_loc2_ && _loc1_;
      }

      private function checkBatchConfirmation() : void
      {
         this.checkLateMoves();
         if(!this.isBatchItemMoved(this.batchInFlightId))
         {
            return;
         }
         ++this.batchMovedCount;
         this.advanceBatchFromResponse();
      }

      private function checkLateMoves() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         for(_loc1_ in this.batchTimedOut)
         {
            if(this.isBatchItemMoved(int(_loc1_)))
            {
               if(_loc3_ == null)
               {
                  _loc3_ = [];
               }
               _loc3_.push(_loc1_);
            }
         }
         if(_loc3_ == null)
         {
            return;
         }
         for each(_loc1_ in _loc3_)
         {
            delete this.batchTimedOut[_loc1_];
            ++this.batchMovedCount;
            if(this.batchSkippedCount > 0)
            {
               --this.batchSkippedCount;
            }
            _loc2_ = int(this.batchSkipReasons["no response"]) - 1;
            if(_loc2_ > 0)
            {
               this.batchSkipReasons["no response"] = _loc2_;
            }
            else
            {
               delete this.batchSkipReasons["no response"];
            }
         }
      }

      private function onBatchResponseTimeout(param1:TimerEvent) : void
      {
         this.stopBatchTimer();
         this.batchWaitingResponse = false;
         this.batchTimedOut[this.batchInFlightId] = true;
         this.recordSkip("no response");
         this.sendNextBatchItem();
      }

      private function advanceBatchFromResponse() : void
      {
         this.batchWaitingResponse = false;
         this.stopBatchTimer();
         this.updateBusy();
         this.sendNextBatchItem();
      }

      private function stopBatchTimer() : void
      {
         if(this.batchTimer != null)
         {
            this.batchTimer.stop();
            this.batchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onBatchGapTimer);
            this.batchTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onBatchResponseTimeout);
            this.batchTimer = null;
         }
      }

      private function finishBatch() : void
      {
         this.hideBusy();
         this.stopBatchTimer();
         if(this.rootClass != null && this.rootClass.world != null)
         {
            this.checkLateMoves();
         }
         this.batchRunning = false;
         this.flushRebuild();
         this.batchWaitingResponse = false;
         this.batchInFlightItem = null;
         this.batchInFlightId = 0;
         this.setControlsEnabled(true);
         this.afterSelectionChange();
         this.showResult();
      }

      private function showResult() : void
      {
         var _loc1_:String = "Moved " + this.batchMovedCount;
         if(this.batchSkippedCount > 0)
         {
            _loc1_ += " · " + this.batchSkippedCount + " skipped: " + this.buildSkipReasonText();
         }
         this.resultMessage = _loc1_;
         this.drawCenterLine();
         this.startStatusTimer();
      }

      private function startStatusTimer() : void
      {
         this.stopStatusTimer();
         this.statusTimer = new Timer(RESULT_MS,1);
         this.statusTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onStatusTimerComplete);
         this.statusTimer.start();
      }

      private function stopStatusTimer() : void
      {
         if(this.statusTimer != null)
         {
            this.statusTimer.stop();
            this.statusTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onStatusTimerComplete);
            this.statusTimer = null;
         }
      }

      private function onStatusTimerComplete(param1:TimerEvent) : void
      {
         this.stopStatusTimer();
         this.resultMessage = null;
         this.drawCenterLine();
      }

      private function buildPlusBtn() : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.lineStyle(1,12303291,1,true);
         _loc2_.beginFill(2763306);
         _loc2_.drawCircle(10,10,10);
         _loc2_.endFill();
         var _loc3_:TextField = LPFElementInvAQRow.makeTF(14,16777215,true);
         _loc3_.text = "+";
         _loc3_.x = Math.round((CIRCLE_D - _loc3_.width) / 2);
         _loc3_.y = Math.round((CIRCLE_D - _loc3_.height) / 2);
         _loc1_.addChild(_loc3_);
         _loc1_.buttonMode = true;
         _loc1_.mouseChildren = false;
         _loc1_.addEventListener(MouseEvent.CLICK,this.onPlusClick,false,0,true);
         addChild(_loc1_);
         return _loc1_;
      }

      private function buildFooter() : void
      {
         var goldIconCls:Class;
         var coinsIconCls:Class;
         var g:Graphics = null;
         var tf:TextField = null;
         this.tfBankSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         addChild(this.tfBankSlots);
         this.bankPlusBtn = this.buildPlusBtn();
         this.goldPill = new Sprite();
         this.goldPill.x = CENTER_X;
         this.goldPill.y = PILL_Y;
         rrectRow(this.goldPill.graphics,0,0,PILL_W,PILL_H,13,3815994);
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
         this.acPill.x = CENTER_X + CENTER_W - PILL_W;
         this.acPill.y = PILL_Y;
         rrectRow(this.acPill.graphics,0,0,PILL_W,PILL_H,13,3815994);
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
         this.helpBtn = new Sprite();
         this.helpBtn.x = this.acPill.x + PILL_W - CIRCLE_D - 3;
         this.helpBtn.y = PILL_Y + Math.round((PILL_H - CIRCLE_D) / 2);
         g = this.helpBtn.graphics;
         g.lineStyle(1,12303291,1,true);
         g.beginFill(2763306);
         g.drawCircle(10,10,10);
         g.endFill();
         tf = LPFElementInvAQRow.makeTF(12,16777215,true);
         tf.text = "?";
         tf.x = Math.round((CIRCLE_D - tf.width) / 2);
         tf.y = Math.round((CIRCLE_D - tf.height) / 2);
         this.helpBtn.addChild(tf);
         this.helpBtn.buttonMode = true;
         this.helpBtn.mouseChildren = false;
         this.helpBtn.addEventListener(MouseEvent.CLICK,this.onHelpClick,false,0,true);
         addChild(this.helpBtn);
         this.plusBtn = this.buildPlusBtn();
         this.tfItemSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         addChild(this.tfItemSlots);
         this.tfMiscSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         this.tfSlotSep = LPFListFooter.makeSeparator();
         addChild(this.tfSlotSep);
         addChild(this.tfMiscSlots);
      }

      private function getObjData() : Object
      {
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return null;
         }
         return this.rootClass.world.myAvatar.objData;
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
         param3.y = Math.round((PILL_H - param3.height) / 2);
      }

      private function drawPills() : void
      {
         var _loc1_:Object = this.getObjData();
         if(_loc1_ == null)
         {
            return;
         }
         LPFElementInvAQRow.setRuns(this.tfGold,this.rootClass.strNumWithCommas(int(_loc1_.intGold)),this.fmtWhiteB12,"g",this.fmtGoldB12);
         this.positionPillContent(this.goldIcon,this.goldCR,this.tfGold,PILL_W);
         this.tfCoins.text = this.rootClass.strNumWithCommas(int(_loc1_.intCoins));
         this.positionPillContent(this.coinsIcon,this.coinsCR,this.tfCoins,PILL_W - CIRCLE_D - 4);
      }

      private function layoutSpaceRow(param1:Sprite, param2:Boolean, param3:TextField, param4:int, param5:int, param6:int) : void
      {
         param1.visible = param2;
         param1.y = param6 - 3;
         var _loc1_:Number = 8;
         var _loc2_:Number = param2 ? CIRCLE_D + _loc1_ : 0;
         var _loc3_:Number = _loc2_ + param3.width;
         var _loc4_:Number = Math.round(param4 + (param5 - _loc3_) / 2);
         if(param2)
         {
            param1.x = _loc4_;
            param3.x = _loc4_ + CIRCLE_D + _loc1_;
         }
         else
         {
            param3.x = _loc4_;
         }
         param3.y = Math.round(param1.y + (CIRCLE_D - param3.height) / 2);
      }

      private function drawFooterSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = this.getObjData();
         if(_loc7_ == null || this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return;
         }
         var _loc8_:Object = this.rootClass.world.myAvatar;
         var _loc9_:int = int(_loc8_.iBankCount);
         var _loc10_:int = int(_loc7_.iBankSlots);
         LPFElementInvAQRow.setRuns(this.tfBankSlots,_loc9_ + " / " + _loc10_,_loc9_ >= _loc10_ ? this.fmtSlotRed : this.fmtSlotNum," Bank spaces",this.fmtSlotLabel);
         this.layoutSpaceRow(this.bankPlusBtn,true,this.tfBankSlots,BANK_LIST_X,BANK_LIST_W,SPACE_LABEL_Y1);
         var _loc11_:Boolean = HOUSE_FILTER_KEYS.indexOf(TABS[this.tabIdx].k) > -1;
         if(_loc11_)
         {
            _loc1_ = _loc8_.houseitems != null ? int(_loc8_.houseitems.length) : 0;
            _loc2_ = int(_loc7_.iHouseSlots);
            LPFElementInvAQRow.setRuns(this.tfItemSlots,_loc1_ + " / " + _loc2_,_loc1_ >= _loc2_ ? this.fmtSlotRed : this.fmtSlotNum," House spaces",this.fmtSlotLabel);
            this.tfMiscSlots.visible = false;
            LPFListFooter.layoutSlotLine(this.plusBtn,false,this.tfItemSlots,this.tfSlotSep,this.tfMiscSlots,INV_LIST_X,INV_LIST_W,SPACE_LABEL_Y1 - 3);
         }
         else
         {
            _loc3_ = InvCat.countBag(_loc8_.items);
            _loc4_ = int(_loc7_.iBagSlots);
            LPFElementInvAQRow.setRuns(this.tfItemSlots,_loc3_ + " / " + _loc4_,this.fmtSlotNum," Item spaces",this.fmtSlotLabel);
            _loc5_ = InvCat.countMisc(_loc8_.items);
            _loc6_ = _loc4_;
            LPFElementInvAQRow.setRuns(this.tfMiscSlots,_loc5_ + " / " + _loc6_,_loc5_ >= _loc6_ ? this.fmtSlotRed : this.fmtSlotNum," Misc spaces",this.fmtSlotLabel);
            this.tfMiscSlots.visible = true;
            LPFListFooter.layoutSlotLine(this.plusBtn,true,this.tfItemSlots,this.tfSlotSep,this.tfMiscSlots,INV_LIST_X,INV_LIST_W,SPACE_LABEL_Y1 - 3);
         }
      }

      private function onHelpClick(param1:MouseEvent) : void
      {
         update({"eventType":"helpAC"});
      }

      private function onPlusClick(param1:MouseEvent) : void
      {
         update({"eventType":"buyBagSlots"});
      }

      private function idKey(param1:*) : String
      {
         var _loc1_:String = param1 == null ? "" : String(int(param1));
         while(_loc1_.length < 10)
         {
            _loc1_ = "0" + _loc1_;
         }
         return _loc1_;
      }

      private function ensureKeys(param1:Array) : void
      {
         var _loc1_:Object = null;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         ensureSortRank();
         for each(_loc1_ in param1)
         {
            if(!(_loc1_ == null || _loc1_._aqk != null))
            {
               _loc2_ = sortRank[_loc1_.sType];
               _loc3_ = _loc2_ == null ? 99 : int(_loc2_);
               _loc4_ = _loc3_ < 10 ? "0" + _loc3_ : String(_loc3_);
               _loc5_ = 9999 - int(_loc1_.iLvl);
               _loc6_ = String(_loc5_);
               while(_loc6_.length < 4)
               {
                  _loc6_ = "0" + _loc6_;
               }
               _loc1_._aqn = String(_loc1_.sName).toLowerCase();
               _loc1_._aqk = _loc4_ + _loc1_._aqn + "\x01" + _loc6_ + "\x01" + this.idKey(_loc1_.ItemID) + "\x01" + this.idKey(_loc1_.CharItemID);
            }
         }
      }

      private function pruneSide(param1:String, param2:Dictionary, param3:Array) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         var _loc3_:Object = null;
         var _loc4_:Dictionary = new Dictionary(false);
         for each(_loc1_ in param3)
         {
            _loc4_[_loc1_] = true;
         }
         _loc2_ = [];
         for(_loc3_ in param2)
         {
            if(!(_loc3_ in _loc4_))
            {
               _loc2_.push(_loc3_);
            }
         }
         for each(_loc3_ in _loc2_)
         {
            this.removeFromSelection(param1,_loc3_);
         }
      }

      private function countTabs(param1:Array) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:int = int(TABS.length);
         var _loc8_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < _loc7_)
         {
            _loc8_[_loc1_] = 0;
            _loc1_++;
         }
         var _loc9_:Boolean = FavStore.count > 0;
         for each(_loc2_ in param1)
         {
            if(_loc2_ != null)
            {
               ++_loc8_[0];
               _loc3_ = String(_loc2_.sType);
               if(_loc3_ == "Enhancement")
               {
                  _loc1_ = 1;
                  while(_loc1_ < _loc7_)
                  {
                     if(TABS[_loc1_].k != "fav" && Boolean(itemMatchesTab(_loc2_,TABS[_loc1_].k)))
                     {
                        ++_loc8_[_loc1_];
                     }
                     _loc1_++;
                  }
               }
               else
               {
                  _loc4_ = this.typeTabs[_loc3_] as Array;
                  if(_loc4_ == null)
                  {
                     _loc4_ = [];
                     _loc1_ = 1;
                     while(_loc1_ < _loc7_)
                     {
                        _loc6_ = FILTER_MAP[TABS[_loc1_].k] as Array;
                        if(_loc6_ != null && _loc6_.indexOf(_loc3_) > -1)
                        {
                           _loc4_.push(_loc1_);
                        }
                        _loc1_++;
                     }
                     this.typeTabs[_loc3_] = _loc4_;
                  }
                  _loc5_ = int(_loc4_.length);
                  _loc1_ = 0;
                  while(_loc1_ < _loc5_)
                  {
                     ++_loc8_[_loc4_[_loc1_]];
                     _loc1_++;
                  }
               }
               if(_loc9_ && Boolean(FavStore.has(_loc2_.ItemID)))
               {
                  ++_loc8_[9];
               }
            }
         }
         this.tabCounts = _loc8_;
      }

      private function rebuildMasters() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Array = null;
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return;
         }
         var _loc3_:Array = this.rootClass.world.bankinfo.BankArray.concat();
         this.ensureKeys(_loc3_);
         _loc3_.sortOn("_aqk");
         this.bankMaster = _loc3_;
         this.rebuildRarityCounts();
         this.countTabs(_loc3_);
         var _loc4_:Object = this.rootClass.world.myAvatar;
         var _loc5_:Array = _loc4_.items != null ? _loc4_.items : [];
         var _loc6_:Array = [];
         for each(_loc1_ in _loc5_)
         {
            if(_loc1_ != null && !InvCat.isClass(_loc1_))
            {
               _loc6_.push(_loc1_);
            }
         }
         _loc2_ = _loc4_.houseitems != null ? _loc4_.houseitems : [];
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_ != null)
            {
               _loc6_.push(_loc1_);
            }
         }
         this.ensureKeys(_loc6_);
         _loc6_.sortOn("_aqk");
         this.invMaster = _loc6_;
         this.pruneSide("bank",this.selBank,this.bankMaster);
         this.pruneSide("inv",this.selInv,this.invMaster);
      }

      private function filterSide(param1:Array, param2:String, param3:String, param4:Boolean, param5:Array, param6:Boolean, param7:Boolean = false) : Array
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:int = int(TABS.length);
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            param5[_loc1_] = _loc1_ == 0;
            _loc1_++;
         }
         var _loc5_:* = int(_loc4_ - 1);
         var _loc6_:Array = [];
         var _loc7_:Array = param7 ? [] : null;
         var _loc8_:Array = FavStore.count > 0 ? [] : null;
         for each(_loc2_ in param1)
         {
            if(_loc2_ != null)
            {
               if(_loc5_ > 0)
               {
                  _loc3_ = 1;
                  while(_loc3_ < _loc4_)
                  {
                     if(!param5[_loc3_] && Boolean(itemMatchesTab(_loc2_,TABS[_loc3_].k)))
                     {
                        param5[_loc3_] = true;
                        _loc5_--;
                     }
                     _loc3_++;
                  }
               }
               if(Boolean(itemMatchesTab(_loc2_,param2)) && Boolean(this.chipMatches(_loc2_)) && (!param6 || Boolean(this.rarityMatches(_loc2_))) && (!param4 || String(_loc2_._aqn).indexOf(param3) > -1))
               {
                  if(_loc7_ != null && Boolean(this.isInvEquipped(_loc2_)))
                  {
                     _loc7_.push(_loc2_);
                  }
                  else if(_loc8_ != null && Boolean(FavStore.has(_loc2_.ItemID)))
                  {
                     _loc8_.push(_loc2_);
                  }
                  else
                  {
                     _loc6_.push(_loc2_);
                  }
               }
            }
         }
         if(_loc8_ != null && _loc8_.length > 0)
         {
            _loc6_ = _loc8_.concat(_loc6_);
         }
         if(_loc7_ != null && _loc7_.length > 0)
         {
            return _loc7_.concat(_loc6_);
         }
         return _loc6_;
      }

      private function rebuildViews(param1:Boolean) : void
      {
         var _loc1_:int = 0;
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return;
         }
         var _loc2_:String = this.searchQ.toLowerCase();
         var _loc3_:Boolean = _loc2_.length > 0;
         var _loc4_:String = TABS[this.tabIdx].k;
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = this.filterSide(this.bankMaster,_loc4_,_loc2_,_loc3_,_loc5_,true);
         var _loc8_:Array = this.filterSide(this.invMaster,_loc4_,_loc2_,_loc3_,_loc6_,false,_loc3_);
         var _loc9_:int = int(TABS.length);
         var _loc10_:Array = [];
         _loc1_ = 0;
         while(_loc1_ < _loc9_)
         {
            _loc10_[_loc1_] = _loc5_[_loc1_] || _loc6_[_loc1_];
            _loc1_++;
         }
         this.catOn = _loc10_;
         if(!this.catOn[this.tabIdx])
         {
            this.tabIdx = 0;
            this.rebuildViews(param1);
            return;
         }
         this.bankView = _loc7_;
         this.invView = _loc8_;
         this.anchorBank = -1;
         this.anchorInv = -1;
         this.tabRow.refresh(this.tabIdx,this.tabCounts,this.catOn);
         this.updateHeaders();
         var _loc11_:String = !this.bankLoaded ? "Loading bank…" : (_loc3_ ? "No results for \"" + this.searchQ + "\"" : "No items");
         var _loc12_:String = _loc3_ ? "No results for \"" + this.searchQ + "\"" : "No items";
         this.bankList.setView(this.bankView,_loc11_,param1);
         this.invList.setView(this.invView,_loc12_,param1);
         this.drawFooterSlots();
      }
   }
}

import flash.display.*;
import flash.events.*;
import flash.geom.*;
import flash.text.*;
import flash.utils.*;
import liteAssets.mobile.*;

class BankAQList extends Sprite
{

   private static const POOL_MAX:int = 16;

   public var onItemClick:Function;

   public var isRowEquipped:Function;

   public var selSet:Dictionary;

   public var clicksEnabled:Boolean = true;

   private var side:String;

   private var rootClass:MovieClip;

   private var listW:int;

   private var listH:int;

   private var rowW:int;

   private var view:Array = [];

   private var emptyMsg:String = "";

   private var hitFill:Shape;

   private var listBg:Shape;

   private var listBorder:Shape;

   private var listHolder:Sprite;

   private var sbTrack:Sprite;

   private var sbThumb:Sprite;

   private var tfEmpty:TextField;

   private var activeRows:Object = {};

   private var rowPool:Array = [];

   private var rowIndexMap:Dictionary = new Dictionary(false);

   private var tmpKeys:Array = [];

   private var scrollY:int = 0;

   private var touchScroll:TouchScroll;

   private var thumbH:int = 0;

   private var dragOff:Number = 0;

   private var dragStage:Stage;

   private var wheelStage:Stage;

   public function BankAQList(param1:String)
   {
      super();
      this.side = param1;
      this.hitFill = new Shape();
      this.listBg = new Shape();
      this.listBorder = new Shape();
      this.listHolder = new Sprite();
      this.sbTrack = new Sprite();
      this.sbThumb = new Sprite();
      this.sbTrack.addChild(this.sbThumb);
      this.tfEmpty = LPFElementInvAQRow.makeTF(12,7829367);
      this.tfEmpty.visible = false;
      addChild(this.hitFill);
      addChild(this.listBg);
      addChild(this.listHolder);
      addChild(this.listBorder);
      addChild(this.sbTrack);
      addChild(this.tfEmpty);
      this.touchScroll = TouchScroll.attach(this.listHolder,this.touchGetPos,this.touchSetPos,this.touchGetMax);
      addEventListener(Event.ADDED_TO_STAGE,this.onAddedHook,false,0,true);
      this.sbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown,false,0,true);
   }

   public function setup(param1:MovieClip, param2:int, param3:int) : void
   {
      this.rootClass = param1;
      this.listW = param2;
      this.listH = param3;
      this.rowW = this.listW - 10;
      var _loc1_:Graphics = this.hitFill.graphics;
      _loc1_.clear();
      _loc1_.beginFill(0,0);
      _loc1_.drawRect(0,0,this.listW,this.listH);
      _loc1_.endFill();
      _loc1_ = this.listBg.graphics;
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
      this.listHolder.scrollRect = new Rectangle(0,0,this.listW - 10,this.listH);
   }

   public function setView(param1:Array, param2:String, param3:Boolean) : void
   {
      this.view = param1;
      this.emptyMsg = param2;
      if(param3)
      {
         this.scrollY = 0;
      }
      this.updateEmpty();
      this.layoutRows(true);
   }

   public function refreshHighlight() : void
   {
      var _loc1_:String = null;
      var _loc2_:LPFElementInvAQRow = null;
      for(_loc1_ in this.activeRows)
      {
         _loc2_ = this.activeRows[_loc1_];
         _loc2_.bind(_loc2_.item,this.rootClass,this.selSet != null && _loc2_.item in this.selSet,this.eqOf(_loc2_.item));
      }
   }

   private function eqOf(param1:Object) : Boolean
   {
      return this.isRowEquipped != null ? Boolean(this.isRowEquipped(param1)) : false;
   }

   private function updateEmpty() : void
   {
      if(this.view.length == 0)
      {
         this.tfEmpty.text = this.emptyMsg;
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

   private function releaseSlot(param1:int) : void
   {
      var _loc1_:LPFElementInvAQRow = this.activeRows[param1];
      if(_loc1_ != null)
      {
         _loc1_.setHover(false);
         if(_loc1_.parent != null)
         {
            _loc1_.parent.removeChild(_loc1_);
         }
         if(this.rowPool.length < POOL_MAX)
         {
            this.rowPool.push(_loc1_);
         }
         else
         {
            this.destroyRow(_loc1_);
         }
      }
      delete this.activeRows[param1];
   }

   private function destroyRow(param1:LPFElementInvAQRow) : void
   {
      param1.removeEventListener(MouseEvent.CLICK,this.onRowClick);
      param1.removeEventListener(MouseEvent.ROLL_OVER,this.onRowOver);
      param1.removeEventListener(MouseEvent.ROLL_OUT,this.onRowOut);
      delete this.rowIndexMap[param1];
      param1.destroy();
   }

   private function layoutRows(param1:Boolean) : void
   {
      var _loc1_:String = null;
      var _loc2_:int = 0;
      var _loc3_:Object = null;
      var _loc4_:LPFElementInvAQRow = null;
      var _loc5_:int = LPFFrameInvAQ.ROW_H;
      var _loc6_:int = int(this.view.length);
      var _loc7_:Boolean = _loc6_ * _loc5_ > this.listH;
      var _loc8_:int = _loc7_ ? int(this.listW - 12) : int(this.listW - 2);
      if(_loc8_ != this.rowW)
      {
         this.rowW = _loc8_;
         param1 = true;
      }
      var _loc9_:int = _loc6_ * _loc5_ - this.listH;
      if(_loc9_ < 0)
      {
         _loc9_ = 0;
      }
      if(this.scrollY > _loc9_)
      {
         this.scrollY = _loc9_;
      }
      if(this.scrollY < 0)
      {
         this.scrollY = 0;
      }
      this.listHolder.scrollRect = new Rectangle(0,this.scrollY,_loc7_ ? this.listW - 10 : Number(this.listW),this.listH);
      var _loc10_:int = int(this.scrollY / _loc5_);
      var _loc11_:int = int((this.scrollY + this.listH - 1) / _loc5_);
      if(_loc11_ > _loc6_ - 1)
      {
         _loc11_ = _loc6_ - 1;
      }
      this.tmpKeys.length = 0;
      for(_loc1_ in this.activeRows)
      {
         _loc2_ = int(_loc1_);
         if(_loc2_ < _loc10_ || _loc2_ > _loc11_)
         {
            this.tmpKeys.push(_loc2_);
         }
      }
      for each(_loc2_ in this.tmpKeys)
      {
         this.releaseSlot(_loc2_);
      }
      _loc2_ = _loc10_;
      while(_loc2_ <= _loc11_)
      {
         _loc3_ = this.view[_loc2_];
         _loc4_ = this.activeRows[_loc2_];
         if(_loc4_ == null)
         {
            _loc4_ = this.acquireRow();
            this.activeRows[_loc2_] = _loc4_;
            this.rowIndexMap[_loc4_] = _loc2_;
            _loc4_.rowW = this.rowW;
            _loc4_.bind(_loc3_,this.rootClass,this.selSet != null && _loc3_ in this.selSet,this.eqOf(_loc3_));
            _loc4_.x = 0;
            _loc4_.y = _loc2_ * _loc5_;
            this.listHolder.addChild(_loc4_);
         }
         else if(param1)
         {
            _loc4_.rowW = this.rowW;
            _loc4_.bind(_loc3_,this.rootClass,this.selSet != null && _loc3_ in this.selSet,this.eqOf(_loc3_));
         }
         _loc2_++;
      }
      this.updateScrollbar();
   }

   private function updateScrollbar() : void
   {
      var _loc1_:Graphics = null;
      var _loc2_:Matrix = null;
      var _loc3_:int = LPFFrameInvAQ.ROW_H;
      var _loc4_:int = this.view.length * _loc3_;
      if(_loc4_ <= this.listH)
      {
         this.sbTrack.visible = false;
         return;
      }
      this.sbTrack.visible = true;
      var _loc5_:int = this.listH - 4;
      var _loc6_:int = int(this.listH * this.listH / _loc4_);
      if(_loc6_ < 24)
      {
         _loc6_ = 24;
      }
      if(_loc6_ > _loc5_)
      {
         _loc6_ = _loc5_;
      }
      if(_loc6_ != this.thumbH)
      {
         this.thumbH = _loc6_;
         _loc1_ = this.sbThumb.graphics;
         _loc1_.clear();
         _loc2_ = new Matrix();
         _loc2_.createGradientBox(8,this.thumbH,0,0,0);
         _loc1_.lineStyle(1,13145646,1,true);
         _loc1_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc2_);
         _loc1_.drawRoundRect(0,0,8,this.thumbH,8,8);
         _loc1_.endFill();
      }
      this.sbThumb.y = int((_loc5_ - this.thumbH) * this.scrollY / (_loc4_ - this.listH));
   }

   private function onAddedHook(param1:Event) : void
   {
      removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHook);
      if(this.wheelStage != null || stage == null)
      {
         return;
      }
      this.wheelStage = stage;
      this.wheelStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true,0,true);
   }

   private function onStageWheel(param1:MouseEvent) : void
   {
      if(this.wheelStage == null || !visible)
      {
         return;
      }
      if(hitTestPoint(param1.stageX,param1.stageY,true))
      {
         this.onWheel(param1);
      }
   }

   private function touchGetPos() : Number
   {
      return this.scrollY;
   }

   private function touchSetPos(param1:Number) : void
   {
      this.scrollY = int(param1);
      this.layoutRows(false);
   }

   private function touchGetMax() : Number
   {
      return Math.max(0,this.view.length * LPFFrameInvAQ.ROW_H - this.listH);
   }

   private function onWheel(param1:MouseEvent) : void
   {
      var _loc1_:int = LPFFrameInvAQ.ROW_H;
      if(this.view.length * _loc1_ <= this.listH)
      {
         return;
      }
      this.scrollY -= param1.delta * (_loc1_ / 3);
      this.layoutRows(false);
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
         this.layoutRows(false);
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
      this.layoutRows(false);
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
      if(!this.clicksEnabled)
      {
         return;
      }
      var _loc1_:LPFElementInvAQRow = LPFElementInvAQRow(param1.currentTarget);
      if(_loc1_.item == null)
      {
         return;
      }
      var _loc2_:int = this.rowIndexMap[_loc1_] != undefined ? int(this.rowIndexMap[_loc1_]) : -1;
      if(this.onItemClick != null)
      {
         this.onItemClick(_loc1_.item,_loc2_,param1.shiftKey);
      }
   }

   private function onRowOver(param1:MouseEvent) : void
   {
      LPFElementInvAQRow(param1.currentTarget).setHover(true);
   }

   private function onRowOut(param1:MouseEvent) : void
   {
      LPFElementInvAQRow(param1.currentTarget).setHover(false);
   }

   public function destroy() : void
   {
      var _loc1_:String = null;
      var _loc2_:int = 0;
      if(this.touchScroll != null)
      {
         this.touchScroll.detach();
         this.touchScroll = null;
      }
      this.removeDragListeners();
      removeEventListener(Event.ADDED_TO_STAGE,this.onAddedHook);
      if(this.wheelStage != null)
      {
         this.wheelStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onStageWheel,true);
         this.wheelStage = null;
      }
      this.sbTrack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onTrackDown);
      this.tmpKeys.length = 0;
      for(_loc1_ in this.activeRows)
      {
         this.tmpKeys.push(int(_loc1_));
      }
      for each(_loc2_ in this.tmpKeys)
      {
         this.releaseSlot(_loc2_);
      }
      this.activeRows = {};
      while(this.rowPool.length > 0)
      {
         this.destroyRow(this.rowPool.pop());
      }
      if(parent != null)
      {
         parent.removeChild(this);
      }
   }
}

class BankTabRow extends Sprite
{

   private static const KEY_W:int = 20;

   private static const KEY_H:int = 22;

   private static const KEY_GAP:int = 3;

   private static const TAB_GAP:int = 2;

   private static const PAD:int = 3;

   public var onSelect:Function;

   private var rowH:int;

   private var x0:int;

   private var x1:int;

   private var slot:int;

   private var btnP:Sprite;

   private var btnN:Sprite;

   private var clip:Sprite;

   private var touch:TouchScroll;

   private var sprites:Array = [];

   private var labels:Array = [];

   private var names:Array = [];

   private var widths:Array = [];

   private var xs:Array = [];

   private var stripW:int = 0;

   private var scrollX:int = 0;

   private var totalW:int = 0;

   private var needReveal:Boolean = true;

   private var selIdx:int = 0;

   private var enabled:Array = [];

   private var fmtName:TextFormat = new TextFormat("Arial",11,12303291,false);

   private var fmtSel:TextFormat = new TextFormat("Arial",11,16777215,true);

   private var fmtCount:TextFormat = new TextFormat("Arial",11,14725888,true);

   private var mtx:Matrix = new Matrix();

   public function BankTabRow(param1:String, param2:String, param3:int, param4:int, param5:int, param6:int)
   {
      super();
      this.rowH = param3;
      this.x0 = param4;
      this.x1 = param5;
      this.slot = param6;
      this.btnP = this.makeKeyBtn(param1);
      this.btnN = this.makeKeyBtn(param2);
      this.btnP.y = this.btnN.y = Math.round((param3 - KEY_H) / 2);
      this.clip = new Sprite();
      this.clip.scrollRect = this.tabRect();
      addChild(this.clip);
      addChild(this.btnP);
      addChild(this.btnN);
      this.touch = TouchScroll.attach(this.clip,this.getPos,this.setPos,this.getMax,true);
      this.btnP.addEventListener(MouseEvent.CLICK,this.onPrev,false,0,true);
      this.btnN.addEventListener(MouseEvent.CLICK,this.onNext,false,0,true);
   }

   public function destroy() : void
   {
      if(this.touch != null)
      {
         this.touch.detach();
         this.touch = null;
      }
      this.onSelect = null;
   }

   public function reveal() : void
   {
      this.needReveal = true;
   }

   public function setTabs(param1:Array, param2:Array) : void
   {
      var _loc1_:int = 0;
      var _loc2_:Sprite = null;
      var _loc3_:TextField = null;
      var _loc4_:DisplayObject = null;
      while(this.clip.numChildren > 0)
      {
         this.clip.removeChildAt(0);
      }
      this.sprites = [];
      this.labels = [];
      this.widths = [];
      this.xs = [];
      this.names = param1;
      _loc1_ = 0;
      while(_loc1_ < this.names.length)
      {
         _loc2_ = new Sprite();
         _loc2_.name = String(_loc1_);
         _loc2_.buttonMode = true;
         _loc2_.mouseChildren = false;
         if(param2 != null && param2[_loc1_] != null)
         {
            _loc4_ = param2[_loc1_];
            _loc4_.x = 5;
            _loc4_.y = Math.round((this.rowH - 14) / 2);
            _loc2_.addChild(_loc4_);
         }
         _loc3_ = LPFElementInvAQRow.makeTF(11,12303291);
         _loc2_.addChild(_loc3_);
         this.clip.addChild(_loc2_);
         this.sprites.push(_loc2_);
         this.labels.push(_loc3_);
         this.widths.push(0);
         this.xs.push(0);
         _loc2_.addEventListener(MouseEvent.CLICK,this.onTabClick,false,0,true);
         _loc1_++;
      }
      this.scrollX = 0;
      this.needReveal = true;
   }

   public function refresh(param1:int, param2:Array, param3:Array) : void
   {
      var _loc1_:int = 0;
      var _loc2_:Sprite = null;
      var _loc3_:TextField = null;
      var _loc4_:Boolean = false;
      var _loc5_:int = 0;
      var _loc6_:Graphics = null;
      var _loc7_:int = 0;
      this.selIdx = param1;
      this.enabled = param3 != null ? param3 : [];
      var _loc8_:int = 0;
      var _loc9_:int = this.rowH >= 24 ? 5 : 4;
      var _loc10_:int = this.slot > 0 ? int(5 + this.slot + 3) : 5;
      _loc1_ = 0;
      while(_loc1_ < this.sprites.length)
      {
         _loc2_ = this.sprites[_loc1_];
         _loc3_ = this.labels[_loc1_];
         _loc4_ = _loc1_ == param1;
         if(param2 != null)
         {
            LPFElementInvAQRow.setRuns(_loc3_,this.names[_loc1_],_loc4_ ? this.fmtSel : this.fmtName," (" + param2[_loc1_] + ")",_loc4_ ? this.fmtCount : this.fmtName);
         }
         else
         {
            LPFElementInvAQRow.setRuns(_loc3_,this.names[_loc1_],_loc4_ ? this.fmtSel : this.fmtName,"",this.fmtName);
         }
         _loc5_ = int(_loc3_.textWidth) + _loc10_ + 5;
         _loc6_ = _loc2_.graphics;
         _loc6_.clear();
         this.mtx.createGradientBox(_loc5_,this.rowH,Math.PI / 2,0,0);
         _loc6_.beginGradientFill(GradientType.LINEAR,_loc4_ ? [7030051,3021836] : [1776411,986895],[1,1],[0,255],this.mtx);
         _loc6_.moveTo(0,this.rowH);
         _loc6_.lineTo(0,_loc9_);
         _loc6_.curveTo(0,0,_loc9_,0);
         _loc6_.lineTo(_loc5_ - _loc9_,0);
         _loc6_.curveTo(_loc5_,0,_loc5_,_loc9_);
         _loc6_.lineTo(_loc5_,this.rowH);
         _loc6_.lineTo(0,this.rowH);
         _loc6_.endFill();
         _loc6_.lineStyle(1,_loc4_ ? 13145646 : 4473924,1,true);
         _loc6_.moveTo(0.5,this.rowH);
         _loc6_.lineTo(0.5,_loc9_);
         _loc6_.curveTo(0.5,0.5,_loc9_,0.5);
         _loc6_.lineTo(_loc5_ - _loc9_,0.5);
         _loc6_.curveTo(_loc5_ - 0.5,0.5,_loc5_ - 0.5,_loc9_);
         _loc6_.lineTo(_loc5_ - 0.5,this.rowH);
         _loc3_.x = _loc10_;
         _loc3_.y = Math.round((this.rowH - _loc3_.height) / 2);
         _loc2_.x = _loc8_;
         _loc4_ = _loc1_ >= this.enabled.length || Boolean(this.enabled[_loc1_]);
         _loc2_.alpha = _loc4_ ? 1 : 0.35;
         _loc2_.buttonMode = _loc4_;
         if(Mobile.active)
         {
            TouchTargets.pad(_loc2_,_loc5_ + 2,Mobile.touchPx(9),new Rectangle(_loc8_ - 1,-PAD,_loc5_ + 2,this.rowH + PAD * 2));
         }
         else
         {
            TouchTargets.unpad(_loc2_);
         }
         this.widths[_loc1_] = _loc5_;
         this.xs[_loc1_] = _loc8_;
         _loc8_ += _loc5_ + TAB_GAP;
         _loc1_++;
      }
      this.totalW = Math.max(0,_loc8_ - TAB_GAP);
      var _loc11_:int = this.totalW + (KEY_W + KEY_GAP) * 2;
      var _loc12_:int = this.x1 - this.x0;
      if(_loc11_ <= _loc12_)
      {
         _loc7_ = this.x0 + Math.round((_loc12_ - _loc11_) / 2);
         this.btnP.x = _loc7_;
         this.clip.x = _loc7_ + KEY_W + KEY_GAP;
         this.stripW = this.totalW;
         this.btnN.x = this.clip.x + this.totalW + KEY_GAP;
      }
      else
      {
         this.btnP.x = this.x0;
         this.clip.x = this.x0 + KEY_W + KEY_GAP;
         this.btnN.x = this.x1 - KEY_W;
         this.stripW = this.btnN.x - KEY_GAP - this.clip.x;
      }
      if(this.needReveal)
      {
         this.needReveal = false;
         this.ensureVisible();
      }
      else
      {
         this.clamp();
      }
   }

   public function step(param1:int) : void
   {
      var _loc1_:int = 0;
      var _loc2_:int = int(this.sprites.length);
      if(_loc2_ == 0)
      {
         return;
      }
      var _loc3_:int = int(this.selIdx);
      _loc1_ = 0;
      while(_loc1_ < _loc2_)
      {
         _loc3_ = (_loc3_ + param1 + _loc2_) % _loc2_;
         if(_loc3_ >= this.enabled.length || Boolean(this.enabled[_loc3_]))
         {
            break;
         }
         _loc1_++;
      }
      if(_loc1_ < _loc2_ && _loc3_ != this.selIdx && this.onSelect != null)
      {
         this.onSelect(_loc3_);
      }
   }

   private function makeKeyBtn(param1:String) : Sprite
   {
      var _loc1_:Sprite = new Sprite();
      LPFFrameBankAQ.rrect(_loc1_.graphics,0,0,KEY_W,KEY_H,4,2763306,5592405);
      var _loc2_:TextField = LPFElementInvAQRow.makeTF(11,16777215,true);
      _loc2_.text = param1;
      _loc2_.x = Math.round((KEY_W - _loc2_.width) / 2);
      _loc2_.y = Math.round((KEY_H - _loc2_.height) / 2);
      _loc1_.addChild(_loc2_);
      _loc1_.buttonMode = true;
      _loc1_.mouseChildren = false;
      return _loc1_;
   }

   private function onPrev(param1:MouseEvent) : void
   {
      this.step(-1);
   }

   private function onNext(param1:MouseEvent) : void
   {
      this.step(1);
   }

   private function onTabClick(param1:MouseEvent) : void
   {
      var _loc1_:int = int(DisplayObject(param1.currentTarget).name);
      if(_loc1_ == this.selIdx)
      {
         return;
      }
      if(_loc1_ < this.enabled.length && !this.enabled[_loc1_])
      {
         return;
      }
      if(this.onSelect != null)
      {
         this.onSelect(_loc1_);
      }
   }

   private function clamp() : void
   {
      var _loc1_:int = Math.max(0,this.totalW - this.stripW);
      if(this.scrollX > _loc1_)
      {
         this.scrollX = _loc1_;
      }
      if(this.scrollX < 0)
      {
         this.scrollX = 0;
      }
      this.clip.scrollRect = this.tabRect();
   }

   private function ensureVisible() : void
   {
      var _loc1_:int = 0;
      var _loc2_:int = 0;
      if(this.selIdx >= 0 && this.selIdx < this.sprites.length)
      {
         _loc1_ = int(this.xs[this.selIdx]);
         _loc2_ = int(this.widths[this.selIdx]);
         if(_loc1_ < this.scrollX)
         {
            this.scrollX = _loc1_;
         }
         if(_loc1_ + _loc2_ > this.scrollX + this.stripW)
         {
            this.scrollX = _loc1_ + _loc2_ - this.stripW;
         }
      }
      this.clamp();
   }

   private function tabRect() : Rectangle
   {
      var _loc1_:int = Mobile.active ? int(PAD) : 0;
      return new Rectangle(this.scrollX,-_loc1_,this.stripW,this.rowH + _loc1_ * 2);
   }

   private function getPos() : Number
   {
      return this.scrollX;
   }

   private function setPos(param1:Number) : void
   {
      this.scrollX = int(param1);
      this.clip.scrollRect = this.tabRect();
   }

   private function getMax() : Number
   {
      return Math.max(0,this.totalW - this.stripW);
   }
}
