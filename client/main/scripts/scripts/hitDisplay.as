package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3443")]
   public dynamic class hitDisplay extends MovieClip
   {

      public var t:MovieClip;

      public function hitDisplay()
      {
         super();
         addFrameScript(19,this.frame20);
      }

      internal function frame20() : *
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
