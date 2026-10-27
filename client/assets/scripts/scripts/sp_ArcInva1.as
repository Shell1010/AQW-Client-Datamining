package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5260")]
   public dynamic class sp_ArcInva1 extends SpellW
   {

      public function sp_ArcInva1()
      {
         super();
         addFrameScript(39,this.frame40);
      }

      internal function frame40() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
