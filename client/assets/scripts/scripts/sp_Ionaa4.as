package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6605")]
   public dynamic class sp_Ionaa4 extends SpellW
   {

      public function sp_Ionaa4()
      {
         super();
         addFrameScript(17,this.frame18);
      }

      internal function frame18() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
