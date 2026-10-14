package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;

   public class QtyStepper
   {

      private static var faces:Array;

      private static const IN:Number = 7;

      private static const HOLD:int = 400;

      private static const FIRST:int = 150;

      private static const FLOOR:int = 35;

      private static const ACCEL:Number = 0.85;

      private static const DESK_W:int = 22;

      private static const DESK_MAX:int = 30;

      private static const DESK_GAP:int = 2;

      private static const REACH_L:Number = 5;

      private static const REACH_R:Number = 11;

      private static const HIT_L:Number = 26;

      private static const HIT_R:Number = 15;

      private static const MOB_MAX:int = 30;

      private static const GAP:int = 3;

      private var host:DisplayObjectContainer;

      private var onStep:Function;

      private var onMax:Function;

      private var minusB:QtyStepButton;

      private var plusB:QtyStepButton;

      private var maxB:QtyStepButton;

      private var repeat:Timer;

      private var dir:int = 0;

      private var held:QtyStepButton;

      private var st:Stage;

      private var lim:Rectangle;

      private var _midX:Number = 0;

      private var _visible:Boolean = true;

      public function QtyStepper(param1:DisplayObjectContainer, param2:Function, param3:Function)
      {
         super();
         this.host = param1;
         this.onStep = param2;
         this.onMax = param3;
         capture(param1.parent);
         var _loc1_:DisplayObject = param1.getChildByName("t1");
         var _loc2_:DisplayObject = param1.getChildByName("bar");
         var _loc3_:DisplayObject = param1.getChildByName("handle");
         var _loc4_:DisplayObject = boxOf(param1,_loc1_);
         var _loc5_:Rectangle = _loc4_ != null ? _loc4_.getBounds(param1) : _loc1_.getBounds(param1);
         if(Mobile.active)
         {
            this.bracket(_loc5_,_loc4_,_loc1_,param1.getChildByName("t2"),_loc2_,_loc3_);
         }
         else
         {
            this.row(_loc5_);
         }
         var _loc6_:Number = Math.min(this.minusB.x,_loc2_.x);
         var _loc7_:Number = Math.max(this.plusB.x + this.plusB.w,this.maxB.x + this.maxB.w,_loc2_.x + _loc2_.width);
         this._midX = (_loc6_ + _loc7_) / 2;
         this.minusB.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         this.plusB.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         this.maxB.addEventListener(MouseEvent.CLICK,this.onMaxClick,false,0,true);
         this.minusB.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
         this.repeat = new Timer(HOLD,0);
         this.repeat.addEventListener(TimerEvent.TIMER,this.onTick,false,0,true);
      }

      private static function boxOf(param1:DisplayObjectContainer, param2:DisplayObject) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         var _loc8_:Number = param2.x + param2.width / 2;
         var _loc1_:Number = param2.y + param2.height / 2;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is Shape && _loc3_.getBounds(param1).contains(_loc8_,_loc1_))
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }

      private static function capture(param1:DisplayObjectContainer) : void
      {
         var _loc8_:DisplayObjectContainer = null;
         var _loc1_:SimpleButton = null;
         var _loc2_:Rectangle = null;
         var _loc3_:BitmapData = null;
         if(faces != null || param1 == null)
         {
            return;
         }
         var _loc9_:int = 0;
         for(; _loc9_ < param1.numChildren; _loc9_++)
         {
            _loc8_ = param1.getChildAt(_loc9_) as DisplayObjectContainer;
            if(!(_loc8_ == null || !(_loc8_.getChildByName("btn1") is SimpleButton)))
            {
               _loc1_ = _loc8_.getChildByName("btn2") as SimpleButton;
               if(!(_loc1_ == null || _loc1_.upState == null))
               {
                  try
                  {
                     _loc2_ = _loc1_.upState.getBounds(_loc1_.upState);
                     if(!(_loc2_.width < IN * 2 + 4 || _loc2_.height < IN * 2 + 4))
                     {
                        _loc3_ = snap(_loc1_.upState,_loc2_);
                        if(_loc3_ != null)
                        {
                           faces = [_loc3_,clip(snap(_loc1_.overState,_loc2_),_loc3_),clip(snap(_loc1_.downState,_loc2_),_loc3_)];
                           return;
                        }
                     }
                  }
                  catch(e:Error)
                  {
                  }
                  continue;
               }
            }
         }
      }

      private static function clip(param1:BitmapData, param2:BitmapData) : BitmapData
      {
         if(param1 == null || param1.width != param2.width || param1.height != param2.height)
         {
            return param2;
         }
         param1.copyChannel(param2,param2.rect,new Point(),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
         return param1;
      }

      private static function snap(param1:DisplayObject, param2:Rectangle) : BitmapData
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc8_:Number = Number(NativeArt.K);
         var _loc1_:BitmapData = new BitmapData(Math.ceil(param2.width * _loc8_),Math.ceil(param2.height * _loc8_),true,0);
         _loc1_.drawWithQuality(param1,new Matrix(_loc8_,0,0,_loc8_,-param2.x * _loc8_,-param2.y * _loc8_),null,null,null,true,StageQuality.HIGH);
         if(_loc1_.getColorBoundsRect(4278190080,0,false).isEmpty())
         {
            _loc1_.dispose();
            return null;
         }
         return _loc1_;
      }

      public function get midX() : Number
      {
         return this._midX;
      }

      public function get visible() : Boolean
      {
         return this._visible;
      }

      public function set visible(param1:Boolean) : void
      {
         this._visible = param1;
         if(!param1)
         {
            this.stop();
         }
         this.minusB.visible = param1;
         this.plusB.visible = param1;
         this.maxB.visible = param1;
      }

      public function refresh(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         this.minusB.enabled = param1;
         this.plusB.enabled = param2;
         this.maxB.enabled = param3;
         if(this.held != null && !this.held.enabled)
         {
            this.stop();
         }
      }

      public function trim(param1:Rectangle) : Rectangle
      {
         return this.lim != null && param1 != null ? param1.intersection(this.lim) : param1;
      }

      public function destroy() : void
      {
         var _loc8_:QtyStepButton = null;
         this.stop();
         this.repeat.removeEventListener(TimerEvent.TIMER,this.onTick);
         this.minusB.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         this.plusB.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         this.maxB.removeEventListener(MouseEvent.CLICK,this.onMaxClick);
         this.minusB.removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         var _loc10_:Array = [this.minusB,this.plusB,this.maxB];
         var _loc9_:int = 0;
         while(_loc9_ < _loc10_.length)
         {
            _loc8_ = _loc10_[_loc9_];
            _loc8_.destroy();
            if(_loc8_.parent != null)
            {
               _loc8_.parent.removeChild(_loc8_);
            }
            _loc9_++;
         }
         this.onStep = null;
         this.onMax = null;
      }

      private function row(param1:Rectangle) : void
      {
         var _loc9_:int = Math.round(param1.height);
         var _loc8_:Number = Number(this.py(param1.y));
         this.minusB = this.add(QtyStepButton.MINUS,DESK_W,_loc9_,this.px(param1.x - DESK_GAP - DESK_W),_loc8_);
         this.plusB = this.add(QtyStepButton.PLUS,DESK_W,_loc9_,this.px(param1.right + DESK_GAP),_loc8_);
         this.maxB = this.add(QtyStepButton.MAX,DESK_MAX,_loc9_,this.plusB.x + DESK_W + DESK_GAP + 1,_loc8_);
      }

      private function bracket(param1:Rectangle, param2:DisplayObject, param3:DisplayObject, param4:DisplayObject, param5:DisplayObject, param6:DisplayObject) : void
      {
         var _loc11_:Matrix = null;
         var _loc4_:Rectangle = param6.getBounds(this.host);
         var _loc5_:Number = Number(this.py(param1.y - 1));
         var _loc6_:int = Math.round(this.py(_loc4_.bottom + 1) - _loc5_);
         var _loc7_:Number = Number(this.px(param5.x - REACH_L));
         var _loc12_:Number = Number(this.px(param5.x + param5.width + REACH_R));
         var _loc13_:Number = param5.x - HIT_L;
         var _loc14_:Number = param5.x + param5.width + HIT_R;
         var _loc15_:int = Math.floor((_loc12_ - _loc7_ - param1.width - MOB_MAX - GAP * 3) / 2);
         this.minusB = this.add(QtyStepButton.MINUS,_loc15_,_loc6_,_loc7_,_loc5_);
         this.plusB = this.add(QtyStepButton.PLUS,_loc15_,_loc6_,_loc12_ - _loc15_,_loc5_);
         var _loc16_:Number = Math.round(this.minusB.x + _loc15_ + GAP - param1.x);
         if(param2 != null)
         {
            _loc11_ = param2.transform.matrix;
            _loc11_.tx += _loc16_;
            param2.transform.matrix = _loc11_;
         }
         param3.x += _loc16_;
         if(param4 != null)
         {
            param4.x += _loc16_;
         }
         param1.x += _loc16_;
         var _loc17_:Number = this.plusB.x - GAP;
         var _loc18_:Number = Number(this.px(param1.right + GAP));
         var _loc19_:int = Math.round(param1.height) + 2;
         this.maxB = this.add(QtyStepButton.MAX,Math.round(_loc17_ - _loc18_),_loc19_,_loc18_,this.py(param1.y - 1));
         param5.x = param1.x;
         param5.width = _loc17_ - param1.x;
         var _loc20_:Number = (this.maxB.y + _loc19_ + _loc4_.y) / 2;
         var _loc21_:Number = GAP / 2;
         var _loc22_:Number = this.minusB.x + _loc15_ + _loc21_;
         var _loc23_:Number = this.plusB.x - _loc21_;
         this.pad(this.minusB,new Rectangle(_loc13_,_loc5_ - 4,_loc22_ - _loc13_,_loc6_ + 6));
         this.pad(this.plusB,new Rectangle(_loc23_,_loc5_ - 4,_loc14_ - _loc23_,_loc6_ + 6));
         this.pad(this.maxB,new Rectangle(this.maxB.x - _loc21_,_loc5_ - 4,this.maxB.w + GAP,_loc20_ - _loc5_ + 4));
         this.lim = new Rectangle(_loc22_,_loc20_,_loc23_ - _loc22_,_loc4_.bottom + 2 - _loc20_);
      }

      private function add(param1:int, param2:int, param3:int, param4:Number, param5:Number) : QtyStepButton
      {
         var _loc3_:QtyStepButton = new QtyStepButton(param1,param2,param3,faces);
         _loc3_.x = param4;
         _loc3_.y = param5;
         this.host.addChild(_loc3_);
         return _loc3_;
      }

      private function pad(param1:QtyStepButton, param2:Rectangle) : void
      {
         TouchTargets.pad(param1,0,0,param2);
      }

      private function px(param1:Number) : Number
      {
         return Math.round(this.host.x + param1) - this.host.x;
      }

      private function py(param1:Number) : Number
      {
         return Math.round(this.host.y + param1) - this.host.y;
      }

      private function onDown(param1:MouseEvent) : void
      {
         var _loc9_:QtyStepButton = param1.currentTarget as QtyStepButton;
         if(_loc9_ == null || !_loc9_.enabled || this.onStep == null)
         {
            return;
         }
         this.stop();
         this.dir = _loc9_ == this.minusB ? -1 : 1;
         this.onStep(this.dir);
         if(!_loc9_.enabled || _loc9_.stage == null)
         {
            return;
         }
         this.held = _loc9_;
         this.st = _loc9_.stage;
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         _loc9_.addEventListener(MouseEvent.ROLL_OUT,this.onUp,false,0,true);
         this.repeat.reset();
         this.repeat.delay = HOLD;
         this.repeat.start();
      }

      private function onTick(param1:TimerEvent) : void
      {
         if(this.held == null || !this.held.enabled || this.held.stage == null || !this._visible || this.onStep == null)
         {
            this.stop();
            return;
         }
         this.onStep(this.dir);
         this.repeat.delay = this.repeat.delay >= HOLD ? Number(FIRST) : Math.max(FLOOR,Math.round(this.repeat.delay * ACCEL));
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.stop();
      }

      private function onRemoved(param1:Event) : void
      {
         this.stop();
      }

      private function onMaxClick(param1:MouseEvent) : void
      {
         if(Boolean(this.maxB.enabled) && this.onMax != null)
         {
            this.onMax();
         }
      }

      public function stop() : void
      {
         this.repeat.stop();
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.st = null;
         }
         if(this.held != null)
         {
            this.held.removeEventListener(MouseEvent.ROLL_OUT,this.onUp);
            this.held = null;
         }
      }
   }
}

