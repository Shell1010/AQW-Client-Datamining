package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol6510")]
   public dynamic class mtl_a2 extends SpellW
   {

      public function mtl_a2()
      {
         super();
         addFrameScript(50,this.frame51);
      }

      internal function frame51() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
