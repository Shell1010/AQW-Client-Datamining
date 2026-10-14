package liteAssets.mobile
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.events.*;
   import flash.utils.*;

   public class HoldPress
   {

      public static const MS:int = 350;

      private static const FILL:uint = 16763904;

      private static const FILL_A:Number = 0.45;

      private var shape:Shape;

      private var w:Number = 0;

      private var h:Number = 0;

      private var t0:int = 0;

      private var done:Function;

      public function HoldPress(param1:Shape)
      {
         super();
         this.shape = param1;
      }

      public function get active() : Boolean
      {
         return this.done != null;
      }

      public function start(param1:Number, param2:Number, param3:Function) : void
      {
         this.stop();
         this.w = param1;
         this.h = param2;
         this.done = param3;
         this.t0 = getTimer();
         this.shape.addEventListener(Event.ENTER_FRAME,this.onFrame,false,0,true);
      }

      public function stop() : void
      {
         this.shape.removeEventListener(Event.ENTER_FRAME,this.onFrame);
         this.shape.graphics.clear();
         this.done = null;
      }

      private function onFrame(param1:Event) : void
      {
         var _loc1_:Function = null;
         var _loc2_:Number = (getTimer() - this.t0) / MS;
         if(_loc2_ >= 1)
         {
            _loc1_ = this.done;
            this.stop();
            if(_loc1_ != null)
            {
               _loc1_();
            }
            return;
         }
         var _loc3_:Graphics = this.shape.graphics;
         _loc3_.clear();
         var _loc4_:Number = Math.max(0,(this.h - 4) * _loc2_);
         if(_loc4_ > 0)
         {
            _loc3_.beginFill(FILL,FILL_A);
            _loc3_.drawRoundRect(2,this.h - 2 - _loc4_,this.w - 4,_loc4_,6,6);
            _loc3_.endFill();
         }
      }
   }
}
