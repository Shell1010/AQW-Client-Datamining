package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol899")]
   public dynamic class sp_shadowsGena4 extends SpellW
   {

      public function sp_shadowsGena4()
      {
         super();
         addFrameScript(0,this.frame1,34,this.frame35);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame35() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
