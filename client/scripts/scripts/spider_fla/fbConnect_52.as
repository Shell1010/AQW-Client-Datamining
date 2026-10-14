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

   [Embed(source="/_assets/assets.swf", symbol="symbol3640")]
   public dynamic class fbConnect_52 extends MovieClip
   {

      public var btnClose:SimpleButton;

      public var btnFBCreate:SimpleButton;

      public var btnFBLink:SimpleButton;

      public var frame:MovieClip;

      public var strPassword:TextField;

      public var strUsername:TextField;

      public function fbConnect_52()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      internal function frame1() : *
      {
         this.visible = false;
      }
   }
}
