package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol622")]
   public dynamic class sp_UUG25a3 extends SpellW
   {

      public function sp_UUG25a3()
      {
         super();
         addFrameScript(0,this.frame1,31,this.frame32);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame32() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
