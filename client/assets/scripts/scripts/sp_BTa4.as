package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4798")]
   public dynamic class sp_BTa4 extends SpellW
   {

      public function sp_BTa4()
      {
         super();
         addFrameScript(0,this.frame1,37,this.frame38);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame38() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
