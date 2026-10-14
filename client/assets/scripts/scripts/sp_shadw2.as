package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol861")]
   public dynamic class sp_shadw2 extends SpellW
   {

      public function sp_shadw2()
      {
         super();
         addFrameScript(0,this.frame1,61,this.frame62);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame62() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
