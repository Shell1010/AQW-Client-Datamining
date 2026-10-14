package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7939")]
   public dynamic class sp_cssa2 extends SpellW
   {

      public function sp_cssa2()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame31() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
