package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7114")]
   public dynamic class eg_gt1 extends SpellW
   {

      public function eg_gt1()
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
