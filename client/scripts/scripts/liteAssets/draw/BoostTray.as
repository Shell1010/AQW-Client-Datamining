package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.utils.*;

   public class BoostTray extends Sprite
   {

      private static const PAD:int = 7;

      private static const GAP:int = 3;

      private static const HW:int = 26;

      private static const HH:int = 11;

      private static const RAD:int = 8;

      private static const ANIM_MS:int = 260;

      private static const BANDS:Array = [1513239,5262150,4407098,6445910,1381653,2500134];

      private static const HOMES:Array = [["mcPartyFrame","posParty",110.85],["playerAuras","posAurasP",100]];

      private var g:MovieClip;

      private var p:MovieClip;

      private var tab:Shape = new Shape();

      private var icons:Sprite = new Sprite();

      private var clip:Shape = new Shape();

      private var arrow:Sprite = new Sprite();

      private var chev:Shape = new Shape();

      private var open:Boolean = true;

      private var k:Number = 1;

      private var last:int;

      private var joinY:int;

      private var fullBot:int;

      private var L:int;

      private var R:int;

      private var aligned:Boolean;

      public function BoostTray(param1:MovieClip, param2:MovieClip)
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Graphics = null;
         var _loc3_:Graphics = null;
         super();
         this.g = param1;
         this.p = param2;
         name = "boostTray";
         addEventListener(MouseEvent.CLICK,this.onSwallow,false,0,true);
         try
         {
            this.open = this.g.litePreference.data.bBoostsHidden != true;
         }
         catch(e:Error)
         {
         }
         this.k = this.open ? 1 : 0;
         var _loc4_:int = int(this.p.numChildren);
         for each(_loc1_ in this.list())
         {
            _loc4_ = Math.min(_loc4_,this.p.getChildIndex(_loc1_));
         }
         this.p.addChildAt(this,_loc4_);
         addChild(this.tab);
         addChild(this.icons);
         addChild(this.clip);
         this.icons.mask = this.clip;
         for each(_loc1_ in this.list())
         {
            this.icons.addChild(_loc1_);
         }
         _loc2_ = this.arrow.graphics;
         _loc2_.beginFill(0,0);
         _loc2_.drawRect(-17,-10,34,22);
         _loc2_.endFill();
         _loc3_ = this.chev.graphics;
         _loc3_.lineStyle(2,14272931,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         _loc3_.moveTo(-4,2);
         _loc3_.lineTo(0,-2);
         _loc3_.lineTo(4,2);
         this.chev.alpha = 0.8;
         this.arrow.addChild(this.chev);
         this.arrow.buttonMode = true;
         this.arrow.mouseChildren = false;
         this.arrow.addEventListener(MouseEvent.CLICK,this.onToggle,false,0,true);
         this.arrow.addEventListener(MouseEvent.ROLL_OVER,this.onOver,false,0,true);
         this.arrow.addEventListener(MouseEvent.ROLL_OUT,this.onOut,false,0,true);
         addChild(this.arrow);
      }

      public static function layout(param1:MovieClip) : void
      {
         var _loc5_:MovieClip = null;
         var _loc4_:BoostTray = null;
         try
         {
            _loc5_ = param1.ui.mcPortrait;
            if(_loc5_.SP == null)
            {
               return;
            }
            _loc4_ = _loc5_.getChildByName("boostTray") as BoostTray;
            if(_loc4_ == null)
            {
               _loc4_ = new BoostTray(param1,_loc5_);
            }
            _loc4_.arrange();
         }
         catch(e:Error)
         {
         }
      }

      private function list() : Array
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Array = [];
         for each(_loc5_ in [this.p.iconBoostXP,this.p.iconBoostG,this.p.iconBoostRep,this.p.iconBoostCP])
         {
            if(_loc5_ != null)
            {
               _loc6_.push(_loc5_);
            }
         }
         return _loc6_;
      }

      public function arrange() : void
      {
         var _loc1_:int = 0;
         var _loc7_:MovieClip = null;
         var _loc8_:Rectangle = null;
         var _loc6_:MovieClip = this.p.SP;
         var _loc5_:Rectangle = (_loc6_.numChildren > 0 ? _loc6_.getChildAt(0) : _loc6_).getBounds(this.p);
         this.joinY = Math.round(_loc5_.bottom) + 6;
         var _loc4_:int = Math.round(_loc5_.x) - 3;
         _loc1_ = Math.round(_loc5_.right) + 7;
         var _loc2_:Array = [];
         var _loc3_:Array = [];
         var _loc9_:int = -GAP;
         for each(_loc7_ in this.list())
         {
            if(_loc7_.visible)
            {
               _loc8_ = (_loc7_.numChildren > 0 ? _loc7_.getChildAt(0) : _loc7_).getBounds(this.icons);
               _loc2_.push(_loc7_);
               _loc3_.push(_loc8_);
               _loc9_ += Math.round(_loc8_.width) + GAP;
            }
         }
         visible = _loc2_.length > 0;
         if(!visible)
         {
            this.push(0);
            return;
         }
         var _loc10_:int = _loc9_ + PAD * 2;
         this.L = Math.round((_loc4_ + _loc1_ - _loc10_) / 2);
         this.R = this.L + _loc10_;
         this.aligned = this.R > _loc1_ - 6;
         if(this.aligned)
         {
            this.R = _loc1_;
            this.L = this.R - _loc10_;
         }
         var _loc11_:int = this.L + PAD;
         var _loc12_:int = this.joinY + 3;
         var _loc13_:int = 0;
         while(_loc13_ < _loc2_.length)
         {
            _loc8_ = _loc3_[_loc13_];
            _loc2_[_loc13_].x += _loc11_ - _loc8_.x;
            _loc2_[_loc13_].y += _loc12_ - _loc8_.y;
            _loc11_ += Math.round(_loc8_.width) + GAP;
            _loc13_++;
         }
         this.fullBot = _loc12_ + 32;
         this.draw();
      }

      private function rect(param1:Graphics, param2:uint, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : void
      {
         if(param5 <= 0 || param6 <= 0)
         {
            return;
         }
         param7 = Math.max(0,Math.min(param7,param6,param5 / 2));
         param1.beginFill(param2);
         param1.moveTo(param3,param4);
         param1.lineTo(param3 + param5,param4);
         param1.lineTo(param3 + param5,param4 + param6 - param7);
         if(param7 > 0)
         {
            param1.curveTo(param3 + param5,param4 + param6,param3 + param5 - param7,param4 + param6);
         }
         param1.lineTo(param3 + param7,param4 + param6);
         if(param7 > 0)
         {
            param1.curveTo(param3,param4 + param6,param3,param4 + param6 - param7);
         }
         param1.lineTo(param3,param4);
         param1.endFill();
      }

      private function draw() : void
      {
         var _loc7_:uint = 0;
         var _loc10_:int = 0;
         var _loc6_:Number = this.k * this.k * (3 - 2 * this.k);
         var _loc5_:int = Math.round(this.joinY + (this.fullBot - this.joinY) * _loc6_);
         var _loc4_:int = Math.round((this.L + this.R - HW) / 2);
         var _loc1_:Boolean = Boolean(this.aligned) && _loc5_ - RAD > this.joinY;
         var _loc2_:Graphics = this.tab.graphics;
         _loc2_.clear();
         var _loc3_:int = 0;
         while(_loc3_ < BANDS.length)
         {
            _loc7_ = uint(BANDS[_loc3_]);
            _loc10_ = this.joinY - 1 - Math.min(_loc3_,4);
            if(_loc5_ > this.joinY)
            {
               this.rect(_loc2_,_loc7_,this.L + _loc3_,_loc10_,this.R - this.L - 2 * _loc3_,_loc5_ - _loc3_ - _loc10_,Math.min(RAD - _loc3_,_loc5_ - this.joinY));
            }
            if(_loc1_)
            {
               this.rect(_loc2_,_loc7_,this.R - 7,this.joinY - 9,7 - _loc3_,_loc5_ - RAD - this.joinY + 9,0);
            }
            this.rect(_loc2_,_loc7_,_loc4_ + _loc3_,_loc5_ - 1 - Math.min(_loc3_,4),HW - 2 * _loc3_,HH + 1 + Math.min(_loc3_,4) - _loc3_,5 - _loc3_);
            _loc3_++;
         }
         var _loc9_:Graphics = this.clip.graphics;
         _loc9_.clear();
         _loc9_.beginFill(0);
         _loc9_.drawRect(this.L + 5,this.joinY - 1,this.R - this.L - 10,Math.max(0,_loc5_ - 4 - this.joinY));
         _loc9_.endFill();
         this.icons.y = _loc5_ - this.fullBot;
         this.icons.mouseChildren = this.k >= 1;
         this.arrow.x = _loc4_ + HW / 2;
         this.arrow.y = _loc5_ + 2;
         this.arrow.rotation = 180 * (1 - _loc6_);
         this.push(this.p.y + (_loc5_ + HH + 3) * this.p.scaleY);
      }

      private function push(param1:Number) : void
      {
         var _loc5_:MovieClip = null;
         var _loc4_:Array = null;
         var _loc1_:DisplayObject = null;
         try
         {
            _loc5_ = this.g.ui;
            for each(_loc4_ in HOMES)
            {
               _loc1_ = _loc5_.getChildByName(_loc4_[0]);
               if(!(_loc1_ == null || this.g.litePreference.data[_loc4_[1]] != null))
               {
                  _loc1_.y = Math.max(_loc4_[2],param1);
               }
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onToggle(param1:MouseEvent) : void
      {
         this.open = !this.open;
         try
         {
            this.g.litePreference.data.bBoostsHidden = !this.open;
            this.g.litePreference.flush();
         }
         catch(err:Error)
         {
         }
         this.last = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onFrame,false,0,true);
      }

      private function onFrame(param1:Event) : void
      {
         var _loc5_:int = int(getTimer());
         var _loc4_:Number = (_loc5_ - this.last) / ANIM_MS;
         this.last = _loc5_;
         this.k = this.open ? Math.min(1,this.k + _loc4_) : Math.max(0,this.k - _loc4_);
         this.draw();
         if(this.k == (this.open ? 1 : 0))
         {
            removeEventListener(Event.ENTER_FRAME,this.onFrame);
         }
      }

      private function onSwallow(param1:MouseEvent) : void
      {
         param1.stopPropagation();
      }

      private function onOver(param1:MouseEvent) : void
      {
         this.chev.alpha = 1;
      }

      private function onOut(param1:MouseEvent) : void
      {
         this.chev.alpha = 0.8;
      }
   }
}
