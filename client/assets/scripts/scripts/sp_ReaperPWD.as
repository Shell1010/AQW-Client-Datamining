package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5991")]
   public dynamic class sp_ReaperPWD extends SpellW
   {

      public function sp_ReaperPWD()
      {
         super();
         addFrameScript(69,this.frame70);
      }

      internal function frame70() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
