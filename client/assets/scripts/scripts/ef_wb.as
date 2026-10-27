package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7176")]
   public dynamic class ef_wb extends SpellW
   {

      public function ef_wb()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31);
      }

      internal function frame1() : *
      {
         this.scaleX *= 0.5;
         this.scaleY *= 0.5;
         this.y -= 470;
      }

      internal function frame31() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
