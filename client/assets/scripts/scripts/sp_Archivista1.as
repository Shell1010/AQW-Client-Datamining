package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5357")]
   public dynamic class sp_Archivista1 extends MovieClip
   {

      public function sp_Archivista1()
      {
         super();
         addFrameScript(22,this.frame23);
      }

      internal function frame23() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
