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

   [Embed(source="/_assets/assets.swf", symbol="symbol3795")]
   public dynamic class game_1_CMP_Checkboxa10_217 extends MovieClip
   {

      public var checkmark:MovieClip;

      public var chkBtn:SimpleButton;

      public var bitChecked:Boolean;

      public function game_1_CMP_Checkboxa10_217()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      public function onClick(param1:MouseEvent) : *
      {
         this.bitChecked = !this.bitChecked;
         this.checkmark.visible = this.bitChecked;
      }

      internal function frame1() : *
      {
         this.checkmark.mouseEnabled = false;
         this.chkBtn.addEventListener(MouseEvent.CLICK,this.onClick,false,1,true);
      }
   }
}
