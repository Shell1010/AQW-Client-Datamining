package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2456")]
   public dynamic class sp_legPallya4 extends SpellW
   {

      public function sp_legPallya4()
      {
         super();
         addFrameScript(0,this.frame1,21,this.frame22);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame22() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
