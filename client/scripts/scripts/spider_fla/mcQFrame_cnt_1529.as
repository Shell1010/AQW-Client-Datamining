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

   [Embed(source="/_assets/assets.swf", symbol="symbol738")]
   public dynamic class mcQFrame_cnt_1529 extends MovieClip
   {

      public var aMask:MovieClip;

      public var bMask:MovieClip;

      public var bg:MovieClip;

      public var btns:MovieClip;

      public var core:MovieClip;

      public var qList:MovieClip;

      public var scr:MovieClip;

      public var strTitle:TextField;

      public var mc:*;

      public function mcQFrame_cnt_1529()
      {
         super();
         addFrameScript(4,this.frame5,9,this.frame10,10,this.frame11,14,this.frame15,21,this.frame22,35,this.frame36,46,this.frame47,52,this.frame53,57,this.frame58,66,this.frame67);
      }

      internal function frame5() : *
      {
         stop();
      }

      internal function frame10() : *
      {
         MovieClip(parent).showQuestList();
         this.bg.resizeTo(326,379);
      }

      internal function frame11() : *
      {
         stop();
      }

      internal function frame15() : *
      {
         MovieClip(parent).showQuestList();
      }

      internal function frame22() : *
      {
         stop();
      }

      internal function frame36() : *
      {
         MovieClip(parent).showQuestDetail();
         this.bg.resizeTo(326,379);
      }

      internal function frame47() : *
      {
         stop();
      }

      internal function frame53() : *
      {
         stop();
      }

      internal function frame58() : *
      {
         MovieClip(parent).killDetailUI();
      }

      internal function frame67() : *
      {
         this.mc = MovieClip(parent);
         if(this.mc.qData != null)
         {
            gotoAndPlay("detail");
         }
         else
         {
            gotoAndPlay("list");
         }
      }
   }
}
