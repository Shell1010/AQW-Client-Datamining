package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3173")]
   public dynamic class sp_FSReav_a3 extends SpellW
   {

      public function sp_FSReav_a3()
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
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
