package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   import liteAssets.mobile.*;

   public class MailWindow extends Sprite
   {

      private static const W:int = 660;

      private static const H:int = 430;

      private static const ROW_H:int = 58;

      private static const LIST_X:int = 16;

      private static const LIST_Y:int = 72;

      private static const LIST_W:int = 222;

      private static const LIST_H:int = 340;

      private static const BODY_X:int = 264;

      private static const BODY_W:int = 368;

      private static const CARD_X0:int = 14;

      private var hub:MailHub;

      private var rootClass:MovieClip;

      private var bg:MovieClip;

      private var fallbackBg:Shape;

      private var fallbackTitle:TextField;

      private var fallbackClose:Sprite;

      private var fmtHeaderGold:TextFormat;

      private var fmtHeaderCount:TextFormat;

      private var fmtFromLabel:TextFormat;

      private var fmtFromName:TextFormat;

      private var fmtTrayLabelGold:TextFormat;

      private var fmtTrayLabelCount:TextFormat;

      private var tfListHeader:TextField;

      private var tfListUnread:TextField;

      private var listViewport:Sprite;

      private var listHolder:Sprite;

      private var rows:Array = [];

      private var rowsFirst:int = -1;

      private var listRowW:int = 0;

      private var listScrollY:int = 0;

      private var sbTrack:Sprite;

      private var sbThumb:Sprite;

      private var listThumbH:int = 0;

      private var emptyEnvelope:Shape;

      private var emptyLabel:TextField;

      private var parchment:Shape;

      private var tfSubject:TextField;

      private var tfMetaFrom:TextField;

      private var tfMetaDate:TextField;

      private var tfExpiry:TextField;

      private var divider:Shape;

      private var emptyLetterLabel:TextField;

      private var bodyViewport:Sprite;

      private var bodyHolder:Sprite;

      private var bodyScrollY:Number = 0;

      private var bodyContentH:Number = 0;

      private var bodyVpH:Number = 0;

      private var bodySbTrack:Sprite;

      private var bodySbThumb:Sprite;

      private var bodyThumbH:int = 0;

      private var loaders:Array = [];

      private var imgMeta:Dictionary = new Dictionary();

      private var tray:Sprite;

      private var trayClaimBtn:Sprite;

      private var tfTrayLabel:TextField;

      private var tfTrayStatus:TextField;

      private var cards:Array = [];

      private var cardView:Sprite;

      private var cardSbTrack:Sprite;

      private var cardSbThumb:Sprite;

      private var cardScrollY:Number = 0;

      private var cardViewH:Number = 0;

      private var cardContentH:Number = 0;

      private var cardThumbH:int = 0;

      private var listTouch:TouchScroll;

      private var bodyTouch:TouchScroll;

      private var cardTouch:TouchScroll;

      private var trayM:Object;

      private var trayMailId:* = null;

      private var trayClaimed:Boolean = false;

      private var paneM:Object;

      private var blockedTip:Boolean = false;

      private var selectedId:* = null;

      private var wheelStage:Stage;

      private var dragStage:Stage;

      private var dragMode:String = "";

      private var dragOff:Number = 0;

      private var cardAnimRunning:Boolean = false;

      private var animDeadline:int = 0;

      private var destroyed:Boolean = false;

      public function MailWindow(param1:MailHub)
      {
         super();
         this.hub = param1;
         this.rootClass = param1.rootClass;
         x = 150;
         y = 45;
         this.buildFormats();
         this.buildChrome();
         this.buildListPanel();
         this.buildLetterPane();
         this.listTouch = TouchScroll.attach(this.listViewport,this.getListPos,this.setListPos,this.getListMax);
         this.bodyTouch = TouchScroll.attach(this.bodyViewport,this.getBodyPos,this.setBodyPos,this.getBodyMax);
         if(stage != null)
         {
            this.hookWheel();
         }
         else
         {
            addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage,false,0,true);
         }
      }

      private static function setRuns(param1:TextField, param2:String, param3:TextFormat, param4:String, param5:TextFormat) : void
      {
         param1.text = param2 + param4;
         if(param2.length > 0)
         {
            param1.setTextFormat(param3,0,param2.length);
         }
         if(param4.length > 0)
         {
            param1.setTextFormat(param5,param2.length,param2.length + param4.length);
         }
      }

      private static function clampLines(param1:TextField, param2:String, param3:int) : void
      {
         var _loc1_:int = 0;
         param1.text = param2;
         if(param1.numLines <= param3)
         {
            param1.height = param1.textHeight + 4;
            return;
         }
         var _loc2_:int = 0;
         var _loc3_:int = param2.length - 1;
         var _loc4_:int = 0;
         while(_loc2_ <= _loc3_)
         {
            _loc1_ = _loc2_ + _loc3_ >> 1;
            param1.text = param2.substr(0,_loc1_) + "…";
            if(param1.numLines <= param3)
            {
               _loc4_ = _loc1_;
               _loc2_ = _loc1_ + 1;
            }
            else
            {
               _loc3_ = _loc1_ - 1;
            }
         }
         param1.text = param2.substr(0,_loc4_) + "…";
         param1.height = param1.textHeight + 4;
      }

      public function refresh() : void
      {
         if(this.destroyed)
         {
            return;
         }
         var _loc5_:Object = this.ensureSelection();
         this.rebuildRows();
         this.updateListHeader();
         if(_loc5_ != null && _loc5_ === this.paneM)
         {
            this.refreshTray(_loc5_);
         }
         else
         {
            this.rebuildLetterPane(_loc5_);
         }
         this.updateCardAnimState();
      }

      private function refreshTray(param1:Object) : void
      {
         if(this.tray == null && (param1.att == null || param1.att.length == 0))
         {
            return;
         }
         if(this.tray != null && this.trayMailId == param1.id && this.trayClaimed == this.hub.isClaimed(param1) && this.cards.length == param1.att.length)
         {
            this.updateTrayState(param1);
            return;
         }
         this.clearTray();
         this.buildTrayIfAny(param1);
         this.bodyVpH = Math.max(0,this.trayTopFor(param1) - 8 - this.bodyViewport.y);
         this.layoutBodyScrollbar();
      }

      public function refreshRows() : void
      {
         if(this.destroyed)
         {
            return;
         }
         this.renderRows(true);
      }

      public function claimDone(param1:Object, param2:Array) : void
      {
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         if(Boolean(this.destroyed) || this.paneM == null || param1 == null || this.paneM.id != param1.id)
         {
            return;
         }
         this.clearTray();
         this.buildTrayIfAny(param1);
         this.bodyVpH = Math.max(0,this.trayTopFor(param1) - 8 - this.bodyViewport.y);
         this.layoutBodyScrollbar();
         if(param2 != null && param2.length > 0)
         {
            _loc6_ = 0;
            while(_loc6_ < param2.length)
            {
               _loc2_ = int(param2[_loc6_]);
               if(_loc2_ >= 0 && _loc2_ < this.cards.length && this.cards[_loc2_] != null)
               {
                  MailCard(this.cards[_loc2_]).pop(_loc6_ * 90);
               }
               _loc6_++;
            }
            this.animDeadline = getTimer() + param2.length * 90 + 260 + 60;
         }
         this.updateCardAnimState();
      }

      public function bodyLoaded(param1:Object) : void
      {
         if(Boolean(this.destroyed) || this.paneM == null || param1 == null || this.paneM.id != param1.id)
         {
            return;
         }
         this.clearBodyContent();
         this.buildBodyContent(param1);
      }

      public function destroy() : void
      {
         var _loc5_:int = 0;
         var _loc7_:MailRow = null;
         if(this.destroyed)
         {
            return;
         }
         this.destroyed = true;
         this.unhookWheel();
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.removeDragListeners();
         if(this.cardAnimRunning)
         {
            removeEventListener(Event.ENTER_FRAME,this.onCardTick);
            this.cardAnimRunning = false;
         }
         if(this.listTouch != null)
         {
            this.listTouch.detach();
         }
         if(this.bodyTouch != null)
         {
            this.bodyTouch.detach();
         }
         this.listTouch = null;
         this.bodyTouch = null;
         this.clearBodyContent();
         this.clearTray();
         _loc5_ = 0;
         while(_loc5_ < this.rows.length)
         {
            _loc7_ = this.rows[_loc5_];
            _loc7_.removeEventListener(MouseEvent.CLICK,this.onRowClick);
            _loc7_.removeEventListener(MouseEvent.ROLL_OVER,this.onRowOver);
            _loc7_.removeEventListener(MouseEvent.ROLL_OUT,this.onRowOut);
            _loc7_.destroy();
            _loc5_++;
         }
         this.rows = [];
         try
         {
            this.sbTrack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onListTrackDown);
         }
         catch(e:Error)
         {
         }
         try
         {
            this.bodySbTrack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBodyTrackDown);
         }
         catch(e2:Error)
         {
         }
         try
         {
            if(this.bg != null && this.bg.btnClose != null)
            {
               this.bg.btnClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
            }
         }
         catch(e3:Error)
         {
         }
         if(this.fallbackClose != null)
         {
            this.fallbackClose.removeEventListener(MouseEvent.CLICK,this.onCloseClick);
         }
         try
         {
            this.rootClass.ui.ToolTip.close();
         }
         catch(e4:Error)
         {
         }
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
      }

      private function buildFormats() : void
      {
         this.fmtHeaderGold = MailArt.fmt(12,MailArt.GOLD,true);
         this.fmtHeaderCount = MailArt.fmt(12,10066329);
         this.fmtFromLabel = MailArt.fmt(11,7032366,true);
         this.fmtFromName = MailArt.fmt(11,7032366);
         this.fmtTrayLabelGold = MailArt.fmt(11,MailArt.GOLD,true);
         this.fmtTrayLabelCount = MailArt.fmt(11,12303291);
      }

      private function buildChrome() : void
      {
         var cls:Class = null;
         try
         {
            cls = getDefinitionByName("LPFPanelBg") as Class;
         }
         catch(e:Error)
         {
            cls = null;
         }
         if(cls != null)
         {
            try
            {
               this.bg = new cls() as MovieClip;
            }
            catch(e2:Error)
            {
               bg = null;
            }
         }
         if(this.bg != null)
         {
            addChildAt(this.bg,0);
            try
            {
               this.bg.frame.width = W;
               this.bg.frame.height = H;
               this.bg.bg.width = W - 12;
               this.bg.bg.height = H - 10;
               this.bg.btnClose.x = W - 31;
            }
            catch(e3:Error)
            {
            }
            try
            {
               if("dragonLeft" in this.bg)
               {
                  this.bg.dragonLeft.visible = false;
               }
            }
            catch(e4:Error)
            {
            }
            try
            {
               if("dragonRight" in this.bg)
               {
                  this.bg.dragonRight.visible = false;
               }
            }
            catch(e5:Error)
            {
            }
            try
            {
               this.bg.tTitle.text = "Mailbox";
               this.bg.tTitle.textColor = 16777215;
               this.bg.tTitle.x = int(330 - this.bg.tTitle.width / 2);
            }
            catch(e6:Error)
            {
            }
            try
            {
               this.bg.btnClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
            }
            catch(e7:Error)
            {
            }
         }
         else
         {
            this.buildFallbackChrome();
         }
      }

      private function buildFallbackChrome() : void
      {
         this.fallbackBg = new Shape();
         var _loc5_:Graphics = this.fallbackBg.graphics;
         _loc5_.beginFill(1710618);
         _loc5_.lineStyle(2,MailArt.TRIM,1,true);
         _loc5_.drawRoundRect(0,0,W,H,12,12);
         _loc5_.endFill();
         addChildAt(this.fallbackBg,0);
         this.fallbackTitle = MailArt.tf(14,16777215,true);
         this.fallbackTitle.text = "Mailbox";
         this.fallbackTitle.x = int(330 - this.fallbackTitle.width / 2);
         this.fallbackTitle.y = 10;
         addChild(this.fallbackTitle);
         this.fallbackClose = new Sprite();
         var _loc7_:Graphics = this.fallbackClose.graphics;
         _loc7_.beginFill(3807770);
         _loc7_.lineStyle(1,9054762,1,true);
         _loc7_.drawRoundRect(0,0,22,22,6,6);
         _loc7_.endFill();
         var _loc6_:TextField = MailArt.tf(12,16748688,true);
         _loc6_.text = "X";
         _loc6_.x = Math.round((22 - _loc6_.width) / 2);
         _loc6_.y = Math.round((22 - _loc6_.height) / 2);
         this.fallbackClose.addChild(_loc6_);
         this.fallbackClose.x = W - 31;
         this.fallbackClose.y = 8;
         this.fallbackClose.buttonMode = true;
         this.fallbackClose.mouseChildren = false;
         this.fallbackClose.addEventListener(MouseEvent.CLICK,this.onCloseClick,false,0,true);
         addChild(this.fallbackClose);
      }

      private function onCloseClick(param1:MouseEvent) : void
      {
         try
         {
            this.hub.closeWindow();
         }
         catch(err:Error)
         {
         }
      }

      private function buildListPanel() : void
      {
         var _loc5_:Shape = new Shape();
         var _loc7_:Graphics = _loc5_.graphics;
         _loc7_.beginFill(657930);
         _loc7_.lineStyle(1,2763306,1,true);
         _loc7_.drawRoundRect(14,44,226,372,12,12);
         _loc7_.endFill();
         addChild(_loc5_);
         this.tfListHeader = MailArt.tf(12,MailArt.GOLD,true);
         this.tfListHeader.x = 24;
         this.tfListHeader.y = 50;
         addChild(this.tfListHeader);
         this.tfListUnread = MailArt.tf(11,12303291);
         this.tfListUnread.y = 52;
         addChild(this.tfListUnread);
         this.listViewport = new Sprite();
         this.listViewport.x = LIST_X;
         this.listViewport.y = LIST_Y;
         this.listViewport.opaqueBackground = 657930;
         addChild(this.listViewport);
         this.listHolder = new Sprite();
         this.listViewport.addChild(this.listHolder);
         this.sbTrack = new Sprite();
         this.sbThumb = new Sprite();
         this.sbTrack.addChild(this.sbThumb);
         addChild(this.sbTrack);
         this.sbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onListTrackDown,false,0,true);
         this.emptyEnvelope = new Shape();
         addChild(this.emptyEnvelope);
         this.emptyLabel = MailArt.tf(12,10066329);
         this.emptyLabel.text = "No letters yet";
         addChild(this.emptyLabel);
      }

      private function buildLetterPane() : void
      {
         this.parchment = new Shape();
         addChild(this.parchment);
         this.drawParchment();
         this.tfSubject = MailArt.tf(16,3875858,true);
         this.tfSubject.multiline = true;
         this.tfSubject.wordWrap = true;
         this.tfSubject.autoSize = TextFieldAutoSize.NONE;
         this.tfSubject.width = BODY_W;
         this.tfSubject.x = BODY_X;
         this.tfSubject.y = 54;
         addChild(this.tfSubject);
         this.tfMetaFrom = MailArt.tf(11,7032366,true);
         addChild(this.tfMetaFrom);
         this.tfMetaDate = MailArt.tf(11,8019002);
         addChild(this.tfMetaDate);
         this.tfExpiry = MailArt.tf(11,8019002);
         addChild(this.tfExpiry);
         this.divider = new Shape();
         addChild(this.divider);
         this.bodyViewport = new Sprite();
         this.bodyViewport.x = BODY_X;
         addChild(this.bodyViewport);
         this.bodyHolder = new Sprite();
         this.bodyViewport.addChild(this.bodyHolder);
         this.bodySbTrack = new Sprite();
         this.bodySbThumb = new Sprite();
         this.bodySbTrack.addChild(this.bodySbThumb);
         addChild(this.bodySbTrack);
         this.bodySbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onBodyTrackDown,false,0,true);
         this.emptyLetterLabel = MailArt.tf(13,7032366);
         this.emptyLetterLabel.text = "Letters from the AQW Team will appear here.";
         this.emptyLetterLabel.multiline = true;
         this.emptyLetterLabel.wordWrap = true;
         this.emptyLetterLabel.autoSize = TextFieldAutoSize.NONE;
         this.emptyLetterLabel.width = BODY_W;
         addChild(this.emptyLetterLabel);
      }

      private function drawParchment() : void
      {
         var _loc5_:Graphics = this.parchment.graphics;
         _loc5_.clear();
         var _loc7_:Matrix = new Matrix();
         _loc7_.createGradientBox(396,372,Math.PI / 2,250,44);
         _loc5_.beginGradientFill(GradientType.LINEAR,[16182223,15258789],[1,1],[0,255],_loc7_);
         _loc5_.lineStyle(2,9071162,1,true);
         _loc5_.drawRoundRect(250,44,396,372,16,16);
         _loc5_.endFill();
         _loc5_.lineStyle(1,13215594,0.6,true);
         _loc5_.drawRoundRect(254,48,388,364,12,12);
      }

      private function isSelected(param1:Object) : Boolean
      {
         return this.selectedId != null && param1.id == this.selectedId;
      }

      private function selectMail(param1:Object) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc7_:Boolean = this.selectedId != param1.id;
         this.selectedId = param1.id;
         try
         {
            this.hub.markRead(param1);
         }
         catch(e:Error)
         {
         }
         if(_loc7_)
         {
            this.bodyScrollY = 0;
            param1.bodyErr = false;
         }
      }

      private function ensureSelection() : Object
      {
         var _loc7_:int = 0;
         var _loc5_:Array = this.hub.mails;
         if(this.selectedId != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_.length)
            {
               if(_loc5_[_loc7_].id == this.selectedId)
               {
                  return _loc5_[_loc7_];
               }
               _loc7_++;
            }
         }
         _loc7_ = 0;
         while(_loc7_ < _loc5_.length)
         {
            if(_loc5_[_loc7_].read != 1)
            {
               this.selectMail(_loc5_[_loc7_]);
               return _loc5_[_loc7_];
            }
            _loc7_++;
         }
         if(_loc5_.length > 0)
         {
            this.selectMail(_loc5_[0]);
            return _loc5_[0];
         }
         this.selectedId = null;
         return null;
      }

      private function rebuildRows() : void
      {
         var _loc1_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:MailRow = null;
         var _loc5_:Array = this.hub.mails;
         var _loc7_:int = int(_loc5_.length);
         var _loc6_:Boolean = _loc7_ * ROW_H > LIST_H;
         var _loc2_:int = LIST_W - (_loc6_ ? 10 : 2);
         if(this.rows.length == 0)
         {
            _loc1_ = Math.ceil(LIST_H / ROW_H) + 1;
            _loc8_ = 0;
            while(_loc8_ < _loc1_)
            {
               _loc9_ = new MailRow();
               _loc9_.visible = false;
               _loc9_.addEventListener(MouseEvent.CLICK,this.onRowClick,false,0,true);
               _loc9_.addEventListener(MouseEvent.ROLL_OVER,this.onRowOver,false,0,true);
               _loc9_.addEventListener(MouseEvent.ROLL_OUT,this.onRowOut,false,0,true);
               this.listHolder.addChild(_loc9_);
               this.rows.push(_loc9_);
               _loc8_++;
            }
         }
         var _loc3_:int = _loc7_ * ROW_H;
         var _loc4_:int = _loc3_ - LIST_H;
         if(_loc4_ < 0)
         {
            _loc4_ = 0;
         }
         if(this.listScrollY > _loc4_)
         {
            this.listScrollY = _loc4_;
         }
         if(this.listScrollY < 0)
         {
            this.listScrollY = 0;
         }
         this.listRowW = _loc2_;
         this.listViewport.scrollRect = new Rectangle(0,this.listScrollY,_loc2_,LIST_H);
         this.renderRows(true);
         this.updateListScrollbar(_loc3_,_loc6_);
         this.maybeLoadMore();
         this.emptyEnvelope.visible = _loc7_ == 0;
         this.emptyLabel.visible = _loc7_ == 0;
         if(_loc7_ == 0)
         {
            this.emptyEnvelope.graphics.clear();
            MailArt.envelope(this.emptyEnvelope.graphics,0,0,60,40,false,false);
            this.emptyEnvelope.alpha = 0.35;
            this.emptyEnvelope.x = LIST_X + Math.round((LIST_W - 60) / 2);
            this.emptyEnvelope.y = LIST_Y + Math.round((LIST_H - 40) / 2) - 14;
            this.emptyLabel.x = LIST_X + Math.round((LIST_W - this.emptyLabel.width) / 2);
            this.emptyLabel.y = this.emptyEnvelope.y + 50;
         }
      }

      private function renderRows(param1:Boolean) : void
      {
         var _loc3_:MailRow = null;
         var _loc4_:int = 0;
         var _loc1_:Object = null;
         var _loc7_:int = int(this.listScrollY / ROW_H);
         if(!param1 && _loc7_ == this.rowsFirst)
         {
            return;
         }
         this.rowsFirst = _loc7_;
         var _loc6_:Array = this.hub.mails;
         var _loc2_:int = 0;
         while(_loc2_ < this.rows.length)
         {
            _loc3_ = this.rows[_loc2_];
            _loc4_ = _loc7_ + _loc2_;
            if(_loc4_ < _loc6_.length)
            {
               _loc1_ = _loc6_[_loc4_];
               _loc3_.y = _loc4_ * ROW_H;
               _loc3_.bind(_loc1_,this.listRowW,this.isSelected(_loc1_),this.hub.isClaimed(_loc1_),this.hub.hasRewards(_loc1_));
               _loc3_.visible = true;
            }
            else if(_loc3_.visible)
            {
               _loc3_.setHover(false);
               _loc3_.visible = false;
            }
            _loc2_++;
         }
      }

      private function updateListHeader() : void
      {
         var _loc2_:int = 0;
         var _loc5_:Array = this.hub.mails;
         var _loc7_:int = int(_loc5_.length);
         var _loc6_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            if(_loc5_[_loc2_].read != 1)
            {
               _loc6_++;
            }
            _loc2_++;
         }
         setRuns(this.tfListHeader,"Letters",this.fmtHeaderGold," (" + _loc7_ + (this.hub.hasMore() ? "+" : "") + ")",this.fmtHeaderCount);
         this.tfListUnread.visible = _loc6_ > 0;
         if(_loc6_ > 0)
         {
            this.tfListUnread.text = _loc6_ + " unread";
            this.tfListUnread.x = Math.round(240 - 10 - this.tfListUnread.width);
            this.tfListUnread.y = 52;
         }
      }

      private function onRowClick(param1:MouseEvent) : void
      {
         var _loc7_:MailRow = null;
         var _loc6_:Object = null;
         var _loc2_:Boolean = false;
         try
         {
            _loc7_ = param1.currentTarget as MailRow;
            if(_loc7_ == null || _loc7_.mail == null)
            {
               return;
            }
            _loc6_ = _loc7_.mail;
            _loc2_ = this.selectedId != null && _loc6_.id == this.selectedId;
            this.selectMail(_loc6_);
            this.refresh();
            if(_loc2_ && _loc6_.body == null && Boolean(_loc6_.bodyErr))
            {
               _loc6_.bodyErr = false;
               this.bodyLoaded(_loc6_);
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onRowOver(param1:MouseEvent) : void
      {
         var _loc7_:MailRow = null;
         try
         {
            _loc7_ = param1.currentTarget as MailRow;
            if(_loc7_ != null)
            {
               _loc7_.setHover(true);
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onRowOut(param1:MouseEvent) : void
      {
         var _loc7_:MailRow = null;
         try
         {
            _loc7_ = param1.currentTarget as MailRow;
            if(_loc7_ != null)
            {
               _loc7_.setHover(false);
            }
         }
         catch(err:Error)
         {
         }
      }

      private function updateListScrollbar(param1:int, param2:Boolean) : void
      {
         this.sbTrack.x = LIST_X + LIST_W - 6;
         this.sbTrack.y = LIST_Y;
         this.sbTrack.visible = param2;
         if(!param2)
         {
            return;
         }
         var _loc6_:Graphics = this.sbTrack.graphics;
         _loc6_.clear();
         _loc6_.beginFill(1710618);
         _loc6_.drawRoundRect(0,0,6,LIST_H,6,6);
         _loc6_.endFill();
         var _loc2_:int = int(LIST_H * LIST_H / param1);
         if(_loc2_ < 24)
         {
            _loc2_ = 24;
         }
         if(_loc2_ > LIST_H)
         {
            _loc2_ = int(LIST_H);
         }
         this.listThumbH = _loc2_;
         var _loc3_:Graphics = this.sbThumb.graphics;
         _loc3_.clear();
         var _loc4_:Matrix = new Matrix();
         _loc4_.createGradientBox(6,this.listThumbH,0,0,0);
         _loc3_.lineStyle(1,MailArt.TRIM,1,true);
         _loc3_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc4_);
         _loc3_.drawRoundRect(0,0,6,this.listThumbH,6,6);
         _loc3_.endFill();
         var _loc1_:int = param1 - LIST_H;
         this.sbThumb.y = _loc1_ > 0 ? int((LIST_H - this.listThumbH) * this.listScrollY / _loc1_) : 0;
      }

      private function getListPos() : Number
      {
         return this.listScrollY;
      }

      private function setListPos(param1:Number) : void
      {
         this.listScrollY = int(param1);
         this.applyListScroll();
      }

      private function getListMax() : Number
      {
         return Math.max(0,this.hub.mails.length * ROW_H - LIST_H);
      }

      private function getBodyPos() : Number
      {
         return this.bodyScrollY;
      }

      private function setBodyPos(param1:Number) : void
      {
         this.bodyScrollY = param1;
         this.applyBodyScroll();
      }

      private function getBodyMax() : Number
      {
         return Math.max(0,this.bodyContentH - this.bodyVpH);
      }

      private function getCardPos() : Number
      {
         return this.cardScrollY;
      }

      private function setCardPos(param1:Number) : void
      {
         this.cardScrollY = param1;
         this.applyCardScroll();
      }

      private function getCardMax() : Number
      {
         return Math.max(0,this.cardContentH - this.cardViewH);
      }

      private function clampListScroll(param1:int) : void
      {
         if(this.listScrollY > param1)
         {
            this.listScrollY = param1;
         }
         if(this.listScrollY < 0)
         {
            this.listScrollY = 0;
         }
      }

      private function applyListScroll() : void
      {
         var _loc5_:int = this.sbTrack.visible ? int(LIST_W - 10) : int(LIST_W - 2);
         this.listViewport.scrollRect = new Rectangle(0,this.listScrollY,_loc5_,LIST_H);
         var _loc7_:Array = this.hub.mails;
         var _loc6_:int = _loc7_.length * ROW_H;
         var _loc2_:int = _loc6_ - LIST_H;
         this.sbThumb.y = _loc2_ > 0 ? int((LIST_H - this.listThumbH) * this.listScrollY / _loc2_) : 0;
         this.renderRows(false);
         this.maybeLoadMore();
      }

      private function maybeLoadMore() : void
      {
         var _loc5_:int = 0;
         try
         {
            if(!this.hub.hasMore())
            {
               return;
            }
            _loc5_ = this.hub.mails.length * ROW_H - LIST_H;
            if(_loc5_ <= 0 || this.listScrollY >= _loc5_ - ROW_H)
            {
               this.hub.loadMore();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onListTrackDown(param1:MouseEvent) : void
      {
         var _loc7_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         try
         {
            _loc7_ = this.hub.mails;
            _loc6_ = _loc7_.length * ROW_H;
            _loc2_ = _loc6_ - LIST_H;
            if(_loc2_ <= 0)
            {
               return;
            }
            if(param1.target == this.sbThumb)
            {
               this.dragMode = "list";
               this.dragOff = this.sbTrack.mouseY - this.sbThumb.y;
               this.dragStage = stage;
               if(this.dragStage != null)
               {
                  this.dragStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove,false,0,true);
                  this.dragStage.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp,false,0,true);
               }
            }
            else
            {
               this.listScrollY += this.sbTrack.mouseY < this.sbThumb.y ? -LIST_H : LIST_H;
               this.clampListScroll(_loc2_);
               this.applyListScroll();
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onDragMove(param1:MouseEvent) : void
      {
         var _loc7_:Array = null;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         try
         {
            if(this.dragMode == "list")
            {
               _loc7_ = this.hub.mails;
               _loc6_ = _loc7_.length * ROW_H;
               _loc2_ = _loc6_ - LIST_H;
               _loc3_ = LIST_H - this.listThumbH;
               if(_loc3_ <= 0 || _loc2_ <= 0)
               {
                  return;
               }
               _loc4_ = this.sbTrack.mouseY - this.dragOff;
               if(_loc4_ < 0)
               {
                  _loc4_ = 0;
               }
               else if(_loc4_ > _loc3_)
               {
                  _loc4_ = _loc3_;
               }
               this.listScrollY = int(_loc4_ / _loc3_ * _loc2_);
               this.applyListScroll();
            }
            else if(this.dragMode == "body")
            {
               _loc1_ = this.bodyContentH - this.bodyVpH;
               _loc8_ = this.bodyVpH - this.bodyThumbH;
               if(_loc8_ <= 0 || _loc1_ <= 0)
               {
                  return;
               }
               _loc9_ = this.bodySbTrack.mouseY - this.dragOff;
               if(_loc9_ < 0)
               {
                  _loc9_ = 0;
               }
               else if(_loc9_ > _loc8_)
               {
                  _loc9_ = _loc8_;
               }
               this.bodyScrollY = int(_loc9_ / _loc8_ * _loc1_);
               this.applyBodyScroll();
            }
            else if(this.dragMode == "cards")
            {
               _loc10_ = this.cardContentH - this.cardViewH;
               _loc11_ = this.cardViewH - this.cardThumbH;
               if(_loc11_ <= 0 || _loc10_ <= 0 || this.cardSbTrack == null)
               {
                  return;
               }
               _loc12_ = this.cardSbTrack.mouseY - this.dragOff;
               if(_loc12_ < 0)
               {
                  _loc12_ = 0;
               }
               else if(_loc12_ > _loc11_)
               {
                  _loc12_ = _loc11_;
               }
               this.cardScrollY = int(_loc12_ / _loc11_ * _loc10_);
               this.applyCardScroll();
            }
            param1.updateAfterEvent();
         }
         catch(err:Error)
         {
         }
      }

      private function onDragUp(param1:MouseEvent) : void
      {
         try
         {
            this.removeDragListeners();
            this.dragMode = "";
         }
         catch(err:Error)
         {
         }
      }

      private function removeDragListeners() : void
      {
         if(this.dragStage != null)
         {
            this.dragStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove);
            this.dragStage.removeEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
            this.dragStage = null;
         }
      }

      private function hookWheel() : void
      {
         if(this.wheelStage != null || stage == null)
         {
            return;
         }
         this.wheelStage = stage;
         this.wheelStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,true,0,true);
      }

      private function unhookWheel() : void
      {
         if(this.wheelStage == null)
         {
            return;
         }
         this.wheelStage.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onWheel,true);
         this.wheelStage = null;
      }

      private function onAddedToStage(param1:Event) : void
      {
         try
         {
            removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
            this.hookWheel();
         }
         catch(err:Error)
         {
         }
      }

      private function onWheel(param1:MouseEvent) : void
      {
         var _loc7_:DisplayObject = null;
         var _loc6_:Point = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:Number = NaN;
         var _loc8_:Point = null;
         if(this.destroyed)
         {
            return;
         }
         try
         {
            _loc7_ = param1.target as DisplayObject;
            if(_loc7_ == null || !contains(_loc7_))
            {
               return;
            }
            _loc6_ = globalToLocal(new Point(param1.stageX,param1.stageY));
            if(_loc6_.x >= LIST_X && _loc6_.x < LIST_X + LIST_W && _loc6_.y >= LIST_Y && _loc6_.y < LIST_Y + LIST_H)
            {
               _loc2_ = this.hub.mails;
               _loc3_ = _loc2_.length * ROW_H;
               _loc4_ = _loc3_ - LIST_H;
               if(_loc4_ > 0)
               {
                  this.listScrollY -= param1.delta * int(ROW_H / 3);
                  this.clampListScroll(_loc4_);
                  this.applyListScroll();
               }
               param1.stopPropagation();
            }
            else if(Boolean(this.bodyViewport.visible) && _loc6_.x >= BODY_X && _loc6_.x < BODY_X + BODY_W + 10 && _loc6_.y >= this.bodyViewport.y && _loc6_.y < this.bodyViewport.y + this.bodyVpH)
            {
               _loc1_ = this.bodyContentH - this.bodyVpH;
               if(_loc1_ > 0)
               {
                  this.bodyScrollY -= param1.delta * 12;
                  if(this.bodyScrollY < 0)
                  {
                     this.bodyScrollY = 0;
                  }
                  if(this.bodyScrollY > _loc1_)
                  {
                     this.bodyScrollY = _loc1_;
                  }
                  this.applyBodyScroll();
               }
               param1.stopPropagation();
            }
            else if(this.cardSbTrack != null && this.tray != null)
            {
               _loc8_ = this.tray.globalToLocal(new Point(param1.stageX,param1.stageY));
               if(_loc8_.x >= 0 && _loc8_.x < 380 && _loc8_.y >= 22 && _loc8_.y < 22 + this.cardViewH)
               {
                  this.cardScrollY -= param1.delta * 27;
                  this.clampCardScroll();
                  this.applyCardScroll();
                  param1.stopPropagation();
               }
            }
         }
         catch(err:Error)
         {
         }
      }

      private function trayTopFor(param1:Object) : Number
      {
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:Number = NaN;
         if(param1.att != null && param1.att.length > 0)
         {
            _loc7_ = int(param1.att.length);
            _loc6_ = Math.ceil(_loc7_ / 5);
            if(_loc6_ < 1)
            {
               _loc6_ = 1;
            }
            if(_loc6_ > 2)
            {
               _loc6_ = 2;
            }
            _loc2_ = 22 + _loc6_ * 80 + 40;
            return 410 - _loc2_;
         }
         return 410;
      }

      private function rebuildLetterPane(param1:Object) : void
      {
         this.clearBodyContent();
         this.clearTray();
         this.paneM = param1;
         this.cardScrollY = 0;
         if(param1 == null)
         {
            this.tfSubject.visible = false;
            this.tfMetaFrom.visible = false;
            this.tfMetaDate.visible = false;
            this.tfExpiry.visible = false;
            this.divider.visible = false;
            this.bodyViewport.visible = false;
            this.bodySbTrack.visible = false;
            this.emptyLetterLabel.visible = true;
            this.emptyLetterLabel.height = this.emptyLetterLabel.textHeight + 4;
            this.emptyLetterLabel.x = BODY_X + Math.round((BODY_W - this.emptyLetterLabel.width) / 2);
            this.emptyLetterLabel.y = 44 + Math.round((372 - this.emptyLetterLabel.height) / 2);
            return;
         }
         this.emptyLetterLabel.visible = false;
         this.tfSubject.visible = true;
         this.tfMetaFrom.visible = true;
         this.tfMetaDate.visible = true;
         this.divider.visible = true;
         this.bodyViewport.visible = true;
         var _loc7_:String = param1.subj != null ? String(param1.subj) : "";
         this.tfSubject.text = _loc7_;
         MailArt.cover(this.tfSubject);
         clampLines(this.tfSubject,_loc7_,2);
         var _loc6_:Number = this.tfSubject.y + this.tfSubject.height + 4;
         setRuns(this.tfMetaFrom,"From: ",this.fmtFromLabel,param1.from != null ? String(param1.from) : "",this.fmtFromName);
         MailArt.cover(this.tfMetaFrom);
         MailArt.fit(this.tfMetaFrom,BODY_W);
         this.tfMetaFrom.x = BODY_X;
         this.tfMetaFrom.y = _loc6_;
         this.tfMetaDate.text = "  ·  " + MailArt.dateLong(Number(param1.sent));
         this.tfMetaDate.x = this.tfMetaFrom.x + this.tfMetaFrom.width;
         this.tfMetaDate.y = _loc6_;
         var _loc2_:Number = Math.max(this.tfMetaFrom.height,this.tfMetaDate.height);
         if(this.tfMetaDate.x + this.tfMetaDate.width > BODY_X + BODY_W)
         {
            this.tfMetaDate.text = MailArt.dateLong(Number(param1.sent));
            this.tfMetaDate.x = BODY_X;
            this.tfMetaDate.y = _loc6_ + _loc2_;
         }
         var _loc3_:Number = this.tfMetaDate.x + this.tfMetaDate.width;
         if(param1.exp != null)
         {
            this.tfExpiry.visible = true;
            this.tfExpiry.text = MailArt.expiryText(Number(param1.exp));
            this.tfExpiry.textColor = MailArt.soon(Number(param1.exp)) ? 11680286 : 8019002;
            this.tfExpiry.x = Math.round(632 - this.tfExpiry.width);
            this.tfExpiry.y = this.tfMetaDate.y;
            if(this.tfExpiry.x < _loc3_ + 12)
            {
               this.tfExpiry.y = this.tfMetaDate.y + _loc2_;
            }
         }
         else
         {
            this.tfExpiry.visible = false;
         }
         var _loc4_:Number = this.tfMetaDate.y + _loc2_;
         if(Boolean(this.tfExpiry.visible) && this.tfExpiry.y + _loc2_ > _loc4_)
         {
            _loc4_ = this.tfExpiry.y + _loc2_;
         }
         var _loc1_:Number = _loc4_ + 6;
         this.divider.graphics.clear();
         this.divider.graphics.lineStyle(1,11570519,1,true);
         this.divider.graphics.moveTo(264,_loc1_);
         this.divider.graphics.lineTo(632,_loc1_);
         var _loc8_:Number = 448;
         this.divider.graphics.beginFill(11570519);
         this.divider.graphics.moveTo(_loc8_,_loc1_ - 3);
         this.divider.graphics.lineTo(_loc8_ + 3,_loc1_);
         this.divider.graphics.lineTo(_loc8_,_loc1_ + 3);
         this.divider.graphics.lineTo(_loc8_ - 3,_loc1_);
         this.divider.graphics.lineTo(_loc8_,_loc1_ - 3);
         this.divider.graphics.endFill();
         var _loc9_:Number = Number(this.trayTopFor(param1));
         var _loc10_:Number = _loc1_ + 10;
         this.bodyViewport.y = _loc10_;
         this.bodyVpH = Math.max(0,_loc9_ - 8 - _loc10_);
         this.buildBodyContent(param1);
         this.buildTrayIfAny(param1);
      }

      private function clearBodyContent() : void
      {
         var _loc5_:int = 0;
         var _loc7_:Loader = null;
         var _loc6_:DisplayObject = null;
         _loc5_ = 0;
         while(_loc5_ < this.loaders.length)
         {
            _loc7_ = this.loaders[_loc5_];
            try
            {
               _loc7_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onImageComplete);
               _loc7_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onImageError);
               _loc7_.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onImageError);
               _loc7_.close();
            }
            catch(e:Error)
            {
            }
            try
            {
               _loc7_.unloadAndStop(true);
            }
            catch(e2:Error)
            {
            }
            _loc5_++;
         }
         this.loaders = [];
         this.imgMeta = new Dictionary();
         while(this.bodyHolder.numChildren > 0)
         {
            _loc6_ = this.bodyHolder.getChildAt(0);
            if(_loc6_ is TextField)
            {
               TextField(_loc6_).removeEventListener(TextEvent.LINK,this.onBodyLink);
            }
            this.bodyHolder.removeChildAt(0);
         }
         this.bodyContentH = 0;
         this.bodyScrollY = 0;
      }

      private function buildBodyContent(param1:Object) : void
      {
         var blocks:Array;
         var i:int = 0;
         var waitText:String = null;
         var tfWait:TextField = null;
         var b:Object = null;
         var m:Object = param1;
         if(m.body == null)
         {
            if(!m.bodyErr && !m.bodyGone)
            {
               this.hub.loadBody(m);
            }
            waitText = m.bodyGone ? "This letter is no longer available." : (m.bodyErr ? "This letter couldn\'t be loaded right now. Click it again to retry." : "Loading letter…");
            tfWait = this.buildTextBlock(waitText);
            tfWait.alpha = 0.6;
            this.bodyHolder.addChild(tfWait);
            this.relayoutBody();
            return;
         }
         blocks = [];
         try
         {
            blocks = MailArt.bbBlocks(String(m.body));
         }
         catch(e:Error)
         {
            blocks = [];
         }
         i = 0;
         while(i < blocks.length)
         {
            b = blocks[i];
            if(b.t == "text")
            {
               this.bodyHolder.addChild(this.buildTextBlock(String(b.html)));
            }
            else if(b.t == "img")
            {
               this.bodyHolder.addChild(this.buildImageBlock(String(b.url)));
            }
            i++;
         }
         this.relayoutBody();
      }

      private function buildTextBlock(param1:String) : TextField
      {
         var _loc7_:TextField = new TextField();
         _loc7_.embedFonts = MailArt.embedded();
         if(_loc7_.embedFonts)
         {
            _loc7_.antiAliasType = AntiAliasType.ADVANCED;
         }
         _loc7_.multiline = true;
         _loc7_.wordWrap = true;
         _loc7_.width = 356;
         _loc7_.selectable = false;
         _loc7_.mouseEnabled = true;
         _loc7_.autoSize = TextFieldAutoSize.NONE;
         var _loc6_:TextFormat = MailArt.fmt(12,2759178);
         _loc6_.leading = 3;
         _loc7_.defaultTextFormat = _loc6_;
         _loc7_.htmlText = MailArt.embedHtml(param1);
         MailArt.cover(_loc7_);
         _loc7_.height = _loc7_.textHeight + 4;
         _loc7_.addEventListener(TextEvent.LINK,this.onBodyLink,false,0,true);
         return _loc7_;
      }

      private function onBodyLink(param1:TextEvent) : void
      {
         var _loc7_:String = null;
         try
         {
            _loc7_ = param1.text;
            if(_loc7_ != null && (_loc7_.indexOf("http://") == 0 || _loc7_.indexOf("https://") == 0))
            {
               navigateToURL(new URLRequest(_loc7_),"_blank");
            }
         }
         catch(err:Error)
         {
         }
      }

      private function buildImageBlock(param1:String) : Sprite
      {
         var _loc3_:Loader = null;
         var _loc7_:Sprite = new Sprite();
         var _loc6_:Shape = new Shape();
         _loc6_.graphics.beginFill(14271898);
         _loc6_.graphics.drawRoundRect(0,0,356,120,8,8);
         _loc6_.graphics.endFill();
         _loc7_.addChild(_loc6_);
         var _loc2_:TextField = MailArt.tf(11,8019002);
         _loc2_.text = "Loading image…";
         _loc2_.x = Math.round((356 - _loc2_.width) / 2);
         _loc2_.y = Math.round((120 - _loc2_.height) / 2);
         _loc7_.addChild(_loc2_);
         try
         {
            _loc3_ = new Loader();
            _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onImageComplete,false,0,true);
            _loc3_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onImageError,false,0,true);
            _loc3_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onImageError,false,0,true);
            this.loaders.push(_loc3_);
            this.imgMeta[_loc3_] = {
               "holder":_loc7_,
               "placeholder":_loc6_,
               "tf":_loc2_
            };
            _loc3_.load(new URLRequest(param1),new LoaderContext(false));
         }
         catch(e:Error)
         {
         }
         return _loc7_;
      }

      private function onImageComplete(param1:Event) : void
      {
         var _loc7_:LoaderInfo = null;
         var _loc6_:Loader = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc1_:DisplayObject = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Shape = null;
         try
         {
            _loc7_ = LoaderInfo(param1.target);
            _loc6_ = _loc7_.loader;
            _loc2_ = this.imgMeta[_loc6_];
            if(_loc2_ == null)
            {
               return;
            }
            delete this.imgMeta[_loc6_];
            _loc3_ = int(this.loaders.indexOf(_loc6_));
            if(_loc3_ > -1)
            {
               this.loaders.splice(_loc3_,1);
            }
            _loc4_ = _loc2_.holder;
            if(_loc4_.parent == null)
            {
               return;
            }
            if(String(_loc7_.contentType).indexOf("image/") != 0 || _loc7_.width <= 0 || _loc7_.height <= 0)
            {
               try
               {
                  _loc6_.unloadAndStop();
               }
               catch(eU:Error)
               {
               }
               this.imgMeta[_loc6_] = _loc2_;
               this.onImageError(param1);
               return;
            }
            _loc1_ = _loc6_;
            _loc8_ = _loc7_.width;
            _loc9_ = _loc7_.height;
            _loc10_ = Math.min(1,356 / _loc8_,240 / _loc9_);
            _loc1_.scaleX = _loc1_.scaleY = _loc10_;
            _loc1_.x = Math.round((356 - _loc8_ * _loc10_) / 2);
            _loc1_.y = 0;
            if(_loc2_.placeholder.parent != null)
            {
               _loc4_.removeChild(_loc2_.placeholder);
            }
            if(_loc2_.tf.parent != null)
            {
               _loc4_.removeChild(_loc2_.tf);
            }
            _loc4_.addChild(_loc1_);
            _loc11_ = new Shape();
            _loc11_.graphics.lineStyle(1,9071162,1,true);
            _loc11_.graphics.drawRect(_loc1_.x,0,_loc8_ * _loc10_,_loc9_ * _loc10_);
            _loc4_.addChild(_loc11_);
            this.relayoutBody();
         }
         catch(err:Error)
         {
         }
      }

      private function onImageError(param1:Event) : void
      {
         var _loc7_:LoaderInfo = null;
         var _loc6_:Loader = null;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         var _loc1_:Shape = null;
         var _loc8_:TextField = null;
         try
         {
            _loc7_ = LoaderInfo(param1.target);
            _loc6_ = _loc7_.loader;
            _loc2_ = this.imgMeta[_loc6_];
            if(_loc2_ == null)
            {
               return;
            }
            delete this.imgMeta[_loc6_];
            _loc3_ = int(this.loaders.indexOf(_loc6_));
            if(_loc3_ > -1)
            {
               this.loaders.splice(_loc3_,1);
            }
            _loc4_ = _loc2_.holder;
            if(_loc4_.parent == null)
            {
               return;
            }
            _loc1_ = _loc2_.placeholder;
            _loc1_.graphics.clear();
            _loc1_.graphics.beginFill(14271898);
            _loc1_.graphics.drawRoundRect(0,0,356,40,8,8);
            _loc1_.graphics.endFill();
            _loc8_ = _loc2_.tf;
            _loc8_.text = "Image unavailable";
            _loc8_.x = Math.round((356 - _loc8_.width) / 2);
            _loc8_.y = Math.round((40 - _loc8_.height) / 2);
            this.relayoutBody();
         }
         catch(err:Error)
         {
         }
      }

      private function relayoutBody() : void
      {
         var _loc6_:int = 0;
         var _loc2_:DisplayObject = null;
         var _loc5_:Number = 0;
         var _loc7_:int = int(this.bodyHolder.numChildren);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc2_ = this.bodyHolder.getChildAt(_loc6_);
            _loc2_.y = _loc5_;
            _loc5_ += _loc2_.height + 8;
            _loc6_++;
         }
         if(_loc7_ > 0)
         {
            _loc5_ -= 8;
         }
         this.bodyContentH = _loc5_;
         this.layoutBodyScrollbar();
      }

      private function layoutBodyScrollbar() : void
      {
         var _loc5_:Number = Number(this.bodyVpH);
         var _loc7_:Boolean = this.bodyContentH > _loc5_ && _loc5_ > 0;
         this.bodySbTrack.visible = _loc7_;
         if(!_loc7_)
         {
            if(this.bodyScrollY != 0)
            {
               this.bodyScrollY = 0;
            }
            this.bodyViewport.scrollRect = new Rectangle(0,0,BODY_W,_loc5_);
            return;
         }
         var _loc6_:Number = this.bodyContentH - _loc5_;
         if(this.bodyScrollY > _loc6_)
         {
            this.bodyScrollY = _loc6_;
         }
         if(this.bodyScrollY < 0)
         {
            this.bodyScrollY = 0;
         }
         this.bodyViewport.scrollRect = new Rectangle(0,this.bodyScrollY,BODY_W,_loc5_);
         this.bodySbTrack.x = 634;
         this.bodySbTrack.y = this.bodyViewport.y;
         var _loc2_:Graphics = this.bodySbTrack.graphics;
         _loc2_.clear();
         _loc2_.beginFill(14206106);
         _loc2_.drawRoundRect(0,0,6,_loc5_,6,6);
         _loc2_.endFill();
         var _loc3_:int = int(_loc5_ * _loc5_ / this.bodyContentH);
         if(_loc3_ < 24)
         {
            _loc3_ = 24;
         }
         if(_loc3_ > _loc5_)
         {
            _loc3_ = _loc5_;
         }
         this.bodyThumbH = _loc3_;
         var _loc4_:Graphics = this.bodySbThumb.graphics;
         _loc4_.clear();
         _loc4_.beginFill(9071162);
         _loc4_.drawRoundRect(0,0,6,this.bodyThumbH,6,6);
         _loc4_.endFill();
         this.bodySbThumb.y = int((_loc5_ - this.bodyThumbH) * this.bodyScrollY / _loc6_);
      }

      private function applyBodyScroll() : void
      {
         var _loc5_:Number = NaN;
         this.bodyViewport.scrollRect = new Rectangle(0,this.bodyScrollY,BODY_W,this.bodyVpH);
         if(this.bodyThumbH > 0)
         {
            _loc5_ = this.bodyContentH - this.bodyVpH;
            this.bodySbThumb.y = _loc5_ > 0 ? int((this.bodyVpH - this.bodyThumbH) * this.bodyScrollY / _loc5_) : 0;
         }
      }

      private function onBodyTrackDown(param1:MouseEvent) : void
      {
         var _loc7_:Number = NaN;
         try
         {
            _loc7_ = this.bodyContentH - this.bodyVpH;
            if(_loc7_ <= 0)
            {
               return;
            }
            if(param1.target == this.bodySbThumb)
            {
               this.dragMode = "body";
               this.dragOff = this.bodySbTrack.mouseY - this.bodySbThumb.y;
               this.dragStage = stage;
               if(this.dragStage != null)
               {
                  this.dragStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove,false,0,true);
                  this.dragStage.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp,false,0,true);
               }
            }
            else
            {
               this.bodyScrollY += this.bodySbTrack.mouseY < this.bodySbThumb.y ? -this.bodyVpH : this.bodyVpH;
               if(this.bodyScrollY < 0)
               {
                  this.bodyScrollY = 0;
               }
               if(this.bodyScrollY > _loc7_)
               {
                  this.bodyScrollY = _loc7_;
               }
               this.applyBodyScroll();
            }
         }
         catch(err:Error)
         {
         }
      }

      private function clearTray() : void
      {
         var _loc5_:int = 0;
         if(this.blockedTip)
         {
            this.blockedTip = false;
            try
            {
               this.rootClass.ui.ToolTip.close();
            }
            catch(eT:Error)
            {
            }
         }
         _loc5_ = 0;
         while(_loc5_ < this.cards.length)
         {
            if(this.cards[_loc5_] != null)
            {
               MailCard(this.cards[_loc5_]).destroy();
            }
            _loc5_++;
         }
         this.cards = [];
         this.trayM = null;
         this.trayMailId = null;
         if(this.dragMode == "cards")
         {
            this.removeDragListeners();
            this.dragMode = "";
         }
         if(this.cardSbTrack != null)
         {
            this.cardSbTrack.removeEventListener(MouseEvent.MOUSE_DOWN,this.onCardTrackDown);
            this.cardSbTrack = null;
            this.cardSbThumb = null;
         }
         if(this.cardTouch != null)
         {
            this.cardTouch.detach();
            this.cardTouch = null;
         }
         this.cardView = null;
         if(this.trayClaimBtn != null)
         {
            this.trayClaimBtn.removeEventListener(MouseEvent.CLICK,this.onClaimClick);
            this.trayClaimBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onClaimBlockedOver);
            this.trayClaimBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onClaimBlockedOut);
            this.trayClaimBtn = null;
         }
         if(this.tray != null)
         {
            if(this.tray.parent != null)
            {
               this.tray.parent.removeChild(this.tray);
            }
            this.tray = null;
         }
         this.tfTrayLabel = null;
         this.tfTrayStatus = null;
      }

      private function buildTrayIfAny(param1:Object) : void
      {
         if(param1.att != null && param1.att.length > 0)
         {
            this.buildTray(param1);
         }
      }

      private function buildTray(param1:Object) : void
      {
         var _loc4_:Number = NaN;
         var _loc7_:int = int(param1.att.length);
         var _loc6_:int = Math.ceil(_loc7_ / 5);
         if(_loc6_ < 1)
         {
            _loc6_ = 1;
         }
         if(_loc6_ > 2)
         {
            _loc6_ = 2;
         }
         var _loc2_:Number = 22 + _loc6_ * 80 + 40;
         this.tray = new Sprite();
         this.tray.x = 258;
         this.tray.y = 410 - _loc2_;
         addChild(this.tray);
         var _loc3_:Graphics = this.tray.graphics;
         _loc3_.beginFill(2825488,0.92);
         _loc3_.lineStyle(1,MailArt.TRIM,1,true);
         _loc3_.drawRoundRect(0,0,380,_loc2_,12,12);
         _loc3_.endFill();
         this.trayM = param1;
         this.trayMailId = param1.id;
         this.trayClaimed = this.hub.isClaimed(param1);
         this.tfTrayLabel = MailArt.tf(11,MailArt.GOLD,true);
         this.tray.addChild(this.tfTrayLabel);
         if(this.trayClaimed)
         {
            this.tfTrayLabel.textColor = 8181372;
            this.tfTrayLabel.text = "Attachments — all claimed";
         }
         else
         {
            setRuns(this.tfTrayLabel,"Attachments",this.fmtTrayLabelGold," (" + _loc7_ + ")",this.fmtTrayLabelCount);
         }
         this.tfTrayLabel.x = 10;
         this.tfTrayLabel.y = 5;
         this.cards = new Array(_loc7_);
         this.cardView = new Sprite();
         this.cardView.y = 22;
         this.tray.addChild(this.cardView);
         this.cardViewH = _loc6_ * 80;
         this.cardContentH = Math.ceil(_loc7_ / 5) * 80;
         if(this.cardContentH > this.cardViewH)
         {
            this.buildCardScroll();
         }
         else
         {
            this.ensureCards();
         }
         this.tfTrayStatus = MailArt.tf(11,12303291);
         this.tfTrayStatus.multiline = true;
         this.tfTrayStatus.wordWrap = true;
         this.tfTrayStatus.autoSize = TextFieldAutoSize.NONE;
         this.tfTrayStatus.width = 220;
         this.tfTrayStatus.x = 10;
         this.tfTrayStatus.y = _loc2_ - 36;
         this.tray.addChild(this.tfTrayStatus);
         if(!this.trayClaimed)
         {
            this.trayClaimBtn = MailArt.button("Claim All",118,30,"green");
            this.trayClaimBtn.x = 380 - 128;
            this.trayClaimBtn.y = _loc2_ - 36;
            this.tray.addChild(this.trayClaimBtn);
            _loc4_ = (this.cardView.y + this.cardViewH + this.trayClaimBtn.y) / 2;
            TouchTargets.pad(this.trayClaimBtn,0,0,new Rectangle(-10000,_loc4_,20000,_loc2_ + 14 - _loc4_));
            this.trayClaimBtn.addEventListener(MouseEvent.CLICK,this.onClaimClick,false,0,true);
         }
         this.updateTrayState(param1);
      }

      private function updateTrayState(param1:Object) : void
      {
         var statusText:String;
         var statusColor:uint;
         var spaceOk:Boolean;
         var m:Object = param1;
         var claimed:Boolean = Boolean(this.hub.isClaimed(m));
         var info:Object = null;
         if(!claimed)
         {
            try
            {
               info = this.hub.spaceInfo(m);
            }
            catch(e:Error)
            {
               info = null;
            }
         }
         statusText = "";
         statusColor = 12303291;
         if(m.claimMsg != null)
         {
            statusText = String(m.claimMsg);
            statusColor = 16739163;
         }
         else if(claimed)
         {
            statusText = "All rewards claimed.";
            statusColor = 8181372;
         }
         else if(m.busy == true)
         {
            statusText = "Claiming…";
         }
         else if(info != null)
         {
            statusText = info.text != null ? String(info.text) : "";
            statusColor = info.color != null ? uint(info.color) : 12303291;
         }
         clampLines(this.tfTrayStatus,statusText,2);
         this.tfTrayStatus.textColor = statusColor;
         if(this.trayClaimBtn == null)
         {
            return;
         }
         this.trayClaimBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onClaimBlockedOver);
         this.trayClaimBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onClaimBlockedOut);
         spaceOk = info == null || info.ok != false;
         if(spaceOk && Boolean(this.blockedTip))
         {
            this.blockedTip = false;
            try
            {
               this.rootClass.ui.ToolTip.close();
            }
            catch(eT:Error)
            {
            }
         }
         if(m.busy == true)
         {
            MailArt.setButton(this.trayClaimBtn,false,"Claiming…");
         }
         else if(!spaceOk)
         {
            MailArt.setButton(this.trayClaimBtn,false,"Claim All");
            this.trayClaimBtn.addEventListener(MouseEvent.ROLL_OVER,this.onClaimBlockedOver,false,0,true);
            this.trayClaimBtn.addEventListener(MouseEvent.ROLL_OUT,this.onClaimBlockedOut,false,0,true);
         }
         else
         {
            MailArt.setButton(this.trayClaimBtn,true,"Claim All");
         }
      }

      private function cardFirst() : int
      {
         return int(this.cardScrollY / 80) * 5;
      }

      private function cardLast() : int
      {
         return Math.min(this.cards.length,(int((this.cardScrollY + this.cardViewH - 1) / 80) + 1) * 5);
      }

      private function ensureCards() : void
      {
         var _loc6_:MailCard = null;
         if(this.cardView == null || this.trayM == null || this.trayM.att == null)
         {
            return;
         }
         var _loc5_:int = int(this.cardLast());
         var _loc7_:int = int(this.cardFirst());
         while(_loc7_ < _loc5_)
         {
            if(!(this.cards[_loc7_] != null || this.trayM.att[_loc7_] == null))
            {
               _loc6_ = new MailCard(this.rootClass,this.trayM.att[_loc7_],_loc7_);
               _loc6_.x = CARD_X0 + _loc7_ % 5 * 72;
               _loc6_.y = int(_loc7_ / 5) * 80;
               this.cardView.addChild(_loc6_);
               this.cards[_loc7_] = _loc6_;
            }
            _loc7_++;
         }
      }

      private function buildCardScroll() : void
      {
         this.cardSbTrack = new Sprite();
         this.cardSbThumb = new Sprite();
         this.cardSbTrack.addChild(this.cardSbThumb);
         this.cardSbTrack.x = 370;
         this.cardSbTrack.y = 22;
         this.tray.addChild(this.cardSbTrack);
         var _loc5_:Graphics = this.cardSbTrack.graphics;
         _loc5_.beginFill(1710618);
         _loc5_.drawRoundRect(0,0,6,this.cardViewH,6,6);
         _loc5_.endFill();
         this.cardThumbH = Math.max(24,int(this.cardViewH * this.cardViewH / this.cardContentH));
         var _loc7_:Matrix = new Matrix();
         _loc7_.createGradientBox(6,this.cardThumbH,0,0,0);
         var _loc6_:Graphics = this.cardSbThumb.graphics;
         _loc6_.lineStyle(1,MailArt.TRIM,1,true);
         _loc6_.beginGradientFill(GradientType.LINEAR,[8912896,14155776,8912896],[1,1,1],[0,127,255],_loc7_);
         _loc6_.drawRoundRect(0,0,6,this.cardThumbH,6,6);
         _loc6_.endFill();
         this.cardSbTrack.addEventListener(MouseEvent.MOUSE_DOWN,this.onCardTrackDown,false,0,true);
         this.cardTouch = TouchScroll.attach(this.cardView,this.getCardPos,this.setCardPos,this.getCardMax);
         this.clampCardScroll();
         this.applyCardScroll();
      }

      private function clampCardScroll() : void
      {
         var _loc5_:Number = this.cardContentH - this.cardViewH;
         if(this.cardScrollY > _loc5_)
         {
            this.cardScrollY = _loc5_;
         }
         if(this.cardScrollY < 0)
         {
            this.cardScrollY = 0;
         }
      }

      private function applyCardScroll() : void
      {
         if(this.cardView == null || this.cardSbThumb == null)
         {
            return;
         }
         var _loc5_:Number = this.cardContentH - this.cardViewH;
         this.cardView.scrollRect = new Rectangle(0,this.cardScrollY,368,this.cardViewH);
         this.cardSbThumb.y = _loc5_ > 0 ? int((this.cardViewH - this.cardThumbH) * this.cardScrollY / _loc5_) : 0;
         this.ensureCards();
      }

      private function onCardTrackDown(param1:MouseEvent) : void
      {
         try
         {
            if(this.cardContentH - this.cardViewH <= 0)
            {
               return;
            }
            if(param1.target == this.cardSbThumb)
            {
               this.dragMode = "cards";
               this.dragOff = this.cardSbTrack.mouseY - this.cardSbThumb.y;
               this.dragStage = stage;
               if(this.dragStage != null)
               {
                  this.dragStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onDragMove,false,0,true);
                  this.dragStage.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp,false,0,true);
               }
            }
            else
            {
               this.cardScrollY += this.cardSbTrack.mouseY < this.cardSbThumb.y ? -this.cardViewH : this.cardViewH;
               this.clampCardScroll();
               this.applyCardScroll();
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onClaimClick(param1:MouseEvent) : void
      {
         try
         {
            if(this.paneM == null || this.trayClaimBtn == null || !MailArt.isEnabled(this.trayClaimBtn))
            {
               return;
            }
            this.hub.claim(this.paneM);
         }
         catch(err:Error)
         {
         }
      }

      private function onClaimBlockedOver(param1:MouseEvent) : void
      {
         try
         {
            this.blockedTip = true;
            this.rootClass.ui.ToolTip.openWith({"str":"Make room in your inventory first."});
         }
         catch(err:Error)
         {
         }
      }

      private function onClaimBlockedOut(param1:MouseEvent) : void
      {
         try
         {
            this.blockedTip = false;
            this.rootClass.ui.ToolTip.close();
         }
         catch(err:Error)
         {
         }
      }

      private function updateCardAnimState() : void
      {
         var _loc5_:Boolean = false;
         if(this.paneM != null && this.paneM.att != null && this.paneM.att.length > 0 && !this.hub.isClaimed(this.paneM))
         {
            _loc5_ = true;
         }
         if(!_loc5_ && getTimer() < this.animDeadline)
         {
            _loc5_ = true;
         }
         if(_loc5_ && !this.cardAnimRunning)
         {
            this.cardAnimRunning = true;
            addEventListener(Event.ENTER_FRAME,this.onCardTick,false,0,true);
         }
         else if(!_loc5_ && Boolean(this.cardAnimRunning))
         {
            this.cardAnimRunning = false;
            removeEventListener(Event.ENTER_FRAME,this.onCardTick);
         }
      }

      private function onCardTick(param1:Event) : void
      {
         var _loc7_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:int = 0;
         try
         {
            _loc7_ = int(getTimer());
            _loc6_ = int(this.cardLast());
            _loc2_ = int(this.cardFirst());
            while(_loc2_ < _loc6_)
            {
               if(this.cards[_loc2_] != null)
               {
                  try
                  {
                     MailCard(this.cards[_loc2_]).tick(_loc7_);
                  }
                  catch(errC:Error)
                  {
                  }
               }
               _loc2_++;
            }
            this.updateCardAnimState();
         }
         catch(err:Error)
         {
         }
      }
   }
}
