package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;

   public class SpellW extends MovieClip
   {

      public var backfoot:MovieClip;

      public var backhand:MovieClip;

      public var backshin:MovieClip;

      public var backshoulder:MovieClip;

      public var backthigh:MovieClip;

      public var cape:MovieClip;

      public var chest:MovieClip;

      public var flame:MovieClip;

      public var frontfoot:MovieClip;

      public var fronthand:MovieClip;

      public var frontshin:MovieClip;

      public var frontshoulder:MovieClip;

      public var frontthigh:MovieClip;

      public var fx0:MovieClip;

      public var fx1:MovieClip;

      public var fx2:MovieClip;

      public var h1:MovieClip;

      public var h2:MovieClip;

      public var head:MovieClip;

      public var hip:MovieClip;

      public var idlefoot:MovieClip;

      public var inner:MovieClip;

      public var robe:MovieClip;

      public var shadow:MovieClip;

      public var w1:MovieClip;

      public var w2:MovieClip;

      public var w3:MovieClip;

      public var w4:MovieClip;

      public var w5:MovieClip;

      public var w7:MovieClip;

      public var weapon:MovieClip;

      public var isSpell:Boolean = true;

      public var world:MovieClip = null;

      public var tMC:MovieClip = null;

      public var tc:MovieClip = null;

      public var strl:String = "";

      public var spellDur:int = 0;

      public var spellTimer:Timer = null;

      private var _disposed:Boolean = false;

      public function SpellW()
      {
         super();
      }

      public function init() : void
      {
         if(this._disposed)
         {
            return;
         }
         addEventListener(Event.ENTER_FRAME,this.trackTC,false,0,true);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage,false,0,true);
         if(this.spellDur != 0)
         {
            this.spellTimer = new Timer(this.spellDur * 1000,1);
            this.spellTimer.addEventListener(TimerEvent.TIMER,this.onTimer,false,0,true);
            this.spellTimer.start();
         }
      }

      public function killSpell() : void
      {
         if(this._disposed)
         {
            return;
         }
         this._disposed = true;
         removeEventListener(Event.ENTER_FRAME,this.trackTC);
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         if(this.spellTimer != null)
         {
            this.spellTimer.stop();
            this.spellTimer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.spellTimer = null;
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
         stop();
         this.world = null;
         this.tMC = null;
         this.tc = null;
         this.strl = null;
      }

      private function trackTC(e:Event) : void
      {
         if(this._disposed)
         {
            return;
         }
         if(parent == null || this.tMC == null || this.tMC.parent == null)
         {
            this.killSpell();
            return;
         }
         x = this.tMC.x;
         y = this.tMC.y + 3;
      }

      private function onTimer(e:TimerEvent) : void
      {
         this.killSpell();
      }

      private function onRemovedFromStage(e:Event) : void
      {
         this.killSpell();
      }
   }
}
