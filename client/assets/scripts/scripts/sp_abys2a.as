package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol5444")]
   public dynamic class sp_abys2a extends SpellW
   {

      public function sp_abys2a()
      {
         super();
         addFrameScript(0,this.frame1,16,this.frame17,17,this.frame18);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame17() : *
      {
         if(spellDur > 0)
         {
            gotoAndPlay("Start");
         }
      }

      internal function frame18() : *
      {
         killSpell();
      }
   }
}
