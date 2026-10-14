package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2363")]
   public dynamic class sp_Licha4 extends SpellW
   {

      public function sp_Licha4()
      {
         super();
         addFrameScript(0,this.frame1,14,this.frame15);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame15() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
