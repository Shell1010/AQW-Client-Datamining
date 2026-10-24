package Assets_20261016_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5711")]
   public dynamic class Anim_2026Animations_ScionofFlame_SOFAura2_2426 extends MovieClip
   {

      public function Anim_2026Animations_ScionofFlame_SOFAura2_2426()
      {
         super();
         addFrameScript(4,this.frame5,30,this.frame31,40,this.frame41);
      }

      internal function frame5() : *
      {
         stop();
      }

      internal function frame31() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }

      internal function frame41() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }
   }
}
