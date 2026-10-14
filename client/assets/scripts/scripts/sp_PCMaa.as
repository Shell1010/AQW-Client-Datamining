package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1364")]
   public dynamic class sp_PCMaa extends SpellW
   {

      public function sp_PCMaa()
      {
         super();
         addFrameScript(0,this.frame1,57,this.frame58);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame58() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
