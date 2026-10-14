package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5254")]
   public dynamic class sp_ArcInva2 extends SpellW
   {

      public function sp_ArcInva2()
      {
         super();
         addFrameScript(30,this.frame31);
      }

      internal function frame31() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
