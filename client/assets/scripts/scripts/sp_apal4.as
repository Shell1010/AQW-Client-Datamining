package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5385")]
   public dynamic class sp_apal4 extends SpellW
   {

      public function sp_apal4()
      {
         super();
         addFrameScript(0,this.frame1,40,this.frame41);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame41() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
