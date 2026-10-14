package liteAssets.mobile
{
   import flash.display.*;
   import flash.geom.*;

   public class NativeArt
   {

      private static var menuUp:BitmapData;

      private static var menuDown:BitmapData;

      private static var qBtn:BitmapData;

      public static const K:Number = 2;

      public static const MENU_X:Number = 16;

      public static const MENU_Y:Number = 15;

      public static const QB_IN:Number = 7;

      private static const MENU_NAMES:Array = ["btnBag","btnOption","btnMap","btnRest","btnBook","btnMenu"];

      private static const SKIP:Object = {
         "ti":1,
         "fx":1,
         "__touchPad":1
      };

      public function NativeArt()
      {
         super();
      }

      public static function menu(param1:Boolean) : BitmapData
      {
         if(menuUp == null)
         {
            captureMenu();
         }
         return param1 && menuDown != null ? menuDown : menuUp;
      }

      public static function get questButton() : BitmapData
      {
         return qBtn;
      }

      public static function captureQuestButton(param1:DisplayObjectContainer) : void
      {
         var j:int;
         var hidden:Array = null;
         var r:Rectangle = null;
         var i:int = 0;
         var c:DisplayObject = null;
         var src:DisplayObjectContainer = param1;
         if(qBtn != null || src == null)
         {
            return;
         }
         hidden = [];
         try
         {
            r = artBounds(src,src);
            if(r == null || r.width < QB_IN * 2 + 4 || r.height < QB_IN * 2 + 4)
            {
               return;
            }
            i = 0;
            while(i < src.numChildren)
            {
               c = src.getChildAt(i);
               if(SKIP[c.name] == 1 && c.visible)
               {
                  c.visible = false;
                  hidden.push(c);
               }
               i++;
            }
            qBtn = snap(src,r,null);
         }
         catch(e:Error)
         {
            qBtn = null;
         }
         j = 0;
         while(j < hidden.length)
         {
            DisplayObject(hidden[j]).visible = true;
            j++;
         }
      }

      public static function artBounds(param1:DisplayObjectContainer, param2:DisplayObject) : Rectangle
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         var _loc3_:Rectangle = null;
         var _loc4_:int = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc1_ = param1.getChildAt(_loc4_);
            if(SKIP[_loc1_.name] != 1)
            {
               _loc2_ = _loc1_.getBounds(param2);
               if(!(_loc2_.width <= 0 || _loc2_.height <= 0))
               {
                  _loc3_ = _loc3_ == null ? _loc2_ : _loc3_.union(_loc2_);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }

      public static function slice(param1:Graphics, param2:BitmapData, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number = 1) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Array = [0,param5 * K,param2.width - param7 * K,param2.width];
         var _loc9_:Array = [0,param6 * K,param2.height - param8 * K,param2.height];
         var _loc10_:Array = [0,param5 * param9,param3 - param7 * param9,param3];
         var _loc11_:Array = [0,param6 * param9,param4 - param8 * param9,param4];
         var _loc12_:Matrix = new Matrix();
         var _loc13_:int = 0;
         while(_loc13_ < 3)
         {
            _loc1_ = 0;
            while(_loc1_ < 3)
            {
               _loc2_ = _loc10_[_loc1_ + 1] - _loc10_[_loc1_];
               _loc3_ = _loc11_[_loc13_ + 1] - _loc11_[_loc13_];
               _loc4_ = _loc8_[_loc1_ + 1] - _loc8_[_loc1_];
               _loc5_ = _loc9_[_loc13_ + 1] - _loc9_[_loc13_];
               if(!(_loc2_ <= 0 || _loc3_ <= 0 || _loc4_ <= 0 || _loc5_ <= 0))
               {
                  _loc6_ = _loc2_ / _loc4_;
                  _loc7_ = _loc3_ / _loc5_;
                  _loc12_.setTo(_loc6_,0,0,_loc7_,_loc10_[_loc1_] - _loc8_[_loc1_] * _loc6_,_loc11_[_loc13_] - _loc9_[_loc13_] * _loc7_);
                  param1.beginBitmapFill(param2,_loc12_,false,true);
                  param1.drawRect(_loc10_[_loc1_],_loc11_[_loc13_],_loc2_,_loc3_);
                  param1.endFill();
               }
               _loc1_++;
            }
            _loc13_++;
         }
      }

      public static function menuFace(param1:Graphics, param2:Number, param3:Number, param4:Boolean) : void
      {
         param1.clear();
         var _loc1_:BitmapData = menu(param4);
         var _loc2_:Number = _loc1_ != null ? _loc1_.width / K : 47;
         var _loc3_:Number = _loc1_ != null ? _loc1_.height / K : 43;
         var _loc4_:Number = Math.min(param2 / _loc2_,param3 / _loc3_,(param2 - 4) / (MENU_X * 2),(param3 - 4) / (MENU_Y * 2));
         if(_loc1_ != null)
         {
            slice(param1,_loc1_,param2,param3,MENU_X,MENU_Y,MENU_X,MENU_Y,_loc4_);
            return;
         }
         var _loc5_:Number = Math.round(MENU_X * _loc4_);
         var _loc6_:Matrix = new Matrix();
         param1.beginFill(3158064);
         param1.drawRoundRect(0,0,param2,param3,_loc5_ * 2,_loc5_ * 2);
         param1.endFill();
         _loc6_.createGradientBox(param2 - 4,param3 - 4,Math.PI / 2,2,2);
         param1.beginGradientFill(GradientType.LINEAR,[9211020,7237230,4408131,1973790],[1,1,1,1],[0,96,104,255],_loc6_);
         param1.drawRoundRect(2,2,param2 - 4,param3 - 4,_loc5_ * 2 - 4,_loc5_ * 2 - 4);
         param1.endFill();
      }

      public static function questFace(param1:Graphics, param2:Number, param3:Number) : void
      {
         param1.clear();
         var _loc1_:Number = Math.min(1,(param2 - 2) / (QB_IN * 2),(param3 - 2) / (QB_IN * 2));
         if(qBtn != null)
         {
            slice(param1,qBtn,param2,param3,QB_IN,QB_IN,QB_IN,QB_IN,_loc1_);
            return;
         }
         param1.beginFill(13673792);
         param1.drawRoundRect(0,0,param2,param3,10,10);
         param1.endFill();
         param1.beginFill(16048765);
         param1.drawRoundRect(1,1,param2 - 2,param3 - 2,8,8);
         param1.endFill();
         var _loc2_:Matrix = new Matrix();
         _loc2_.createGradientBox(param2 - 4,param3 - 4,Math.PI / 2,2,2);
         param1.beginGradientFill(GradientType.LINEAR,[3815994,1052688,65793],[1,1,1],[0,120,255],_loc2_);
         param1.drawRoundRect(2,2,param2 - 4,param3 - 4,6,6);
         param1.endFill();
      }

      private static function captureMenu() : void
      {
         var mm:DisplayObjectContainer = null;
         var i:int = 0;
         var b:SimpleButton = null;
         try
         {
            mm = Mobile.game.ui.mcInterface.mcMenu as DisplayObjectContainer;
            if(mm == null)
            {
               return;
            }
            i = 0;
            while(i < MENU_NAMES.length && menuUp == null)
            {
               b = mm.getChildByName(MENU_NAMES[i]) as SimpleButton;
               if(b != null)
               {
                  menuUp = base(b.upState);
                  if(menuUp != null)
                  {
                     menuDown = base(b.downState);
                  }
               }
               i++;
            }
         }
         catch(e:Error)
         {
            menuUp = null;
            menuDown = null;
         }
      }

      private static function base(param1:DisplayObject) : BitmapData
      {
         var _loc1_:DisplayObjectContainer = param1 as DisplayObjectContainer;
         if(_loc1_ == null || _loc1_.numChildren < 2)
         {
            return null;
         }
         var _loc2_:DisplayObject = _loc1_.getChildAt(0);
         var _loc3_:Rectangle = _loc2_.getBounds(_loc1_);
         if(_loc3_.width < MENU_X * 2 + 4 || _loc3_.height < MENU_Y * 2 + 4)
         {
            return null;
         }
         return snap(_loc2_,_loc3_,_loc2_.transform.matrix);
      }

      private static function snap(param1:DisplayObject, param2:Rectangle, param3:Matrix) : BitmapData
      {
         var _loc1_:Matrix = param3 != null ? param3.clone() : new Matrix();
         _loc1_.translate(-param2.x,-param2.y);
         _loc1_.scale(K,K);
         var _loc2_:BitmapData = new BitmapData(Math.ceil(param2.width * K),Math.ceil(param2.height * K),true,0);
         _loc2_.drawWithQuality(param1,_loc1_,param3 != null ? param1.transform.colorTransform : null,null,null,true,StageQuality.HIGH);
         if(_loc2_.getColorBoundsRect(4278190080,0,false).isEmpty())
         {
            _loc2_.dispose();
            return null;
         }
         return _loc2_;
      }
   }
}
