package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1200")]
   public dynamic class sp_pslayera4 extends MovieClip
   {

      public function sp_pslayera4()
      {
         super();
         addFrameScript(15,this.frame16);
      }

      internal function frame16() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
