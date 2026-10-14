package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol3490")]
   public dynamic class sp_eh2 extends SpellW
   {

      public function sp_eh2()
      {
         super();
         addFrameScript(0,this.frame1,95,this.frame96,96,this.frame97,97,this.frame98);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame96() : *
      {
         if(spellDur > 0)
         {
            gotoAndPlay("Start");
         }
      }

      internal function frame97() : *
      {
         killSpell();
      }

      internal function frame98() : *
      {
      }
   }
}
