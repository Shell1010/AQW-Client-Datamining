package
{
   [Embed(source="/_assets/assets.swf", symbol="symbol4782")]
   public dynamic class sp_C1 extends SpellW
   {

      public function sp_C1()
      {
         super();
         addFrameScript(39,this.frame40);
      }

      internal function frame40() : *
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
         stop();
      }
   }
}
