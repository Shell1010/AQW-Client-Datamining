package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3872")]
   public dynamic class sp_DVHLaa extends SpellW
   {

      public function sp_DVHLaa()
      {
         super();
         addFrameScript(0,this.frame1,27,this.frame28);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame28() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
