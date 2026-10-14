package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol156")]
   public dynamic class sp_wtr extends SpellW
   {

      public function sp_wtr()
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
