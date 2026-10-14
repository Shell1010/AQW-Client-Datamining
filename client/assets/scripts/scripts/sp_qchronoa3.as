package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1068")]
   public dynamic class sp_qchronoa3 extends SpellW
   {

      public function sp_qchronoa3()
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
