package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2283")]
   public dynamic class sp_Lichp extends MovieClip
   {

      public function sp_Lichp()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame31() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
