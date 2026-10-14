package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2179")]
   public dynamic class sp_mod1 extends SpellW
   {

      public function sp_mod1()
      {
         super();
         addFrameScript(35,this.frame36);
      }

      internal function frame36() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
