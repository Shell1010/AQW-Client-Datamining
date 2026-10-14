package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3405")]
   public dynamic class LevelUpDisplay extends MovieClip
   {

      public var t:MovieClip;

      public function LevelUpDisplay()
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
