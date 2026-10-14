package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol5006")]
   public dynamic class sp_bite extends SpellW
   {

      public function sp_bite()
      {
         super();
         addFrameScript(0,this.frame1,39,this.frame40);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame40() : *
      {
         killSpell();
      }
   }
}
