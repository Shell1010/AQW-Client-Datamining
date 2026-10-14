package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5415")]
   public dynamic class sp_apal3 extends SpellW
   {

      public function sp_apal3()
      {
         super();
         addFrameScript(0,this.frame1,28,this.frame29);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame29() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
