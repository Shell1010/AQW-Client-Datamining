package
{
   public class InvCat
   {

      public static const MISC_TYPES:Array = ["Item","Note","Quest Item","Resource"];

      private static const NUMERIC_META:RegExp = /^\s*\d+\s*$/;

      private static const KEPT_AT_ZERO:int = 45739;

      public function InvCat()
      {
         super();
      }

      public static function isClass(param1:Object) : Boolean
      {
         return param1 != null && param1.sType == "Class";
      }

      public static function isMisc(param1:Object) : Boolean
      {
         return param1 != null && MISC_TYPES.indexOf(param1.sType) > -1 && !(param1.sType == "Item" && param1.sMeta != null && NUMERIC_META.test(String(param1.sMeta)));
      }

      public static function isHouse(param1:Object) : Boolean
      {
         return param1 != null && (int(param1.bHouse) == 1 || param1.bHouse === true || param1.sType == "House" || param1.sType == "Wall Item" || param1.sType == "Floor Item" || param1.sType == "Guild");
      }

      public static function isBag(param1:Object) : Boolean
      {
         return param1 != null && !isClass(param1) && !isMisc(param1) && !isHouse(param1);
      }

      public static function countBag(param1:Array) : int
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         for each(_loc1_ in param1)
         {
            if(isBag(_loc1_))
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }

      public static function countMisc(param1:Array) : int
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         for each(_loc1_ in param1)
         {
            if(isMisc(_loc1_))
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }

      public static function countClass(param1:Array) : int
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         for each(_loc1_ in param1)
         {
            if(isClass(_loc1_))
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }

      public static function owned(param1:Array, param2:int) : Object
      {
         var _loc1_:Object = null;
         for each(_loc1_ in param1)
         {
            if(_loc1_ != null && int(_loc1_.ItemID) == param2)
            {
               return _loc1_;
            }
         }
         return null;
      }

      public static function isFullFor(param1:Array, param2:Object, param3:int, param4:int = 0) : Boolean
      {
         if(param2 == null || isClass(param2))
         {
            return false;
         }
         var _loc1_:Object = owned(param1,int(param2.ItemID));
         if(_loc1_ != null && int(_loc1_.iQty) < int(_loc1_.iStk))
         {
            return false;
         }
         if(isMisc(param2))
         {
            return _loc1_ == null && countMisc(param1) - param4 >= param3;
         }
         return countBag(param1) - param4 >= param3;
      }

      public static function poolOf(param1:Object) : String
      {
         if(isClass(param1))
         {
            return "class";
         }
         if(isHouse(param1))
         {
            return "house";
         }
         return isMisc(param1) ? "misc" : "bag";
      }

      public static function freedBy(param1:Array, param2:Object, param3:int) : int
      {
         var _loc1_:Object = null;
         var _loc2_:Number = NaN;
         var _loc3_:Object = null;
         if(param2 == null || owned(param1,int(param2.ItemID)) != null)
         {
            return 0;
         }
         var _loc4_:String = poolOf(param2);
         if(_loc4_ != "bag" && _loc4_ != "misc")
         {
            return 0;
         }
         var _loc5_:Number = Number(param2.iQty);
         if(_loc5_ <= 0)
         {
            _loc5_ = 1;
         }
         var _loc6_:Number = Math.max(1,Math.floor(param3 / _loc5_));
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         if(param2.turnin != null)
         {
            for each(_loc3_ in param2.turnin)
            {
               _loc2_ = Number(_loc3_.iQty) * _loc6_;
               if(isToken(param2) && int(_loc3_.ItemID) == int(param2.TokID))
               {
                  _loc8_ = true;
                  _loc2_ += tokenNeed(param2,param3);
               }
               _loc1_ = owned(param1,int(_loc3_.ItemID));
               if(_loc1_ != null && int(_loc3_.ItemID) != KEPT_AT_ZERO && poolOf(_loc1_) == _loc4_ && (_loc1_.sES == "ar" || int(_loc1_.iQty) <= _loc2_))
               {
                  _loc7_++;
               }
            }
         }
         if(isToken(param2) && !_loc8_ && int(param2.TokID) != KEPT_AT_ZERO)
         {
            _loc1_ = owned(param1,int(param2.TokID));
            if(_loc1_ != null && poolOf(_loc1_) == _loc4_ && int(_loc1_.iQty) <= tokenNeed(param2,param3))
            {
               _loc7_++;
            }
         }
         return _loc7_;
      }

      public static function fullMsg(param1:Object) : String
      {
         return isMisc(param1) ? "Misc Inventory Full!" : "Inventory Full!";
      }

      public static function isQuestLocked(param1:Object, param2:Object) : Boolean
      {
         try
         {
            if(param1.iQSindex != null && Number(param1.iQSindex) >= 0 && Number(param2.getQuestValue(param1.iQSindex)) < Number(param1.iQSvalue))
            {
               return true;
            }
         }
         catch(e:Error)
         {
         }
         return false;
      }

      public static function isOwned(param1:Object, param2:Object) : Boolean
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = param2.invTree[int(param1.ItemID)];
            if(_loc1_ != null && int(_loc1_.iQty) > 0)
            {
               return true;
            }
            return param2.bankinfo != null && Boolean(param2.bankinfo.isItemInBank(int(param1.ItemID)));
         }
         catch(e:Error)
         {
         }
         return false;
      }

      public static function isToken(param1:Object) : Boolean
      {
         return param1 != null && Number(param1.TokID) > 0 && Number(param1.TokQty) > 0;
      }

      public static function tokenHave(param1:Object, param2:Object) : int
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = param2.invTree[int(param1.TokID)];
            if(_loc1_ != null)
            {
               return int(_loc1_.iQty);
            }
         }
         catch(e:Error)
         {
         }
         return 0;
      }

      public static function tokenName(param1:Object, param2:Object) : String
      {
         var _loc1_:Object = null;
         if(param1.TokName != null && String(param1.TokName).length > 0)
         {
            return String(param1.TokName);
         }
         try
         {
            _loc1_ = param2.invTree[int(param1.TokID)];
            if(_loc1_ != null && _loc1_.sName != null)
            {
               return String(_loc1_.sName);
            }
         }
         catch(e:Error)
         {
         }
         return "Item #" + int(param1.TokID);
      }

      public static function tokenNeed(param1:Object, param2:int) : int
      {
         var _loc1_:Number = Number(param1.iQty);
         if(_loc1_ <= 0)
         {
            _loc1_ = 1;
         }
         return int(Number(param1.TokQty) * Math.max(1,Math.floor(param2 / _loc1_)));
      }
   }
}
