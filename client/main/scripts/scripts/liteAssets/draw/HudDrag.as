package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;

   public class HudDrag
   {

      private static const STAGE_W:int = 960;

      private static const THRESHOLD_SQ:int = 16;

      private static const CAP_H:int = 13;

      private var t:Sprite;

      private var r:MovieClip;

      private var key:String;

      private var hit:InteractiveObject;

      private var bd:Sprite;

      private var bg:Shape;

      private var cap:TextField;

      private var pad:int;

      private var boundsFn:Function;

      private var maxY:int;

      private var st:Stage;

      private var dragging:Boolean = false;

      private var dragged:Boolean = false;

      private var polling:Boolean = false;

      private var sx:Number = 0;

      private var sy:Number = 0;

      private var ox:Number = 0;

      private var oy:Number = 0;

      private var rect:Rectangle = new Rectangle();

      private var kidsOff:Boolean = false;

      private var kidsWas:Boolean = true;

      public function HudDrag(param1:Sprite, param2:MovieClip, param3:String, param4:Object = null)
      {
         super();
         if(param4 == null)
         {
            param4 = {};
         }
         this.t = param1;
         this.r = param2;
         this.key = param3;
         this.pad = param4.padding != null ? int(param4.padding) : 6;
         this.boundsFn = param4.measure as Function;
         this.maxY = param4.bottom != null ? int(param4.bottom) : 550;
         this.hit = param4.handle != null ? param4.handle as InteractiveObject : param1;
         if(param4.backdrop)
         {
            this.bd = new Sprite();
            this.bd.mouseChildren = false;
            this.bd.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
            this.bg = new Shape();
            this.bd.addChild(this.bg);
            if(param4.caption != null)
            {
               this.cap = new TextField();
               this.cap.defaultTextFormat = new TextFormat("Arial",9,15255671,true);
               this.cap.autoSize = TextFieldAutoSize.LEFT;
               this.cap.selectable = false;
               this.cap.mouseEnabled = false;
               this.cap.filters = [new GlowFilter(0,1,3,3,6,1)];
               this.cap.text = String(param4.caption);
               this.bd.addChild(this.cap);
            }
            this.t.addEventListener(MouseEvent.ROLL_OVER,this.onOver,false,0,true);
         }
         this.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         this.hit.addEventListener(MouseEvent.CLICK,this.onClickCapture,true,0,true);
         this.restore();
      }

      public function restore() : void
      {
         var _loc1_:Object = null;
         if(this.t == null)
         {
            return;
         }
         try
         {
            _loc1_ = this.r.litePreference.data[this.key];
            if(_loc1_ != null && _loc1_.x != null)
            {
               this.t.x = int(_loc1_.x);
               this.t.y = int(_loc1_.y);
            }
         }
         catch(e:Error)
         {
         }
         this.clamp();
      }

      public function reset(param1:Number, param2:Number) : void
      {
         if(this.t == null)
         {
            return;
         }
         try
         {
            this.r.litePreference.data[this.key] = null;
            this.r.litePreference.flush();
         }
         catch(e:Error)
         {
         }
         this.t.x = param1;
         this.t.y = param2;
         this.clamp();
         this.refresh();
      }

      public function refresh() : void
      {
         if(this.bd != null && this.bd.parent != null)
         {
            this.draw();
         }
      }

      public function detach() : void
      {
         this.stopPress();
         if(this.hit != null)
         {
            this.hit.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            this.hit.removeEventListener(MouseEvent.CLICK,this.onClickCapture,true);
         }
         if(this.bd != null)
         {
            this.hideBackdrop();
            this.bd.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown);
            if(this.t != null)
            {
               this.t.removeEventListener(MouseEvent.ROLL_OVER,this.onOver);
            }
            this.bd = null;
            this.bg = null;
            this.cap = null;
         }
         this.t = null;
         this.r = null;
         this.hit = null;
         this.boundsFn = null;
      }

      public function clamp() : void
      {
         if(this.t == null || this.t.parent == null)
         {
            return;
         }
         var _loc1_:Rectangle = this.bounds();
         if(_loc1_ == null || _loc1_.width <= 0 || _loc1_.height <= 0)
         {
            return;
         }
         var _loc2_:Number = 0;
         var _loc3_:Number = 0;
         if(_loc1_.right > STAGE_W)
         {
            _loc2_ = STAGE_W - _loc1_.right;
         }
         if(_loc1_.bottom > this.maxY)
         {
            _loc3_ = this.maxY - _loc1_.bottom;
         }
         if(_loc1_.left + _loc2_ < 0)
         {
            _loc2_ = -_loc1_.left;
         }
         if(_loc1_.top + _loc3_ < 0)
         {
            _loc3_ = -_loc1_.top;
         }
         this.t.x += _loc2_;
         this.t.y += _loc3_;
      }

      private function bounds() : Rectangle
      {
         return this.boundsFn != null ? this.boundsFn(this.t.parent) as Rectangle : this.t.getBounds(this.t.parent);
      }

      private function save() : void
      {
         try
         {
            this.r.litePreference.data[this.key] = {
               "x":int(this.t.x),
               "y":int(this.t.y)
            };
            this.r.litePreference.flush();
         }
         catch(e:Error)
         {
         }
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(this.t == null || this.t.stage == null)
         {
            return;
         }
         this.stopPress();
         this.st = this.t.stage;
         this.dragging = false;
         this.dragged = false;
         this.sx = param1.stageX;
         this.sy = param1.stageY;
         this.ox = this.t.x;
         this.oy = this.t.y;
         this.st.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
      }

      private function onMove(param1:MouseEvent) : void
      {
         if(this.t == null)
         {
            this.stopPress();
            return;
         }
         var _loc1_:Number = param1.stageX - this.sx;
         var _loc2_:Number = param1.stageY - this.sy;
         if(!this.dragging)
         {
            if(_loc1_ * _loc1_ + _loc2_ * _loc2_ < THRESHOLD_SQ)
            {
               return;
            }
            this.dragging = true;
            this.kidsWas = this.t.mouseChildren;
            this.kidsOff = true;
            this.t.mouseChildren = false;
            if(this.r != null && this.r.ui != null && this.r.ui.ToolTip != null)
            {
               this.r.ui.ToolTip.close();
            }
         }
         this.t.x = Math.round(this.ox + _loc1_);
         this.t.y = Math.round(this.oy + _loc2_);
         this.clamp();
         this.refresh();
         param1.updateAfterEvent();
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.stopPress();
         if(this.dragging)
         {
            this.dragging = false;
            this.dragged = true;
            this.save();
         }
      }

      private function stopPress() : void
      {
         if(this.kidsOff)
         {
            this.kidsOff = false;
            if(this.t != null)
            {
               this.t.mouseChildren = this.kidsWas;
            }
         }
         if(this.st != null)
         {
            this.st.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
            this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
            this.st = null;
         }
      }

      private function onClickCapture(param1:MouseEvent) : void
      {
         if(!this.dragged)
         {
            return;
         }
         this.dragged = false;
         param1.stopImmediatePropagation();
      }

      private function onOver(param1:MouseEvent) : void
      {
         if(this.bd == null || this.t == null || this.t.parent == null || !this.t.visible)
         {
            return;
         }
         var _loc1_:DisplayObjectContainer = this.t.parent;
         if(this.bd.parent != null)
         {
            this.bd.parent.removeChild(this.bd);
         }
         _loc1_.addChildAt(this.bd,_loc1_.getChildIndex(this.t));
         this.draw();
         if(!this.polling)
         {
            this.polling = true;
            this.bd.addEventListener(Event.ENTER_FRAME,this.onPoll,false,0,true);
         }
      }

      private function onPoll(param1:Event) : void
      {
         if(this.t == null || this.t.stage == null || this.t.parent == null || !this.t.visible)
         {
            this.hideBackdrop();
            return;
         }
         if(this.st != null)
         {
            return;
         }
         if(!this.rect.contains(this.t.parent.mouseX,this.t.parent.mouseY))
         {
            this.hideBackdrop();
         }
      }

      private function hideBackdrop() : void
      {
         if(this.bd == null)
         {
            return;
         }
         if(this.polling)
         {
            this.polling = false;
            this.bd.removeEventListener(Event.ENTER_FRAME,this.onPoll);
         }
         this.bg.graphics.clear();
         if(this.bd.parent != null)
         {
            this.bd.parent.removeChild(this.bd);
         }
      }

      private function draw() : void
      {
         var _loc1_:Rectangle = this.bounds();
         var _loc2_:Graphics = this.bg.graphics;
         _loc2_.clear();
         if(_loc1_ == null || _loc1_.width <= 0 || _loc1_.height <= 0)
         {
            this.rect.setEmpty();
            if(this.cap != null)
            {
               this.cap.visible = false;
            }
            return;
         }
         var _loc3_:int = this.cap != null ? int(CAP_H) : 0;
         this.rect.x = _loc1_.x - this.pad;
         this.rect.y = _loc1_.y - this.pad - _loc3_;
         this.rect.width = _loc1_.width + this.pad * 2;
         this.rect.height = _loc1_.height + this.pad * 2 + _loc3_;
         _loc2_.beginFill(0,0.5);
         _loc2_.drawRoundRect(this.rect.x,this.rect.y,this.rect.width,this.rect.height,10,10);
         _loc2_.endFill();
         if(this.cap != null)
         {
            this.cap.visible = true;
            this.cap.x = this.rect.x + 4;
            this.cap.y = this.rect.y + 2;
         }
      }
   }
}
