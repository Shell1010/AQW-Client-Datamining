package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3232")]
   public dynamic class sp_FSReav_a1 extends SpellW
   {

      public function sp_FSReav_a1()
      {
         super();
         addFrameScript(0,this.frame1,16,this.frame17);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame17() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
