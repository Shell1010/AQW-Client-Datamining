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

   [Embed(source="/_assets/assets.swf", symbol="symbol4270")]
   public dynamic class sp_conf extends SpellW
   {

      public function sp_conf()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame16() : *
      {
         MovieClip(parent).killSpell();
      }
   }
}
