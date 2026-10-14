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

   [Embed(source="/_assets/assets.swf", symbol="symbol3627")]
   public dynamic class Symbol23copy_65 extends MovieClip
   {

      public var buttons:Array;

      public function Symbol23copy_65()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      internal function frame1() : *
      {
         this.buttons = new Array({
            "txt":"Stats & Class",
            "fct":"rootClass.toggleCharpanel"
         },{
            "txt":"Reputations",
            "fct":"rootClass.showFactionInterface"
         },{
            "txt":"Friends",
            "fct":"rootClass.world.showFriendsList"
         },{
            "txt":"Guild",
            "fct":"rootClass.world.showGuildList"
         },{
            "txt":"Character Page",
            "fct":"charPage"
         },{"txt":"Your Hero"});
      }
   }
}
