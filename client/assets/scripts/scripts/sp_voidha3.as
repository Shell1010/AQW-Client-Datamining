package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol282")]
   public dynamic class sp_voidha3 extends SpellW
   {

      public function sp_voidha3()
      {
         super();
         addFrameScript(0,this.frame1,27,this.frame28);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame28() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
