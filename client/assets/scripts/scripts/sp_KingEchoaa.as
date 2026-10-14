package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2747")]
   public dynamic class sp_KingEchoaa extends SpellW
   {

      public function sp_KingEchoaa()
      {
         super();
         addFrameScript(0,this.frame1,23,this.frame24);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame24() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
