package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5100")]
   public dynamic class sp_Berserk2026a3 extends MovieClip
   {

      public function sp_Berserk2026a3()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame15() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
