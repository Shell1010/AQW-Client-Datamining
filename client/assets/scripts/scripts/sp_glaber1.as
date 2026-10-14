package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3159")]
   public dynamic class sp_glaber1 extends SpellW
   {

      public function sp_glaber1()
      {
         super();
         addFrameScript(0,this.frame1,23,this.frame24);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame24() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
