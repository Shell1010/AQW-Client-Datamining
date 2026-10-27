package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7898")]
   public dynamic class ef_coinattack extends SpellW
   {

      public function ef_coinattack()
      {
         super();
         addFrameScript(50,this.frame51);
      }

      internal function frame51() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
