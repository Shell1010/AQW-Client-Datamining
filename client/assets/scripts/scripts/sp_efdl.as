package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3529")]
   public dynamic class sp_efdl extends SpellW
   {

      public function sp_efdl()
      {
         super();
         addFrameScript(0,this.frame1,44,this.frame45);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame45() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
