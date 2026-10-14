package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3409")]
   public dynamic class sp_es extends SpellW
   {

      public function sp_es()
      {
         super();
         addFrameScript(13,this.frame14);
      }

      internal function frame14() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
