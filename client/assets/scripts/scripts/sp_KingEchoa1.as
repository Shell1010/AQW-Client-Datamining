package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2945")]
   public dynamic class sp_KingEchoa1 extends MovieClip
   {

      public function sp_KingEchoa1()
      {
         super();
         addFrameScript(24,this.frame25);
      }

      internal function frame25() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
