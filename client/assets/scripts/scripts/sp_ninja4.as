package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1586")]
   public dynamic class sp_ninja4 extends SpellW
   {

      public function sp_ninja4()
      {
         super();
         addFrameScript(0,this.frame1,23,this.frame24);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame24() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
