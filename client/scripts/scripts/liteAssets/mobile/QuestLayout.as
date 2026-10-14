package liteAssets.mobile
{
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;

   public class QuestLayout
   {

      private static const ROW_MIN:int = 34;

      public static const LIST_W:int = 282;

      private static const TEXT_IN:int = 10;

      private static const ROW_GAP:int = 4;

      private static const ROW_IN:int = 2;

      private static const TEXT_OUTLINE:GlowFilter = new GlowFilter(0,1,3,3,64,1);

      private static const STEP_GAP:int = 8;

      private static const MIN_VIEW:int = 60;

      private static const PAD_NAME:String = "__touchPad";

      private static const ROWS_NAME:String = "__rowFaces";

      private static const HIT_NAME:String = "__qHit";

      private static const VIEW_NAME:String = "__qView";

      private static var trackH:Dictionary = new Dictionary(true);

      public function QuestLayout()
      {
         super();
      }

      public static function rowH() : int
      {
         return Math.max(ROW_MIN,Mobile.touchPx(6));
      }

      public static function row(param1:MovieClip, param2:int) : void
      {
         var _loc1_:int = 0;
         var _loc2_:TextField = null;
         var _loc3_:int = 0;
         _loc1_ = rowH();
         param1.y = param2 * _loc1_;
         _loc2_ = param1.getChildByName("ti") as TextField;
         var _loc4_:DisplayObject = param1.getChildByName("hit");
         var _loc5_:int = _loc1_ - ROW_GAP;
         var _loc6_:Number = _loc2_ != null ? _loc2_.y + (_loc2_.textHeight + 4) / 2 : _loc5_ / 2;
         _loc3_ = Math.round(_loc5_ / 2 - _loc6_);
         if(_loc2_ != null)
         {
            _loc2_.x += TEXT_IN;
            _loc2_.y += _loc3_;
            _loc2_.filters = [TEXT_OUTLINE];
         }
         if(_loc4_ != null)
         {
            _loc4_.x += TEXT_IN;
            _loc4_.y += _loc3_;
         }
         var _loc7_:DisplayObject = param1.getChildByName(PAD_NAME);
         if(_loc7_ != null)
         {
            param1.removeChild(_loc7_);
         }
         var _loc8_:Shape = new Shape();
         _loc8_.name = PAD_NAME;
         _loc8_.graphics.beginFill(0,0);
         _loc8_.graphics.drawRect(-param1.x,0,LIST_W,_loc1_);
         _loc8_.graphics.endFill();
         param1.addChildAt(_loc8_,0);
      }

      public static function rows(param1:MovieClip, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc8_:Shape = null;
         var _loc1_:DisplayObject = param1.getChildByName("__rows");
         if(_loc1_ != null)
         {
            param1.removeChild(_loc1_);
         }
         var _loc2_:Sprite = param1.getChildByName(ROWS_NAME) as Sprite;
         if(_loc2_ == null)
         {
            _loc2_ = new Sprite();
            _loc2_.name = ROWS_NAME;
            _loc2_.mouseEnabled = false;
            _loc2_.mouseChildren = false;
            param1.addChildAt(_loc2_,0);
         }
         var _loc4_:int = rowH();
         var _loc5_:int = LIST_W - ROW_IN * 2;
         var _loc6_:int = _loc4_ - ROW_GAP;
         while(_loc2_.numChildren > param2)
         {
            _loc2_.removeChildAt(_loc2_.numChildren - 1);
         }
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            _loc8_ = _loc3_ < _loc2_.numChildren ? _loc2_.getChildAt(_loc3_) as Shape : null;
            if(_loc8_ == null)
            {
               _loc8_ = new Shape();
               _loc2_.addChild(_loc8_);
            }
            NativeArt.questFace(_loc8_.graphics,_loc5_,_loc6_);
            _loc8_.x = ROW_IN;
            _loc8_.y = _loc3_ * _loc4_;
            _loc3_++;
         }
         var _loc7_:DisplayObject = param1.getChildByName("mHi");
         if(_loc7_ != null)
         {
            _loc7_.x = ROW_IN;
            _loc7_.width = _loc5_;
            _loc7_.height = _loc6_;
            _loc7_.transform.colorTransform = new ColorTransform(0,0,0,0.22,244,226,125,0);
         }
      }

      public static function fitStepper(param1:MovieClip, param2:DisplayObject) : void
      {
         unfit(param1);
         if(param1 == null || param2 == null)
         {
            return;
         }
         var _loc1_:MovieClip = param1.getChildByName("scr") as MovieClip;
         var _loc2_:DisplayObject = param1.getChildByName("core");
         var _loc4_:DisplayObject = param1.getChildByName("bMask");
         var _loc5_:DisplayObject = _loc1_ != null ? _loc1_.getChildByName("b") : null;
         if(_loc2_ == null || _loc4_ == null || _loc5_ == null)
         {
            return;
         }
         var _loc6_:Number = _loc5_.height;
         var _loc3_:Number = _loc1_.y + _loc5_.y;
         var _loc7_:Number = Math.floor(Math.max(MIN_VIEW,param2.y - STEP_GAP - _loc3_));
         if(_loc7_ >= _loc6_)
         {
            return;
         }
         trackH[_loc5_] = _loc6_;
         _loc5_.height = _loc7_;
         var _loc8_:Rectangle = _loc4_.getBounds(param1);
         var _loc9_:Shape = new Shape();
         _loc9_.name = VIEW_NAME;
         _loc9_.graphics.beginFill(0,1);
         _loc9_.graphics.drawRect(_loc8_.x,_loc3_,_loc8_.width,_loc7_);
         _loc9_.graphics.endFill();
         _loc9_.visible = false;
         param1.addChild(_loc9_);
         _loc2_.mask = _loc9_;
      }

      public static function unfit(param1:MovieClip) : void
      {
         var _loc4_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         var _loc10_:DisplayObject = param1.getChildByName(VIEW_NAME);
         if(_loc10_ != null)
         {
            _loc4_ = param1.getChildByName("core");
            if(_loc4_ != null && _loc4_.mask == _loc10_)
            {
               _loc4_.mask = null;
            }
            param1.removeChild(_loc10_);
         }
         var _loc1_:MovieClip = param1.getChildByName("scr") as MovieClip;
         var _loc2_:DisplayObject = _loc1_ != null ? _loc1_.getChildByName("b") : null;
         if(_loc2_ != null && trackH[_loc2_] != undefined)
         {
            _loc2_.height = trackH[_loc2_];
            delete trackH[_loc2_];
         }
      }

      public static function detailHit(param1:MovieClip, param2:DisplayObject) : void
      {
         if(!Mobile.active || param1 == null || param2 == null)
         {
            return;
         }
         var _loc1_:DisplayObject = param1.getChildByName(HIT_NAME);
         if(_loc1_ != null)
         {
            param1.removeChild(_loc1_);
         }
         var _loc2_:Rectangle = param1.getBounds(param1);
         var _loc4_:Number = -10;
         var _loc5_:Number = param2.x - 2 - param1.x - _loc4_;
         if(_loc5_ <= 0 || _loc2_.height <= 0)
         {
            return;
         }
         var _loc6_:Sprite = new Sprite();
         _loc6_.name = HIT_NAME;
         _loc6_.graphics.beginFill(0,0);
         _loc6_.graphics.drawRect(_loc4_,Math.min(0,_loc2_.y),_loc5_,_loc2_.bottom + 20 - Math.min(0,_loc2_.y));
         _loc6_.graphics.endFill();
         param1.addChildAt(_loc6_,0);
      }
   }
}
