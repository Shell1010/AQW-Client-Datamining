package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4693")]
   public dynamic class sp_chaos1 extends SpellW
   {

      public function sp_chaos1()
      {
         super();
         addFrameScript(0,this.frame1,37,this.frame38);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame38() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
