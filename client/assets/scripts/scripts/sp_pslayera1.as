package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1291")]
   public dynamic class sp_pslayera1 extends MovieClip
   {

      public function sp_pslayera1()
      {
         super();
         addFrameScript(26,this.frame27);
      }

      internal function frame27() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
