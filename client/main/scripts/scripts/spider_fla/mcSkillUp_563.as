package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol4189")]
   public dynamic class mcSkillUp_563 extends MovieClip
   {

      public var rootClass:MovieClip;

      public var c:int;

      public var t:int;

      public function mcSkillUp_563()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,10,this.frame11,41,this.frame42);
      }

      public function fClose() : void
      {
         this.gotoAndStop("reset");
      }

      public function onSkillUpClick(param1:MouseEvent) : void
      {
         this.rootClass.toggleCharpanel("spend");
         this.fClose();
      }

      internal function frame1() : *
      {
         this.visible = false;
         this.x = 961;
         this.rootClass = stage.getChildAt(0) as MovieClip;
         this.c = 0;
         this.t = 60;
         this.addEventListener(MouseEvent.CLICK,this.onSkillUpClick,false,0,true);
         this.buttonMode = true;
         stop();
      }

      internal function frame2() : *
      {
         this.visible = false;
         this.x = 961;
         stop();
      }

      internal function frame11() : *
      {
         this.visible = true;
         this.x = 766;
         this.c = 0;
      }

      internal function frame42() : *
      {
         if(++this.c < this.t)
         {
            this.gotoAndPlay(this.currentFrame - 1);
         }
         else
         {
            this.fClose();
         }
      }
   }
}
