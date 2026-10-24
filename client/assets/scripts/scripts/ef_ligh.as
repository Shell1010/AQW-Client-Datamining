package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7590")]
   public dynamic class ef_ligh extends SpellW
   {

      public function ef_ligh()
      {
         super();
         addFrameScript(22,this.frame23);
      }

      internal function frame23() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
