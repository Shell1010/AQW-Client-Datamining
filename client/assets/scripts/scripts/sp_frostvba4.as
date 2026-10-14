package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3240")]
   public dynamic class sp_frostvba4 extends SpellW
   {

      public function sp_frostvba4()
      {
         super();
         addFrameScript(0,this.frame1,52,this.frame53);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame53() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
