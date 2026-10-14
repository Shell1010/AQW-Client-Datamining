package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1221")]
   public dynamic class sp_pslayera3 extends MovieClip
   {

      public function sp_pslayera3()
      {
         super();
         addFrameScript(37,this.frame38);
      }

      internal function frame38() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
