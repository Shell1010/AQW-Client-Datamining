package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3278")]
   public dynamic class sp_exaltha3 extends SpellW
   {

      public function sp_exaltha3()
      {
         super();
         addFrameScript(0,this.frame1,59,this.frame60);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame60() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
