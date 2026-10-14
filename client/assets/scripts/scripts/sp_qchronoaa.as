package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol961")]
   public dynamic class sp_qchronoaa extends SpellW
   {

      public function sp_qchronoaa()
      {
         super();
         addFrameScript(0,this.frame1,43,this.frame44);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame44() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
