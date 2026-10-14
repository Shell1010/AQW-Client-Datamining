package com.adobe.utils
{
   public class StringUtil
   {

      public function StringUtil()
      {
         super();
      }

      public static function stringsAreEqual(param1:String, param2:String, param3:Boolean) : Boolean
      {
         if(param3)
         {
            return param1 == param2;
         }
         return param1.toUpperCase() == param2.toUpperCase();
      }

      public static function trim(param1:String) : String
      {
         return StringUtil.ltrim(StringUtil.rtrim(param1));
      }

      public static function ltrim(param1:String) : String
      {
         var _loc1_:Number = param1.length;
         var _loc2_:Number = 0;
         while(_loc2_ < _loc1_)
         {
            if(param1.charCodeAt(_loc2_) > 32)
            {
               return param1.substring(_loc2_);
            }
            _loc2_++;
         }
         return "";
      }

      public static function rtrim(param1:String) : String
      {
         var _loc1_:Number = param1.length;
         var _loc2_:Number = _loc1_;
         while(_loc2_ > 0)
         {
            if(param1.charCodeAt(_loc2_ - 1) > 32)
            {
               return param1.substring(0,_loc2_);
            }
            _loc2_--;
         }
         return "";
      }

      public static function beginsWith(param1:String, param2:String) : Boolean
      {
         return param2 == param1.substring(0,param2.length);
      }

      public static function endsWith(param1:String, param2:String) : Boolean
      {
         return param2 == param1.substring(param1.length - param2.length);
      }

      public static function remove(param1:String, param2:String) : String
      {
         return StringUtil.replace(param1,param2,"");
      }

      public static function replace(param1:String, param2:String, param3:String) : String
      {
         var _loc1_:Number = NaN;
         var _loc2_:String = new String();
         var _loc3_:Boolean = false;
         var _loc4_:Number = param1.length;
         var _loc5_:Number = param2.length;
         var _loc6_:Number = 0;
         for(; _loc6_ < _loc4_; _loc6_++)
         {
            if(param1.charAt(_loc6_) == param2.charAt(0))
            {
               _loc3_ = true;
               _loc1_ = 0;
               while(_loc1_ < _loc5_)
               {
                  if(param1.charAt(_loc6_ + _loc1_) != param2.charAt(_loc1_))
                  {
                     _loc3_ = false;
                     break;
                  }
                  _loc1_++;
               }
               if(_loc3_)
               {
                  _loc2_ += param3;
                  _loc6_ += _loc5_ - 1;
                  continue;
               }
            }
            _loc2_ += param1.charAt(_loc6_);
         }
         return _loc2_;
      }
   }
}
