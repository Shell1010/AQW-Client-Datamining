package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;

   public class TouchSlider extends Sprite
   {

      public static const TRACK_W:Number = 190;

      public static const TRACK_H:Number = 8;

      public static const THUMB:Number = 20;

      private var hit:Sprite = new Sprite();

      private var track:Shape = new Shape();

      private var fill:Shape = new Shape();

      private var thumb:Sprite = new Sprite();

      private var val:Number = 0;

      private var dragging:Boolean = false;

      public function TouchSlider()
      {
         super();
         var _loc1_:Number = Mobile.active ? Number(Mobile.touchPx(9)) : 24;
         this.hit.graphics.beginFill(0,0);
         this.hit.graphics.drawRect(-THUMB / 2,-_loc1_ / 2,TRACK_W + THUMB,_loc1_);
         this.hit.graphics.endFill();
         this.drawTrack();
         this.thumb.mouseEnabled = false;
         this.thumb.mouseChildren = false;
         this.buildThumb();
         this.thumb.filters = [new DropShadowFilter(1,90,0,0.6,3,3,1,1)];
         addChild(this.hit);
         addChild(this.track);
         addChild(this.fill);
         addChild(this.thumb);
         buttonMode = true;
         useHandCursor = true;
         addEventListener(MouseEvent.MOUSE_DOWN,this.onDown,false,0,true);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved,false,0,true);
         this.redraw();
      }

      private function drawTrack() : void
      {
         var _loc1_:Graphics = this.track.graphics;
         _loc1_.lineStyle(1,3815994,1,true);
         _loc1_.beginFill(855309,1);
         _loc1_.drawRoundRect(0,-TRACK_H / 2,TRACK_W,TRACK_H,TRACK_H,TRACK_H);
         _loc1_.endFill();
         this.track.filters = [new DropShadowFilter(1,90,0,0.6,2,2,1,1,true)];
      }

      private function buildThumb() : void
      {
         var r:Number;
         var g:Graphics;
         var outer:Matrix;
         var inner:Matrix;
         var knob:DisplayObject = null;
         var q:* = undefined;
         var kb:Rectangle = null;
         knob = null;
         try
         {
            q = new LPFFrameQtySelector();
            knob = q.handle;
         }
         catch(e:Error)
         {
            knob = null;
         }
         if(knob != null && knob.width > 0 && knob.height > 0)
         {
            kb = knob.getBounds(knob);
            if(kb.height < 14 || kb.height > 30)
            {
               knob.scaleX = knob.scaleY = 22 / kb.height;
            }
            this.thumb.addChild(knob);
            if(knob is MovieClip)
            {
               MovieClip(knob).stop();
               MovieClip(knob).mouseEnabled = false;
               MovieClip(knob).mouseChildren = false;
            }
            knob.x = Math.round(-(kb.x + kb.width / 2) * knob.scaleX);
            knob.y = Math.round(-(kb.y + kb.height / 2) * knob.scaleY);
            return;
         }
         r = THUMB / 2;
         g = this.thumb.graphics;
         outer = new Matrix();
         outer.createGradientBox(THUMB,THUMB,Math.PI / 2,-r,-r);
         g.lineStyle(1,9071162,1,true);
         g.beginGradientFill(GradientType.LINEAR,[16048765,11958807],[1,1],[0,255],outer);
         g.drawCircle(0,0,r - 0.5);
         g.endFill();
         inner = new Matrix();
         inner.createGradientBox(10,10,Math.PI / 2,-5,-5);
         g.lineStyle();
         g.beginGradientFill(GradientType.LINEAR,[11958807,16048765],[1,1],[0,255],inner);
         g.drawCircle(0,0,5);
         g.endFill();
      }

      public function get value() : Number
      {
         return this.val;
      }

      public function set value(param1:Number) : void
      {
         this.val = this.clamp(param1);
         this.redraw();
      }

      private function clamp(param1:Number) : Number
      {
         return Math.max(0,Math.min(100,Math.round(param1)));
      }

      private function redraw() : void
      {
         var _loc1_:Matrix = null;
         var _loc2_:Number = Math.round(TRACK_W * this.val / 100);
         var _loc3_:Graphics = this.fill.graphics;
         _loc3_.clear();
         if(_loc2_ > 0)
         {
            _loc1_ = new Matrix();
            _loc1_.createGradientBox(_loc2_,TRACK_H,Math.PI / 2,0,-TRACK_H / 2);
            _loc3_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc1_);
            _loc3_.drawRoundRect(0,-TRACK_H / 2,_loc2_,TRACK_H,TRACK_H,TRACK_H);
            _loc3_.endFill();
            if(_loc2_ > 6)
            {
               _loc3_.beginFill(13145646,0.85);
               _loc3_.drawRect(3,-TRACK_H / 2 + 1,_loc2_ - 6,1);
               _loc3_.endFill();
            }
         }
         this.thumb.x = _loc2_;
      }

      private function setFromStage(param1:Number, param2:Number) : void
      {
         var _loc1_:Point = globalToLocal(new Point(param1,param2));
         var _loc2_:Number = Number(this.clamp(_loc1_.x / TRACK_W * 100));
         if(_loc2_ == this.val)
         {
            return;
         }
         this.val = _loc2_;
         this.redraw();
         dispatchEvent(new Event(Event.CHANGE));
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(stage == null)
         {
            return;
         }
         this.endDrag();
         this.dragging = true;
         this.thumb.scaleX = this.thumb.scaleY = 1.1;
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.setFromStage(param1.stageX,param1.stageY);
      }

      private function onMove(param1:MouseEvent) : void
      {
         this.setFromStage(param1.stageX,param1.stageY);
      }

      private function onUp(param1:MouseEvent) : void
      {
         this.setFromStage(param1.stageX,param1.stageY);
         this.endDrag();
         dispatchEvent(new Event(Event.COMPLETE));
      }

      private function endDrag() : void
      {
         this.dragging = false;
         this.thumb.scaleX = this.thumb.scaleY = 1;
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
      }

      private function onWheel(param1:MouseEvent) : void
      {
         if(param1.delta == 0)
         {
            return;
         }
         var _loc1_:Number = Number(this.clamp(this.val + (param1.delta > 0 ? 5 : -5)));
         if(_loc1_ == this.val)
         {
            return;
         }
         this.val = _loc1_;
         this.redraw();
         dispatchEvent(new Event(Event.CHANGE));
         dispatchEvent(new Event(Event.COMPLETE));
      }

      private function onRemoved(param1:Event) : void
      {
         if(this.dragging)
         {
            this.endDrag();
         }
      }
   }
}
