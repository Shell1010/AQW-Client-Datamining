package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5785")]
   public dynamic class sp_sofa4 extends MovieClip
   {

      public function sp_sofa4()
      {
         super();
         addFrameScript(51,this.frame52);
      }

      internal function frame52() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
