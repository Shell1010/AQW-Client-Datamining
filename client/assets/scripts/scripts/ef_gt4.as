package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7692")]
   public dynamic class ef_gt4 extends SpellW
   {

      public function ef_gt4()
      {
         super();
         addFrameScript(35,this.frame36);
      }

      internal function frame36() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
