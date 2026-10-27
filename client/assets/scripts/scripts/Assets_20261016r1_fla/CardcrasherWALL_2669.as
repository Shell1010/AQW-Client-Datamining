package Assets_20261016r1_fla
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol4715")]
   public dynamic class CardcrasherWALL_2669 extends MovieClip
   {

      public var w1:MovieClip;

      public var w2:MovieClip;

      public var w3:MovieClip;

      public var chosen:int;

      public function CardcrasherWALL_2669()
      {
         super();
         addFrameScript(0,this.frame1,25,this.frame26);
      }

      public function randomRange(minNum:Number, maxNum:Number) : Number
      {
         return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
      }

      internal function frame1() : *
      {
         this.w1.visible = false;
         this.w2.visible = false;
         this.w3.visible = false;
         trace(this.randomRange(1,3));
         this.chosen = int(this.randomRange(1,3));
         if(this.chosen == 1)
         {
            this.w1.visible = true;
         }
         if(this.chosen == 2)
         {
            this.w2.visible = true;
         }
         if(this.chosen == 3)
         {
            this.w3.visible = true;
         }
      }

      internal function frame26() : *
      {
         stop();
      }
   }
}
