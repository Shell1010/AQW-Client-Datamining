package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1986")]
   public class LPFFrameCostDisplay extends LPFFrame
   {

      public var bg:MovieClip;

      public var mcCoins:MovieClip;

      public var mcGold:MovieClip;

      private var rootClass:MovieClip;

      private var r:Object;

      private var tfToken:TextField;

      public function LPFFrameCostDisplay()
      {
         super();
         x = 0;
         y = 0;
         fData = {};
      }

      override public function fOpen(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.tfToken = LPFElementInvAQRow.makeTF(11,16777215);
         this.tfToken.multiline = true;
         this.tfToken.wordWrap = true;
         this.tfToken.visible = false;
         addChild(this.tfToken);
         fData = param1.fData;
         if("eventTypes" in param1)
         {
            eventTypes = param1.eventTypes;
         }
         if("r" in param1)
         {
            this.r = param1.r;
         }
         this.fDraw();
         this.positionBy(this.r);
         if(this.tfToken.visible)
         {
            this.drawToken();
         }
         getLayout().registerForEvents(this,eventTypes);
         this.mcCoins.addEventListener(MouseEvent.MOUSE_OVER,this.onCoinsTTOver,false,0,true);
         this.mcCoins.addEventListener(MouseEvent.MOUSE_OUT,this.onTTOut,false,0,true);
         this.mcGold.addEventListener(MouseEvent.MOUSE_OVER,this.onGoldTTOver,false,0,true);
         this.mcGold.addEventListener(MouseEvent.MOUSE_OUT,this.onTTOut,false,0,true);
         this.mcGold.hit.alpha = 0;
         this.mcCoins.hit.alpha = 0;
      }

      override public function fClose() : void
      {
         this.mcCoins.removeEventListener(MouseEvent.MOUSE_OVER,this.onCoinsTTOver);
         this.mcCoins.removeEventListener(MouseEvent.MOUSE_OUT,this.onTTOut);
         this.mcGold.removeEventListener(MouseEvent.MOUSE_OVER,this.onGoldTTOver);
         this.mcGold.removeEventListener(MouseEvent.MOUSE_OUT,this.onTTOut);
         getLayout().unregisterFrame(this);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function get qty_parent() : *
      {
         return MovieClip(MovieClip(parent).parent).iQty ? MovieClip(MovieClip(parent).parent) : MovieClip(parent);
      }

      private function fDraw() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         visible = false;
         _loc1_ = getLayout().sMode == "shopSell";
         var _loc5_:Number = 0;
         var _loc6_:String = "#FFFFFF";
         if(getLayout().sMode.indexOf("shop") > -1 && fData != null)
         {
            visible = true;
            this.mcGold.visible = false;
            this.mcCoins.visible = false;
            this.mcGold.x = 0;
            this.mcCoins.x = 0;
            this.mcGold.ti.text = "";
            this.mcCoins.ti.text = "";
            this.tfToken.visible = false;
            this.bg.visible = true;
            _loc5_ = Number(fData.iCost);
            if(this.qty_parent.eSel != null && getLayout().sMode == "shopBuy" && getLayout().hasOwnProperty("splitPanel"))
            {
               if(getLayout().splitPanel.visible)
               {
                  _loc3_ = int(getLayout().splitPanel.frames[2].mc.getSelected());
                  if(_loc3_ > 1)
                  {
                     _loc5_ *= _loc3_;
                  }
               }
            }
            else if(Boolean(getLayout().sMode.indexOf("shop") > -1 && this.qty_parent) && Boolean(this.hasSlider()) && this.qty_parent.iQty > 1)
            {
               if(fData.sES != "ar")
               {
                  _loc5_ *= this.qty_parent.iQty;
               }
            }
            _loc2_ = !_loc1_ && this.rootClass.ui.mcPopup.currentLabel != "MergeShop" && InvCat.isToken(fData);
            if(_loc5_ > 0 || _loc2_)
            {
               if(_loc5_ > 0)
               {
                  if("bCoins" in fData && fData.bCoins == 1)
                  {
                     if(_loc1_)
                     {
                        _loc4_ = new Date().getTime();
                        fData.iHrs = (_loc4_ - fData.tPurchase) / (1000 * 60 * 60);
                        if(fData.ItemID == 8939)
                        {
                           _loc5_ = Math.ceil(_loc5_ / 4);
                        }
                        else if(fData.iHrs < 24)
                        {
                           _loc5_ = Math.ceil(_loc5_ * 9 / 10);
                        }
                        else
                        {
                           _loc5_ = Math.ceil(_loc5_ / 4);
                        }
                     }
                     else if(_loc5_ > this.rootClass.world.myAvatar.objData.intCoins)
                     {
                        _loc6_ = "#FF0000";
                     }
                     this.mcCoins.ti.htmlText = "<font color=\'" + _loc6_ + "\'>" + this.rootClass.strNumWithCommas(_loc5_) + "</font>";
                     this.mcCoins.visible = true;
                  }
                  else
                  {
                     if(_loc1_)
                     {
                        _loc5_ = Math.ceil(_loc5_ / 4);
                     }
                     else if(_loc5_ > this.rootClass.world.myAvatar.objData.intGold)
                     {
                        _loc6_ = "#FF0000";
                     }
                     this.mcGold.ti.htmlText = "<font color=\'" + _loc6_ + "\'>" + this.rootClass.strNumWithCommas(_loc5_) + "</font>";
                     this.mcGold.visible = true;
                  }
                  this.mcGold.hit.width = this.mcGold.ti.x + this.mcGold.ti.textWidth + 2;
                  this.mcCoins.hit.width = this.mcCoins.ti.x + this.mcCoins.ti.textWidth + 2;
               }
               this.bg.visible = this.mcGold.visible || this.mcCoins.visible;
               if(_loc2_)
               {
                  this.drawToken();
               }
               if(this.rootClass.ui.mcPopup.currentLabel == "MergeShop" && Boolean(this.hasSlider()))
               {
                  this.positionBy({
                     "x":int(fParent.w / 2),
                     "y":-102,
                     "w":-1,
                     "h":-1,
                     "xPosRule":"centerOnX"
                  });
               }
               else if(this.rootClass.ui.mcPopup.currentLabel == "MergeShop" && !this.hasSlider())
               {
                  this.positionBy(this.r);
               }
               visible = true;
            }
            else
            {
               visible = false;
            }
         }
      }

      private function drawToken() : void
      {
         var _loc1_:Object = null;
         var _loc2_:int = Boolean(this.qty_parent) && this.qty_parent.iQty > 0 ? int(this.qty_parent.iQty) : 1;
         var _loc3_:int = InvCat.tokenNeed(fData,_loc2_);
         var _loc4_:int = InvCat.tokenHave(fData,this.rootClass.world);
         var _loc5_:String = "<font color=\'#BBBBBB\'>Requires:</font> <b>" + _loc3_ + " x " + InvCat.tokenName(fData,this.rootClass.world) + "</b><br>";
         if(_loc4_ >= _loc3_)
         {
            _loc5_ += "<font color=\'#7CFC00\'>You have " + _loc4_ + "</font>";
         }
         else
         {
            _loc5_ += "<font color=\'#FF4444\'>You have " + _loc4_ + "</font>";
            _loc1_ = this.rootClass.world.bankinfo;
            if(_loc1_ != null && Boolean(_loc1_.isItemInBank(fData.TokID)))
            {
               _loc5_ += "<font color=\'#999999\'> (+" + _loc1_.getBankItem(fData.TokID).iQty + " in bank)</font>";
            }
         }
         var _loc6_:Number = this.bg.visible ? x - 8 : fParent.w - 22;
         this.tfToken.width = Math.max(60,_loc6_ - 22);
         this.tfToken.htmlText = _loc5_;
         this.tfToken.x = 22 - x;
         this.tfToken.y = 359 - this.tfToken.height - y;
         this.tfToken.visible = true;
      }

      private function hasSlider() : Boolean
      {
         if(getLayout().sMode == "shopBuy" && (this.rootClass.world.maximumShopBuys(fData) < 2 || fData.bCoins == 1 && fData.iCost > 0))
         {
            return false;
         }
         if(getLayout().sMode == "shopSell" && this.rootClass.world.maximumShopSells(fData) < 2)
         {
            return false;
         }
         return true;
      }

      override protected function positionBy(param1:Object) : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.mcGold.visible)
         {
            this.bg.width = this.mcGold.x + this.mcGold.ti.x + this.mcGold.ti.textWidth + 10;
            w = this.bg.width;
            _loc2_ = 1;
         }
         else
         {
            this.bg.width = this.mcCoins.x + this.mcCoins.ti.x + this.mcCoins.ti.textWidth + 10;
            w = this.bg.width;
         }
         if(param1 != null && "xPosRule" in param1)
         {
            if(param1.xPosRule == "centerOnX")
            {
               x = int(param1.x - w / 2) + _loc2_;
            }
         }
         else if(param1.x > -1)
         {
            x = param1.x;
         }
         else
         {
            x = int(fParent.w / 2 - w / 2) + _loc2_;
         }
         if(param1.y > -1)
         {
            y = param1.y;
         }
         else if(param1.y == -1)
         {
            _loc1_ = fParent.numChildren;
            if(_loc1_ > 1)
            {
               y = fParent.getChildAt(_loc1_ - 2).y + fParent.getChildAt(_loc1_ - 2).height + 10;
            }
            else
            {
               y = 10;
            }
         }
         else
         {
            y = fParent.h + param1.y;
         }
      }

      override public function notify(param1:Object) : void
      {
         if(param1.eventType == "listItemASel" || param1.eventType == "listItemBSel")
         {
            if(param1.fData != null && param1.fData.oSel != null)
            {
               fData = param1.fData.oSel;
            }
            this.fDraw();
         }
         if(param1.eventType == "updateQtyValue")
         {
            this.fDraw();
         }
      }

      private function onCoinsTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Adventure Coins"});
      }

      private function onGoldTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Gold"});
      }

      private function onTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }
   }
}
