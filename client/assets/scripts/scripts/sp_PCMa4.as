package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol1383")]
   public dynamic class sp_PCMa4 extends SpellW
   {

      public function sp_PCMa4()
      {
         super();
         addFrameScript(0,this.frame1,26,this.frame27);
      }

      internal function frame1() : *
      {
         this.scaleX *= 0.7;
         this.scaleY *= 0.7;
      }

      internal function frame27() : *
      {
         stop();
      }
   }
}
