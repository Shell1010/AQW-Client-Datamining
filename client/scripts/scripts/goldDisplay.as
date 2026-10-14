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

   [Embed(source="/_assets/assets.swf", symbol="symbol2331")]
   public dynamic class goldDisplay extends MovieClip
   {

      public var t:MovieClip;

      public var tMask:MovieClip;

      public function goldDisplay()
      {
         super();
         addFrameScript(39,this.frame40);
      }

      internal function frame40() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
