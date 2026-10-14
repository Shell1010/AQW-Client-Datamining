package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1817")]
   public dynamic class sp_necrono_a3 extends SpellW
   {

      public function sp_necrono_a3()
      {
         super();
         addFrameScript(0,this.frame1,20,this.frame21);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame21() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
