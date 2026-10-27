package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6871")]
   public dynamic class sp_Ionaa1 extends SpellW
   {

      public function sp_Ionaa1()
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
