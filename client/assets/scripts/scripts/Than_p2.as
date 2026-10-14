package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol110")]
   public dynamic class Than_p2 extends SpellW
   {

      public function Than_p2()
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
