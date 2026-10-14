package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.utils.*;

   public class Joystick extends Sprite
   {

      public static const PAD:int = 183;

      private static const BG:int = 119;

      private static const HANDLE:int = 86;

      private static const DEAD:Number = 12;

      private static const RIM:Number = 30;

      private static const IDLE_ALPHA:Number = 0.698;

      private static const PRESS_ALPHA:Number = 1;

      private static const LIMIT_Y:int = 500;

      private static const TAP_DIST_SQ:int = 100;

      private static const TAP_MS:int = 250;

      private var hit:Sprite;

      private var gfx:Sprite;

      private var bgBmp:Bitmap;

      private var handleBmp:Bitmap;

      private var outline:Shape;

      private var cx:Number = 91.5;

      private var cy:Number = 91.5;

      private var st:Stage;

      private var down:Boolean = false;

      private var sx:Number = 0;

      private var sy:Number = 0;

      private var t0:int = 0;

      private var moved:Boolean = false;

      private var _locked:Boolean = false;

      private var lox:Number = 0;

      private var loy:Number = 0;

      public function Joystick()
      {
         super();
         this.hit = new Sprite();
         addChild(this.hit);
         this.gfx = new Sprite();
         this.gfx.mouseEnabled = false;
         this.gfx.mouseChildren = false;
         addChild(this.gfx);
         this.bgBmp = new Bitmap();
         this.handleBmp = new Bitmap();
         this.bgBmp.alpha = IDLE_ALPHA;
         this.handleBmp.alpha = IDLE_ALPHA;
         this.gfx.addChild(this.bgBmp);
         this.gfx.addChild(this.handleBmp);
         this.gfx.visible = false;
         this.outline = new Shape();
         this.outline.visible = false;
         addChild(this.outline);
         this.setZone(new Rectangle(0,0,PAD,PAD));
         JoyArt.get("bg",this.onBg);
         JoyArt.get("handle",this.onHandle);
         this.layout(0,0);
         this.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
      }

      private function onBg(param1:BitmapData) : void
      {
         if(this.bgBmp == null)
         {
            return;
         }
         this.bgBmp.bitmapData = param1;
         this.bgBmp.smoothing = true;
         this.bgBmp.width = BG;
         this.bgBmp.height = BG;
         this.layout(this.lox,this.loy);
      }

      private function onHandle(param1:BitmapData) : void
      {
         if(this.handleBmp == null)
         {
            return;
         }
         this.handleBmp.bitmapData = param1;
         this.handleBmp.smoothing = true;
         this.handleBmp.width = HANDLE;
         this.handleBmp.height = HANDLE;
         this.layout(this.lox,this.loy);
      }

      private function layout(param1:Number, param2:Number) : void
      {
         this.lox = param1;
         this.loy = param2;
         this.bgBmp.x = this.cx - BG / 2;
         this.bgBmp.y = this.cy - BG / 2;
         this.handleBmp.x = this.cx + param1 - HANDLE / 2;
         this.handleBmp.y = this.cy + param2 - HANDLE / 2;
      }

      public function setZone(param1:Rectangle) : void
      {
         this.hit.graphics.clear();
         this.hit.graphics.beginFill(0,0);
         this.hit.graphics.drawRect(param1.x,param1.y,param1.width,param1.height);
         this.hit.graphics.endFill();
         this.outline.graphics.clear();
         this.outline.graphics.lineStyle(2,15255671,1);
         this.outline.graphics.drawRect(param1.x,param1.y,param1.width,param1.height);
      }

      public function get pressed() : Boolean
      {
         return this.down;
      }

      public function set editing(param1:Boolean) : void
      {
         this._locked = param1;
         this.outline.visible = param1;
         if(param1)
         {
            this.release();
         }
         this.gfx.visible = param1;
      }

      public function release() : void
      {
         var _loc1_:Boolean = false;
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.st.removeEventListener(Event.DEACTIVATE,this.onLost);
            this.st.removeEventListener(Event.MOUSE_LEAVE,this.onLost);
            this.st = null;
         }
         _loc1_ = Boolean(this.down);
         this.down = false;
         this.cx = PAD / 2;
         this.cy = PAD / 2;
         this.layout(0,0);
         this.handleBmp.alpha = IDLE_ALPHA;
         this.gfx.visible = this._locked;
         if(_loc1_)
         {
            MoveInput.setStick(0,0);
         }
      }

      public function destroy() : void
      {
         this.release();
         this.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(Boolean(this._locked) || stage == null)
         {
            return;
         }
         this.release();
         var _loc1_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc2_:Number = BG / 2;
         this.cx = Math.max(_loc2_ - x,Math.min(960 - _loc2_ - x,_loc1_.x));
         this.cy = Math.max(_loc2_ - y,Math.min(LIMIT_Y - _loc2_ - y,_loc1_.y));
         this.sx = param1.stageX;
         this.sy = param1.stageY;
         this.t0 = getTimer();
         this.moved = false;
         this.down = true;
         this.handleBmp.alpha = PRESS_ALPHA;
         this.gfx.visible = true;
         this.layout(0,0);
         MoveInput.setStick(0,0);
         this.st = stage;
         this.st.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.st.addEventListener(Event.DEACTIVATE,this.onLost,false,0,true);
         this.st.addEventListener(Event.MOUSE_LEAVE,this.onLost,false,0,true);
      }

      private function onMove(param1:MouseEvent) : void
      {
         if(!this.down)
         {
            return;
         }
         var _loc1_:Number = param1.stageX - this.sx;
         var _loc2_:Number = param1.stageY - this.sy;
         if(_loc1_ * _loc1_ + _loc2_ * _loc2_ >= TAP_DIST_SQ)
         {
            this.moved = true;
         }
         var _loc3_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc4_:Number = _loc3_.x - this.cx;
         var _loc5_:Number = _loc3_.y - this.cy;
         var _loc6_:Number = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
         if(_loc6_ < DEAD)
         {
            this.layout(0,0);
            MoveInput.setStick(0,0);
         }
         else
         {
            this.layout(_loc4_ / _loc6_ * RIM,_loc5_ / _loc6_ * RIM);
            MoveInput.setStick(_loc4_ / _loc6_,_loc5_ / _loc6_);
         }
      }

      private function onLost(param1:Event) : void
      {
         this.release();
      }

      private function onUp(param1:MouseEvent) : void
      {
         var _loc1_:Boolean = !this.moved && getTimer() - this.t0 < TAP_MS;
         var _loc2_:Number = param1.stageX;
         var _loc3_:Number = param1.stageY;
         var _loc4_:Stage = this.st;
         this.release();
         if(_loc1_ && _loc4_ != null)
         {
            this.forwardTap(_loc4_,_loc2_,_loc3_);
         }
      }

      private function forwardTap(param1:Stage, param2:Number, param3:Number) : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:InteractiveObject = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Point = null;
         var _loc5_:Point = new Point(param2,param3);
         var _loc6_:Array = param1.getObjectsUnderPoint(_loc5_);
         var _loc7_:DisplayObjectContainer = parent;
         var _loc8_:* = int(_loc6_.length - 1);
         while(_loc8_ >= 0)
         {
            _loc1_ = _loc6_[_loc8_];
            if(!(_loc7_ != null && _loc7_.contains(_loc1_)))
            {
               _loc2_ = null;
               _loc3_ = _loc1_;
               while(_loc3_ != null && _loc3_ != param1)
               {
                  if(_loc3_ is InteractiveObject && Boolean(InteractiveObject(_loc3_).mouseEnabled))
                  {
                     if(_loc2_ == null)
                     {
                        _loc2_ = InteractiveObject(_loc3_);
                     }
                  }
                  if(_loc3_ is DisplayObjectContainer && !DisplayObjectContainer(_loc3_).mouseChildren && _loc3_ is InteractiveObject && Boolean(InteractiveObject(_loc3_).mouseEnabled))
                  {
                     _loc2_ = InteractiveObject(_loc3_);
                  }
                  _loc3_ = _loc3_.parent;
               }
               if(_loc2_ != null)
               {
                  _loc4_ = _loc2_.globalToLocal(_loc5_);
                  _loc2_.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true,false,_loc4_.x,_loc4_.y));
                  return;
               }
            }
            _loc8_--;
         }
      }
   }
}
