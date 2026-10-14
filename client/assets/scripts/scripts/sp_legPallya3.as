package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2522")]
   public dynamic class sp_legPallya3 extends SpellW
   {

      public function sp_legPallya3()
      {
         super();
         addFrameScript(0,this.frame1,35,this.frame36);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame36() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
