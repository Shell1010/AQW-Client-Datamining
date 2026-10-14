package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1462")]
   public dynamic class sp_ninjaa1 extends SpellW
   {

      public function sp_ninjaa1()
      {
         super();
         addFrameScript(8,this.frame9);
      }

      internal function frame9() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