import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.geom.*;
import flash.text.TextField;
import liteAssets.draw.*;

class QtyStepButton extends Sprite
{

   public static const MINUS:int = 0;

   public static const PLUS:int = 1;

   public static const MAX:int = 2;

   private static const IN:Number = 7;

   private static const IDENT:ColorTransform = new ColorTransform();

   private static const LIT:ColorTransform = new ColorTransform(1,1,1,1,30,30,30);

   private static const DARK:ColorTransform = new ColorTransform(0.55,0.55,0.55);

   public var w:int;

   public var h:int;

   private var art:Array;

   private var face:Shape;

   private var mark:Shape;

   private var tf:TextField;

   private var _enabled:Boolean = true;

   private var hover:Boolean = false;

   private var down:Boolean = false;

   private var shown:int = -1;

   private var st:Stage;

   public function QtyStepButton(param1:int, param2:int, param3:int, param4:Array)
   {
      super();
      this.w = param2;
      this.h = param3;
      this.art = param4;
      mouseChildren = false;
      buttonMode = true;
      useHandCursor = true;
      this.face = new Shape();
      addChild(this.face);
      var _loc2_:GlowFilter = new GlowFilter(0,0.75,2,2,3,1);
      if(param1 == MAX)
      {
         this.tf = MailArt.tf(param3 >= 20 && param2 >= 32 ? 12 : 11,16777215,true);
         this.tf.text = "Max";
         this.tf.filters = [_loc2_];
         this.tf.x = Math.round((param2 - this.tf.width) / 2);
         this.tf.y = Math.round((param3 - this.tf.height) / 2);
         addChild(this.tf);
      }
      else
      {
         this.mark = new Shape();
         this.glyph(this.mark.graphics,param1 == PLUS);
         this.mark.filters = [_loc2_];
         addChild(this.mark);
      }
      addEventListener(MouseEvent.ROLL_OVER,this.onOver,false,0,true);
      addEventListener(MouseEvent.ROLL_OUT,this.onOut,false,0,true);
      addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
      this.redraw();
   }

