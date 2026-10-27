package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7804")]
   public dynamic class ef_fw extends MovieClip
   {

      public function ef_fw()
      {
         super();
         addFrameScript(0,this.frame1,49,this.frame50);
      }

      internal function frame1() : *
      {
         this.scaleX *= 0.5;
         this.scaleY *= 0.5;
      }

      internal function frame50() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
