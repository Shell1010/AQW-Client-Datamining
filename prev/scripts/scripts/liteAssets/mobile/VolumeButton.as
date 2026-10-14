package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class VolumeButton extends Sprite
   {

      private static var art:BitmapData;

      private static const K:Number = 2;

      private static const SL:int = 7;

      private static const ST:int = 7;

      private static const SR:int = 7;

      private static const SB:int = 7;

      private static const SHADOW:DropShadowFilter = new DropShadowFilter(2,90,0,0.5,4,4,1,2);

      private static const SEL_GLOW:GlowFilter = new GlowFilter(16767083,0.9,10,10,2,2);

      private static const OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,10,1);

      private static const GLYPH_OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,8,2);

      private static var tried:Boolean = false;

      private static const GRAY:ColorMatrixFilter = new ColorMatrixFilter([0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0.3,0.59,0.11,0,0,0,0,0,1,0]);

      private var bw:int;

      private var bh:int;

      private var hover:Boolean = false;

      private var sel:Boolean = false;

      private var down:Boolean = false;

      private var dimmed:Boolean = false;

      private var face:Shape;

      private var tf:TextField;

      private var glyph:Shape;

      private var st:Stage;

      public function VolumeButton(param1:int, param2:int, param3:String = null, param4:int = 13)
      {
         super();
         this.bw = param1;
         this.bh = param2;
         buttonMode = true;
         useHandCursor = true;
         mouseChildren = false;
         this.face = new Shape();
         paintFace(this.face.graphics,param1,param2);
         addChild(this.face);
         if(param3 != null)
         {
            this.tf = MailArt.tf(param4,16777215,true);
            this.tf.filters = [OUTLINE];
            this.tf.text = param3;
            addChild(this.tf);
         }
         else
         {
            this.glyph = new Shape();
            this.glyph.filters = [GLYPH_OUTLINE];
            this.glyph.scaleX = this.glyph.scaleY = Math.max(1,Math.min(param1,param2) / 40);
            addChild(this.glyph);
         }
         addEventListener(MouseEvent.ROLL_OVER,this.onOver,false,0,true);
         addEventListener(MouseEvent.ROLL_OUT,this.onOut,false,0,true);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         this.redraw();
      }

      public static function captureNative(param1:SimpleButton) : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         var _loc3_:BitmapData = null;
         if(art != null || param1 == null)
         {
            return;
         }
         try
         {
            _loc1_ = param1.upState;
            if(_loc1_ == null)
            {
               return;
            }
            _loc2_ = _loc1_.getBounds(_loc1_);
            if(_loc2_.width < SL + SR + 4 || _loc2_.height < ST + SB + 4)
            {
               return;
            }
            _loc3_ = new BitmapData(Math.ceil(_loc2_.width * K),Math.ceil(_loc2_.height * K),true,0);
            _loc3_.drawWithQuality(_loc1_,new Matrix(K,0,0,K,-_loc2_.x * K,-_loc2_.y * K),null,null,null,true,StageQuality.HIGH);
            if(_loc3_.getColorBoundsRect(4278190080,0,false).isEmpty())
            {
               _loc3_.dispose();
            }
            else
            {
               art = _loc3_;
            }
         }
         catch(e:Error)
         {
         }
      }

      public static function ensureArt() : void
      {
         var _loc4_:Class = null;
         var _loc1_:MovieClip = null;
         if(art != null || Boolean(tried))
         {
            return;
         }
         tried = true;
         try
         {
            _loc4_ = getDefinitionByName("mcOption") as Class;
            _loc1_ = _loc4_ != null ? new _loc4_(Mobile.game) as MovieClip : null;
            if(_loc1_ == null)
            {
               return;
            }
            _loc1_["addFrameScript"](0,null);
            _loc1_.stop();
            captureNative(_loc1_.getChildByName("btnMusic") as SimpleButton);
         }
         catch(e:Error)
         {
         }
      }

      public static function paintFace(param1:Graphics, param2:int, param3:int) : void
      {
         ensureArt();
         if(art != null)
         {
            slice(param1,art,param2,param3);
         }
         else
         {
            paintRed(param1,param2,param3);
         }
      }

      private static function slice(param1:Graphics, param2:BitmapData, param3:int, param4:int) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Array = [0,SL * K,param2.width - SR * K,param2.width];
         var _loc11_:Array = [0,ST * K,param2.height - SB * K,param2.height];
         var _loc12_:Array = [0,SL,param3 - SR,param3];
         var _loc13_:Array = [0,ST,param4 - SB,param4];
         var _loc14_:Matrix = new Matrix();
         var _loc15_:int = 0;
         while(_loc15_ < 3)
         {
            _loc5_ = 0;
            while(_loc5_ < 3)
            {
               _loc6_ = _loc12_[_loc5_ + 1] - _loc12_[_loc5_];
               _loc7_ = _loc13_[_loc15_ + 1] - _loc13_[_loc15_];
               if(!(_loc6_ <= 0 || _loc7_ <= 0))
               {
                  _loc8_ = _loc6_ / (_loc10_[_loc5_ + 1] - _loc10_[_loc5_]);
                  _loc9_ = _loc7_ / (_loc11_[_loc15_ + 1] - _loc11_[_loc15_]);
                  _loc14_.setTo(_loc8_,0,0,_loc9_,_loc12_[_loc5_] - _loc10_[_loc5_] * _loc8_,_loc13_[_loc15_] - _loc11_[_loc15_] * _loc9_);
                  param1.beginBitmapFill(param2,_loc14_,false,true);
                  param1.drawRect(_loc12_[_loc5_],_loc13_[_loc15_],_loc6_,_loc7_);
                  param1.endFill();
               }
               _loc5_++;
            }
            _loc15_++;
         }
      }

      private static function paintRed(param1:Graphics, param2:int, param3:int) : void
      {
         var _loc3_:Matrix = new Matrix();
         param1.beginFill(0);
         param1.drawRoundRect(0,0,param2,param3,8,8);
         param1.endFill();
         _loc3_.createGradientBox(param2,param3,Math.PI / 2,0,0);
         param1.beginGradientFill(GradientType.LINEAR,[16048765,13408563,8610593],[1,1,1],[0,110,255],_loc3_);
         param1.drawRoundRect(1,1,param2 - 2,param3 - 2,6,6);
         param1.endFill();
         param1.beginFill(0);
         param1.drawRect(3,3,param2 - 6,param3 - 6);
         param1.endFill();
         _loc3_.createGradientBox(param2 - 8,param3 - 8,Math.PI / 2,4,4);
         param1.beginGradientFill(GradientType.LINEAR,[9306112,10354688,13107200,15747144],[1,1,1,1],[0,118,126,255],_loc3_);
         param1.drawRect(4,4,param2 - 8,param3 - 8);
         param1.endFill();
         var _loc10_:Number = Math.max(2,Math.round((param3 - 8) * 0.14));
         param1.beginFill(16764057,0.9);
         param1.drawRoundRect(7,5,param2 - 14,_loc10_,_loc10_,_loc10_);
         param1.endFill();
         param1.beginFill(16764057,0.7);
         param1.drawRect(5,param3 - 5 - _loc10_ * 0.6,param2 - 10,_loc10_ * 0.6);
         param1.endFill();
      }

      public function get selected() : Boolean
      {
         return this.sel;
      }

      public function set selected(param1:Boolean) : void
      {
         if(param1 == this.sel)
         {
            return;
         }
         this.sel = param1;
         this.redraw();
      }

      public function get dim() : Boolean
      {
         return this.dimmed;
      }

      public function set dim(param1:Boolean) : void
      {
         if(param1 == this.dimmed)
         {
            return;
         }
         this.dimmed = param1;
         this.redraw();
      }

      public function set label(param1:String) : void
      {
         if(this.tf == null || this.tf.text == param1)
         {
            return;
         }
         this.tf.text = param1;
         this.redraw();
      }

      public function speaker(param1:Number, param2:Boolean) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(this.glyph == null)
         {
            return;
         }
         if(this.sel != param2)
         {
            this.sel = param2;
            this.redraw();
         }
         var _loc2_:Graphics = this.glyph.graphics;
         _loc2_.clear();
         _loc2_.lineStyle();
         _loc2_.beginFill(16777215);
         _loc2_.moveTo(-10,-4);
         _loc2_.lineTo(-6,-4);
         _loc2_.lineTo(-1,-9);
         _loc2_.lineTo(-1,9);
         _loc2_.lineTo(-6,4);
         _loc2_.lineTo(-10,4);
         _loc2_.lineTo(-10,-4);
         _loc2_.endFill();
         if(param2)
         {
            _loc2_.lineStyle(2.5,16777215,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND);
            _loc2_.moveTo(3,-4);
            _loc2_.lineTo(11,4);
            _loc2_.moveTo(3,4);
            _loc2_.lineTo(11,-4);
            return;
         }
         var _loc3_:int = param1 <= 0 ? 0 : (param1 < 34 ? 1 : (param1 < 67 ? 2 : 3));
         _loc2_.lineStyle(2,16777215,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND);
         var _loc10_:int = 0;
         while(_loc10_ < _loc3_)
         {
            _loc11_ = 5 + _loc10_ * 4;
            _loc12_ = _loc11_ * 0.7071;
            _loc2_.moveTo(-1 + _loc12_,-_loc12_);
            _loc2_.curveTo(-1 + _loc11_ * 1.2929,0,-1 + _loc12_,_loc12_);
            _loc10_++;
         }
      }

      private function onOver(param1:MouseEvent) : void
      {
         if(this.hover)
         {
            return;
         }
         this.hover = true;
         this.redraw();
      }

      private function onOut(param1:MouseEvent) : void
      {
         if(!this.hover)
         {
            return;
         }
         this.hover = false;
         this.redraw();
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         this.endPress();
         this.down = true;
         this.st = stage;
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.redraw();
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.endPress();
         this.redraw();
      }

      private function endPress() : void
      {
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.st = null;
         }
         this.down = false;
      }

      private function redraw() : void
      {
         var _loc4_:int = this.down ? 1 : 0;
         var _loc1_:Number = (this.sel ? 0.72 : 1) * (this.down ? 0.82 : 1) * (this.dimmed ? 0.5 : 1);
         var _loc2_:Number = Boolean(this.hover) && !this.down && !this.sel && !Mobile.active ? 20 : 0;
         this.face.transform.colorTransform = new ColorTransform(_loc1_,_loc1_,_loc1_,1,_loc2_,_loc2_,_loc2_,0);
         this.face.y = _loc4_;
         this.face.filters = Boolean(this.sel) && this.tf != null ? [SEL_GLOW,SHADOW] : (this.dimmed ? [GRAY,SHADOW] : [SHADOW]);
         if(this.tf != null)
         {
            this.tf.textColor = this.dimmed ? 11579568 : 16777215;
            this.tf.x = Math.round((this.bw - this.tf.width) / 2);
            this.tf.y = Math.round((this.bh - this.tf.height) / 2) + _loc4_;
         }
         if(this.glyph != null)
         {
            this.glyph.x = Math.round(this.bw / 2 - 2 * this.glyph.scaleX);
            this.glyph.y = Math.round(this.bh / 2) + _loc4_;
         }
      }
   }
}
