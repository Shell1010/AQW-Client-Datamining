package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7410")]
   public dynamic class ef_ninja1 extends SpellW
   {

      public function ef_ninja1()
      {
         super();
         addFrameScript(22,this.frame23);
      }

      internal function frame23() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
