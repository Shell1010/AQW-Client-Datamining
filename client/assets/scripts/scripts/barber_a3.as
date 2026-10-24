package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol8146")]
   public dynamic class barber_a3 extends SpellW
   {

      public function barber_a3()
      {
         super();
         addFrameScript(0,this.frame1,44,this.frame45);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame45() : *
      {
         killSpell();
      }
   }
}
