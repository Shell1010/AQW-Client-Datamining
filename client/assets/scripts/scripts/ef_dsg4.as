package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7721")]
   public dynamic class ef_dsg4 extends SpellW
   {

      public function ef_dsg4()
      {
         super();
         addFrameScript(0,this.frame1,22,this.frame23);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame23() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
