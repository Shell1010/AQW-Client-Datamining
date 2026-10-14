package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5416")]
   public dynamic class sp_apal1 extends SpellW
   {

      public function sp_apal1()
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
