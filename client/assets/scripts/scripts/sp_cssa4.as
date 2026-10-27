package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol8037")]
   public dynamic class sp_cssa4 extends SpellW
   {

      public function sp_cssa4()
      {
         super();
         addFrameScript(0,this.frame1,18,this.frame19);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame19() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
