package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1131")]
   public dynamic class sp_pslayeraa extends MovieClip
   {

      public function sp_pslayeraa()
      {
         super();
         addFrameScript(13,this.frame14);
      }

      internal function frame14() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
