package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4228")]
   public dynamic class sp_corruptchaa extends SpellW
   {

      public function sp_corruptchaa()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame25() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
