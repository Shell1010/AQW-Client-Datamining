package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6674")]
   public dynamic class sp_kaa2 extends MovieClip
   {

      public function sp_kaa2()
      {
         super();
         addFrameScript(0,this.frame1,24,this.frame25);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame25() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
