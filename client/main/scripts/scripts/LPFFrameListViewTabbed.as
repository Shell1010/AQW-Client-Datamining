package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1919")]
   public class LPFFrameListViewTabbed extends LPFFrame
   {

      private static const SEARCH_X:int = 34;

      private static const SEARCH_H:int = 20;

      public var bgList:MovieClip;

      public var bgTabs:MovieClip;

      public var iList:MovieClip;

      public var listMask:MovieClip;

      public var scr:LPFElementScrollBar;

      public var tMsg:TextField;

      public var tabs:MovieClip;

      private var listA:Array = [];

      private var aSel:Array = [];

      private var iSel:Object;

      private var tSel:Object;

      private var tabStates:Array = [];

      private var filterMap:Object = {};

      private var itemEventType:String;

      private var tabEventType:String;

      private var sortOrder:Array = [];

      private var filter:String = "";

      private var allowDesel:Boolean = false;

      private var onDemand:Boolean = false;

      private var openBlank:Boolean = false;

      private var refreshTabs:Boolean = false;

      private var bLimited:Boolean = false;

      private var multiSelect:Boolean = false;

      private var excludeTypes:Array = [];

      private var search:Boolean = false;

      private var searchQ:String = "";

      private var searchFocused:Boolean = false;

      private var searchTimer:Timer;

      private var searchBox:Sprite;

      private var tfSearch:TextField;

      private var tfPlaceholder:TextField;

      private var tfNone:TextField;

      private var held:Dictionary = new Dictionary();

      private var closed:Boolean = false;

      private var shadeO:Object;

      private var itemList:Array;

      public function LPFFrameListViewTabbed()
      {
         super();
         x = 0;
         y = 0;
         fData = {};
      }

      override public function fOpen(param1:Object) : void
      {
         fData = param1.fData;
         this.itemList = fData.list;
         positionBy(param1.r);
         this.drawBG();
         if("tabStates" in param1)
         {
            this.tabStates = param1.tabStates;
         }
         if("filterMap" in param1)
         {
            this.filterMap = param1.filterMap;
         }
         if("sortOrder" in param1)
         {
            this.sortOrder = param1.sortOrder;
         }
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("filter" in param1)
         {
            this.filter = param1.filter;
         }
         if("itemEventType" in param1)
         {
            this.itemEventType = param1.itemEventType;
         }
         if("tabEventType" in param1)
         {
            this.tabEventType = param1.tabEventType;
         }
         if("sName" in param1)
         {
            sName = param1.sName;
         }
         if("allowDesel" in param1)
         {
            this.allowDesel = param1.allowDesel == true;
         }
         if("openBlank" in param1)
         {
            this.openBlank = param1.openBlank == true;
         }
         if("onDemand" in param1)
         {
            this.onDemand = param1.onDemand == true;
         }
         if("refreshTabs" in param1)
         {
            this.refreshTabs = param1.refreshTabs == true;
         }
         if("multiSelect" in param1)
         {
            this.multiSelect = param1.multiSelect == true;
         }
         if("excludeTypes" in param1)
         {
            this.excludeTypes = param1.excludeTypes;
         }
         if("search" in param1)
         {
            this.search = param1.search == true;
         }
         if(this.search)
         {
            this.buildSearch();
         }
         if("bLimited" in fData)
         {
            this.bLimited = param1.fData.bLimited == true;
         }
         if(!this.openBlank)
         {
            if(this.iSel == null)
            {
               this.tSel = this.getTabByFilter("*");
            }
            else
            {
               this.tSel = this.getTabByFilter(this.iSel.sType);
            }
         }
         this.initTabs();
         this.fDraw();
         getLayout().registerForEvents(this,eventTypes);
      }

      private function fRefresh(param1:Object) : void
      {
         if("tabStates" in param1)
         {
            this.tabStates = param1.tabStates;
         }
         if("filterMap" in param1)
         {
            this.filterMap = param1.filterMap;
         }
         if("sortOrder" in param1)
         {
            this.sortOrder = param1.sortOrder;
         }
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("filter" in param1)
         {
            this.filter = param1.filter;
         }
         if("itemEventType" in param1)
         {
            this.itemEventType = param1.itemEventType;
         }
         if("tabEventType" in param1)
         {
            this.tabEventType = param1.tabEventType;
         }
         if("sName" in param1)
         {
            sName = param1.sName;
         }
         this.iSel = null;
         this.shadeO = null;
         this.resetSearch();
         this.tSel = this.getTabByFilter("*");
         if(fData.list != null)
         {
            this.itemList = fData.list;
         }
         this.initTabs();
         this.fDraw();
      }

      private function initTabs() : void
      {
         var _loc1_:Object = null;
         var _loc2_:MovieClip = null;
         var _loc3_:Object = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc1_ = {};
         var _loc8_:Array = [];
         var _loc9_:String = "";
         while(this.tabs.numChildren > 0)
         {
            this.tabs.removeChildAt(0);
         }
         this.bgTabs.graphics.clear();
         _loc7_ = 0;
         while(_loc7_ < this.tabStates.length)
         {
            if(this.onDemand)
            {
               this.tabStates[_loc7_].state = 0;
            }
            else
            {
               this.tabStates[_loc7_].state = -1;
               for each(_loc1_ in fData.list)
               {
                  for(_loc5_ in this.filterMap)
                  {
                     if(this.filterMap[_loc5_].indexOf(_loc1_.sType) > -1 || _loc1_.sType == "Enhancement" && _loc1_.sES == _loc5_)
                     {
                        if(this.tabStates[_loc7_].filter == _loc5_)
                        {
                           this.tabStates[_loc7_].state = 0;
                        }
                     }
                  }
               }
            }
            _loc7_++;
         }
         _loc8_ = [];
         _loc6_ = 0;
         while(_loc6_ < this.tabStates.length)
         {
            _loc1_ = this.tabStates[_loc6_];
            _loc2_ = this.tabs.addChild(new LPFElementListViewTab()) as MovieClip;
            _loc3_ = getLayout().rootClass.world.getClass(_loc1_.icon);
            _loc4_ = _loc2_.icon.addChild(new _loc3_());
            _loc4_.scaleX = _loc4_.scaleY = 16 / _loc4_.height;
            _loc4_.x -= _loc4_.width / 2;
            _loc4_.y = 2;
            _loc2_.icon.mouseEnabled = false;
            _loc2_.icon.mouseChildren = false;
            _loc2_.o = _loc1_;
            _loc1_.mc = _loc2_;
            _loc2_.bg2.visible = false;
            if(_loc1_ == this.tSel)
            {
               _loc1_.state = 1;
            }
            if(_loc1_.state == -1)
            {
               _loc2_.icon.alpha = 0.3;
               _loc2_.bg3.visible = true;
               _loc2_.bg2.visible = false;
               _loc2_.bg.visible = false;
               _loc2_.mouseEnabled = false;
               _loc2_.mouseChildren = false;
            }
            else
            {
               _loc2_.bg3.visible = false;
               _loc2_.buttonMode = true;
               if(_loc1_.state == 1)
               {
                  _loc2_.bg.visible = false;
                  _loc2_.bg2.visible = true;
               }
               _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.tabClick,false,0,true);
            }
            _loc2_.x = int((_loc2_.width + 3) * _loc6_) + 1;
            _loc8_.push(_loc2_.getBounds(this.bgTabs));
            _loc6_++;
         }
         this.drawTabBG();
         this.layoutSearch();
      }

      private function fDraw(param1:Boolean = true, param2:Boolean = false) : void
      {
         var _loc1_:String = null;
         var _loc2_:MovieClip = null;
         var _loc3_:LPFElementListItemItem = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:DisplayObject = null;
         this.listA = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Object = {};
         param2 &&= Boolean(this.multiSelect);
         if(param2)
         {
            _loc10_ = 0;
            while(_loc10_ < this.iList.numChildren)
            {
               _loc2_ = MovieClip(this.iList.getChildAt(_loc10_));
               if(_loc2_.sel)
               {
                  this.held[_loc2_.fData] = true;
               }
               else
               {
                  delete this.held[_loc2_.fData];
               }
               _loc10_++;
            }
         }
         else
         {
            this.held = new Dictionary();
            this.shadeO = null;
         }
         if(this.tfNone != null)
         {
            this.tfNone.visible = false;
         }
         while(this.iList.numChildren > 0)
         {
            LPFElementListItem(this.iList.getChildAt(0)).fClose();
         }
         if(param1)
         {
            this.iList.y = this.bgTabs.height - 1;
         }
         if(this.tSel == null)
         {
            this.setMessage("No Tab Selected");
            this.scr.fOpen({
               "subject":this.iList,
               "subjectMask":this.listMask,
               "reset":param1
            });
            return;
         }
         this.setMessage("");
         if(this.tSel.filter != "*")
         {
            for each(_loc12_ in this.itemList)
            {
               if(this.excludeTypes.indexOf(_loc12_.sType) <= -1)
               {
                  if(this.filterMap[this.tSel.filter].indexOf(_loc12_.sType) > -1 || _loc12_.sType == "Enhancement" && _loc12_.sES.indexOf(this.tSel.filter) > -1)
                  {
                     if(!(this.tSel.filter == "pots" && (_loc12_.sLink != "potion" && _loc12_.sLink != "elixir" && _loc12_.sLink != "tonic" && _loc12_.sLink != "scroll")))
                     {
                        _loc9_.push(_loc12_);
                     }
                  }
               }
            }
         }
         else if(this.excludeTypes.length > 0)
         {
            _loc9_ = [];
            for each(_loc12_ in this.itemList)
            {
               if(this.excludeTypes.indexOf(_loc12_.sType) <= -1)
               {
                  _loc9_.push(_loc12_);
               }
            }
         }
         else
         {
            _loc9_ = this.itemList;
         }
         if(this.searchQ.length > 0)
         {
            _loc1_ = this.searchQ.toLowerCase();
            _loc6_ = [];
            for each(_loc12_ in _loc9_)
            {
               if(_loc12_ != null && String(_loc12_.sName).toLowerCase().indexOf(_loc1_) > -1)
               {
                  _loc6_.push(_loc12_);
               }
            }
            _loc9_ = _loc6_;
            if(_loc6_.length == 0)
            {
               this.showNone();
            }
         }
         if(Boolean(this.onDemand) && _loc9_.length == 0)
         {
            this.setMessage("No items of this type");
            this.scr.fOpen({
               "subject":this.iList,
               "subjectMask":this.listMask,
               "reset":param1
            });
            return;
         }
         _loc10_ = 0;
         while(_loc10_ < this.sortOrder.length)
         {
            _loc6_ = [];
            for each(_loc12_ in _loc9_)
            {
               if(_loc12_.sType == this.sortOrder[_loc10_])
               {
                  _loc6_.push(_loc12_);
               }
            }
            if(_loc6_.length > 0)
            {
               _loc6_.sortOn(["sName","iLvl"],[undefined,Array.DESCENDING | Array.NUMERIC]);
               this.listA = this.listA.concat(_loc6_);
            }
            _loc10_++;
         }
         _loc6_ = [];
         for each(_loc12_ in _loc9_)
         {
            if(this.listA.indexOf(_loc12_) == -1)
            {
               _loc6_.push(_loc12_);
            }
         }
         if(_loc6_.length > 0)
         {
            _loc6_.sortOn(["sType","sName"]);
            this.listA = this.listA.concat(_loc6_);
         }
         var _loc13_:Object = {};
         _loc13_.eventType = this.itemEventType;
         _loc13_.allowDesel = this.allowDesel;
         _loc13_.multiSelect = this.multiSelect;
         _loc13_.bLimited = this.bLimited && getLayout().sMode == "shopBuy";
         _loc10_ = 0;
         while(_loc10_ < this.listA.length)
         {
            _loc13_.fData = this.listA[_loc10_];
            _loc3_ = new LPFElementListItemItem();
            _loc4_ = this.iList.addChild(_loc3_);
            _loc3_.subscribeTo(this);
            _loc3_.fOpen(_loc13_);
            if(param2)
            {
               if(this.held[_loc3_.fData] == true)
               {
                  _loc3_.select();
               }
               delete this.held[_loc3_.fData];
            }
            else if(_loc3_.fData == this.iSel)
            {
               _loc3_.select();
            }
            if(_loc10_ > 0)
            {
               _loc5_ = this.iList.getChildAt(_loc10_ - 1);
               _loc4_.y = _loc5_.y + _loc5_.height;
            }
            _loc10_++;
         }
         this.scr.fOpen({
            "subject":this.iList,
            "subjectMask":this.listMask,
            "reset":param1
         });
      }

      private function getTabByFilter(param1:String) : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.tabStates.length)
         {
            _loc1_ = this.tabStates[_loc2_];
            if(_loc1_.filter == param1)
            {
               return _loc1_;
            }
            _loc2_++;
         }
         if(this.tabStates.length > 0 && param1 != "none")
         {
            return this.tabStates[0];
         }
         return null;
      }

      private function tabClick(param1:MouseEvent) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = MovieClip(param1.currentTarget).o;
         if(this.tSel != null)
         {
            this.tSel.mc.bg.visible = true;
            this.tSel.mc.bg2.visible = false;
            this.tSel.state = 0;
         }
         this.tSel = _loc2_;
         this.tSel.mc.bg.visible = false;
         this.tSel.mc.bg2.visible = true;
         this.tSel.state = 1;
         this.drawTabBG();
         if(this.onDemand)
         {
            _loc1_ = {
               "fData":{"types":this.filterMap[this.tSel.filter]},
               "eventType":this.tabEventType,
               "fCaller":sName
            };
            while(this.iList.numChildren > 0)
            {
               LPFElementListItem(this.iList.getChildAt(0)).fClose();
            }
            this.iList.y = this.bgTabs.height - 1;
            this.update(_loc1_);
         }
         else
         {
            this.fDraw();
         }
      }

      private function drawTabBG() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Rectangle = null;
         var _loc3_:MovieClip = null;
         var _loc4_:Graphics = this.bgTabs.graphics;
         var _loc5_:int = this.bgTabs.bg.height - 1;
         _loc4_.clear();
         _loc4_.lineStyle(0,6710886,1);
         _loc4_.moveTo(0,_loc5_);
         if(this.tSel != null)
         {
            _loc3_ = this.tSel.mc;
            if(_loc3_.x > 1)
            {
               _loc4_.lineTo(this.tSel.mc.x,_loc5_);
            }
            _loc4_.moveTo(this.tSel.mc.x + this.tSel.mc.width,_loc5_);
            _loc4_.lineTo(this.bgList.width,_loc5_);
            --this.tSel.mc.x;
            this.bgTabs.bg.visible = true;
         }
         else
         {
            _loc4_.lineTo(this.bgList.width,_loc5_);
            this.bgTabs.bg.visible = false;
         }
      }

      private function setMessage(param1:String) : void
      {
         if(param1 != null && param1.length > 0)
         {
            this.tMsg.text = param1;
            this.tMsg.visible = true;
         }
         else
         {
            this.tMsg.text = "";
            this.tMsg.visible = false;
         }
      }

      override public function update(param1:Object) : void
      {
         if(param1.eventType == this.itemEventType)
         {
            this.iSel = param1.fData;
         }
         if(param1.eventType == this.tabEventType)
         {
            this.iSel = null;
         }
         getLayout().update(param1);
      }

      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "sModeSet")
         {
            fData = param1.fData;
            this.fRefresh(param1);
         }
         if(param1.eventType == "refreshItems")
         {
            if(fData.isBank)
            {
               this.itemList = getLayout().rootClass.world.bankinfo.items;
            }
            if(this.itemList.indexOf(this.iSel) == -1)
            {
               this.iSel = null;
            }
            this.fDraw(false);
            if(this.refreshTabs)
            {
               this.initTabs();
            }
         }
         if(param1.eventType == "refreshInv")
         {
            this.itemList = getLayout().rootClass.world.myAvatar.filtered_inventory;
            this.fDraw(true);
         }
         if(param1.eventType == "refreshBank")
         {
            if(fData.isBank)
            {
               this.itemList = getLayout().rootClass.world.bankinfo.items;
            }
            this.fDraw(fData.isBank != null);
         }
         if(param1.eventType == "listItemASel")
         {
            this.fRefresh(param1);
            if(this.filter != "")
            {
               this.shadeO = param1.fData;
               this.shadeListByTypeFilter(param1.fData);
            }
         }
         if(param1.eventType == this.tabEventType && param1.fData != null)
         {
            if("loadPending" in param1.fData)
            {
               if("msg" in param1.fData)
               {
                  this.setMessage(param1.fData.msg);
               }
            }
         }
      }

      private function shadeListByTypeFilter(param1:Object) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         if(param1.eSel != null)
         {
            _loc2_ = param1.eSel;
         }
         if(param1.iSel != null)
         {
            _loc2_ = param1.iSel;
         }
         if(_loc2_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < this.iList.numChildren)
            {
               _loc1_ = this.iList.getChildAt(_loc3_) as MovieClip;
               if(_loc1_.fData[this.filter] == _loc2_[this.filter] && _loc1_.fData.sType != _loc2_.sType)
               {
                  _loc1_.alpha = 1;
                  _loc1_.mouseEnabled = true;
                  _loc1_.mouseChildren = true;
               }
               else
               {
                  _loc1_.alpha = 0.3;
                  _loc1_.mouseEnabled = false;
                  _loc1_.mouseChildren = false;
               }
               _loc3_++;
            }
         }
      }

      public function getListItemByiSel() : MovieClip
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.iList.numChildren)
         {
            _loc1_ = MovieClip(this.iList.getChildAt(_loc2_));
            if(_loc1_.fData == this.iSel)
            {
               return _loc1_;
            }
            _loc2_++;
         }
         return null;
      }

      public function getSelected() : int
      {
         var _loc1_:MovieClip = null;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         while(_loc4_ < this.iList.numChildren)
         {
            _loc1_ = MovieClip(this.iList.getChildAt(_loc4_));
            if(_loc1_.sel)
            {
               _loc3_ += 1;
            }
            _loc4_++;
         }
         for(_loc2_ in this.held)
         {
            _loc3_ += 1;
         }
         return _loc3_;
      }

      public function getSelectedItems() : Array
      {
         var _loc1_:MovieClip = null;
         var _loc2_:* = undefined;
         var _loc3_:Array = [];
         var _loc4_:* = 0;
         while(_loc4_ < this.iList.numChildren)
         {
            _loc1_ = MovieClip(this.iList.getChildAt(_loc4_));
            if(_loc1_.sel)
            {
               _loc3_.push(_loc1_.fData.ItemID);
            }
            _loc4_++;
         }
         for(_loc2_ in this.held)
         {
            _loc3_.push(_loc2_.ItemID);
         }
         return _loc3_;
      }

      override public function fClose() : void
      {
         if(!this.closed)
         {
            this.closed = true;
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
            this.held = new Dictionary();
         }
         super.fClose();
      }

      private function buildSearch() : void
      {
         if(this.searchBox != null)
         {
            return;
         }
         var _loc1_:int = w - SEARCH_X - 1;
         this.searchBox = new Sprite();
         this.searchBox.x = SEARCH_X;
         this.searchBox.y = 1;
         var _loc2_:Graphics = this.searchBox.graphics;
         _loc2_.lineStyle(1,3815994,1,true);
         _loc2_.beginFill(855309);
         _loc2_.drawRoundRect(0,0,_loc1_,SEARCH_H,12,12);
         _loc2_.endFill();
         var _loc3_:Number = _loc1_ - 14;
         var _loc4_:Number = SEARCH_H / 2;
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
         this.tfSearch.multiline = false;
         this.tfSearch.wordWrap = false;
         this.tfSearch.maxChars = 40;
         this.tfSearch.defaultTextFormat = MailArt.fmt(11,16777215);
         this.tfSearch.text = "Wg";
         var _loc5_:Number = this.tfSearch.textHeight + 4;
         this.tfSearch.text = "";
         this.tfSearch.width = _loc1_ - 8 - 20;
         this.tfSearch.height = _loc5_;
         this.tfSearch.x = 8;
         this.tfSearch.y = Math.round((SEARCH_H - _loc5_) / 2);
         this.tfPlaceholder = MailArt.tf(11,7829367);
         this.tfPlaceholder.text = "Search items";
         this.tfPlaceholder.x = 8;
         this.tfPlaceholder.y = this.tfSearch.y;
         this.searchBox.addChild(this.tfSearch);
         this.searchBox.addChild(this.tfPlaceholder);
         addChild(this.searchBox);
         this.tfNone = MailArt.tf(12,10066329);
         this.tfNone.mouseEnabled = false;
         this.tfNone.visible = false;
         addChild(this.tfNone);
         this.tfSearch.addEventListener(Event.CHANGE,this.onSearchChange,false,0,true);
         this.tfSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onSearchKey,false,0,true);
         this.tfSearch.addEventListener(KeyboardEvent.KEY_UP,this.onSearchKey,false,0,true);
         this.tfSearch.addEventListener(FocusEvent.FOCUS_IN,this.onSearchFocus,false,0,true);
         this.tfSearch.addEventListener(FocusEvent.FOCUS_OUT,this.onSearchFocus,false,0,true);
         SearchAssist.attach(getLayout().rootClass,this.searchBox,this.tfSearch,this.tfPlaceholder,_loc1_,SEARCH_H,855309);
         this.searchTimer = new Timer(150,1);
         this.searchTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onSearchTimer,false,0,true);
      }

      private function layoutSearch() : void
      {
         if(this.searchBox == null)
         {
            return;
         }
         this.searchBox.visible = this.tabs.numChildren <= 1;
         if(!this.searchBox.visible)
         {
            this.resetSearch();
         }
      }

      private function resetSearch() : void
      {
         if(this.searchBox == null)
         {
            return;
         }
         if(this.searchTimer != null)
         {
            this.searchTimer.reset();
         }
         this.searchQ = "";
         if(this.tfSearch.length > 0)
         {
            this.tfSearch.text = "";
            this.tfSearch.dispatchEvent(new Event(Event.CHANGE));
         }
         this.updatePlaceholder();
      }

      private function showNone() : void
      {
         if(this.tfNone == null)
         {
            return;
         }
         this.tfNone.text = "No results for \"" + this.searchQ + "\"";
         MailArt.cover(this.tfNone);
         MailArt.fit(this.tfNone,w - 20);
         this.tfNone.x = Math.round((w - this.tfNone.width) / 2);
         this.tfNone.y = Math.round(this.bgList.y + 30);
         this.tfNone.visible = true;
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

      private function onSearchFocus(param1:FocusEvent) : void
      {
         this.searchFocused = param1.type == FocusEvent.FOCUS_IN;
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
         this.fDraw(true,true);
         if(this.shadeO != null)
         {
            this.shadeListByTypeFilter(this.shadeO);
         }
      }

      private function drawBG() : void
      {
         this.bgList.width = w;
         this.bgList.height = h - this.listMask.y + 3;
         this.bgList.y = this.listMask.y;
         this.listMask.width = w;
         this.listMask.height = h - this.listMask.y - 0;
         this.scr.b.height = this.listMask.height - 2 * this.scr.a2.height + 1;
         this.scr.hit.height = this.scr.b.height;
         this.scr.hit.alpha = 0;
         this.scr.a2.y = this.scr.b.y + this.scr.b.height + this.scr.a2.height;
         this.scr.x = w + 2;
         this.tMsg.x = Math.round(this.bgList.width / 2 - this.tMsg.width / 2);
         this.tMsg.y = Math.round(this.bgList.y + (this.bgList.height / 2 - this.tMsg.height / 2));
      }
   }
}
