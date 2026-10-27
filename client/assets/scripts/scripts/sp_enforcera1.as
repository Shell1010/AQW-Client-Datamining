package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3418")]
   public dynamic class sp_enforcera1 extends SpellW
   {

      public function sp_enforcera1()
      {
         super();
         addFrameScript(36,this.frame37);
      }

      internal function frame37() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
