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

   public class LPFFrameEnhListAQ extends LPFFrame
   {

      private static const POOL_MAX:int = 16;

      private static const SEARCH_H:int = 22;

      private static const SEARCH_GAP:int = 4;

      private static const LVL_RESERVE:int = 34;

      private static const UNKNOWN_RANK:int = 10000;

      private static const GOLD:uint = 14725888;

      private static const GREEN:uint = 8190976;

      private static const RED:uint = 16729156;

      private static const GREY:uint = 10066329;

      private static const EMPTY:Array = [];

      private static const SORT_ORDER:Array = ["Note","Resource","Item","Quest Item","ServerUse","Enhancement","Sword","Axe","Gauntlet","Dagger","HandGun","Rifle","Gun","Whip","Bow","Mace","Polearm","Staff","Wand","Class","Armor","Helm","Cape","Misc","Earring","Amulet","Necklace","Belt","Ring","Pet"];

      private static var sortRank:Object = null;

      private var rootClass:MovieClip;

      private var closed:Boolean = false;

      private var direction:String = "items";

      private var searchQ:String = "";

      private var searchFocused:Boolean = false;

      private var searchTimer:Timer;

      private var view:Array = [];

      private var selItem:Object;

      private var bestEnh:Object;

      private var scrollY:int = 0;

      private var touchScroll:TouchScroll;

      private var listX:int = 0;

      private var listW:int = 0;

      private var listH:int = 0;

      private var rowW:int = 0;

      private var activeRows:Object = {};

      private var rowPool:Array = [];

      private var tmpKeys:Array = [];

      private var scrollRectR:Rectangle = new Rectangle();

      private var thumbH:int = 0;

      private var dragOff:Number = 0;

      private var dragStage:Stage;

      private var wheelStage:Stage;

      private var overlays:Dictionary = new Dictionary();

      private var deltaFmt:TextFormat = new TextFormat("Arial",11,GREY,true);

      private var starFmt:TextFormat = new TextFormat("Arial",11,GOLD,true);

      private var searchBox:Sprite;

      private var tfSearch:TextField;

      private var tfPlaceholder:TextField;

      private var listArea:Sprite;

      private var listBg:Shape;

      private var listBorder:Shape;

      private var listHolder:Sprite;

      private var sbTrack:Sprite;

      private var sbThumb:Sprite;

      private var tfEmpty:TextField;

      public function LPFFrameEnhListAQ()
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
         eventTypes = ["refreshItems","listItemASel","listItemBSel","sModeSet"];
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
         this.buildSearch();
         this.buildList();
         this.layoutList();
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
         if(Boolean(this.closed) || this.rootClass == null)
         {
            return;
         }
         switch(String(param1.eventType))
         {
            case "listItemASel":
               this.direction = getLayout().eSel != null ? "items" : "enh";
               this.searchQ = "";
               if(this.tfSearch != null)
               {
                  this.tfSearch.text = "";
               }
               this.setPlaceholderText();
               this.updatePlaceholder();
               this.scrollY = 0;
               this.rebuild();
               break;
            case "listItemBSel":
               this.selItem = this.direction == "enh" ? getLayout().eSel : getLayout().iSel;
               this.refreshActiveRows();
               break;
            case "refreshItems":
               this.rebuild();
         }
      }

      private function playerLevel() : int
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = this.rootClass.world.myAvatar;
            if(_loc1_.dataLeaf != null && _loc1_.dataLeaf.intLevel != null)
            {
               return int(_loc1_.dataLeaf.intLevel);
            }
            return int(_loc1_.objData.intLevel);
         }
         catch(e:Error)
         {
         }
         return int.MAX_VALUE;
      }

      private function statVal(param1:Object, param2:String) : int
      {
         var _loc1_:* = param1["$" + param2];
         return _loc1_ != null ? int(_loc1_) : 0;
      }

      private function statDelta(param1:Object, param2:Object) : int
      {
         var _loc1_:String = null;
         var _loc2_:int = 0;
         var _loc3_:Object = this.rootClass.getStatsA(param2,param1.sES);
         var _loc4_:Object = this.rootClass.getStatsA(param1,param1.sES);
         for each(_loc1_ in this.rootClass.orderedStats)
         {
            _loc2_ += this.statVal(_loc3_,_loc1_) - this.statVal(_loc4_,_loc1_);
         }
         return _loc2_;
      }

      private function buildSearch() : void
      {
         var _loc1_:int = 0;
         _loc1_ = w;
         this.searchBox = new Sprite();
         this.searchBox.x = 0;
         this.searchBox.y = 0;
         var _loc2_:Graphics = this.searchBox.graphics;
         rrect(_loc2_,0,0,_loc1_,SEARCH_H,6,855309,3815994);
         var _loc3_:Number = _loc1_ - 14;
         var _loc4_:Number = SEARCH_H / 2;
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
         this.tfSearch.defaultTextFormat = new TextFormat("Arial",11,16777215);
         this.tfSearch.text = "Wg";
         var _loc5_:Number = this.tfSearch.textHeight + 4;
         this.tfSearch.text = "";
         this.tfSearch.width = _loc1_ - 8 - 20;
         this.tfSearch.height = _loc5_;
         this.tfSearch.x = 8;
         this.tfSearch.y = Math.round((SEARCH_H - _loc5_) / 2);
         this.tfPlaceholder = LPFElementInvAQRow.makeTF(11,7829367);
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
         this.setPlaceholderText();
      }

      private function setPlaceholderText() : void
      {
         this.tfPlaceholder.text = this.direction == "items" ? "Search items" : "Search enhancements";
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
         this.listX = 0;
         this.listW = w;
         this.listH = h - (SEARCH_H + SEARCH_GAP);
         this.rowW = this.listW - 10;
         this.listArea.x = this.listX;
         this.listArea.y = SEARCH_H + SEARCH_GAP;
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

      private function rebuild() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.rootClass == null)
         {
            return;
         }
         this.closeTip();
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
         var _loc4_:Array = fData != null && fData.list != null ? fData.list : EMPTY;
         var _loc5_:Object = this.direction == "enh" ? getLayout().iSel : getLayout().eSel;
         this.selItem = this.direction == "enh" ? getLayout().eSel : getLayout().iSel;
         var _loc6_:int = int(this.playerLevel());
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:Boolean = false;
         var _loc10_:Array = [];
         if(_loc5_ != null)
         {
            for each(_loc1_ in _loc4_)
            {
               if(_loc1_ != null)
               {
                  if(this.direction == "enh")
                  {
                     if(String(_loc1_.sType).toLowerCase() != "enhancement" || _loc1_.sES != _loc5_.sES)
                     {
                        continue;
                     }
                  }
                  else if(String(_loc1_.sType).toLowerCase() == "enhancement" || _loc1_.sES != _loc5_.sES)
                  {
                     continue;
                  }
                  _loc10_.push(_loc1_);
               }
            }
         }
         if(this.direction == "enh")
         {
            for each(_loc1_ in _loc10_)
            {
               if(int(_loc1_.iLvl) <= _loc6_)
               {
                  _loc2_ = int(this.statDelta(_loc5_,_loc1_));
                  if(!_loc9_ || _loc2_ > _loc8_)
                  {
                     _loc7_ = _loc1_;
                     _loc8_ = _loc2_;
                     _loc9_ = true;
                  }
               }
            }
         }
         this.bestEnh = _loc8_ > 0 ? _loc7_ : null;
         var _loc11_:String = this.searchQ.toLowerCase();
         var _loc12_:Boolean = _loc11_.length > 0;
         this.view = [];
         for each(_loc1_ in _loc10_)
         {
            if(!(_loc12_ && String(_loc1_.sName).toLowerCase().indexOf(_loc11_) < 0))
            {
               this.view.push(_loc1_);
            }
         }
         this.view.sort(compareItems);
         this.updateEmpty();
         this.layoutRows(true);
      }

      private function updateEmpty() : void
      {
         if(this.view.length == 0)
         {
            this.tfEmpty.text = this.searchQ.length > 0 ? "No results for \"" + this.searchQ + "\"" : (this.direction == "enh" ? "No enhancements" : "No items");
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

      private function closeTip() : void
      {
         if(this.rootClass != null && this.rootClass.ui != null && this.rootClass.ui.ToolTip != null)
         {
            this.rootClass.ui.ToolTip.close();
         }
      }

      private function releaseRow(param1:LPFElementInvAQRow) : void
      {
         if(param1.locked)
         {
            this.closeTip();
         }
         param1.setHover(false);
         this.clearOverlay(param1);
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
         this.clearOverlay(param1);
         param1.destroy();
      }

      private function clearOverlay(param1:LPFElementInvAQRow) : void
      {
         var _loc1_:TextField = this.overlays[param1];
         if(_loc1_ != null)
         {
            if(_loc1_.parent != null)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            delete this.overlays[param1];
         }
      }

      private function drawDelta(param1:LPFElementInvAQRow, param2:Object) : void
      {
         var _loc1_:Object = getLayout().iSel;
         if(_loc1_ == null)
         {
            this.clearOverlay(param1);
            return;
         }
         var _loc2_:int = int(this.statDelta(_loc1_,param2));
         var _loc3_:String = _loc2_ > 0 ? "+" + _loc2_ : (_loc2_ < 0 ? String(_loc2_) : "±0");
         var _loc4_:uint = _loc2_ > 0 ? uint(GREEN) : (_loc2_ < 0 ? uint(RED) : uint(GREY));
         this.deltaFmt.color = _loc4_;
         var _loc5_:String = param2 === this.bestEnh ? "★ " : "";
         var _loc6_:TextField = this.overlays[param1];
         if(_loc6_ == null)
         {
            _loc6_ = LPFElementInvAQRow.makeTF(11,_loc4_,true);
            param1.addChild(_loc6_);
            this.overlays[param1] = _loc6_;
         }
         LPFElementInvAQRow.setRuns(_loc6_,_loc5_,this.starFmt,_loc3_,this.deltaFmt);
         _loc6_.x = param1.rowW - LVL_RESERVE - _loc6_.width;
         _loc6_.y = Math.round((LPFFrameInvAQ.ROW_H - _loc6_.height) / 2);
      }

      private function bindRow(param1:LPFElementInvAQRow, param2:Object) : void
      {
         param1.priceText = null;
         param1.priceCoins = false;
         param1.limitedStock = false;
         if(param1.locked)
         {
            this.closeTip();
         }
         var _loc1_:Boolean = this.direction == "enh" && int(param2.iLvl) > this.playerLevel();
         param1.locked = _loc1_;
         var _loc2_:Boolean = this.direction == "items" && (param2.bEquip == 1 || param2.bWear == 1);
         param1.bind(param2,this.rootClass,param2 === this.selItem,_loc2_);
         param1.alpha = _loc1_ ? 0.45 : 1;
         param1.buttonMode = !_loc1_;
         if(this.direction == "enh")
         {
            this.drawDelta(param1,param2);
         }
         else
         {
            this.clearOverlay(param1);
         }
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
         if(!this.closed && this.rootClass != null)
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
         if(_loc1_ == null || _loc1_.item == null || _loc1_.locked || this.rootClass == null)
         {
            return;
         }
         if(this.rootClass.isGreedyModalInStack())
         {
            return;
         }
         update({
            "eventType":"listItemBSel",
            "fData":_loc1_.item
         });
      }

      private function onRowOver(param1:MouseEvent) : void
      {
         var _loc1_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.locked)
         {
            if(this.rootClass != null)
            {
               this.rootClass.ui.ToolTip.openWith({"str":"Level requirement not met"});
            }
         }
         else
         {
            _loc1_.setHover(true);
         }
      }

      private function onRowOut(param1:MouseEvent) : void
      {
         var _loc1_:LPFElementInvAQRow = param1.currentTarget as LPFElementInvAQRow;
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.locked)
         {
            if(this.rootClass != null)
            {
               this.rootClass.ui.ToolTip.close();
            }
         }
         else
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

      public function getSelectedItems() : Array
      {
         var _loc1_:Object = getLayout().iSel;
         return _loc1_ != null ? [_loc1_.ItemID] : [];
      }

      public function getSelected() : int
      {
         return getLayout().iSel != null ? 1 : 0;
      }
   }
}
