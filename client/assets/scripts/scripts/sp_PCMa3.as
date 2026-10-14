package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1399")]
   public dynamic class sp_PCMa3 extends SpellW
   {

      public function sp_PCMa3()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame30() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
