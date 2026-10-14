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

   [Embed(source="/_assets/assets.swf", symbol="symbol529")]
   public dynamic class MCUpgradeWindow extends MovieClip
   {

      public var btnBuy:SimpleButton;

      public var btnClose:SimpleButton;

      public var btnClose2:SimpleButton;

      public var txtBody:TextField;

      public var txtHrs:TextField;

      public var rootClass:*;

      public var iDiff:Number;

      public var iHrs:int;

      public var renewDate:String;

      public var iRemain:int;

      public function MCUpgradeWindow()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10,18,this.frame19);
      }

      internal function frame1() : *
      {
         this.rootClass = stage.getChildAt(0);
         this.iDiff = (this.rootClass.date_server.getTime() - this.rootClass.world.myAvatar.objData.dCreated.getTime()) / 1000;
         this.iHrs = this.iDiff / (60 * 60);
         if(this.iHrs < 72 && !this.rootClass.world.myAvatar.isUpgraded())
         {
            gotoAndPlay("DragonHero");
         }
         else if(this.rootClass.world.myAvatar.hasUpgraded())
         {
            gotoAndPlay("Renew");
         }
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
         this.iRemain = 72 - this.iHrs;
         if(this.iRemain > 1)
         {
            this.txtHrs.text = this.iRemain + " hours";
         }
         else
         {
            this.txtHrs.text = this.iRemain + " hour";
         }
         stop();
      }
   }
}
