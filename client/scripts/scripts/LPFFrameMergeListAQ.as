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

   public class LPFFrameMergeListAQ extends LPFFrame
   {

      private static const POOL_MAX:int = 16;

      private static const SEARCH_H:int = 22;

      private static const CHIP_W:int = 72;

      private static const CHIP_GAP:int = 4;

      private static const STRIP_W:int = 26;

      private static const STRIP_GAP:int = 4;

      private static const BTN_SIZE:int = 22;

      private static const BTN_GAP:int = 4;

      private static const UNKNOWN_RANK:int = 10000;

      private static const EMPTY:Array = [];

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
         "houseitems":["House","Wall Item","Floor Item"]
      };

      private static var sortRank:Object = null;

      private static const ROW_FILL_MTX:Matrix = new Matrix();

      private var rootClass:MovieClip;

      private var closed:Boolean = false;

      private var filterDefs:Array;

      private var subIdx:int = 0;

      private var subEnabled:Array = [];

      private var searchQ:String = "";

      private var searchFocused:Boolean = false;

      private var searchTimer:Timer;

      private var onlyMergeable:Boolean = false;

      private var view:Array = [];

      private var selItem:Object;

      private var scrollY:int = 0;

      private var touchScroll:TouchScroll;

      private var listX:int = 0;

      private var listW:int = 0;

      private var listH:int = 0;

      private var rowW:int = 0;

      private var searchW:int = 0;

      private var activeRows:Object = {};

      private var rowPool:Array = [];

      private var tmpKeys:Array = [];

      private var scrollRectR:Rectangle = new Rectangle();

      private var thumbH:int = 0;

      private var dragOff:Number = 0;

      private var dragStage:Stage;

      private var wheelStage:Stage;

      private var searchBox:Sprite;

      private var tfSearch:TextField;

      private var tfPlaceholder:TextField;

      private var chipMerge:Sprite;

      private var tfChip:TextField;

      private var subStrip:Sprite;

      private var subBtns:Array = [];

      private var listArea:Sprite;

      private var listBg:Shape;

      private var listBorder:Shape;

      private var listHolder:Sprite;

      private var footer:LPFListFooter;

      private var sbTrack:Sprite;

      private var sbThumb:Sprite;

      private var tfEmpty:TextField;

      public function LPFFrameMergeListAQ()
      {
         super();
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
         if(param2 == "*")
         {
            return true;
         }
         var _loc1_:Array = FILTER_MAP[param2] as Array;
         return _loc1_ != null && _loc1_.indexOf(param1.sType) > -1 || param1.sType == "Enhancement" && String(param1.sES).indexOf(param2) > -1;
      }

      private static function compareItems(param1:Object, param2:Object) : int
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc1_:Number = Number(param1.SortIndex);
         var _loc4_:Number = Number(param2.SortIndex);
         var _loc5_:int = !isNaN(_loc1_) && _loc1_ >= 0 ? int(_loc1_) : -1;
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
            _loc2_ = String(param1.sType);
            _loc3_ = String(param2.sType);
            if(_loc2_ != _loc3_)
            {
               return _loc2_ < _loc3_ ? -1 : 1;
            }
         }
         _loc2_ = String(param1.sName);
         _loc3_ = String(param2.sName);
         if(_loc2_ != _loc3_)
         {
            return _loc2_ < _loc3_ ? -1 : 1;
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
         eventTypes = ["refreshItems","listItemASel","refreshCoins","refreshSlots"];
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
         this.filterDefs = MovieClip(getLayout()).getTabStates();
         this.searchW = w - CHIP_W - CHIP_GAP;
         this.buildSearch();
         this.buildMergeChip();
         this.subStrip = new Sprite();
         this.subStrip.x = 0;
         this.subStrip.y = SEARCH_H + STRIP_GAP;
         addChild(this.subStrip);
         this.buildSubStrip();
         this.buildList();
         this.layoutList();
         this.rebuild();
         this.footer = new LPFListFooter(this.rootClass,w,this.onFooterPlus);
         this.footer.y = h + 4;
         addChild(this.footer);
         this.footer.drawPills();
         this.footer.drawSlots();
      }

      private function onFooterPlus() : void
      {
         update({"eventType":"buyBagSlots"});
      }

      override public function fClose() : void
      {
         var _loc15_:String = null;
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
         for(_loc15_ in this.activeRows)
         {
            this.destroyRow(this.activeRows[_loc15_]);
         }
         this.activeRows = {};
         while(this.rowPool.length > 0)
         {
            this.destroyRow(this.rowPool.pop());
         }
         if(this.footer != null)
         {
            this.footer.destroy();
            this.footer = null;
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
         var _loc16_:Object = null;
         if(Boolean(this.closed) || this.rootClass == null)
         {
            return;
         }
         switch(String(param1.eventType))
         {
            case "refreshItems":
               this.rebuild();
               if(this.footer != null)
               {
                  this.footer.drawSlots();
               }
               break;
            case "refreshCoins":
               if(this.footer != null)
               {
                  this.footer.drawPills();
               }
               break;
            case "refreshSlots":
               if(this.footer != null)
               {
                  this.footer.drawSlots();
               }
               break;
            case "listItemASel":
               _loc16_ = param1.fData != null ? param1.fData.oSel || param1.fData.iSel : null;
               if(_loc16_ != null)
               {
                  this.selItem = _loc16_;
               }
               this.refreshActiveRows();
         }
      }

      private function isMergeable(param1:Object) : Boolean
      {
         return Boolean(getLayout().canMergeItem(param1));
      }

      private function isHiddenLocked(param1:Object) : Boolean
      {
         return int(param1.bHide) == 1 && InvCat.isQuestLocked(param1,this.rootClass.world);
      }

      private function isSilhouetted(param1:Object) : Boolean
      {
         return int(param1.bSilhouette) == 1 && InvCat.isQuestLocked(param1,this.rootClass.world);
      }

      private function buildSearch() : void
      {
         var _loc15_:int = 0;
         _loc15_ = int(this.searchW);
         this.searchBox = new Sprite();
         this.searchBox.x = 0;
         this.searchBox.y = 0;
         var _loc16_:Graphics = this.searchBox.graphics;
         rrect(_loc16_,0,0,_loc15_,SEARCH_H,6,855309,3815994);
         var _loc1_:Number = _loc15_ - 14;
         var _loc4_:Number = SEARCH_H / 2;
         _loc16_.lineStyle(2,10066329,1,true);
         _loc16_.drawCircle(_loc1_,_loc4_,5);
         _loc16_.moveTo(_loc1_ + 3.5,_loc4_ + 3.5);
         _loc16_.lineTo(_loc1_ + 6.5,_loc4_ + 6.5);
         this.tfSearch = new TextField();
         this.tfSearch.embedFonts = false;
         this.tfSearch.type = TextFieldType.INPUT;
         this.tfSearch.selectable = true;
         this.tfSearch.mouseEnabled = true;
         this.tfSearch.multiline = false;
         this.tfSearch.wordWrap = false;
         this.tfSearch.maxChars = 40;
         this.tfSearch.restrict = null;
         this.tfSearch.defaultTextFormat = new TextFormat("Arial",11,16777215);
         this.tfSearch.text = "Wg";
         var _loc5_:Number = this.tfSearch.textHeight + 4;
         this.tfSearch.text = "";
         this.tfSearch.width = _loc15_ - 8 - 20;
         this.tfSearch.height = _loc5_;
         this.tfSearch.x = 8;
         this.tfSearch.y = Math.round((SEARCH_H - _loc5_) / 2);
         this.tfPlaceholder = LPFElementInvAQRow.makeTF(11,7829367);
         this.tfPlaceholder.text = "Search merges";
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

      private function buildMergeChip() : void
      {
         this.chipMerge = new Sprite();
         this.chipMerge.buttonMode = true;
         this.chipMerge.mouseChildren = false;
         this.chipMerge.x = this.searchW + CHIP_GAP;
         this.chipMerge.y = 0;
         this.tfChip = LPFElementInvAQRow.makeTF(10,12303291,true);
         this.tfChip.text = "Can merge";
         this.chipMerge.addChild(this.tfChip);
         this.chipMerge.addEventListener(MouseEvent.CLICK,this.onChipClick,false,0,true);
         addChild(this.chipMerge);
         this.drawChip();
      }

      private function drawChip() : void
      {
         var _loc15_:Graphics = this.chipMerge.graphics;
         _loc15_.clear();
         if(this.onlyMergeable)
         {
            rrect(_loc15_,0,0,CHIP_W,SEARCH_H,SEARCH_H / 2,1980948,8190976);
         }
         else
         {
            rrectRow(_loc15_,0,0,CHIP_W,SEARCH_H,SEARCH_H / 2,3815994);
         }
         this.tfChip.textColor = this.onlyMergeable ? 8190976 : 12303291;
         this.tfChip.x = Math.round((CHIP_W - this.tfChip.width) / 2);
         this.tfChip.y = Math.round((SEARCH_H - this.tfChip.height) / 2);
      }

      private function onChipClick(param1:MouseEvent) : void
      {
         this.onlyMergeable = !this.onlyMergeable;
         this.drawChip();
         this.scrollY = 0;
         this.rebuild();
      }

      private function buildSubStrip() : void
      {
         var _loc15_:int = 0;
         var _loc16_:Sprite = null;
         _loc15_ = 0;
         while(_loc15_ < this.filterDefs.length)
         {
            _loc16_ = new Sprite();
            _loc16_.name = String(_loc15_);
            _loc16_.y = _loc15_ * (BTN_SIZE + BTN_GAP);
            _loc16_.buttonMode = true;
            _loc16_.mouseChildren = false;
            this.addSubIcon(_loc16_,this.filterDefs[_loc15_].icon);
            _loc16_.addEventListener(MouseEvent.CLICK,this.onSubClick,false,0,true);
            _loc16_.addEventListener(MouseEvent.ROLL_OVER,this.onSubOver,false,0,true);
            _loc16_.addEventListener(MouseEvent.ROLL_OUT,this.onSubOut,false,0,true);
            this.subStrip.addChild(_loc16_);
            this.subBtns.push(_loc16_);
            _loc15_++;
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
               s = (BTN_SIZE - 4) / bh;
               if(bw * s > BTN_SIZE - 2)
               {
                  s = (BTN_SIZE - 2) / bw;
               }
               d.scaleX = d.scaleY = s;
            }
            LPFElementInvAQRow.centerAt(d,BTN_SIZE / 2,BTN_SIZE / 2);
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
         var _loc15_:int = 0;
         var _loc16_:Graphics = null;
         var _loc1_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:Sprite = null;
         var _loc6_:DisplayObject = null;
         _loc15_ = 0;
         while(_loc15_ < this.subBtns.length)
         {
            _loc5_ = this.subBtns[_loc15_];
            _loc1_ = _loc15_ == this.subIdx;
            _loc4_ = _loc15_ < this.subEnabled.length ? Boolean(this.subEnabled[_loc15_]) : true;
            _loc16_ = _loc5_.graphics;
            _loc16_.clear();
            if(_loc1_)
            {
               rrect(_loc16_,0,0,BTN_SIZE,BTN_SIZE,5,4862488,13145646);
            }
            else
            {
               rrectRow(_loc16_,0,0,BTN_SIZE,BTN_SIZE,5,3815994);
            }
            _loc5_.buttonMode = _loc4_;
            _loc6_ = _loc5_.numChildren > 0 ? DisplayObject(_loc5_.getChildAt(0)) : null;
            if(_loc6_ != null)
            {
               _loc6_.alpha = _loc4_ ? 1 : 0.3;
            }
            _loc15_++;
         }
      }

      private function onSubClick(param1:MouseEvent) : void
      {
         var _loc16_:int = int(DisplayObject(param1.currentTarget).name);
         if(_loc16_ == this.subIdx)
         {
            return;
         }
         if(_loc16_ < this.subEnabled.length && !this.subEnabled[_loc16_])
         {
            return;
         }
         this.subIdx = _loc16_;
         this.scrollY = 0;
         this.rebuild();
      }

      private function onSubOver(param1:MouseEvent) : void
      {
         var _loc16_:Object = this.filterDefs[int(DisplayObject(param1.currentTarget).name)];
         if(_loc16_ != null && this.rootClass != null)
         {
            this.rootClass.ui.ToolTip.openWith({"str":_loc16_.sTag});
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
         this.listX = STRIP_W + STRIP_GAP;
         this.listW = w - this.listX;
         this.listH = h - (SEARCH_H + STRIP_GAP);
         this.rowW = this.listW - 10;
         this.listArea.x = this.listX;
         this.listArea.y = SEARCH_H + STRIP_GAP;
         var _loc15_:Graphics = this.listBg.graphics;
         _loc15_.clear();
         _loc15_.beginFill(657930);
         _loc15_.drawRoundRect(0,0,this.listW,this.listH,8,8);
         _loc15_.endFill();
         _loc15_ = this.listBorder.graphics;
         _loc15_.clear();
         _loc15_.lineStyle(1,2763306,1,true);
         _loc15_.drawRoundRect(0,0,this.listW,this.listH,8,8);
         this.sbTrack.x = this.listW - 10;
         this.sbTrack.y = 2;
         _loc15_ = this.sbTrack.graphics;
         _loc15_.clear();
         _loc15_.beginFill(1710618);
         _loc15_.drawRoundRect(0,0,8,this.listH - 4,8,8);
         _loc15_.endFill();
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

      private function rebuild() : void
      {
         var _loc1_:int = 0;
         var _loc4_:Object = null;
         var _loc9_:int = 0;
         if(this.rootClass == null)
         {
            return;
         }
         if(sortRank == null)
         {
            sortRank = {};
            _loc9_ = 0;
            while(_loc9_ < SORT_ORDER.length)
            {
               sortRank[SORT_ORDER[_loc9_]] = _loc9_;
               _loc9_++;
            }
         }
         var _loc15_:Array = fData != null && fData.list != null ? fData.list : EMPTY;
         var _loc16_:int = int(this.filterDefs.length);
         var _loc5_:Boolean = false;
         this.subEnabled = [];
         _loc1_ = 0;
         while(_loc1_ < _loc16_)
         {
            this.subEnabled.push(_loc1_ == 0);
            _loc1_++;
         }
         for each(_loc4_ in _loc15_)
         {
            if(!(_loc4_ == null || Boolean(this.isHiddenLocked(_loc4_))))
            {
               this.markFilterEnabled(this.subEnabled,_loc4_);
            }
         }
         if(_loc16_ > 0 && this.subIdx < _loc16_ && !this.subEnabled[this.subIdx])
         {
            this.subIdx = 0;
         }
         var _loc6_:String = _loc16_ > 0 ? String(this.filterDefs[this.subIdx].filter) : "*";
         var _loc7_:String = this.searchQ.toLowerCase();
         var _loc8_:Boolean = _loc7_.length > 0;
         this.view = [];
         for each(_loc4_ in _loc15_)
         {
            if(!(_loc4_ == null || Boolean(this.isHiddenLocked(_loc4_))))
            {
               if(_loc4_ === this.selItem)
               {
                  _loc5_ = true;
               }
               if(itemMatchesFilter(_loc4_,_loc6_))
               {
                  if(!(_loc8_ && String(_loc4_.sName).toLowerCase().indexOf(_loc7_) < 0))
                  {
                     if(!(Boolean(this.onlyMergeable) && !this.isMergeable(_loc4_)))
                     {
                        this.view.push(_loc4_);
                     }
                  }
               }
            }
         }
         if(!_loc5_)
         {
            this.selItem = null;
         }
         this.view.sort(compareItems);
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
         var _loc15_:LPFElementInvAQRow = new LPFElementInvAQRow();
         _loc15_.addEventListener(MouseEvent.CLICK,this.onRowClick,false,0,true);
         _loc15_.addEventListener(MouseEvent.ROLL_OVER,this.onRowOver,false,0,true);
         _loc15_.addEventListener(MouseEvent.ROLL_OUT,this.onRowOut,false,0,true);
         return _loc15_;
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
         var _loc1_:Boolean = Boolean(this.isSilhouetted(param2));
         param1.locked = _loc1_;
         param1.silhouette = _loc1_;
         var _loc4_:Object = this.rootClass.world.shopinfo;
         param1.limitedStock = _loc4_ != null && Boolean(_loc4_.bLimited);
         param1.markCheck = !_loc1_ && InvCat.isOwned(param2,this.rootClass.world);
         param1.bind(param2,this.rootClass,param2 === this.selItem,false);
      }

      private function layoutRows(param1:Boolean = false) : void
      {
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:LPFElementInvAQRow = null;
         var _loc10_:Object = null;
         var _loc16_:int = int(this.view.length);
         var _loc1_:int = _loc16_ * LPFFrameInvAQ.ROW_H > this.listH ? int(this.listW - 12) : int(this.listW - 2);
         if(_loc1_ != this.rowW)
         {
            this.rowW = _loc1_;
            param1 = true;
         }
         var _loc4_:int = _loc16_ * LPFFrameInvAQ.ROW_H - this.listH;
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(this.scrollY > _loc4_)
         {
            this.scrollY = _loc4_;
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
         var _loc5_:int = int(this.scrollY / LPFFrameInvAQ.ROW_H);
         var _loc6_:int = int((this.scrollY + this.listH - 1) / LPFFrameInvAQ.ROW_H);
         if(_loc6_ > _loc16_ - 1)
         {
            _loc6_ = _loc16_ - 1;
         }
         this.tmpKeys.length = 0;
         for(_loc7_ in this.activeRows)
         {
            _loc8_ = int(_loc7_);
            if(_loc8_ < _loc5_ || _loc8_ > _loc6_)
            {
               this.tmpKeys.push(_loc8_);
            }
         }
         for each(_loc8_ in this.tmpKeys)
         {
            this.releaseRow(this.activeRows[_loc8_]);
            delete this.activeRows[_loc8_];
         }
         _loc8_ = _loc5_;
         while(_loc8_ <= _loc6_)
         {
            _loc10_ = this.view[_loc8_];
            _loc9_ = this.activeRows[_loc8_];
            if(_loc9_ == null)
            {
               _loc9_ = this.acquireRow();
               this.activeRows[_loc8_] = _loc9_;
               _loc9_.rowW = this.rowW;
               this.bindRow(_loc9_,_loc10_);
               _loc9_.y = _loc8_ * LPFFrameInvAQ.ROW_H;
               this.listHolder.addChild(_loc9_);
            }
            else if(param1)
            {
               _loc9_.rowW = this.rowW;
               this.bindRow(_loc9_,_loc10_);
            }
            _loc8_++;
         }
         this.updateScrollbar();
      }

      private function onFavChanged() : void
      {
         if(!this.closed && this.rootClass != null)
         {
            this.refreshActiveRows();
         }
      }

      private function refreshActiveRows() : void
      {
         var _loc15_:String = null;
         var _loc16_:LPFElementInvAQRow = null;
         for(_loc15_ in this.activeRows)
         {
            _loc16_ = this.activeRows[_loc15_];
            this.bindRow(_loc16_,_loc16_.item);
         }
      }

      private function updateScrollbar() : void
      {
         var _loc4_:Graphics = null;
         var _loc5_:Matrix = null;
         var _loc15_:int = this.view.length * LPFFrameInvAQ.ROW_H;
         if(_loc15_ <= this.listH)
         {
            this.sbTrack.visible = false;
            return;
         }
         this.sbTrack.visible = true;
         var _loc16_:int = this.listH - 4;
         var _loc1_:int = int(this.listH * this.listH / _loc15_);
         if(_loc1_ < 24)
         {
            _loc1_ = 24;
         }
         if(_loc1_ > _loc16_)
         {
            _loc1_ = _loc16_;
         }
         if(_loc1_ != this.thumbH)
         {
            this.thumbH = _loc1_;
            _loc4_ = this.sbThumb.graphics;
            _loc5_ = new Matrix();
            _loc5_.createGradientBox(8,this.thumbH,0,0,0);
            _loc4_.clear();
            _loc4_.lineStyle(1,13145646,1,true);
            _loc4_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc5_);
            _loc4_.drawRoundRect(0,0,8,this.thumbH,8,8);
            _loc4_.endFill();
         }
         this.sbThumb.y = int((_loc16_ - this.thumbH) * this.scrollY / (_loc15_ - this.listH));
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
         var _loc16_:Number = this.listH - 4 - this.thumbH;
         var _loc1_:int = this.view.length * LPFFrameInvAQ.ROW_H - this.listH;
         if(_loc16_ <= 0 || _loc1_ <= 0)
         {
            return;
         }
         var _loc4_:Number = this.sbTrack.mouseY - this.dragOff;
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         else if(_loc4_ > _loc16_)
         {
            _loc4_ = _loc16_;
         }
         this.scrollY = int(_loc4_ / _loc16_ * _loc1_);
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
         var _loc16_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc16_ == null || _loc16_.item == null || this.rootClass == null)
         {
            return;
         }
         if(this.rootClass.isGreedyModalInStack())
         {
            return;
         }
         var _loc1_:Object = _loc16_.item;
         this.selItem = _loc1_;
         update({
            "eventType":"listItemASel",
            "fData":_loc1_
         });
      }

      private function onRowOver(param1:MouseEvent) : void
      {
         var _loc16_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc16_ != null)
         {
            _loc16_.setHover(true);
         }
      }

      private function onRowOut(param1:MouseEvent) : void
      {
         var _loc16_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc16_ != null)
         {
            _loc16_.setHover(false);
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
         var _loc15_:String = this.tfSearch.text;
         if(_loc15_ == this.searchQ)
         {
            return;
         }
         this.searchQ = _loc15_;
         this.scrollY = 0;
         this.rebuild();
      }
   }
}