   public function get enabled() : Boolean
   {
      return this._enabled;
   }

   public function set enabled(param1:Boolean) : void
   {
      if(param1 == this._enabled)
      {
         return;
      }
      this._enabled = param1;
      this.redraw();
   }

   public function destroy() : void
   {
      this.endPress();
      removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
      removeEventListener(MouseEvent.ROLL_OUT,this.onOut);
      removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
   }

   private function glyph(param1:Graphics, param2:Boolean) : void
   {
      var _loc8_:int = this.h >= 28 ? 3 : 2;
      if((this.h - _loc8_ & 1) != 0)
      {
         _loc8_++;
      }
      var _loc1_:int = Math.round(Math.min(this.w,this.h) * 0.45);
      if((this.w - _loc1_ & 1) != 0)
      {
         _loc1_++;
      }
      param1.beginFill(16777215);
      param1.drawRect((this.w - _loc1_) / 2,(this.h - _loc8_) / 2,_loc1_,_loc8_);
      if(param2)
      {
         param1.drawRect((this.w - _loc8_) / 2,(this.h - _loc1_) / 2,_loc8_,(_loc1_ - _loc8_) / 2);
         param1.drawRect((this.w - _loc8_) / 2,(this.h + _loc8_) / 2,_loc8_,(_loc1_ - _loc8_) / 2);
      }
      param1.endFill();
   }

