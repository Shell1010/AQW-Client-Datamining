package liteAssets.draw
{
   import fl.data.*;
   import fl.motion.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2222")]
   public class customDrops extends MovieClip
   {

      public var inner_menu:MovieClip;

      internal var rootClass:MovieClip;

      public var mcDraggable:draggableDrops;

      private var inactive:ColorMatrixFilter;

      private var isOpen:Boolean = false;

      public var itemCount:Object;

      public var invTree:Array;

      public function customDrops(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
         this.itemCount = {};
         this.invTree = [];
         var _loc1_:AdjustColor = new AdjustColor();
         _loc1_.saturation = -100;
         _loc1_.brightness = -100;
         _loc1_.contrast = 0;
         _loc1_.hue = 0;
         this.inactive = new ColorMatrixFilter(_loc1_.CalculateFinalFlatArray());
         this.name = "customDrops";
         this.rootClass.ui.mcPortrait.iconDrops.visible = true;
         this.visible = true;
         this.onChange(this.rootClass.litePreference.data.dOptions["dragMode"]);
         Mobile.events.addEventListener(Event.CHANGE,this.onMobile,false,0,true);
         if(Mobile.useDropTray)
         {
            this.applyMobile();
         }
      }

      public function onChange(param1:Boolean) : void
      {
         if(param1)
         {
            if(this.numChildren > 1)
            {
               while(this.numChildren > 1)
               {
                  this.removeChildAt(1);
               }
            }
            this.inner_menu.visible = false;
            if(this.inner_menu.hasEventListener(MouseEvent.CLICK))
            {
               this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached);
               this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached);
               this.inner_menu.removeEventListener(MouseEvent.CLICK,this.onToggleAttached);
            }
            if(this.rootClass.ui.mcInterface.getChildByName("customDrops"))
            {
               this.rootClass.ui.mcInterface.removeChild(this);
            }
            this.rootClass.ui.addChild(this);
            this.rootClass.ui.setChildIndex(this.rootClass.ui.getChildByName("customDrops"),this.rootClass.ui.numChildren - 1);
            this.x = 0;
            this.y = 0;
            this.mcDraggable = new draggableDrops();
            this.addChild(this.mcDraggable);
            if(this.rootClass.litePreference.data.dmtPos)
            {
               this.mcDraggable.x = this.rootClass.litePreference.data.dmtPos.x;
               this.mcDraggable.y = this.rootClass.litePreference.data.dmtPos.y;
            }
            this.mcDraggable.visible = true;
            this.mcDraggable.txtQty.mouseEnabled = false;
            this.mcDraggable.menuBar.addEventListener(MouseEvent.CLICK,this.onToggleMenu,false,0,true);
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_DOWN,this.onHold,false,0,true);
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease,false,0,true);
            this.mcDraggable.menu.visible = this.rootClass.litePreference.data.dOptions["openMenu"];
            this.lockMode();
            this.reDraw();
         }
         else
         {
            if(this.mcDraggable)
            {
               while(this.mcDraggable.menu.numChildren > 1)
               {
                  this.mcDraggable.menu.removeChildAt(1);
               }
               this.mcDraggable.menuBar.removeEventListener(MouseEvent.CLICK,this.onToggleMenu);
               this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHold);
               this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
               this.removeChild(this.mcDraggable);
               this.mcDraggable = null;
               this.rootClass.ui.removeChild(this);
            }
            this.rootClass.ui.mcInterface.addChild(this);
            this.rootClass.ui.mcInterface.setChildIndex(this.rootClass.ui.mcInterface.getChildByName("customDrops"),0);
            this.x = 352;
            this.y = this.rootClass.litePreference.data.dOptions["invertMenu"] ? -530 : -19;
            this.inner_menu.visible = true;
            this.inner_menu.height = this.rootClass.litePreference.data.dOptions["invertMenu"] ? 42.8 : 157.7;
            this.inner_menu.addEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached,false,0,true);
            this.inner_menu.addEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached,false,0,true);
            this.inner_menu.addEventListener(MouseEvent.CLICK,this.onToggleAttached,false,0,true);
            if(this.rootClass.litePreference.data.dOptions["openMenu"])
            {
               this.isOpen = true;
               this.reDraw();
            }
            else
            {
               this.inner_menu.filters = [this.inactive];
            }
         }
      }

      public function lockMode() : void
      {
         if(!this.mcDraggable)
         {
            return;
         }
         if(!this.rootClass.litePreference.data.dOptions["lockMode"])
         {
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_DOWN,this.onHold,false,0,true);
            this.mcDraggable.menuBar.addEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease,false,0,true);
         }
         else
         {
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHold);
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
         }
      }

      public function resetPos() : void
      {
         if(this.mcDraggable)
         {
            this.mcDraggable.x = 0;
            this.mcDraggable.y = 0;
         }
         this.rootClass.litePreference.data.dmtPos.x = 0;
         this.rootClass.litePreference.data.dmtPos.y = 0;
      }

      public function onToggleMenu(param1:MouseEvent) : void
      {
         this.mcDraggable.menu.visible = !this.mcDraggable.menu.visible;
         if(this.mcDraggable.menu.visible)
         {
            this.reDraw();
         }
      }

      private function onHold(param1:MouseEvent) : void
      {
         this.mcDraggable.startDrag();
      }

      private function onMouseRelease(param1:MouseEvent) : void
      {
         this.mcDraggable.stopDrag();
         this.rootClass.litePreference.data.dmtPos = {
            "x":this.mcDraggable.x,
            "y":this.mcDraggable.y
         };
         this.rootClass.litePreference.flush();
      }

      public function cleanup() : void
      {
         if(this.mcDraggable)
         {
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.CLICK,this.onToggleMenu);
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHold);
            this.mcDraggable.menuBar.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
         }
         else
         {
            this.inner_menu.removeEventListener(MouseEvent.ROLL_OVER,this.onRollOverAttached);
            this.inner_menu.removeEventListener(MouseEvent.ROLL_OUT,this.onRollOutAttached);
            this.inner_menu.removeEventListener(MouseEvent.CLICK,this.onToggleAttached);
         }
         Mobile.events.removeEventListener(Event.CHANGE,this.onMobile);
         DropTray.close(this);
         this.rootClass.cDropsUI = null;
         this.rootClass.ui.mcPortrait.iconDrops.visible = false;
         parent.removeChild(this);
      }

      public function isMenuOpen() : Boolean
      {
         return this.mcDraggable ? this.mcDraggable.visible : Boolean(this.isOpen);
      }

      public function onRollOverAttached(param1:MouseEvent) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.y = this.rootClass.litePreference.data.dOptions["invertMenu"] ? -521 : -28;
      }

      public function onRollOutAttached(param1:MouseEvent) : void
      {
         if(this.isOpen)
         {
            return;
         }
         this.y = this.rootClass.litePreference.data.dOptions["invertMenu"] ? -530 : -19;
      }

      public function onToggleAttached(param1:MouseEvent) : void
      {
         this.isOpen = !this.isOpen;
         if(!this.isOpen)
         {
            this.inner_menu.filters = [this.inactive];
            while(this.numChildren > 1)
            {
               this.removeChildAt(1);
            }
            this.inner_menu.height = this.rootClass.litePreference.data.dOptions["invertMenu"] ? 42.8 : 157.7;
            this.inner_menu.y = 0;
            this.y = this.rootClass.litePreference.data.dOptions["invertMenu"] ? -530 : -19;
         }
         else
         {
            this.inner_menu.filters = [];
            this.reDraw();
         }
      }

      public function onShow() : void
      {
         if(this.mcDraggable)
         {
            this.mcDraggable.visible = !this.mcDraggable.visible;
         }
         else
         {
            this.inner_menu.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }

      public function onUpdate() : *
      {
         this.itemCount = {};
         this.invTree.length = 0;
         if(Boolean(this.isOpen) || Boolean(this.mcDraggable) || Boolean(Mobile.useDropTray))
         {
            this.reDraw();
         }
      }

      public function onBtNo(param1:*) : void
      {
         var _loc1_:* = int(this.invTree.length - 1);
         while(_loc1_ >= 0)
         {
            if(this.invTree[_loc1_].ItemID == param1.ItemID)
            {
               this.itemCount[this.invTree[_loc1_].dID] = null;
               this.invTree.splice(_loc1_,1);
            }
            _loc1_--;
         }
         if(Boolean(this.isOpen) || Boolean(this.mcDraggable) || Boolean(Mobile.useDropTray))
         {
            this.reDraw();
         }
      }

      public function isBlacklisted(param1:String) : Boolean
      {
         return false;
      }

      public function cleanDSUI() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:* = this.rootClass.ui.getChildByName("dsUI").numChildren;
         _loc3_ -= 2;
         while(_loc3_ > -1)
         {
            _loc1_ = this.rootClass.ui.getChildByName("dsUI").getChildAt(_loc3_) as MovieClip;
            _loc2_ = this.rootClass.ui.getChildByName("dsUI").getChildAt(_loc3_ + 1) as MovieClip;
            _loc1_.fY = _loc1_.y = _loc2_.fY - (_loc2_.fHeight + 8);
            _loc3_--;
         }
      }

      public function showItem(param1:Object) : void
      {
         if(this.isBlacklisted(param1.sName.toUpperCase()))
         {
            return;
         }
         if(this.itemCount[param1.dID] == null)
         {
            this.itemCount[param1.dID] = int(param1.dQty);
            this.invTree.push(param1);
         }
         else
         {
            this.itemCount[param1.dID] += int(param1.dQty);
         }
         if(Boolean(Mobile.useDropTray) && this.rootClass.litePreference.data.dOptions["lootFeedOff"] != true)
         {
            LootFeed.push(this.rootClass,param1,int(param1.dQty));
         }
         if(Mobile.useDropTray)
         {
            this.reDraw();
            return;
         }
         if(this.mcDraggable)
         {
            this.reDraw();
            if(!this.mcDraggable.visible)
            {
               this.rootClass.ui.mcPortrait.iconDrops.onAlert();
            }
            return;
         }
         if(this.isOpen)
         {
            this.reDraw();
         }
         else
         {
            this.rootClass.ui.mcPortrait.iconDrops.onAlert();
         }
      }

      public function acceptDrop(param1:Object) : void
      {
         var _loc1_:* = int(this.invTree.length - 1);
         while(_loc1_ >= 0)
         {
            if(this.invTree[_loc1_].ItemID == param1.ItemID)
            {
               this.itemCount[this.invTree[_loc1_].dID] = null;
               this.invTree.splice(_loc1_,1);
            }
            _loc1_--;
         }
         if(Boolean(this.isOpen) || Boolean(this.mcDraggable) || Boolean(Mobile.useDropTray))
         {
            this.reDraw();
         }
      }

      public function reDraw() : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(Mobile.useDropTray)
         {
            if(this.rootClass.litePreference.data.dOptions["termsAgree"])
            {
               for each(_loc2_ in this.invTree)
               {
                  if(this.itemCount[_loc2_.dID] % (_loc2_.ItemID == 6521 ? 1000 : 100) == 0)
                  {
                     this.qtyWarning();
                     break;
                  }
               }
            }
            DropTray.sync(this);
            return;
         }
         var _loc4_:int = 0;
         while((this.mcDraggable ? this.mcDraggable.menu : this).numChildren > 1)
         {
            (this.mcDraggable ? this.mcDraggable.menu : this).removeChildAt(1);
         }
         var _loc5_:Boolean = false;
         var _loc6_:int = 0;
         for each(_loc1_ in this.invTree)
         {
            if(this.itemCount[_loc1_.dID] % 100 == 0)
            {
               if(_loc1_.ItemID == 6521 && this.itemCount[_loc1_.dID] % 1000 == 0)
               {
                  _loc5_ = true;
               }
               else if(_loc1_.ItemID != 6521)
               {
                  _loc5_ = true;
               }
            }
            _loc3_ = new dEntry(this.rootClass,_loc1_,this.itemCount[_loc1_.dID]);
            if(this.rootClass.litePreference.data.dOptions["invertMenu"])
            {
               _loc3_.x = 1.5;
               _loc3_.y = !this.mcDraggable ? 24 + 21.5 * _loc6_ - 0.5 : 161 + 21.5 * _loc6_;
            }
            else
            {
               _loc3_.x = 1.5;
               _loc3_.y = !this.mcDraggable ? -16 - 21.5 * _loc6_ + 0.5 : 108 - 21.5 * _loc6_;
            }
            _loc3_.name = _loc1_.sName;
            (this.mcDraggable ? this.mcDraggable.menu : this).addChild(_loc3_);
            _loc4_ += this.itemCount[_loc1_.dID];
            _loc6_++;
         }
         if(_loc5_ && Boolean(this.rootClass.litePreference.data.dOptions["termsAgree"]))
         {
            this.qtyWarning();
         }
         if(this.mcDraggable)
         {
            this.mcDraggable.txtQty.text = " x " + _loc4_;
            if(this.rootClass.litePreference.data.dOptions["invertMenu"])
            {
               this.mcDraggable.menu.menuBG.y = 158;
               this.mcDraggable.menu.menuBG.height = 21.5 * _loc6_ + 6;
            }
            else
            {
               this.mcDraggable.menu.menuBG.y = 108 - 21.5 * (_loc6_ - 1) - 3;
               this.mcDraggable.menu.menuBG.height = 21.5 * _loc6_ + 6;
            }
         }
         else if(this.rootClass.litePreference.data.dOptions["invertMenu"])
         {
            this.inner_menu.y = 0;
            this.inner_menu.height = _loc6_ == 0 ? 47.5 : 47.5 + 21.5 * (_loc6_ - 1);
            this.y = -521;
         }
         else
         {
            this.inner_menu.y = 4 - 21.5 * _loc6_;
            this.inner_menu.height = _loc6_ == 0 ? 157.7 : 157.7 + 21.5 * (_loc6_ - 1);
            this.y = -28;
         }
      }

      private function qtyWarning() : void
      {
         var _loc1_:* = new ModalMC();
         var _loc2_:* = {};
         _loc2_.strBody = "You have an item that\'s over the 100x quantity threshold! Please pick up your drops before you bug out!";
         _loc2_.callback = null;
         _loc2_.btns = "mono";
         _loc2_.glow = "red,medium";
         this.rootClass.ui.ModalStack.addChild(_loc1_);
         _loc1_.init(_loc2_);
      }

      private function onMobile(param1:Event) : void
      {
         this.applyMobile();
      }

      public function refreshMode() : void
      {
         this.applyMobile();
      }

      private function applyMobile() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = Boolean(Mobile.useDropTray);
         this.visible = !_loc1_;
         this.rootClass.ui.mcPortrait.iconDrops.visible = !_loc1_;
         if(_loc1_)
         {
            DropTray.sync(this);
            return;
         }
         DropTray.close(this);
         if(Boolean(this.isOpen) || Boolean(this.mcDraggable))
         {
            this.reDraw();
         }
         if(this.invTree.length > 0 && (this.mcDraggable ? Boolean(!this.mcDraggable.visible) : Boolean(!this.isOpen)))
         {
            this.rootClass.ui.mcPortrait.iconDrops.onAlert();
         }
      }

      public function requestDrop(param1:Object, param2:Boolean = true) : Boolean
      {
         var _loc1_:* = this.rootClass.world.myAvatar;
         var _loc2_:String = null;
         if(this.rootClass.isHouseItem(param1))
         {
            if(_loc1_.houseitems.length >= _loc1_.objData.iHouseSlots)
            {
               _loc2_ = "House Inventory Full!";
            }
         }
         else if(InvCat.isFullFor(_loc1_.items,param1,_loc1_.objData.iBagSlots))
         {
            _loc2_ = InvCat.isMisc(param1) ? "Misc Inventory Full!" : "Item Inventory Full!";
         }
         this.rootClass.stage.focus = null;
         if(_loc2_ != null)
         {
            if(param2)
            {
               this.rootClass.MsgBox.notify(_loc2_);
            }
            return false;
         }
         this.rootClass.sfc.sendXtMessage("zm","getDrop",[param1.ItemID],"str",this.rootClass.world.curRoom);
         return true;
      }

      public function declineDrop(param1:Object) : void
      {
         this.rootClass.stage.focus = null;
         if(!this.rootClass.litePreference.data.dOptions["warnDecline"])
         {
            this.onBtNo(param1);
            return;
         }
         var _loc1_:* = new ModalMC();
         var _loc2_:* = {};
         _loc2_.strBody = "Are you sure you want to decline the drop for " + param1.sName + "?";
         _loc2_.callback = this.onDeclineConfirm;
         _loc2_.params = {
            "sName":param1.sName,
            "ItemID":param1.ItemID
         };
         _loc2_.glow = "red,medium";
         _loc2_.btns = "dual";
         this.rootClass.stage.addChild(_loc1_);
         _loc1_.init(_loc2_);
      }

      private function onDeclineConfirm(param1:Object) : void
      {
         if(param1.accept)
         {
            this.onBtNo(param1);
         }
         this.rootClass.stage.focus = null;
      }

      public function previewDrop(param1:Object) : void
      {
         if(this.rootClass.ui.getChildByName("qRewardPrev"))
         {
            this.rootClass.ui.getChildByName("qRewardPrev").fClose();
         }
         var _loc1_:* = this.rootClass.ui.addChild(new qRewardPrev(param1));
         _loc1_.world = this.rootClass.world;
         _loc1_.rootClass = this.rootClass;
         _loc1_.isDropPreview();
         _loc1_.open();
         this.rootClass.stage.focus = null;
      }

      public function blacklist(param1:Object) : void
      {
         var _loc1_:* = new ModalMC();
         var _loc2_:* = {};
         _loc2_.glow = "red,medium";
         if(param1.sName.indexOf("Item of Digital Awesomeness.") > -1)
         {
            _loc2_.strBody = "You can NOT block IoDAs!";
            _loc2_.callback = null;
            _loc2_.btns = "mono";
         }
         else
         {
            _loc2_.strBody = "Are you sure you want to add " + param1.sName + " to the item block list?";
            _loc2_.callback = this.onBlacklistConfirm;
            _loc2_.params = {
               "sName":param1.sName,
               "ItemID":param1.ItemID
            };
            _loc2_.btns = "dual";
         }
         this.rootClass.stage.addChild(_loc1_);
         _loc1_.init(_loc2_);
      }

      private function onBlacklistConfirm(param1:Object) : void
      {
         var _loc1_:DataProvider = null;
         if(param1.accept)
         {
            _loc1_ = new DataProvider(this.rootClass.litePreference.data.blackList);
            _loc1_.addItem({
               "label":param1.sName.toUpperCase(),
               "value":param1.ItemID
            });
            this.rootClass.litePreference.data.blackList = _loc1_.toArray();
            this.rootClass.litePreference.flush();
            this.onBtNo(param1);
         }
         this.rootClass.stage.focus = null;
      }
   }
}
