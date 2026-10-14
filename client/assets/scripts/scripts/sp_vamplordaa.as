package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol512")]
   public dynamic class sp_vamplordaa extends MovieClip
   {

      public function sp_vamplordaa()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame14() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
