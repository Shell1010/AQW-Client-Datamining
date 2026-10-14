package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2158")]
   public dynamic class sp_moga4 extends SpellW
   {

      public function sp_moga4()
      {
         super();
         addFrameScript(0,this.frame1,79,this.frame80);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame80() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
