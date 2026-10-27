package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7950")]
   public dynamic class ef_be extends SpellW
   {

      public function ef_be()
      {
         super();
         addFrameScript(0,this.frame1,48,this.frame49);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame49() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
