package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4009")]
   public dynamic class sp_drak4 extends SpellW
   {

      public function sp_drak4()
      {
         super();
         addFrameScript(0,this.frame1,56,this.frame57);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame57() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
