package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5828")]
   public dynamic class sp_sofa3 extends MovieClip
   {

      public function sp_sofa3()
      {
         super();
         addFrameScript(30,this.frame31);
      }

      internal function frame31() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
