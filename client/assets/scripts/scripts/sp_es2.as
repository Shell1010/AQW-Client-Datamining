package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3390")]
   public dynamic class sp_es2 extends SpellW
   {

      public function sp_es2()
      {
         super();
         addFrameScript(26,this.frame27);
      }

      internal function frame27() : *
      {
         stop();
         MovieClip(parent).removeChild(this);
      }
   }
}
