package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1417")]
   public dynamic class sp_PCMa2 extends SpellW
   {

      public function sp_PCMa2()
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
