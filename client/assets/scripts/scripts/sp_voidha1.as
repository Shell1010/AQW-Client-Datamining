package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol316")]
   public dynamic class sp_voidha1 extends SpellW
   {

      public function sp_voidha1()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame31() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
