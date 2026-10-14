package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3814")]
   public dynamic class sp_ea2 extends SpellW
   {

      public function sp_ea2()
      {
         super();
         addFrameScript(0,this.frame1,20,this.frame21);
      }

      internal function frame1() : *
      {
      }

      internal function frame21() : *
      {
         MovieClip(parent).removeChild(this);
      }
   }
}
