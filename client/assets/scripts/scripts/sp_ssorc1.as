package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol757")]
   public dynamic class sp_ssorc1 extends SpellW
   {

      public function sp_ssorc1()
      {
         super();
         addFrameScript(0,this.frame1,17,this.frame18);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame18() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
