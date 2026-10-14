package liteAssets.mobile
{
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;

   public class TouchTargets
   {

      private static const NAME:String = "__touchPad";

      private static const origs:Dictionary = new Dictionary(true);

      public function TouchTargets()
      {
         super();
      }

      public static function pad(param1:InteractiveObject, param2:Number = 0, param3:Number = 0, param4:Rectangle = null) : void
      {
         if(!Mobile.active || param1 == null)
         {
            return;
         }
         if(param2 <= 0)
         {
            param2 = Number(phys(param1.scaleX));
         }
         if(param3 <= 0)
         {
            param3 = Number(phys(param1.scaleY));
         }
         if(param1 is SimpleButton)
         {
            padButton(param1 as SimpleButton,param2,param3,param4);
            return;
         }
         var _loc1_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:DisplayObject = _loc1_.getChildByName(NAME);
         if(_loc2_ != null)
         {
            _loc1_.removeChild(_loc2_);
         }
         var _loc3_:Rectangle = area(param1,_loc1_.getBounds(_loc1_),param2,param3,param4);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:Shape = new Shape();
         _loc4_.name = NAME;
         _loc4_.graphics.beginFill(0,0);
         _loc4_.graphics.drawRect(_loc3_.x,_loc3_.y,_loc3_.width,_loc3_.height);
         _loc4_.graphics.endFill();
         _loc1_.addChildAt(_loc4_,0);
      }

      public static function unpad(param1:InteractiveObject) : void
      {
         var _loc5_:SimpleButton = null;
         var _loc1_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         if(param1 is SimpleButton)
         {
            _loc5_ = param1 as SimpleButton;
            _loc1_ = origs[_loc5_] as DisplayObject;
            if(_loc1_ != null)
            {
               _loc5_.hitTestState = _loc1_;
               delete origs[_loc5_];
            }
            return;
         }
         var _loc6_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc6_ == null)
         {
            return;
         }
         var _loc7_:DisplayObject = _loc6_.getChildByName(NAME);
         if(_loc7_ != null)
         {
            _loc6_.removeChild(_loc7_);
         }
      }

      private static function phys(param1:Number) : Number
      {
         param1 = Math.abs(param1);
         return Mobile.touchPx(9) / (param1 > 0 ? param1 : 1);
      }

      private static function area(param1:DisplayObject, param2:Rectangle, param3:Number, param4:Number, param5:Rectangle) : Rectangle
      {
         if(param2.width <= 0 || param2.height <= 0)
         {
            return null;
         }
         var _loc2_:Number = Math.max(param2.width,param3);
         var _loc3_:Number = Math.max(param2.height,param4);
         var _loc4_:Rectangle = new Rectangle(param2.x - (_loc2_ - param2.width) / 2,param2.y - (_loc3_ - param2.height) / 2,_loc2_,_loc3_);
         if(param5 == null)
         {
            return _loc4_;
         }
         var _loc8_:Rectangle = toLocal(param1,param5);
         _loc4_.x = Math.max(Math.min(_loc4_.x,_loc8_.right - _loc4_.width),_loc8_.x);
         _loc4_.x = Math.max(Math.min(_loc4_.x,param2.x),param2.right - _loc4_.width);
         _loc4_.y = Math.max(Math.min(_loc4_.y,_loc8_.bottom - _loc4_.height),_loc8_.y);
         _loc4_.y = Math.max(Math.min(_loc4_.y,param2.y),param2.bottom - _loc4_.height);
         _loc4_ = _loc4_.intersection(_loc8_);
         return _loc4_.isEmpty() ? param2.clone() : _loc4_.union(param2);
      }

      private static function toLocal(param1:DisplayObject, param2:Rectangle) : Rectangle
      {
         var _loc7_:Matrix = param1.transform.matrix;
         if(_loc7_ == null)
         {
            return param2.clone();
         }
         _loc7_.invert();
         var _loc5_:Point = _loc7_.transformPoint(param2.topLeft);
         var _loc1_:Point = _loc7_.transformPoint(param2.bottomRight);
         return new Rectangle(Math.min(_loc5_.x,_loc1_.x),Math.min(_loc5_.y,_loc1_.y),Math.abs(_loc1_.x - _loc5_.x),Math.abs(_loc1_.y - _loc5_.y));
      }

      private static function padButton(param1:SimpleButton, param2:Number, param3:Number, param4:Rectangle) : void
      {
         var _loc1_:DisplayObject = origs[param1] as DisplayObject;
         if(_loc1_ == null)
         {
            _loc1_ = param1.hitTestState;
            origs[param1] = _loc1_;
         }
         var _loc2_:Rectangle = area(param1,_loc1_.getBounds(_loc1_),param2,param3,param4);
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(0,1);
         _loc3_.graphics.drawRect(_loc2_.x,_loc2_.y,_loc2_.width,_loc2_.height);
         _loc3_.graphics.endFill();
         param1.hitTestState = _loc3_;
      }
   }
}
