package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4102")]
   public dynamic class sp_DKLa1 extends MovieClip
   {

      public function sp_DKLa1()
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
