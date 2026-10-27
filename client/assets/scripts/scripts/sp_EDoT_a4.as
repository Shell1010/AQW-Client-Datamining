package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3675")]
   public dynamic class sp_EDoT_a4 extends SpellW
   {

      public function sp_EDoT_a4()
      {
         super();
         addFrameScript(0,this.frame1,54,this.frame55);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame55() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
