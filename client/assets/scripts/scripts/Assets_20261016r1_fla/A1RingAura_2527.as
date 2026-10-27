package Assets_20261016r1_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5250")]
   public dynamic class A1RingAura_2527 extends MovieClip
   {

      public function A1RingAura_2527()
      {
         super();
         addFrameScript(8,this.frame9,34,this.frame35,44,this.frame45);
      }

      internal function frame9() : *
      {
         stop();
      }

      internal function frame35() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }

      internal function frame45() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }
   }
}
