package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4717")]
   public dynamic class sp_CardClash extends SpellW
   {

      public function sp_CardClash()
      {
         super();
         addFrameScript(0,this.frame1,27,this.frame28);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame28() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
