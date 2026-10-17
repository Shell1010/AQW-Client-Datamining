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

   [Embed(source="/_assets/assets.swf", symbol="symbol2709")]
   public dynamic class mcFactions_cnt_401 extends MovieClip
   {

      public var aMask:MovieClip;

      public var bMask:MovieClip;

      public var bg:MovieClip;

      public var fList:MovieClip;

      public var scr:MovieClip;

      public function mcFactions_cnt_401()
      {
         super();
         addFrameScript(4,this.frame5,9,this.frame10,17,this.frame18);
      }

      internal function frame5() : *
      {
         stop();
      }

      internal function frame10() : *
      {
         MovieClip(parent).showFactionList();
      }

      internal function frame18() : *
      {
         stop();
      }
   }
}
