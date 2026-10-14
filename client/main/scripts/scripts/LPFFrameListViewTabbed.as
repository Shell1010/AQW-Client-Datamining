package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1919")]
   public class LPFFrameListViewTabbed extends LPFFrame
   {

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
         var _loc1_:MovieClip = null;
         var _loc2_:Object = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Object = {};
         var _loc8_:Array = [];
         var _loc9_:String = "";
         while(this.tabs.numChildren > 0)
         {
            this.tabs.removeChildAt(0);
         }
         this.bgTabs.graphics.clear();
         _loc6_ = 0;
         while(_loc6_ < this.tabStates.length)
         {
            if(this.onDemand)
            {
               this.tabStates[_loc6_].state = 0;
            }
            else
            {
               this.tabStates[_loc6_].state = -1;
               for each(_loc7_ in fData.list)
               {
                  for(_loc4_ in this.filterMap)
                  {
                     if(this.filterMap[_loc4_].indexOf(_loc7_.sType) > -1 || _loc7_.sType == "Enhancement" && _loc7_.sES == _loc4_)
                     {
                        if(this.tabStates[_loc6_].filter == _loc4_)
                        {
                           this.tabStates[_loc6_].state = 0;
                        }
                     }
                  }
               }
            }
            _loc6_++;
         }
         _loc8_ = [];
         _loc5_ = 0;
         while(_loc5_ < this.tabStates.length)
         {
            _loc7_ = this.tabStates[_loc5_];
            _loc1_ = this.tabs.addChild(new LPFElementListViewTab()) as MovieClip;
            _loc2_ = getLayout().rootClass.world.getClass(_loc7_.icon);
            _loc3_ = _loc1_.icon.addChild(new _loc2_());
            _loc3_.scaleX = _loc3_.scaleY = 16 / _loc3_.height;
            _loc3_.x -= _loc3_.width / 2;
            _loc3_.y = 2;
            _loc1_.icon.mouseEnabled = false;
            _loc1_.icon.mouseChildren = false;
            _loc1_.o = _loc7_;
            _loc7_.mc = _loc1_;
            _loc1_.bg2.visible = false;
            if(_loc7_ == this.tSel)
            {
               _loc7_.state = 1;
            }
            if(_loc7_.state == -1)
            {
               _loc1_.icon.alpha = 0.3;
               _loc1_.bg3.visible = true;
               _loc1_.bg2.visible = false;
               _loc1_.bg.visible = false;
               _loc1_.mouseEnabled = false;
               _loc1_.mouseChildren = false;
            }
            else
            {
               _loc1_.bg3.visible = false;
               _loc1_.buttonMode = true;
               if(_loc7_.state == 1)
               {
                  _loc1_.bg.visible = false;
                  _loc1_.bg2.visible = true;
               }
               _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.tabClick,false,0,true);
            }
            _loc1_.x = int((_loc1_.width + 3) * _loc5_) + 1;
            _loc8_.push(_loc1_.getBounds(this.bgTabs));
            _loc5_++;
         }
         this.drawTabBG();
      }

      private function fDraw(param1:Boolean = true) : void
      {
         var _loc1_:String = null;
         var _loc2_:LPFElementListItemItem = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:DisplayObject = null;
         this.listA = [];
         var _loc5_:Array = [];
         var _loc6_:Array = [];
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Object = {};
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
            for each(_loc11_ in this.itemList)
            {
               if(this.excludeTypes.indexOf(_loc11_.sType) <= -1)
               {
                  if(this.filterMap[this.tSel.filter].indexOf(_loc11_.sType) > -1 || _loc11_.sType == "Enhancement" && _loc11_.sES.indexOf(this.tSel.filter) > -1)
                  {
                     if(!(this.tSel.filter == "pots" && (_loc11_.sLink != "potion" && _loc11_.sLink != "elixir" && _loc11_.sLink != "tonic" && _loc11_.sLink != "scroll")))
                     {
                        _loc8_.push(_loc11_);
                     }
                  }
               }
            }
         }
         else if(this.excludeTypes.length > 0)
         {
            _loc8_ = [];
            for each(_loc11_ in this.itemList)
            {
               if(this.excludeTypes.indexOf(_loc11_.sType) <= -1)
               {
                  _loc8_.push(_loc11_);
               }
            }
         }
         else
         {
            _loc8_ = this.itemList;
         }
         if(Boolean(this.onDemand) && _loc8_.length == 0)
         {
            this.setMessage("No items of this type");
            this.scr.fOpen({
               "subject":this.iList,
               "subjectMask":this.listMask,
               "reset":param1
            });
            return;
         }
         _loc9_ = 0;
         while(_loc9_ < this.sortOrder.length)
         {
            _loc5_ = [];
            for each(_loc11_ in _loc8_)
            {
               if(_loc11_.sType == this.sortOrder[_loc9_])
               {
                  _loc5_.push(_loc11_);
               }
            }
            if(_loc5_.length > 0)
            {
               _loc5_.sortOn(["sName","iLvl"],[undefined,Array.DESCENDING | Array.NUMERIC]);
               this.listA = this.listA.concat(_loc5_);
            }
            _loc9_++;
         }
         _loc5_ = [];
         for each(_loc11_ in _loc8_)
         {
            if(this.listA.indexOf(_loc11_) == -1)
            {
               _loc5_.push(_loc11_);
            }
         }
         if(_loc5_.length > 0)
         {
            _loc5_.sortOn(["sType","sName"]);
            this.listA = this.listA.concat(_loc5_);
         }
         var _loc12_:Object = {};
         _loc12_.eventType = this.itemEventType;
         _loc12_.allowDesel = this.allowDesel;
         _loc12_.multiSelect = this.multiSelect;
         _loc12_.bLimited = this.bLimited && getLayout().sMode == "shopBuy";
         _loc9_ = 0;
         while(_loc9_ < this.listA.length)
         {
            _loc12_.fData = this.listA[_loc9_];
            _loc2_ = new LPFElementListItemItem();
            _loc3_ = this.iList.addChild(_loc2_);
            _loc2_.subscribeTo(this);
            _loc2_.fOpen(_loc12_);
            if(_loc2_.fData == this.iSel)
            {
               _loc2_.select();
            }
            if(_loc9_ > 0)
            {
               _loc4_ = this.iList.getChildAt(_loc9_ - 1);
               _loc3_.y = _loc4_.y + _loc4_.height;
            }
            _loc9_++;
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
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         while(_loc3_ < this.iList.numChildren)
         {
            _loc1_ = MovieClip(this.iList.getChildAt(_loc3_));
            if(_loc1_.sel)
            {
               _loc2_ += 1;
            }
            _loc3_++;
         }
         return _loc2_;
      }

      public function getSelectedItems() : Array
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Array = [];
         var _loc3_:* = 0;
         while(_loc3_ < this.iList.numChildren)
         {
            _loc1_ = MovieClip(this.iList.getChildAt(_loc3_));
            if(_loc1_.sel)
            {
               _loc2_.push(_loc1_.fData.ItemID);
            }
            _loc3_++;
         }
         return _loc2_;
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
