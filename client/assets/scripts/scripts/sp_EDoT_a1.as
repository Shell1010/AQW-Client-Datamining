package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3741")]
   public dynamic class sp_EDoT_a1 extends SpellW
   {

      public function sp_EDoT_a1()
      {
         super();
         addFrameScript(0,this.frame1,61,this.frame62);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame62() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
