package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7145")]
   public dynamic class ef_skelerun extends SpellW
   {

      public function ef_skelerun()
      {
         super();
         addFrameScript(50,this.frame51);
      }

      internal function frame51() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
