package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4803")]
   public dynamic class sp_BTa2 extends SpellW
   {

      public function sp_BTa2()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame14() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
