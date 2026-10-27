package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3667")]
   public dynamic class sp_EDoT_aa extends SpellW
   {

      public function sp_EDoT_aa()
      {
         super();
         addFrameScript(0,this.frame1,38,this.frame39);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame39() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
