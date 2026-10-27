package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4481")]
   public dynamic class sp_classm2 extends SpellW
   {

      public function sp_classm2()
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
