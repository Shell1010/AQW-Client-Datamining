package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3379")]
   public dynamic class sp_es3 extends SpellW
   {

      public function sp_es3()
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
