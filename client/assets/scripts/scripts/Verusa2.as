package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol427")]
   public dynamic class Verusa2 extends SpellW
   {

      public function Verusa2()
      {
         super();
         addFrameScript(0,this.frame1,44,this.frame45);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame45() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
