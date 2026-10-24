package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7785")]
   public dynamic class ef_goldenpig extends SpellW
   {

      public function ef_goldenpig()
      {
         super();
         addFrameScript(37,this.frame38);
      }

      internal function frame38() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
