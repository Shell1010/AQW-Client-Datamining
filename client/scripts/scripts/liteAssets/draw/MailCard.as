package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.TextField;

   public class MailCard extends Sprite
   {

      private static const POP_MS:Number = 260;

      private static const SHIMMER_MS:Number = 700;

      private static const SHIMMER_CYCLE:Number = 3500;

      private static const GREY_MATRIX:Array = [0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0];

      private var rootClass:MovieClip;

      private var att:Object;

      private var index:int;

      private var content:Sprite;

      private var slot:Sprite;

      private var iconHolder:Sprite;

      private var iconD:DisplayObject;

      private var acMarkTf:TextField;

      private var qtyTf:TextField;

      private var labelTf:TextField;

      private var checkHolder:Sprite;

      private var shimmerBand:Shape;

      private var shimmerMask:Shape;

      private var shimmerEnabled:Boolean;

      private var visualClaimed:Boolean;

      private var hoverOpen:Boolean = false;

      private var popPending:Boolean = false;

      private var popDelay:int = 0;

      private var popAt:int = -1;

      private var popPlaying:Boolean = false;

      private var popStart:int = 0;

      public function MailCard(param1:MovieClip, param2:Object, param3:int)
      {
         super();
         this.rootClass = param1;
         this.att = param2 != null ? param2 : {};
         this.index = param3;
         this.shimmerEnabled = this.att.ok != 1;
         this.visualClaimed = this.att.ok == 1;
         mouseChildren = false;
         this.content = new Sprite();
         addChild(this.content);
         this.slot = new Sprite();
         this.content.addChild(this.slot);
         this.iconHolder = new Sprite();
         this.iconHolder.mouseEnabled = false;
         this.iconHolder.mouseChildren = false;
         this.content.addChild(this.iconHolder);
         if(this.shimmerEnabled)
         {
            this.buildShimmer();
         }
         this.checkHolder = new Sprite();
         this.checkHolder.mouseEnabled = false;
         this.checkHolder.mouseChildren = false;
         this.content.addChild(this.checkHolder);
         this.acMarkTf = MailArt.tf(9,MailArt.GOLD,true,true);
         this.content.addChild(this.acMarkTf);
         this.qtyTf = MailArt.tf(12,16777215,true);
         this.qtyTf.filters = [new GlowFilter(0,1,3,3,4)];
         this.content.addChild(this.qtyTf);
         this.labelTf = MailArt.tf(10,15260864);
         this.content.addChild(this.labelTf);
         this.drawSlot(false);
         this.drawIcon();
         this.drawAcMark();
         this.drawQty();
         this.drawLabel();
         this.drawClaimState();
         addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
      }

      public function tick(param1:int) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Boolean = false;
         var _loc3_:Number = NaN;
         try
         {
            if(this.popPending)
            {
               if(this.popAt < 0)
               {
                  this.popAt = param1 + this.popDelay;
               }
               if(param1 >= this.popAt)
               {
                  this.popPending = false;
                  this.popPlaying = true;
                  this.popStart = param1;
               }
            }
            if(this.popPlaying)
            {
               _loc1_ = (param1 - this.popStart) / POP_MS;
               _loc2_ = false;
               if(_loc1_ >= 1)
               {
                  _loc1_ = 1;
                  _loc2_ = true;
               }
               _loc3_ = 1 + 0.15 * (1 - Math.abs(2 * _loc1_ - 1));
               this.content.scaleX = this.content.scaleY = _loc3_;
               this.content.x = (64 - 64 * _loc3_) / 2;
               this.content.y = (74 - 74 * _loc3_) / 2;
               if(_loc2_)
               {
                  this.popPlaying = false;
                  this.content.scaleX = this.content.scaleY = 1;
                  this.content.x = 0;
                  this.content.y = 0;
                  this.visualClaimed = true;
                  this.drawClaimState();
               }
            }
            if(Boolean(this.shimmerEnabled) && !this.visualClaimed && this.shimmerBand != null)
            {
               this.tickShimmer(param1);
            }
         }
         catch(e:Error)
         {
         }
      }

      public function pop(param1:int) : void
      {
         this.popPending = true;
         this.popPlaying = false;
         this.popAt = -1;
         this.popDelay = param1;
      }

      public function destroy() : void
      {
         removeEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         removeEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         try
         {
            if(Boolean(this.hoverOpen) && this.rootClass != null)
            {
               this.rootClass.ui.ToolTip.close();
            }
         }
         catch(e:Error)
         {
         }
         this.hoverOpen = false;
         if(parent != null)
         {
            parent.removeChild(this);
         }
         this.rootClass = null;
         this.att = null;
      }

      private function strokeColor() : uint
      {
         if(this.att.c != null)
         {
            return uint(this.att.c);
         }
         switch(String(this.att.t))
         {
            case "item":
               return this.att.it != null && int(this.att.it.bUpg) == 1 ? 16566089 : 13145646;
            case "gold":
               return MailArt.GOLD;
            case "ac":
               return 16757504;
            case "xp":
               return 8190976;
            case "rep":
               return 11894492;
            case "cp":
               return 52479;
            default:
               return 13145646;
         }
      }

      private function drawSlot(param1:Boolean) : void
      {
         this.slot.x = 4;
         this.slot.y = 0;
         var _loc1_:Graphics = this.slot.graphics;
         _loc1_.clear();
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(56,56,0,0,0);
         _loc1_.beginGradientFill(GradientType.RADIAL,[3812380,1314312],[1,1],[0,255],_loc2_);
         _loc1_.lineStyle(2,param1 ? 16769162 : uint(this.strokeColor()),1,true);
         _loc1_.drawRoundRect(1,1,54,54,16,16);
         _loc1_.endFill();
      }

      private function fallbackLink() : String
      {
         switch(String(this.att.t))
         {
            case "gold":
               return "LPFIconGold";
            case "ac":
               return "LPFIconCoins";
            case "xp":
               return "xpBoost";
            case "rep":
               return "repBoost";
            case "cp":
               return "classBoost";
            default:
               return null;
         }
      }

      private function drawIcon() : void
      {
         var link:String = null;
         var fb:String = null;
         while(this.iconHolder.numChildren > 0)
         {
            this.iconHolder.removeChildAt(0);
         }
         this.iconHolder.graphics.clear();
         this.iconD = null;
         try
         {
            if(String(this.att.t) == "item")
            {
               link = this.att.it != null ? MailArt.itemLinkage(this.att.it) : "";
               this.iconD = MailArt.icon(this.rootClass,link);
               if(this.iconD == null)
               {
                  this.iconD = MailArt.icon(this.rootClass,"iibag");
               }
            }
            else
            {
               this.iconD = MailArt.icon(this.rootClass,this.att.ic != null ? String(this.att.ic) : "");
               if(this.iconD == null)
               {
                  fb = this.fallbackLink();
                  if(fb != null)
                  {
                     this.iconD = MailArt.icon(this.rootClass,fb);
                  }
               }
            }
         }
         catch(e:Error)
         {
            iconD = null;
         }
         this.iconHolder.x = 4 + 28;
         this.iconHolder.y = 28;
         if(this.iconD != null)
         {
            this.iconHolder.addChild(this.iconD);
            this.fitIcon(this.iconD);
         }
         else
         {
            this.drawStar();
         }
      }

      private function fitIcon(param1:DisplayObject) : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Number = NaN;
         _loc1_ = param1.getBounds(param1);
         if(_loc1_.width <= 0 || _loc1_.height <= 0)
         {
            return;
         }
         _loc2_ = Math.min(36 / _loc1_.width,36 / _loc1_.height);
         if(_loc2_ > 2)
         {
            _loc2_ = 2;
         }
         param1.scaleX = param1.scaleY = _loc2_;
         param1.x = -(_loc1_.x + _loc1_.width / 2) * _loc2_;
         param1.y = -(_loc1_.y + _loc1_.height / 2) * _loc2_;
      }

      private function drawStar() : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Graphics = this.iconHolder.graphics;
         _loc8_.clear();
         _loc8_.beginFill(MailArt.GOLD);
         var _loc1_:Number = 15;
         var _loc2_:Number = 6;
         _loc3_ = 0;
         while(_loc3_ < 10)
         {
            _loc4_ = -Math.PI / 2 + _loc3_ * Math.PI / 5;
            _loc5_ = _loc3_ % 2 == 0 ? _loc1_ : _loc2_;
            _loc6_ = Math.cos(_loc4_) * _loc5_;
            _loc7_ = Math.sin(_loc4_) * _loc5_;
            if(_loc3_ == 0)
            {
               _loc8_.moveTo(_loc6_,_loc7_);
            }
            else
            {
               _loc8_.lineTo(_loc6_,_loc7_);
            }
            _loc3_++;
         }
         _loc8_.endFill();
      }

      private function drawAcMark() : void
      {
         var _loc8_:Boolean = String(this.att.t) == "item" && this.att.it != null && int(this.att.it.bCoins) == 1;
         this.acMarkTf.visible = _loc8_;
         if(_loc8_)
         {
            this.acMarkTf.text = "AC";
            this.acMarkTf.x = 6;
            this.acMarkTf.y = 3;
         }
      }

      private function drawQty() : void
      {
         var _loc8_:Number = Number(this.att.q);
         var _loc1_:Boolean = String(this.att.t) == "item";
         var _loc2_:Boolean = _loc1_ ? _loc8_ > 1 : true;
         this.qtyTf.visible = _loc2_;
         if(_loc2_)
         {
            this.qtyTf.text = _loc1_ ? "x" + int(_loc8_) : MailArt.shortNum(_loc8_);
            this.qtyTf.x = Math.round(57 - this.qtyTf.width);
            this.qtyTf.y = Math.round(54 - this.qtyTf.height);
         }
      }

      private function labelText() : String
      {
         switch(String(this.att.t))
         {
            case "item":
               return this.att.n != null ? String(this.att.n) : "";
            case "gold":
               return "Gold";
            case "ac":
               return "AC";
            case "xp":
               return "XP";
            case "cp":
               return "Class Points";
            default:
               return this.att.n != null ? String(this.att.n) : "";
         }
      }

      private function drawLabel() : void
      {
         this.labelTf.text = this.labelText();
         MailArt.cover(this.labelTf);
         MailArt.fit(this.labelTf,64);
         this.labelTf.x = Math.round(32 - this.labelTf.width / 2);
         this.labelTf.y = 58;
      }

      private function drawClaimState() : void
      {
         while(this.checkHolder.numChildren > 0)
         {
            this.checkHolder.removeChildAt(0);
         }
         this.checkHolder.graphics.clear();
         if(this.iconD != null)
         {
            if(this.visualClaimed)
            {
               this.iconD.filters = [new ColorMatrixFilter(GREY_MATRIX)];
               this.iconD.alpha = 0.55;
            }
            else
            {
               this.iconD.filters = [];
               this.iconD.alpha = 1;
            }
         }
         if(this.visualClaimed)
         {
            MailArt.check(this.checkHolder.graphics,54,6,8);
            if(this.shimmerBand != null)
            {
               this.shimmerBand.visible = false;
            }
         }
      }

      private function buildShimmer() : void
      {
         this.shimmerMask = new Shape();
         this.shimmerMask.graphics.beginFill(16777215);
         this.shimmerMask.graphics.drawRoundRect(5,1,54,54,16,16);
         this.shimmerMask.graphics.endFill();
         this.content.addChild(this.shimmerMask);
         this.shimmerBand = new Shape();
         var _loc8_:Graphics = this.shimmerBand.graphics;
         var _loc1_:Matrix = new Matrix();
         _loc1_.createGradientBox(18,90,Math.PI / 2,-9,-45);
         _loc8_.beginGradientFill(GradientType.LINEAR,[16777215,16777215,16777215],[0,0.35,0],[0,128,255],_loc1_);
         _loc8_.drawRect(-9,-45,18,90);
         _loc8_.endFill();
         this.shimmerBand.rotation = 25;
         this.shimmerBand.y = 28;
         this.shimmerBand.mask = this.shimmerMask;
         this.shimmerBand.visible = false;
         this.content.addChild(this.shimmerBand);
      }

      private function tickShimmer(param1:int) : void
      {
         var _loc2_:Number = NaN;
         var _loc1_:Number = (param1 + this.index * 350) % SHIMMER_CYCLE;
         if(_loc1_ < SHIMMER_MS)
         {
            this.shimmerBand.visible = true;
            _loc2_ = _loc1_ / SHIMMER_MS;
            this.shimmerBand.x = -16 + _loc2_ * 96;
         }
         else
         {
            this.shimmerBand.visible = false;
         }
      }

      private function tooltipText() : String
      {
         var _loc1_:Object = null;
         var _loc2_:String = null;
         var _loc8_:Number = Number(this.att.q);
         if(String(this.att.t) == "item")
         {
            _loc1_ = this.att.it;
            _loc2_ = _loc1_ != null && _loc1_.sName != null ? String(_loc1_.sName) : (this.att.n != null ? String(this.att.n) : "");
            _loc2_ += "\n" + (_loc1_ != null && _loc1_.sType != null ? String(_loc1_.sType) : "");
            if(_loc1_ != null && Number(_loc1_.iLvl) > 0)
            {
               _loc2_ += ", Level " + int(_loc1_.iLvl);
            }
            if(_loc8_ > 1)
            {
               _loc2_ += "\nQuantity: " + MailArt.commas(_loc8_);
            }
            if(this.att.skip)
            {
               _loc2_ += "\nYou already owned this item.";
            }
            return _loc2_;
         }
         if(this.att.tip != null && String(this.att.tip).length > 0)
         {
            return String(this.att.tip);
         }
         return MailArt.commas(_loc8_) + " " + (this.att.n != null ? String(this.att.n) : "");
      }

      private function onRollOver(param1:MouseEvent) : void
      {
         try
         {
            this.drawSlot(true);
            if(this.rootClass != null)
            {
               this.rootClass.ui.ToolTip.openWith({"str":this.tooltipText()});
               this.hoverOpen = true;
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onRollOut(param1:MouseEvent) : void
      {
         try
         {
            this.drawSlot(false);
            if(Boolean(this.hoverOpen) && this.rootClass != null)
            {
               this.rootClass.ui.ToolTip.close();
            }
         }
         catch(err:Error)
         {
         }
         this.hoverOpen = false;
      }
   }
}
