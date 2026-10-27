package
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol7007")]
   public dynamic class sp_HBVa3 extends SpellW
   {

      public var pAV:*;

      public function sp_HBVa3()
      {
         super();
         addFrameScript(0,this.frame1,28,this.frame29);
      }

      internal function frame1() : *
      {
         init();
         try
         {
            this.pAV = MovieClip(this.stage.getChildAt(0)).world.myAvatar;
         }
         catch(e:Error)
         {
         }
      }

      internal function frame29() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
