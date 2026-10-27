package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol3937")]
   public dynamic class sp_DVHLa4 extends SpellW
   {

      public function sp_DVHLa4()
      {
         super();
         addFrameScript(0,this.frame1,64,this.frame65);
      }

      internal function frame1() : *
      {
         init();
      }

      internal function frame65() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
