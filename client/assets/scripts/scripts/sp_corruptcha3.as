package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4252")]
   public dynamic class sp_corruptcha3 extends SpellW
   {

      public function sp_corruptcha3()
      {
         super();
         addFrameScript(0,this.frame1,32,this.frame33);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame33() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
