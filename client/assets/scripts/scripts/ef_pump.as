package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7380")]
   public dynamic class ef_pump extends SpellW
   {

      public function ef_pump()
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
