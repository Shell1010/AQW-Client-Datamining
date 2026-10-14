package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Rectangle;
   import flash.utils.*;

   public class ActBarTouch
   {

      private static var bar:MovieClip;

      private static var game:MovieClip;

      private static var timer:Timer;

      private static const PAD_NAME:String = "__abPad";

      private static const PITCH:Number = 45;

      private static const SLOTS:int = 6;

      private static var keys:Array = [];

      public function ActBarTouch()
      {
         super();
      }

      public static function start(param1:MovieClip) : void
      {
         var g:MovieClip = param1;
         stop();
         if(g == null || g.ui == null)
         {
            return;
         }
         game = g;
         try
         {
            bar = g.ui.mcInterface.actBar as MovieClip;
         }
         catch(e:Error)
         {
            bar = null;
         }
         if(bar == null)
         {
            return;
         }
         timer = new Timer(400);
         timer.addEventListener(TimerEvent.TIMER,onTick);
         timer.start();
         sync();
      }

      public static function stop() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:DisplayObject = null;
         if(timer != null)
         {
            timer.stop();
            timer.removeEventListener(TimerEvent.TIMER,onTick);
            timer = null;
         }
         if(bar != null)
         {
            _loc1_ = 1;
            while(_loc1_ <= SLOTS)
            {
               _loc2_ = bar.getChildByName("i" + _loc1_) as MovieClip;
               if(_loc2_ != null)
               {
                  _loc3_ = _loc2_.getChildByName(PAD_NAME);
                  if(_loc3_ != null)
                  {
                     _loc2_.removeChild(_loc3_);
                  }
               }
               _loc1_++;
            }
         }
         bar = null;
         game = null;
         keys = [];
      }

      private static function onTick(param1:TimerEvent) : void
      {
         var _loc1_:MovieClip = null;
         if(!Mobile.active)
         {
            return;
         }
         if(bar == null || bar.stage == null)
         {
            _loc1_ = null;
            try
            {
               _loc1_ = game.ui.mcInterface.actBar as MovieClip;
            }
            catch(err:Error)
            {
            }
            if(_loc1_ == null || _loc1_ == bar)
            {
               return;
            }
            bar = _loc1_;
         }
         sync();
      }

      private static function sync() : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Shape = null;
         var _loc11_:DisplayObject = null;
         var _loc12_:Rectangle = null;
         var _loc13_:int = 1;
         while(_loc13_ <= SLOTS)
         {
            _loc1_ = bar.getChildByName("i" + _loc13_) as MovieClip;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_.scaleX;
               _loc3_ = _loc1_.scaleY;
               if(!(_loc2_ == 0 || _loc3_ == 0))
               {
                  _loc4_ = _loc1_.getChildByName(PAD_NAME);
                  _loc5_ = null;
                  _loc6_ = 0;
                  while(_loc6_ < _loc1_.numChildren)
                  {
                     _loc11_ = _loc1_.getChildAt(_loc6_);
                     if(_loc11_ != _loc4_)
                     {
                        _loc12_ = _loc11_.getBounds(_loc1_);
                        if(!(_loc12_.width <= 0 || _loc12_.height <= 0))
                        {
                           _loc5_ = _loc5_ == null ? _loc12_ : _loc5_.union(_loc12_);
                        }
                     }
                     _loc6_++;
                  }
                  if(_loc5_ != null)
                  {
                     _loc7_ = _loc2_ + "," + _loc3_ + "," + _loc5_.x + "," + _loc5_.y + "," + _loc5_.width + "," + _loc5_.height;
                     if(!(_loc4_ != null && keys[_loc13_] == _loc7_))
                     {
                        keys[_loc13_] = _loc7_;
                        _loc8_ = _loc5_.width * Math.abs(_loc2_);
                        _loc9_ = Math.max(0,(PITCH - _loc8_) / 2) / Math.abs(_loc2_);
                        _loc10_ = _loc4_ as Shape;
                        if(_loc10_ == null)
                        {
                           _loc10_ = new Shape();
                           _loc10_.name = PAD_NAME;
                           _loc1_.addChildAt(_loc10_,0);
                        }
                        _loc10_.graphics.clear();
                        _loc10_.graphics.beginFill(0,0);
                        _loc10_.graphics.drawRect(_loc5_.x - _loc9_,_loc5_.y,_loc5_.width + _loc9_ * 2,_loc5_.height);
                        _loc10_.graphics.endFill();
                     }
                  }
               }
            }
            _loc13_++;
         }
      }
   }
}
