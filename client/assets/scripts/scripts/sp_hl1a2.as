package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3025")]
   public dynamic class sp_hl1a2 extends SpellW
   {

      public function sp_hl1a2()
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
