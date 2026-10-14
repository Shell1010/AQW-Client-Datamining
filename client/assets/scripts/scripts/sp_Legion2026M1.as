package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2719")]
   public dynamic class sp_Legion2026M1 extends MovieClip
   {

      public function sp_Legion2026M1()
      {
         super();
         addFrameScript(9,this.frame10);
      }

      internal function frame10() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
