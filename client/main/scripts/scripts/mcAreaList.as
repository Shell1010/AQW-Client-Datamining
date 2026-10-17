package
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

   [Embed(source="/_assets/assets.swf", symbol="symbol2751")]
   public dynamic class mcAreaList extends MovieClip
   {

      public var cnt:MovieClip;

      public var cntMask:MovieClip;

      public var title:MovieClip;

      public function mcAreaList()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2,4,this.frame5,19,this.frame20,24,this.frame25);
      }

      internal function frame1() : *
      {
         this.title.gotoAndStop(1);
      }

      internal function frame2() : *
      {
         stop();
      }

      internal function frame5() : *
      {
         this.title.gotoAndPlay("in");
         MovieClip(Game.root).areaListGet();
      }

      internal function frame20() : *
      {
         stop();
      }

      internal function frame25() : *
      {
         this.title.gotoAndPlay("out");
      }
   }
}
