package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol143")]
   public dynamic class sp_ed1old extends SpellW
   {

      public function sp_ed1old()
      {
         super();
         addFrameScript(0,this.frame1,47,this.frame48,49,this.frame50);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame48() : *
      {
         killSpell();
      }

      internal function frame50() : *
      {
         MovieClip(parent).stop();
         stop();
      }
   }
}
