package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5856")]
   public dynamic class sp_sofa2 extends MovieClip
   {

      public function sp_sofa2()
      {
         super();
         addFrameScript(21,this.frame22);
      }

      internal function frame22() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
