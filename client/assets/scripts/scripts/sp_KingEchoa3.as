package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2874")]
   public dynamic class sp_KingEchoa3 extends MovieClip
   {

      public function sp_KingEchoa3()
      {
         super();
         addFrameScript(0,this.frame1,18,this.frame19);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame19() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
