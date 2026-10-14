package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2274")]
   public dynamic class sp_lightc1 extends SpellW
   {

      public function sp_lightc1()
      {
         super();
         addFrameScript(0,this.frame1,33,this.frame34);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame34() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
