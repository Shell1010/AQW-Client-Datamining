package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3494")]
   public dynamic class sp_efsb extends SpellW
   {

      public function sp_efsb()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }

      internal function frame1() : *
      {
         this.scaleX *= 0.5;
         this.scaleY *= 0.5;
      }

      internal function frame30() : *
      {
         trace("last frame reached");
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
