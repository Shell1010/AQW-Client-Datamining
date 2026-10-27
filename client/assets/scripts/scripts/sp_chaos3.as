package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4656")]
   public dynamic class sp_chaos3 extends SpellW
   {

      public function sp_chaos3()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame30() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
