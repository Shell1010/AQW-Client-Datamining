package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4318")]
   public dynamic class sp_classm6 extends SpellW
   {

      public function sp_classm6()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame16() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
