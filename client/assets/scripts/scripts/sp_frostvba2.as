package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3259")]
   public dynamic class sp_frostvba2 extends SpellW
   {

      public function sp_frostvba2()
      {
         super();
         addFrameScript(0,this.frame1,8,this.frame9);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame9() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
