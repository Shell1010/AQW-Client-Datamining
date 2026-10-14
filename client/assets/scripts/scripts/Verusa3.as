package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol414")]
   public dynamic class Verusa3 extends SpellW
   {

      public function Verusa3()
      {
         super();
         addFrameScript(0,this.frame1,49,this.frame50);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame50() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
