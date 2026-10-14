package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4666")]
   public dynamic class sp_chaos2 extends SpellW
   {

      public function sp_chaos2()
      {
         super();
         addFrameScript(0,this.frame1,12,this.frame13);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame13() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
