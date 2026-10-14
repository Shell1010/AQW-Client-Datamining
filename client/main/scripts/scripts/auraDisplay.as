package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3420")]
   public dynamic class auraDisplay extends MovieClip
   {

      public var t:MovieClip;

      public function auraDisplay()
      {
         super();
         addFrameScript(34,this.frame35);
      }

      internal function frame35() : *
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
