package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6846")]
   public dynamic class sp_Ionaa3 extends SpellW
   {

      public function sp_Ionaa3()
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
