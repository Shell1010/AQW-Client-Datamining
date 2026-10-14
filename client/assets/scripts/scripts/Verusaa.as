package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol352")]
   public dynamic class Verusaa extends SpellW
   {

      public function Verusaa()
      {
         super();
         addFrameScript(0,this.frame1,42,this.frame43);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame43() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
