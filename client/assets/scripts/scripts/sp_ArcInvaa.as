package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5174")]
   public dynamic class sp_ArcInvaa extends SpellW
   {

      public function sp_ArcInvaa()
      {
         super();
         addFrameScript(24,this.frame25);
      }

      internal function frame25() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
