package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7278")]
   public dynamic class ef_spsb extends SpellW
   {

      public function ef_spsb()
      {
         super();
         addFrameScript(0,this.frame1,23,this.frame24);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame24() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
