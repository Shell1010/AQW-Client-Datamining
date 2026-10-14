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

   [Embed(source="/_assets/assets.swf", symbol="symbol3973")]
   public dynamic class charicon_322 extends MovieClip
   {

      public var buttons:Array;

      public function charicon_322()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      internal function frame1() : *
      {
         this.buttons = new Array({
            "txt":"Stats Overview",
            "fct":"rootClass.toggleStatspanel"
         },{
            "txt":"Class Overview",
            "fct":"rootClass.toggleCharpanel"
         },{
            "txt":"Reputations",
            "fct":"rootClass.showFactionInterface"
         },{
            "txt":"Friendships",
            "fct":"rootClass.showFriendshipUI"
         },{
            "txt":"Friends",
            "fct":"rootClass.world.showFriendsList"
         },{
            "txt":"Guild",
            "fct":"rootClass.world.showGuildList"
         },{
            "txt":"Outfits",
            "fct":"rootClass.toggleOutfits"
         },{
            "txt":"Character Page",
            "fct":"charPage"
         },{"txt":"Your Hero"});
      }
   }
}
