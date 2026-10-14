package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3091")]
   public dynamic class sp_glaber3 extends SpellW
   {

      public function sp_glaber3()
      {
         super();
         addFrameScript(0,this.frame1,19,this.frame20);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame20() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
