package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol7998")]
   public dynamic class DC_aa extends SpellW
   {

      public function DC_aa()
      {
         super();
         addFrameScript(0,this.frame1,32,this.frame33);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame33() : *
      {
         killSpell();
      }
   }
}
