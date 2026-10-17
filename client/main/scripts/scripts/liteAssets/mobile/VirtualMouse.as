package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;

   public class VirtualMouse extends Sprite
   {

      public static const MINIMIZE:String = "vmMinimize";

      private static const STAGE_W:int = 960;

      private static const STAGE_H:int = 550;

      private static const LIMIT_Y:int = 500;

      private static const HOME_Y:int = 482;

      private static const CHAT_R:int = 372;

      private static const HOME_GAP:int = 8;

      private static const TAP_MS:int = 200;

      private static const TAP_DIST_SQ:int = 64;

      private static const PICK_MS:int = 30;

      private static const WHEEL_PX:Number = 12;

      private static const WHEEL_MAX:int = 8;

      private static const G_MIN:Number = 1;

      private static const G_MAX:Number = 3.2;

      private static const V0:Number = 25;

      private static const V1:Number = 250;

      private static const FADE:Number = 0.35;

      private static const DIM:Number = 0.4;

      private static const WALK_AREA:String = "btnWalkingArea";

      private static const ARROW:Array = [0,0,0,16.5,4.2,12.6,7.2,18.6,9.6,17.5,6.7,11.6,11.8,11.6];

      private static const SHADOW:DropShadowFilter = new DropShadowFilter(2,60,0,0.45,4,4,1,2);

      private static const INK:uint = 2759178;

      private static const RIM:uint = 13145646;

      private static const RIM_ON:uint = 10119710;

      private static const BODY:Array = [16777215,15919317];

      private static const BODY_ON:Array = [16773828,15778378];

      private var g:MovieClip;

      private var skipObj:DisplayObject;

      private var homeL:int;

      private var homeR:int;

      private var st:Stage;

      private var panel:Trackpad;

      private var arrow:Sprite;

      private var opened:Boolean = false;

      private var faded:Boolean = false;

      private var mini:Boolean = false;

      private var k:Number = 4.4;

      private var cx:Number = 480;

      private var cy:Number = 275;

      private var hot:Point = new Point(STAGE_W / 2,STAGE_H / 2);

      private var busy:int = 0;

      private var part:String;

      private var gx0:Number = 0;

      private var gy0:Number = 0;

      private var lx:Number = 0;

      private var ly:Number = 0;

      private var gt0:int = 0;

      private var lt:int = 0;

      private var moved:Boolean = false;

      private var vs:Number = 0;

      private var acc:Number = 0;

      private var ox:Number = 0;

      private var oy:Number = 0;

      private var pickT:int = -1000;

      private var moveT:InteractiveObject;

      private var hoverT:InteractiveObject;

      private var chain:Array = [];

      private var held:Boolean = false;

      private var holdT:InteractiveObject;

      private var holdWalk:Boolean = false;

      private var lpOff:Boolean = false;

      private var sbBtn:SimpleButton;

      private var sbUp:DisplayObject;

      private var sbSet:DisplayObject;

      private var tipTimer:Timer;

      private var overT:int = 0;

      private var realT:int = 0;

      private var tipMine:Boolean = false;

      private var lastUpdate:int;

      public function VirtualMouse(param1:MovieClip, param2:DisplayObject, param3:int, param4:int)
      {
         super();
         this.g = param1;
         this.skipObj = param2;
         this.homeL = param3;
         this.homeR = param4;
         mouseEnabled = false;
         tabEnabled = false;
         tabChildren = false;
         this.arrow = new Sprite();
         this.arrow.mouseEnabled = false;
         this.arrow.mouseChildren = false;
         this.arrow.filters = [SHADOW];
         addChild(this.arrow);
      }

      private static function poly(param1:Graphics, param2:Array) : void
      {
         param1.moveTo(param2[0],param2[1]);
         var _loc1_:int = 2;
         while(_loc1_ < param2.length)
         {
            param1.lineTo(param2[_loc1_],param2[_loc1_ + 1]);
            _loc1_ += 2;
         }
         param1.lineTo(param2[0],param2[1]);
      }

      public function get isOpen() : Boolean
      {
         return this.opened;
      }

      public function get pos() : Object
      {
         return this.panel != null ? {
            "x":int(this.panel.x),
            "y":int(this.panel.y)
         } : null;
      }

      public function get minimized() : Boolean
      {
         return this.mini;
      }

      public function set minimized(param1:Boolean) : void
      {
         this.applyMin(param1,false);
      }

      public function open(param1:Object, param2:Boolean = false) : void
      {
         if(Boolean(this.opened) || this.g == null)
         {
            return;
         }
         this.st = this.g.stage;
         if(this.st == null)
         {
            return;
         }
         this.k = Mobile.touchPx(10) / 10;
         this.panel = new Trackpad(this.k);
         addChildAt(this.panel,getChildIndex(this.arrow));
         this.drawArrow();
         this.opened = true;
         this.mini = param2;
         this.panel.setMinimized(this.mini,false);
         this.arrow.alpha = this.mini ? Number(DIM) : 1;
         this.place(param1);
         if(this.cx >= this.panel.x && this.cx <= this.panel.x + this.panel.boxW && this.cy >= this.panel.y && this.cy <= this.panel.y + this.panel.boxH)
         {
            this.cx = int(this.panel.x + this.panel.width / 2);
            this.cy = Math.max(12,int(this.panel.y - 40));
            this.hot.x = this.cx;
            this.hot.y = this.cy;
         }
         this.st.addChild(this);
         this.st.addEventListener(MouseEvent.MOUSE_DOWN,this.onRealDown,true,int.MAX_VALUE,true);
         this.st.addEventListener(MouseEvent.MOUSE_MOVE,this.onRealMove,true,int.MAX_VALUE,true);
         this.st.addEventListener(MouseEvent.MOUSE_MOVE,this.onRealMove,false,int.MAX_VALUE,true);
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onRealUp,true,int.MAX_VALUE,true);
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onRealUp,false,int.MAX_VALUE,true);
         this.st.addEventListener(MouseEvent.CLICK,this.onRealClick,true,int.MAX_VALUE,true);
         this.st.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onFocusChange,true,int.MAX_VALUE,true);
         this.st.addEventListener(Event.ADDED,this.onAdded,false,0,true);
         this.st.addEventListener(Event.DEACTIVATE,this.onCancel,false,0,true);
         this.hookTip(true);
         this.arrow.x = this.hot.x;
         this.arrow.y = this.hot.y;
         this.fade();
         this.refresh();
      }

      public function place(param1:Object) : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.panel == null)
         {
            return;
         }
         if(param1 != null && param1.x != null && param1.y != null)
         {
            this.panel.x = Number(param1.x);
            this.panel.y = Number(param1.y);
         }
         else
         {
            _loc1_ = Math.max(this.homeL,CHAT_R) + HOME_GAP;
            _loc2_ = this.homeR - HOME_GAP;
            this.panel.x = this.panel.boxW <= _loc2_ - _loc1_ ? Math.round(_loc1_ + (_loc2_ - _loc1_ - this.panel.boxW) / 2) : _loc2_ - this.panel.boxW;
            this.panel.y = HOME_Y - this.panel.fullH;
         }
         this.clampPanel();
         this.fade();
      }

      public function close() : void
      {
         if(!this.opened)
         {
            return;
         }
         this.endGesture();
         if(this.held)
         {
            this.setHold(false,false);
         }
         this.setHover(null);
         this.sbRestore();
         if(this.tipMine)
         {
            this.closeTip();
         }
         this.opened = false;
         this.moveT = null;
         this.hookTip(false);
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_DOWN,this.onRealDown,true);
            this.st.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRealMove,true);
            this.st.removeEventListener(MouseEvent.MOUSE_MOVE,this.onRealMove,false);
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onRealUp,true);
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onRealUp,false);
            this.st.removeEventListener(MouseEvent.CLICK,this.onRealClick,true);
            this.st.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onFocusChange,true);
            this.st.removeEventListener(Event.ADDED,this.onAdded);
            this.st.removeEventListener(Event.DEACTIVATE,this.onCancel);
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
         if(this.panel != null)
         {
            removeChild(this.panel);
            this.panel = null;
         }
         this.faded = false;
      }

      public function destroy() : void
      {
         this.close();
         this.g = null;
         this.skipObj = null;
         this.st = null;
      }

      private function applyMin(param1:Boolean, param2:Boolean) : void
      {
         this.mini = param1;
         this.arrow.alpha = param1 ? Number(DIM) : 1;
         if(this.panel == null)
         {
            return;
         }
         if(param1)
         {
            this.endGesture();
            if(this.held)
            {
               this.setHold(false,false);
            }
            this.setHover(null);
            this.sbRestore();
            if(this.tipMine)
            {
               this.closeTip();
            }
            this.moveT = null;
         }
         this.panel.setMinimized(param1,param2);
         this.clampPanel();
         this.fade();
      }

      private function clampPanel() : void
      {
         this.panel.x = Math.round(Math.max(0,Math.min(STAGE_W - this.panel.boxW,this.panel.x)));
         this.panel.y = Math.round(Math.max(0,Math.min(LIMIT_Y - this.panel.boxH,this.panel.y)));
      }

      private function fade() : void
      {
         if(this.panel == null)
         {
            return;
         }
         var _loc1_:Boolean = this.hot.x >= this.panel.x && this.hot.x <= this.panel.x + this.panel.boxW && this.hot.y >= this.panel.y && this.hot.y <= this.panel.y + this.panel.boxH;
         if(_loc1_ == this.faded)
         {
            return;
         }
         this.faded = _loc1_;
         this.panel.alpha = _loc1_ ? Number(FADE) : 1;
      }

      private function drawArrow() : void
      {
         var _loc1_:Graphics = this.arrow.graphics;
         _loc1_.clear();
         var _loc2_:Number = Math.max(19,Math.min(34,Math.round(4.6 * this.k))) / 18.6;
         var _loc3_:int = Math.max(1,Math.round(_loc2_ * 0.9));
         var _loc4_:int = Math.max(1,Math.round(_loc2_ * 0.75));
         var _loc5_:Number = _loc4_ % 2 == 1 ? 0.5 : 0;
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < ARROW.length)
         {
            _loc6_.push(Math.round(ARROW[_loc7_] * _loc2_) + _loc5_);
            _loc7_++;
         }
         _loc1_.lineStyle(_loc4_ + _loc3_ * 2,INK,1,true,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,3);
         _loc1_.beginFill(INK);
         poly(_loc1_,_loc6_);
         _loc1_.endFill();
         var _loc8_:Matrix = new Matrix();
         _loc8_.createGradientBox(12 * _loc2_,19 * _loc2_,Math.PI / 2,0,0);
         _loc1_.lineStyle(_loc4_,this.held ? uint(RIM_ON) : uint(RIM),1,true,LineScaleMode.NORMAL,CapsStyle.NONE,JointStyle.MITER,3);
         _loc1_.beginGradientFill(GradientType.LINEAR,this.held ? BODY_ON : BODY,[1,1],[0,255],_loc8_);
         poly(_loc1_,_loc6_);
         _loc1_.endFill();
      }

      private function onRealDown(param1:MouseEvent) : void
      {
         if(this.busy > 0)
         {
            return;
         }
         if(this.part != null)
         {
            this.endGesture();
         }
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(this.panel == null || _loc1_ == null || !this.panel.contains(_loc1_))
         {
            this.realT = getTimer();
            return;
         }
         param1.stopImmediatePropagation();
         this.part = this.panel.partOf(_loc1_);
         this.gx0 = this.lx = param1.stageX;
         this.gy0 = this.ly = param1.stageY;
         this.gt0 = this.lt = getTimer();
         this.moved = false;
         this.vs = 0;
         this.acc = 0;
         this.ox = this.panel.x;
         this.oy = this.panel.y;
         if(this.part == Trackpad.STRIP)
         {
            this.refresh();
         }
         this.panel.press(this.part,true);
      }

      private function onRealMove(param1:MouseEvent) : void
      {
         if(this.busy > 0 || this.part == null)
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc1_:Number = param1.stageX;
         var _loc2_:Number = param1.stageY;
         var _loc3_:int = int(getTimer());
         var _loc4_:Number = _loc1_ - this.lx;
         var _loc5_:Number = _loc2_ - this.ly;
         var _loc6_:int = _loc3_ - this.lt;
         this.lx = _loc1_;
         this.ly = _loc2_;
         this.lt = _loc3_;
         var _loc7_:Number = _loc1_ - this.gx0;
         var _loc8_:Number = _loc2_ - this.gy0;
         if(!this.moved && _loc7_ * _loc7_ + _loc8_ * _loc8_ >= TAP_DIST_SQ)
         {
            this.moved = true;
         }
         if(this.part == Trackpad.PAD)
         {
            this.padMove(_loc4_,_loc5_,_loc6_);
         }
         else if(this.part == Trackpad.STRIP)
         {
            this.stripMove(_loc5_);
         }
         else if(this.part == Trackpad.GRIP)
         {
            if(this.moved)
            {
               this.panel.x = this.ox + _loc7_;
               this.panel.y = this.oy + _loc8_;
               this.clampPanel();
               this.fade();
            }
         }
         else
         {
            this.panel.press(this.part,this.panel.partOf(param1.target as DisplayObject) == this.part);
         }
         var _loc9_:int = int(getTimer());
         if(_loc9_ - this.lastUpdate >= 33)
         {
            this.lastUpdate = _loc9_;
            param1.updateAfterEvent();
         }
      }

      private function onRealUp(param1:MouseEvent) : void
      {
         if(this.busy > 0 || this.part == null)
         {
            return;
         }
         param1.stopImmediatePropagation();
         var _loc1_:String = this.part;
         var _loc2_:Boolean = !this.moved && getTimer() - this.gt0 < TAP_MS;
         var _loc3_:Boolean = Boolean(this.moved);
         var _loc4_:Boolean = this.panel.partOf(param1.target as DisplayObject) == _loc1_;
         this.endGesture();
         if(_loc1_ == Trackpad.PAD)
         {
            if(_loc2_)
            {
               this.primary();
            }
            else if(this.opened)
            {
               this.refresh();
            }
            return;
         }
         if(_loc1_ == Trackpad.GRIP)
         {
            if(_loc3_)
            {
               dispatchEvent(new Event(Event.CHANGE));
            }
            return;
         }
         if(!_loc4_)
         {
            return;
         }
         if(_loc1_ == Trackpad.LEFT)
         {
            this.primary();
         }
         else if(_loc1_ == Trackpad.RIGHT)
         {
            this.secondary();
         }
         else if(_loc1_ == Trackpad.HOLD)
         {
            this.setHold(!this.held);
         }
         else if(_loc1_ == Trackpad.CLOSE)
         {
            dispatchEvent(new Event(Event.CLOSE));
         }
         else if(_loc1_ == Trackpad.MIN)
         {
            this.applyMin(!this.mini,true);
            dispatchEvent(new Event(MINIMIZE));
         }
      }

      private function onRealClick(param1:MouseEvent) : void
      {
         if(this.busy > 0 || this.panel == null)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(_loc1_ != null && Boolean(this.panel.contains(_loc1_)))
         {
            param1.stopImmediatePropagation();
         }
      }

      private function onFocusChange(param1:FocusEvent) : void
      {
         var _loc1_:DisplayObject = param1.relatedObject as DisplayObject;
         if(this.busy == 0 && _loc1_ != null && contains(_loc1_))
         {
            param1.preventDefault();
         }
      }

      private function onAdded(param1:Event) : void
      {
         if(this.st == null || parent != this.st)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(_loc1_ == null || _loc1_ == this || _loc1_.parent != this.st)
         {
            return;
         }
         var _loc2_:int = this.st.numChildren - 1;
         if(this.st.getChildIndex(this) != _loc2_)
         {
            this.st.setChildIndex(this,_loc2_);
         }
      }

      private function onCancel(param1:Event) : void
      {
         this.endGesture();
      }

      private function endGesture() : void
      {
         if(this.part != null && this.panel != null)
         {
            this.panel.press(this.part,false);
         }
         this.part = null;
         this.acc = 0;
      }

      private function padMove(param1:Number, param2:Number, param3:int) : void
      {
         var _loc1_:Number = Math.sqrt(param1 * param1 + param2 * param2);
         if(_loc1_ <= 0)
         {
            return;
         }
         var _loc2_:Number = _loc1_ / this.k / (param3 < 4 ? 4 : param3) * 1000;
         this.vs = this.vs > 0 ? this.vs * 0.5 + _loc2_ * 0.5 : _loc2_;
         var _loc3_:Number = (this.vs - V0) / (V1 - V0);
         _loc3_ = _loc3_ < 0 ? 0 : (_loc3_ > 1 ? 1 : _loc3_);
         var _loc4_:Number = G_MIN + (G_MAX - G_MIN) * _loc3_ * _loc3_ * (3 - 2 * _loc3_);
         this.moveCursor(this.cx + param1 * _loc4_,this.cy + param2 * _loc4_);
      }

      private function moveCursor(param1:Number, param2:Number) : void
      {
         this.cx = param1 < 0 ? 0 : (param1 > STAGE_W ? Number(STAGE_W) : param1);
         this.cy = param2 < 0 ? 0 : (param2 > STAGE_H ? Number(STAGE_H) : param2);
         var _loc1_:int = Math.round(this.cx);
         var _loc2_:int = Math.round(this.cy);
         if(_loc1_ == this.hot.x && _loc2_ == this.hot.y)
         {
            return;
         }
         this.hot.x = _loc1_;
         this.hot.y = _loc2_;
         this.arrow.x = _loc1_;
         this.arrow.y = _loc2_;
         this.fade();
         if(getTimer() - this.pickT >= PICK_MS || this.moveT == null || this.moveT.stage == null)
         {
            this.refresh();
         }
         this.fire(this.dest(this.moveT),MouseEvent.MOUSE_MOVE);
      }

      private function stripMove(param1:Number) : void
      {
         this.acc += param1;
         var _loc1_:int = 0;
         while(this.acc >= WHEEL_PX && _loc1_ < WHEEL_MAX)
         {
            this.acc -= WHEEL_PX;
            this.wheel(-1);
            _loc1_++;
         }
         while(this.acc <= -WHEEL_PX && _loc1_ < WHEEL_MAX)
         {
            this.acc += WHEEL_PX;
            this.wheel(1);
            _loc1_++;
         }
         if(_loc1_ >= WHEEL_MAX)
         {
            this.acc = 0;
         }
      }

      private function wheel(param1:int) : void
      {
         if(!this.opened)
         {
            return;
         }
         if(this.moveT == null || this.moveT.stage == null)
         {
            this.refresh();
         }
         this.fire(this.dest(this.moveT),MouseEvent.MOUSE_WHEEL,true,null,param1);
      }

      private function primary() : void
      {
         if(this.held)
         {
            this.setHold(false);
            return;
         }
         var _loc1_:InteractiveObject = this.refresh();
         if(this.isWalk(_loc1_))
         {
            this.walk();
            return;
         }
         this.fire(_loc1_,MouseEvent.MOUSE_DOWN);
         this.focusText(_loc1_);
         if(!this.opened)
         {
            return;
         }
         this.fire(_loc1_,MouseEvent.MOUSE_UP);
         if(Boolean(this.opened) && _loc1_.stage != null)
         {
            this.fire(_loc1_,MouseEvent.CLICK);
         }
         if(this.opened)
         {
            this.refresh();
         }
      }

      private function secondary() : void
      {
         var _loc1_:InteractiveObject = this.dest(this.refresh());
         this.fire(_loc1_,MouseEvent.RIGHT_MOUSE_DOWN);
         this.fire(_loc1_,MouseEvent.RIGHT_MOUSE_UP);
         if(_loc1_.stage != null)
         {
            this.fire(_loc1_,MouseEvent.RIGHT_CLICK);
         }
         if(this.opened)
         {
            this.refresh();
         }
      }

      private function setHold(param1:Boolean, param2:Boolean = true) : void
      {
         var _loc1_:InteractiveObject = null;
         var _loc2_:Boolean = false;
         if(param1 == this.held)
         {
            return;
         }
         var _loc3_:InteractiveObject = this.refresh();
         if(param1)
         {
            this.held = true;
            this.holdT = _loc3_;
            this.holdWalk = this.isWalk(_loc3_);
            if(!this.holdWalk)
            {
               if(!this.lpOff)
               {
                  LongPress.stop();
                  this.lpOff = true;
               }
               this.fire(_loc3_,MouseEvent.MOUSE_DOWN);
               this.focusText(_loc3_);
            }
         }
         else
         {
            _loc1_ = this.holdT;
            _loc2_ = Boolean(this.holdWalk);
            this.held = false;
            this.holdT = null;
            this.holdWalk = false;
            if(_loc2_)
            {
               if(param2 && Boolean(this.isWalk(_loc3_)))
               {
                  this.walk();
               }
            }
            else
            {
               this.fire(this.dest(_loc3_),MouseEvent.MOUSE_UP);
               if(param2 && _loc3_ == _loc1_ && _loc3_.stage != null)
               {
                  this.fire(_loc3_,MouseEvent.CLICK);
               }
            }
            if(this.lpOff)
            {
               this.lpOff = false;
               if(this.g != null && Boolean(Mobile.active))
               {
                  LongPress.start(this.g);
               }
            }
         }
         this.sbRestore();
         this.sbHover();
         this.drawArrow();
         if(this.panel != null)
         {
            this.panel.hold = this.held;
         }
      }

      private function walk() : void
      {
         var _loc1_:* = undefined;
         try
         {
            _loc1_ = this.g.world;
            if(_loc1_ != null)
            {
               _loc1_.walkToPoint(this.hot.x,this.hot.y);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function focusText(param1:InteractiveObject) : void
      {
         var _loc1_:TextField = param1 as TextField;
         if(_loc1_ == null || _loc1_.type != TextFieldType.INPUT || this.st == null)
         {
            return;
         }
         try
         {
            this.st.focus = _loc1_;
            _loc1_.setSelection(_loc1_.length,_loc1_.length);
            _loc1_["requestSoftKeyboard"]();
         }
         catch(e:Error)
         {
         }
      }

      private function isWalk(param1:DisplayObject) : Boolean
      {
         var _loc1_:DisplayObject = param1;
         while(_loc1_ != null && _loc1_ != this.st)
         {
            if(_loc1_.name == WALK_AREA)
            {
               return true;
            }
            _loc1_ = _loc1_.parent;
         }
         return false;
      }

      private function dest(param1:InteractiveObject) : InteractiveObject
      {
         return param1 == null || Boolean(this.isWalk(param1)) ? this.st : param1;
      }

      private function fire(param1:InteractiveObject, param2:String, param3:Boolean = true, param4:InteractiveObject = null, param5:int = 0) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc1_:Point = param1.globalToLocal(this.hot);
         var _loc2_:Boolean = param2 == MouseEvent.MOUSE_DOWN || Boolean(this.held) && param2 != MouseEvent.MOUSE_UP;
         ++this.busy;
         try
         {
            param1.dispatchEvent(new MouseEvent(param2,param3,false,_loc1_.x,_loc1_.y,param4,false,false,false,_loc2_,param5));
         }
         catch(e:Error)
         {
         }
         --this.busy;
      }

      private function refresh() : InteractiveObject
      {
         this.pickT = getTimer();
         var _loc1_:InteractiveObject = this.pick();
         this.moveT = _loc1_;
         this.setHover(_loc1_ == this.st ? null : _loc1_);
         return _loc1_;
      }

      private function setHover(param1:InteractiveObject) : void
      {
         var _loc1_:* = 0;
         if(param1 == this.hoverT)
         {
            return;
         }
         var _loc2_:InteractiveObject = this.hoverT;
         var _loc3_:Array = this.chain;
         var _loc4_:Array = [];
         var _loc5_:Dictionary = new Dictionary();
         var _loc6_:Dictionary = new Dictionary();
         var _loc7_:DisplayObject = param1;
         while(_loc7_ != null && _loc7_ != this.st)
         {
            _loc4_.push(_loc7_);
            _loc5_[_loc7_] = true;
            _loc7_ = _loc7_.parent;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc3_.length)
         {
            _loc6_[_loc3_[_loc1_]] = true;
            _loc1_++;
         }
         this.hoverT = param1;
         this.chain = _loc4_;
         this.sbHover();
         if(_loc2_ != null)
         {
            this.fire(_loc2_,MouseEvent.MOUSE_OUT,true,param1);
            _loc1_ = 0;
            while(_loc1_ < _loc3_.length)
            {
               if(_loc5_[_loc3_[_loc1_]] != true)
               {
                  this.fire(InteractiveObject(_loc3_[_loc1_]),MouseEvent.ROLL_OUT,false,param1);
               }
               _loc1_++;
            }
            if(this.tipMine)
            {
               this.closeTip();
            }
         }
         if(param1 != null)
         {
            _loc1_ = int(_loc4_.length - 1);
            while(_loc1_ >= 0)
            {
               if(_loc6_[_loc4_[_loc1_]] != true)
               {
                  this.fire(InteractiveObject(_loc4_[_loc1_]),MouseEvent.ROLL_OVER,false,_loc2_);
               }
               _loc1_--;
            }
            this.fire(param1,MouseEvent.MOUSE_OVER,true,_loc2_);
            this.overT = getTimer();
            if(this.tipTimer != null && Boolean(this.tipTimer.running))
            {
               this.tipMine = true;
            }
         }
      }

      private function sbHover() : void
      {
         var _loc1_:SimpleButton = this.hoverT as SimpleButton;
         if(_loc1_ != this.sbBtn)
         {
            this.sbRestore();
         }
         if(_loc1_ == null || !_loc1_.enabled)
         {
            return;
         }
         if(this.sbBtn == null)
         {
            this.sbBtn = _loc1_;
            this.sbUp = _loc1_.upState;
            this.sbSet = this.sbUp;
         }
         else if(_loc1_.upState != this.sbSet)
         {
            this.sbBtn = null;
            this.sbUp = null;
            this.sbSet = null;
            return;
         }
         var _loc2_:DisplayObject = Boolean(this.held) && _loc1_ == this.holdT ? _loc1_.downState : _loc1_.overState;
         if(_loc2_ == null)
         {
            _loc2_ = this.sbUp;
         }
         if(_loc1_.upState != _loc2_)
         {
            _loc1_.upState = _loc2_;
         }
         this.sbSet = _loc1_.upState;
      }

      private function sbRestore() : void
      {
         if(this.sbBtn != null && this.sbBtn.upState == this.sbSet && this.sbSet != this.sbUp)
         {
            this.sbBtn.upState = this.sbUp;
         }
         this.sbBtn = null;
         this.sbUp = null;
         this.sbSet = null;
      }

      private function pick() : InteractiveObject
      {
         return TapPick.at(this.st,this.hot.x,this.hot.y,this,this.skipObj);
      }

      private function hookTip(param1:Boolean) : void
      {
         var on:Boolean = param1;
         if(this.tipTimer != null)
         {
            this.tipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onTip);
            this.tipTimer = null;
         }
         if(!on || this.g == null)
         {
            return;
         }
         try
         {
            this.tipTimer = this.g.ui.ToolTip.tOpen as Timer;
         }
         catch(e:Error)
         {
            tipTimer = null;
         }
         if(this.tipTimer != null)
         {
            this.tipTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onTip,false,-1,true);
         }
      }

      private function closeTip() : void
      {
         var _loc1_:MovieClip = null;
         this.tipMine = false;
         try
         {
            _loc1_ = this.g.ui.ToolTip;
            if(this.tipTimer != null && Boolean(this.tipTimer.running) || Boolean(_loc1_.cnt.visible) && Boolean(_loc1_.currentLabel != "out"))
            {
               _loc1_.close();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onTip(param1:TimerEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = null;
         var _loc3_:DisplayObjectContainer = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(!this.opened || Boolean(this.mini) || this.overT < this.realT)
         {
            return;
         }
         this.tipMine = true;
         try
         {
            _loc1_ = this.g.ui;
            _loc2_ = _loc1_.ToolTip;
            _loc3_ = _loc2_.getChildByName("cnt") as DisplayObjectContainer;
            _loc4_ = _loc3_ != null ? _loc3_.getChildByName("bg") : null;
            if(_loc4_ == null)
            {
               return;
            }
            if(int(_loc2_.x) == int(STAGE_W - _loc4_.width - 4) && int(_loc2_.y) == int(480 - _loc4_.height - 4))
            {
               return;
            }
            _loc5_ = this.hot.x - _loc2_.width / 2 - _loc1_.x;
            if(_loc5_ + _loc4_.width > STAGE_W)
            {
               _loc5_ = STAGE_W - _loc4_.width - 10;
            }
            if(_loc5_ < 1)
            {
               _loc5_ = 1;
            }
            _loc6_ = this.hot.y - _loc2_.height - 15;
            if(_loc6_ < 1)
            {
               _loc6_ = this.hot.y + this.arrow.height + 4;
            }
            _loc2_.x = int(_loc5_);
            _loc2_.y = int(_loc6_);
         }
         catch(err:Error)
         {
         }
      }
   }
}
