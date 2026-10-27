package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7131")]
   public dynamic class ef_whip extends SpellW
   {

      public function ef_whip()
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
