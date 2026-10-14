package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1720")]
   public dynamic class sp_ninja1 extends SpellW
   {

      public function sp_ninja1()
      {
         super();
         addFrameScript(0,this.frame1,26,this.frame27);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame27() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
