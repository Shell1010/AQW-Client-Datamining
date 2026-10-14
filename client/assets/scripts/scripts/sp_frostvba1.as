package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3261")]
   public dynamic class sp_frostvba1 extends SpellW
   {

      public function sp_frostvba1()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame11() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
