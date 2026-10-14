package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3446")]
   public dynamic class iconFlare extends MovieClip
   {

      public var bg:MovieClip;

      public function iconFlare()
      {
         super();
         addFrameScript(8,this.frame9);
      }

      internal function frame9() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
