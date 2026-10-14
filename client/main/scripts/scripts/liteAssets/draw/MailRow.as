package liteAssets.draw
{
   import flash.display.*;
   import flash.geom.*;
   import flash.text.TextField;

   public class MailRow extends Sprite
   {

      private static const H:int = 58;

      private static var mtx:Matrix = new Matrix();

      public var mail:Object;

      private var rowW:Number = 0;

      private var selected:Boolean = false;

      private var hovered:Boolean = false;

      private var bgShape:Sprite;

      private var unreadBar:Sprite;

      private var envHolder:Sprite;

      private var tfSubject:TextField;

      private var tfFrom:TextField;

      private var tfDate:TextField;

      private var tfExp:TextField;

      private var statusHolder:Sprite;

      public function MailRow()
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         this.bgShape = new Sprite();
         addChild(this.bgShape);
         this.unreadBar = new Sprite();
         addChild(this.unreadBar);
         this.envHolder = new Sprite();
         this.envHolder.mouseEnabled = false;
         addChild(this.envHolder);
         this.tfSubject = MailArt.tf(12,12303291,true);
         this.tfSubject.x = 48;
         this.tfSubject.y = 7;
         addChild(this.tfSubject);
         this.tfFrom = MailArt.tf(10,10066329);
         this.tfFrom.x = 48;
         this.tfFrom.y = 25;
         addChild(this.tfFrom);
         this.tfDate = MailArt.tf(10,8947848);
         this.tfDate.x = 48;
         this.tfDate.y = 39;
         addChild(this.tfDate);
         this.tfExp = MailArt.tf(10,16740419);
         this.tfExp.y = 39;
         addChild(this.tfExp);
         this.statusHolder = new Sprite();
         this.statusHolder.mouseEnabled = false;
         this.statusHolder.mouseChildren = false;
         addChild(this.statusHolder);
      }

      public function bind(param1:Object, param2:Number, param3:Boolean, param4:Boolean, param5:Boolean) : void
      {
         this.mail = param1;
         this.rowW = param2;
         this.selected = param3;
         this.drawBG();
         this.drawEnvelope();
         this.drawSubject();
         this.drawFrom();
         this.drawDate();
         this.drawStatus(param4,param5);
      }

      public function setHover(param1:Boolean) : void
      {
         if(this.hovered == param1 || this.mail == null)
         {
            return;
         }
         this.hovered = param1;
         this.drawBG();
      }

      public function destroy() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
         this.bgShape.graphics.clear();
         this.unreadBar.graphics.clear();
         this.envHolder.graphics.clear();
         this.statusHolder.graphics.clear();
         this.mail = null;
      }

      private function drawBG() : void
      {
         var _loc1_:Graphics = this.bgShape.graphics;
         _loc1_.clear();
         if(this.selected)
         {
            mtx.createGradientBox(this.rowW,H,0,0,0);
            _loc1_.beginGradientFill(GradientType.LINEAR,[940643,5971340],[1,1],[0,255],mtx);
            _loc1_.drawRect(0,0,this.rowW,H);
            _loc1_.endFill();
            _loc1_.beginFill(8381420,0.5);
            _loc1_.drawRect(0,0,this.rowW,1);
            _loc1_.endFill();
         }
         else
         {
            mtx.createGradientBox(this.rowW,H,Math.PI / 2,0,0);
            _loc1_.beginGradientFill(GradientType.LINEAR,this.hovered ? [2763306,1644825] : [1776411,986895],[1,1],[0,255],mtx);
            _loc1_.drawRect(0,0,this.rowW,H);
            _loc1_.endFill();
            _loc1_.beginFill(2500134);
            _loc1_.drawRect(0,H - 1,this.rowW,1);
            _loc1_.endFill();
         }
         this.unreadBar.graphics.clear();
         if(this.mail.read != 1)
         {
            this.unreadBar.graphics.beginFill(MailArt.GOLD);
            this.unreadBar.graphics.drawRect(0,0,3,H);
            this.unreadBar.graphics.endFill();
         }
      }

      private function drawEnvelope() : void
      {
         var _loc1_:Boolean = this.mail.read != 1;
         this.envHolder.graphics.clear();
         MailArt.envelope(this.envHolder.graphics,10,18,30,21,!_loc1_,_loc1_);
      }

      private function drawSubject() : void
      {
         var _loc1_:Boolean = this.mail.read != 1;
         this.tfSubject.textColor = _loc1_ ? 16777215 : 12303291;
         this.tfSubject.text = this.mail.subj != null ? String(this.mail.subj) : "";
         MailArt.cover(this.tfSubject);
         MailArt.fit(this.tfSubject,this.rowW - 48 - 30);
      }

      private function drawFrom() : void
      {
         this.tfFrom.text = "From " + (this.mail.from != null ? String(this.mail.from) : "");
         MailArt.cover(this.tfFrom);
         MailArt.fit(this.tfFrom,this.rowW - 48 - 30);
      }

      private function drawDate() : void
      {
         this.tfDate.text = MailArt.dateShort(Number(this.mail.sent));
         var _loc1_:Boolean = this.mail.exp != null && Boolean(MailArt.soon(Number(this.mail.exp)));
         this.tfExp.visible = _loc1_;
         if(_loc1_)
         {
            this.tfExp.text = "  ·  " + MailArt.expiryText(Number(this.mail.exp));
            this.tfExp.x = this.tfDate.x + this.tfDate.width;
         }
      }

      private function drawStatus(param1:Boolean, param2:Boolean) : void
      {
         var _loc1_:Graphics = this.statusHolder.graphics;
         _loc1_.clear();
         var _loc2_:Number = this.rowW - 18;
         var _loc3_:Number = 29;
         if(param2)
         {
            MailArt.gift(_loc1_,_loc2_,_loc3_,16);
         }
         else if(param1 && this.mail.att != null && this.mail.att.length > 0)
         {
            MailArt.check(_loc1_,_loc2_,_loc3_,7);
         }
      }
   }
}
