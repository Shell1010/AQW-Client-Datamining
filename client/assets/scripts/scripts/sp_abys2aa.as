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

   [Embed(source="/_assets/assets.swf", symbol="symbol5443")]
   public dynamic class sp_abys2aa extends SpellW
   {

      public function sp_abys2aa()
      {
         super();
         addFrameScript(0,this.frame1,16,this.frame17,17,this.frame18);
      }

      internal function frame1() : *
      {
         MovieClip(parent).init();
      }

      internal function frame17() : *
      {
         if(MovieClip(parent).spellDur > 0)
         {
            gotoAndPlay("Start");
         }
      }

      internal function frame18() : *
      {
         MovieClip(parent).killSpell();
      }
   }
}
