package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4629")]
   public dynamic class sp_chass3 extends SpellW
   {

      public function sp_chass3()
      {
         super();
         addFrameScript(0,this.frame1,28,this.frame29);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame29() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
