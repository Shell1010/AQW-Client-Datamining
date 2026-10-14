package liteAssets.mobile
{
   import flash.display.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class DropSlot extends Sprite
   {

      private static var src:MovieClip;

      private static var checkVis:Rectangle;

      public static const REF_X:Number = -1;

      public static const REF_Y:Number = -1;

      public static const REF_W:Number = 49.25;

      public static const REF_H:Number = 44.95;

      public static const ICON_W:int = 34;

      public static const ICON_H:int = 31;

      private static const NUM_GLOW:Array = [new GlowFilter(0,1,3,3,4,2)];

      private static const PRESS_GLOW:Array = [new GlowFilter(16767083,0.8,10,10,2,2)];

      private static const SEL_GLOW:Array = [new GlowFilter(16767083,0.9,8,8,2,2)];

      private static var srcTried:Boolean = false;

      public var item:Object;

      public var key:String;

      private var sw:int;

      private var sh:int;

      private var face:Sprite;

      private var bmd:BitmapData;

      private var badge:Sprite;

      private var badgeTf:TextField;

      private var painted:String;

      private var qty:int = -1;

      private var _pressed:Boolean = false;

      private var _selected:Boolean = false;

      private var _owned:Boolean = false;

      private var check:Sprite;

      public function DropSlot(param1:int)
      {
         super();
         this.sw = param1;
         this.sh = Math.round(param1 * REF_H / REF_W);
         mouseChildren = false;
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(0,0);
         _loc1_.graphics.drawRect(0,0,this.sw,this.sh);
         _loc1_.graphics.endFill();
         addChild(_loc1_);
         this.face = new Sprite();
         this.face.x = this.sw / 2;
         this.face.y = this.sh / 2;
         this.bmd = new BitmapData(this.sw,this.sh,true,0);
         var _loc2_:Bitmap = new Bitmap(this.bmd,"auto",true);
         _loc2_.x = -this.sw / 2;
         _loc2_.y = -this.sh / 2;
         this.face.addChild(_loc2_);
         addChild(this.face);
         this.badge = new Sprite();
         this.badge.mouseEnabled = false;
         this.badge.mouseChildren = false;
         this.badgeTf = MailArt.tf(11,16777215,true);
         this.badgeTf.filters = NUM_GLOW;
         this.badge.addChild(this.badgeTf);
         this.badge.visible = false;
         this.face.addChild(this.badge);
      }

      public static function slotH(param1:int) : int
      {
         return Math.round(param1 * REF_H / REF_W);
      }

      public static function nameColor(param1:Object) : uint
      {
         return param1 != null && int(param1.bUpg) == 1 ? 16566089 : 16777215;
      }

      public static function checkMark(param1:Number) : Sprite
      {
         var _loc1_:Sprite = null;
         var _loc2_:detailedCheck = null;
         var _loc3_:Rectangle = null;
         _loc1_ = new Sprite();
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         try
         {
            _loc2_ = new detailedCheck();
            _loc3_ = visibleRect(_loc2_);
            if(_loc3_.height <= 0)
            {
               return _loc1_;
            }
            _loc2_.scaleX = _loc2_.scaleY = param1 / _loc3_.height;
            _loc2_.x = -_loc3_.right * _loc2_.scaleX;
            _loc2_.y = -_loc3_.y * _loc2_.scaleY;
            _loc1_.addChild(_loc2_);
         }
         catch(e:Error)
         {
         }
         return _loc1_;
      }

      private static function visibleRect(param1:DisplayObject) : Rectangle
      {
         if(checkVis != null)
         {
            return checkVis;
         }
         var _loc1_:Rectangle = param1.getBounds(param1);
         if(_loc1_.width <= 0 || _loc1_.height <= 0)
         {
            return _loc1_;
         }
         var _loc2_:Number = 4;
         var _loc3_:BitmapData = new BitmapData(Math.ceil(_loc1_.width * _loc2_) + 2,Math.ceil(_loc1_.height * _loc2_) + 2,true,0);
         _loc3_.draw(param1,new Matrix(_loc2_,0,0,_loc2_,-_loc1_.x * _loc2_,-_loc1_.y * _loc2_));
         var _loc4_:Rectangle = _loc3_.getColorBoundsRect(65280,0,false);
         _loc3_.dispose();
         if(!_loc4_.isEmpty())
         {
            _loc4_.inflate(_loc2_,_loc2_);
         }
         checkVis = _loc4_.isEmpty() ? _loc1_ : new Rectangle(_loc1_.x + _loc4_.x / _loc2_,_loc1_.y + _loc4_.y / _loc2_,_loc4_.width / _loc2_,_loc4_.height / _loc2_);
         return checkVis;
      }

      public static function isOwned(param1:MovieClip, param2:Object) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         if(param1 == null || param2 == null)
         {
            return false;
         }
         try
         {
            _loc2_ = int(param2.ItemID);
            _loc3_ = int(param2.bHouse) == 1 ? param1.world.myAvatar.houseitems : param1.world.myAvatar.items;
            for each(_loc4_ in _loc3_)
            {
               if(_loc4_ != null && int(_loc4_.ItemID) == _loc2_)
               {
                  return true;
               }
            }
            return param1.world.bankinfo.isItemInBank(_loc2_) == true;
         }
         catch(e:Error)
         {
         }
         return false;
      }

      private static function fitIcon(param1:DisplayObject, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc5_:Number = param1.width;
         var _loc6_:Number = param1.height;
         if(_loc5_ > 0 && _loc6_ > 0)
         {
            param1.scaleX = param1.scaleY = _loc5_ > _loc6_ ? param2 / _loc5_ : param3 / _loc6_;
         }
         param1.x = param4 - param1.width / 2;
         param1.y = param5 - param1.height / 2;
      }

      private static function slotArt() : MovieClip
      {
         var cls:Class = null;
         var s:MovieClip = null;
         var bg:MovieClip = null;
         var q:DisplayObject = null;
         var cnt:DisplayObjectContainer = null;
         if(src != null || Boolean(srcTried))
         {
            return src;
         }
         srcTried = true;
         try
         {
            cls = getDefinitionByName("ib2") as Class;
            s = cls != null ? new cls() as MovieClip : null;
            if(s == null)
            {
               return null;
            }
            s.stop();
            bg = s.getChildByName("bg") as MovieClip;
            if(bg != null)
            {
               bg.gotoAndStop(1);
            }
            q = s.getChildByName("tQty");
            if(q != null)
            {
               q.visible = false;
            }
            cnt = s.getChildByName("cnt") as DisplayObjectContainer;
            while(cnt != null && cnt.numChildren > 0)
            {
               cnt.removeChildAt(0);
            }
            src = s;
         }
         catch(e:Error)
         {
            src = null;
         }
         return src;
      }

      public static function icon(param1:MovieClip, param2:Object) : DisplayObject
      {
         var link:String;
         var d:DisplayObject;
         var g:MovieClip = param1;
         var o:Object = param2;
         if(o == null)
         {
            return null;
         }
         link = null;
         try
         {
            if(String(o.sType).toLowerCase() == "enhancement")
            {
               link = String(g.getIconBySlot(o.sES));
            }
         }
         catch(e:Error)
         {
            link = null;
         }
         if(link == null || link.length == 0)
         {
            link = MailArt.itemLinkage(o);
         }
         d = MailArt.icon(g,link);
         if(d == null && o.sIcon != null && String(o.sIcon) != link)
         {
            d = MailArt.icon(g,String(o.sIcon));
         }
         if(d == null)
         {
            d = MailArt.icon(g,"iibag");
         }
         return d;
      }

      public function get slotW() : int
      {
         return this.sw;
      }

      public function get slotH() : int
      {
         return this.sh;
      }

      public function show(param1:Object, param2:int, param3:MovieClip) : void
      {
         this.item = param1;
         var _loc3_:String = param1 != null ? String(param1.ItemID) + "|" + String(param1.sIcon) + "|" + String(param1.sFile) : "";
         if(_loc3_ != this.painted)
         {
            this.painted = _loc3_;
            this.paint(param3);
         }
         if(param2 != this.qty)
         {
            this.qty = param2;
            this.drawBadge();
         }
      }

      public function reset() : void
      {
         this.item = null;
         this.key = null;
         this.painted = null;
         this.qty = -1;
         this.pressed = false;
         this.selected = false;
         this.owned = false;
      }

      public function set pressed(param1:Boolean) : void
      {
         if(param1 == this._pressed)
         {
            return;
         }
         this._pressed = param1;
         this.face.scaleX = this.face.scaleY = param1 ? 0.92 : 1;
         this.applyGlow();
      }

      public function set selected(param1:Boolean) : void
      {
         if(param1 == this._selected)
         {
            return;
         }
         this._selected = param1;
         this.applyGlow();
      }

      public function set owned(param1:Boolean) : void
      {
         if(param1 == this._owned)
         {
            return;
         }
         this._owned = param1;
         if(param1 && this.check == null)
         {
            this.check = checkMark(Math.round(this.sh * 0.45));
            this.check.x = Math.round(this.sw / 2 - 1);
            this.check.y = Math.round(-this.sh / 2 + 1);
            this.face.addChild(this.check);
         }
         if(this.check != null)
         {
            this.check.visible = param1;
         }
      }

      public function dispose() : void
      {
         if(this.bmd != null)
         {
            this.bmd.dispose();
         }
         this.bmd = null;
         this.item = null;
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      private function applyGlow() : void
      {
         this.face.filters = this._pressed ? PRESS_GLOW : (this._selected ? SEL_GLOW : null);
      }

      private function drawBadge() : void
      {
         var _loc7_:Graphics = this.badge.graphics;
         _loc7_.clear();
         this.badge.visible = this.qty > 1;
         if(!this.badge.visible)
         {
            return;
         }
         this.badgeTf.text = "x" + this.qty;
         var _loc1_:int = 14;
         var _loc2_:int = Math.max(16,Math.ceil(this.badgeTf.textWidth) + 8);
         _loc7_.lineStyle(1,MailArt.TRIM,1,true);
         _loc7_.beginFill(1118481,0.9);
         _loc7_.drawRoundRect(0,0,_loc2_,_loc1_,_loc1_,_loc1_);
         _loc7_.endFill();
         this.badgeTf.x = Math.round((_loc2_ - this.badgeTf.width) / 2);
         this.badgeTf.y = Math.round((_loc1_ - this.badgeTf.height) / 2);
         this.badge.x = Math.round(this.sw / 2 - _loc2_ - 2);
         this.badge.y = Math.round(this.sh / 2 - _loc1_ - 2);
      }

      private function paint(param1:MovieClip) : void
      {
         var _loc5_:Shape = null;
         var _loc6_:Sprite = null;
         var _loc8_:Number = NaN;
         var _loc9_:Matrix = null;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(this.bmd == null)
         {
            return;
         }
         this.bmd.fillRect(this.bmd.rect,0);
         var _loc1_:MovieClip = slotArt();
         var _loc2_:DisplayObject = icon(param1,this.item);
         if(_loc1_ == null)
         {
            _loc5_ = new Shape();
            NativeArt.menuFace(_loc5_.graphics,this.sw,this.sh,false);
            this.bmd.drawWithQuality(_loc5_,null,null,null,null,true,StageQuality.HIGH);
            if(_loc2_ != null)
            {
               _loc6_ = new Sprite();
               _loc6_.addChild(_loc2_);
               fitIcon(_loc2_,this.sw * ICON_W / REF_W,this.sh * ICON_H / REF_H,this.sw / 2,this.sh / 2);
               this.bmd.drawWithQuality(_loc6_,null,null,null,null,true,StageQuality.HIGH);
            }
            return;
         }
         var _loc3_:DisplayObjectContainer = _loc1_.getChildByName("cnt") as DisplayObjectContainer;
         var _loc4_:DisplayObject = _loc1_.getChildByName("bg");
         try
         {
            if(_loc3_ != null && _loc2_ != null)
            {
               _loc3_.addChild(_loc2_);
               _loc10_ = _loc4_ != null ? _loc4_.width : REF_W;
               _loc11_ = _loc4_ != null ? _loc4_.height : REF_H;
               fitIcon(_loc2_,ICON_W,ICON_H,_loc10_ / 2,_loc11_ / 2);
            }
            _loc8_ = Math.min(this.sw / REF_W,this.sh / REF_H);
            _loc9_ = new Matrix(_loc8_,0,0,_loc8_,(this.sw - REF_W * _loc8_) / 2 - REF_X * _loc8_,(this.sh - REF_H * _loc8_) / 2 - REF_Y * _loc8_);
            this.bmd.drawWithQuality(_loc1_,_loc9_,null,null,null,true,StageQuality.HIGH);
         }
         catch(e:Error)
         {
         }
         if(_loc2_ != null && _loc2_.parent != null)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
      }
   }
}
