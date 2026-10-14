package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2429")]
   public dynamic class sp_Licha2 extends SpellW
   {

      public function sp_Licha2()
      {
         super();
         addFrameScript(0,this.frame1,16,this.frame17);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame17() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
