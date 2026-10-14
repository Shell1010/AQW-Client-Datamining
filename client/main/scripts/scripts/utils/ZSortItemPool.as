package utils
{
   import flash.display.MovieClip;
   import types.*;

   public class ZSortItemPool
   {

      private static var _pool:Vector.<ZSortItem> = new Vector.<ZSortItem>();

      private static const MAX_SIZE:int = 100;

      public function ZSortItemPool()
      {
         super();
      }

      public static function getItem(param1:MovieClip, param2:Number) : ZSortItem
      {
         var _loc1_:ZSortItem = null;
         if(_pool.length > 0)
         {
            _loc1_ = _pool.pop();
            _loc1_.mc = param1;
            _loc1_.oy = param2;
            return _loc1_;
         }
         return new ZSortItem(param1,param2);
      }

      public static function releaseItem(param1:ZSortItem) : void
      {
         if(param1 != null && _pool.length < MAX_SIZE)
         {
            param1.mc = null;
            _pool.push(param1);
         }
      }

      public static function releaseAll(param1:Vector.<ZSortItem>) : void
      {
         var _loc1_:* = int(param1.length - 1);
         while(_loc1_ >= 0)
         {
            releaseItem(param1[_loc1_]);
            _loc1_--;
         }
      }

      public static function clear() : void
      {
         _pool.length = 0;
      }
   }
}
