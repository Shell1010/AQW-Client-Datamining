package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7949")]
   public dynamic class ef_binkyrun extends SpellW
   {

      public function ef_binkyrun()
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
