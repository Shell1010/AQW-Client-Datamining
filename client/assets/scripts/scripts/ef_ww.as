package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6962")]
   public dynamic class ef_ww extends SpellW
   {

      public function ef_ww()
      {
         super();
         addFrameScript(45,this.frame46);
      }

      internal function frame46() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
