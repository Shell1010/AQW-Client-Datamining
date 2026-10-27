package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3352")]
   public dynamic class sp_es5 extends SpellW
   {

      public function sp_es5()
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
