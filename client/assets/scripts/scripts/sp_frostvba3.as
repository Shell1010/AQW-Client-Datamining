package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3255")]
   public dynamic class sp_frostvba3 extends SpellW
   {

      public function sp_frostvba3()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame10() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
