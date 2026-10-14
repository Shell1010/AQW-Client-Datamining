package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3813")]
   public dynamic class sp_ea3 extends SpellW
   {

      public function sp_ea3()
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
