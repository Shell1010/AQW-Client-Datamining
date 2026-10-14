package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class SkillCluster extends Sprite
   {

      private static const EXT_R:int = 63;

      private static const EXT_B:int = 19;

      private static const AA_S:int = 80;

      private static const SK_S:int = 58;

      private static const GAP:int = 6;

      private static const PX:Array = [0,-0.61,-1.08,-0.72,-0.06,0.69];

      private static const PY:Array = [0,0.75,0.08,-0.63,-1.05,-0.76];

      private static const SK_K:Number = 0.667;

      private static const DPX:Number = -1.32;

      private static const DPY:Number = 0.74;

      private static const DASH_K:Number = 0.82;

      private static const DASH_OFF:Number = 0.4;

      private static const FIG:Array = [[112,0,132,18,133,24,126,25,117,25,112,31,108,33,106,32,103,41,100,44,95,48,91,48,89,50,93,52,100,54,101,58,101,62,97,67,95,67,88,72,81,73,80,75,77,74,72,77,72,80,68,87,69,89,66,92,64,95,59,96,57,91,57,85,58,84,60,76,58,74,59,72,62,70,68,64,68,61,70,61,66,60,62,57,59,61,50,63,46,65,43,70,41,70,34,76,27,76,26,78,23,78,14,82,11,90,12,92,10,95,8,99,3,100,1,97,0,92,0,90,1,89,1,80,0,79,0,76,6,74,7,75,14,67,14,64,17,63,22,56,31,54,33,52,42,53,48,46,52,45,57,40,61,40,64,38,68,36,69,36,70,33,72,32,73,28,75,23,65,26,64,27,63,27,62,29,56,31,53,31,46,35,46,40,43,45,37,45,34,47,31,46,30,44,32,40,30,38,30,36,31,33,31,28,46,16,51,11,62,8,62,14,63,14,64,13,68,13,78,9,83,2,87,4,90,8]];

      private static const REF_X:Number = -1;

      private static const REF_Y:Number = -1;

      private static const REF_W:Number = 49.25;

      private static const REF_H:Number = 44.95;

      private static const CANCEL_SQ:int = 144;

      private static const REFRESH_TICKS:int = 50;

      private static const IDLE_ALPHA:Number = 0.92;

      public static const HOLD_HINT:String = "holdHint";

      private static const SWEEP_ALPHA:Number = 0.55;

      private static const CD_COLOR:uint = 16744458;

      private static const PRESS_GLOW:Array = [new GlowFilter(16767083,0.8,10,10,2,2)];

      private static const NUM_GLOW:Array = [new GlowFilter(0,1,3,3,4,2)];

      private static const CD_GLOW:Array = [new GlowFilter(0,1,4,4,3,2)];

      private static const GLYPH_GLOW:Array = [new GlowFilter(0,1,3,3,8,2)];

      private static const IDENT:ColorTransform = new ColorTransform();

      private static const DARK:ColorTransform = new ColorTransform(0.8,0.8,0.8);

      private var btns:Array = [];

      private var faces:Array = [];

      private var hits:Array = [];

      private var bmds:Array = [];

      private var pies:Array = [];

      private var cdTxts:Array = [];

      private var radii:Array = [];

      private var lastIcon:Array = [];

      private var lastAlpha:Array = [];

      private var lastTick:Array = [];

      private var lastDeg:Array = [];

      private var lastSec:Array = [];

      private var frame:Shape;

      private var ring:Sprite;

      private var handle:Sprite;

      private var hHit:Sprite;

      private var hFace:Shape;

      private var hFill:Shape;

      private var hold:HoldPress;

      private var hChev:Shape;

      private var dashBtn:Sprite;

      private var dashFace:Shape;

      private var dashGlyph:Shape;

      private var dashS:int;

      private var dashOk:Boolean = true;

      private var dashT:int = 0;

      private var hRect:Rectangle;

      private var hW:int;

      private var hH:int;

      private var hst:Stage;

      private var hPress:Boolean = false;

      private var hx:Number = 0;

      private var hy:Number = 0;

      private var _collapsed:Boolean = false;

      private var timer:Timer;

      private var st:Stage;

      private var pressed:int = -1;

      private var cancelled:Boolean = false;

      private var sx:Number = 0;

      private var sy:Number = 0;

      private var tick:int = 0;

      private var _shown:Boolean = false;

      private var _editing:Boolean = false;

      private var _extL:int;

      private var _extT:int;

      private var _extR:int = 63;

      private var _extB:int = 19;

      private var aaS:int;

      private var skS:int;

      private var gap:int;

      public function SkillCluster()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         var _loc9_:Sprite = null;
         var _loc10_:BitmapData = null;
         var _loc11_:Bitmap = null;
         var _loc12_:Shape = null;
         var _loc13_:Shape = null;
         var _loc14_:TextField = null;
         super();
         mouseEnabled = false;
         this.skS = Math.max(SK_S,Mobile.touchPx(9));
         this.aaS = Math.max(AA_S,Mobile.touchPx(11));
         this.gap = Math.round(GAP * Math.max(this.skS / SK_S,this.aaS / AA_S));
         var _loc15_:int = int(this.aaS);
         var _loc16_:int = int(this.skS);
         this.frame = new Shape();
         this.frame.visible = false;
         addChild(this.frame);
         this.ring = new Sprite();
         this.ring.mouseEnabled = false;
         addChild(this.ring);
         var _loc17_:int = 0;
         while(_loc17_ < 6)
         {
            _loc1_ = _loc17_ == 0 ? _loc15_ : _loc16_;
            _loc2_ = Math.round(_loc1_ * REF_H / REF_W);
            _loc3_ = -(_loc1_ >> 1);
            _loc4_ = -(_loc2_ >> 1);
            _loc5_ = _loc1_ * 0.77;
            _loc6_ = _loc2_ * 0.68;
            _loc7_ = new Sprite();
            _loc8_ = new Sprite();
            _loc8_.graphics.beginFill(0,0);
            _loc8_.graphics.drawRoundRect(_loc3_,_loc4_,_loc1_,_loc2_,_loc5_,_loc6_);
            _loc8_.graphics.endFill();
            _loc8_.mouseEnabled = false;
            _loc7_.addChild(_loc8_);
            _loc7_.hitArea = _loc8_;
            _loc9_ = new Sprite();
            _loc10_ = new BitmapData(_loc1_,_loc2_,true,0);
            _loc11_ = new Bitmap(_loc10_,"auto",true);
            _loc11_.x = _loc3_;
            _loc11_.y = _loc4_;
            _loc9_.addChild(_loc11_);
            _loc12_ = new Shape();
            _loc13_ = new Shape();
            _loc13_.graphics.beginFill(0);
            _loc13_.graphics.drawRoundRect(_loc3_,_loc4_,_loc1_,_loc2_,_loc5_,_loc6_);
            _loc13_.graphics.endFill();
            _loc9_.addChild(_loc12_);
            _loc9_.addChild(_loc13_);
            _loc12_.mask = _loc13_;
            _loc14_ = MailArt.tf(18,CD_COLOR,true);
            _loc14_.filters = CD_GLOW;
            _loc14_.visible = false;
            _loc9_.addChild(_loc14_);
            _loc9_.addChild(this.badge(String(_loc17_ + 1),_loc3_,_loc4_ + _loc2_));
            _loc7_.addChild(_loc9_);
            _loc7_.mouseChildren = false;
            _loc7_.alpha = IDLE_ALPHA;
            _loc7_.visible = false;
            _loc7_.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
            this.ring.addChild(_loc7_);
            this.btns.push(_loc7_);
            this.faces.push(_loc9_);
            this.hits.push(_loc8_);
            this.bmds.push(_loc10_);
            this.pies.push(_loc12_);
            this.cdTxts.push(_loc14_);
            this.radii.push(Math.ceil(Math.sqrt(_loc1_ * _loc1_ + _loc2_ * _loc2_) / 2) + 2);
            this.lastIcon.push(null);
            this.lastAlpha.push(-1);
            this.lastTick.push(-REFRESH_TICKS);
            this.lastDeg.push(-1);
            this.lastSec.push(0);
            _loc17_++;
         }
         this.dashS = Math.round(this.skS * DASH_K);
         this.dashBtn = new Sprite();
         this.dashBtn.mouseChildren = false;
         this.dashFace = new Shape();
         this.dashFace.x = this.dashFace.y = -(this.dashS >> 1);
         this.dashBtn.addChild(this.dashFace);
         this.dashGlyph = new Shape();
         this.dashGlyph.filters = GLYPH_GLOW;
         this.dashBtn.addChild(this.dashGlyph);
         var _loc18_:Sprite = new Sprite();
         _loc18_.graphics.beginFill(0,0);
         _loc18_.graphics.drawCircle(0,0,(this.dashS >> 1) + this.gap);
         _loc18_.graphics.endFill();
         _loc18_.mouseEnabled = false;
         this.dashBtn.addChild(_loc18_);
         this.dashBtn.hitArea = _loc18_;
         this.drawDash(false);
         this.dashBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDashDown,false,0,true);
         if(Multitouch.supportsTouchEvents)
         {
            Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
            this.dashBtn.addEventListener(TouchEvent.TOUCH_BEGIN,this.onDashTouch,false,0,true);
         }
         this.ring.addChild(this.dashBtn);
         this.handle = new Sprite();
         this.handle.mouseChildren = false;
         this.hHit = new Sprite();
         this.hHit.mouseEnabled = false;
         this.handle.addChild(this.hHit);
         this.handle.hitArea = this.hHit;
         this.hFace = new Shape();
         this.handle.addChild(this.hFace);
         this.hFill = new Shape();
         this.handle.addChild(this.hFill);
         this.hold = new HoldPress(this.hFill);
         this.hChev = new Shape();
         this.hChev.filters = GLYPH_GLOW;
         this.handle.addChild(this.hChev);
         this.handle.addEventListener(MouseEvent.MOUSE_DOWN,this.onHandleDown,false,0,true);
         addChild(this.handle);
         this.layout();
         visible = false;
      }

      private function layout() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = Math.max(this.aaS,this.skS / SK_K);
         var _loc4_:int = Math.round(this.aaS * REF_H / REF_W);
         var _loc5_:int = Math.round(this.skS * REF_H / REF_W);
         var _loc6_:int = this.aaS - (this.aaS >> 1);
         var _loc7_:Number = -(this.aaS >> 1);
         var _loc8_:Number = -(_loc4_ >> 1);
         var _loc9_:Number = _loc6_;
         var _loc10_:Number = _loc4_ - (_loc4_ >> 1);
         var _loc11_:Array = [0];
         var _loc12_:Array = [0];
         var _loc13_:int = 1;
         while(_loc13_ < 6)
         {
            _loc1_ = Math.round(PX[_loc13_] * _loc3_);
            _loc2_ = Math.round(PY[_loc13_] * _loc3_);
            _loc11_.push(_loc1_);
            _loc12_.push(_loc2_);
            _loc7_ = Math.min(_loc7_,_loc1_ - (this.skS >> 1));
            _loc8_ = Math.min(_loc8_,_loc2_ - (_loc5_ >> 1));
            _loc9_ = Math.max(_loc9_,_loc1_ - (this.skS >> 1) + this.skS);
            _loc10_ = Math.max(_loc10_,_loc2_ - (_loc5_ >> 1) + _loc5_);
            _loc13_++;
         }
         var _loc14_:int = Math.round(DPX * _loc3_);
         var _loc15_:int = Math.round(DPY * _loc3_);
         _loc7_ = Math.min(_loc7_,_loc14_ - (this.dashS >> 1));
         _loc8_ = Math.min(_loc8_,_loc15_ - (this.dashS >> 1));
         _loc10_ = Math.max(_loc10_,_loc15_ - (this.dashS >> 1) + this.dashS);
         this.hW = Math.round(_loc3_ * 0.3);
         this.hH = Math.round(_loc3_ * 0.62);
         _loc9_ = Math.max(_loc9_,_loc6_ + this.gap + this.hW);
         var _loc16_:int = EXT_R - _loc9_;
         var _loc17_:int = EXT_B - _loc10_;
         this._extL = -(_loc16_ + _loc7_);
         this._extT = -(_loc17_ + _loc8_);
         this._extR = EXT_R;
         this._extB = EXT_B;
         _loc13_ = 0;
         while(_loc13_ < 6)
         {
            this.btns[_loc13_].x = _loc16_ + _loc11_[_loc13_];
            this.btns[_loc13_].y = _loc17_ + _loc12_[_loc13_];
            _loc13_++;
         }
         this.dashBtn.x = _loc16_ + _loc14_;
         this.dashBtn.y = _loc17_ + _loc15_;
         this.hFace.x = this.hFill.x = this.hChev.x = _loc16_ + _loc9_ - this.hW;
         this.hFace.y = this.hFill.y = this.hChev.y = _loc17_ - (this.hH >> 1);
         this.hRect = new Rectangle(_loc16_ + _loc6_ + 2,_loc17_ - (this.hH >> 1) - this.gap,_loc9_ - _loc6_ - 2,this.hH + this.gap * 2);
         var _loc18_:Graphics = this.hHit.graphics;
         _loc18_.clear();
         _loc18_.beginFill(0,0);
         _loc18_.drawRect(this.hRect.x,this.hRect.y,this.hRect.width,this.hRect.height);
         _loc18_.endFill();
         this.drawHandle(false);
         var _loc19_:Graphics = this.frame.graphics;
         _loc19_.clear();
         _loc19_.lineStyle(2,MailArt.TRIM,1);
         this.dashRect(_loc19_,-this._extL,-this._extT,this._extL + this._extR,this._extT + this._extB);
      }

      public function get extL() : int
      {
         return this._extL;
      }

      public function get extT() : int
      {
         return this._extT;
      }

      public function get extR() : int
      {
         return this._extR;
      }

      public function get extB() : int
      {
         return this._extB;
      }

      public function get handleRect() : Rectangle
      {
         return this.hRect;
      }

      public function set collapsed(param1:Boolean) : void
      {
         if(param1 == this._collapsed)
         {
            return;
         }
         this._collapsed = param1;
         this.ring.visible = !param1;
         if(param1)
         {
            this.endPress();
         }
         this.drawHandle(false);
         if(!param1 && Boolean(this._shown))
         {
            this.onTick(null);
         }
      }

      public function get shown() : Boolean
      {
         return this._shown;
      }

      public function set shown(param1:Boolean) : void
      {
         var _loc1_:int = 0;
         if(param1 == this._shown)
         {
            return;
         }
         this._shown = param1;
         visible = param1;
         if(param1)
         {
            this.timer = new Timer(100);
            this.timer.addEventListener(TimerEvent.TIMER,this.onTick,false,0,true);
            this.timer.start();
            this.tick = 0;
            _loc1_ = 0;
            while(_loc1_ < 6)
            {
               this.lastTick[_loc1_] = -REFRESH_TICKS;
               _loc1_++;
            }
            this.onTick(null);
         }
         else
         {
            this.endPress();
            this.endHandle();
            if(this.timer != null)
            {
               this.timer.stop();
               this.timer.removeEventListener(TimerEvent.TIMER,this.onTick);
               this.timer = null;
            }
         }
      }

      public function set editing(param1:Boolean) : void
      {
         this._editing = param1;
         this.frame.visible = param1;
         if(param1)
         {
            this.endPress();
            this.endHandle();
         }
      }

      public function destroy() : void
      {
         this.shown = false;
         this.endPress();
         this.endHandle();
         this.handle.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHandleDown);
         this.dashBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDashDown);
         this.dashBtn.removeEventListener(TouchEvent.TOUCH_BEGIN,this.onDashTouch);
         var _loc1_:int = 0;
         while(_loc1_ < this.btns.length)
         {
            this.btns[_loc1_].removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            this.clearSweep(_loc1_);
            this.bmds[_loc1_].dispose();
            _loc1_++;
         }
         this.btns = [];
         this.bmds = [];
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function slot(param1:int) : MovieClip
      {
         try
         {
            return Mobile.game.ui.mcInterface.actBar.getChildByName("i" + (param1 + 1)) as MovieClip;
         }
         catch(e:Error)
         {
         }
         return null;
      }

      private function badge(param1:String, param2:int, param3:int) : Sprite
      {
         var _loc1_:Sprite = new Sprite();
         var _loc2_:TextField = MailArt.tf(11,16777215,true);
         _loc2_.text = param1;
         _loc2_.filters = NUM_GLOW;
         var _loc3_:int = 14;
         var _loc4_:int = Math.max(16,Math.ceil(_loc2_.textWidth) + 8);
         var _loc5_:Graphics = _loc1_.graphics;
         _loc5_.lineStyle(1,MailArt.TRIM,1,true);
         _loc5_.beginFill(1118481,0.9);
         _loc5_.drawRoundRect(0,0,_loc4_,_loc3_,_loc3_,_loc3_);
         _loc5_.endFill();
         _loc2_.x = Math.round((_loc4_ - _loc2_.width) / 2);
         _loc2_.y = Math.round((_loc3_ - _loc2_.height) / 2);
         _loc1_.addChild(_loc2_);
         _loc1_.x = param2 + 2;
         _loc1_.y = param3 - _loc3_ - 2;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         return _loc1_;
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(Boolean(this._editing) || !this._shown)
         {
            return;
         }
         this.endPress();
         var _loc1_:Sprite = Sprite(param1.currentTarget);
         this.pressed = this.btns.indexOf(_loc1_);
         this.cancelled = false;
         this.sx = param1.stageX;
         this.sy = param1.stageY;
         this.setPressed(this.pressed,true);
         this.st = _loc1_.stage;
         this.st.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
      }

      private function onMove(param1:MouseEvent) : void
      {
         if(this.pressed < 0 || Boolean(this.cancelled))
         {
            return;
         }
         var _loc1_:Number = param1.stageX - this.sx;
         var _loc2_:Number = param1.stageY - this.sy;
         if(_loc1_ * _loc1_ + _loc2_ * _loc2_ >= CANCEL_SQ)
         {
            this.cancelled = true;
            this.setPressed(this.pressed,false);
         }
      }

      private function onUp(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:int = int(this.pressed);
         var _loc3_:Boolean = _loc2_ >= 0 && !this.cancelled && Boolean(this.btns[_loc2_].visible) && Boolean(this.hits[_loc2_].hitTestPoint(param1.stageX,param1.stageY,true));
         this.endPress();
         if(_loc3_)
         {
            _loc1_ = this.slot(_loc2_);
            if(_loc1_ != null)
            {
               _loc1_.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            }
         }
      }

      private function endPress() : void
      {
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.st = null;
         }
         if(this.pressed >= 0 && this.pressed < this.btns.length)
         {
            this.setPressed(this.pressed,false);
         }
         this.pressed = -1;
         this.cancelled = false;
      }

      private function onHandleDown(param1:MouseEvent) : void
      {
         if(Boolean(this._editing) || !this._shown)
         {
            return;
         }
         this.endHandle();
         this.hst = this.handle.stage;
         if(this.hst == null)
         {
            return;
         }
         this.hPress = true;
         this.hx = param1.stageX;
         this.hy = param1.stageY;
         this.drawHandle(true);
         this.hst.addEventListener(MouseEvent.MOUSE_UP,this.onHandleUp,false,0,true);
         this.hst.addEventListener(MouseEvent.MOUSE_MOVE,this.onHandleMove,false,0,true);
         this.hst.addEventListener(Event.DEACTIVATE,this.onHandleLost,false,0,true);
         this.hst.addEventListener(Event.MOUSE_LEAVE,this.onHandleLost,false,0,true);
         if(!this._collapsed)
         {
            this.hold.start(this.hW,this.hH,this.onHoldDone);
         }
      }

      private function onHandleMove(param1:MouseEvent) : void
      {
         this.hx = param1.stageX;
         this.hy = param1.stageY;
         if(Boolean(this.hold.active) && !this.hHit.hitTestPoint(this.hx,this.hy,true))
         {
            this.hold.stop();
         }
      }

      private function onHandleLost(param1:Event) : void
      {
         this.endHandle();
      }

      private function onHoldDone() : void
      {
         var _loc1_:Boolean = Boolean(this.hPress) && Boolean(this.hHit.hitTestPoint(this.hx,this.hy,true));
         this.endHandle();
         if(_loc1_)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }

      private function onHandleUp(param1:MouseEvent) : void
      {
         var _loc1_:Boolean = Boolean(this.hPress) && Boolean(this.hHit.hitTestPoint(param1.stageX,param1.stageY,true));
         var _loc2_:Boolean = Boolean(this._collapsed);
         this.endHandle();
         if(_loc1_ && _loc2_)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         else if(_loc1_)
         {
            dispatchEvent(new Event(HOLD_HINT));
         }
      }

      private function endHandle() : void
      {
         this.hold.stop();
         if(this.hst != null)
         {
            this.hst.removeEventListener(MouseEvent.MOUSE_UP,this.onHandleUp);
            this.hst.removeEventListener(MouseEvent.MOUSE_MOVE,this.onHandleMove);
            this.hst.removeEventListener(Event.DEACTIVATE,this.onHandleLost);
            this.hst.removeEventListener(Event.MOUSE_LEAVE,this.onHandleLost);
            this.hst = null;
         }
         if(this.hPress)
         {
            this.hPress = false;
            this.drawHandle(false);
         }
      }

      private function drawHandle(param1:Boolean) : void
      {
         NativeArt.menuFace(this.hFace.graphics,this.hW,this.hH,param1);
         this.hFace.transform.colorTransform = param1 ? DARK : IDENT;
         this.handle.alpha = param1 ? 1 : Number(IDLE_ALPHA);
         var _loc1_:Graphics = this.hChev.graphics;
         _loc1_.clear();
         var _loc2_:Number = Math.min(this.hW / 28,this.hH / 56);
         _loc1_.lineStyle(3 * _loc2_,16777215,1,true,LineScaleMode.NORMAL,CapsStyle.ROUND,JointStyle.ROUND);
         var _loc3_:Number = (this._collapsed ? -1 : 1) * _loc2_;
         var _loc4_:Number = this.hW / 2;
         var _loc5_:Number = this.hH / 2;
         _loc1_.moveTo(_loc4_ - 4 * _loc3_,_loc5_ - 9 * _loc2_);
         _loc1_.lineTo(_loc4_ + 4 * _loc3_,_loc5_);
         _loc1_.lineTo(_loc4_ - 4 * _loc3_,_loc5_ + 9 * _loc2_);
      }

      private function onDashDown(param1:MouseEvent) : void
      {
         this.fireDash();
      }

      private function onDashTouch(param1:TouchEvent) : void
      {
         if(!param1.isPrimaryTouchPoint)
         {
            this.fireDash();
         }
      }

      private function fireDash() : void
      {
         if(Boolean(this._editing) || !this._shown || Boolean(this._collapsed))
         {
            return;
         }
         if(MoveInput.requestDash())
         {
            this.dashT = getTimer();
            this.drawDash(true);
         }
      }

      private function drawDash(param1:Boolean) : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         NativeArt.menuFace(this.dashFace.graphics,this.dashS,this.dashS,param1);
         this.dashFace.transform.colorTransform = param1 ? DARK : IDENT;
         this.dashBtn.filters = param1 ? PRESS_GLOW : null;
         this.dashBtn.scaleX = this.dashBtn.scaleY = param1 ? 0.92 : 1;
         this.dashBtn.alpha = !this.dashOk ? Number(DASH_OFF) : (param1 ? 1 : Number(IDLE_ALPHA));
         var _loc3_:Graphics = this.dashGlyph.graphics;
         _loc3_.clear();
         var _loc4_:Number = this.dashS * 0.5 / 100;
         var _loc5_:Number = -this.dashS * 0.22;
         var _loc6_:Number = -this.dashS * 0.25;
         for each(_loc1_ in FIG)
         {
            _loc3_.beginFill(16777215);
            _loc3_.moveTo(_loc5_ + _loc1_[0] * _loc4_,_loc6_ + _loc1_[1] * _loc4_);
            _loc2_ = 2;
            while(_loc2_ < _loc1_.length)
            {
               _loc3_.lineTo(_loc5_ + _loc1_[_loc2_] * _loc4_,_loc6_ + _loc1_[_loc2_ + 1] * _loc4_);
               _loc2_ += 2;
            }
            _loc3_.endFill();
         }
         _loc3_.lineStyle(this.dashS / 22,16777215,0.85,true,LineScaleMode.NORMAL,CapsStyle.ROUND);
         _loc3_.moveTo(_loc5_ - 26 * _loc4_,_loc6_ + 10 * _loc4_);
         _loc3_.lineTo(_loc5_ + 14 * _loc4_,_loc6_ + 10 * _loc4_);
         _loc3_.moveTo(_loc5_ - 34 * _loc4_,_loc6_ + 27 * _loc4_);
         _loc3_.lineTo(_loc5_ + 12 * _loc4_,_loc6_ + 27 * _loc4_);
         _loc3_.moveTo(_loc5_ - 24 * _loc4_,_loc6_ + 44 * _loc4_);
         _loc3_.lineTo(_loc5_ + 6 * _loc4_,_loc6_ + 44 * _loc4_);
      }

      private function setPressed(param1:int, param2:Boolean) : void
      {
         var _loc1_:Sprite = this.faces[param1];
         _loc1_.scaleX = _loc1_.scaleY = param2 ? 0.92 : 1;
         _loc1_.filters = param2 ? PRESS_GLOW : null;
         this.btns[param1].alpha = param2 ? 1 : IDLE_ALPHA;
      }

      private function onTick(param1:TimerEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Sprite = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         ++this.tick;
         if(this._collapsed)
         {
            return;
         }
         var _loc7_:Number = 0;
         var _loc8_:Number = 0;
         try
         {
            _loc7_ = Math.min(Math.max(Number(Mobile.game.world.myAvatar.dataLeaf.sta.$tha),-1),0.5);
         }
         catch(err:Error)
         {
         }
         try
         {
            _loc8_ = Number(Mobile.game.world.GCD) + 300;
         }
         catch(err2:Error)
         {
         }
         if(_loc8_ <= 0)
         {
            _loc8_ = 0;
         }
         var _loc9_:int = int(getTimer());
         var _loc10_:Boolean = Boolean(MoveInput.dashReady());
         if(_loc10_ != this.dashOk || this.dashT > 0 && _loc9_ - this.dashT > 140)
         {
            this.dashOk = _loc10_;
            if(this.dashT > 0 && _loc9_ - this.dashT > 140)
            {
               this.dashT = 0;
            }
            this.drawDash(this.dashT > 0);
         }
         var _loc11_:int = 0;
         while(_loc11_ < 6)
         {
            _loc1_ = this.slot(_loc11_);
            _loc2_ = this.btns[_loc11_];
            if(_loc1_ == null || _loc1_.actObj == null || _loc1_.actObj.ref == "i1" && !_loc1_.actObj.sArg1)
            {
               if(_loc2_.visible)
               {
                  if(this.pressed == _loc11_)
                  {
                     this.endPress();
                  }
                  _loc2_.visible = false;
               }
               this.lastIcon[_loc11_] = null;
               this.clearSweep(_loc11_);
            }
            else
            {
               if(!_loc2_.visible)
               {
                  _loc2_.visible = true;
               }
               _loc3_ = _loc1_.cnt != null ? Number(_loc1_.cnt.alpha) : 1;
               if(_loc1_ != this.lastIcon[_loc11_] || _loc3_ != this.lastAlpha[_loc11_] || this.tick - this.lastTick[_loc11_] >= REFRESH_TICKS)
               {
                  if(_loc1_ != this.lastIcon[_loc11_])
                  {
                     this.clearSweep(_loc11_);
                  }
                  this.lastIcon[_loc11_] = _loc1_;
                  this.lastAlpha[_loc11_] = _loc3_;
                  this.lastTick[_loc11_] = this.tick;
                  this.drawIcon(_loc11_,_loc1_);
               }
               if(_loc1_.icon2 != null && _loc1_.cd > 0 && !_loc1_.actObj.lock)
               {
                  _loc4_ = Math.round(_loc1_.cd * (1 - _loc7_));
                  _loc5_ = _loc9_ - _loc1_.tsg;
                  _loc6_ = _loc4_ > 0 ? _loc5_ / _loc4_ : 1;
                  if(_loc6_ < 0.99)
                  {
                     this.updateSweep(_loc11_,_loc6_,_loc1_.cd > _loc8_ ? int(Math.ceil((_loc4_ - _loc5_) / 1000)) : 0);
                  }
                  else
                  {
                     this.clearSweep(_loc11_);
                  }
               }
               else
               {
                  this.clearSweep(_loc11_);
               }
            }
            _loc11_++;
         }
      }

      private function drawIcon(param1:int, param2:MovieClip) : void
      {
         var _loc1_:BitmapData = this.bmds[param1];
         _loc1_.fillRect(_loc1_.rect,0);
         var _loc2_:Number = Math.min(_loc1_.width / REF_W,_loc1_.height / REF_H);
         var _loc3_:Matrix = new Matrix(_loc2_,0,0,_loc2_,(_loc1_.width - REF_W * _loc2_) / 2 - REF_X * _loc2_,(_loc1_.height - REF_H * _loc2_) / 2 - REF_Y * _loc2_);
         try
         {
            _loc1_.drawWithQuality(param2,_loc3_,null,null,null,true,StageQuality.HIGH);
         }
         catch(e:Error)
         {
         }
      }

      private function updateSweep(param1:int, param2:Number, param3:int) : void
      {
         var _loc1_:TextField = null;
         var _loc2_:int = int(Math.min(Math.max(param2,0),1) * 360);
         if(_loc2_ != this.lastDeg[param1])
         {
            this.lastDeg[param1] = _loc2_;
            this.drawPie(this.pies[param1],_loc2_,this.radii[param1]);
         }
         if(param3 != this.lastSec[param1])
         {
            this.lastSec[param1] = param3;
            _loc1_ = this.cdTxts[param1];
            _loc1_.visible = param3 > 0;
            if(param3 > 0)
            {
               _loc1_.text = String(param3);
               _loc1_.x = -Math.round(_loc1_.width / 2);
               _loc1_.y = -Math.round(_loc1_.height / 2);
            }
         }
      }

      private function clearSweep(param1:int) : void
      {
         if(this.lastDeg[param1] >= 0)
         {
            this.lastDeg[param1] = -1;
            Shape(this.pies[param1]).graphics.clear();
         }
         if(this.lastSec[param1] != 0)
         {
            this.lastSec[param1] = 0;
            TextField(this.cdTxts[param1]).visible = false;
         }
      }

      private function drawPie(param1:Shape, param2:int, param3:Number) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Graphics = param1.graphics;
         _loc2_.clear();
         if(param2 >= 360)
         {
            return;
         }
         var _loc3_:Number = (param2 - 90) * Math.PI / 180;
         var _loc4_:Number = (360 - param2) * Math.PI / 180;
         var _loc5_:int = Math.max(1,Math.ceil((360 - param2) / 10));
         _loc2_.beginFill(0,SWEEP_ALPHA);
         _loc2_.moveTo(0,0);
         var _loc6_:int = 0;
         while(_loc6_ <= _loc5_)
         {
            _loc1_ = _loc3_ + _loc4_ * _loc6_ / _loc5_;
            _loc2_.lineTo(param3 * Math.cos(_loc1_),param3 * Math.sin(_loc1_));
            _loc6_++;
         }
         _loc2_.lineTo(0,0);
         _loc2_.endFill();
      }

      private function dashRect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         this.dashLine(param1,param2,param3,param2 + param4,param3);
         this.dashLine(param1,param2 + param4,param3,param2 + param4,param3 + param5);
         this.dashLine(param1,param2 + param4,param3 + param5,param2,param3 + param5);
         this.dashLine(param1,param2,param3 + param5,param2,param3);
      }

      private function dashLine(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = Math.sqrt((param4 - param2) * (param4 - param2) + (param5 - param3) * (param5 - param3));
         var _loc3_:Number = (param4 - param2) / _loc2_;
         var _loc4_:Number = (param5 - param3) / _loc2_;
         var _loc5_:Number = 0;
         while(_loc5_ < _loc2_)
         {
            _loc1_ = Math.min(_loc5_ + 8,_loc2_);
            param1.moveTo(param2 + _loc3_ * _loc5_,param3 + _loc4_ * _loc5_);
            param1.lineTo(param2 + _loc3_ * _loc1_,param3 + _loc4_ * _loc1_);
            _loc5_ += 13;
         }
      }
   }
}
