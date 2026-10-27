package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6269")]
   public dynamic class sp_MaAta1 extends SpellW
   {

      public function sp_MaAta1()
      {
         super();
         addFrameScript(0,this.frame1,20,this.frame21);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame21() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
