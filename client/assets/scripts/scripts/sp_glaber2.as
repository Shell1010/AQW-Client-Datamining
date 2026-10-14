package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3108")]
   public dynamic class sp_glaber2 extends SpellW
   {

      public function sp_glaber2()
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
