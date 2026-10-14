package Assets_20260702_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol393")]
   public dynamic class verusanima4aura_3931 extends MovieClip
   {

      public function verusanima4aura_3931()
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
