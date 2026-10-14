package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol30")]
   public dynamic class than_a1 extends SpellW
   {

      public function than_a1()
      {
         super();
         addFrameScript(0,this.frame1,34,this.frame35);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame35() : *
      {
         killSpell();
      }
   }
}
