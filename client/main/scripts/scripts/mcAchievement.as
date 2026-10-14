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

   [Embed(source="/_assets/assets.swf", symbol="symbol1858")]
   public dynamic class mcAchievement extends MovieClip
   {

      public var cnt:MovieClip;

      public var fx2:MovieClip;

      public function mcAchievement()
      {
         super();
         addFrameScript(122,this.frame123);
      }

      internal function frame123() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
