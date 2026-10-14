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

   [Embed(source="/_assets/assets.swf", symbol="symbol740")]
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
         var _loc2_:int = 0;
         var _loc1_:int = 0;
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
               _loc2_ = 0;
               while(_loc2_ < this.sIDs.length)
               {
                  this.qIDs.push(this.sIDs[_loc2_]);
                  _loc2_++;
               }
               _loc1_ = 0;
               while(_loc1_ < this.tIDs.length)
               {
                  if(Boolean(this.world.isQuestInProgress(this.tIDs[_loc1_])) && this.qIDs.indexOf(this.tIDs[_loc1_]) == -1)
                  {
                     this.qIDs.push(this.tIDs[_loc1_]);
                  }
                  _loc1_++;
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
         var _loc2_:Object = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.qIDs.length)
         {
            if(this.qla[_loc1_] == false && this.qlb[_loc1_] == true)
            {
               _loc2_ = this.world.questTree[this.qIDs[_loc1_]];
            }
            _loc1_++;
         }
         return _loc2_;
      }

      private function hasRequiredItemsForQuest(param1:Object) : Boolean
      {
         var _loc1_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         if(param1.reqd != null && param1.reqd.length > 0)
         {
            _loc1_ = 0;
            while(_loc1_ < param1.reqd.length)
            {
               _loc3_ = param1.reqd[_loc1_].ItemID;
               _loc4_ = int(param1.reqd[_loc1_].iQty);
               if(this.rootClass.world.invTree[_loc3_] == null || int(this.rootClass.world.invTree[_loc3_].iQty) < _loc4_)
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
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:* = undefined;
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
            _loc3_ = param1.iReqCP - this.rootClass.arrRanks[_loc1_ - 1];
            if(_loc3_ > 0)
            {
               return "Requires " + _loc3_ + " Class Points on " + param1.sClass + ", Rank " + _loc1_ + ".";
            }
            return "Requires " + (this.rootClass.litePreference.data.bDebugger ? "(" + param1.iClass + ") " : "") + param1.sClass + ", Rank " + _loc1_ + ".";
         }
         if(param1.FactionID > 1 && this.world.myAvatar.getRep(param1.FactionID) < param1.iReqRep)
         {
            _loc4_ = int(this.rootClass.getRankFromPoints(param1.iReqRep));
            _loc5_ = param1.iReqRep - this.rootClass.arrRanks[_loc4_ - 1];
            if(_loc5_ > 0)
            {
               return "Requires " + _loc5_ + " Reputation for " + param1.sFaction + ", Rank " + _loc4_ + ".";
            }
            return "Requires " + param1.sFaction + ", Rank " + _loc4_ + ".";
         }
         if(param1.reqd != null && !this.hasRequiredItemsForQuest(param1))
         {
            _loc6_ = "Required Item(s): ";
            _loc7_ = 0;
            while(_loc7_ < param1.reqd.length)
            {
               _loc8_ = this.world.invTree[param1.reqd[_loc7_].ItemID];
               _loc9_ = int(param1.reqd[_loc7_].iQty);
               if(_loc8_.sES == "ar")
               {
                  _loc10_ = int(this.rootClass.getRankFromPoints(_loc9_));
                  _loc11_ = _loc9_ - this.rootClass.arrRanks[_loc10_ - 1];
                  if(_loc11_ > 0)
                  {
                     _loc6_ += _loc11_ + " Class Points on ";
                  }
                  if(this.rootClass.litePreference.data.bDebugger)
                  {
                     _loc6_ += "(" + param1.reqd[_loc7_].ItemID + ")";
                  }
                  _loc6_ += _loc8_.sName + ", Rank " + _loc10_;
               }
               else
               {
                  if(this.rootClass.litePreference.data.bDebugger)
                  {
                     _loc6_ += "(" + param1.reqd[_loc7_].ItemID + ")";
                  }
                  _loc6_ += _loc8_.sName;
                  if(_loc9_ > 1)
                  {
                     _loc6_ += "x" + _loc9_;
                  }
               }
               _loc6_ += ", ";
               _loc7_++;
            }
            return _loc6_.substr(0,_loc6_.length - 2) + ".";
         }
         return "";
      }

      private function isOneTimeQuestDone(param1:*) : Boolean
      {
         return param1.bOnce == 1 && (param1.iSlot < 0 || this.world.getQuestValue(param1.iSlot) >= param1.iValue);
      }

      private function buildQuestList() : *
      {
         var _loc6_:* = undefined;
         var _loc7_:* = undefined;
         var _loc8_:String = null;
         var _loc2_:* = 0;
         var _loc1_:* = 0;
         while(_loc1_ < this.qIDs.length)
         {
            _loc6_ = this.world.questTree[this.qIDs[_loc1_]];
            if(_loc6_ != null && !this.isOneTimeQuestDone(_loc6_))
            {
               _loc7_ = this.mc.cnt.qList.addChild(new qProto());
               _loc8_ = this.rootClass.litePreference.data.bDebugger ? "(" + _loc6_.QuestID + ")" : "";
               if(this.isQuestAvailable(_loc6_))
               {
                  _loc7_.ti.htmlText = "<font color=\'#009900\'><b>" + _loc8_ + _loc6_.sName + "</b></font>";
               }
               else
               {
                  _loc7_.ti.htmlText = "<font color=\'#990000\'><b>" + _loc8_ + _loc6_.sName + "</b></font>";
               }
               _loc7_.addEventListener(MouseEvent.CLICK,this.qListClick);
               _loc7_.QuestID = _loc6_.QuestID;
               if(_loc6_.sTyp != null)
               {
                  _loc7_.ti.htmlText += " <font color=\"#888888\">" + _loc6_.sTyp + "</font>";
               }
               if(_loc6_.status != null)
               {
                  switch(_loc6_.status)
                  {
                     case "p":
                        _loc7_.ti.htmlText += "<font color=\'#888888\'> - In progress</font>";
                        break;
                     case "c":
                        _loc7_.ti.htmlText += "<font color=\'#99FF00\'> - <b>Complete!</b></font>";
                  }
               }
               _loc7_.addEventListener(MouseEvent.MOUSE_OVER,this.iMouseOver,false,0,true);
               _loc7_.addEventListener(MouseEvent.MOUSE_OUT,this.iMouseOut,false,0,true);
               _loc7_.buttonMode = true;
               _loc7_.hit.alpha = 0;
               _loc7_.x = 10;
               if(Mobile.active)
               {
                  QuestLayout.row(_loc7_,_loc2_++);
               }
               else
               {
                  _loc7_.y = _loc1_ * 20;
               }
            }
            _loc1_++;
         }
         if(Mobile.active)
         {
            QuestLayout.rows(this.mc.cnt.qList,_loc2_);
         }
         var _loc3_:* = this.mc.cnt.scr;
         var _loc4_:* = this.mc.cnt.bMask;
         var _loc5_:* = this.mc.cnt.qList;
         _loc3_.h.height = int(_loc3_.b.height / _loc5_.height * _loc3_.b.height);
         this.hRun = _loc3_.b.height - _loc3_.h.height;
         this.dRun = _loc5_.height - _loc3_.b.height + 20;
         _loc3_.h.y = 0;
         _loc5_.oy = _loc5_.y = this.qly;
         _loc3_.visible = false;
         _loc3_.hit.alpha = 0;
         this.mDown = false;
         this.detachTouch();
         if(_loc5_.height > _loc3_.b.height)
         {
            _loc3_.visible = true;
            _loc3_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc3_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc5_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
            this.qTouch = TouchScroll.attach(_loc5_,this.touchPos,this.touchSet,this.touchMax);
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
         var _loc2_:* = this.mc.cnt.qList.addChild(new qProto());
         _loc2_.ti.htmlText = "<font color=\"#DDDDDD\">You aren\'t on any quests!</font>";
         _loc2_.hit.alpha = 0;
         _loc2_.x = 10;
         this.mc.cnt.qList.iproto.visible = false;
         this.mc.cnt.scr.visible = false;
      }

      private function isOwned(param1:Boolean, param2:*) : Boolean
      {
         var _loc3_:* = undefined;
         for each(_loc3_ in param1 ? this.rootClass.world.myAvatar.houseitems : this.rootClass.world.myAvatar.items)
         {
            if(_loc3_.ItemID == param2)
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
         var _loc3_:Object = null;
         var _loc4_:Object = null;
         var _loc10_:* = undefined;
         var _loc12_:String = null;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:Class = null;
         var _loc17_:MovieClip = null;
         var _loc18_:GlowFilter = null;
         var _loc19_:Array = null;
         var _loc20_:String = null;
         var _loc21_:Object = null;
         var _loc22_:MovieClip = null;
         var _loc23_:Object = null;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:String = null;
         var _loc27_:String = null;
         var _loc28_:String = null;
         var _loc29_:Object = null;
         var _loc30_:Object = null;
         var _loc31_:* = undefined;
         var _loc32_:Class = null;
         var _loc33_:DisplayObject = null;
         var _loc34_:Rectangle = null;
         var _loc35_:Number = NaN;
         var _loc36_:detailedCheck = null;
         var _loc37_:Rectangle = null;
         var _loc38_:Rectangle = null;
         var _loc39_:Rectangle = null;
         var _loc40_:TextFormat = null;
         var _loc41_:* = undefined;
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
         var _loc2_:int = 0;
         this.choiceID = -1;
         this.world.checkAllQuestStatus();
         this.mc.cnt.mouseChildren = true;
         this.mc.cnt.strTitle.text = this.qData.sName;
         var _loc5_:* = this.mc.cnt.core;
         _loc5_.strNote.autoSize = "left";
         _loc5_.strNote.text = this.getQuestValidationString(this.qData);
         _loc5_.strDesc.mouseWheelEnabled = false;
         _loc5_.strReq.mouseWheelEnabled = false;
         _loc5_.rewards.strRew.mouseWheelEnabled = false;
         _loc5_.strDesc.autoSize = "left";
         _loc5_.strReq.autoSize = "left";
         _loc5_.rewards.strRew.autoSize = "left";
         if(this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0 && this.qData.sEndText != "")
         {
            _loc5_.strDesc.text = this.qData.sEndText;
         }
         else
         {
            _loc5_.strDesc.text = this.qData.sDesc;
         }
         _loc5_.strReq.htmlText = "";
         if(this.qData.turnin != null && this.qData.turnin.length > 0)
         {
            _loc12_ = "";
            _loc2_ = 0;
            while(_loc2_ < this.qData.turnin.length)
            {
               _loc13_ = this.world.invTree[this.qData.turnin[_loc2_].ItemID];
               _loc14_ = this.qData.oItems[this.qData.turnin[_loc2_].ItemID].sName;
               if(this.rootClass.litePreference.data.bDebugger)
               {
                  _loc14_ = "(" + this.qData.turnin[_loc2_].ItemID + ") " + _loc14_;
               }
               _loc15_ = int(this.qData.turnin[_loc2_].iQty);
               if(_loc2_ > 0)
               {
                  _loc12_ += ",<br>";
               }
               if(_loc13_.iQty < _loc15_)
               {
                  _loc12_ += _loc14_ + " <font color=\"#888888\">" + _loc13_.iQty + "/</font>" + _loc15_;
               }
               else
               {
                  _loc12_ += "<font color=\"#888888\">" + _loc14_ + " " + _loc13_.iQty + "/" + _loc15_ + "</font>";
               }
               _loc2_++;
            }
            _loc5_.strReq.htmlText = _loc12_;
         }
         var _loc6_:String = this.qData.iGold + "<font color=\"#FFCC00\"> gold</font><br>";
         _loc6_ = _loc6_ + (this.qData.iExp + "<font color=\"#FF00FF\"> xp</font>");
         if(this.qData.hasOwnProperty("metaValues") && Boolean(this.qData.metaValues.hasOwnProperty("freeac")))
         {
            _loc6_ += "<br>" + this.qData.metaValues.freeac + "<font color=\"#FFCC00\"> ac</font>";
         }
         if(this.qData.FactionID > 1 && this.qData.iRep > 0)
         {
            _loc6_ += "<br>" + this.qData.iRep + " <font color=\'#00FF66\'>rep : " + this.qData.sFaction + "</font>";
         }
         _loc5_.rewards.strRew.htmlText = _loc6_;
         if(_loc5_.strNote.text == "")
         {
            _loc5_.descTitle.y = 0;
         }
         else
         {
            _loc5_.descTitle.y = _loc5_.strNote.y + _loc5_.strNote.textHeight + 10;
         }
         _loc5_.strDesc.y = _loc5_.descTitle.y + 15;
         _loc5_.reqTitle.y = Math.round(_loc5_.strDesc.y + _loc5_.strDesc.textHeight + 10);
         _loc5_.strReq.y = _loc5_.reqTitle.y + 15;
         _loc5_.rewards.y = Math.round(_loc5_.strReq.y + _loc5_.strReq.textHeight + 10);
         var _loc7_:Number = _loc5_.rewards.y + _loc5_.rewards.height + 15;
         if(this.qData.oRewards != null)
         {
            _loc16_ = this.world.getClass("DFrameMCcnt");
            _loc19_ = ["itemsS","itemsC","itemsR","itemsrand"];
            _loc2_ = 0;
            while(_loc2_ < _loc19_.length)
            {
               _loc20_ = _loc19_[_loc2_];
               switch(_loc20_)
               {
                  case "itemsS":
                  default:
                     _loc22_ = _loc5_.rewardsStatic;
                     break;
                  case "itemsC":
                     _loc22_ = _loc5_.rewardsChoice;
                     break;
                  case "itemsR":
                     _loc22_ = _loc5_.rewardsRoll;
                     break;
                  case "itemsrand":
                     _loc22_ = _loc5_.rewardsRandom;
               }
               if(this.qData.oRewards[_loc20_] == null)
               {
                  _loc22_.visible = false;
               }
               else
               {
                  _loc21_ = this.qData.oRewards[_loc20_];
                  _loc25_ = 16;
                  for(_loc1_ in _loc21_)
                  {
                     _loc23_ = _loc21_[_loc1_];
                     _loc24_ = int(_loc23_.iQty);
                     _loc17_ = _loc22_.addChild(new _loc16_()) as MovieClip;
                     _loc17_.ItemID = _loc23_.ItemID;
                     _loc17_.strName.autoSize = "left";
                     _loc26_ = this.rootClass.litePreference.data.bDebugger ? "(" + _loc23_.ItemID + ")" : "";
                     _loc17_.strName.text = _loc26_ + _loc23_.sName;
                     _loc17_.strName.width = _loc17_.strName.textWidth + 6;
                     _loc27_ = "100";
                     if(_loc20_ != "itemsrand")
                     {
                        for each(_loc31_ in this.qData.reward)
                        {
                           if(_loc31_.ItemID == _loc17_.ItemID && _loc31_.iQty == _loc24_)
                           {
                              _loc27_ = _loc31_.iRate;
                           }
                        }
                     }
                     if(_loc20_ == "itemsrand")
                     {
                        _loc27_ = Number(Number(_loc27_) / this.getCount(_loc20_)).toFixed(2).toString();
                     }
                     _loc17_.strType.text = _loc27_ ? _loc23_.sType + " (" + _loc27_ + "%)" : _loc23_.sType;
                     _loc17_.strType.width = 100;
                     _loc17_.strRate.visible = false;
                     _loc17_.bg.width = int(_loc17_.strName.textWidth) + 75;
                     if(_loc17_.bg.width < 175)
                     {
                        _loc17_.bg.width = 175;
                     }
                     _loc17_.fx1.width = _loc17_.bg.width;
                     if(_loc24_ > 1)
                     {
                        _loc17_.strQ.text = "x" + _loc24_;
                        _loc17_.strQ.x = _loc17_.bg.width - _loc17_.strQ.width - 7;
                        _loc17_.strQ.visible = true;
                     }
                     else
                     {
                        _loc17_.strQ.x = 0;
                        _loc17_.strQ.visible = false;
                     }
                     _loc17_.bg.filters = [];
                     _loc17_.icon.removeAllChildren();
                     _loc28_ = "";
                     if(_loc23_.sType.toLowerCase() == "enhancement")
                     {
                        _loc28_ = this.rootClass.getIconBySlot(_loc23_.sES);
                     }
                     else if(_loc23_.sIcon == null || _loc23_.sIcon == "" || _loc23_.sIcon == "none")
                     {
                        if(_loc23_.sLink.toLowerCase() != "none")
                        {
                           _loc28_ = "iidesign";
                        }
                        else
                        {
                           _loc28_ = "iibag";
                        }
                     }
                     else
                     {
                        _loc28_ = _loc23_.sIcon;
                     }
                     try
                     {
                        _loc32_ = this.world.getClass(_loc28_) as Class;
                        _loc33_ = _loc17_.icon.addChild(new _loc32_());
                        _loc33_.scaleX = _loc33_.scaleY = String(_loc23_.sType).toLowerCase() == "misc" ? 0.25 : 0.5;
                        _loc34_ = _loc33_.getBounds(_loc17_.icon);
                        if(_loc34_.width > 30 || _loc34_.height > 30)
                        {
                           _loc35_ = 30 / Math.max(_loc34_.width,_loc34_.height);
                           _loc33_.scaleX *= _loc35_;
                           _loc33_.scaleY *= _loc35_;
                        }
                        _loc17_.icon.filters = [];
                        if(this.isOwned(_loc23_.bHouse,_loc23_.ItemID))
                        {
                           _loc36_ = new detailedCheck();
                           _loc17_.icon.addChild(_loc36_);
                           _loc37_ = _loc36_.getBounds(_loc36_);
                           _loc38_ = _loc33_.getBounds(_loc17_.icon);
                           if(_loc37_.height > 0)
                           {
                              _loc36_.scaleX = _loc36_.scaleY = _loc38_.height / _loc37_.height;
                           }
                           _loc39_ = _loc36_.getBounds(_loc17_.icon);
                           _loc36_.x += _loc38_.x + _loc38_.width / 2 - (_loc39_.x + _loc39_.width / 2) + _loc38_.height / 2;
                           _loc36_.y += _loc38_.y + _loc38_.height / 2 - (_loc39_.y + _loc39_.height / 2);
                        }
                     }
                     catch(e:Error)
                     {
                     }
                     _loc17_.y = _loc25_;
                     _loc25_ += Math.round(_loc17_.height + 8);
                     if(_loc20_ == "itemsC" && this.qMode != "l" && this.qData.status != null && this.qData.status == "c" && this.tIDs.indexOf(String(this.qData.QuestID)) >= 0)
                     {
                        _loc17_.mouseEnabled = true;
                        _loc17_.mouseChildren = false;
                        _loc17_.buttonMode = true;
                        _loc17_.addEventListener(MouseEvent.CLICK,this.btnRewardClick,false,0,true);
                        TouchTargets.pad(_loc17_,0,Math.min(Mobile.touchPx(9),_loc17_.height + 8));
                     }
                     if(_loc23_.bCoins != 1)
                     {
                        _loc17_.fadedAC.visible = false;
                     }
                     else
                     {
                        _loc17_.fadedAC.x = _loc17_.bg.width - 72;
                     }
                     if(_loc23_.bUpg)
                     {
                        _loc40_ = _loc17_.strName.defaultTextFormat;
                        _loc40_.color = 16566089;
                        _loc17_.strName.setTextFormat(_loc40_);
                        _loc40_ = _loc17_.strQ.defaultTextFormat;
                        _loc40_.color = 16566089;
                        _loc17_.strQ.setTextFormat(_loc40_);
                     }
                     for each(_loc30_ in this.qData.oRewards)
                     {
                        for each(_loc31_ in _loc30_)
                        {
                           if(_loc31_.ItemID == _loc17_.ItemID)
                           {
                              _loc29_ = _loc31_;
                           }
                        }
                     }
                     if(!_loc17_.hasEventListener(MouseEvent.CLICK))
                     {
                        _loc17_.addEventListener(MouseEvent.CLICK,this.onRewardPreview,false,0,true);
                     }
                  }
               }
               if(_loc22_.visible)
               {
                  _loc22_.y = _loc7_;
                  _loc7_ = _loc22_.y + _loc22_.height + 15;
               }
               _loc2_++;
            }
         }
         this.rewardCount = -1;
         var _loc8_:* = null;
         var _loc9_:* = {};
         if(this.qMode != "l")
         {
            if(this.qData.status == null)
            {
               _loc8_ = this.mc.cnt.btns.dual;
               this.mc.cnt.btns.tri.visible = false;
               _loc9_ = {
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
               _loc8_ = this.mc.cnt.btns.tri;
               this.mc.cnt.btns.dual.visible = false;
               _loc9_ = {
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
               _loc8_ = this.mc.cnt.btns.dual;
               this.mc.cnt.btns.tri.visible = false;
               _loc9_ = {
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
            _loc8_ = this.mc.cnt.btns.dual;
            this.mc.cnt.btns.tri.visible = false;
            _loc9_ = {
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
         for(_loc10_ in _loc9_)
         {
            _loc41_ = _loc8_[_loc10_];
            _loc41_.buttonMode = true;
            _loc41_.fx.visible = false;
            _loc41_.ti.mouseEnabled = false;
            _loc41_.addEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver,false,0,true);
            _loc41_.addEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut,false,0,true);
            _loc41_.ti.text = _loc9_[_loc10_].txt;
            _loc41_.addEventListener(MouseEvent.CLICK,_loc9_[_loc10_].fn,false,0,true);
            TouchTargets.pad(_loc41_);
         }
         if(_loc8_ == this.mc.cnt.btns.tri && this.qData.sField == null && this.qData.bOnce == 0 && this.world.maximumQuestTurnIns(this.qData.QuestID) > 1)
         {
            this.qStep = TurnInStepper.create(this.mc.cnt,_loc8_.b2,_loc8_.b1,this.world.maximumQuestTurnIns(this.qData.QuestID),_loc8_.b2.ti);
            QuestLayout.fitStepper(this.mc.cnt,this.qStep);
         }
         var _loc11_:* = this.mc.cnt.scr;
         var _loc42_:* = this.mc.cnt.bMask;
         _loc11_.h.height = int(_loc11_.b.height / _loc5_.height * _loc11_.b.height);
         this.hRun = _loc11_.b.height - _loc11_.h.height;
         this.dRun = _loc5_.height - _loc11_.b.height + 20;
         _loc11_.h.y = 0;
         _loc5_.oy = _loc5_.y = this.qdy;
         _loc11_.visible = false;
         _loc11_.hit.alpha = 0;
         this.mDown = false;
         this.detachTouch();
         if(_loc5_.height > _loc11_.b.height)
         {
            _loc11_.visible = true;
            _loc11_.hit.addEventListener(MouseEvent.MOUSE_DOWN,this.scrDown,false,0,true);
            _loc11_.h.addEventListener(Event.ENTER_FRAME,this.hEF,false,0,true);
            _loc5_.addEventListener(Event.ENTER_FRAME,this.dEF,false,0,true);
            this.qTouch = TouchScroll.attach(_loc5_,this.touchPos,this.touchSet,this.touchMax);
            QuestLayout.detailHit(_loc5_,_loc11_);
         }
         this.mc.cnt.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,false,0,true);
      }

      private function onRewardPreview(param1:MouseEvent) : void
      {
         var _loc1_:Object = null;
         var _loc3_:Object = null;
         var _loc5_:Object = null;
         for each(_loc3_ in this.qData.oRewards)
         {
            for each(_loc5_ in _loc3_)
            {
               if(_loc5_.ItemID == param1.currentTarget.ItemID)
               {
                  _loc1_ = _loc5_;
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
         var _loc2_:MovieClip = this.mc.cnt.scr;
         return this.hRun > 0 ? _loc2_.h.y / this.hRun * this.dRun : 0;
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
         var _loc3_:* = MovieClip(param1.currentTarget);
         var _loc4_:* = -_loc1_.h.y / this.hRun;
         var _loc5_:* = int(_loc4_ * this.dRun) + _loc3_.oy;
         if(Math.abs(_loc5_ - _loc3_.y) > 0.2)
         {
            _loc3_.y += (_loc5_ - _loc3_.y) / 4;
         }
         else
         {
            _loc3_.y = _loc5_;
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
         var _loc3_:* = undefined;
         var _loc1_:* = this.getQuestValidationString(this.qData);
         if(this.qData.hasOwnProperty("sMeta") && this.qData.sMeta.indexOf("EmailConfirm") != -1 && this.world.myAvatar.objData.intActivationFlag < 5)
         {
            this.rootClass.MsgBox.notify("Confirmed Contact Email Address Required");
         }
         else if(_loc1_ != "")
         {
            MovieClip(Game.root).MsgBox.notify(_loc1_);
         }
         else if(this.world.coolDown("acceptQuest"))
         {
            _loc3_ = MovieClip(param1.currentTarget);
            this.setCT(_loc3_.bg,43775);
            _loc3_.removeEventListener(MouseEvent.CLICK,this.btnAccept);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
            _loc3_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
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
         var _loc3_:int = 0;
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
            _loc1_.removeEventListener(MouseEvent.CLICK,this.btnAbandon);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OVER,this.bMouseOver);
            _loc1_.removeEventListener(MouseEvent.MOUSE_OUT,this.bMouseOut);
            _loc3_ = this.qStep != null ? this.qStep.value : 1;
            this.killStepper();
            this.mc.cnt.gotoAndPlay("hold");
            this.getQuestListA();
            this.world.tryQuestComplete(this.qData.QuestID,this.choiceID,false,_loc3_);
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
         var _loc4_:MovieClip = null;
         var _loc1_:MovieClip = param1.currentTarget as MovieClip;
         var _loc3_:MovieClip = _loc1_.parent as MovieClip;
         this.choiceID = _loc1_.ItemID;
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.numChildren)
         {
            _loc4_ = _loc3_.getChildAt(_loc5_) as MovieClip;
            if(!(_loc4_ == null || _loc4_.ItemID == undefined || !("bg" in _loc4_) || _loc4_.bg == null))
            {
               _loc4_.bg.filters = this.choiceID == _loc4_.ItemID ? [CHOICE_GLOW] : [];
            }
            _loc5_++;
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
         var _loc3_:* = param1.transform.colorTransform;
         _loc3_.color = param2;
         param1.transform.colorTransform = _loc3_;
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
