package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.net.*;
   import flash.text.*;
   import liteAssets.draw.*;
   import liteAssets.mobile.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol733")]
   public class QFrameMC extends MovieClip
   {

      private static const CHOICE_GLOW:GlowFilter = new GlowFilter(16763955,1,5,5,2,1,true,false);

      public var cnt:MovieClip;

      public var world:MovieClip;

      public var rootClass:MovieClip;

      public var qData:Object = null;

      internal var qMode:String = null;

      internal var choiceID:int = -1;

      internal var isOpen:Boolean = false;

      internal var mc:MovieClip;

      internal var mDown:Boolean = false;

      internal var hRun:int = 0;

      internal var dRun:int = 0;

      internal var mbY:int = 0;

      internal var mhY:int = 0;

      internal var mbD:int = 0;

      internal var qTouch:TouchScroll;

      internal var qStep:TurnInStepper;

      internal var qly:int = 70;

      internal var qdy:int = 58;

      internal var qla:Array = [];

      internal var qlb:Array = [];

      public var qIDs:Array = [];

      public var sIDs:Array = [];

      public var tIDs:Array = [];

      internal var rewardCount:int = -1;

      public function QFrameMC()
      {
         super();
         addFrameScript(6,this.frame7,11,this.frame12,15,this.frame16);
         this.mc = MovieClip(this);
         this.mc.x = 0;
         this.mc.y = 65;
         this.mc.cnt.bg.btnClose.addEventListener(MouseEvent.CLICK,this.xClick);
         this.mc.cnt.bg.btnTry.visible = false;
         this.mc.cnt.bg.btnPin.visible = false;
         this.mc.cnt.bg.btnWiki.visible = false;
      }

      public function onPin(param1:MouseEvent) : void
      {
         var _loc1_:* = undefined;
         this.rootClass.pinnedQuests = "";
         if(!param1.shiftKey)
         {
            for each(_loc1_ in this.qIDs)
            {
               this.rootClass.pinnedQuests += _loc1_ + ",";
            }
         }
      }

      public function open() : *
      {
         this.rootClass = MovieClip(this.stage.getChildAt(0));
         this.mc.cnt.bg.btnPin.addEventListener(MouseEvent.CLICK,this.onPin,false,0,true);
         this.mc.cnt.bg.btnWiki.addEventListener(MouseEvent.CLICK,this.onWiki,false,0,true);
         this.world = this.rootClass.world;
         this.mc = MovieClip(this);
         this.mc.cnt.bg.fx.visible = false;
         if(this.rootClass.isDialoqueUp())
         {
            this.mc.cnt.bg.fx.visible = true;
         }
         if(!this.isOpen)
         {
            this.isOpen = true;
            this.mc.cnt.gotoAndPlay("intro");
         }
         else
         {
            this.isOpen = false;
            this.fClose();
         }
      }

      public function onWiki(param1:MouseEvent) : void
      {
         if(!this.qData)
         {
            return;
         }
         navigateToURL(new URLRequest("http://aqwwiki.wikidot.com/search:site/a/p/q/" + this.qData.sName),"_blank");
      }

      public function showQuestList() : *
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.killStepper();
         TouchTargets.pad(this.mc.cnt.bg.btnClose);
         this.mc.cnt.bg.btnPin.visible = this.rootClass.litePreference.data.bQuestPin;
         this.mc.cnt.bg.btnWiki.visible = false;
         if(this.qMode == "l" && this.world.getActiveQuests() != "" || this.qMode == "q")
         {
            if(this.qMode == "l")
            {
               this.qIDs = this.world.getActiveQuests().split(",");
            }
            else
            {
               this.qIDs = [];
               _loc1_ = 0;
               while(_loc1_ < this.sIDs.length)
               {
                  this.qIDs.push(this.sIDs[_loc1_]);
                  _loc1_++;
               }
               _loc2_ = 0;
               while(_loc2_ < this.tIDs.length)
               {
                  if(Boolean(this.world.isQuestInProgress(this.tIDs[_loc2_])) && this.qIDs.indexOf(this.tIDs[_loc2_]) == -1)
                  {
                     this.qIDs.push(this.tIDs[_loc2_]);
                  }
                  _loc2_++;
               }
            }
            this.world.checkAllQuestStatus();
            this.buildQuestList();
         }
         else
         {
            this.showEmptyList();
         }
         if(this.mc.cnt.bg.btnPin.visible)
         {
            this.mc.cnt.strTitle.x = 53;
            this.mc.cnt.strTitle.width = 256;
         }
         else
         {
            this.mc.cnt.strTitle.x = 42;
            this.mc.cnt.strTitle.width = 270;
         }
         if(this.qMode == "l")
         {
            this.mc.cnt.strTitle.htmlText = "Current Quests<font color=\"#FF0000\">:</font>";
         }
         if(this.qMode == "q")
         {
            this.mc.cnt.strTitle.htmlText = "Available Quests<font color=\"#FF0000\">:</font>";
         }
         this.mc.cnt.qList.visible = true;
         this.mc.cnt.qList.mHi.visible = false;
         this.mc.cnt.mouseChildren = true;
      }

      private function isQuestAvailable(param1:Object) : Boolean
      {
         if(param1 != null)
         {
            if(param1.bGuild != null && param1.bGuild == 1)
            {
               if(this.rootClass.world.myAvatar.objData.guild == null)
               {
                  return false;
               }
               if(param1.iReqRep > 0 && this.rootClass.world.myAvatar.objData.guild.guildRep < param1.iReqRep)
               {
                  return false;
               }
            }
            if(param1.sField != null && this.world.getAchievement(param1.sField,param1.iIndex) != 0 || param1.iLvl > this.world.myAvatar.objData.intLevel || param1.bUpg == 1 && !this.world.myAvatar.isUpgraded() || param1.iSlot >= 0 && this.world.getQuestValue(param1.iSlot) < Math.abs(param1.iValue) - 1 || param1.iClass > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP || param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
            {
               return false;
            }
            if(param1.QuestID == 3190 && !this.world.myAvatar.isUpgraded())
            {
               if(this.world.getQuestValue(43) < 3)
               {
                  return false;
               }
               if(this.world.getQuestValue(21) < 26)
               {
                  return false;
               }
               if(this.world.getQuestValue(22) < 35)
               {
                  return false;
               }
               if(this.world.getQuestValue(25) < 22)
               {
                  return false;
               }
               if(this.world.getQuestValue(26) < 23)
               {
                  return false;
               }
               if(this.world.getQuestValue(27) < 14)
               {
                  return false;
               }
               if(this.world.getQuestValue(32) < 35)
               {
                  return false;
               }
               if(this.world.getQuestValue(36) < 28)
               {
                  return false;
               }
               if(this.world.getQuestValue(51) < 34 && this.world.getQuestValue(52) < 34)
               {
                  return false;
               }
               if(this.world.getQuestValue(100) < 15)
               {
                  return false;
               }
               if(this.world.getQuestValue(117) < 17)
               {
                  return false;
               }
               if(this.world.getQuestValue(131) < 27)
               {
                  return false;
               }
               if(this.world.getQuestValue(122) < 35)
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }

      private function getQuestListA() : void
      {
         var _loc1_:* = undefined;
         this.qla = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.qIDs.length)
         {
            _loc1_ = this.world.questTree[this.qIDs[_loc2_]];
            this.qla.push(this.isQuestAvailable(_loc1_));
            _loc2_++;
         }
      }

      private function getQuestListB() : void
      {
         var _loc1_:* = undefined;
         this.qlb = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.qIDs.length)
         {
            _loc1_ = this.world.questTree[this.qIDs[_loc2_]];
            this.qlb.push(this.isQuestAvailable(_loc1_));
            _loc2_++;
         }
      }

      private function nextQuestAvailable() : Object
      {
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.qIDs.length)
         {
            if(this.qla[_loc2_] == false && this.qlb[_loc2_] == true)
            {
               _loc1_ = this.world.questTree[this.qIDs[_loc2_]];
            }
            _loc2_++;
         }
         return _loc1_;
      }

      private function hasRequiredItemsForQuest(param1:Object) : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         if(param1.reqd != null && param1.reqd.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < param1.reqd.length)
            {
               _loc2_ = param1.reqd[_loc1_].ItemID;
               _loc3_ = int(param1.reqd[_loc1_].iQty);
               if(this.rootClass.world.invTree[_loc2_] == null || int(this.rootClass.world.invTree[_loc2_].iQty) < _loc3_)
               {
                  return false;
               }
               _loc1_++;
            }
         }
         return true;
      }

      private function getQuestValidationString(param1:Object) : String
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Object = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:* = undefined;
         if(param1.sField != null && this.world.getAchievement(param1.sField,param1.iIndex) != 0)
         {
            if(param1.sField == "im0")
            {
               return "Monthly Quests are only available once per month.";
            }
            if(param1.sField == "iw0")
            {
               return "Weekly Quests reset every Friday morning.";
            }
            return "Daily Quests are only available once per day.";
         }
         if(param1.bUpg == 1 && !this.world.myAvatar.isUpgraded())
         {
            return "Upgrade is required for this quest!";
         }
         if(param1.iSlot >= 0 && this.world.getQuestValue(param1.iSlot) < param1.iValue - 1)
         {
            return "Quest has not been unlocked!";
         }
         if(param1.iLvl > this.world.myAvatar.objData.intLevel)
         {
            return "Unlocks at Level " + param1.iLvl + ".";
         }
         if(param1.iClass > 0 && this.world.myAvatar.getCPByID(param1.iClass) < param1.iReqCP)
         {
            _loc1_ = int(this.rootClass.getRankFromPoints(param1.iReqCP));
            _loc2_ = param1.iReqCP - this.rootClass.arrRanks[_loc1_ - 1];
            if(_loc2_ > 0)
            {
               return "Requires " + _loc2_ + " Class Points on " + param1.sClass + ", Rank " + _loc1_ + ".";
            }
            return "Requires " + (this.rootClass.litePreference.data.bDebugger ? "(" + param1.iClass + ") " : "") + param1.sClass + ", Rank " + _loc1_ + ".";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc3_ = int(this.rootClass.getRankFromPoints(param1.iReqRep));
            _loc4_ = param1.iReqRep - this.rootClass.arrRanks[_loc3_ - 1];
            if(_loc4_ > 0)
            {
               return "Requires " + _loc4_ + " Reputation for " + param1.sFaction + ", Rank " + _loc3_ + ".";
            }
            return "Requires " + param1.sFaction + ", Rank " + _loc3_ + ".";
         }
         if(param1.reqd != null && !this.hasRequiredItemsForQuest(param1))
         {
            _loc5_ = "Required Item(s): ";
            _loc6_ = 0;
            while(_loc6_ < param1.reqd.length)
            {
               _loc7_ = this.world.invTree[param1.reqd[_loc6_].ItemID];
               _loc8_ = int(param1.reqd[_loc6_].iQty);
               if(_loc7_.sES == "ar")
               {
                  _loc9_ = int(this.rootClass.getRankFromPoints(_loc8_));
                  _loc10_ = _loc8_ - this.rootClass.arrRanks[_loc9_ - 1];
                  if(_loc10_ > 0)
                  {
                     _loc5_ += _loc10_ + " Class Points on ";
                  }
                  if(this.rootClass.litePreference.data.bDebugger)
                  {
                     _loc5_ += "(" + param1.reqd[_loc6_].ItemID + ")";
                  }
                  _loc5_ += _loc7_.sName + ", Rank " + _loc9_;
               }
               else
               {
                  if(this.rootClass.litePreference.data.bDebugger)
                  {
                     _loc5_ += "(" + param1.reqd[_loc6_].ItemID + ")";
                  }
                  _loc5_ += _loc7_.sName;
                  if(_loc8_ > 1)
                  {
                     _loc5_ += "x" + _loc8_;
                  }
               }
               _loc5_ += ", ";
               _loc6_++;
            }
            return _loc5_.substr(0,_loc5_.length - 2) + ".";
         }
         return "";
      }

      private function isOneTimeQuestDone(param1:*) : Boolean
      {
         return param1.bOnce == 1 && (param1.iSlot < 0 || this.world.getQuestValue(param1.iSlot) >= param1.iValue);
      }

      private function buildQuestList() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc4_:* = 0;
         var _loc5_:* = 0;
         while(_loc5_ < this.qIDs.length)
         {
            _loc1_ = this.world.questTree[this.qIDs[_loc5_]];
            if(_loc1_ != null && !this.isOneTimeQuestDone(_loc1_))
            {
               _loc2_ = this.mc.cnt.qList.addChild(new qProto());
               _loc3_ = this.rootClass.litePreference.data.bDebugger ? "(" + _loc1_.QuestID + ")" : "";
               if(this.isQuestAvailable(_loc1_))
               {
                  _loc2_.ti.htmlText = "<font color=\'#009900\'><b>" + _loc3_ + _loc1_.sName + "</b></font>";
               }
               else
               {
                  _loc2_.ti.htmlText = "<font color=\'#990000\'><b>" + _loc3_ + _loc1_.sName + "</b></font>";
               }
               _loc2_.addEventListener(MouseEvent.CLICK,this.qListClick);
               _loc2_.QuestID = _loc1_.QuestID;
               if(_loc1_.sTyp != null)
               {
                  _loc2_.ti.htmlText += " <font color=\"#888888\">" + _loc1_.sTyp + "</font>";
               }
               if(_loc1_.status != null)
               {
                  switch(_loc1_.status)
                  {
                     case "p":
                        _loc2_.ti.htmlText += "<font color=\'#888888\'> - In progress</font>";
                        break;
                     case "c":
                        _loc2_.ti.htmlText += "<font color=\'#99FF00\'> - <b>Complete!</b></font>";
                  }
               }
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.iMouseOver,false,0,true);
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.iMouseOut,false,0,true);
               _loc2_.buttonMode = true;
               _loc2_.hit.alpha = 0;
               _loc2_.x = 10;
               if(Mobile.active)
               {
                  QuestLayout.row(_loc2_,_loc4_++);
               }
               else
               {
                  _loc2_.y = _loc5_ * 20;
               }
            }
            _loc5_++;
         }
         if(Mobile.active)
         {
            QuestLayout.rows(this.mc.cnt.qList,_loc4_);
         }
         var _loc6_:* = this.mc.cnt.scr;
         var _loc7_:* = this.mc.cnt.bMask;
         var _loc8_:* = this.mc.cnt.qList;
         _loc6_.h.height = int(_loc6_.b.height / _loc8_.height * _loc6_.b.height);
         this.hRun = _loc6_.b.height - _loc6_.h.height;
         this.dRun = _loc8_.height - _loc6_.b.height + 20;
         _loc6_.h.y = 0;
         _loc8_.oy = _loc8_.y = this.qly;
         _loc6_.visible = false;
         _loc6_.hit.alpha = 0;
         this.mDown = false;
         this.detachTouch();
         if(_loc8_.height > _loc6_.b.height)
         {
            _loc6_.visible = true;
            _loc6_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc6_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc8_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
            this.qTouch = TouchScroll.attach(_loc8_,this.touchPos,this.touchSet,this.touchMax);
         }
         this.mc.cnt.qList.iproto.visible = false;
      }

      private function qListClick(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         this.qData = this.world.questTree[_loc1_.QuestID];
         _loc1_.removeEventListener(MouseEvent.CLICK,this.qListClick);
         _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.iMouseOver);
         _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.iMouseOut);
         this.mc.cnt.gotoAndPlay("out");
         if(this.mc.cnt.qList.hasEventListener(Event.ENTER_FRAME))
         {
            this.mc.cnt.qList.removeEventListener(Event.ENTER_FRAME,this.dEF);
         }
         this.mc.cnt.qList.mouseEnabled = false;
         this.mc.cnt.qList.mouseChildren = false;
      }

      private function showEmptyList() : *
      {
         var _loc1_:* = this.mc.cnt.qList.addChild(new qProto());
         _loc1_.ti.htmlText = "<font color=\"#DDDDDD\">You aren\'t on any quests!</font>";
         _loc1_.hit.alpha = 0;
         _loc1_.x = 10;
         this.mc.cnt.qList.iproto.visible = false;
         this.mc.cnt.scr.visible = false;
      }

      private function isOwned(param1:Boolean, param2:*) : Boolean
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in param1 ? this.rootClass.world.myAvatar.houseitems : this.rootClass.world.myAvatar.items)
         {
            if(_loc1_.ItemID == param2)
            {
               return true;
            }
         }
         if(this.rootClass.world.bankinfo.isItemInBank(param2))
         {
            return true;
         }
         return false;
      }

      public function getCount(param1:String) : int
      {
         var _loc1_:* = undefined;
         if(this.rewardCount != -1)
         {
            return this.rewardCount;
         }
         this.rewardCount = 0;
         for(_loc1_ in this.qData.oRewards[param1])
         {
            ++this.rewardCount;
         }
         return this.rewardCount;
      }

      public function showQuestDetail() : *
      {
         var _loc1_:String = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:* = undefined;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:Class = null;
         var _loc10_:MovieClip = null;
         var _loc11_:GlowFilter = null;
         var _loc12_:Array = null;
         var _loc13_:String = null;
         var _loc14_:Object = null;
         var _loc15_:MovieClip = null;
         var _loc16_:Object = null;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:String = null;
         var _loc20_:String = null;
         var _loc21_:String = null;
         var _loc22_:Object = null;
         var _loc23_:Object = null;
         var _loc24_:* = undefined;
         var _loc25_:Class = null;
         var _loc26_:DisplayObject = null;
         var _loc27_:Rectangle = null;
         var _loc28_:Number = NaN;
         var _loc29_:detailedCheck = null;
         var _loc30_:Rectangle = null;
         var _loc31_:Rectangle = null;
         var _loc32_:Rectangle = null;
         var _loc33_:TextFormat = null;
         var _loc34_:* = undefined;
         this.killStepper();
         TouchTargets.pad(this.mc.cnt.bg.btnClose);
         this.mc.cnt.bg.btnPin.visible = false;
         this.mc.cnt.bg.btnWiki.visible = true;
         if(this.mc.cnt.bg.btnWiki.visible)
         {
            this.mc.cnt.strTitle.x = 53;
            this.mc.cnt.strTitle.width = 256;
         }
         else
         {
            this.mc.cnt.strTitle.x = 42;
            this.mc.cnt.strTitle.width = 270;
         }
         var _loc35_:int = 0;
         this.choiceID = -1;
         this.world.checkAllQuestStatus();
         this.mc.cnt.mouseChildren = true;
         this.mc.cnt.strTitle.text = this.qData.sName;
         var _loc36_:* = this.mc.cnt.core;
         _loc36_.strNote.autoSize = "left";
         _loc36_.strNote.text = this.getQuestValidationString(this.qData);
         _loc36_.strDesc.mouseWheelEnabled = false;
         _loc36_.strReq.mouseWheelEnabled = false;
         _loc36_.rewards.strRew.mouseWheelEnabled = false;
         _loc36_.strDesc.autoSize = "left";
         _loc36_.strReq.autoSize = "left";
         _loc36_.rewards.strRew.autoSize = "left";
         if(this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0 && this.qData.sEndText != "")
         {
            _loc36_.strDesc.text = this.qData.sEndText;
         }
         else
         {
            _loc36_.strDesc.text = this.qData.sDesc;
         }
         _loc36_.strReq.htmlText = "";
         if(this.qData.turnin != null && this.qData.turnin.length > 0)
         {
            _loc5_ = "";
            _loc35_ = 0;
            while(_loc35_ < this.qData.turnin.length)
            {
               _loc6_ = this.world.invTree[this.qData.turnin[_loc35_].ItemID];
               _loc7_ = this.qData.oItems[this.qData.turnin[_loc35_].ItemID].sName;
               if(this.rootClass.litePreference.data.bDebugger)
               {
                  _loc7_ = "(" + this.qData.turnin[_loc35_].ItemID + ") " + _loc7_;
               }
               _loc8_ = int(this.qData.turnin[_loc35_].iQty);
               if(_loc35_ > 0)
               {
                  _loc5_ += ",<br>";
               }
               if(_loc6_.iQty < _loc8_)
               {
                  _loc5_ += _loc7_ + " <font color=\"#888888\">" + _loc6_.iQty + "/</font>" + _loc8_;
               }
               else
               {
                  _loc5_ += "<font color=\"#888888\">" + _loc7_ + " " + _loc6_.iQty + "/" + _loc8_ + "</font>";
               }
               _loc35_++;
            }
            _loc36_.strReq.htmlText = _loc5_;
         }
         var _loc37_:String = this.qData.iGold + "<font color=\"#FFCC00\"> gold</font><br>";
         _loc37_ = _loc37_ + (this.qData.iExp + "<font color=\"#FF00FF\"> xp</font>");
         if(this.qData.hasOwnProperty("metaValues") && Boolean(this.qData.metaValues.hasOwnProperty("freeac")))
         {
            _loc37_ += "<br>" + this.qData.metaValues.freeac + "<font color=\"#FFCC00\"> ac</font>";
         }
         if(this.qData.FactionID > 1 && this.qData.iRep > 0)
         {
            _loc37_ += "<br>" + this.qData.iRep + " <font color=\'#00FF66\'>rep : " + this.qData.sFaction + "</font>";
         }
         _loc36_.rewards.strRew.htmlText = _loc37_;
         if(_loc36_.strNote.text == "")
         {
            _loc36_.descTitle.y = 0;
         }
         else
         {
            _loc36_.descTitle.y = _loc36_.strNote.y + _loc36_.strNote.textHeight + 10;
         }
         _loc36_.strDesc.y = _loc36_.descTitle.y + 15;
         _loc36_.reqTitle.y = Math.round(_loc36_.strDesc.y + _loc36_.strDesc.textHeight + 10);
         _loc36_.strReq.y = _loc36_.reqTitle.y + 15;
         _loc36_.rewards.y = Math.round(_loc36_.strReq.y + _loc36_.strReq.textHeight + 10);
         var _loc38_:Number = _loc36_.rewards.y + _loc36_.rewards.height + 15;
         if(this.qData.oRewards != null)
         {
            _loc9_ = this.world.getClass("DFrameMCcnt");
            _loc12_ = ["itemsS","itemsC","itemsR","itemsrand"];
            _loc35_ = 0;
            while(_loc35_ < _loc12_.length)
            {
               _loc13_ = _loc12_[_loc35_];
               switch(_loc13_)
               {
                  case "itemsS":
                  default:
                     _loc15_ = _loc36_.rewardsStatic;
                     break;
                  case "itemsC":
                     _loc15_ = _loc36_.rewardsChoice;
                     break;
                  case "itemsR":
                     _loc15_ = _loc36_.rewardsRoll;
                     break;
                  case "itemsrand":
                     _loc15_ = _loc36_.rewardsRandom;
               }
               if(this.qData.oRewards[_loc13_] == null)
               {
                  _loc15_.visible = false;
               }
               else
               {
                  _loc14_ = this.qData.oRewards[_loc13_];
                  _loc18_ = 16;
                  for(_loc1_ in _loc14_)
                  {
                     _loc16_ = _loc14_[_loc1_];
                     _loc17_ = int(_loc16_.iQty);
                     _loc10_ = _loc15_.addChild(new _loc9_()) as MovieClip;
                     _loc10_.ItemID = _loc16_.ItemID;
                     _loc10_.strName.autoSize = "left";
                     _loc19_ = this.rootClass.litePreference.data.bDebugger ? "(" + _loc16_.ItemID + ")" : "";
                     _loc10_.strName.text = _loc19_ + _loc16_.sName;
                     _loc10_.strName.width = _loc10_.strName.textWidth + 6;
                     _loc20_ = "100";
                     if(_loc13_ != "itemsrand")
                     {
                        for each(_loc24_ in this.qData.reward)
                        {
                           if(_loc24_.ItemID == _loc10_.ItemID && _loc24_.iQty == _loc17_)
                           {
                              _loc20_ = _loc24_.iRate;
                           }
                        }
                     }
                     if(_loc13_ == "itemsrand")
                     {
                        _loc20_ = Number(Number(_loc20_) / this.getCount(_loc13_)).toFixed(2).toString();
                     }
                     _loc10_.strType.text = _loc20_ ? _loc16_.sType + " (" + _loc20_ + "%)" : _loc16_.sType;
                     _loc10_.strType.width = 100;
                     _loc10_.strRate.visible = false;
                     _loc10_.bg.width = int(_loc10_.strName.textWidth) + 75;
                     if(_loc10_.bg.width < 175)
                     {
                        _loc10_.bg.width = 175;
                     }
                     _loc10_.fx1.width = _loc10_.bg.width;
                     if(_loc17_ > 1)
                     {
                        _loc10_.strQ.text = "x" + _loc17_;
                        _loc10_.strQ.x = _loc10_.bg.width - _loc10_.strQ.width - 7;
                        _loc10_.strQ.visible = true;
                     }
                     else
                     {
                        _loc10_.strQ.x = 0;
                        _loc10_.strQ.visible = false;
                     }
                     _loc10_.bg.filters = [];
                     _loc10_.icon.removeAllChildren();
                     _loc21_ = "";
                     if(_loc16_.sType.toLowerCase() == "enhancement")
                     {
                        _loc21_ = this.rootClass.getIconBySlot(_loc16_.sES);
                     }
                     else if(_loc16_.sIcon == null || _loc16_.sIcon == "" || _loc16_.sIcon == "none")
                     {
                        if(_loc16_.sLink.toLowerCase() != "none")
                        {
                           _loc21_ = "iidesign";
                        }
                        else
                        {
                           _loc21_ = "iibag";
                        }
                     }
                     else
                     {
                        _loc21_ = _loc16_.sIcon;
                     }
                     try
                     {
                        _loc25_ = this.world.getClass(_loc21_) as Class;
                        _loc26_ = _loc10_.icon.addChild(new _loc25_());
                        _loc26_.scaleX = _loc26_.scaleY = String(_loc16_.sType).toLowerCase() == "misc" ? 0.25 : 0.5;
                        _loc27_ = _loc26_.getBounds(_loc10_.icon);
                        if(_loc27_.width > 30 || _loc27_.height > 30)
                        {
                           _loc28_ = 30 / Math.max(_loc27_.width,_loc27_.height);
                           _loc26_.scaleX *= _loc28_;
                           _loc26_.scaleY *= _loc28_;
                        }
                        _loc10_.icon.filters = [];
                        if(this.isOwned(_loc16_.bHouse,_loc16_.ItemID))
                        {
                           _loc29_ = new detailedCheck();
                           _loc10_.icon.addChild(_loc29_);
                           _loc30_ = _loc29_.getBounds(_loc29_);
                           _loc31_ = _loc26_.getBounds(_loc10_.icon);
                           if(_loc30_.height > 0)
                           {
                              _loc29_.scaleX = _loc29_.scaleY = _loc31_.height / _loc30_.height;
                           }
                           _loc32_ = _loc29_.getBounds(_loc10_.icon);
                           _loc29_.x += _loc31_.x + _loc31_.width / 2 - (_loc32_.x + _loc32_.width / 2) + _loc31_.height / 2;
                           _loc29_.y += _loc31_.y + _loc31_.height / 2 - (_loc32_.y + _loc32_.height / 2);
                        }
                     }
                     catch(e:Error)
                     {
                     }
                     _loc10_.y = _loc18_;
                     _loc18_ += Math.round(_loc10_.height + 8);
                     if(_loc13_ == "itemsC" && this.qMode != "l" && this.qData.status != null && this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0)
                     {
                        _loc10_.mouseEnabled = true;
                        _loc10_.mouseChildren = false;
                        _loc10_.buttonMode = true;
                        _loc10_.addEventListener(MouseEvent.CLICK,this.btnRewardClick,false,0,true);
                        TouchTargets.pad(_loc10_,0,Math.min(Mobile.touchPx(9),_loc10_.height + 8));
                     }
                     if(_loc16_.bCoins != 1)
                     {
                        _loc10_.fadedAC.visible = false;
                     }
                     else
                     {
                        _loc10_.fadedAC.x = _loc10_.bg.width - 72;
                     }
                     if(_loc16_.bUpg)
                     {
                        _loc33_ = _loc10_.strName.defaultTextFormat;
                        _loc33_.color = 16566089;
                        _loc10_.strName.setTextFormat(_loc33_);
                        _loc33_ = _loc10_.strQ.defaultTextFormat;
                        _loc33_.color = 16566089;
                        _loc10_.strQ.setTextFormat(_loc33_);
                     }
                     for each(_loc23_ in this.qData.oRewards)
                     {
                        for each(_loc24_ in _loc23_)
                        {
                           if(_loc24_.ItemID == _loc10_.ItemID)
                           {
                              _loc22_ = _loc24_;
                           }
                        }
                     }
                     if(!_loc10_.hasEventListener(MouseEvent.CLICK))
                     {
                        _loc10_.addEventListener(MouseEvent.CLICK,this.onRewardPreview,false,0,true);
                     }
                  }
               }
               if(_loc15_.visible)
               {
                  _loc15_.y = _loc38_;
                  _loc38_ = _loc15_.y + _loc15_.height + 15;
               }
               _loc35_++;
            }
         }
         this.rewardCount = -1;
         var _loc39_:* = null;
         var _loc40_:* = {};
         if(this.qMode != "l")
         {
            if(this.qData.status == null)
            {
               _loc39_ = this.mc.cnt.btns.dual;
               this.mc.cnt.btns.tri.visible = false;
               _loc40_ = {
                  "b1":{
                     "txt":"Accept",
                     "fn":this.btnAccept
                  },
                  "b2":{
                     "txt":"Decline",
                     "fn":this.btnBack
                  }
               };
            }
            else if(this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0)
            {
               _loc39_ = this.mc.cnt.btns.tri;
               this.mc.cnt.btns.dual.visible = false;
               _loc40_ = {
                  "b1":{
                     "txt":"Back",
                     "fn":this.btnBack
                  },
                  "b2":{
                     "txt":"Turn in!",
                     "fn":this.btnComplete
                  },
                  "b3":{
                     "txt":"Abandon",
                     "fn":this.btnAbandon
                  }
               };
            }
            else
            {
               _loc39_ = this.mc.cnt.btns.dual;
               this.mc.cnt.btns.tri.visible = false;
               _loc40_ = {
                  "b1":{
                     "txt":"Back",
                     "fn":this.btnBack
                  },
                  "b2":{
                     "txt":"Abandon",
                     "fn":this.btnAbandon
                  }
               };
            }
         }
         else
         {
            _loc39_ = this.mc.cnt.btns.dual;
            this.mc.cnt.btns.tri.visible = false;
            _loc40_ = {
               "b1":{
                  "txt":"Back",
                  "fn":this.btnBack
               },
               "b2":{
                  "txt":"Abandon",
                  "fn":this.btnAbandon
               }
            };
         }
         for(_loc4_ in _loc40_)
         {
            _loc34_ = _loc39_[_loc4_];
            _loc34_.buttonMode = true;
            _loc34_.fx.visible = false;
            _loc34_.ti.mouseEnabled = false;
            _loc34_.addEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver,false,0,true);
            _loc34_.addEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut,false,0,true);
            _loc34_.ti.text = _loc40_[_loc4_].txt;
            _loc34_.addEventListener(MouseEvent.CLICK,_loc40_[_loc4_].fn,false,0,true);
            TouchTargets.pad(_loc34_);
         }
         if(_loc39_ == this.mc.cnt.btns.tri && this.qData.sField == null && this.qData.bOnce == 0 && this.world.maximumQuestTurnIns(this.qData.QuestID) > 1)
         {
            this.qStep = TurnInStepper.create(this.mc.cnt,_loc39_.b2,_loc39_.b1,this.world.maximumQuestTurnIns(this.qData.QuestID),_loc39_.b2.ti);
            QuestLayout.fitStepper(this.mc.cnt,this.qStep);
         }
         var _loc41_:* = this.mc.cnt.scr;
         var _loc42_:* = this.mc.cnt.bMask;
         _loc41_.h.height = int(_loc41_.b.height / _loc36_.height * _loc41_.b.height);
         this.hRun = _loc41_.b.height - _loc41_.h.height;
         this.dRun = _loc36_.height - _loc41_.b.height + 20;
         _loc41_.h.y = 0;
         _loc36_.oy = _loc36_.y = this.qdy;
         _loc41_.visible = false;
         _loc41_.hit.alpha = 0;
         this.mDown = false;
         this.detachTouch();
         if(_loc36_.height > _loc41_.b.height)
         {
            _loc41_.visible = true;
            _loc41_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc41_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc36_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
            this.qTouch = TouchScroll.attach(_loc36_,this.touchPos,this.touchSet,this.touchMax);
            QuestLayout.detailHit(_loc36_,_loc41_);
         }
         this.mc.cnt.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
      }

      private function onRewardPreview(param1:MouseEvent) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         for each(_loc2_ in this.qData.oRewards)
         {
            for each(_loc3_ in _loc2_)
            {
               if(_loc3_.ItemID == param1.currentTarget.ItemID)
               {
                  _loc1_ = _loc3_;
               }
            }
         }
         if(this.rootClass.ui.getChildByName("qRewardPrev"))
         {
            this.rootClass.ui.getChildByName("qRewardPrev").fClose();
         }
         var _loc4_:* = this.rootClass.ui.addChild(new qRewardPrev(_loc1_));
         _loc4_.world = this.rootClass.world;
         _loc4_.rootClass = this.rootClass;
         _loc4_.open();
      }

      private function killStepper() : void
      {
         if(this.qStep != null)
         {
            this.qStep.destroy();
            this.qStep = null;
         }
         QuestLayout.unfit(this.mc.cnt);
      }

      private function detachTouch() : void
      {
         if(this.qTouch != null)
         {
            this.qTouch.detach();
            this.qTouch = null;
         }
      }

      private function touchPos() : Number
      {
         var _loc1_:MovieClip = this.mc.cnt.scr;
         return this.hRun > 0 ? _loc1_.h.y / this.hRun * this.dRun : 0;
      }

      private function touchSet(param1:Number) : void
      {
         var _loc1_:MovieClip = this.mc.cnt.scr;
         if(this.dRun > 0)
         {
            _loc1_.h.y = param1 / this.dRun * this.hRun;
         }
      }

      private function touchMax() : Number
      {
         return Math.max(0,this.dRun);
      }

      private function onWheel(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = this.mc.cnt.scr;
         if(!_loc1_ || !_loc1_.visible)
         {
            return;
         }
         _loc1_.h.y += param1.delta * -1 * 3;
         if(_loc1_.h.y < 0)
         {
            _loc1_.h.y = 0;
         }
         if(_loc1_.h.y + _loc1_.h.height > _loc1_.b.height)
         {
            _loc1_.h.y = int(_loc1_.b.height - _loc1_.h.height);
         }
      }

      private function scrDown(param1:MouseEvent) : *
      {
         this.mbY = int(mouseY);
         this.mhY = int(MovieClip(param1.currentTarget.parent).h.y);
         this.mDown = true;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.scrUp,false,0,true);
      }

      private function scrUp(param1:MouseEvent) : *
      {
         this.mDown = false;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.scrUp);
      }

      private function hEF(param1:Event) : *
      {
         var _loc1_:* = undefined;
         if(this.mDown)
         {
            _loc1_ = MovieClip(param1.currentTarget.parent);
            this.mbD = int(mouseY) - this.mbY;
            _loc1_.h.y = this.mhY + this.mbD;
            if(_loc1_.h.y + _loc1_.h.height > _loc1_.b.height)
            {
               _loc1_.h.y = int(_loc1_.b.height - _loc1_.h.height);
            }
            if(_loc1_.h.y < 0)
            {
               _loc1_.h.y = 0;
            }
         }
      }

      private function dEF(param1:Event) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget.parent).scr;
         var _loc2_:* = MovieClip(param1.currentTarget);
         var _loc3_:* = -_loc1_.h.y / this.hRun;
         var _loc4_:* = int(_loc3_ * this.dRun) + _loc2_.oy;
         if(Math.abs(_loc4_ - _loc2_.y) > 0.2)
         {
            _loc2_.y += (_loc4_ - _loc2_.y) / 4;
         }
         else
         {
            _loc2_.y = _loc4_;
         }
      }

      public function killDetailUI() : *
      {
         if(this.mc.cnt.core.hasEventListener(Event.ENTER_FRAME))
         {
            this.mc.cnt.core.removeEventListener(Event.ENTER_FRAME,this.dEF);
         }
      }

      public function turninResult(param1:String) : *
      {
         this.getQuestListB();
         this.qData = null;
         if(this.mc.cnt.currentLabel == "hold")
         {
            if(param1 == "pass")
            {
               this.qData = this.nextQuestAvailable();
            }
            this.mc.cnt.gotoAndPlay("back");
         }
      }

      private function xClick(param1:MouseEvent) : *
      {
         this.fClose();
         if(this.rootClass.ui.getChildByName("qRewardPrev"))
         {
            this.rootClass.ui.getChildByName("qRewardPrev").fClose();
         }
      }

      public function fClose() : void
      {
         this.detachTouch();
         this.killStepper();
         this.mc.cnt.bg.btnClose.removeEventListener(MouseEvent.CLICK,this.xClick);
         stage.focus = stage;
         this.mc.parent.removeChild(this.mc);
      }

      private function btnAccept(param1:MouseEvent) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = this.getQuestValidationString(this.qData);
         if(this.qData.hasOwnProperty("sMeta") && this.qData.sMeta.indexOf("EmailConfirm") != -1 && this.world.myAvatar.objData.intActivationFlag < 5)
         {
            this.rootClass.MsgBox.notify("Confirmed Contact Email Address Required");
         }
         else if(_loc2_ != "")
         {
            MovieClip(Game.root).MsgBox.notify(_loc2_);
         }
         else if(this.world.coolDown("acceptQuest"))
         {
            _loc1_ = MovieClip(param1.currentTarget);
            this.setCT(_loc1_.bg,43775);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.btnAccept);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
            this.world.acceptQuest(this.qData.QuestID);
            this.qData = null;
         }
      }

      private function btnAbandon(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         this.world.abandonQuest(this.qData.QuestID);
         this.setCT(_loc1_.bg,16711680);
         _loc1_.removeEventListener(MouseEvent.CLICK,this.btnAbandon);
         _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
         _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
         this.killStepper();
         this.qData = null;
         this.mc.cnt.gotoAndPlay("back");
      }

      private function btnComplete(param1:MouseEvent) : *
      {
         var _loc1_:* = undefined;
         var _loc2_:int = 0;
         if(Boolean(this.world.coolDown("tryQuestComplete")) && Boolean(this.world.canTurnInQuest(this.qData.QuestID)))
         {
            if(this.qData.oRewards.itemsC != null && this.choiceID == -1)
            {
               this.rootClass.addUpdate("Please choose a reward before turning the quest in!");
               this.rootClass.chatF.pushMsg("warning","Please choose a reward before turning the quest in!","SERVER","",0);
               return;
            }
            _loc1_ = MovieClip(param1.currentTarget);
            this.setCT(_loc1_.bg,65280);
            _loc1_.removeEventListener(MouseEvent.CLICK,this.btnComplete);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
            _loc2_ = this.qStep != null ? this.qStep.value : 1;
            this.killStepper();
            this.mc.cnt.gotoAndPlay("hold");
            this.getQuestListA();
            this.world.tryQuestComplete(this.qData.QuestID,this.choiceID,false,_loc2_);
         }
      }

      private function btnBack(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         this.setCT(_loc1_.bg,11184810);
         _loc1_.removeEventListener(MouseEvent.CLICK,this.btnBack);
         _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
         _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
         this.killStepper();
         this.mc.cnt.mouseChildren = false;
         this.qData = null;
         this.mc.cnt.gotoAndPlay("back");
      }

      private function btnRewardClick(param1:MouseEvent) : void
      {
         var _loc1_:MovieClip = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:MovieClip = _loc2_.parent as MovieClip;
         this.choiceID = _loc2_.ItemID;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.numChildren)
         {
            _loc1_ = _loc3_.getChildAt(_loc4_) as MovieClip;
            if(!(_loc1_ == null || _loc1_.ItemID == undefined || !("bg" in _loc1_) || _loc1_.bg == null))
            {
               _loc1_.bg.filters = this.choiceID == _loc1_.ItemID ? [CHOICE_GLOW] : [];
            }
            _loc4_++;
         }
      }

      private function bMouseOver(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.fx.visible = true;
      }

      private function bMouseOut(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.fx.visible = false;
      }

      private function setCT(param1:*, param2:*) : *
      {
         var _loc1_:* = param1.transform.colorTransform;
         _loc1_.color = param2;
         param1.transform.colorTransform = _loc1_;
      }

      private function iMouseOver(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.parent.mHi.visible = true;
         _loc1_.parent.mHi.y = _loc1_.y;
      }

      private function iMouseOut(param1:MouseEvent) : *
      {
         var _loc1_:* = MovieClip(param1.currentTarget);
         _loc1_.parent.mHi.visible = false;
      }

      internal function frame7() : *
      {
         stop();
      }

      internal function frame12() : *
      {
      }

      internal function frame16() : *
      {
         this.fClose();
      }
   }
}
