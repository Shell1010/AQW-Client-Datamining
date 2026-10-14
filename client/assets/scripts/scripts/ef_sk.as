package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7172")]
   public dynamic class ef_sk extends SpellW
   {

      public function ef_sk()
      {
         super();
         addFrameScript(0,this.frame1,115,this.frame116);
      }

      internal function frame1() : *
      {
         this.scaleX *= 0.5;
         this.scaleY *= 0.5;
      }

      internal function frame116() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
