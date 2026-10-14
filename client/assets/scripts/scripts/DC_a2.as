package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol7810")]
   public dynamic class DC_a2 extends SpellW
   {

      public function DC_a2()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame14() : *
      {
         killSpell();
      }
   }
}
