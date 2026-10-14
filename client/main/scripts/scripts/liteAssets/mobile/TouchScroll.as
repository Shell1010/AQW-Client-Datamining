package liteAssets.mobile
{
   import flash.display.InteractiveObject;
   import flash.display.Stage;
   import flash.events.*;
   import flash.utils.*;

   public class TouchScroll
   {

      private static const THRESHOLD:Number = 8;

      private static const SAMPLE_MS:int = 100;

      private static const FLING_MIN:Number = 0.3;

      private static const FLING_STOP:Number = 0.05;

      private static const DECAY:Number = 0.94;

      private static var _dragging:Boolean = false;

      private var area:InteractiveObject;

      private var getPos:Function;

      private var setPos:Function;

      private var getMax:Function;

      private var horizontal:Boolean;

      private var st:Stage;

      private var down:Boolean = false;

      private var moved:Boolean = false;

      private var startStage:Number = 0;

      private var startPos:Number = 0;

      private var samples:Array = [];

      private var velocity:Number = 0;

      private var lastT:int = 0;

      private var flinging:Boolean = false;

      private var eating:Boolean = false;

      public function TouchScroll()
      {
         super();
      }

      public static function attach(param1:InteractiveObject, param2:Function, param3:Function, param4:Function, param5:Boolean = false) : TouchScroll
      {
         var _loc1_:TouchScroll = new TouchScroll();
         _loc1_.area = param1;
         _loc1_.getPos = param2;
         _loc1_.setPos = param3;
         _loc1_.getMax = param4;
         _loc1_.horizontal = param5;
         param1.addEventListener(MouseEvent.MOUSE_DOWN,_loc1_.onDown,true,0,true);
         return _loc1_;
      }

      public static function get dragging() : Boolean
      {
         return _dragging;
      }

      public function detach() : void
      {
         if(this.area != null)
         {
            this.area.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDown,true);
         }
         this.endTrack();
         this.stopFling();
         this.stopEat();
         if(this.moved)
         {
            _dragging = false;
         }
         this.moved = false;
         this.area = null;
      }

      private function axis(param1:MouseEvent) : Number
      {
         return this.horizontal ? param1.stageX : param1.stageY;
      }

      private function onDown(param1:MouseEvent) : void
      {
         if(!Mobile.active || this.area == null)
         {
            return;
         }
         this.stopFling();
         this.stopEat();
         this.endTrack();
         this.st = this.area.stage;
         if(this.st == null)
         {
            return;
         }
         this.down = true;
         this.moved = false;
         this.startStage = this.axis(param1);
         this.startPos = Number(this.getPos());
         this.samples.length = 0;
         this.st.addEventListener(MouseEvent.MOUSE_MOVE,this.onMove,false,0,true);
         this.st.addEventListener(MouseEvent.MOUSE_UP,this.onUp,false,0,true);
         this.st.addEventListener(Event.DEACTIVATE,this.onAbort,false,0,true);
         this.st.addEventListener(Event.MOUSE_LEAVE,this.onAbort,false,0,true);
      }

      private function onMove(param1:MouseEvent) : void
      {
         if(!this.down)
         {
            return;
         }
         var _loc1_:Number = Number(this.axis(param1));
         var _loc2_:Number = this.startStage - _loc1_;
         if(!this.moved)
         {
            if(Math.abs(_loc2_) < THRESHOLD)
            {
               return;
            }
            this.moved = true;
            _dragging = true;
         }
         var _loc3_:Number = Number(this.getMax());
         this.setPos(Math.max(0,Math.min(_loc3_,this.startPos + _loc2_)));
         var _loc4_:int = int(getTimer());
         this.samples.push(_loc4_,_loc1_);
         while(this.samples.length > 2 && _loc4_ - int(this.samples[0]) > SAMPLE_MS)
         {
            this.samples.splice(0,2);
         }
      }

      private function onUp(param1:MouseEvent) : void
      {
         var _loc1_:Number = NaN;
         if(!this.down)
         {
            return;
         }
         var _loc2_:int = int(getTimer());
         var _loc3_:Stage = this.st;
         this.endTrack();
         if(!this.moved)
         {
            return;
         }
         _dragging = false;
         this.moved = false;
         this.eating = true;
         _loc3_.addEventListener(MouseEvent.CLICK,this.eat,true,int.MAX_VALUE,true);
         _loc3_.addEventListener(Event.ENTER_FRAME,this.stopEatFrame,false,0,true);
         var _loc4_:int = int(this.samples.length);
         this.velocity = 0;
         if(_loc4_ >= 4 && _loc2_ - int(this.samples[_loc4_ - 2]) <= SAMPLE_MS)
         {
            _loc1_ = int(this.samples[_loc4_ - 2]) - int(this.samples[0]);
            if(_loc1_ > 0)
            {
               this.velocity = (Number(this.samples[0 + 1]) - Number(this.samples[_loc4_ - 1])) / _loc1_;
            }
         }
         if(Math.abs(this.velocity) > FLING_MIN)
         {
            this.lastT = _loc2_;
            this.flinging = true;
            _loc3_.addEventListener(Event.ENTER_FRAME,this.onFling,false,0,true);
         }
      }

      private function onFling(param1:Event) : void
      {
         if(this.area == null)
         {
            this.stopFling();
            return;
         }
         var _loc1_:int = int(getTimer());
         var _loc2_:Number = _loc1_ - this.lastT;
         this.lastT = _loc1_;
         var _loc3_:Number = Number(this.getMax());
         var _loc4_:Number = Number(this.getPos()) + this.velocity * _loc2_;
         var _loc5_:Boolean = false;
         if(_loc4_ <= 0)
         {
            _loc4_ = 0;
            _loc5_ = true;
         }
         else if(_loc4_ >= _loc3_)
         {
            _loc4_ = _loc3_;
            _loc5_ = true;
         }
         this.setPos(_loc4_);
         this.velocity *= Math.pow(DECAY,_loc2_ / 33);
         if(_loc5_ || Math.abs(this.velocity) < FLING_STOP)
         {
            this.stopFling();
         }
      }

      private function eat(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.stopEat();
      }

      private function stopEatFrame(param1:Event) : void
      {
         this.stopEat();
      }

      private function stopEat() : void
      {
         if(!this.eating)
         {
            return;
         }
         this.eating = false;
         var _loc1_:Stage = this.area != null && this.area.stage != null ? this.area.stage : this.st;
         if(_loc1_ == null)
         {
            return;
         }
         _loc1_.removeEventListener(MouseEvent.CLICK,this.eat,true);
         _loc1_.removeEventListener(Event.ENTER_FRAME,this.stopEatFrame);
      }

      private function stopFling() : void
      {
         if(!this.flinging)
         {
            return;
         }
         this.flinging = false;
         var _loc1_:Stage = this.area != null && this.area.stage != null ? this.area.stage : this.st;
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.ENTER_FRAME,this.onFling);
         }
      }

      private function onAbort(param1:Event) : void
      {
         if(!this.down)
         {
            return;
         }
         var _loc1_:Stage = this.st;
         this.endTrack();
         if(this.moved)
         {
            _dragging = false;
            this.moved = false;
         }
         if(_loc1_ != null)
         {
            _loc1_.removeEventListener(Event.ENTER_FRAME,this.onFling);
         }
      }

      private function endTrack() : void
      {
         this.down = false;
         if(this.st == null)
         {
            return;
         }
         this.st.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMove);
         this.st.removeEventListener(MouseEvent.MOUSE_UP,this.onUp);
         this.st.removeEventListener(Event.DEACTIVATE,this.onAbort);
         this.st.removeEventListener(Event.MOUSE_LEAVE,this.onAbort);
      }
   }
}
