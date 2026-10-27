package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7584")]
   public dynamic class ef_ms extends SpellW
   {

      public function ef_ms()
      {
         super();
         addFrameScript(0,this.frame1,83,this.frame84);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame84() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
