package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3414")]
   public dynamic class critDisplay extends MovieClip
   {

      public var t:MovieClip;

      public function critDisplay()
      {
         super();
         addFrameScript(24,this.frame25);
      }

      internal function frame25() : *
      {
         try
         {
            MovieClip(parent).removeChild(this);
         }
         catch(e:*)
         {
         }
         stop();
      }
   }
}
