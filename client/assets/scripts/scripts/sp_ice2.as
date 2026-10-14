package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol2994")]
   public dynamic class sp_ice2 extends SpellW
   {

      public function sp_ice2()
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
