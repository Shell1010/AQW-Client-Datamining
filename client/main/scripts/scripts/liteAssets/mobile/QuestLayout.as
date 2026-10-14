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
         var _loc1_:int = 0;
         var _loc2_:Shape = null;
         var _loc3_:DisplayObject = param1.getChildByName("__rows");
         if(_loc3_ != null)
         {
            param1.removeChild(_loc3_);
         }
         var _loc4_:Sprite = param1.getChildByName(ROWS_NAME) as Sprite;
         if(_loc4_ == null)
         {
            _loc4_ = new Sprite();
            _loc4_.name = ROWS_NAME;
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            param1.addChildAt(_loc4_,0);
         }
         var _loc5_:int = rowH();
         var _loc6_:int = LIST_W - ROW_IN * 2;
         var _loc7_:int = _loc5_ - ROW_GAP;
         while(_loc4_.numChildren > param2)
         {
            _loc4_.removeChildAt(_loc4_.numChildren - 1);
         }
         _loc1_ = 0;
         while(_loc1_ < param2)
         {
            _loc2_ = _loc1_ < _loc4_.numChildren ? _loc4_.getChildAt(_loc1_) as Shape : null;
            if(_loc2_ == null)
            {
               _loc2_ = new Shape();
               _loc4_.addChild(_loc2_);
            }
            NativeArt.questFace(_loc2_.graphics,_loc6_,_loc7_);
            _loc2_.x = ROW_IN;
            _loc2_.y = _loc1_ * _loc5_;
            _loc1_++;
         }
         var _loc8_:DisplayObject = param1.getChildByName("mHi");
         if(_loc8_ != null)
         {
            _loc8_.x = ROW_IN;
            _loc8_.width = _loc6_;
            _loc8_.height = _loc7_;
            _loc8_.transform.colorTransform = new ColorTransform(0,0,0,0.22,244,226,125,0);
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
         var _loc3_:DisplayObject = param1.getChildByName("bMask");
         var _loc4_:DisplayObject = _loc1_ != null ? _loc1_.getChildByName("b") : null;
         if(_loc2_ == null || _loc3_ == null || _loc4_ == null)
         {
            return;
         }
         var _loc5_:Number = _loc4_.height;
         var _loc6_:Number = _loc1_.y + _loc4_.y;
         var _loc7_:Number = Math.floor(Math.max(MIN_VIEW,param2.y - STEP_GAP - _loc6_));
         if(_loc7_ >= _loc5_)
         {
            return;
         }
         trackH[_loc4_] = _loc5_;
         _loc4_.height = _loc7_;
         var _loc8_:Rectangle = _loc3_.getBounds(param1);
         var _loc9_:Shape = new Shape();
         _loc9_.name = VIEW_NAME;
         _loc9_.graphics.beginFill(0,1);
         _loc9_.graphics.drawRect(_loc8_.x,_loc6_,_loc8_.width,_loc7_);
         _loc9_.graphics.endFill();
         _loc9_.visible = false;
         param1.addChild(_loc9_);
         _loc2_.mask = _loc9_;
      }

      public static function unfit(param1:MovieClip) : void
      {
         var _loc1_:DisplayObject = null;
         if(param1 == null)
         {
            return;
         }
         var _loc2_:DisplayObject = param1.getChildByName(VIEW_NAME);
         if(_loc2_ != null)
         {
            _loc1_ = param1.getChildByName("core");
            if(_loc1_ != null && _loc1_.mask == _loc2_)
            {
               _loc1_.mask = null;
            }
            param1.removeChild(_loc2_);
         }
         var _loc3_:MovieClip = param1.getChildByName("scr") as MovieClip;
         var _loc4_:DisplayObject = _loc3_ != null ? _loc3_.getChildByName("b") : null;
         if(_loc4_ != null && trackH[_loc4_] != undefined)
         {
            _loc4_.height = trackH[_loc4_];
            delete trackH[_loc4_];
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
         var _loc3_:Number = -10;
         var _loc4_:Number = param2.x - 2 - param1.x - _loc3_;
         if(_loc4_ <= 0 || _loc2_.height <= 0)
         {
            return;
         }
         var _loc5_:Sprite = new Sprite();
         _loc5_.name = HIT_NAME;
         _loc5_.graphics.beginFill(0,0);
         _loc5_.graphics.drawRect(_loc3_,Math.min(0,_loc2_.y),_loc4_,_loc2_.bottom + 20 - Math.min(0,_loc2_.y));
         _loc5_.graphics.endFill();
         param1.addChildAt(_loc5_,0);
      }
   }
}
