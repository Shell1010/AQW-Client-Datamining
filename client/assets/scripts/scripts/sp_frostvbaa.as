package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3238")]
   public dynamic class sp_frostvbaa extends SpellW
   {

      public function sp_frostvbaa()
      {
         super();
         addFrameScript(0,this.frame1,11,this.frame12);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame12() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
