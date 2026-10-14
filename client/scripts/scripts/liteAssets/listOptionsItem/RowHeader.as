package liteAssets.listOptionsItem
{
   import flash.display.Sprite;
   import flash.filters.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import liteAssets.draw.*;

   public class RowHeader extends Sprite
   {

      public static const H:int = 26;

      public function RowHeader(param1:String, param2:int)
      {
         var _loc1_:TextField = null;
         super();
         mouseEnabled = false;
         mouseChildren = false;
         _loc1_ = MailArt.tf(11,14725888,true);
         var _loc2_:TextFormat = _loc1_.defaultTextFormat;
         _loc2_.letterSpacing = 1.5;
         _loc1_.defaultTextFormat = _loc2_;
         _loc1_.filters = [new DropShadowFilter(1,90,0,0.8,2,2,1,1)];
         _loc1_.text = param1.toUpperCase();
         _loc1_.x = 4;
         _loc1_.y = Math.round((H - _loc1_.height) / 2) + 1;
         addChild(_loc1_);
         var _loc3_:int = Math.round(_loc1_.x + _loc1_.width + 8);
         var _loc4_:int = Math.round(H / 2) + 1;
         graphics.beginFill(13145646,0.45);
         graphics.drawRect(_loc3_,_loc4_,Math.max(0,param2 - _loc3_ - 4),1);
         graphics.endFill();
      }
   }
}
