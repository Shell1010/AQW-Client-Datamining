package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol873")]
   public dynamic class sp_shadw1 extends SpellW
   {

      public function sp_shadw1()
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
