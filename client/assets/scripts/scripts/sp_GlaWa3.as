package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6900")]
   public dynamic class sp_GlaWa3 extends SpellW
   {

      public function sp_GlaWa3()
      {
         super();
         addFrameScript(24,this.frame25);
      }

      internal function frame25() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
