package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol7897")]
   public dynamic class ef_coinattack2 extends SpellW
   {

      public function ef_coinattack2()
      {
         super();
         addFrameScript(26,this.frame27);
      }

      internal function frame27() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
