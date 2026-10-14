package Assets_20260702_fla
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

   [Embed(source="/_assets/assets.swf", symbol="symbol3566")]
   public dynamic class FlameShield3_2946 extends MovieClip
   {

      public function FlameShield3_2946()
      {
         super();
         addFrameScript(0,this.frame1,28,this.frame29,29,this.frame30);
      }

      internal function frame1() : *
      {
         MovieClip(parent).init();
      }

      internal function frame29() : *
      {
         if(MovieClip(parent).spellDur > 0)
         {
            gotoAndPlay("Start");
         }
      }

      internal function frame30() : *
      {
         MovieClip(parent).killSpell();
      }
   }
}
