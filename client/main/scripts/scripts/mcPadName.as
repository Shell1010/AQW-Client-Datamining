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

   [Embed(source="/_assets/assets.swf", symbol="symbol746")]
   public dynamic class mcPadName extends MovieClip
   {

      public var cnt:MovieClip;

      public var isOn:*;

      public function mcPadName()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,9,this.frame10,19,this.frame20);
      }

      internal function frame1() : *
      {
         visible = false;
         this.isOn = false;
         stop();
      }

      internal function frame5() : *
      {
         visible = true;
      }

      internal function frame10() : *
      {
         stop();
      }

      internal function frame20() : *
      {
         visible = false;
         stop();
      }
   }
}
