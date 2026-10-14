package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol3614")]
   public dynamic class sp_ef2 extends SpellW
   {

      public function sp_ef2()
      {
         super();
         addFrameScript(0,this.frame1,64,this.frame65,73,this.frame74);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame65() : *
      {
         killSpell();
      }

      internal function frame74() : *
      {
         stop();
      }
   }
}
