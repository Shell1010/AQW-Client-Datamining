package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol3455")]
   public dynamic class sp_ei3 extends SpellW
   {

      public function sp_ei3()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame30() : *
      {
         killSpell();
      }
   }
}
