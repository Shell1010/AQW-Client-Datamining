package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol2970")]
   public dynamic class sp_inver3 extends SpellW
   {

      public function sp_inver3()
      {
         super();
         addFrameScript(0,this.frame1,26,this.frame27);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame27() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
