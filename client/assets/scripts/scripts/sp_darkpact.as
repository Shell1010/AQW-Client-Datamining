package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4165")]
   public dynamic class sp_darkpact extends SpellW
   {

      public function sp_darkpact()
      {
         super();
         addFrameScript(0,this.frame1,18,this.frame19);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame19() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
