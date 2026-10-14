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

   [Embed(source="/_assets/assets.swf", symbol="symbol2488")]
   public dynamic class uProto extends MovieClip
   {

      public var t1:MovieClip;

      public function uProto()
      {
         super();
         addFrameScript(0,this.frame1,100,this.frame101);
      }

      internal function frame1() : *
      {
         stop();
      }

      internal function frame101() : *
      {
         try
         {
            if(parent != null)
            {
               parent.removeChild(this);
            }
         }
         catch(e:Error)
         {
         }
         stop();
      }
   }
}
