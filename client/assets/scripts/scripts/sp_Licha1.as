package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2439")]
   public dynamic class sp_Licha1 extends SpellW
   {

      public function sp_Licha1()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame11() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