   private function onOver(param1:MouseEvent) : void
   {
      this.hover = true;
      this.redraw();
   }

   private function onOut(param1:MouseEvent) : void
   {
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
      this.hover = true;
      this.down = true;
      this.st = stage;
      this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
      this.redraw();
   }

   private function onUp(param1:MouseEvent) : void
   {
      this.endPress();
      if(Mobile.active)
      {
         this.hover = false;
      }
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
      var _loc10_:int = 0;
      if(Boolean(this._enabled) && Boolean(this.hover))
      {
         _loc10_ = this.down ? 2 : (Mobile.active ? 0 : 1);
      }
      this.paint(_loc10_);
      alpha = this._enabled ? 1 : 0.4;
      buttonMode = this._enabled;
      useHandCursor = this._enabled;
   }

   private function paint(param1:int) : void
   {
      if(param1 == this.shown)
      {
         return;
      }
      this.shown = param1;
      var _loc9_:Graphics = this.face.graphics;
      _loc9_.clear();
      if(this.art != null)
      {
         NativeArt.slice(_loc9_,this.art[param1],this.w,this.h,IN,IN,IN,IN,Math.min(1,(this.w - 2) / (IN * 2),(this.h - 2) / (IN * 2)));
         return;
      }
      var _loc8_:Matrix = new Matrix();
      _loc8_.createGradientBox(this.w,this.h,Math.PI / 2,0,0);
      _loc9_.beginGradientFill(GradientType.LINEAR,[16048765,11958807,8803607],[1,1,1],[0,128,255],_loc8_);
      _loc9_.drawRoundRect(0,0,this.w,this.h,8,8);
      _loc9_.endFill();
      _loc8_.createGradientBox(this.w - 4,this.h - 4,Math.PI / 2,2,2);
      _loc9_.beginGradientFill(GradientType.LINEAR,[6684672,6684672,10027008,10027008],[1,1,1,1],[0,127,128,255],_loc8_);
      _loc9_.drawRoundRect(2,2,this.w - 4,this.h - 4,6,6);
      _loc9_.endFill();
      _loc9_.beginFill(16743001,0.55);
      _loc9_.drawRoundRect(4,3,this.w - 8,Math.max(2,Math.round(this.h * 0.1)),3,3);
      _loc9_.endFill();
      this.face.transform.colorTransform = param1 == 1 ? LIT : (param1 == 2 ? DARK : IDENT);
   }
}
