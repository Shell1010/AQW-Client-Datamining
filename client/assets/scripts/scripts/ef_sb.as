package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7354")]
   public dynamic class ef_sb extends SpellW
   {

      public function ef_sb()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame30() : *
      {
         trace("last frame reached");
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
