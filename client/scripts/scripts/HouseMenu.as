package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2664")]
   public class HouseMenu extends MovieClip
   {

      public var bg:MovieClip;

      public var btnClose:SimpleButton;

      public var fxmask:MovieClip;

      public var hit:MovieClip;

      public var iListA:MovieClip;

      public var iListB:MovieClip;

      public var preview:MovieClip;

      public var tTitle:MovieClip;

      public var txtSearch:TextField;

      public var world:MovieClip;

      public var rootClass:MovieClip;

      public var CHARS:MovieClip;

      public var fData:Object = null;

      internal var mDown:Boolean = false;

      internal var hRun:int = 0;

      internal var dRun:int = 0;

      internal var mbY:int = 0;

      internal var mhY:int = 0;

      internal var mbD:int = 0;

      internal var ox:int = 0;

      internal var oy:int = 0;

      internal var mox:int = 0;

      internal var moy:int = 0;

      internal var scrTgt:MovieClip;

      private var currentCategory:String = "";

      public function HouseMenu()
      {
         super();
         var _loc1_:MovieClip = this as MovieClip;
         _loc1_.tTitle.mouseEnabled = false;
         _loc1_.preview.tPreview.mouseEnabled = false;
         _loc1_.hit.alpha = 0;
         _loc1_.hit.buttonMode = true;
      }

      public function fOpen(param1:String) : void
      {
         var _loc2_:MovieClip = null;
         this.rootClass = stage.getChildAt(0) as MovieClip;
         this.world = this.rootClass.world as MovieClip;
         this.CHARS = this.rootClass.world.CHARS as MovieClip;
         _loc2_ = MovieClip(this.parent).mcHouseItemHandle;
         _loc2_.visible = false;
         _loc2_.x = 1000;
         _loc2_.addEventListener(Event.ENTER_FRAME,this.onHandleEnterFrame,false,0,true);
         _loc2_.bCancel.addEventListener(MouseEvent.CLICK,this.onHandleCancelClick,false,0,true);
         _loc2_.bDelete.addEventListener(MouseEvent.CLICK,this.onHandleDeleteClick,false,0,true);
         _loc2_.bFlip.addEventListener(MouseEvent.CLICK,this.onHandleFlipClick,false,0,true);
         _loc2_.frame.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandleMoveClick,false,0,true);
         _loc2_.bCancel.buttonMode = true;
         _loc2_.bDelete.buttonMode = true;
         _loc2_.bFlip.buttonMode = true;
         var _loc3_:MovieClip = MovieClip(this.rootClass.ui.mcPopup);
         _loc3_.mcHouseOptions.cnt.bDesign.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsDesignClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bSave.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsSaveClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bHide.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHideClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bFloor.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsFloorClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bWall.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsWallClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bMisc.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsMiscClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bHouse.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHouseClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bReset.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHouseReset,false,0,true);
         _loc3_.mcHouseOptions.bExpand.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsExpandClick,false,0,true);
         _loc3_.mcHouseOptions.cnt.bDesign.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bSave.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bHide.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bFloor.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bWall.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bMisc.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bHouse.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bReset.buttonMode = true;
         _loc3_.mcHouseOptions.bExpand.buttonMode = true;
         _loc3_.mcHouseOptions.cnt.bDesign.ti.mouseEnabled = false;
         _loc3_.mcHouseOptions.cnt.txtPlaced.text = this.world.strFrame + " - ?/200 placed";
         var _loc4_:MovieClip = this as MovieClip;
         _loc4_.preview.bAdd.buttonMode = true;
         _loc4_.preview.t2.mouseEnabled = false;
         _loc4_.preview.bAdd.addEventListener(MouseEvent.CLICK,this.onItemAddClick,false,0,true);
         _loc4_.btnClose.addEventListener(MouseEvent.CLICK,this.btnCloseClick,false,0,true);
         _loc4_.bg.addEventListener(MouseEvent.MOUSE_DOWN,this.onHouseMenuBGClick,false,0,true);
         _loc4_.bg.addEventListener(Event.ENTER_FRAME,this.onHouseMenuBGEnterFrame,false,0,true);
         _loc4_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.onHouseMenuBGClick,false,0,true);
         _loc4_.hit.addEventListener(Event.ENTER_FRAME,this.onHouseMenuBGEnterFrame,false,0,true);
         _loc4_.txtSearch.addEventListener(MouseEvent.CLICK,this.onClear,false,0,true);
         _loc4_.txtSearch.addEventListener(KeyboardEvent.KEY_DOWN,this.onSearch,false,0,true);
         _loc4_.txtSearch.addEventListener(MouseEvent.MOUSE_DOWN,this.onHouseMenuBGClick,false,0,true);
         _loc4_.iListB.addEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll,false,0,true);
         this.rootClass.world.showHouseOptions("default");
         if(param1.toLowerCase() == "edit")
         {
            this.showEditMenu();
         }
      }

      public function onScroll(param1:MouseEvent) : void
      {
         var _loc2_:* = (this as MovieClip).iListB.scr;
         _loc2_.h.y += param1.delta * -3;
         if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
         {
            _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
         }
         if(_loc2_.h.y < 0)
         {
            _loc2_.h.y = 0;
         }
      }

      public function onFilter(param1:*, param2:int, param3:Array) : Boolean
      {
         return param1.sName.toLowerCase().indexOf(this.txtSearch.text.toLowerCase()) > -1;
      }

      public function onSearch(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 13)
         {
            this.buildItemList(this.fData[this.currentCategory].filter(this.onFilter),"B",this);
         }
      }

      public function onClear(param1:MouseEvent) : void
      {
         if(this.txtSearch.text.toLowerCase() == "search")
         {
            this.txtSearch.text = "";
         }
      }

      public function showEditMenu() : void
      {
         var _loc1_:MovieClip = null;
         _loc1_ = MovieClip(this);
         this.buildHouseMenu();
         _loc1_.visible = true;
         _loc1_.y = 315;
         _loc1_.x = int(480 - _loc1_.bg.width / 2);
         var _loc2_:MovieClip = this.rootClass.ui.mcPopup.mcHouseOptions.cnt;
         _loc2_.bDesign.ti.text = "Done Editing";
         _loc2_.bWall.txtWall.textColor = 3355443;
         _loc2_.bFloor.txtFloor.textColor = 3355443;
         _loc2_.bMisc.txtMisc.textColor = 3355443;
         _loc2_.bHouse.txtHouse.textColor = 3355443;
         _loc2_.bFloor.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsFloorClick);
         _loc2_.bWall.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsWallClick);
         _loc2_.bMisc.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsMiscClick);
         _loc2_.bHouse.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHouseClick);
      }

      public function hideEditMenu() : void
      {
         var _loc1_:MovieClip = MovieClip(this);
         _loc1_.visible = false;
         _loc1_.x = 1000;
         stage.focus = stage;
         this.rootClass.ui.mcPopup.mcHouseOptions.cnt.bDesign.ti.text = "Edit House";
         var _loc2_:MovieClip = this.rootClass.ui.mcPopup.mcHouseOptions.cnt;
         _loc2_.bWall.txtWall.textColor = 16777215;
         _loc2_.bFloor.txtFloor.textColor = 16777215;
         _loc2_.bMisc.txtMisc.textColor = 16777215;
         _loc2_.bHouse.txtHouse.textColor = 16777215;
         _loc2_.bFloor.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsFloorClick,false,0,true);
         _loc2_.bWall.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsWallClick,false,0,true);
         _loc2_.bMisc.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsMiscClick,false,0,true);
         _loc2_.bHouse.addEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHouseClick,false,0,true);
         this.onHandleCancelClick();
      }

      public function btnCloseClick(param1:MouseEvent = null) : void
      {
         this.rootClass.mixer.playSound("Click");
         this.rootClass.world.toggleHouseEdit();
      }

      public function fClose(param1:MouseEvent = null) : void
      {
         this.hideItemHandle();
         var _loc2_:MovieClip = MovieClip(this);
         var _loc3_:MovieClip = MovieClip(this.rootClass.ui.mcPopup);
         var _loc4_:MovieClip = MovieClip(this.parent).mcHouseItemHandle;
         _loc4_.removeEventListener(Event.ENTER_FRAME,this.onHandleEnterFrame);
         _loc4_.bCancel.removeEventListener(MouseEvent.CLICK,this.onHandleCancelClick);
         _loc4_.bDelete.removeEventListener(MouseEvent.CLICK,this.onHandleDeleteClick);
         _loc4_.bFlip.removeEventListener(MouseEvent.CLICK,this.onHandleFlipClick);
         _loc4_.frame.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHandleMoveClick);
         _loc2_.txtSearch.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHouseMenuBGClick);
         _loc3_.mcHouseOptions.cnt.bDesign.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsDesignClick);
         _loc3_.mcHouseOptions.cnt.bSave.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsSaveClick);
         _loc3_.mcHouseOptions.cnt.bHide.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHideClick);
         _loc3_.mcHouseOptions.cnt.bFloor.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsFloorClick);
         _loc3_.mcHouseOptions.cnt.bWall.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsWallClick);
         _loc3_.mcHouseOptions.cnt.bMisc.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsMiscClick);
         _loc3_.mcHouseOptions.cnt.bHouse.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHouseClick);
         _loc3_.mcHouseOptions.cnt.bReset.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsHouseReset);
         _loc3_.mcHouseOptions.bExpand.removeEventListener(MouseEvent.CLICK,this.world.onHouseOptionsExpandClick);
         _loc2_.preview.bAdd.removeEventListener(MouseEvent.CLICK,this.onItemAddClick);
         _loc2_.btnClose.removeEventListener(MouseEvent.CLICK,this.btnCloseClick);
         _loc2_.bg.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHouseMenuBGClick);
         _loc2_.bg.removeEventListener(Event.ENTER_FRAME,this.onHouseMenuBGEnterFrame);
         _loc2_.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHouseMenuBGClick);
         _loc2_.hit.removeEventListener(Event.ENTER_FRAME,this.onHouseMenuBGEnterFrame);
         _loc2_.btnClose.removeEventListener(MouseEvent.CLICK,this.btnCloseClick);
         _loc2_.txtSearch.removeEventListener(MouseEvent.CLICK,this.onClear);
         _loc2_.txtSearch.removeEventListener(KeyboardEvent.KEY_DOWN,this.onSearch);
         _loc2_.iListB.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onScroll);
         this.destroyIList(_loc2_.iListA);
         this.destroyIList(_loc2_.iListB);
         _loc2_.visible = false;
         stage.focus = stage;
      }

      public function buildHouseMenu() : void
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Object = {};
         var _loc3_:MovieClip = this as MovieClip;
         var _loc4_:Object = {};
         var _loc7_:String = "";
         var _loc8_:Array = [];
         var _loc9_:Boolean = true;
         var _loc10_:* = this.world.myAvatar.houseitems.sortOn("sType");
         _loc1_ = 0;
         while(_loc1_ < this.world.myAvatar.houseitems.length)
         {
            _loc9_ = true;
            _loc4_ = _loc10_[_loc1_];
            _loc7_ = _loc4_.sType;
            if(!(_loc7_ in _loc2_))
            {
               _loc2_[_loc7_] = [];
            }
            _loc8_ = _loc2_[_loc7_];
            _loc6_ = 0;
            while(_loc6_ < _loc8_.length)
            {
               if(_loc8_[_loc6_].ItemID == _loc4_.ItemID)
               {
                  _loc9_ = false;
                  break;
               }
               _loc6_++;
            }
            if(_loc9_)
            {
               _loc8_.push(_loc4_);
            }
            _loc1_++;
         }
         for(_loc7_ in _loc2_)
         {
            _loc2_[_loc7_].sortOn("sName");
         }
         this.fData = _loc2_;
         _loc5_ = [];
         for(_loc7_ in _loc2_)
         {
            _loc5_.push(_loc7_);
         }
         _loc5_.sort(this.rootClass.arraySort);
         this.buildItemList(_loc5_,"A",_loc3_);
      }

      public function buildItemList(param1:Array, param2:String, param3:MovieClip) : void
      {
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:Class = null;
         var _loc11_:* = undefined;
         var _loc4_:int = 0;
         var _loc7_:MovieClip = this as MovieClip;
         var _loc5_:String = "";
         var _loc6_:Boolean = true;
         var _loc12_:int = 90;
         _loc7_.preview.cnt.visible = false;
         _loc7_.preview.t2.visible = false;
         _loc7_.preview.bAdd.visible = false;
         _loc7_.preview.tPreview.visible = false;
         if(param2 == "A")
         {
            _loc7_.iListB.visible = false;
            _loc7_.txtSearch.visible = false;
            _loc8_ = _loc7_.iListA;
            this.destroyIList(_loc8_);
            _loc8_.par = param3;
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc9_ = _loc8_.iList.addChild(new hProto());
               _loc9_.ti.autoSize = "left";
               _loc9_.ti.text = String(param1[_loc4_]);
               if(_loc9_.ti.textWidth > _loc12_)
               {
                  _loc12_ = int(_loc9_.ti.textWidth);
               }
               _loc9_.hit.alpha = 0;
               _loc9_.typ = param2;
               _loc9_.val = param1[_loc4_];
               _loc9_.iSel = false;
               _loc9_.addEventListener(MouseEvent.CLICK,this.onHouseMenuItemClick,false,0,true);
               _loc9_.addEventListener(MouseEvent.MOUSE_OVER,this.onHouseMenuItemMouseOver,false,0,true);
               _loc9_.y = _loc8_.iList.iproto.y + _loc4_ * 16;
               _loc9_.bg.visible = false;
               _loc9_.buttonMode = true;
               _loc4_++;
            }
            _loc8_.iList.iproto.visible = false;
            _loc8_.iList.y = _loc8_.imask.height / 2 - _loc8_.iList.height / 2;
         }
         else if(param2 == "B")
         {
            _loc7_.iListB.visible = true;
            _loc7_.txtSearch.visible = true;
            _loc8_ = _loc7_.iListB;
            this.destroyIList(_loc8_);
            _loc8_.par = param3;
            _loc4_ = 0;
            while(_loc4_ < param1.length)
            {
               _loc9_ = _loc8_.iList.addChild(new hProto());
               _loc9_.ti.autoSize = "left";
               _loc11_ = param1[_loc4_].bEquip ? param1[_loc4_].bEquip : "0";
               _loc9_.ti.text = String(param1[_loc4_].sName) + (param1[_loc4_].iQty > 1 ? " - " + _loc11_ + "/" + param1[_loc4_].iQty : "");
               if(_loc9_.ti.textWidth > _loc12_)
               {
                  _loc12_ = int(_loc9_.ti.textWidth);
               }
               _loc9_.hit.alpha = 0;
               _loc9_.typ = param2;
               _loc9_.val = param1[_loc4_];
               _loc9_.iSel = false;
               _loc9_.addEventListener(MouseEvent.CLICK,this.onHouseMenuItemClick,false,0,true);
               _loc9_.addEventListener(MouseEvent.MOUSE_OVER,this.onHouseMenuItemMouseOver,false,0,true);
               _loc9_.y = _loc8_.iList.iproto.y + _loc4_ * 16;
               _loc9_.bg.visible = _loc9_.val.bEquip;
               _loc9_.buttonMode = true;
               _loc4_++;
            }
            _loc8_.iList.iproto.visible = false;
            _loc8_.x = _loc8_.par.x + _loc8_.par.width + 1;
            _loc8_.iList.y = _loc8_.imask.height / 2 - _loc8_.iList.height / 2;
         }
         _loc12_ += 7;
         _loc4_ = 1;
         while(_loc4_ < _loc8_.iList.numChildren)
         {
            _loc9_ = _loc8_.iList.getChildAt(_loc4_) as MovieClip;
            _loc9_.bg.width = _loc12_;
            _loc9_.hit.width = _loc12_;
            _loc4_++;
         }
         var _loc13_:MovieClip = _loc8_.scr;
         var _loc14_:MovieClip = _loc8_.imask;
         var _loc15_:MovieClip = _loc8_.iList;
         _loc13_.h.y = 0;
         _loc13_.visible = false;
         _loc13_.hit.alpha = 0;
         _loc13_.mDown = false;
         if(_loc15_.height > _loc13_.b.height)
         {
            _loc13_.h.height = int(_loc13_.b.height / _loc15_.height * _loc13_.b.height);
            this.hRun = _loc13_.b.height - _loc13_.h.height;
            this.dRun = _loc15_.height - _loc13_.b.height + 10;
            _loc15_.oy = _loc15_.y = _loc14_.y;
            _loc13_.visible = true;
            _loc13_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc13_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc15_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
         }
         else
         {
            _loc13_.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.scrDown);
            _loc13_.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
            _loc15_.removeEventListener(Event.ENTER_FRAME,this.dEF);
         }
         _loc8_.imask.width = _loc12_ - 1;
         _loc8_.divider.x = _loc12_;
         _loc8_.scr.x = _loc12_;
         if(_loc8_.scr.visible)
         {
            _loc8_.w = _loc12_ + _loc8_.scr.width;
         }
         else
         {
            _loc8_.w = _loc12_ + 1;
         }
         this.resizeMe();
      }

      private function destroyIList(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         while(param1.iList.numChildren > 1)
         {
            _loc2_ = param1.iList.getChildAt(1);
            _loc2_.removeEventListener(MouseEvent.CLICK,this.onHouseMenuItemClick);
            _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.onHouseMenuItemMouseOver);
            delete _loc2_.val;
            param1.iList.removeChildAt(1);
         }
         param1.scr.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.scrDown);
         param1.scr.h.removeEventListener(Event.ENTER_FRAME,this.hEF);
         param1.iList.removeEventListener(Event.ENTER_FRAME,this.dEF);
      }

      public function onHouseMenuItemClick(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc8_:Object = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc4_:MovieClip = _loc2_.parent as MovieClip;
         var _loc7_:MovieClip = this as MovieClip;
         var _loc9_:int = 0;
         var _loc10_:String = "";
         if(_loc2_.typ == "A")
         {
            _loc9_ = 0;
            while(_loc9_ < _loc4_.numChildren)
            {
               MovieClip(_loc4_.getChildAt(_loc9_)).bg.visible = false;
               _loc9_++;
            }
            _loc2_.bg.visible = true;
            this.buildItemList(this.fData[_loc2_.val],"B",MovieClip(_loc2_.parent));
            this.currentCategory = _loc2_.val;
         }
         if(_loc2_.typ == "B")
         {
            _loc9_ = 1;
            while(_loc9_ < _loc4_.numChildren)
            {
               _loc3_ = _loc4_.getChildAt(_loc9_) as MovieClip;
               _loc3_.iSel = false;
               _loc9_++;
            }
            _loc2_.iSel = true;
            this.refreshIListB();
            _loc8_ = _loc2_.val;
            this.world.loadHouseItemB(_loc8_);
            this.resizeMe();
         }
      }

      public function onHouseMenuItemMouseOver(param1:MouseEvent) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:MovieClip = MovieClip(param1.currentTarget);
         var _loc4_:int = 1;
         while(_loc4_ < _loc2_.parent.numChildren)
         {
            _loc3_ = MovieClip(_loc2_.parent.getChildAt(_loc4_));
            if(_loc3_.bg.alpha < 0.4)
            {
               _loc3_.bg.visible = false;
            }
            _loc4_++;
         }
         if(!_loc2_.bg.visible)
         {
            _loc2_.bg.visible = true;
            _loc2_.bg.alpha = 0.33;
         }
      }

      private function refreshIListB() : void
      {
         var _loc3_:MovieClip = null;
         var _loc1_:MovieClip = MovieClip(this).iListB.iList;
         var _loc2_:int = 1;
         while(_loc2_ < _loc1_.numChildren)
         {
            _loc3_ = _loc1_.getChildAt(_loc2_) as MovieClip;
            if(_loc3_.val != null)
            {
               _loc3_.bg.visible = false;
               if(_loc3_.iSel)
               {
                  _loc3_.bg.visible = true;
                  _loc3_.bg.alpha = 0.5;
               }
               if(_loc3_.val.iQty > 1)
               {
                  _loc3_.ti.text = String(_loc3_.val.sName) + (_loc3_.val.iQty > 1 ? " - " + _loc3_.val.bEquip + "/" + _loc3_.val.iQty : "");
               }
               if(int(_loc3_.val.bEquip))
               {
                  _loc3_.bg.visible = true;
                  _loc3_.bg.alpha = 1;
               }
            }
            _loc2_++;
         }
      }

      public function onItemAddClick(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc2_:Object = MovieClip(param1.currentTarget.parent).item;
         if(!_loc2_.hasOwnProperty("bEquip"))
         {
            _loc2_.bEquip = 0;
         }
         if(int(_loc2_.bEquip) < _loc2_.iQty)
         {
            if(_loc2_.iQty > 1 && int(_loc2_.bEquip) < _loc2_.iQty)
            {
               _loc2_.bEquip += 1;
               this.refreshIListB();
               _loc3_ = _loc2_.sType.toLowerCase().indexOf("wall") > -1 ? 150 : 300;
               this.world.loadHouseItem(_loc2_,480,_loc3_);
               this.rootClass.world.hasModified = true;
            }
            else if(_loc2_.bUpg == 1 && !this.rootClass.world.myAvatar.isUpgraded())
            {
               this.rootClass.showUpgradeWindow();
            }
            else if(_loc2_.sType == "House")
            {
               this.world.equipHouse(_loc2_);
            }
            else
            {
               _loc2_.bEquip += 1;
               this.refreshIListB();
               _loc3_ = _loc2_.sType.toLowerCase().indexOf("wall") > -1 ? 150 : 300;
               this.world.loadHouseItem(_loc2_,480,_loc3_);
               this.rootClass.world.hasModified = true;
            }
         }
      }

      public function previewHouseItem(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1.item.sType == "House")
         {
            _loc2_ = param1.item.sFile.substr(0,-4).substr(param1.item.sFile.lastIndexOf("/") + 1).split("-").join("_") + "_preview";
         }
         else
         {
            _loc2_ = param1.item.sLink;
         }
         if(_loc2_ == null || !this.world.loaderD.hasDefinition(_loc2_))
         {
            if(_loc2_ != null)
            {
               trace("[Load] ERR missing linkage " + _loc2_ + " " + param1.item.sFile);
            }
            return;
         }
         var _loc3_:Class = this.world.loaderD.getDefinition(_loc2_) as Class;
         var _loc4_:MovieClip = MovieClip(this).preview.cnt as MovieClip;
         if(_loc4_.numChildren > 0)
         {
            _loc4_.removeChildAt(0);
         }
         var _loc7_:MovieClip = _loc4_.addChild(new _loc3_()) as MovieClip;
         var _loc8_:* = 130 / _loc7_.width;
         if(_loc7_.height > _loc7_.width)
         {
            _loc8_ = 113 / _loc7_.height;
         }
         _loc7_.scaleX = _loc8_;
         _loc7_.scaleY = _loc8_;
         _loc7_.x = 130 / 2;
         _loc7_.y = 113 / 2 + _loc7_.height / 2;
         _loc7_.ItemID = param1.item.ItemID;
         MovieClip(this).preview.item = param1.item;
         MovieClip(this).preview.bAdd.visible = true;
         MovieClip(this).preview.tPreview.visible = true;
         MovieClip(this).preview.t2.visible = false;
         MovieClip(this).preview.cnt.visible = true;
      }

      public function resizeMe() : *
      {
         var _loc1_:MovieClip = MovieClip(this);
         if(_loc1_.iListA.visible)
         {
            _loc1_.bg.width = _loc1_.iListA.x + _loc1_.iListA.w + 5;
         }
         if(_loc1_.iListB.visible)
         {
            _loc1_.iListB.x = _loc1_.iListA.x + _loc1_.iListA.w + 1;
            _loc1_.bg.width += _loc1_.iListB.w + 1;
            _loc1_.iListA.divider.visible = !_loc1_.iListA.scr.visible;
         }
         else
         {
            _loc1_.iListA.divider.visible = false;
         }
         if(Boolean(_loc1_.preview.t2.visible) || Boolean(_loc1_.preview.cnt.visible))
         {
            _loc1_.preview.x = _loc1_.iListB.x + _loc1_.iListB.w + 4;
            _loc1_.bg.width += _loc1_.preview.width + 4;
            _loc1_.iListB.divider.visible = !_loc1_.iListB.scr.visible;
         }
         else
         {
            _loc1_.iListB.divider.visible = false;
         }
         var _loc2_:* = _loc1_.tTitle.x + this.tTitle.width + 4 + _loc1_.btnClose.width + 4;
         if(_loc1_.bg.width < _loc2_)
         {
            _loc1_.bg.width = _loc2_;
         }
         _loc1_.btnClose.x = _loc1_.bg.width - 19;
         _loc1_.fxmask.width = _loc1_.bg.width;
         if(_loc1_.x < 0)
         {
            _loc1_.x = 0;
         }
         if(_loc1_.x + _loc1_.bg.width > 960)
         {
            _loc1_.x = 960 - _loc1_.bg.width;
         }
         if(_loc1_.y < 0)
         {
            _loc1_.y = 0;
         }
         if(_loc1_.y + _loc1_.bg.height > 495)
         {
            _loc1_.y = 495 - _loc1_.bg.height;
         }
         _loc1_.txtSearch.width = _loc1_.iListB.width - (_loc1_.btnClose.width + 4 + 10);
      }

      public function scrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(MovieClip(param1.currentTarget.parent).h.y);
         this.scrTgt = MovieClip(param1.currentTarget.parent);
         this.scrTgt.mDown = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.scrUp,false,0,true);
      }

      public function scrUp(param1:MouseEvent) : *
      {
         this.scrTgt.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }

      public function hEF(param1:Event) : *
      {
         var _loc2_:* = undefined;
         if(MovieClip(param1.currentTarget.parent).mDown)
         {
            _loc2_ = MovieClip(param1.currentTarget.parent);
            this.mbD = int(mouseY) - this.mbY;
            _loc2_.h.y = this.mhY + this.mbD;
            if(_loc2_.h.y + _loc2_.h.height > _loc2_.b.height)
            {
               _loc2_.h.y = int(_loc2_.b.height - _loc2_.h.height);
            }
            if(_loc2_.h.y < 0)
            {
               _loc2_.h.y = 0;
            }
         }
      }

      public function dEF(param1:Event) : *
      {
         var _loc2_:* = MovieClip(param1.currentTarget.parent).scr;
         var _loc3_:* = MovieClip(param1.currentTarget);
         var _loc4_:* = -_loc2_.h.y / this.hRun;
         var _loc7_:* = int(_loc4_ * this.dRun) + _loc3_.oy;
         if(Math.abs(_loc7_ - _loc3_.y) > 0.2)
         {
            _loc3_.y += (_loc7_ - _loc3_.y) / 4;
         }
         else
         {
            _loc3_.y = _loc7_;
         }
      }

      public function drawItemHandle(param1:MovieClip) : void
      {
         var _loc2_:int = Math.ceil(param1.width);
         var _loc3_:int = Math.ceil(param1.height);
         var _loc4_:MovieClip = MovieClip(this.parent).mcHouseItemHandle as MovieClip;
         _loc4_.visible = true;
         var _loc7_:Rectangle = param1.getBounds(stage);
         _loc4_.frame.width = _loc2_ > 100 ? _loc2_ : 100;
         _loc4_.frame.height = _loc3_ > 50 ? _loc3_ : 50;
         _loc4_.x = int(param1.x - _loc4_.frame.width / 2);
         _loc4_.y = int(_loc7_.y);
         if(_loc4_.tgt != null)
         {
            _loc4_.tgt.filters = [];
         }
         _loc4_.tgt = param1;
         _loc4_.tgt.filters = [new GlowFilter(16777215,1,8,8,2,2)];
      }

      public function hideItemHandle() : void
      {
         var _loc1_:MovieClip = MovieClip(this.parent).mcHouseItemHandle as MovieClip;
         _loc1_.visible = false;
         _loc1_.x = 1000;
         if(_loc1_.tgt != null)
         {
            _loc1_.tgt.filters = [];
         }
         _loc1_.tgt = null;
      }

      public function onHandleFlipClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.rootClass.ui.mcPopup.mcHouseItemHandle;
         _loc2_.tgt.scaleX *= -1;
         this.rootClass.world.hasModified = true;
      }

      public function onHandleMoveClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.rootClass.ui.mcPopup.mcHouseItemHandle;
         _loc2_.mDown = true;
         _loc2_.ox = _loc2_.x;
         _loc2_.oy = _loc2_.y;
         _loc2_.mox = stage.mouseX;
         _loc2_.moy = stage.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onHandleMoveRelease,false,0,true);
         this.rootClass.world.hasModified = true;
      }

      public function onHandleMoveRelease(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = this.rootClass.ui.mcPopup.mcHouseItemHandle;
         _loc2_.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onHandleMoveRelease);
         this.world.houseItemValidate(MovieClip(_loc2_.tgt));
      }

      public function onHandleDeleteClick(param1:MouseEvent) : void
      {
         this.rootClass.mixer.playSound("Click");
         var _loc2_:MovieClip = this.rootClass.ui.mcPopup.mcHouseItemHandle;
         var _loc3_:MovieClip = _loc2_.tgt;
         --_loc3_.item.bEquip;
         this.refreshIListB();
         delete _loc3_.item;
         delete _loc3_.ItemID;
         _loc3_.removeEventListener(Event.ENTER_FRAME,this.world.onHouseItemEnterFrame);
         _loc3_.parent.removeChild(_loc3_);
         this.hideItemHandle();
         this.rootClass.world.hasModified = true;
      }

      public function onHandleCancelClick(param1:MouseEvent = null) : void
      {
         var _loc2_:MovieClip = this.rootClass.ui.mcPopup.mcHouseItemHandle;
         if(Boolean(_loc2_.tgt) && !_loc2_.tgt.isStable)
         {
            this.rootClass.showMessageBox("You can not leave this house item placed here!");
            return;
         }
         if(_loc2_.tgt != null)
         {
            _loc2_.tgt.filters = [];
         }
         _loc2_.tgt = null;
         _loc2_.x = 1000;
         _loc2_.visible = false;
      }

      public function onHandleEnterFrame(param1:Event) : *
      {
         var _loc8_:* = undefined;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.visible)
         {
            _loc2_.bCancel.x = _loc2_.frame.width - _loc2_.bCancel.width - 8;
            _loc2_.bDelete.x = _loc2_.bCancel.x - _loc2_.bDelete.width - 8;
            _loc2_.bFlip.x = _loc2_.bDelete.x - _loc2_.bFlip.width - 8;
            if(_loc2_.mDown)
            {
               _loc2_.x = _loc2_.ox + (stage.mouseX - _loc2_.mox);
               _loc2_.y = _loc2_.oy + (stage.mouseY - _loc2_.moy);
               if(_loc2_.x + _loc2_.frame.width / 2 < 0)
               {
                  _loc2_.x = -int(_loc2_.frame.width / 2);
               }
               if(_loc2_.x + _loc2_.frame.width / 2 > 960)
               {
                  _loc2_.x = int(960 - _loc2_.frame.width / 2);
               }
               if(_loc2_.y + _loc2_.frame.height / 2 < 0)
               {
                  _loc2_.y = -int(_loc2_.frame.height / 2);
               }
               if(_loc2_.y + _loc2_.frame.height / 2 > 495)
               {
                  _loc2_.y = int(495 - _loc2_.frame.height / 2);
               }
               _loc2_.tgt.x = Math.ceil(_loc2_.x + _loc2_.frame.width / 2);
               _loc2_.tgt.y = Math.ceil(_loc2_.y - (_loc2_.tgt.getBounds(stage).y - _loc2_.tgt.y));
            }
         }
         var _loc3_:MovieClip = MovieClip(this.rootClass.ui.mcPopup);
         var _loc4_:int = 0;
         var _loc7_:int = 0;
         while(_loc7_ < this.world.CHARS.numChildren)
         {
            _loc8_ = this.world.CHARS.getChildAt(_loc7_);
            if(Boolean(_loc8_.hasOwnProperty("isHouseItem")) && Boolean(MovieClip(_loc8_).isHouseItem))
            {
               _loc4_++;
            }
            _loc7_++;
         }
         _loc3_.mcHouseOptions.cnt.txtPlaced.text = this.world.strFrame + " - " + _loc4_ + "/200 placed";
      }

      public function onHouseMenuBGClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(this);
         _loc2_.mDown = true;
         _loc2_.ox = _loc2_.x;
         _loc2_.oy = _loc2_.y;
         _loc2_.mox = stage.mouseX;
         _loc2_.moy = stage.mouseY;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onHouseMenuBGRelease,false,0,true);
      }

      public function onHouseMenuBGRelease(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = MovieClip(this);
         _loc2_.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onHouseMenuBGRelease);
      }

      public function onHouseMenuBGEnterFrame(param1:Event) : *
      {
         var _loc2_:MovieClip = param1.currentTarget.parent as MovieClip;
         if(_loc2_.visible)
         {
            if(_loc2_.mDown)
            {
               _loc2_.x = _loc2_.ox + (stage.mouseX - _loc2_.mox);
               _loc2_.y = _loc2_.oy + (stage.mouseY - _loc2_.moy);
               if(_loc2_.x < 0)
               {
                  _loc2_.x = 0;
               }
               if(_loc2_.x + _loc2_.bg.width > 960)
               {
                  _loc2_.x = 960 - _loc2_.bg.width;
               }
               if(_loc2_.y < 0)
               {
                  _loc2_.y = 0;
               }
               if(_loc2_.y + _loc2_.bg.height > 495)
               {
                  _loc2_.y = 495 - _loc2_.bg.height;
               }
            }
         }
      }
   }
}
