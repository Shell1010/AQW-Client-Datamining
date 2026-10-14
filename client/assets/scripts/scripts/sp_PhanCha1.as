package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6103")]
   public dynamic class sp_PhanCha1 extends SpellW
   {

      public function sp_PhanCha1()
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
