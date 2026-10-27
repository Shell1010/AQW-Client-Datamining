package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol3641")]
   public dynamic class sp_ee2 extends SpellW
   {

      public function sp_ee2()
      {
         super();
         addFrameScript(0,this.frame1,60,this.frame61);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame61() : *
      {
         killSpell();
         stop();
      }
   }
}
