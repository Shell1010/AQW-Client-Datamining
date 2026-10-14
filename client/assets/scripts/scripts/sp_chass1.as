package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4636")]
   public dynamic class sp_chass1 extends SpellW
   {

      public function sp_chass1()
      {
         super();
         addFrameScript(0,this.frame1,25,this.frame26);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame26() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
