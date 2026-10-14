package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6684")]
   public dynamic class sp_Ionaa2 extends SpellW
   {

      public function sp_Ionaa2()
      {
         super();
         addFrameScript(13,this.frame14);
      }

      internal function frame14() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
