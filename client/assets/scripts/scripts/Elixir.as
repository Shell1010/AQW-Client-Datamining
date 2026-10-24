package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol8432")]
   public dynamic class Elixir extends MovieClip
   {

      public var iconBoostElix:MovieClip;

      public function Elixir()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      internal function frame1() : *
      {
         stop();
      }
   }
}
