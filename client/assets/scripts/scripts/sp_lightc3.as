package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2229")]
   public dynamic class sp_lightc3 extends SpellW
   {

      public function sp_lightc3()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame30() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
