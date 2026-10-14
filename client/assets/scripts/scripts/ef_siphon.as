package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol7183")]
   public dynamic class ef_siphon extends SpellW
   {

      public function ef_siphon()
      {
         super();
         addFrameScript(0,this.frame1,35,this.frame36);
      }

      internal function frame1() : *
      {
         this.scaleX *= 0.5;
         this.scaleY *= 0.5;
         this.x -= 40;
         this.y -= 150;
      }

      internal function frame36() : *
      {
         stop();
      }
   }
}
