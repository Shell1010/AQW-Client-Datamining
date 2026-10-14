package spider_fla
{
   import flash.accessibility.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol3956")]
   public dynamic class Symbol25_319 extends MovieClip
   {

      public var buttons:Array;

      public function Symbol25_319()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      internal function frame1() : *
      {
         this.buttons = new Array({
            "txt":"Temp Inventory",
            "fct":"toggleTempInventory"
         },{
            "txt":"Quests",
            "fct":"rootClass.world.toggleQuestLog"
         },{"txt":"Quests"});
      }
   }
}
