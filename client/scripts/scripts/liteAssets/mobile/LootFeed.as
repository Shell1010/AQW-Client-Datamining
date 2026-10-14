package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class LootFeed extends Sprite
   {

      private static var inst:LootFeed;

      private static const ROW_H:int = 30;

      private static const GAP:int = 4;

      private static const SLOT:int = 26;

      private static const MAX_ROWS:int = 5;

      private static const IN_MS:int = 220;

      private static const HOLD_MS:int = 3500;

      private static const OUT_MS:int = 320;

      private static const POP_MS:int = 220;

      private static const SLIDE:int = 46;

      private static const EDGE:int = 10;

      private static const STAGE_W:int = 960;

      private static const DEFAULT_BOTTOM:int = 330;

      private static const TEXT_SHADOW:DropShadowFilter = new DropShadowFilter(1,90,0,0.9,2,2,2,1);

      private static const POP_GLOW:GlowFilter = new GlowFilter(16766282,0.8,8,8,2,1);

      private var g:MovieClip;

      private var rows:Array = [];

      public function LootFeed(param1:MovieClip)
      {
         super();
         this.g = param1;
         mouseEnabled = false;
         mouseChildren = false;
      }

      public static function push(param1:MovieClip, param2:Object, param3:int) : void
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:int = 0;
         if(param1 == null || param2 == null || param1.ui == null)
         {
            return;
         }
         if(param3 < 1)
         {
            param3 = 1;
         }
         try
         {
            if(inst == null || inst.parent == null)
            {
               inst = new LootFeed(param1);
               _loc1_ = param1.ui as DisplayObjectContainer;
               _loc2_ = _loc1_.numChildren;
               try
               {
                  _loc2_ = _loc1_.getChildIndex(param1.ui.mcPopup);
               }
               catch(e1:Error)
               {
               }
               _loc1_.addChildAt(inst,_loc2_);
            }
            inst.add(param2,param3);
         }
         catch(e:Error)
         {
         }
      }

      public static function clear() : void
      {
         if(inst == null)
         {
            return;
         }
         inst.dispose();
         inst = null;
      }

      private function bottomY() : Number
      {
         var _loc3_:Rectangle = null;
         var _loc4_:Array = MobileHUD.zones();
         var _loc5_:Number = -1;
         for each(_loc3_ in _loc4_)
         {
            if(_loc3_.x + _loc3_.width / 2 > STAGE_W / 2)
            {
               _loc5_ = _loc5_ < 0 ? _loc3_.y : Math.min(_loc5_,_loc3_.y);
            }
         }
         return _loc5_ > 0 ? _loc5_ - 8 : Number(DEFAULT_BOTTOM);
      }

      private function add(param1:Object, param2:int) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc3_:String = String(param1.ItemID);
         for each(_loc1_ in this.rows)
         {
            if(_loc1_.id == _loc3_ && _loc1_.state != "out")
            {
               _loc1_.qty += param2;
               this.setText(_loc1_);
               if(_loc1_.state == "hold")
               {
                  _loc1_.t0 = getTimer();
               }
               _loc1_.pop = getTimer();
               return;
            }
         }
         _loc2_ = this.build(param1,param2);
         this.rows.push(_loc2_);
         _loc6_ = 0;
         _loc7_ = int(this.rows.length - 1);
         while(_loc7_ >= 0)
         {
            if(this.rows[_loc7_].state != "out")
            {
               if(++_loc6_ > MAX_ROWS)
               {
                  this.startOut(this.rows[_loc7_]);
               }
            }
            _loc7_--;
         }
         this.layout(true);
         if(!hasEventListener(Event.ENTER_FRAME))
         {
            addEventListener(Event.ENTER_FRAME,this.onFrame,false,0,true);
         }
      }

      private function build(param1:Object, param2:int) : Object
      {
         var q:TextField;
         var n:TextField;
         var slot:Shape;
         var ic:DisplayObject;
         var row:Object;
         var item:Object = param1;
         var qty:int = param2;
         var s:Sprite = new Sprite();
         var plate:Shape = new Shape();
         s.addChild(plate);
         q = MailArt.tf(12,12432806,true);
         q.filters = [TEXT_SHADOW];
         s.addChild(q);
         n = MailArt.tf(13,DropSlot.nameColor(item),true);
         n.filters = [TEXT_SHADOW];
         s.addChild(n);
         slot = new Shape();
         s.addChild(slot);
         ic = null;
         try
         {
            ic = DropSlot.icon(this.g,item);
         }
         catch(e:Error)
         {
            ic = null;
         }
         if(ic != null)
         {
            s.addChild(ic);
         }
         addChild(s);
         row = {
            "id":String(item.ItemID),
            "name":String(item.sName),
            "qty":qty,
            "sprite":s,
            "plate":plate,
            "qTf":q,
            "nTf":n,
            "slot":slot,
            "icon":ic,
            "state":"in",
            "t0":getTimer(),
            "pop":0,
            "y":-1,
            "w":0
         };
         this.setText(row);
         s.alpha = 0;
         return row;
      }

      private function setText(param1:Object) : void
      {
         var _loc1_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc9_:Rectangle = null;
         var _loc10_:Number = NaN;
         var _loc5_:TextField = param1.qTf;
         var _loc3_:TextField = param1.nTf;
         _loc5_.text = "x" + param1.qty;
         _loc3_.text = param1.name;
         MailArt.fit(_loc3_,220);
         _loc1_ = 12 + Math.round(_loc5_.width) + 4 + Math.round(_loc3_.width) + 8 + SLOT + 6;
         param1.w = _loc1_;
         var _loc2_:Sprite = param1.sprite;
         var _loc6_:int = -_loc1_;
         _loc5_.scaleX = _loc5_.scaleY = 1;
         _loc5_.x = _loc6_ + 12;
         _loc5_.y = Math.round((ROW_H - _loc5_.height) / 2);
         param1.qx = _loc5_.x;
         param1.qy = _loc5_.y;
         param1.qw = _loc5_.width;
         param1.qh = _loc5_.height;
         _loc3_.x = _loc5_.x + Math.round(_loc5_.width) + 4;
         _loc3_.y = Math.round((ROW_H - _loc3_.height) / 2);
         var _loc7_:int = -SLOT - 4;
         var _loc11_:int = Math.round((ROW_H - SLOT) / 2);
         this.drawPlate(Shape(param1.plate).graphics,_loc6_,_loc1_);
         var _loc12_:Graphics = Shape(param1.slot).graphics;
         _loc12_.clear();
         _loc12_.lineStyle(1,13145646,0.9,true);
         _loc12_.beginFill(723723,0.9);
         _loc12_.drawRoundRect(_loc7_,_loc11_,SLOT,SLOT,6,6);
         _loc12_.endFill();
         _loc8_ = param1.icon;
         if(_loc8_ != null)
         {
            _loc8_.scaleX = _loc8_.scaleY = 1;
            _loc9_ = _loc8_.getBounds(_loc8_);
            if(_loc9_.width > 0 && _loc9_.height > 0)
            {
               _loc10_ = Math.min((SLOT - 6) / _loc9_.width,(SLOT - 6) / _loc9_.height);
               _loc8_.scaleX = _loc8_.scaleY = _loc10_;
               _loc8_.x = _loc7_ + SLOT / 2 - (_loc9_.x + _loc9_.width / 2) * _loc10_;
               _loc8_.y = _loc11_ + SLOT / 2 - (_loc9_.y + _loc9_.height / 2) * _loc10_;
            }
         }
      }

      private function drawPlate(param1:Graphics, param2:int, param3:int) : void
      {
         param1.clear();
         var _loc1_:Matrix = new Matrix();
         _loc1_.createGradientBox(param3,ROW_H,0,param2,0);
         param1.lineStyle(1,13145646,0.55,true);
         param1.beginGradientFill(GradientType.LINEAR,[921102,1842204],[0.55,0.9],[0,200],_loc1_);
         param1.moveTo(param2 + 10,0);
         param1.lineTo(0,0);
         param1.lineTo(0,ROW_H);
         param1.lineTo(param2 + 10,ROW_H);
         param1.lineTo(param2,ROW_H / 2);
         param1.lineTo(param2 + 10,0);
         param1.endFill();
      }

      private function startOut(param1:Object) : void
      {
         if(param1.state == "out")
         {
            return;
         }
         param1.state = "out";
         param1.t0 = getTimer();
      }

      private function layout(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc5_:Number = Number(this.bottomY());
         var _loc3_:Number = _loc5_ - ROW_H;
         var _loc1_:* = int(this.rows.length - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = this.rows[_loc1_];
            if(_loc2_.state != "out")
            {
               _loc2_.ty = _loc3_;
               if(param1 && _loc2_.y < 0)
               {
                  _loc2_.y = _loc3_;
               }
               _loc3_ -= ROW_H + GAP;
            }
            _loc1_--;
         }
      }

      private function onFrame(param1:Event) : void
      {
         var _loc2_:Object = null;
         var _loc6_:Sprite = null;
         var _loc7_:int = 0;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc5_:int = int(getTimer());
         var _loc3_:Array = [];
         var _loc1_:Boolean = false;
         for each(_loc2_ in this.rows)
         {
            _loc6_ = _loc2_.sprite;
            _loc7_ = _loc5_ - _loc2_.t0;
            _loc11_ = 0;
            if(_loc2_.state == "in")
            {
               _loc8_ = Math.min(1,_loc7_ / IN_MS);
               _loc9_ = 1 - Math.pow(1 - _loc8_,3);
               _loc6_.alpha = _loc9_;
               _loc11_ = SLIDE * (1 - _loc9_);
               if(_loc8_ >= 1)
               {
                  _loc2_.state = "hold";
                  _loc2_.t0 = _loc5_;
               }
            }
            else if(_loc2_.state == "hold")
            {
               _loc6_.alpha = 1;
               if(_loc7_ >= HOLD_MS)
               {
                  this.startOut(_loc2_);
               }
            }
            else
            {
               _loc10_ = Math.min(1,_loc7_ / OUT_MS);
               _loc6_.alpha = 1 - _loc10_;
               _loc11_ = SLIDE * 0.7 * _loc10_ * _loc10_;
               if(_loc10_ >= 1)
               {
                  if(_loc6_.parent != null)
                  {
                     _loc6_.parent.removeChild(_loc6_);
                  }
                  _loc1_ = true;
                  continue;
               }
            }
            if(_loc2_.ty != null)
            {
               _loc2_.y += (Number(_loc2_.ty) - _loc2_.y) * 0.3;
            }
            _loc6_.x = STAGE_W - EDGE + _loc11_;
            _loc6_.y = Math.round(_loc2_.y);
            _loc12_ = _loc2_.pop > 0 ? (_loc5_ - _loc2_.pop) / POP_MS : 1;
            if(_loc12_ < 1)
            {
               _loc13_ = 1 + 0.35 * Math.sin(_loc12_ * Math.PI);
               TextField(_loc2_.qTf).scaleX = TextField(_loc2_.qTf).scaleY = _loc13_;
               TextField(_loc2_.qTf).x = _loc2_.qx - _loc2_.qw * (_loc13_ - 1) / 2;
               TextField(_loc2_.qTf).y = _loc2_.qy - _loc2_.qh * (_loc13_ - 1) / 2;
               POP_GLOW.alpha = 0.8 * (1 - _loc12_);
               TextField(_loc2_.qTf).filters = [TEXT_SHADOW,POP_GLOW];
            }
            else if(_loc2_.pop > 0)
            {
               TextField(_loc2_.qTf).scaleX = TextField(_loc2_.qTf).scaleY = 1;
               TextField(_loc2_.qTf).x = _loc2_.qx;
               TextField(_loc2_.qTf).y = _loc2_.qy;
               TextField(_loc2_.qTf).filters = [TEXT_SHADOW];
               _loc2_.pop = 0;
            }
            _loc3_.push(_loc2_);
         }
         this.rows = _loc3_;
         if(_loc1_)
         {
            this.layout(false);
         }
         if(this.rows.length == 0)
         {
            this.dispose();
         }
      }

      private function dispose() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onFrame);
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         this.rows = [];
         if(parent != null)
         {
            parent.removeChild(this);
         }
         if(inst == this)
         {
            inst = null;
         }
      }
   }
}
