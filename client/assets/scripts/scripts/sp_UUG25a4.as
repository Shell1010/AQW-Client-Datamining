package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol616")]
   public dynamic class sp_UUG25a4 extends SpellW
   {

      public function sp_UUG25a4()
      {
         super();
         addFrameScript(0,this.frame1,50,this.frame51);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame51() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
