package liteAssets.mobile
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.draw.*;

   public class DropPopover extends Sprite
   {

      public static const ACCEPT:String = "accept";

      public static const DECLINE:String = "decline";

      public static const PREVIEW:String = "preview";

      private static const STAGE_W:int = 960;

      private static const PAD:int = 12;

      private static const GAP:int = 8;

      private static const TEXT_GAP:int = 10;

      private static const EDGE:int = 4;

      private static const RADIUS:int = 16;

      private static const OPEN_MS:int = 120;

      private static const FILL:uint = 723723;

      private static const RIM:uint = 3815994;

      private static const ELL:String = String.fromCharCode(8230);

      private static const AC_GAP:int = 5;

      private static const LIFT:DropShadowFilter = new DropShadowFilter(3,90,0,0.6,10,10,1,2);

      public var key:String;

      public var item:Object;

      private var g:MovieClip;

      private var cb:Function;

      private var pw:int;

      private var ph:int;

      private var bw:int;

      private var bh:int;

      private var iconW:int;

      private var iconH:int;

      private var textX:int;

      private var textW:int;

      private var qty:int = -1;

      private var pivot:Sprite;

      private var win:Sprite;

      private var back:Shape;

      private var iconBox:Sprite;

      private var check:Sprite;

      private var acIcon:DisplayObject;

      private var acW:int = 0;

      private var icR:Rectangle = new Rectangle();

      private var nameTf:TextField;

      private var nameFmt:TextFormat = new TextFormat();

      private var qtyFmt:TextFormat = new TextFormat(null,null,16777215);

      private var acceptBtn:VolumeButton;

      private var declineBtn:VolumeButton;

      private var previewBtn:VolumeButton;

      private var openAt:int = 0;

      public function DropPopover(param1:MovieClip, param2:Function)
      {
         super();
         this.g = param1;
         this.cb = param2;
         tabEnabled = false;
         tabChildren = false;
         this.bh = Mobile.touchPx(8);
         this.bw = Math.max(88,Math.round(this.bh * 1.5));
         var _loc1_:int = Math.max(46,Mobile.touchPx(8));
         var _loc2_:Number = Math.min(_loc1_ / DropSlot.REF_W,DropSlot.slotH(_loc1_) / DropSlot.REF_H);
         this.iconW = Math.round(DropSlot.ICON_W * _loc2_);
         this.iconH = Math.round(DropSlot.ICON_H * _loc2_);
         this.pw = PAD * 2 + this.bw * 3 + GAP * 2;
         this.textX = PAD + this.iconW + TEXT_GAP;
         this.textW = this.pw - PAD - this.textX - 6;
         this.pivot = new Sprite();
         this.win = new Sprite();
         this.pivot.addChild(this.win);
         addChild(this.pivot);
         this.back = new Shape();
         this.back.filters = [LIFT];
         this.win.addChild(this.back);
         this.iconBox = new Sprite();
         this.iconBox.mouseEnabled = false;
         this.iconBox.mouseChildren = false;
         this.iconBox.x = PAD;
         this.win.addChild(this.iconBox);
         this.check = DropSlot.checkMark(Math.round(this.iconH * 0.5));
         this.check.visible = false;
         this.nameTf = MailArt.tf(15,16777215,true);
         this.nameTf.x = this.textX - 2;
         this.win.addChild(this.nameTf);
         this.win.addChild(this.check);
         this.nameTf.text = "Wg";
         this.acIcon = makeAC(Math.round((this.nameTf.height - 4) * 0.8));
         this.nameTf.text = "";
         if(this.acIcon != null)
         {
            this.acIcon.visible = false;
            this.acIcon.x = this.textX;
            this.win.addChild(this.acIcon);
         }
         this.acceptBtn = this.button("Accept",0,this.onAccept);
         this.declineBtn = this.button("Decline",1,this.onDecline);
         this.previewBtn = this.button("Preview",2,this.onPreview);
      }

      private static function makeAC(param1:Number) : DisplayObject
      {
         var _loc3_:Class = null;
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         var _loc4_:Sprite = null;
         try
         {
            _loc3_ = getDefinitionByName("LPFIconCoins") as Class;
            _loc1_ = new _loc3_() as DisplayObject;
            _loc2_ = _loc1_.getBounds(_loc1_);
            if(_loc2_.height <= 0)
            {
               return null;
            }
            _loc1_.scaleX = _loc1_.scaleY = param1 / _loc2_.height;
            _loc4_ = new Sprite();
            _loc4_.mouseEnabled = false;
            _loc4_.mouseChildren = false;
            _loc1_.x = -_loc2_.x * _loc1_.scaleX;
            _loc1_.y = -_loc2_.y * _loc1_.scaleY;
            _loc4_.addChild(_loc1_);
            return _loc4_;
         }
         catch(e:Error)
         {
         }
         return null;
      }

      public function get boxW() : int
      {
         return this.pw;
      }

      public function get boxH() : int
      {
         return this.ph;
      }

      public function open(param1:Object, param2:int, param3:String, param4:Boolean = false) : void
      {
         this.item = param1;
         this.key = param3;
         this.busy = false;
         this.setIcon(param1);
         this.check.visible = param4;
         var _loc4_:Boolean = this.acIcon != null && param1 != null && int(param1.bCoins) == 1;
         if(this.acIcon != null)
         {
            this.acIcon.visible = _loc4_;
         }
         this.acW = _loc4_ ? int(Math.round(this.acIcon.width) + AC_GAP) : 0;
         this.nameTf.x = this.textX - 2 + this.acW;
         this.qty = param2;
         this.setTitle();
         this.layout();
         this.startAnim();
      }

      public function setQty(param1:int) : void
      {
         if(param1 == this.qty)
         {
            return;
         }
         this.qty = param1;
         this.setTitle();
      }

      public function set busy(param1:Boolean) : void
      {
         this.acceptBtn.mouseEnabled = !param1;
         this.acceptBtn.alpha = param1 ? 0.5 : 1;
      }

      public function place(param1:Number, param2:Number, param3:Array) : void
      {
         var _loc5_:Rectangle = null;
         var _loc2_:Number = Math.round(param1 - this.pw / 2);
         var _loc4_:Number = Math.round(param2 - this.ph);
         _loc2_ = Math.max(EDGE,Math.min(STAGE_W - EDGE - this.pw,_loc2_));
         if(_loc4_ < EDGE)
         {
            _loc4_ = Number(EDGE);
         }
         var _loc6_:int = 0;
         while(param3 != null && _loc6_ < param3.length)
         {
            _loc5_ = param3[_loc6_];
            if(!(_loc5_.bottom <= _loc4_ || _loc5_.top >= _loc4_ + this.ph || _loc5_.right <= _loc2_ || _loc5_.left >= _loc2_ + this.pw))
            {
               if(_loc5_.x + _loc5_.width / 2 > param1)
               {
                  _loc2_ = Math.min(_loc2_,_loc5_.left - GAP - this.pw);
               }
               else
               {
                  _loc2_ = Math.max(_loc2_,_loc5_.right + GAP);
               }
            }
            _loc6_++;
         }
         this.x = Math.max(EDGE,Math.min(STAGE_W - EDGE - this.pw,_loc2_));
         this.y = _loc4_;
      }

      public function destroy() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
         this.acceptBtn.removeEventListener(MouseEvent.CLICK,this.onAccept);
         this.declineBtn.removeEventListener(MouseEvent.CLICK,this.onDecline);
         this.previewBtn.removeEventListener(MouseEvent.CLICK,this.onPreview);
         while(this.iconBox.numChildren > 0)
         {
            this.iconBox.removeChildAt(0);
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
         this.cb = null;
         this.g = null;
         this.item = null;
      }

      private function button(param1:String, param2:int, param3:Function) : VolumeButton
      {
         var _loc2_:VolumeButton = new VolumeButton(this.bw,this.bh,param1,13);
         _loc2_.x = PAD + param2 * (this.bw + GAP);
         _loc2_.addEventListener(MouseEvent.CLICK,param3,false,0,true);
         this.win.addChild(_loc2_);
         return _loc2_;
      }

      private function setIcon(param1:Object) : void
      {
         while(this.iconBox.numChildren > 0)
         {
            this.iconBox.removeChildAt(0);
         }
         this.icR.setTo(0,0,this.iconW,this.iconH);
         var _loc3_:DisplayObject = DropSlot.icon(this.g,param1);
         if(_loc3_ == null)
         {
            return;
         }
         var _loc1_:Rectangle = _loc3_.getBounds(_loc3_);
         if(_loc1_.width > 0 && _loc1_.height > 0)
         {
            _loc3_.scaleX = _loc3_.scaleY = Math.min(this.iconW / _loc1_.width,this.iconH / _loc1_.height);
         }
         _loc3_.x = Math.round((this.iconW - _loc1_.width * _loc3_.scaleX) / 2 - _loc1_.x * _loc3_.scaleX);
         _loc3_.y = Math.round((this.iconH - _loc1_.height * _loc3_.scaleY) / 2 - _loc1_.y * _loc3_.scaleY);
         this.iconBox.addChild(_loc3_);
         this.icR = _loc3_.getBounds(this.iconBox);
      }

      private function setTitle() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:String = null;
         var _loc6_:int = 0;
         var _loc5_:String = null;
         var _loc7_:String = this.item != null && this.item.sName != null ? String(this.item.sName) : "";
         var _loc3_:String = " x" + this.qty;
         this.nameTf.text = _loc7_ + _loc3_;
         if(this.nameTf.textWidth > this.textW - this.acW)
         {
            _loc1_ = 0;
            _loc2_ = _loc7_.length - 1;
            _loc4_ = ELL;
            while(_loc1_ <= _loc2_)
            {
               _loc6_ = _loc1_ + _loc2_ >> 1;
               _loc5_ = _loc7_.substr(0,_loc6_).replace(/\s+$/,"") + ELL;
               this.nameTf.text = _loc5_ + _loc3_;
               if(this.nameTf.textWidth <= this.textW - this.acW)
               {
                  _loc4_ = _loc5_;
                  _loc1_ = _loc6_ + 1;
               }
               else
               {
                  _loc2_ = _loc6_ - 1;
               }
            }
            _loc7_ = _loc4_;
            this.nameTf.text = _loc7_ + _loc3_;
         }
         this.nameFmt.color = DropSlot.nameColor(this.item);
         if(_loc7_.length > 0)
         {
            this.nameTf.setTextFormat(this.nameFmt,0,_loc7_.length);
         }
         this.nameTf.setTextFormat(this.qtyFmt,_loc7_.length,this.nameTf.length);
      }

      private function layout() : void
      {
         var _loc5_:VolumeButton = null;
         var _loc7_:Number = this.nameTf.height - 4;
         var _loc3_:int = Math.max(this.iconH,Math.ceil(_loc7_));
         this.iconBox.y = PAD + Math.round((_loc3_ - this.iconH) / 2);
         this.nameTf.y = PAD - 2 + Math.round((_loc3_ - _loc7_) / 2);
         if(this.acIcon != null)
         {
            this.acIcon.y = Math.round(this.nameTf.y + 2 + (_loc7_ - this.acIcon.height) / 2);
         }
         this.check.x = Math.round(this.iconBox.x + this.icR.right + this.iconH * 0.15);
         this.check.y = Math.round(this.iconBox.y + this.icR.top - this.iconH * 0.08);
         var _loc1_:int = PAD + _loc3_ + PAD;
         this.ph = _loc1_ + this.bh + PAD;
         var _loc2_:Array = [this.acceptBtn,this.declineBtn,this.previewBtn];
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.length)
         {
            _loc5_ = _loc2_[_loc4_];
            _loc5_.y = _loc1_;
            TouchTargets.pad(_loc5_,0,0,new Rectangle(_loc5_.x - GAP / 2,_loc1_ - GAP / 2,this.bw + GAP,this.bh + GAP / 2 + PAD));
            _loc4_++;
         }
         var _loc6_:Graphics = this.back.graphics;
         _loc6_.clear();
         _loc6_.lineStyle(1,RIM,1,true);
         _loc6_.beginFill(FILL,0.96);
         _loc6_.drawRoundRect(0,0,this.pw,this.ph,RADIUS,RADIUS);
         _loc6_.endFill();
         this.win.x = -this.pw / 2;
         this.win.y = -this.ph;
         this.pivot.x = this.pw / 2;
         this.pivot.y = this.ph;
      }

      private function startAnim() : void
      {
         this.openAt = getTimer();
         this.pivot.alpha = 0;
         this.pivot.scaleX = this.pivot.scaleY = 0.94;
         addEventListener(Event.ENTER_FRAME,this.onAnim,false,0,true);
      }

      private function onAnim(param1:Event) : void
      {
         var _loc3_:Number = Math.min(1,(getTimer() - this.openAt) / OPEN_MS);
         var _loc1_:Number = 1 - (1 - _loc3_) * (1 - _loc3_);
         this.pivot.alpha = _loc1_;
         this.pivot.scaleX = this.pivot.scaleY = 0.94 + 0.06 * _loc1_;
         if(_loc3_ < 1)
         {
            return;
         }
         removeEventListener(Event.ENTER_FRAME,this.onAnim);
      }

      private function fire(param1:String) : void
      {
         if(this.cb != null)
         {
            this.cb(param1);
         }
      }

      private function onAccept(param1:MouseEvent) : void
      {
         this.fire(ACCEPT);
      }

      private function onDecline(param1:MouseEvent) : void
      {
         this.fire(DECLINE);
      }

      private function onPreview(param1:MouseEvent) : void
      {
         this.fire(PREVIEW);
      }
   }
}
