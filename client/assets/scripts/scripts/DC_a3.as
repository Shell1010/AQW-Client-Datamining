package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol8005")]
   public dynamic class DC_a3 extends SpellW
   {

      public function DC_a3()
      {
         super();
         addFrameScript(0,this.frame1,32,this.frame33);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame33() : *
      {
         killSpell();
      }
   }
}
