package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol8162")]
   public dynamic class barber_a2 extends SpellW
   {

      public function barber_a2()
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
