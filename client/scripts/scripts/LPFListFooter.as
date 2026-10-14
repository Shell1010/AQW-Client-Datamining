package
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;

   public class LPFListFooter extends Sprite
   {

      private static var goldIconClass:Class;

      private static var coinsIconClass:Class;

      public static const PILL_H:int = 26;

      public static const HEIGHT:int = 70;

      private static const EMPTY:Array = [];

      private static const FILL_MTX:Matrix = new Matrix();

      private static var iconsChecked:Boolean = false;

      private var rootClass:MovieClip;

      private var w:int;

      private var pillW:int;

      private var onPlus:Function;

      private var goldIcon:DisplayObject;

      private var coinsIcon:DisplayObject;

      private var goldCR:Rectangle;

      private var coinsCR:Rectangle;

      private var tfGold:TextField;

      private var tfCoins:TextField;

      private var tfItemSlots:TextField;

      private var tfMiscSlots:TextField;

      private var tfSep:TextField;

      private var btnPlus:Sprite;

      private var fmtWhite:TextFormat = new TextFormat("Arial",12,16777215,true);

      private var fmtGold:TextFormat = new TextFormat("Arial",12,14725888,true);

      private var fmtRed:TextFormat = new TextFormat("Arial",12,16729156,true);

      private var fmtLabel:TextFormat = new TextFormat("Arial",12,10066329,false);

      private var lastCR:Rectangle;

      public function LPFListFooter(param1:MovieClip, param2:int, param3:Function)
      {
         var _loc1_:TextField = null;
         super();
         this.rootClass = param1;
         this.w = param2;
         this.pillW = int((this.w - 6) / 2);
         this.onPlus = param3;
         loadIconClasses();
         var _loc2_:Sprite = this.buildPill(0,goldIconClass,20);
         this.goldIcon = _loc2_.numChildren > 0 ? _loc2_.getChildAt(0) : null;
         this.goldCR = this.lastCR;
         this.tfGold = LPFElementInvAQRow.makeTF(12,16777215,true);
         _loc2_.addChild(this.tfGold);
         var _loc3_:Sprite = this.buildPill(this.pillW + 6,coinsIconClass,16);
         this.coinsIcon = _loc3_.numChildren > 0 ? _loc3_.getChildAt(0) : null;
         this.coinsCR = this.lastCR;
         this.tfCoins = LPFElementInvAQRow.makeTF(12,16777215,true);
         _loc3_.addChild(this.tfCoins);
         this.btnPlus = new Sprite();
         var _loc4_:Graphics = this.btnPlus.graphics;
         _loc4_.lineStyle(1,12303291,1,true);
         _loc4_.beginFill(2763306);
         _loc4_.drawCircle(10,10,10);
         _loc4_.endFill();
         _loc1_ = LPFElementInvAQRow.makeTF(14,16777215,true);
         _loc1_.text = "+";
         _loc1_.x = Math.round((20 - _loc1_.width) / 2);
         _loc1_.y = Math.round((20 - _loc1_.height) / 2);
         this.btnPlus.addChild(_loc1_);
         this.btnPlus.buttonMode = true;
         this.btnPlus.mouseChildren = false;
         this.btnPlus.addEventListener(MouseEvent.CLICK,this.onPlusClick,false,0,true);
         addChild(this.btnPlus);
         this.tfItemSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         addChild(this.tfItemSlots);
         this.tfMiscSlots = LPFElementInvAQRow.makeTF(12,16777215,true);
         addChild(this.tfMiscSlots);
         this.tfSep = makeSeparator();
         addChild(this.tfSep);
      }

      public static function makeSeparator() : TextField
      {
         var _loc5_:TextField = LPFElementInvAQRow.makeTF(12,5592405,true);
         _loc5_.text = "|";
         return _loc5_;
      }

      public static function layoutSlotLine(param1:DisplayObject, param2:Boolean, param3:TextField, param4:TextField, param5:TextField, param6:Number, param7:Number, param8:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Boolean = false;
         var _loc8_:Number = NaN;
         var _loc9_:Number = 8;
         _loc6_ = 6;
         _loc7_ = param5 != null && param5.visible;
         if(param4 != null)
         {
            param4.visible = _loc7_;
         }
         param3.scaleX = param3.scaleY = 1;
         if(_loc7_)
         {
            param5.scaleX = param5.scaleY = 1;
         }
         var _loc10_:Number = param2 ? 20 + _loc9_ : 0;
         var _loc11_:Number = _loc10_ + (_loc7_ ? _loc6_ * 2 + param4.width : 0);
         var _loc12_:Number = param3.width + (_loc7_ ? param5.width : 0);
         var _loc13_:Number = param7 - 8;
         if(_loc11_ + _loc12_ > _loc13_ && _loc12_ > 0)
         {
            _loc8_ = Math.max(0.75,(_loc13_ - _loc11_) / _loc12_);
            param3.scaleX = param3.scaleY = _loc8_;
            if(_loc7_)
            {
               param5.scaleX = param5.scaleY = _loc8_;
            }
            _loc12_ = param3.width + (_loc7_ ? param5.width : 0);
         }
         var _loc14_:Number = Math.round(param6 + (param7 - _loc11_ - _loc12_) / 2);
         if(param1 != null)
         {
            param1.visible = param2;
            param1.x = _loc14_;
            param1.y = param8;
         }
         if(param2)
         {
            _loc14_ += 20 + _loc9_;
         }
         param3.x = _loc14_;
         param3.y = Math.round(param8 + (20 - param3.height) / 2);
         if(_loc7_)
         {
            _loc14_ += param3.width + _loc6_;
            param4.x = _loc14_;
            param4.y = Math.round(param8 + (20 - param4.height) / 2);
            _loc14_ += param4.width + _loc6_;
            param5.x = _loc14_;
            param5.y = param3.y;
         }
      }

      private static function loadIconClasses() : void
      {
         if(iconsChecked)
         {
            return;
         }
         iconsChecked = true;
         try
         {
            goldIconClass = getDefinitionByName("LPFIconGold") as Class;
         }
         catch(e:Error)
         {
            goldIconClass = null;
         }
         try
         {
            coinsIconClass = getDefinitionByName("LPFIconCoins") as Class;
         }
         catch(e2:Error)
         {
            coinsIconClass = null;
         }
      }

      private static function fitIcon(param1:DisplayObject, param2:Number) : Rectangle
      {
         var _loc4_:BitmapData = null;
         var _loc1_:Rectangle = null;
         var _loc15_:Rectangle = param1.getBounds(param1);
         var _loc2_:Rectangle = _loc15_.clone();
         if(_loc15_.width >= 1 && _loc15_.height >= 1 && _loc15_.width < 2000 && _loc15_.height < 2000)
         {
            _loc4_ = new BitmapData(Math.ceil(_loc15_.width) + 2,Math.ceil(_loc15_.height) + 2,true,0);
            try
            {
               _loc4_.draw(param1,new Matrix(1,0,0,1,1 - _loc15_.x,1 - _loc15_.y));
               _loc4_.threshold(_loc4_,_loc4_.rect,new Point(0,0),"<",2147483648,0,4278190080,true);
               _loc1_ = _loc4_.getColorBoundsRect(4278190080,0,false);
               if(_loc1_.width > 0 && _loc1_.height > 0)
               {
                  _loc2_ = new Rectangle(_loc1_.x + _loc15_.x - 1,_loc1_.y + _loc15_.y - 1,_loc1_.width,_loc1_.height);
               }
            }
            catch(e:Error)
            {
            }
            _loc4_.dispose();
         }
         var _loc3_:Number = _loc2_.height > 0 ? param2 / _loc2_.height : 1;
         if(_loc2_.width * _loc3_ > param2 * 1.6)
         {
            _loc3_ = param2 * 1.6 / _loc2_.width;
         }
         param1.scaleX = param1.scaleY = _loc3_;
         return _loc2_;
      }

      public function destroy() : void
      {
         this.btnPlus.removeEventListener(MouseEvent.CLICK,this.onPlusClick);
         this.onPlus = null;
         this.rootClass = null;
      }

      public function drawPills() : void
      {
         var _loc5_:Object = this.objData();
         if(_loc5_ == null)
         {
            return;
         }
         LPFElementInvAQRow.setRuns(this.tfGold,this.rootClass.strNumWithCommas(int(_loc5_.intGold)),this.fmtWhite,"g",this.fmtGold);
         this.placeContent(this.goldIcon,this.goldCR,this.tfGold);
         this.tfCoins.text = this.rootClass.strNumWithCommas(int(_loc5_.intCoins));
         this.placeContent(this.coinsIcon,this.coinsCR,this.tfCoins);
      }

      public function drawSlots() : void
      {
         var _loc5_:Object = this.objData();
         if(_loc5_ == null)
         {
            return;
         }
         var _loc16_:Array = this.rootClass.world.myAvatar.items != null ? this.rootClass.world.myAvatar.items : EMPTY;
         var _loc15_:int = InvCat.countBag(_loc16_);
         var _loc2_:int = int(_loc5_.iBagSlots);
         var _loc3_:int = InvCat.countMisc(_loc16_);
         LPFElementInvAQRow.setRuns(this.tfItemSlots,_loc15_ + " / " + _loc2_,_loc15_ >= _loc2_ ? this.fmtRed : this.fmtWhite," Item spaces",this.fmtLabel);
         LPFElementInvAQRow.setRuns(this.tfMiscSlots,_loc3_ + " / " + _loc2_,_loc3_ >= _loc2_ ? this.fmtRed : this.fmtWhite," Misc spaces",this.fmtLabel);
         layoutSlotLine(this.btnPlus,true,this.tfItemSlots,this.tfSep,this.tfMiscSlots,0,this.w,PILL_H + 6);
      }

      private function objData() : Object
      {
         if(this.rootClass == null || this.rootClass.world == null || this.rootClass.world.myAvatar == null)
         {
            return null;
         }
         return this.rootClass.world.myAvatar.objData;
      }

      private function onPlusClick(param1:MouseEvent) : void
      {
         if(this.onPlus != null)
         {
            this.onPlus();
         }
      }

      private function buildPill(param1:Number, param2:Class, param3:Number) : Sprite
      {
         var g:Graphics;
         var icon:DisplayObject = null;
         var px:Number = param1;
         var iconCls:Class = param2;
         var iconH:Number = param3;
         var pill:Sprite = new Sprite();
         pill.x = px;
         FILL_MTX.createGradientBox(this.pillW,PILL_H,Math.PI / 2,0,0);
         g = pill.graphics;
         g.lineStyle(1,3815994,1,true);
         g.beginGradientFill(GradientType.LINEAR,[1776411,986895],[1,1],[0,255],FILL_MTX);
         g.drawRoundRect(0,0,this.pillW,PILL_H,PILL_H,PILL_H);
         g.endFill();
         this.lastCR = null;
         if(iconCls != null)
         {
            icon = null;
            try
            {
               icon = new iconCls() as DisplayObject;
            }
            catch(e:Error)
            {
               icon = null;
            }
            if(icon != null)
            {
               this.lastCR = fitIcon(icon,iconH);
               pill.addChild(icon);
            }
         }
         addChild(pill);
         return pill;
      }

      private function placeContent(param1:DisplayObject, param2:Rectangle, param3:TextField) : void
      {
         var _loc2_:Number = 6;
         var _loc3_:Number = param1 != null && param2 != null ? param2.width * param1.scaleX : 0;
         param3.scaleX = param3.scaleY = 1;
         var _loc4_:Number = this.pillW - 16 - _loc3_ - (param1 != null ? _loc2_ : 0);
         if(param3.width > _loc4_ && param3.width > 0)
         {
            param3.scaleX = param3.scaleY = Math.max(0.7,_loc4_ / param3.width);
         }
         var _loc1_:Number = _loc3_ + (param1 != null ? _loc2_ : 0) + param3.width;
         var _loc17_:Number = Math.round((this.pillW - _loc1_) / 2);
         if(param1 != null && param2 != null)
         {
            param1.x = Math.round(_loc17_ - param2.x * param1.scaleX);
            param1.y = Math.round(PILL_H / 2 - (param2.y + param2.height / 2) * param1.scaleY);
            param3.x = Math.round(_loc17_ + _loc3_ + _loc2_);
         }
         else
         {
            param3.x = _loc17_;
         }
         param3.y = Math.round((PILL_H - param3.height) / 2);
      }
   }
}
