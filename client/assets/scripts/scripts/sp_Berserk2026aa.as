package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5024")]
   public dynamic class sp_Berserk2026aa extends SpellW
   {

      public function sp_Berserk2026aa()
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
