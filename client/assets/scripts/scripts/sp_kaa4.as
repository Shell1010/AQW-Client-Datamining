package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6630")]
   public dynamic class sp_kaa4 extends MovieClip
   {

      public function sp_kaa4()
      {
         super();
         addFrameScript(0,this.frame1,70,this.frame71);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame71() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
