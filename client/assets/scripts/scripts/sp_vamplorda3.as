package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol555")]
   public dynamic class sp_vamplorda3 extends SpellW
   {

      public function sp_vamplorda3()
      {
         super();
         addFrameScript(31,this.frame32);
      }

      internal function frame32() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
