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

   [Embed(source="/_assets/assets.swf", symbol="symbol2765")]
   public dynamic class mcAreaList_title_270 extends MovieClip
   {

      public var bMinMax:MovieClip;

      public var t1:TextField;

      public function mcAreaList_title_270()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }

      internal function frame1() : *
      {
         this.t1.mouseEnabled = false;
         this.bMinMax.a1.visible = false;
         this.bMinMax.a2.visible = true;
         stop();
      }

      internal function frame10() : *
      {
         this.bMinMax.a1.visible = true;
         this.bMinMax.a2.visible = false;
         stop();
      }
   }
}
