package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2711")]
   public dynamic class sp_Legion2026M2 extends MovieClip
   {

      public function sp_Legion2026M2()
      {
         super();
         addFrameScript(17,this.frame18);
      }

      internal function frame18() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
