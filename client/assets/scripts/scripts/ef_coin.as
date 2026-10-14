package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7738")]
   public dynamic class ef_coin extends SpellW
   {

      public function ef_coin()
      {
         super();
         addFrameScript(34,this.frame35);
      }

      internal function frame35() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
