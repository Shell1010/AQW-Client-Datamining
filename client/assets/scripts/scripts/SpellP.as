package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;

   public class SpellP extends MovieClip
   {

      public var isSpell:Boolean = true;

      public var sp:int = 20;

      public var dir:int = 1;

      public var world:MovieClip = null;

      public var tMC:MovieClip = null;

      public var strl:String = "";

      public var spellDur:int = 0;

      private var _disposed:Boolean = false;

      public function SpellP()
      {
         super();
      }

      public function init() : void
      {
         if(this._disposed)
         {
            return;
         }
         if(this.dir > 0)
         {
            this.turn("right");
         }
         else
         {
            this.turn("left");
         }
         addEventListener(Event.ENTER_FRAME,this.moveMe,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false,0,true);
      }

      public function turn(strDir:String) : void
      {
         if(strDir == "right" && scaleX < 0 || strDir == "left" && scaleX > 0)
         {
            scaleX *= -1;
         }
      }

      public function killSpell() : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         removeEventListener(Event.ENTER_FRAME,this.moveMe);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         if(parent != null)
         {
            parent.removeChild(this);
         }
         stop();
         this.world = null;
         this.tMC = null;
         this.strl = null;
      }

      public function moveMe(e:Event) : void
      {
         var p:Number = NaN;
         var pi:Point = null;
         if(this._disposed)
         {
            return;
         }
         if(parent == null || this.tMC == null || this.tMC.parent == null)
         {
            this.killSpell();
            return;
         }
         var tcX:Number = this.tMC.x;
         var xBuffer:Number = tcX - x >= 0 ? -width / 2 : width / 2;
         var yBuffer:Number = -this.tMC.mcChar.height * 0.5;
         var sign:int = tcX - x >= 0 ? 1 : -1;
         var pa:Point = new Point(tcX + xBuffer,this.tMC.y + yBuffer);
         var pb:Point = new Point(x,y);
         var d:Number = Point.distance(pa,pb);
         this.sp *= 1.1;
         if(d > this.sp && this.dir == sign)
         {
            p = this.sp / d;
            pi = Point.interpolate(pa,pb,p);
            x = pi.x;
            y = pi.y;
         }
         else
         {
            x = pa.x;
            y = pa.y;
            if(this.world != null)
            {
               this.world.showSpellFXHit({
                  "typ":MovieClip(this).constructor,
                  "tMC":this.tMC,
                  "strl":this.strl
               });
            }
            this.killSpell();
         }
      }

      private function onRemovedFromStage(e:Event) : void
      {
         this.killSpell();
      }
   }
}
