package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4868")]
   public dynamic class sp_blmstraa extends SpellW
   {

      public function sp_blmstraa()
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
