package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3960")]
   public dynamic class sp_DVHLa3 extends SpellW
   {

      public function sp_DVHLa3()
      {
         super();
         addFrameScript(0,this.frame1,27,this.frame28);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame28() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
