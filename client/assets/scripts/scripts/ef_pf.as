package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol7478")]
   public dynamic class ef_pf extends SpellW
   {

      public function ef_pf()
      {
         super();
         addFrameScript(0,this.frame1,69,this.frame70);
      }

      internal function frame1() : *
      {
         this.y -= 50;
      }

      internal function frame70() : *
      {
         stop();
      }
   }
}
