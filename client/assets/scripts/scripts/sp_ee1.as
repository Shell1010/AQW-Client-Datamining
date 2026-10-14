package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol3651")]
   public dynamic class sp_ee1 extends SpellW
   {

      public function sp_ee1()
      {
         super();
         addFrameScript(0,this.frame1,57,this.frame58,74,this.frame75);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame58() : *
      {
         killSpell();
      }

      internal function frame75() : *
      {
         stop();
      }
   }
}
