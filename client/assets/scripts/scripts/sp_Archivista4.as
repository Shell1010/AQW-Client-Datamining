package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol5309")]
   public dynamic class sp_Archivista4 extends SpellW
   {

      public function sp_Archivista4()
      {
         super();
         addFrameScript(49,this.frame50);
      }

      internal function frame50() : *
      {
         MovieClip(parent).removeChild(this);
         stop();
      }
   }
}
