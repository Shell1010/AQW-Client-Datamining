package Assets_20261016_fla
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol8343")]
   public dynamic class comp_BtnGenericRound_1399 extends MovieClip
   {

      public var btnButton:SimpleButton;

      public var mcGray:SimpleButton;

      public var rootClass:MovieClip;

      public var world:*;

      public var isLocked:Boolean;

      public var mc:*;

      public var tt:*;

      public function comp_BtnGenericRound_1399()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }

      public function mouseOverHandler(e:MouseEvent) : *
      {
         this.tt.openWith({"str":this.mc.strToolTip});
      }

      public function mouseOutHandler(e:MouseEvent) : *
      {
         this.tt.close();
      }

      public function onButtonPress(event:MouseEvent) : void
      {
         var intGoodEvil:* = undefined;
         var mc:MovieClip = null;
         var bLocked:* = this.checkQS();
         if(bLocked)
         {
            trace("Quest Button locked no go! QS:" + this.intQS + " / QV:" + this.intQuestValue);
            if(this.strWhyLocked != "")
            {
               this.rootClass.MsgBox.notify(this.strWhyLocked);
            }
         }
         else if(Boolean(this.bitMemberOnly) && !this.rootClass.world.myAvatar.isUpgraded())
         {
            this.rootClass.showUpgradeWindow();
         }
         else
         {
            intGoodEvil = this.rootClass.world.getQuestValue(41);
            if(this.strRestriction == "Good" && intGoodEvil != 1)
            {
               this.rootClass.MsgBox.notify("You are EVIL. Only GOOD characters may do this.");
            }
            else if(this.strRestriction == "Evil" && intGoodEvil != 2)
            {
               this.rootClass.MsgBox.notify("You are GOOD. Only EVIL characters may do this.");
            }
            else if(this.strAction == "GotoAndPlay")
            {
               MovieClip(parent).gotoAndPlay(this.strFrame);
            }
            else if(this.strAction == "GotoAndStop")
            {
               MovieClip(parent).gotoAndStop(this.strFrame);
            }
            else if(this.strAction == "Play")
            {
               MovieClip(parent).play();
            }
            else if(this.strAction == "Play One")
            {
               MovieClip(parent).nextFrame();
            }
            else if(this.strAction == "Close Apop")
            {
               mc = MovieClip(this.rootClass.world.getMovieFront());
               if(mc != null)
               {
                  mc.exit();
               }
            }
            else if(this.strAction == "Item Shop")
            {
               this.rootClass.world.sendLoadShopRequest(this.intID);
            }
            else if(this.strAction == "Hair Shop")
            {
               this.rootClass.world.sendLoadHairShopRequest(this.intID);
            }
            else if(this.strAction == "Enhance Shop")
            {
               this.rootClass.world.sendLoadEnhShopRequest(this.intID);
            }
            else if(this.strAction == "Show Front Movie")
            {
               this.rootClass.world.attachMovieFront(this.strString);
            }
            else if(this.strAction == "/Join")
            {
               this.rootClass.world.gotoTown(this.strString,this.strFrame,this.strPad);
               this.rootClass.world.removeMovieFront();
            }
            else if(this.strAction != "Nothing")
            {
               if(this.strAction == "moveTo")
               {
                  this.rootClass.world.moveToCell(this.strFrame,this.strPad);
               }
            }
         }
         if(this.bitCloseFront == true)
         {
            this.rootClass.world.removeMovieFront();
         }
         if(this.bitCloseUI == true)
         {
            this.rootClass.ui.mcPopup.gotoAndPlay("Init");
         }
      }

      public function checkQS() : Boolean
      {
         var questVal:* = undefined;
         if(this.bQuestLocked)
         {
            questVal = this.rootClass.world.getQuestValue(this.intQS);
            if(questVal >= this.intQuestVal)
            {
               return false;
            }
            return true;
         }
         return false;
      }

      public function setupLock() : *
      {
         switch(this.strLockType)
         {
            case "Gray":
               this.btnButton.visible = false;
               gotoAndStop(3);
               break;
            case "Invis":
               this.visible = false;
         }
      }

      internal function frame1() : *
      {
         this.mc = MovieClip(this);
         trace("Should show tooltip: " + this.bMouseOver);
         if(this.bMouseOver)
         {
            this.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler,false,0,true);
            this.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler,false,0,true);
         }
         trace("added to stage");
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.world = this.rootClass.world;
         this.isLocked = this.checkQS();
         this.tt = this.rootClass.ui.ToolTip;
         if(this.isLocked)
         {
            this.setupLock();
         }
         else
         {
            this.btnButton.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonPress,false,0,true);
         }
         stop();
      }

      internal function frame2() : *
      {
         this.mcGray.addEventListener(MouseEvent.MOUSE_DOWN,this.onButtonPress,false,0,true);
         stop();
      }
   }
}
