package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol184")]
   public dynamic class sp_voidhaa extends SpellW
   {

      public function sp_voidhaa()
      {
         super();
         addFrameScript(0,this.frame1,27,this.frame28);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame28() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
