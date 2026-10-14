package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4607")]
   public dynamic class sp_Chavenge_a1 extends SpellW
   {

      public function sp_Chavenge_a1()
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
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
