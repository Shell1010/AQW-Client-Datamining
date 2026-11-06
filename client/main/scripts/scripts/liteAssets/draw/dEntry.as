package liteAssets.draw
{
   import fl.data.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2241")]
   public class dEntry extends MovieClip
   {

      internal static const HOLD_MS:int = 500;

      internal static const HOLD_SLOP:int = 8;

      public var btNo:MovieClip;

      public var btPreview:MovieClip;

      public var btYes:MovieClip;

      public var entryBar:MovieClip;

      public var icon:MovieClip;

      public var iconAC:MovieClip;

      public var overEntryBar:MovieClip;

      public var txtDrop:TextField;

      public var itemObj:Object;

      internal var format:TextFormat;

      internal var rootClass:MovieClip;

      internal var holdFill:Shape;

      internal var holdLabel:TextField;

      internal var holdStart:int;

      internal var holdX:Number;

      internal var holdY:Number;

      internal var allowPass:Boolean = false;

      public function dEntry(param1:MovieClip, param2:Object, param3:int)
      {
         var sIcon:String;
         var AssetClass:Class = null;
         var mcIcon:* = undefined;
         var check:detailedCheck = null;
         var lb:Rectangle = null;
         var ib:Rectangle = null;
         var gb:Rectangle = null;
         var r:MovieClip = param1;
         var resObj:Object = param2;
         var relQty:int = param3;
         this.format = new TextFormat();
         super();
         this.rootClass = r;
         this.allowPass = false;
         this.gotoAndStop("idle");
         this.btYes.visible = false;
         this.btNo.visible = false;
         this.btPreview.visible = false;
         this.itemObj = resObj;
         this.iconAC.visible = resObj.bCoins == 1;
         this.txtDrop.text = "";
         this.txtDrop.htmlText = "";
         if(resObj.bUpg == 1)
         {
            this.txtDrop.htmlText = "<font color=\'#FCC749\'>" + resObj.sName + " x " + relQty + "</font>";
         }
         else
         {
            this.txtDrop.text = resObj.sName + " x " + relQty;
         }
         this.txtDrop.autoSize = TextFieldAutoSize.LEFT;
         if(this.txtDrop.width > this.entryBar.width - this.txtDrop.x - 20)
         {
            this.txtDrop.autoSize = TextFieldAutoSize.NONE;
            this.txtDrop.width = this.entryBar.width - this.txtDrop.x - 20 - (this.iconAC.visible ? this.iconAC.width : 0);
         }
         if(this.iconAC.visible)
         {
            this.iconAC.x = this.txtDrop.x + this.txtDrop.width;
         }
         sIcon = "";
         if(resObj.sType.toLowerCase() == "enhancement")
         {
            sIcon = this.rootClass.getIconBySlot(resObj.sES);
         }
         else if(resObj.sType.toLowerCase() == "serveruse" || resObj.sType.toLowerCase() == "clientuse")
         {
            if("sFile" in resObj && resObj.sFile.length > 0 && this.rootClass.world.getClass(resObj.sFile) != null)
            {
               sIcon = resObj.sFile;
            }
            else
            {
               sIcon = resObj.sIcon;
            }
         }
         else if(resObj.sIcon == null || resObj.sIcon == "" || resObj.sIcon == "none")
         {
            if(resObj.sLink.toLowerCase() != "none")
            {
               sIcon = "iidesign";
            }
            else
            {
               sIcon = "iibag";
            }
         }
         else
         {
            sIcon = resObj.sIcon;
         }
         try
         {
            AssetClass = this.rootClass.world.getClass(sIcon) as Class;
            mcIcon = this.icon.addChild(new AssetClass());
         }
         catch(e:Error)
         {
            AssetClass = rootClass.world.getClass("iibag") as Class;
            mcIcon = this.icon.addChild(new AssetClass());
         }
         mcIcon.scaleX = mcIcon.scaleY = 16 / mcIcon.height;
         if(this.isOwned(resObj.bHouse,resObj.ItemID))
         {
            check = new detailedCheck();
            this.icon.addChild(check);
            lb = check.getBounds(check);
            ib = mcIcon.getBounds(this.icon);
            if(lb.height > 0)
            {
               check.scaleX = check.scaleY = ib.height / lb.height;
            }
            gb = check.getBounds(this.icon);
            check.x += ib.x + ib.width / 2 - (gb.x + gb.width / 2) + ib.height / 2;
            check.y += ib.y + ib.height / 2 - (gb.y + gb.height / 2);
         }
         this.addEventListener(MouseEvent.ROLL_OVER,this.onHighlight,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onDeHighlight,false,0,true);
         this.addEventListener(MouseEvent.CLICK,this.onShiftClick,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_DOWN,this.onHoldDown,false,0,true);
         this.btYes.addEventListener(MouseEvent.CLICK,this.onBtYes,false,0,true);
         this.btNo.addEventListener(MouseEvent.CLICK,this.onBtNo,false,0,true);
         this.btPreview.addEventListener(MouseEvent.CLICK,this.onBtPreview,false,0,true);
      }

      internal function onShiftClick(param1:MouseEvent) : void
      {
         if(param1.shiftKey)
         {
            this.confirmBlock();
         }
      }

      internal function isControl(param1:DisplayObject) : Boolean
      {
         while(param1 != null && param1 != this)
         {
            if(param1 == this.btYes || param1 == this.btNo || param1 == this.btPreview)
            {
               return true;
            }
            param1 = param1.parent;
         }
         return false;
      }

      internal function onHoldDown(param1:MouseEvent) : void
      {
         var _loc1_:Rectangle = null;
         if(param1.shiftKey || this.isControl(param1.target as DisplayObject))
         {
            return;
         }
         this.cancelHold();
         _loc1_ = this.entryBar.getBounds(this);
         this.holdFill = new Shape();
         this.holdFill.graphics.beginFill(13369344,0.45);
         this.holdFill.graphics.drawRect(0,0,_loc1_.width,_loc1_.height);
         this.holdFill.graphics.endFill();
         this.holdFill.x = _loc1_.x;
         this.holdFill.y = _loc1_.y;
         this.holdFill.scaleX = 0;
         this.addChildAt(this.holdFill,this.getChildIndex(this.entryBar) + 1);
         this.holdLabel = MailArt.tf(10,16777215,true);
         this.holdLabel.mouseEnabled = false;
         this.holdLabel.text = "Hold to block" + String.fromCharCode(8230);
         var _loc2_:Number = _loc1_.right - 4;
         if(this.btYes.visible)
         {
            _loc2_ = Math.min(this.btYes.x,this.btNo.x,this.btPreview.x) - 4;
         }
         this.holdLabel.x = _loc2_ - this.holdLabel.width;
         this.holdLabel.y = _loc1_.y + (_loc1_.height - this.holdLabel.height) / 2;
         this.addChild(this.holdLabel);
         this.holdStart = getTimer();
         this.holdX = param1.stageX;
         this.holdY = param1.stageY;
         this.addEventListener(Event.ENTER_FRAME,this.onHoldFrame,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_MOVE,this.onHoldMove,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.cancelHold,false,0,true);
         this.addEventListener(Event.REMOVED_FROM_STAGE,this.cancelHold,false,0,true);
         this.stage.addEventListener(MouseEvent.MOUSE_UP,this.cancelHold,false,0,true);
      }

      internal function onHoldFrame(param1:Event) : void
      {
         var _loc1_:Number = (getTimer() - this.holdStart) / HOLD_MS;
         if(_loc1_ < 1)
         {
            this.holdFill.scaleX = _loc1_;
            return;
         }
         this.cancelHold();
         this.confirmBlock();
      }

      internal function onHoldMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = param1.stageX - this.holdX;
         var _loc2_:Number = param1.stageY - this.holdY;
         if(_loc1_ * _loc1_ + _loc2_ * _loc2_ > HOLD_SLOP * HOLD_SLOP)
         {
            this.cancelHold();
         }
      }

      internal function cancelHold(param1:Event = null) : void
      {
         if(this.holdFill == null)
         {
            return;
         }
         this.removeEventListener(Event.ENTER_FRAME,this.onHoldFrame);
         this.removeEventListener(MouseEvent.MOUSE_MOVE,this.onHoldMove);
         this.removeEventListener(MouseEvent.ROLL_OUT,this.cancelHold);
         this.removeEventListener(Event.REMOVED_FROM_STAGE,this.cancelHold);
         if(this.stage != null)
         {
            this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.cancelHold);
         }
         if(this.holdFill.parent != null)
         {
            this.holdFill.parent.removeChild(this.holdFill);
         }
         if(this.holdLabel.parent != null)
         {
            this.holdLabel.parent.removeChild(this.holdLabel);
         }
         this.holdFill = null;
         this.holdLabel = null;
      }

      internal function confirmBlock() : void
      {
         var _loc1_:Class = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.itemObj.sName.indexOf("Item of Digital Awesomeness.") > -1)
         {
            _loc1_ = this.rootClass.world.getClass("ModalMC");
            _loc2_ = new _loc1_();
            _loc3_ = {};
            _loc3_.strBody = "You can NOT block IoDAs!";
            _loc3_.callback = null;
            _loc3_.glow = "red,medium";
            _loc3_.btns = "mono";
            this.rootClass.stage.addChild(_loc2_);
            _loc2_.init(_loc3_);
            return;
         }
         _loc1_ = this.rootClass.world.getClass("ModalMC");
         _loc2_ = new _loc1_();
         _loc3_ = {};
         _loc3_.strBody = "Are you sure you want to add " + this.itemObj.sName + " to the item block list?";
         _loc3_.callback = this.onModifyBlacklist;
         _loc3_.params = {
            "sName":this.itemObj.sName,
            "ItemID":this.itemObj.ItemID
         };
         _loc3_.glow = "red,medium";
         _loc3_.btns = "dual";
         this.rootClass.stage.addChild(_loc2_);
         _loc2_.init(_loc3_);
      }

      internal function onModifyBlacklist(param1:Object) : void
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
            this.btNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
         this.rootClass.stage.focus = null;
      }

      internal function isOwned(param1:Boolean, param2:*) : Boolean
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in param1 ? this.rootClass.world.myAvatar.houseitems : this.rootClass.world.myAvatar.items)
         {
            if(_loc1_.ItemID == param2)
            {
               return true;
            }
         }
         if(this.rootClass.world.bankinfo.isItemInBank(param2))
         {
            return true;
         }
         return false;
      }

      internal function updateFormat(param1:int) : void
      {
         this.format.size = param1;
         this.txtDrop.setTextFormat(this.format);
      }

      internal function onBtYes(param1:MouseEvent) : void
      {
         var _loc1_:Boolean = InvCat.isFullFor(this.rootClass.world.myAvatar.items,this.itemObj,this.rootClass.world.myAvatar.objData.iBagSlots);
         if(Boolean(this.rootClass.isHouseItem(this.itemObj)) && this.rootClass.world.myAvatar.houseitems.length >= this.rootClass.world.myAvatar.objData.iHouseSlots)
         {
            this.rootClass.MsgBox.notify("House Inventory Full!");
         }
         else if(!this.rootClass.isHouseItem(this.itemObj) && _loc1_)
         {
            this.rootClass.MsgBox.notify(InvCat.isMisc(this.itemObj) ? "Misc Inventory Full!" : "Item Inventory Full!");
         }
         else
         {
            this.rootClass.sfc.sendXtMessage("zm","getDrop",[this.itemObj.ItemID],"str",this.rootClass.world.curRoom);
         }
         this.rootClass.stage.focus = null;
      }

      internal function onDeclineDrop(param1:Object) : void
      {
         if(param1.accept)
         {
            this.allowPass = true;
            this.btNo.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }

      internal function onBtNo(param1:MouseEvent) : void
      {
         var _loc1_:Class = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(this.rootClass.litePreference.data.dOptions["warnDecline"])
         {
            if(!this.allowPass)
            {
               _loc1_ = this.rootClass.world.getClass("ModalMC");
               _loc2_ = new _loc1_();
               _loc3_ = {};
               _loc3_.strBody = "Are you sure you want to decline the drop for " + this.itemObj.sName + "?";
               _loc3_.callback = this.onDeclineDrop;
               _loc3_.params = {"sName":this.itemObj.sName};
               _loc3_.glow = "red,medium";
               _loc3_.btns = "dual";
               this.rootClass.stage.addChild(_loc2_);
               _loc2_.init(_loc3_);
               return;
            }
         }
         this.rootClass.cDropsUI.onBtNo(this.itemObj);
         this.allowPass = false;
         this.rootClass.stage.focus = null;
      }

      internal function onBtPreview(param1:MouseEvent) : void
      {
         if(this.rootClass.ui.getChildByName("qRewardPrev"))
         {
            this.rootClass.ui.getChildByName("qRewardPrev").fClose();
         }
         var _loc1_:* = this.rootClass.ui.addChild(new qRewardPrev(this.itemObj));
         _loc1_.world = this.rootClass.world;
         _loc1_.rootClass = this.rootClass;
         _loc1_.isDropPreview();
         _loc1_.open();
         this.rootClass.stage.focus = null;
      }

      internal function onHighlight(param1:MouseEvent) : void
      {
         this.gotoAndStop("hover");
         this.btYes.visible = true;
         this.btNo.visible = true;
         this.btPreview.visible = true;
      }

      internal function onDeHighlight(param1:MouseEvent) : void
      {
         this.gotoAndStop("idle");
         this.btYes.visible = false;
         this.btNo.visible = false;
         this.btPreview.visible = false;
      }
   }
}
