package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7056")]
   public dynamic class ef_swi extends SpellW
   {

      public function ef_swi()
      {
         super();
         addFrameScript(26,this.frame27);
      }

      internal function frame27() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
