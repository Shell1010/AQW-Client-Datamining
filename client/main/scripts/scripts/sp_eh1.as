package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3384")]
   public dynamic class sp_eh1 extends MovieClip
   {

      public function sp_eh1()
      {
         super();
         addFrameScript(35,this.frame36);
      }

      internal function frame36() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
