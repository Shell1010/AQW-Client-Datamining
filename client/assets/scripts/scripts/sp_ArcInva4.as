package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5210")]
   public dynamic class sp_ArcInva4 extends SpellW
   {

      public function sp_ArcInva4()
      {
         super();
         addFrameScript(33,this.frame34);
      }

      internal function frame34() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
