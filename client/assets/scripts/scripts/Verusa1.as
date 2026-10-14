package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol444")]
   public dynamic class Verusa1 extends SpellW
   {

      public function Verusa1()
      {
         super();
         addFrameScript(0,this.frame1,21,this.frame22);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame22() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
