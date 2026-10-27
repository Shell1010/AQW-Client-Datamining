package Assets_20261016r1_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol498")]
   public dynamic class vampirebat_3940 extends MovieClip
   {

      public function vampirebat_3940()
      {
         super();
         addFrameScript(4,this.frame5,21,this.frame22,31,this.frame32);
      }

      internal function frame5() : *
      {
         stop();
      }

      internal function frame22() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }

      internal function frame32() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }
   }
}
