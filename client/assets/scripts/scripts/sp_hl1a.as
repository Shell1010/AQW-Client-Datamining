package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3048")]
   public dynamic class sp_hl1a extends SpellW
   {

      public function sp_hl1a()
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
