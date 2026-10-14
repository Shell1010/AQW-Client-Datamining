package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1811")]
   public dynamic class sp_necrono_a4 extends SpellW
   {

      public function sp_necrono_a4()
      {
         super();
         addFrameScript(0,this.frame1,39,this.frame40);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame40() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
