package Assets_20260702_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1039")]
   public dynamic class greencodephaser_3720 extends MovieClip
   {

      public function greencodephaser_3720()
      {
         super();
         addFrameScript(0,this.frame1,25,this.frame26);
      }

      internal function frame1() : *
      {
         gotoAndPlay(Math.round(Math.random() * (this.totalFrames - 1) + 1));
      }

      internal function frame26() : *
      {
         gotoAndPlay("LoopMe");
      }
   }
}
