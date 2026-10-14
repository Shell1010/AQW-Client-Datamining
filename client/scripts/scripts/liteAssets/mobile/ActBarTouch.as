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
         var _loc2_:MovieClip = null;
         if(!Mobile.active)
         {
            return;
         }
         if(bar == null || bar.stage == null)
         {
            _loc2_ = null;
            try
            {
               _loc2_ = game.ui.mcInterface.actBar as MovieClip;
            }
            catch(err:Error)
            {
            }
            if(_loc2_ == null || _loc2_ == bar)
            {
               return;
            }
            bar = _loc2_;
         }
         sync();
      }

      private static function sync() : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:DisplayObject = null;
         var _loc6_:Rectangle = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Shape = null;
         var _loc12_:DisplayObject = null;
         var _loc13_:Rectangle = null;
         var _loc1_:int = 1;
         while(_loc1_ <= SLOTS)
         {
            _loc2_ = bar.getChildByName("i" + _loc1_) as MovieClip;
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.scaleX;
               _loc4_ = _loc2_.scaleY;
               if(!(_loc3_ == 0 || _loc4_ == 0))
               {
                  _loc5_ = _loc2_.getChildByName(PAD_NAME);
                  _loc6_ = null;
                  _loc7_ = 0;
                  while(_loc7_ < _loc2_.numChildren)
                  {
                     _loc12_ = _loc2_.getChildAt(_loc7_);
                     if(_loc12_ != _loc5_)
                     {
                        _loc13_ = _loc12_.getBounds(_loc2_);
                        if(!(_loc13_.width <= 0 || _loc13_.height <= 0))
                        {
                           _loc6_ = _loc6_ == null ? _loc13_ : _loc6_.union(_loc13_);
                        }
                     }
                     _loc7_++;
                  }
                  if(_loc6_ != null)
                  {
                     _loc8_ = _loc3_ + "," + _loc4_ + "," + _loc6_.x + "," + _loc6_.y + "," + _loc6_.width + "," + _loc6_.height;
                     if(!(_loc5_ != null && keys[_loc1_] == _loc8_))
                     {
                        keys[_loc1_] = _loc8_;
                        _loc9_ = _loc6_.width * Math.abs(_loc3_);
                        _loc10_ = Math.max(0,(PITCH - _loc9_) / 2) / Math.abs(_loc3_);
                        _loc11_ = _loc5_ as Shape;
                        if(_loc11_ == null)
                        {
                           _loc11_ = new Shape();
                           _loc11_.name = PAD_NAME;
                           _loc2_.addChildAt(_loc11_,0);
                        }
                        _loc11_.graphics.clear();
                        _loc11_.graphics.beginFill(0,0);
                        _loc11_.graphics.drawRect(_loc6_.x - _loc10_,_loc6_.y,_loc6_.width + _loc10_ * 2,_loc6_.height);
                        _loc11_.graphics.endFill();
                     }
                  }
               }
            }
            _loc1_++;
         }
      }
   }
}
