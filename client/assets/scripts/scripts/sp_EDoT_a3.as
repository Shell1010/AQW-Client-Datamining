package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3707")]
   public dynamic class sp_EDoT_a3 extends SpellW
   {

      public function sp_EDoT_a3()
      {
         super();
         addFrameScript(0,this.frame1,43,this.frame44);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame44() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
