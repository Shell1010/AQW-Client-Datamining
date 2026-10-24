package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7603")]
   public dynamic class ef_ic extends SpellW
   {

      public function ef_ic()
      {
         super();
         addFrameScript(0,this.frame1,41,this.frame42);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame42() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
