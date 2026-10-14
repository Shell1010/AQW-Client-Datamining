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

   [Embed(source="/_assets/assets.swf", symbol="symbol2616")]
   public dynamic class HouseItemHandleMC extends MovieClip
   {

      public var bCancel:MovieClip;

      public var bDelete:MovieClip;

      public var bFlip:MovieClip;

      public var frame:MovieClip;

      public var mDown:Boolean;

      public function HouseItemHandleMC()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      internal function frame1() : *
      {
         this.mDown = false;
      }
   }
}
