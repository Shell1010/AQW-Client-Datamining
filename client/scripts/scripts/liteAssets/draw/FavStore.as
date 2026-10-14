package liteAssets.draw
{
   import flash.display.*;
   import flash.utils.*;

   public class FavStore
   {

      public static const GOLD:uint = 16762951;

      public static const GOLD_DARK:uint = 10119698;

      private static const TOGGLE_GAP:int = 200;

      private static const SIN72:Number = 0.9510565;

      private static const STAR_H:Number = 1.809017;

      public static var version:int = 0;

      public static var count:int = 0;

      private static var favs:Object = {};

      private static var listeners:Array = [];

      private static var lastToggle:int = -1000;

      private static var key:String = null;

      public function FavStore()
      {
         super();
      }

      public static function has(param1:*) : Boolean
      {
         return count > 0 && favs[int(param1)] === true;
      }

      public static function addListener(param1:Function) : void
      {
         if(listeners.indexOf(param1) < 0)
         {
            listeners.push(param1);
         }
      }

      public static function removeListener(param1:Function) : void
      {
         var _loc1_:int = int(listeners.indexOf(param1));
         if(_loc1_ > -1)
         {
            listeners.splice(_loc1_,1);
         }
      }

      private static function changed() : void
      {
         var _loc1_:Function = null;
         ++version;
         var _loc2_:Array = listeners.concat();
         for each(_loc1_ in _loc2_)
         {
            try
            {
               _loc1_();
            }
            catch(e:Error)
            {
            }
         }
      }

      private static function setFav(param1:int, param2:Boolean) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         if(param2)
         {
            if(favs[param1] !== true)
            {
               favs[param1] = true;
               ++count;
            }
         }
         else if(favs[param1] === true)
         {
            delete favs[param1];
            --count;
         }
      }

      public static function reset() : void
      {
         favs = {};
         count = 0;
         key = null;
         lastToggle = -1000;
         changed();
      }

      public static function load(param1:MovieClip) : void
      {
         var cid:int = 0;
         var all:Object = null;
         var list:Array = null;
         var v:* = undefined;
         var rootClass:MovieClip = param1;
         favs = {};
         count = 0;
         key = null;
         try
         {
            cid = int(rootClass.world.myAvatar.objData.CharID);
            if(cid > 0)
            {
               key = String(cid);
               all = rootClass.litePreference.data.favs;
               list = all != null ? all[key] as Array : null;
               if(list != null)
               {
                  for each(v in list)
                  {
                     setFav(int(v),true);
                  }
               }
            }
         }
         catch(e:Error)
         {
            key = null;
         }
         changed();
      }

      private static function save(param1:MovieClip) : void
      {
         var _loc1_:Array = null;
         var _loc3_:String = null;
         var _loc4_:Object = null;
         if(key == null)
         {
            return;
         }
         try
         {
            _loc1_ = [];
            for(_loc3_ in favs)
            {
               _loc1_.push(int(_loc3_));
            }
            _loc4_ = param1.litePreference.data;
            if(_loc4_.favs == null)
            {
               _loc4_.favs = {};
            }
            if(_loc1_.length > 0)
            {
               _loc4_.favs[key] = _loc1_;
            }
            else
            {
               delete _loc4_.favs[key];
            }
            param1.litePreference.flush();
         }
         catch(e:Error)
         {
         }
      }

      public static function inInventory(param1:Object, param2:MovieClip) : Boolean
      {
         var _loc5_:Object = null;
         if(param1 == null || param2 == null || param2.world == null || param2.world.myAvatar == null)
         {
            return false;
         }
         var _loc3_:Array = param2.world.myAvatar.items as Array;
         if(_loc3_ == null)
         {
            return false;
         }
         var _loc4_:int = int(param1.ItemID);
         for each(_loc5_ in _loc3_)
         {
            if(_loc5_ != null && int(_loc5_.ItemID) == _loc4_)
            {
               return true;
            }
         }
         return false;
      }

      public static function toggle(param1:Object, param2:MovieClip) : void
      {
         if(param1 == null || param2 == null || param2.world == null)
         {
            return;
         }
         var _loc3_:int = int(param1.ItemID);
         if(_loc3_ <= 0)
         {
            return;
         }
         var _loc4_:int = int(getTimer());
         if(_loc4_ - lastToggle < TOGGLE_GAP)
         {
            return;
         }
         if(key == null)
         {
            load(param2);
         }
         if(key == null)
         {
            return;
         }
         var _loc5_:Boolean = !has(_loc3_);
         if((_loc5_) && !inInventory(param1,param2))
         {
            param2.MsgBox.notify("Move this item to your inventory to favorite it.");
            return;
         }
         lastToggle = _loc4_;
         setFav(_loc3_,_loc5_);
         changed();
         save(param2);
      }

      public static function notifyLocked(param1:MovieClip, param2:String) : void
      {
         param1.MsgBox.notify("Unfavorite this item before " + param2 + " it.");
      }

      public static function drawStar(param1:Graphics, param2:Number, param3:Number, param4:Number) : void
      {
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = param4 * 0.382;
         _loc5_ = 0;
         while(_loc5_ < 10)
         {
            _loc6_ = -Math.PI / 2 + _loc5_ * Math.PI / 5;
            _loc7_ = _loc5_ % 2 == 0 ? param4 : _loc8_;
            if(_loc5_ == 0)
            {
               param1.moveTo(param2 + Math.cos(_loc6_) * _loc7_,param3 + Math.sin(_loc6_) * _loc7_);
            }
            else
            {
               param1.lineTo(param2 + Math.cos(_loc6_) * _loc7_,param3 + Math.sin(_loc6_) * _loc7_);
            }
            _loc5_++;
         }
         param1.lineTo(param2,param3 - param4);
      }

      public static function starShape(param1:Number) : Shape
      {
         var _loc1_:Shape = new Shape();
         var _loc3_:Number = param1 / STAR_H;
         var _loc4_:Graphics = _loc1_.graphics;
         _loc4_.lineStyle(1,GOLD_DARK,1,true);
         _loc4_.beginFill(GOLD);
         drawStar(_loc4_,_loc3_ * SIN72,_loc3_,_loc3_);
         _loc4_.endFill();
         return _loc1_;
      }
   }
}
