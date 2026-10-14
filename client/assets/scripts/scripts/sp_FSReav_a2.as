package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3191")]
   public dynamic class sp_FSReav_a2 extends SpellW
   {

      public function sp_FSReav_a2()
      {
         super();
         addFrameScript(0,this.frame1,20,this.frame21);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame21() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
