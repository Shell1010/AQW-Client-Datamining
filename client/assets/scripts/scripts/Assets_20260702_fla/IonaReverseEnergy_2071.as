package Assets_20260702_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6577")]
   public dynamic class IonaReverseEnergy_2071 extends MovieClip
   {

      public function IonaReverseEnergy_2071()
      {
         super();
         addFrameScript(4,this.frame5,30,this.frame31,40,this.frame41);
      }

      internal function frame5() : *
      {
         stop();
      }

      internal function frame31() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }

      internal function frame41() : *
      {
         stop();
         MovieClip(parent).stop();
         parent.parent.removeChild(parent);
      }
   }
}
