package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol645")]
   public dynamic class sp_sun extends SpellW
   {

      public function sp_sun()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame11() : *
      {
         killSpell();
      }
   }
}
