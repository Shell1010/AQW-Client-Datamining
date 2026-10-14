package
{
   import flash.net.*;
   import flash.system.*;

   public class GUID
   {

      private static var counter:Number = 0;

      public function GUID()
      {
         super();
      }

      public static function GetGUID() : *
      {
         var so_guid:SharedObject = SharedObject.getLocal("AQW_GUID");
         if(so_guid.size == 0)
         {
            so_guid.data.guid = create();
            try
            {
               so_guid.flush();
            }
            catch(e:Error)
            {
               trace("[Game] ERR GUID flush: " + e.message);
            }
         }
         return so_guid.data.guid;
      }

      public static function create() : String
      {
         var _loc1_:Date = new Date();
         var _loc2_:Number = _loc1_.getTime();
         var _loc3_:Number = Math.random() * Number.MAX_VALUE;
         var _loc4_:String = Capabilities.serverString;
         var _loc5_:String = calculate(_loc2_ + _loc4_ + _loc3_ + counter++).toUpperCase();
         return _loc5_.substring(0,8) + "-" + _loc5_.substring(8,12) + "-" + _loc5_.substring(12,16) + "-" + _loc5_.substring(16,20) + "-" + _loc5_.substring(20,32);
      }

      private static function calculate(param1:String) : String
      {
         return hex_sha1(param1);
      }

      private static function hex_sha1(param1:String) : String
      {
         return binb2hex(core_sha1(str2binb(param1),param1.length * 8));
      }

      private static function core_sha1(param1:Array, param2:Number) : Array
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         param1[param2 >> 5] |= 128 << 24 - param2 % 32;
         param1[(param2 + 64 >> 9 << 4) + 15] = param2;
         var _loc8_:Array = new Array(80);
         var _loc9_:Number = 1732584193;
         var _loc10_:Number = -271733879;
         var _loc11_:Number = -1732584194;
         var _loc12_:Number = 271733878;
         var _loc13_:Number = -1009589776;
         var _loc14_:Number = 0;
         while(_loc14_ < param1.length)
         {
            _loc1_ = _loc9_;
            _loc2_ = _loc10_;
            _loc3_ = _loc11_;
            _loc4_ = _loc12_;
            _loc5_ = _loc13_;
            _loc6_ = 0;
            while(_loc6_ < 80)
            {
               if(_loc6_ < 16)
               {
                  _loc8_[_loc6_] = param1[_loc14_ + _loc6_];
               }
               else
               {
                  _loc8_[_loc6_] = rol(_loc8_[_loc6_ - 3] ^ _loc8_[_loc6_ - 8] ^ _loc8_[_loc6_ - 14] ^ _loc8_[_loc6_ - 16],1);
               }
               _loc7_ = Number(safe_add(safe_add(rol(_loc9_,5),sha1_ft(_loc6_,_loc10_,_loc11_,_loc12_)),safe_add(safe_add(_loc13_,_loc8_[_loc6_]),sha1_kt(_loc6_))));
               _loc13_ = _loc12_;
               _loc12_ = _loc11_;
               _loc11_ = Number(rol(_loc10_,30));
               _loc10_ = _loc9_;
               _loc9_ = _loc7_;
               _loc6_++;
            }
            _loc9_ = Number(safe_add(_loc9_,_loc1_));
            _loc10_ = Number(safe_add(_loc10_,_loc2_));
            _loc11_ = Number(safe_add(_loc11_,_loc3_));
            _loc12_ = Number(safe_add(_loc12_,_loc4_));
            _loc13_ = Number(safe_add(_loc13_,_loc5_));
            _loc14_ += 16;
         }
         return new Array(_loc9_,_loc10_,_loc11_,_loc12_,_loc13_);
      }

      private static function sha1_ft(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         if(param1 < 20)
         {
            return param2 & param3 | ~param2 & param4;
         }
         if(param1 < 40)
         {
            return param2 ^ param3 ^ param4;
         }
         if(param1 < 60)
         {
            return param2 & param3 | param2 & param4 | param3 & param4;
         }
         return param2 ^ param3 ^ param4;
      }

      private static function sha1_kt(param1:Number) : Number
      {
         return param1 < 20 ? 1518500249 : (param1 < 40 ? 1859775393 : (param1 < 60 ? -1894007588 : -899497514));
      }

      private static function safe_add(param1:Number, param2:Number) : Number
      {
         var _loc1_:Number = (param1 & 0xFFFF) + (param2 & 0xFFFF);
         var _loc2_:Number = (param1 >> 16) + (param2 >> 16) + (_loc1_ >> 16);
         return _loc2_ << 16 | _loc1_ & 0xFFFF;
      }

      private static function rol(param1:Number, param2:Number) : Number
      {
         return param1 << param2 | param1 >>> 32 - param2;
      }

      private static function str2binb(param1:String) : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Number = (1 << 8) - 1;
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length * 8)
         {
            _loc1_[_loc3_ >> 5] |= (param1.charCodeAt(_loc3_ / 8) & _loc2_) << 24 - _loc3_ % 32;
            _loc3_ += 8;
         }
         return _loc1_;
      }

      private static function binb2hex(param1:Array) : String
      {
         var _loc1_:String = new String("");
         var _loc2_:String = new String("0123456789abcdef");
         var _loc3_:Number = 0;
         while(_loc3_ < param1.length * 4)
         {
            _loc1_ += _loc2_.charAt(param1[_loc3_ >> 2] >> (3 - _loc3_ % 4) * 8 + 4 & 0x0F) + _loc2_.charAt(param1[_loc3_ >> 2] >> (3 - _loc3_ % 4) * 8 & 0x0F);
            _loc3_++;
         }
         return _loc1_;
      }
   }
}
