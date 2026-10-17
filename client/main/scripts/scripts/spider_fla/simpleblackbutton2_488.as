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

   [Embed(source="/_assets/assets.swf", symbol="symbol607")]
   public dynamic class simpleblackbutton2_488 extends MovieClip
   {

      public var bg:MovieClip;

      public var fx:MovieClip;

      public var isSelected:Boolean;

      public function simpleblackbutton2_488()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      public function select() : *
      {
         this.isSelected = true;
         this.setCT(this.bg,18278);
      }

      public function unselect() : *
      {
         this.isSelected = false;
         this.setCT(this.bg,65793);
      }

      public function onMouseOver(param1:MouseEvent) : *
      {
         if(!this.isSelected)
         {
            this.fx.visible = true;
         }
      }

      public function onMouseOut(param1:MouseEvent) : *
      {
         this.fx.visible = false;
      }

      public function setCT(param1:*, param2:*) : *
      {
         var _loc1_:* = param1.transform.colorTransform;
         _loc1_.color = param2;
         param1.transform.colorTransform = _loc1_;
      }

      internal function frame1() : *
      {
         this.buttonMode = true;
         this.fx.visible = false;
         this.isSelected = false;
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver,false,0,true);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut,false,0,true);
         stop();
      }
   }
}
