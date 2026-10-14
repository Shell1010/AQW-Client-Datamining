package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol712")]
   public dynamic class sp_ssorc3 extends SpellW
   {

      public function sp_ssorc3()
      {
         super();
         addFrameScript(0,this.frame1,65,this.frame66);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame66() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
