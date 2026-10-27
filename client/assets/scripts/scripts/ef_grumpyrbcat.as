package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7721")]
   public dynamic class ef_grumpyrbcat extends SpellW
   {

      public function ef_grumpyrbcat()
      {
         super();
         addFrameScript(40,this.frame41);
      }

      internal function frame41() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
