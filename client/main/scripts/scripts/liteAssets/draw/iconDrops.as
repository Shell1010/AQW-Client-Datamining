package liteAssets.draw
{
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.filters.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2773")]
   public class iconDrops extends MovieClip
   {

      public var border:MovieClip;

      private var alertPending:Boolean = false;

      internal var rootClass:MovieClip;

      private var alertTimer:Timer;

      private var glowFilter:GlowFilter;

      private var alternate:Boolean = false;

      public function iconDrops()
      {
         super();
         this.buttonMode = true;
         this.addEventListener(MouseEvent.CLICK,this.onBtDrop,false,0,true);
         this.glowFilter = new GlowFilter(16777215,1,35,35,1,1,true,false);
         this.alertTimer = new Timer(50);
         this.alertTimer.addEventListener(TimerEvent.TIMER,this.onGlow,false,0,true);
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
      }

      override public function get visible() : Boolean
      {
         return super.visible;
      }

      override public function set visible(param1:Boolean) : void
      {
         super.visible = param1;
         this.resumeAlert();
      }

      private function onAddedToStage(param1:Event) : void
      {
         this.resumeAlert();
      }

      private function resumeAlert() : void
      {
         if(Boolean(this.alertPending) && this.alertTimer != null && !this.alertTimer.running && super.visible && stage != null)
         {
            this.alertTimer.start();
         }
      }

      public function initRoot(param1:MovieClip) : void
      {
         this.rootClass = param1;
      }

      public function onBtDrop(param1:MouseEvent) : void
      {
         this.alertPending = false;
         if(this.alertTimer.running)
         {
            this.alertTimer.stop();
            this.border.filters = [];
         }
         param1.stopPropagation();
         this.rootClass.cDropsUI.onShow();
      }

      public function onAlert() : void
      {
         this.alertPending = true;
         if(this.alertTimer.running)
         {
            return;
         }
         this.glowFilter.strength = 1;
         this.border.filters = [this.glowFilter];
         this.alternate = false;
         if(super.visible && stage != null)
         {
            this.alertTimer.start();
         }
      }

      public function onGlow(param1:TimerEvent) : void
      {
         if(this.rootClass.cDropsUI.isMenuOpen())
         {
            this.alertPending = false;
            this.alertTimer.stop();
            this.border.filters = [];
            return;
         }
         if(!super.visible || stage == null)
         {
            this.alertTimer.stop();
            return;
         }
         this.glowFilter.strength += this.alternate ? 0.05 : -0.05;
         this.border.filters = [this.glowFilter];
         if(this.glowFilter.strength <= 0 || this.glowFilter.strength >= 1)
         {
            this.alternate = this.glowFilter.strength <= 0 ? true : false;
         }
      }

      public function cleanup() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onBtDrop);
         this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.alertPending = false;
         if(this.alertTimer != null)
         {
            this.alertTimer.stop();
            this.alertTimer.removeEventListener(TimerEvent.TIMER,this.onGlow);
            this.alertTimer = null;
         }
         this.border.filters = [];
         this.glowFilter = null;
         this.rootClass = null;
      }
   }
}
