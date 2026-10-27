package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol5143")]
   public dynamic class sp_ball extends SpellP
   {

      public function sp_ball()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      internal function frame1() : *
      {
         init();
      }
   }
}
