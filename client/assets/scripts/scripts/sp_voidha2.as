package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol292")]
   public dynamic class sp_voidha2 extends SpellW
   {

      public function sp_voidha2()
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
