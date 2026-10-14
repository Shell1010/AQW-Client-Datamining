package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3090")]
   public dynamic class sp_glaber4 extends SpellW
   {

      public function sp_glaber4()
      {
         super();
         addFrameScript(0,this.frame1,240,this.frame241);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame241() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
