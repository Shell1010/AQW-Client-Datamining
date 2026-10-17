package
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

   [Embed(source="/_assets/assets.swf", symbol="symbol1821")]
   public dynamic class MCACWindow extends MovieClip
   {

      public var btnBuy:SimpleButton;

      public var btnClose:SimpleButton;

      public var btnClose2:SimpleButton;

      public var btnUpgrade:SimpleButton;

      public var txtBody:TextField;

      public var txtHrs:TextField;

      public var rootClass:*;

      public var renewDate:String;

      public function MCACWindow()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,18,this.frame19);
      }

      internal function frame1() : *
      {
         this.rootClass = stage.getChildAt(0);
         stop();
      }

      internal function frame10() : *
      {
         this.renewDate = this.rootClass.world.myAvatar.objData.dUpgExp.toDateString();
         this.txtBody.htmlText = "Your Membership expired on " + this.renewDate + ". Renew your account to get full access to AdventureQuest Worlds! Your upgrade will enable chat, allow you to equip pets, and give you access to exclusive items, areas, weapons, and more.";
         stop();
      }

      internal function frame19() : *
      {
         stop();
      }
   }
}
