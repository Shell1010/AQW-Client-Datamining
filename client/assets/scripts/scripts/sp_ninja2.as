package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1702")]
   public dynamic class sp_ninja2 extends SpellW
   {

      public function sp_ninja2()
      {
         super();
         addFrameScript(0,this.frame1,35,this.frame36);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame36() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
