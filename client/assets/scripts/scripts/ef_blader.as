package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7739")]
   public dynamic class ef_blader extends SpellW
   {

      public function ef_blader()
      {
         super();
         addFrameScript(23,this.frame24);
      }

      internal function frame24() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
