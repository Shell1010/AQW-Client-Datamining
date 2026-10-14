package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3377")]
   public dynamic class RankUpDisplay extends MovieClip
   {

      public var t:MovieClip;

      public function RankUpDisplay()
      {
         super();
         addFrameScript(37,this.frame38);
      }

      internal function frame38() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
