package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7807")]
   public dynamic class ef_ab extends SpellW
   {

      public function ef_ab()
      {
         super();
         addFrameScript(0,this.frame1,170,this.frame171);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame171() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
