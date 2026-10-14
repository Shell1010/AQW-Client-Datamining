package
{
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2773")]
   public class CastBarMC extends MovieClip
   {

      public var cnt:MovieClip;

      public var o:Object = null;

      public var isOpen:Boolean = false;

      public var callback:Object = null;

      public var state:int = -1;

      public var dur:int = 1000;

      private var world:MovieClip;

      private var rootClass:MovieClip;

      private var mc:MovieClip;

      private var run:int;

      private var ts:Number;

      private var date:Date;

      public function CastBarMC()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,5,this.frame6,9,this.frame10);
      }

      public function init() : void
      {
         this.mc = MovieClip(this);
         this.rootClass = MovieClip(stage.getChildAt(0));
      }

      public function fOpenWith(param1:*) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         this.o = param1;
         this.isOpen = true;
         switch(this.o.typ)
         {
            case "sia":
               this.state = this.o.args.ID;
            case "generic":
               this.mc.cnt.t1.text = this.o.txt;
               _loc1_ = this.mc.cnt.fill;
               _loc2_ = this.mc.cnt.fillMask;
               _loc2_.x = int(_loc1_.x - _loc2_.width);
               this.run = int(_loc1_.x - _loc2_.x);
               this.date = new Date();
               this.ts = Number(this.date.getTime());
               this.dur = int(1000 * this.o.dur);
               _loc2_.removeEventListener(Event.ENTER_FRAME,this.slide);
               _loc2_.addEventListener(Event.ENTER_FRAME,this.slide);
               this.mc.cnt.tip.removeEventListener(Event.ENTER_FRAME,this.tipFollow);
               this.mc.cnt.tip.addEventListener(Event.ENTER_FRAME,this.tipFollow);
               this.mc.gotoAndPlay("in");
         }
      }

      public function fClose() : void
      {
         var _loc1_:* = undefined;
         if(this.isOpen)
         {
            this.o = null;
            this.state = -1;
            this.isOpen = false;
            _loc1_ = this.mc.cnt.fillMask;
            _loc1_.removeEventListener(Event.ENTER_FRAME,this.slide);
            this.mc.cnt.tip.removeEventListener(Event.ENTER_FRAME,this.tipFollow);
            this.mc.gotoAndPlay("out");
            this.rootClass.world.myAvatar.pMC.endAction();
         }
      }

      private function slide(param1:Event) : void
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         this.date = new Date();
         var _loc2_:* = this.date.getTime() - this.ts;
         var _loc3_:* = _loc2_ / this.dur;
         if(_loc3_ >= 1)
         {
            this.mc.gotoAndPlay("out");
            _loc1_.removeEventListener(Event.ENTER_FRAME,this.slide);
            this.mc.cnt.tip.removeEventListener(Event.ENTER_FRAME,this.tipFollow);
            this.fCallback();
            this.fClose();
         }
         else
         {
            _loc1_.x = this.mc.cnt.fill.x - this.mc.cnt.fillMask.width + this.run * _loc3_;
         }
      }

      private function tipFollow(param1:Event) : void
      {
         var _loc1_:* = this.mc.cnt.tip;
         var _loc2_:* = this.mc.cnt.fillMask;
         _loc1_.x = _loc2_.x + _loc2_.width - _loc1_.width;
      }

      private function fCallback() : void
      {
         if(this.o.msg != null)
         {
            this.rootClass.chatF.pushMsg("event",this.o.msg,"SERVER","",0);
         }
         if(this.o.callback != null)
         {
            if(this.o.args != null)
            {
               this.o.callback(this.o.args);
            }
            else
            {
               this.o.callback();
            }
         }
         if(this.o.xtObj != null)
         {
            this.rootClass.sfc.sendXtMessage("zm",this.o.xtObj.cmd,this.o.xtObj.args,"str",this.rootClass.world.curRoom);
         }
      }

      internal function frame1() : *
      {
         this.cnt.visible = false;
         this.init();
         stop();
      }

      internal function frame5() : *
      {
         this.cnt.visible = true;
         this.cnt.tip.visible = true;
      }

      internal function frame6() : *
      {
         stop();
      }

      internal function frame10() : *
      {
         this.cnt.tip.visible = false;
      }
   }
}
