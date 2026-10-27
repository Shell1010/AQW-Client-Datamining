package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7077")]
   public dynamic class sp_GlaWa2 extends SpellW
   {

      public function sp_GlaWa2()
      {
         super();
         addFrameScript(22,this.frame23);
      }

      internal function frame23() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
