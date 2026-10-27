package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6056")]
   public dynamic class sp_PhanChaa extends SpellW
   {

      public function sp_PhanChaa()
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
