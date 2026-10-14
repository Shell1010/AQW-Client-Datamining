package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1770")]
   public dynamic class sp_newlegiondk extends SpellW
   {

      public function sp_newlegiondk()
      {
         super();
         addFrameScript(0,this.frame1,52,this.frame53);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame53() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
