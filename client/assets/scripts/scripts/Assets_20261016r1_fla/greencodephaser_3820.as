package Assets_20261016r1_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1026")]
   public dynamic class greencodephaser_3820 extends MovieClip
   {

      public function greencodephaser_3820()
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
