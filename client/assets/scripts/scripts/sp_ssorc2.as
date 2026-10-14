package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol732")]
   public dynamic class sp_ssorc2 extends SpellW
   {

      public function sp_ssorc2()
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
