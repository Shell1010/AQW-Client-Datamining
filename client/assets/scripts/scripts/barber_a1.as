package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol8169")]
   public dynamic class barber_a1 extends SpellW
   {

      public function barber_a1()
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
