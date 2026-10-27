package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4375")]
   public dynamic class sp_classm5 extends SpellW
   {

      public function sp_classm5()
      {
         super();
         addFrameScript(0,this.frame1,18,this.frame19);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame19() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
