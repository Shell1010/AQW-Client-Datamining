package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1457")]
   public dynamic class sp_NotAModa4 extends SpellW
   {

      public function sp_NotAModa4()
      {
         super();
         addFrameScript(20,this.frame21);
      }

      internal function frame21() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
