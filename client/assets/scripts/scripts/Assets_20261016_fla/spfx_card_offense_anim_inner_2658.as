package Assets_20261016_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4743")]
   public dynamic class spfx_card_offense_anim_inner_2658 extends MovieClip
   {

      public function spfx_card_offense_anim_inner_2658()
      {
         super();
         addFrameScript(4,this.frame5,29,this.frame30,39,this.frame40);
      }

      internal function frame5() : *
      {
         stop();
      }

      internal function frame30() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }

      internal function frame40() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }
   }
}
