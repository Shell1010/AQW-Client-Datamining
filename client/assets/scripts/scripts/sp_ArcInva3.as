package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5249")]
   public dynamic class sp_ArcInva3 extends SpellW
   {

      public function sp_ArcInva3()
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
