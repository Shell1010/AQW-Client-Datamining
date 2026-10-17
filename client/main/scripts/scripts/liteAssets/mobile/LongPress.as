package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;

   public class LongPress
   {

      private static var game:MovieClip;

      private static var stage:Stage;

      private static var ui:DisplayObject;

      private static var timer:Timer;

      private static var target:DisplayObject;

      private static var tapped:DisplayObject;

      private static const HOLD_MS:int = 500;

      private static const MOVE_DIST_SQ:int = 100;

      private static const WALK_AREA:String = "btnWalkingArea";

      private static var down:Boolean = false;

      private static var fired:Boolean = false;

      private static var eating:Boolean = false;

      private static var sx:Number = 0;

      private static var sy:Number = 0;

      private static var skipped:Dictionary = new Dictionary(true);

      public function LongPress()
      {
         super();
      }

      public static function skip(param1:DisplayObject) : void
      {
         if(param1 != null)
         {
            skipped[param1] = true;
         }
      }

      public static function start(param1:MovieClip) : void
      {
         stop();
         if(param1 == null || param1.stage == null || param1.ui == null)
         {
            return;
         }
         game = param1;
         stage = param1.stage;
         ui = param1.ui;
         stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown,true,0,true);
      }

      public static function stop() : void
      {
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onDown,true);
            stage.removeEventListener(MouseEvent.CLICK,eat,true);
            stage.removeEventListener(Event.ENTER_FRAME,stopEatFrame);
            stage.removeEventListener(Event.ENTER_FRAME,onTapOut);
         }
         tapped = null;
         if(fired)
         {
            hover(target,false);
         }
         endTrack();
         eating = false;
         stage = null;
         game = null;
         ui = null;
      }

      private static function inUi(param1:DisplayObject) : Boolean
      {
         var _loc1_:Boolean = false;
         var _loc2_:DisplayObject = param1;
         while(_loc2_ != null)
         {
            if(_loc2_.name == WALK_AREA || _loc2_ is MobileHUD || Boolean(skipped[_loc2_]))
            {
               return false;
            }
            if(_loc2_ == ui)
            {
               _loc1_ = true;
            }
            _loc2_ = _loc2_.parent;
         }
         return _loc1_;
      }

      private static function onDown(param1:MouseEvent) : void
      {
         if(Boolean(down) || !Mobile.active)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.target as DisplayObject;
         if(_loc1_ == null || !inUi(_loc1_))
         {
            return;
         }
         target = _loc1_;
         down = true;
         fired = false;
         sx = param1.stageX;
         sy = param1.stageY;
         if(timer == null)
         {
            timer = new Timer(HOLD_MS,1);
            timer.addEventListener(TimerEvent.TIMER_COMPLETE,onFire);
         }
         timer.reset();
         timer.start();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
         stage.addEventListener(Event.DEACTIVATE,onDeactivate,false,0,true);
      }

      private static function onMove(param1:MouseEvent) : void
      {
         if(!down || Boolean(fired))
         {
            return;
         }
         var _loc1_:Number = param1.stageX - sx;
         var _loc2_:Number = param1.stageY - sy;
         if(_loc1_ * _loc1_ + _loc2_ * _loc2_ >= MOVE_DIST_SQ || Boolean(TouchScroll.dragging))
         {
            endTrack();
         }
      }

      private static function onFire(param1:TimerEvent) : void
      {
         if(!down || Boolean(fired))
         {
            return;
         }
         if(!Mobile.active || Boolean(TouchScroll.dragging) || target == null || target.stage == null)
         {
            endTrack();
            return;
         }
         fired = true;
         hover(target,true);
      }

      private static function onUp(param1:MouseEvent) : void
      {
         if(!down)
         {
            return;
         }
         var _loc1_:Boolean = Boolean(fired);
         var _loc2_:Stage = stage;
         var _loc3_:DisplayObject = target;
         if(_loc1_)
         {
            hover(_loc3_,false);
         }
         endTrack();
         if(!_loc1_)
         {
            if(!inBar(_loc3_))
            {
               return;
            }
            tapped = _loc3_;
            _loc2_.addEventListener(Event.ENTER_FRAME,onTapOut,false,0,true);
            return;
         }
         eating = true;
         _loc2_.addEventListener(MouseEvent.CLICK,eat,true,int.MAX_VALUE,true);
         _loc2_.addEventListener(Event.ENTER_FRAME,stopEatFrame,false,0,true);
      }

      private static function onDeactivate(param1:Event) : void
      {
         if(fired)
         {
            hover(target,false);
         }
         endTrack();
      }

      private static function inBar(param1:DisplayObject) : Boolean
      {
         var _loc1_:DisplayObject = null;
         try
         {
            _loc1_ = game.ui.mcInterface as DisplayObject;
         }
         catch(err:Error)
         {
         }
         var _loc2_:DisplayObject = param1;
         while(_loc1_ != null && _loc2_ != null)
         {
            if(_loc2_ == _loc1_)
            {
               return true;
            }
            _loc2_ = _loc2_.parent;
         }
         return false;
      }

      private static function onTapOut(param1:Event) : void
      {
         param1.currentTarget.removeEventListener(Event.ENTER_FRAME,onTapOut);
         var _loc1_:DisplayObject = tapped;
         tapped = null;
         if(_loc1_ != null && _loc1_.stage != null && !down)
         {
            hover(_loc1_,false);
         }
      }

      private static function hover(param1:DisplayObject, param2:Boolean) : void
      {
         var _loc1_:* = 0;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:Array = [];
         var _loc3_:DisplayObject = param1;
         while(_loc3_ != null)
         {
            _loc2_.push(_loc3_);
            if(_loc3_ == ui)
            {
               break;
            }
            _loc3_ = _loc3_.parent;
         }
         var _loc4_:String = param2 ? MouseEvent.ROLL_OVER : MouseEvent.ROLL_OUT;
         var _loc5_:String = param2 ? MouseEvent.MOUSE_OVER : MouseEvent.MOUSE_OUT;
         if(param2)
         {
            _loc1_ = int(_loc2_.length - 1);
            while(_loc1_ >= 0)
            {
               fire(_loc2_[_loc1_],_loc4_,_loc5_);
               _loc1_--;
            }
         }
         else
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_.length)
            {
               fire(_loc2_[_loc1_],_loc4_,_loc5_);
               _loc1_++;
            }
         }
      }

      private static function fire(param1:DisplayObject, param2:String, param3:String) : void
      {
         try
         {
            param1.dispatchEvent(new MouseEvent(param2,false,false,param1.mouseX,param1.mouseY));
            param1.dispatchEvent(new MouseEvent(param3,false,false,param1.mouseX,param1.mouseY));
         }
         catch(err:Error)
         {
         }
      }

      private static function eat(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         stopEat();
      }

      private static function stopEatFrame(param1:Event) : void
      {
         stopEat();
      }

      private static function stopEat() : void
      {
         if(!eating)
         {
            return;
         }
         eating = false;
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.CLICK,eat,true);
         stage.removeEventListener(Event.ENTER_FRAME,stopEatFrame);
      }

      private static function endTrack() : void
      {
         down = false;
         fired = false;
         target = null;
         if(timer != null)
         {
            timer.stop();
         }
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
         stage.removeEventListener(Event.DEACTIVATE,onDeactivate);
      }
   }
}
