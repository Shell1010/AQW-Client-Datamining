package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4995")]
   public dynamic class sp_blmstra1 extends SpellW
   {

      public function sp_blmstra1()
      {
         super();
         addFrameScript(0,this.frame1,31,this.frame32);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame32() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
