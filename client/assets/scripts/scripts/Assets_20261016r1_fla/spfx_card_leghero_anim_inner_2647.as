package Assets_20261016r1_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4761")]
   public dynamic class spfx_card_leghero_anim_inner_2647 extends MovieClip
   {

      public function spfx_card_leghero_anim_inner_2647()
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
