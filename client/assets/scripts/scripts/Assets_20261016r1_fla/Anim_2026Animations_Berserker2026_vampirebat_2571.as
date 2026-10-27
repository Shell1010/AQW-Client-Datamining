package Assets_20261016r1_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5078")]
   public dynamic class Anim_2026Animations_Berserker2026_vampirebat_2571 extends MovieClip
   {

      public function Anim_2026Animations_Berserker2026_vampirebat_2571()
      {
         super();
         addFrameScript(16,this.frame17,30,this.frame31,40,this.frame41);
      }

      internal function frame17() : *
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
