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
         var _loc1_:Rectangle = null;
         var _loc2_:Array = MobileHUD.zones();
         var _loc3_:Number = -1;
         for each(_loc1_ in _loc2_)
         {
            if(_loc1_.x + _loc1_.width / 2 > STAGE_W / 2)
            {
               _loc3_ = _loc3_ < 0 ? _loc1_.y : Math.min(_loc3_,_loc1_.y);
            }
         }
         return _loc3_ > 0 ? _loc3_ - 8 : Number(DEFAULT_BOTTOM);
      }

      private function add(param1:Object, param2:int) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:* = 0;
         var _loc5_:String = String(param1.ItemID);
         for each(_loc1_ in this.rows)
         {
            if(_loc1_.id == _loc5_ && _loc1_.state != "out")
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
         _loc3_ = 0;
         _loc4_ = int(this.rows.length - 1);
         while(_loc4_ >= 0)
         {
            if(this.rows[_loc4_].state != "out")
            {
               if(++_loc3_ > MAX_ROWS)
               {
                  this.startOut(this.rows[_loc4_]);
               }
            }
            _loc4_--;
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
         var _loc2_:DisplayObject = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:TextField = param1.qTf;
         var _loc6_:TextField = param1.nTf;
         _loc5_.text = "x" + param1.qty;
         _loc6_.text = param1.name;
         MailArt.fit(_loc6_,220);
         _loc1_ = 12 + Math.round(_loc5_.width) + 4 + Math.round(_loc6_.width) + 8 + SLOT + 6;
         param1.w = _loc1_;
         var _loc7_:Sprite = param1.sprite;
         var _loc8_:int = -_loc1_;
         _loc5_.scaleX = _loc5_.scaleY = 1;
         _loc5_.x = _loc8_ + 12;
         _loc5_.y = Math.round((ROW_H - _loc5_.height) / 2);
         param1.qx = _loc5_.x;
         param1.qy = _loc5_.y;
         param1.qw = _loc5_.width;
         param1.qh = _loc5_.height;
         _loc6_.x = _loc5_.x + Math.round(_loc5_.width) + 4;
         _loc6_.y = Math.round((ROW_H - _loc6_.height) / 2);
         var _loc9_:int = -SLOT - 4;
         var _loc10_:int = Math.round((ROW_H - SLOT) / 2);
         this.drawPlate(Shape(param1.plate).graphics,_loc8_,_loc1_);
         var _loc11_:Graphics = Shape(param1.slot).graphics;
         _loc11_.clear();
         _loc11_.lineStyle(1,13145646,0.9,true);
         _loc11_.beginFill(723723,0.9);
         _loc11_.drawRoundRect(_loc9_,_loc10_,SLOT,SLOT,6,6);
         _loc11_.endFill();
         _loc2_ = param1.icon;
         if(_loc2_ != null)
         {
            _loc2_.scaleX = _loc2_.scaleY = 1;
            _loc3_ = _loc2_.getBounds(_loc2_);
            if(_loc3_.width > 0 && _loc3_.height > 0)
            {
               _loc4_ = Math.min((SLOT - 6) / _loc3_.width,(SLOT - 6) / _loc3_.height);
               _loc2_.scaleX = _loc2_.scaleY = _loc4_;
               _loc2_.x = _loc9_ + SLOT / 2 - (_loc3_.x + _loc3_.width / 2) * _loc4_;
               _loc2_.y = _loc10_ + SLOT / 2 - (_loc3_.y + _loc3_.height / 2) * _loc4_;
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
         var _loc1_:Object = null;
         var _loc2_:Number = Number(this.bottomY());
         var _loc3_:Number = _loc2_ - ROW_H;
         var _loc4_:* = int(this.rows.length - 1);
         while(_loc4_ >= 0)
         {
            _loc1_ = this.rows[_loc4_];
            if(_loc1_.state != "out")
            {
               _loc1_.ty = _loc3_;
               if(param1 && _loc1_.y < 0)
               {
                  _loc1_.y = _loc3_;
               }
               _loc3_ -= ROW_H + GAP;
            }
            _loc4_--;
         }
      }

      private function onFrame(param1:Event) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:int = int(getTimer());
         var _loc11_:Array = [];
         var _loc12_:Boolean = false;
         for each(_loc1_ in this.rows)
         {
            _loc2_ = _loc1_.sprite;
            _loc3_ = _loc10_ - _loc1_.t0;
            _loc4_ = 0;
            if(_loc1_.state == "in")
            {
               _loc6_ = Math.min(1,_loc3_ / IN_MS);
               _loc7_ = 1 - Math.pow(1 - _loc6_,3);
               _loc2_.alpha = _loc7_;
               _loc4_ = SLIDE * (1 - _loc7_);
               if(_loc6_ >= 1)
               {
                  _loc1_.state = "hold";
                  _loc1_.t0 = _loc10_;
               }
            }
            else if(_loc1_.state == "hold")
            {
               _loc2_.alpha = 1;
               if(_loc3_ >= HOLD_MS)
               {
                  this.startOut(_loc1_);
               }
            }
            else
            {
               _loc8_ = Math.min(1,_loc3_ / OUT_MS);
               _loc2_.alpha = 1 - _loc8_;
               _loc4_ = SLIDE * 0.7 * _loc8_ * _loc8_;
               if(_loc8_ >= 1)
               {
                  if(_loc2_.parent != null)
                  {
                     _loc2_.parent.removeChild(_loc2_);
                  }
                  _loc12_ = true;
                  continue;
               }
            }
            if(_loc1_.ty != null)
            {
               _loc1_.y += (Number(_loc1_.ty) - _loc1_.y) * 0.3;
            }
            _loc2_.x = STAGE_W - EDGE + _loc4_;
            _loc2_.y = Math.round(_loc1_.y);
            _loc5_ = _loc1_.pop > 0 ? (_loc10_ - _loc1_.pop) / POP_MS : 1;
            if(_loc5_ < 1)
            {
               _loc9_ = 1 + 0.35 * Math.sin(_loc5_ * Math.PI);
               TextField(_loc1_.qTf).scaleX = TextField(_loc1_.qTf).scaleY = _loc9_;
               TextField(_loc1_.qTf).x = _loc1_.qx - _loc1_.qw * (_loc9_ - 1) / 2;
               TextField(_loc1_.qTf).y = _loc1_.qy - _loc1_.qh * (_loc9_ - 1) / 2;
               POP_GLOW.alpha = 0.8 * (1 - _loc5_);
               TextField(_loc1_.qTf).filters = [TEXT_SHADOW,POP_GLOW];
            }
            else if(_loc1_.pop > 0)
            {
               TextField(_loc1_.qTf).scaleX = TextField(_loc1_.qTf).scaleY = 1;
               TextField(_loc1_.qTf).x = _loc1_.qx;
               TextField(_loc1_.qTf).y = _loc1_.qy;
               TextField(_loc1_.qTf).filters = [TEXT_SHADOW];
               _loc1_.pop = 0;
            }
            _loc11_.push(_loc1_);
         }
         this.rows = _loc11_;
         if(_loc12_)
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
