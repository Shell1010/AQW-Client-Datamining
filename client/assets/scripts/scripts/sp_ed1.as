package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3785")]
   public dynamic class sp_ed1 extends SpellW
   {

      public function sp_ed1()
      {
         super();
         addFrameScript(0,this.frame1,49,this.frame50);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame50() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
