package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;

   public class HoldRun
   {

      private static var game:MovieClip;

      private static var stage:Stage;

      private static var mapName:String;

      private static var mapAvatar:Object;

      private static const HOLD_MS:int = 200;

      private static const HOLD_DIST_SQ:int = 100;

      private static const NEAR_SQ:int = 64;

      private static const RESUME_SQ:int = 256;

      private static const WALK_AREA:String = "btnWalkingArea";

      private static var on:Boolean = false;

      private static var down:Boolean = false;

      private static var holding:Boolean = false;

      private static var own:Boolean = false;

      private static var eating:Boolean = false;

      private static var sx:Number = 0;

      private static var sy:Number = 0;

      private static var fx:Number = 0;

      private static var fy:Number = 0;

      private static var t0:int = 0;

      private static var runSet:Boolean = false;

      private static var runMoving:Boolean = false;

      public function HoldRun()
      {
         super();
      }

      public static function start(param1:MovieClip) : void
      {
         stop();
         if(param1 == null || param1.stage == null)
         {
            return;
         }
         game = param1;
         stage = param1.stage;
         on = true;
         stage.addEventListener(MouseEvent.MOUSE_DOWN,onDown,true,0,true);
      }

      public static function stop() : void
      {
         if(stage != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_DOWN,onDown,true);
            stage.removeEventListener(MouseEvent.CLICK,eat,true);
         }
         endTrack();
         eating = false;
         on = false;
         stage = null;
         game = null;
      }

      private static function isWalkArea(param1:DisplayObject) : Boolean
      {
         var _loc1_:DisplayObject = param1;
         while(_loc1_ != null)
         {
            if(_loc1_.name == WALK_AREA)
            {
               return true;
            }
            _loc1_ = _loc1_.parent;
         }
         return false;
      }

      private static function onOwnAvatar(param1:DisplayObject) : Boolean
      {
         var _loc1_:DisplayObjectContainer = null;
         try
         {
            _loc1_ = game.world.myAvatar.pMC as DisplayObjectContainer;
            return _loc1_ != null && (param1 == _loc1_ || _loc1_.contains(param1));
         }
         catch(e:Error)
         {
         }
         return false;
      }

      private static function blocked() : Boolean
      {
         var ui:MovieClip = null;
         var p:MovieClip = null;
         var w:* = undefined;
         try
         {
            ui = game.ui;
            p = ui.mcPopup;
            if(p != null && p.visible && p.currentFrame > 1 && p.currentLabel != "Idle")
            {
               return true;
            }
            if(ui.ModalStack != null && ui.ModalStack.numChildren > 0)
            {
               return true;
            }
            if(stage.focus is TextField)
            {
               return true;
            }
            w = game.world;
            if(w == null || w.bitWalk == false || w.myAvatar == null || w.myAvatar.pMC == null)
            {
               return true;
            }
         }
         catch(e:Error)
         {
            return true;
         }
         return false;
      }

      private static function onDown(param1:MouseEvent) : void
      {
         if(!on || Boolean(down) || !Mobile.active)
         {
            return;
         }
         var _loc1_:DisplayObject = DisplayObject(param1.target);
         var _loc2_:Boolean = false;
         if(!isWalkArea(_loc1_))
         {
            if(!onOwnAvatar(_loc1_))
            {
               return;
            }
            _loc2_ = true;
         }
         if(blocked())
         {
            return;
         }
         var _loc3_:Object = game.world;
         mapName = _loc3_.strMapName;
         mapAvatar = _loc3_.myAvatar.pMC;
         down = true;
         holding = false;
         own = _loc2_;
         sx = param1.stageX;
         sy = param1.stageY;
         fx = sx;
         fy = sy;
         t0 = getTimer();
         stage.addEventListener(MouseEvent.MOUSE_MOVE,onMove,false,0,true);
         stage.addEventListener(MouseEvent.MOUSE_UP,onUp,false,0,true);
         stage.addEventListener(Event.ENTER_FRAME,onFrame,false,0,true);
         stage.addEventListener(Event.DEACTIVATE,onDeactivate,false,0,true);
      }

      private static function onMove(param1:MouseEvent) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         if(!down)
         {
            return;
         }
         fx = param1.stageX;
         fy = param1.stageY;
         if(!holding)
         {
            _loc1_ = fx - sx;
            _loc2_ = fy - sy;
            if(_loc1_ * _loc1_ + _loc2_ * _loc2_ < HOLD_DIST_SQ)
            {
               return;
            }
            if(!valid())
            {
               endTrack();
               return;
            }
            holding = true;
            runMoving = true;
         }
      }

      private static function onFrame(param1:Event) : void
      {
         if(!down)
         {
            return;
         }
         if(!valid())
         {
            endTrack();
            return;
         }
         if(!holding)
         {
            if(Boolean(own) || getTimer() - t0 < HOLD_MS)
            {
               return;
            }
            holding = true;
            runMoving = true;
         }
         steerToFinger();
      }

      private static function onUp(param1:MouseEvent) : void
      {
         if(!down)
         {
            return;
         }
         var _loc1_:Boolean = Boolean(holding);
         var _loc2_:Stage = stage;
         endTrack();
         if(!_loc1_)
         {
            return;
         }
         eating = true;
         _loc2_.addEventListener(MouseEvent.CLICK,eat,true,int.MAX_VALUE,true);
         _loc2_.addEventListener(Event.ENTER_FRAME,stopEatFrame,false,0,true);
      }

      private static function onDeactivate(param1:Event) : void
      {
         endTrack();
      }

      private static function valid() : Boolean
      {
         if(!Mobile.active || Boolean(blocked()))
         {
            return false;
         }
         var _loc1_:Object = game.world;
         return _loc1_.strMapName == mapName && _loc1_.myAvatar.pMC == mapAvatar;
      }

      private static function steerToFinger() : void
      {
         var _loc1_:Object = game.world;
         var _loc2_:Point = _loc1_.CHARS.localToGlobal(new Point(_loc1_.myAvatar.pMC.x,_loc1_.myAvatar.pMC.y));
         var _loc3_:Number = fx - _loc2_.x;
         var _loc4_:Number = fy - _loc2_.y;
         var _loc5_:Number = _loc3_ * _loc3_ + _loc4_ * _loc4_;
         if(_loc5_ <= NEAR_SQ)
         {
            runMoving = false;
         }
         else if(_loc5_ >= RESUME_SQ)
         {
            runMoving = true;
         }
         runSet = true;
         if(runMoving)
         {
            MoveInput.setRun(true,_loc3_,_loc4_);
         }
         else
         {
            MoveInput.setRun(true,0,0);
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
         holding = false;
         own = false;
         runMoving = false;
         if(runSet)
         {
            runSet = false;
            MoveInput.setRun(false);
         }
         if(stage == null)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,onUp);
         stage.removeEventListener(Event.ENTER_FRAME,onFrame);
         stage.removeEventListener(Event.DEACTIVATE,onDeactivate);
      }
   }
}
