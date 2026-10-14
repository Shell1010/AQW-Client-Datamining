package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4892")]
   public dynamic class sp_blmstra4 extends SpellW
   {

      public function sp_blmstra4()
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
