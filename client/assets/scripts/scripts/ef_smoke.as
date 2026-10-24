package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7283")]
   public dynamic class ef_smoke extends SpellW
   {

      public function ef_smoke()
      {
         super();
         addFrameScript(17,this.frame18);
      }

      internal function frame18() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
