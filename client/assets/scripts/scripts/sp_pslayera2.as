package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1266")]
   public dynamic class sp_pslayera2 extends MovieClip
   {

      public function sp_pslayera2()
      {
         super();
         addFrameScript(29,this.frame30);
      }

      internal function frame30() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
