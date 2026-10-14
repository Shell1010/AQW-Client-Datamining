package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4310")]
   public dynamic class sp_classm7 extends SpellW
   {

      public function sp_classm7()
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
