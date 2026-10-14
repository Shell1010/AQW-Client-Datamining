package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol763")]
   public dynamic class sp_sp1 extends SpellW
   {

      public function sp_sp1()
      {
         super();
         addFrameScript(0,this.frame1,31,this.frame32,36,this.frame37);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame32() : *
      {
         killSpell();
      }

      internal function frame37() : *
      {
         stop();
      }
   }
}
