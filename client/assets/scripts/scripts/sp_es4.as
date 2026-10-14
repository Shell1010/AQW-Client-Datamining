package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3378")]
   public dynamic class sp_es4 extends SpellW
   {

      public function sp_es4()
      {
         super();
         addFrameScript(21,this.frame22);
      }

      internal function frame22() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
