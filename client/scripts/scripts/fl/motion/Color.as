package fl.motion
{
   import flash.display.*;
   import flash.geom.ColorTransform;

   public class Color extends ColorTransform
   {

      private var _tintColor:Number = 0;

      private var _tintMultiplier:Number = 0;

      public function Color(param1:Number = 1, param2:Number = 1, param3:Number = 1, param4:Number = 1, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Number = 0)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
      }

      public static function fromXML(param1:XML) : Color
      {
         return Color(new Color().parseXML(param1));
      }

      public static function interpolateTransform(param1:ColorTransform, param2:ColorTransform, param3:Number) : ColorTransform
      {
         var _loc1_:Number = 1 - param3;
         return new ColorTransform(param1.redMultiplier * _loc1_ + param2.redMultiplier * param3,param1.greenMultiplier * _loc1_ + param2.greenMultiplier * param3,param1.blueMultiplier * _loc1_ + param2.blueMultiplier * param3,param1.alphaMultiplier * _loc1_ + param2.alphaMultiplier * param3,param1.redOffset * _loc1_ + param2.redOffset * param3,param1.greenOffset * _loc1_ + param2.greenOffset * param3,param1.blueOffset * _loc1_ + param2.blueOffset * param3,param1.alphaOffset * _loc1_ + param2.alphaOffset * param3);
      }

      public static function interpolateColor(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc1_:Number = 1 - param3;
         var _loc2_:uint = uint(param1 >> 24 & 0xFF);
         var _loc3_:uint = uint(param1 >> 16 & 0xFF);
         var _loc4_:uint = uint(param1 >> 8 & 0xFF);
         var _loc5_:uint = uint(param1 & 0xFF);
         var _loc6_:uint = uint(param2 >> 24 & 0xFF);
         var _loc7_:uint = uint(param2 >> 16 & 0xFF);
         var _loc8_:uint = uint(param2 >> 8 & 0xFF);
         var _loc9_:uint = uint(param2 & 0xFF);
         var _loc10_:uint = _loc2_ * _loc1_ + _loc6_ * param3;
         var _loc11_:uint = _loc3_ * _loc1_ + _loc7_ * param3;
         var _loc12_:uint = _loc4_ * _loc1_ + _loc8_ * param3;
         var _loc13_:uint = _loc5_ * _loc1_ + _loc9_ * param3;
         return uint(_loc10_ << 24 | _loc11_ << 16 | _loc12_ << 8 | _loc13_);
      }

      public function get brightness() : Number
      {
         return this.redOffset ? 1 - this.redMultiplier : this.redMultiplier - 1;
      }

      public function set brightness(param1:Number) : void
      {
         if(param1 > 1)
         {
            param1 = 1;
         }
         else if(param1 < -1)
         {
            param1 = -1;
         }
         var _loc14_:Number = 1 - Math.abs(param1);
         var _loc15_:Number = 0;
         if(param1 > 0)
         {
            _loc15_ = param1 * 255;
         }
         this.redMultiplier = this.greenMultiplier = this.blueMultiplier = _loc14_;
         this.redOffset = this.greenOffset = this.blueOffset = _loc15_;
      }

      public function setTint(param1:uint, param2:Number) : void
      {
         this._tintColor = param1;
         this._tintMultiplier = param2;
         this.redMultiplier = this.greenMultiplier = this.blueMultiplier = 1 - param2;
         var _loc15_:uint = uint(param1 >> 16 & 0xFF);
         var _loc1_:uint = uint(param1 >> 8 & 0xFF);
         var _loc2_:uint = uint(param1 & 0xFF);
         this.redOffset = Math.round(_loc15_ * param2);
         this.greenOffset = Math.round(_loc1_ * param2);
         this.blueOffset = Math.round(_loc2_ * param2);
      }

      public function get tintColor() : uint
      {
         return this._tintColor;
      }

      public function set tintColor(param1:uint) : void
      {
         this.setTint(param1,this.tintMultiplier);
      }

      private function deriveTintColor() : uint
      {
         var _loc16_:Number = 1 / this.tintMultiplier;
         var _loc14_:uint = Math.round(this.redOffset * _loc16_);
         var _loc15_:uint = Math.round(this.greenOffset * _loc16_);
         var _loc1_:uint = Math.round(this.blueOffset * _loc16_);
         return uint(_loc14_ << 16 | _loc15_ << 8 | _loc1_);
      }

      public function get tintMultiplier() : Number
      {
         return this._tintMultiplier;
      }

      public function set tintMultiplier(param1:Number) : void
      {
         this.setTint(this.tintColor,param1);
      }

      private function parseXML(param1:XML = null) : Color
      {
         var _loc15_:XML = null;
         var _loc1_:String = null;
         var _loc2_:uint = 0;
         if(!param1)
         {
            return this;
         }
         var _loc14_:XML = param1.elements()[0];
         if(!_loc14_)
         {
            return this;
         }
         for each(_loc15_ in _loc14_.attributes())
         {
            _loc1_ = _loc15_.localName();
            if(_loc1_ == "tintColor")
            {
               _loc2_ = Number(_loc15_.toString()) as uint;
               this.tintColor = _loc2_;
            }
            else
            {
               this[_loc1_] = Number(_loc15_.toString());
            }
         }
         return this;
      }
   }
}
