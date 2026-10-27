package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol8112")]
   public dynamic class sp_cssa1 extends SpellW
   {

      public function sp_cssa1()
      {
         super();
         addFrameScript(0,this.frame1,60,this.frame61);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame61() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
