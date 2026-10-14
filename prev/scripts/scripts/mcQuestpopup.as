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

   [Embed(source="/_assets/assets.swf", symbol="symbol669")]
   public dynamic class mcQuestpopup extends MovieClip
   {

      public var cnt:MovieClip;

      public var fx2:MovieClip;

      public function mcQuestpopup()
      {
         super();
         addFrameScript(124,this.frame125);
      }

      internal function frame125() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
