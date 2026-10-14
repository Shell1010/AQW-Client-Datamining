package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1101")]
   public dynamic class sp_qchronoa1 extends SpellW
   {

      public function sp_qchronoa1()
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
