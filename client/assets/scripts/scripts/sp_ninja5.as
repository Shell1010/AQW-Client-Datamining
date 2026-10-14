package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1536")]
   public dynamic class sp_ninja5 extends SpellW
   {

      public function sp_ninja5()
      {
         super();
         addFrameScript(0,this.frame1,22,this.frame23);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame23() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
