package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol3550")]
   public dynamic class sp_ef5 extends SpellW
   {

      public function sp_ef5()
      {
         super();
         addFrameScript(0,this.frame1,22,this.frame23);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame23() : *
      {
         killSpell();
      }
   }
}
