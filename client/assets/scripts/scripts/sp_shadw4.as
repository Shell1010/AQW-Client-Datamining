package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol836")]
   public dynamic class sp_shadw4 extends SpellW
   {

      public function sp_shadw4()
      {
         super();
         addFrameScript(0,this.frame1,119,this.frame120);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame120() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
