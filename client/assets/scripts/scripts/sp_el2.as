package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol3438")]
   public dynamic class sp_el2 extends SpellW
   {

      public function sp_el2()
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
