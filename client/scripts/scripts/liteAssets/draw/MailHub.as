package liteAssets.draw
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.utils.*;
   import liteAssets.mobile.*;

   public class MailHub
   {

      private static const TRIM:uint = 13145646;

      private static const CX:int = 460;

      private static const CY:int = 417;

      private static const PR:Number = 11;

      private static const FALLBACK_CX:int = 25;

      private static const FALLBACK_TOP:int = 93;

      private static const TOAST_Y:int = 353;

      public var rootClass:MovieClip;

      public var mails:Array = [];

      private var window:MailWindow;

      private var hudBtn:Sprite;

      private var hudBg:Shape;

      private var hudGloss:Shape;

      private var hudEnvelope:Shape;

      private var hudBadge:Sprite;

      private var hudHover:Boolean = false;

      private var pulseActive:Boolean = false;

      private var pulseT0:int = 0;

      private var attention:Boolean = false;

      private var readIds:Object = {};

      private var claimTimer:uint = 0;

      private var pulseGlow:GlowFilter = new GlowFilter(16767083,0.25,10,10,2);

      private var pulseFilters:Array = [null];

      private var hoverGlow:GlowFilter = new GlowFilter(16767083,0.9,10,10,2.5);

      private var badgeGlow:Array = [new GlowFilter(0,0.6,2,2,2,2)];

      private var hudPressed:Boolean = false;

      private var hudMode:String = "";

      private var moving:Boolean = false;

      private var moveT0:int = 0;

      private var restSlot:Rectangle;

      private var firstListDone:Boolean = false;

      private var lastList:int = 0;

      private var destroyed:Boolean = false;

      private var nextCursor:int = 0;

      private var pageBusy:Boolean = false;

      private var pageAt:int = 0;

      private var pageCursor:int = 0;

      private var pageTimer:uint = 0;

      private var firstTimer:uint = 0;

      private var listSentAt:int = -100000;

      private var pushed:Array = [];

      private var bodyWant:Object = null;

      private var bodyTimer:uint = 0;

      private var bodyWaitTimer:uint = 0;

      private var bodyWaitFor:Object = null;

      private var lastBodyAt:int = -100000;

      private var toastSprite:Sprite;

      private var toastCloseTF:TextField;

      private var toastFinalX:Number = 0;

      private var toastState:String = "";

      private var toastPhase:Number = 0;

      private var toastLastTick:int = 0;

      private var toastHover:Boolean = false;

      private var pulseSkip:Boolean = false;

      private var pulseLastA:Number = -1;

      public function MailHub(param1:MovieClip)
      {
         super();
         this.rootClass = param1;
      }

      private static function attachItems(param1:Array, param2:Object) : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         if(param2 == null)
         {
            return;
         }
         for each(_loc1_ in param1)
         {
            if(!(_loc1_ == null || _loc1_.att == null))
            {
               for each(_loc2_ in _loc1_.att)
               {
                  if(_loc2_ != null && _loc2_.iid != null)
                  {
                     _loc2_.it = param2[_loc2_.iid];
                  }
               }
            }
         }
      }

      private static function newestFirst(param1:Object, param2:Object) : Number
      {
         var _loc1_:Number = Number(param2.sent) - Number(param1.sent);
         if(_loc1_ != 0)
         {
            return _loc1_;
         }
         return Number(param2.id) - Number(param1.id);
      }

      private static function dropNulls(param1:Array) : Array
      {
         var _loc3_:Array = [];
         var _loc1_:int = 0;
         while(_loc1_ < param1.length)
         {
            if(param1[_loc1_] != null)
            {
               _loc3_.push(param1[_loc1_]);
            }
            _loc1_++;
         }
         return _loc3_;
      }

      private static function hudSlot(param1:MovieClip) : Rectangle
      {
         var _loc3_:MovieClip = null;
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         try
         {
            _loc3_ = param1.ui;
            _loc1_ = _loc3_.iconQuest as DisplayObject;
            if(_loc1_ != null)
            {
               _loc2_ = _loc1_.getBounds(_loc3_);
               if(_loc2_.width > 8 && _loc2_.height > 8 && _loc2_.width < 80 && _loc2_.height < 80)
               {
                  _loc4_ = Math.round(Math.min(_loc2_.width,_loc2_.height));
                  _loc5_ = _loc2_.x + _loc2_.width / 2 - 13;
                  _loc6_ = _loc2_.y + _loc2_.height / 2 - 25;
                  return new Rectangle(Math.round(_loc5_ - _loc4_ / 2),Math.round(_loc6_ - _loc4_ / 2),_loc4_,_loc4_);
               }
            }
         }
         catch(e:Error)
         {
         }
         return new Rectangle(Math.max(2,FALLBACK_CX - PR - 22),FALLBACK_TOP - 50,PR * 2,PR * 2);
      }

      private function applyServerOffset() : void
      {
         var _loc7_:Number = 0;
         var _loc3_:Number = 0;
         try
         {
            _loc7_ = Number(this.rootClass["ts_login_server"]);
            _loc3_ = Number(this.rootClass["ts_login_client"]);
         }
         catch(err:Error)
         {
         }
         MailArt.serverOffsetMs = Boolean(isNaN(_loc7_)) || Boolean(isNaN(_loc3_)) || _loc7_ <= 0 || _loc3_ <= 0 ? 0 : Math.round((_loc7_ - _loc3_) / 900000) * 900000;
      }

      public function start() : void
      {
         this.applyServerOffset();
         try
         {
            this.buildHud();
            this.sendList(0);
         }
         catch(e:Error)
         {
         }
      }

      public function destroy() : void
      {
         try
         {
            if(this.destroyed)
            {
               return;
            }
            this.destroyed = true;
            clearTimeout(this.claimTimer);
            clearTimeout(this.bodyTimer);
            clearTimeout(this.bodyWaitTimer);
            clearTimeout(this.pageTimer);
            clearTimeout(this.firstTimer);
            this.closeWindow();
            this.removeToast();
            this.stopPulse();
            if(this.hudBtn != null)
            {
               this.hudBtn.removeEventListener(MouseEvent.ROLL_OVER,this.onHudOver);
               this.hudBtn.removeEventListener(MouseEvent.ROLL_OUT,this.onHudOut);
               this.hudBtn.removeEventListener(MouseEvent.CLICK,this.onHudClick);
               this.hudBtn.removeEventListener(MouseEvent.MOUSE_DOWN,this.onHudDown);
               this.hudBtn.removeEventListener(MouseEvent.MOUSE_UP,this.onHudUp);
               this.hudBtn.removeEventListener(Event.ENTER_FRAME,this.onMoveFrame);
               if(this.hudBtn.parent != null)
               {
                  this.hudBtn.parent.removeChild(this.hudBtn);
               }
               this.hudBtn = null;
            }
            try
            {
               if(this.rootClass != null && this.rootClass.ui != null)
               {
                  this.rootClass.ui.ToolTip.close();
               }
            }
            catch(eT:Error)
            {
            }
         }
         catch(e:Error)
         {
         }
      }

      public function onPacket(param1:Object) : void
      {
         try
         {
            switch(String(param1.cmd))
            {
               case "mailList":
                  this.onMailList(param1);
                  break;
               case "mailNew":
                  this.onMailNew(param1);
                  break;
               case "mailClaim":
                  this.onMailClaim(param1);
                  break;
               case "mailBody":
                  this.onMailBody(param1);
            }
         }
         catch(e:Error)
         {
         }
      }

      public function openWindow() : void
      {
         var uiC:MovieClip = null;
         try
         {
            if(this.window == null)
            {
               this.window = new MailWindow(this);
            }
            uiC = this.rootClass.ui;
            try
            {
               uiC.addChildAt(this.window,uiC.getChildIndex(uiC.mcPopup));
            }
            catch(eIdx:Error)
            {
               uiC.addChild(window);
            }
            this.attention = false;
            this.stopPulse();
            this.refreshBadge();
            this.removeToast();
            if(getTimer() - this.lastList > 300000)
            {
               this.requestFirstPage();
            }
            this.window.refresh();
         }
         catch(e:Error)
         {
         }
      }

      public function closeWindow() : void
      {
         try
         {
            if(this.window != null)
            {
               this.window.destroy();
               if(this.window.parent != null)
               {
                  this.window.parent.removeChild(this.window);
               }
               this.window = null;
            }
            if(this.rootClass != null && this.rootClass.ui != null)
            {
               this.rootClass.ui.ToolTip.close();
            }
         }
         catch(e:Error)
         {
         }
      }

      public function unreadCount() : int
      {
         var _loc3_:Object = null;
         var _loc7_:int = 0;
         for each(_loc3_ in this.mails)
         {
            if(_loc3_ != null && !_loc3_.read)
            {
               _loc7_++;
            }
         }
         return _loc7_;
      }

      public function isClaimed(param1:Object) : Boolean
      {
         var _loc3_:Object = null;
         if(param1 == null || param1.att == null || param1.att.length == 0)
         {
            return true;
         }
         for each(_loc3_ in param1.att)
         {
            if(_loc3_ == null || _loc3_.ok != 1)
            {
               return false;
            }
         }
         return true;
      }

      public function hasRewards(param1:Object) : Boolean
      {
         return param1 != null && param1.att != null && param1.att.length > 0 && !this.isClaimed(param1);
      }

      public function markRead(param1:Object) : void
      {
         try
         {
            if(param1 == null || Boolean(param1.read))
            {
               return;
            }
            param1.read = 1;
            this.readIds[param1.id] = true;
            this.send("mailRead",[param1.id]);
            this.refreshBadge();
         }
         catch(e:Error)
         {
         }
      }

      public function claim(param1:Object) : void
      {
         try
         {
            if(Boolean(param1 == null) || Boolean(param1.busy) || this.isClaimed(param1))
            {
               return;
            }
            param1.busy = true;
            param1.busyAt = getTimer();
            param1.claimMsg = null;
            clearTimeout(this.claimTimer);
            this.claimTimer = setTimeout(this.onClaimTimeout,6000);
            this.send("mailClaim",[param1.id]);
            if(this.window != null)
            {
               this.window.refresh();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onClaimTimeout() : void
      {
         var _loc7_:int = 0;
         var _loc3_:Boolean = false;
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc4_:int = 0;
         try
         {
            _loc7_ = int(getTimer());
            _loc3_ = false;
            _loc1_ = 0;
            for each(_loc2_ in this.mails)
            {
               if(_loc2_.busy)
               {
                  _loc4_ = 6000 - (_loc7_ - int(_loc2_.busyAt));
                  if(_loc4_ <= 100)
                  {
                     _loc2_.busy = false;
                     _loc3_ = true;
                  }
                  else if(_loc1_ == 0 || _loc4_ < _loc1_)
                  {
                     _loc1_ = _loc4_;
                  }
               }
            }
            if(_loc1_ > 0)
            {
               this.claimTimer = setTimeout(this.onClaimTimeout,_loc1_);
            }
            if(_loc3_)
            {
               this.refresh();
            }
         }
         catch(e:Error)
         {
         }
      }

      public function hasMore() : Boolean
      {
         return this.nextCursor > 0;
      }

      public function loadMore() : void
      {
         var _loc7_:int = 0;
         try
         {
            if(Boolean(this.destroyed) || this.nextCursor <= 0)
            {
               return;
            }
            if(Boolean(this.pageBusy) && getTimer() - this.pageAt < 5000)
            {
               return;
            }
            clearTimeout(this.pageTimer);
            _loc7_ = 1100 - (getTimer() - this.listSentAt);
            if(_loc7_ > 0)
            {
               this.pageTimer = setTimeout(this.loadMore,_loc7_);
               return;
            }
            this.pageBusy = true;
            this.pageAt = getTimer();
            this.pageCursor = this.nextCursor;
            this.sendList(this.nextCursor);
         }
         catch(e:Error)
         {
         }
      }

      private function requestFirstPage() : void
      {
         var _loc7_:int = 0;
         try
         {
            if(this.destroyed)
            {
               return;
            }
            clearTimeout(this.firstTimer);
            _loc7_ = 1100 - (getTimer() - this.listSentAt);
            if(_loc7_ > 0)
            {
               this.firstTimer = setTimeout(this.requestFirstPage,_loc7_);
               return;
            }
            this.sendList(0);
         }
         catch(e:Error)
         {
         }
      }

      private function sendList(param1:int) : void
      {
         this.listSentAt = getTimer();
         if(param1 == 0)
         {
            this.pushed = [];
         }
         this.send("mailList",[param1]);
      }

      public function loadBody(param1:Object) : void
      {
         var _loc3_:int = 0;
         try
         {
            if(param1 == null || param1.body != null)
            {
               return;
            }
            if(Boolean(param1.bodyBusy) && getTimer() - int(param1.bodyAt) < 4000)
            {
               return;
            }
            this.bodyWant = param1;
            clearTimeout(this.bodyTimer);
            _loc3_ = 300 - (getTimer() - this.lastBodyAt);
            if(_loc3_ <= 0)
            {
               this.flushBody();
            }
            else
            {
               this.bodyTimer = setTimeout(this.flushBody,_loc3_);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function flushBody() : void
      {
         var _loc7_:Object = null;
         try
         {
            _loc7_ = this.bodyWant;
            this.bodyWant = null;
            if(Boolean(this.destroyed) || _loc7_ == null || _loc7_.body != null)
            {
               return;
            }
            _loc7_.bodyBusy = true;
            _loc7_.bodyAt = getTimer();
            this.lastBodyAt = _loc7_.bodyAt;
            this.send("mailBody",[_loc7_.id]);
            this.bodyWaitFor = _loc7_;
            clearTimeout(this.bodyWaitTimer);
            this.bodyWaitTimer = setTimeout(this.onBodyWait,4000);
         }
         catch(e:Error)
         {
         }
      }

      private function onBodyWait() : void
      {
         var _loc7_:Object = null;
         try
         {
            _loc7_ = this.bodyWaitFor;
            this.bodyWaitFor = null;
            if(Boolean(this.destroyed) || _loc7_ == null || _loc7_.body != null || !_loc7_.bodyBusy)
            {
               return;
            }
            _loc7_.bodyBusy = false;
            _loc7_.bodyErr = true;
            if(this.window != null)
            {
               this.window.bodyLoaded(_loc7_);
            }
         }
         catch(e:Error)
         {
         }
      }

      public function spaceInfo(param1:Object) : Object
      {
         var av:Object = null;
         var items:Array = null;
         var houseitems:Array = null;
         var objData:Object = null;
         var byId:Object = null;
         var order:Array = null;
         var a:Object = null;
         var needBag:int = 0;
         var needMisc:int = 0;
         var needHouse:int = 0;
         var acBag:int = 0;
         var acMisc:int = 0;
         var acHouse:int = 0;
         var idv:int = 0;
         var ownedById:Object = null;
         var bank:Object = null;
         var bankAll:Boolean = false;
         var unsure:Boolean = false;
         var freeBag:int = 0;
         var freeMisc:int = 0;
         var freeHouse:int = 0;
         var shortParts:Array = null;
         var useBag:int = 0;
         var useMisc:int = 0;
         var useHouse:int = 0;
         var toBank:int = 0;
         var needParts:Array = null;
         var text:String = null;
         var id:int = 0;
         var io:Object = null;
         var rec:Object = null;
         var it:Object = null;
         var owned:Object = null;
         var ac:Boolean = false;
         var typeKnown:Boolean = false;
         var inBank:Object = null;
         var m:Object = param1;
         try
         {
            if(m == null || m.att == null)
            {
               return {
                  "ok":true,
                  "text":"",
                  "color":12303291
               };
            }
            av = this.rootClass.world.myAvatar;
            items = av.items != null ? av.items : [];
            houseitems = av.houseitems != null ? av.houseitems : [];
            objData = av.objData;
            byId = {};
            order = [];
            for each(a in m.att)
            {
               if(!(a == null || a.ok == 1 || a.t != "item" || a.it == null))
               {
                  id = int(a.it.ItemID);
                  if(byId[id] == null)
                  {
                     byId[id] = {
                        "it":a.it,
                        "q":Number(a.q)
                     };
                     order.push(id);
                  }
                  else
                  {
                     byId[id].q += Number(a.q);
                  }
               }
            }
            needBag = 0;
            needMisc = 0;
            needHouse = 0;
            acBag = 0;
            acMisc = 0;
            acHouse = 0;
            ownedById = {};
            if(order.length > 0)
            {
               for each(io in items)
               {
                  if(io != null)
                  {
                     ownedById[int(io.ItemID)] = io;
                  }
               }
            }
            bank = null;
            bankAll = false;
            unsure = false;
            try
            {
               bank = this.rootClass.world.bankinfo;
               bankAll = Boolean(bank.hasRequested(["All"]));
            }
            catch(eB:Error)
            {
               bank = null;
            }
            for each(idv in order)
            {
               rec = byId[idv];
               it = rec.it;
               owned = ownedById[idv];
               if(owned != null)
               {
                  if(int(it.iStk) > 1 && Number(owned.iQty) + rec.q > Number(it.iStk))
                  {
                     return {
                        "ok":false,
                        "text":"You can\'t carry more " + it.sName + " (max " + it.iStk + ").",
                        "color":16739163
                     };
                  }
               }
               else if(!InvCat.isClass(it))
               {
                  ac = int(it.bCoins) == 1;
                  typeKnown = false;
                  try
                  {
                     typeKnown = bank != null && (bankAll || Boolean(bank.hasRequested([String(it.sType)])));
                  }
                  catch(eT:Error)
                  {
                     typeKnown = false;
                  }
                  if(typeKnown && Boolean(bank.isItemInBank(idv)))
                  {
                     inBank = bank.getBankItem(idv);
                     if(int(it.iStk) > 1 && inBank != null && Number(inBank.iQty) + rec.q > Number(it.iStk))
                     {
                        return {
                           "ok":false,
                           "text":"You can\'t carry more " + it.sName + " (max " + it.iStk + ", counting your bank).",
                           "color":16739163
                        };
                     }
                  }
                  else
                  {
                     if(!typeKnown && !ac)
                     {
                        unsure = true;
                     }
                     if(InvCat.isHouse(it))
                     {
                        if(ac)
                        {
                           acHouse++;
                        }
                        else
                        {
                           needHouse++;
                        }
                     }
                     else if(InvCat.isMisc(it))
                     {
                        if(ac)
                        {
                           acMisc++;
                        }
                        else
                        {
                           needMisc++;
                        }
                     }
                     else if(ac)
                     {
                        acBag++;
                     }
                     else
                     {
                        needBag++;
                     }
                  }
               }
            }
            freeBag = int(objData.iBagSlots) - InvCat.countBag(items);
            freeMisc = int(objData.iBagSlots) - InvCat.countMisc(items);
            freeHouse = int(objData.iHouseSlots) - houseitems.length;
            shortParts = [];
            if(needBag > 0 && needBag > freeBag)
            {
               shortParts.push(this.pluralize(needBag - freeBag,"inventory space"));
            }
            if(needMisc > 0 && needMisc > freeMisc)
            {
               shortParts.push(this.pluralize(needMisc - freeMisc,"misc space"));
            }
            if(needHouse > 0 && needHouse > freeHouse)
            {
               shortParts.push(this.pluralize(needHouse - freeHouse,"house space"));
            }
            if(shortParts.length > 0)
            {
               return {
                  "ok":unsure,
                  "text":"Not enough room: free " + shortParts.join(" and ") + ".",
                  "color":16739163
               };
            }
            useBag = needBag + Math.min(acBag,Math.max(0,freeBag - needBag));
            useMisc = needMisc + Math.min(acMisc,Math.max(0,freeMisc - needMisc));
            useHouse = needHouse + Math.min(acHouse,Math.max(0,freeHouse - needHouse));
            toBank = acBag + acMisc + acHouse - (useBag - needBag) - (useMisc - needMisc) - (useHouse - needHouse);
            needParts = [];
            if(useBag > 0)
            {
               needParts.push(this.pluralize(useBag,"inventory space"));
            }
            if(useMisc > 0)
            {
               needParts.push(this.pluralize(useMisc,"misc space"));
            }
            if(useHouse > 0)
            {
               needParts.push(this.pluralize(useHouse,"house space"));
            }
            text = needParts.length > 0 ? "Uses " + needParts.join(" and ") + "." : "";
            if(toBank > 0)
            {
               text += (text.length > 0 ? " " : "") + this.pluralize(toBank,"AC item") + " will go to your bank.";
            }
            return {
               "ok":true,
               "text":text,
               "color":12303291
            };
         }
         catch(e:Error)
         {
            return {
               "ok":true,
               "text":""
            };
         }
      }

      private function pluralize(param1:int, param2:String) : String
      {
         return param1 + " " + param2 + (param1 == 1 ? "" : "s");
      }

      private function findIndex(param1:*) : int
      {
         var _loc3_:int = 0;
         while(_loc3_ < this.mails.length)
         {
            if(this.mails[_loc3_].id == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }

      private function onMailList(param1:Object) : void
      {
         var _loc3_:Array = null;
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         try
         {
            _loc3_ = param1.mails != null ? dropNulls(param1.mails) : [];
            if(int(param1.before) > 0)
            {
               if(int(param1.before) != this.pageCursor)
               {
                  this.pageBusy = false;
                  this.pageCursor = 0;
                  return;
               }
               this.pageBusy = false;
               this.pageCursor = 0;
               if(param1.err)
               {
                  return;
               }
               attachItems(_loc3_,param1.items);
               _loc9_ = {};
               for each(_loc1_ in this.mails)
               {
                  if(_loc1_ != null)
                  {
                     _loc9_[_loc1_.id] = true;
                  }
               }
               for each(_loc1_ in _loc3_)
               {
                  if(_loc1_ != null && !_loc9_[_loc1_.id])
                  {
                     this.mails.push(_loc1_);
                  }
               }
               this.mails.sort(newestFirst);
               this.nextCursor = int(param1.next);
               this.refresh();
               return;
            }
            if(param1.err)
            {
               this.pageBusy = false;
               this.pageCursor = 0;
               return;
            }
            attachItems(_loc3_,param1.items);
            _loc2_ = {};
            for each(_loc1_ in _loc3_)
            {
               if(_loc1_ != null)
               {
                  _loc2_[_loc1_.id] = true;
               }
            }
            for each(_loc1_ in this.pushed)
            {
               if(_loc1_ != null && !_loc2_[_loc1_.id])
               {
                  _loc3_.unshift(_loc1_);
               }
            }
            this.pushed = [];
            this.pageCursor = 0;
            clearTimeout(this.pageTimer);
            _loc4_ = !this.firstListDone;
            this.firstListDone = true;
            _loc5_ = {};
            _loc6_ = {};
            for each(_loc1_ in this.mails)
            {
               if(_loc1_ != null)
               {
                  if(_loc1_.body != null)
                  {
                     _loc5_[_loc1_.id] = _loc1_.body;
                  }
                  _loc6_[_loc1_.id] = _loc1_;
               }
            }
            this.mails = _loc3_;
            for each(_loc8_ in this.mails)
            {
               if(_loc8_ != null)
               {
                  if(this.readIds[_loc8_.id])
                  {
                     _loc8_.read = 1;
                  }
                  if(_loc5_[_loc8_.id] != null)
                  {
                     _loc8_.body = _loc5_[_loc8_.id];
                  }
                  _loc10_ = _loc6_[_loc8_.id];
                  if(_loc10_ != null && Boolean(_loc10_.busy))
                  {
                     _loc8_.busy = _loc10_.busy;
                     _loc8_.busyAt = _loc10_.busyAt;
                     _loc8_.claimMsg = _loc10_.claimMsg;
                  }
               }
            }
            this.nextCursor = int(param1.next);
            this.pageBusy = false;
            this.lastList = getTimer();
            if(_loc4_)
            {
               _loc11_ = this.unreadCount();
               if(_loc11_ > 0)
               {
                  this.attention = true;
                  this.showToast("You\'ve got mail!",_loc11_ == 1 ? "1 new letter from the AQW Team" : _loc11_ + " new letters from the AQW Team");
                  this.rootClass.chatF.pushMsg("server","You have " + _loc11_ + " unread letter" + (_loc11_ == 1 ? "" : "s") + " in your Mailbox. Click the envelope above your skills to read them.","SERVER","",0);
               }
            }
            this.refresh();
         }
         catch(e:Error)
         {
         }
      }

      private function onMailNew(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         try
         {
            _loc3_ = param1.mail;
            if(_loc3_ == null)
            {
               return;
            }
            attachItems([_loc3_],param1.items);
            this.pushed.push(_loc3_);
            _loc1_ = int(this.findIndex(_loc3_.id));
            if(_loc1_ >= 0)
            {
               _loc2_ = this.mails[_loc1_];
               if(_loc2_ != null && Boolean(_loc2_.busy))
               {
                  _loc3_.busy = _loc2_.busy;
                  _loc3_.busyAt = _loc2_.busyAt;
                  _loc3_.claimMsg = _loc2_.claimMsg;
               }
               this.mails[_loc1_] = _loc3_;
            }
            else
            {
               this.mails.unshift(_loc3_);
            }
            if(_loc1_ < 0 && this.window == null)
            {
               this.attention = true;
               this.showToast("New letter!",String(_loc3_.subj));
            }
            this.refresh();
         }
         catch(e:Error)
         {
         }
      }

      private function onMailClaim(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         try
         {
            _loc3_ = int(this.findIndex(param1.id));
            if(_loc3_ < 0)
            {
               return;
            }
            _loc1_ = this.mails[_loc3_];
            _loc1_.busy = false;
            if(param1.busy == 1)
            {
               this.refresh();
               return;
            }
            _loc4_ = param1.got != null ? param1.got : [];
            _loc5_ = param1.skip != null ? param1.skip : [];
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               if(_loc1_.att != null && _loc1_.att[_loc4_[_loc2_]] != null)
               {
                  _loc1_.att[_loc4_[_loc2_]].ok = 1;
               }
               _loc2_++;
            }
            _loc2_ = 0;
            while(_loc2_ < _loc5_.length)
            {
               if(_loc1_.att != null && _loc1_.att[_loc5_[_loc2_]] != null)
               {
                  _loc1_.att[_loc5_[_loc2_]].ok = 1;
                  _loc1_.att[_loc5_[_loc2_]].skip = 1;
               }
               _loc2_++;
            }
            if(param1.claimed == 1 && _loc1_.att != null)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc1_.att.length)
               {
                  if(_loc1_.att[_loc2_] != null)
                  {
                     _loc1_.att[_loc2_].ok = 1;
                  }
                  _loc2_++;
               }
            }
            if(this.window != null)
            {
               this.window.claimDone(_loc1_,_loc4_);
               this.window.refreshRows();
            }
            this.refreshBadge();
            if(param1.ok != 1 && param1.msg != null)
            {
               _loc1_.claimMsg = String(param1.msg);
               try
               {
                  this.rootClass.chatF.pushMsg("warning",_loc1_.claimMsg,"SERVER","",0);
               }
               catch(e1:Error)
               {
               }
            }
            else if(param1.ok == 1)
            {
               try
               {
                  this.rootClass.chatF.pushMsg("server","Rewards claimed from \"" + _loc1_.subj + "\".","SERVER","",0);
               }
               catch(e2:Error)
               {
               }
            }
            _loc6_ = param1.notes != null ? param1.notes : [];
            _loc2_ = 0;
            while(_loc2_ < _loc6_.length)
            {
               try
               {
                  this.rootClass.chatF.pushMsg("warning",String(_loc6_[_loc2_]),"SERVER","",0);
               }
               catch(e3:Error)
               {
               }
               _loc2_++;
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onMailBody(param1:Object) : void
      {
         var _loc3_:int = 0;
         var _loc1_:Object = null;
         try
         {
            _loc3_ = int(this.findIndex(param1.id));
            if(_loc3_ < 0)
            {
               return;
            }
            _loc1_ = this.mails[_loc3_];
            if(_loc1_.body != null)
            {
               return;
            }
            _loc1_.bodyBusy = false;
            if(this.bodyWaitFor === _loc1_)
            {
               this.bodyWaitFor = null;
               clearTimeout(this.bodyWaitTimer);
            }
            if(param1.err)
            {
               _loc1_.bodyErr = true;
            }
            else if(param1.gone)
            {
               _loc1_.bodyGone = true;
            }
            else
            {
               _loc1_.body = param1.body != null ? String(param1.body) : "";
            }
            if(this.window != null)
            {
               this.window.bodyLoaded(_loc1_);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function send(param1:String, param2:Array) : void
      {
         try
         {
            this.rootClass.sfc.sendXtMessage("zm",param1,param2,"str",this.rootClass.world.curRoom);
         }
         catch(e:Error)
         {
         }
      }

      private function refresh() : void
      {
         try
         {
            this.refreshBadge();
            if(this.window != null)
            {
               this.window.refresh();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function refreshBadge() : void
      {
         var _loc7_:int = 0;
         try
         {
            if(this.hudBtn == null)
            {
               return;
            }
            _loc7_ = this.unreadCount();
            if(_loc7_ == 0)
            {
               this.attention = false;
            }
            this.applyMode();
            this.drawHud();
            if(Boolean(this.attention) && _loc7_ > 0)
            {
               this.startPulse();
            }
            else
            {
               this.stopPulse();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function buildHud() : void
      {
         var uiC:MovieClip = null;
         try
         {
            this.hudBtn = new Sprite();
            this.hudBtn.buttonMode = true;
            this.hudBtn.mouseChildren = false;
            this.hudBg = new Shape();
            this.hudGloss = new Shape();
            this.hudEnvelope = new Shape();
            this.hudBadge = new Sprite();
            this.hudBtn.addChild(this.hudBg);
            this.hudBtn.addChild(this.hudGloss);
            this.hudBtn.addChild(this.hudEnvelope);
            this.hudBtn.addChild(this.hudBadge);
            this.hudBtn.visible = !this.uiHidden();
            this.applyMode();
            this.drawHud();
            this.hudBtn.addEventListener(MouseEvent.ROLL_OVER,this.onHudOver,false,0,true);
            this.hudBtn.addEventListener(MouseEvent.ROLL_OUT,this.onHudOut,false,0,true);
            this.hudBtn.addEventListener(MouseEvent.CLICK,this.onHudClick,false,0,true);
            this.hudBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onHudDown,false,0,true);
            this.hudBtn.addEventListener(MouseEvent.MOUSE_UP,this.onHudUp,false,0,true);
            uiC = this.rootClass.ui;
            try
            {
               if(uiC.mcInterface != null)
               {
                  uiC.addChildAt(this.hudBtn,uiC.getChildIndex(uiC.mcInterface) + 1);
               }
               else
               {
                  uiC.addChild(this.hudBtn);
               }
            }
            catch(eIdx:Error)
            {
               uiC.addChild(hudBtn);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function uiHidden() : Boolean
      {
         try
         {
            return Boolean(this.rootClass.litePreference.data.bHideUI);
         }
         catch(e:Error)
         {
         }
         return false;
      }

      public function applyUIHidden() : void
      {
         var _loc7_:Boolean = false;
         try
         {
            _loc7_ = Boolean(this.uiHidden());
            if(this.hudBtn != null)
            {
               this.hudBtn.visible = !_loc7_;
            }
            if(_loc7_)
            {
               this.removeToast();
            }
            this.placeHud();
         }
         catch(e:Error)
         {
         }
      }

      public function placeHud() : void
      {
         var _loc7_:Rectangle = null;
         try
         {
            if(this.hudBtn == null || this.hudMode != "portrait" || Boolean(this.moving))
            {
               return;
            }
            _loc7_ = hudSlot(this.rootClass);
            this.hudBtn.scaleX = this.hudBtn.scaleY = _loc7_.width / (PR * 2);
            this.hudBtn.x = _loc7_.x;
            this.hudBtn.y = _loc7_.y;
         }
         catch(e:Error)
         {
         }
      }

      private function bubbleMode() : Boolean
      {
         return this.hudMode == "portrait" && !this.moving;
      }

      private function applyMode() : void
      {
         var _loc7_:String = null;
         var _loc3_:Boolean = false;
         try
         {
            _loc7_ = this.attention ? "center" : "portrait";
            if(_loc7_ == this.hudMode || this.hudBtn == null)
            {
               return;
            }
            _loc3_ = this.hudMode == "center" && _loc7_ == "portrait";
            this.hudMode = _loc7_;
            this.hudBtn.removeEventListener(Event.ENTER_FRAME,this.onMoveFrame);
            this.hudBtn.scaleX = this.hudBtn.scaleY = 1;
            this.moving = _loc3_;
            if(_loc3_)
            {
               this.moveT0 = getTimer();
               this.restSlot = hudSlot(this.rootClass);
               this.hudBtn.x = CX;
               this.hudBtn.y = CY;
               this.hudBtn.addEventListener(Event.ENTER_FRAME,this.onMoveFrame,false,0,true);
            }
            else if(_loc7_ == "center")
            {
               this.hudBtn.x = CX;
               this.hudBtn.y = CY;
            }
            this.drawHud();
            if(!_loc3_ && _loc7_ == "portrait")
            {
               this.placeHud();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onMoveFrame(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = NaN;
         try
         {
            _loc3_ = Math.min(1,(getTimer() - this.moveT0) / 450);
            _loc1_ = 1 - (1 - _loc3_) * (1 - _loc3_) * (1 - _loc3_);
            this.hudBtn.scaleX = this.hudBtn.scaleY = 1 + (this.restSlot.width / 36 - 1) * _loc1_;
            this.hudBtn.x = CX + (this.restSlot.x - CX) * _loc1_;
            this.hudBtn.y = CY + (this.restSlot.y - CY) * _loc1_;
            if(_loc3_ >= 1)
            {
               this.hudBtn.removeEventListener(Event.ENTER_FRAME,this.onMoveFrame);
               this.moving = false;
               this.drawHud();
               this.placeHud();
            }
         }
         catch(err:Error)
         {
         }
      }

      private function drawHud() : void
      {
         this.drawHudBg(this.hudPressed);
         this.drawEnvelope();
         this.drawBadge();
         try
         {
            if(this.bubbleMode())
            {
               TouchTargets.unpad(this.hudBtn);
            }
            else
            {
               TouchTargets.pad(this.hudBtn);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function drawHudBg(param1:Boolean) : void
      {
         var _loc3_:Graphics = null;
         var _loc1_:Matrix = null;
         var _loc2_:Graphics = null;
         try
         {
            _loc3_ = this.hudBg.graphics;
            _loc3_.clear();
            _loc1_ = new Matrix();
            if(this.bubbleMode())
            {
               this.hudGloss.graphics.clear();
               _loc3_.beginFill(1973786);
               _loc3_.drawCircle(PR,PR,PR);
               _loc3_.endFill();
               _loc1_.createGradientBox(PR * 2,PR * 2,Math.PI / 2,0,0);
               _loc3_.lineStyle(1.5,12170138,1,true);
               _loc3_.beginGradientFill(GradientType.LINEAR,param1 ? [2500132,789515] : [4868678,1644823],[1,1],[0,255],_loc1_);
               _loc3_.drawCircle(PR,PR,PR - 2.5);
               _loc3_.endFill();
               return;
            }
            _loc1_.createGradientBox(36,36,Math.PI / 2,0,0);
            _loc3_.lineStyle(1,6974058,1,true);
            _loc3_.beginGradientFill(GradientType.LINEAR,param1 ? [2500134,526344] : [4868682,1381653],[1,1],[0,255],_loc1_);
            _loc3_.drawRoundRect(0,0,36,36,20,20);
            _loc3_.endFill();
            _loc2_ = this.hudGloss.graphics;
            _loc2_.clear();
            _loc2_.beginFill(16777215,param1 ? 0.04 : 0.1);
            _loc2_.drawRoundRect(0,0,36,36 * 0.45,20,20);
            _loc2_.endFill();
         }
         catch(e:Error)
         {
         }
      }

      private function drawEnvelope() : void
      {
         var _loc7_:Graphics = null;
         try
         {
            _loc7_ = this.hudEnvelope.graphics;
            _loc7_.clear();
            if(this.bubbleMode())
            {
               MailArt.envelope(_loc7_,5,7,12,8.5,false,this.unreadCount() > 0);
            }
            else
            {
               MailArt.envelope(_loc7_,7,10,22,16,false,this.unreadCount() > 0);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function drawBadge() : void
      {
         var _loc7_:Graphics = null;
         var _loc3_:int = 0;
         var _loc1_:Boolean = false;
         var _loc2_:TextField = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Matrix = null;
         try
         {
            _loc7_ = this.hudBadge.graphics;
            _loc7_.clear();
            while(this.hudBadge.numChildren > 0)
            {
               this.hudBadge.removeChildAt(0);
            }
            _loc3_ = this.unreadCount();
            _loc1_ = Boolean(this.bubbleMode());
            if(_loc3_ > 0)
            {
               _loc2_ = MailArt.tf(_loc1_ ? 8 : 10,16777215,true);
               _loc2_.text = _loc3_ > 9 ? "9+" : String(_loc3_);
               _loc2_.filters = this.badgeGlow;
               _loc4_ = _loc1_ ? 11 : 15;
               _loc5_ = Math.max(_loc4_,Math.ceil(_loc2_.textWidth) + (_loc1_ ? 5 : 7));
               _loc6_ = (_loc1_ ? 25.5 : 41.5) - _loc5_;
               _loc8_ = (_loc1_ ? 3 : 4) - _loc4_ / 2;
               _loc9_ = new Matrix();
               _loc9_.createGradientBox(_loc5_,_loc4_,Math.PI / 2,_loc6_,_loc8_);
               _loc7_.lineStyle(1,3803658,1,true);
               _loc7_.beginGradientFill(GradientType.LINEAR,[15022389,12000284],[1,1],[0,255],_loc9_);
               _loc7_.drawRoundRect(_loc6_,_loc8_,_loc5_,_loc4_,_loc4_,_loc4_);
               _loc7_.endFill();
               _loc2_.x = Math.round(_loc6_ + (_loc5_ - _loc2_.width) / 2);
               _loc2_.y = Math.round(_loc8_ + (_loc4_ - _loc2_.height) / 2);
               this.hudBadge.addChild(_loc2_);
            }
            else if(this.anyHasRewards())
            {
               _loc7_.lineStyle(1,5913088,1,true);
               _loc7_.beginFill(MailArt.GOLD);
               _loc7_.drawCircle(_loc1_ ? 19 : 32,_loc1_ ? 4 : 5,_loc1_ ? 3.5 : 5);
               _loc7_.endFill();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function anyHasRewards() : Boolean
      {
         var _loc7_:Object = null;
         for each(_loc7_ in this.mails)
         {
            if(this.hasRewards(_loc7_))
            {
               return true;
            }
         }
         return false;
      }

      private function startPulse() : void
      {
         try
         {
            if(Boolean(this.pulseActive) || this.hudBtn == null)
            {
               return;
            }
            this.pulseActive = true;
            this.pulseT0 = getTimer();
            this.pulseLastA = -1;
            this.hudBtn.addEventListener(Event.ENTER_FRAME,this.onPulseFrame,false,0,true);
         }
         catch(e:Error)
         {
         }
      }

      private function stopPulse() : void
      {
         try
         {
            if(!this.pulseActive)
            {
               return;
            }
            this.pulseActive = false;
            if(this.hudBtn != null)
            {
               this.hudBtn.removeEventListener(Event.ENTER_FRAME,this.onPulseFrame);
               this.applyHoverGlow();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onPulseFrame(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         try
         {
            if(this.hudBtn.stage == null || !this.hudBtn.visible)
            {
               return;
            }
            this.pulseSkip = !this.pulseSkip;
            if(this.pulseSkip)
            {
               return;
            }
            _loc3_ = (getTimer() - this.pulseT0) / 1600;
            _loc1_ = (Math.sin(_loc3_ * Math.PI * 2) + 1) / 2;
            _loc2_ = this.hudHover ? 0.95 : Math.round((0.25 + _loc1_ * 0.6) * 20) / 20;
            if(_loc2_ == this.pulseLastA)
            {
               return;
            }
            this.pulseLastA = _loc2_;
            this.pulseGlow.alpha = _loc2_;
            this.pulseFilters[0] = this.pulseGlow;
            this.hudBtn.filters = this.pulseFilters;
         }
         catch(err:Error)
         {
         }
      }

      private function applyHoverGlow() : void
      {
         if(this.hudBtn == null || Boolean(this.pulseActive))
         {
            return;
         }
         this.hudBtn.filters = this.hudHover ? [this.hoverGlow] : [];
      }

      private function onHudDown(param1:MouseEvent) : void
      {
         try
         {
            this.hudPressed = true;
            this.drawHudBg(true);
         }
         catch(err:Error)
         {
         }
      }

      private function onHudUp(param1:MouseEvent) : void
      {
         try
         {
            if(!this.hudPressed)
            {
               return;
            }
            this.hudPressed = false;
            this.drawHudBg(false);
         }
         catch(err:Error)
         {
         }
      }

      private function onHudOver(param1:MouseEvent) : void
      {
         var _loc3_:int = 0;
         try
         {
            this.hudHover = true;
            this.applyHoverGlow();
            _loc3_ = this.unreadCount();
            this.rootClass.ui.ToolTip.openWith({"str":(_loc3_ > 0 ? "Mailbox (" + _loc3_ + " unread)" : "Mailbox")});
         }
         catch(err:Error)
         {
         }
      }

      private function onHudOut(param1:MouseEvent) : void
      {
         try
         {
            this.hudHover = false;
            this.hudPressed = false;
            this.drawHudBg(false);
            this.applyHoverGlow();
            this.rootClass.ui.ToolTip.close();
         }
         catch(err:Error)
         {
         }
      }

      private function onHudClick(param1:MouseEvent) : void
      {
         try
         {
            this.rootClass.ui.ToolTip.close();
            if(this.window != null)
            {
               this.closeWindow();
            }
            else
            {
               this.openWindow();
            }
         }
         catch(err:Error)
         {
         }
      }

      private function showToast(param1:String, param2:String) : void
      {
         var g:Graphics = null;
         var env:Shape = null;
         var tTitle:TextField = null;
         var tLine:TextField = null;
         var closeBtn:Sprite = null;
         var tClose:TextField = null;
         var uiC:MovieClip = null;
         var title:String = param1;
         var line:String = param2;
         try
         {
            this.removeToast();
            if(this.uiHidden())
            {
               return;
            }
            this.toastSprite = new Sprite();
            g = this.toastSprite.graphics;
            g.lineStyle(2,TRIM,1,true);
            g.beginFill(1314827,0.95);
            g.drawRoundRect(0,0,250,54,20,20);
            g.moveTo(115,54);
            g.lineTo(125,64);
            g.lineTo(135,54);
            g.lineTo(115,54);
            g.endFill();
            env = new Shape();
            MailArt.envelope(env.graphics,12,16,30,20,false,true);
            this.toastSprite.addChild(env);
            tTitle = MailArt.tf(14,16767083,true);
            tTitle.text = title;
            tTitle.x = 52;
            tTitle.y = 8;
            this.toastSprite.addChild(tTitle);
            tLine = MailArt.tf(11,15263976,false);
            tLine.text = line;
            MailArt.cover(tLine);
            tLine.x = 52;
            tLine.y = 28;
            MailArt.fit(tLine,180);
            this.toastSprite.addChild(tLine);
            closeBtn = new Sprite();
            closeBtn.mouseChildren = false;
            closeBtn.buttonMode = true;
            closeBtn.graphics.beginFill(0,0);
            closeBtn.graphics.drawRect(-6,-6,24,24);
            closeBtn.graphics.endFill();
            tClose = MailArt.tf(14,11184810,true);
            tClose.text = "×";
            closeBtn.addChild(tClose);
            closeBtn.x = 232;
            closeBtn.y = 2;
            closeBtn.addEventListener(MouseEvent.ROLL_OVER,this.onToastCloseOver,false,0,true);
            closeBtn.addEventListener(MouseEvent.ROLL_OUT,this.onToastCloseOut,false,0,true);
            closeBtn.addEventListener(MouseEvent.CLICK,this.onToastCloseClick,false,0,true);
            this.toastCloseTF = tClose;
            this.toastSprite.addChild(closeBtn);
            this.toastSprite.addEventListener(MouseEvent.CLICK,this.onToastBodyClick,false,0,true);
            this.toastSprite.addEventListener(MouseEvent.ROLL_OVER,this.onToastOver,false,0,true);
            this.toastSprite.addEventListener(MouseEvent.ROLL_OUT,this.onToastOut,false,0,true);
            this.toastSprite.buttonMode = true;
            this.toastFinalX = CX + 18 - 125;
            this.toastSprite.x = this.toastFinalX;
            this.toastSprite.y = TOAST_Y + 12;
            this.toastSprite.alpha = 0;
            this.toastState = "enter";
            this.toastPhase = 0;
            this.toastLastTick = getTimer();
            this.toastHover = false;
            uiC = this.rootClass.ui;
            try
            {
               uiC.addChildAt(this.toastSprite,uiC.getChildIndex(this.hudBtn) + 1);
            }
            catch(eIdx:Error)
            {
               uiC.addChild(toastSprite);
            }
            this.toastSprite.addEventListener(Event.ENTER_FRAME,this.onToastFrame,false,0,true);
         }
         catch(e:Error)
         {
         }
      }

      private function removeToast() : void
      {
         try
         {
            if(this.toastSprite == null)
            {
               return;
            }
            this.toastSprite.removeEventListener(Event.ENTER_FRAME,this.onToastFrame);
            if(this.toastSprite.parent != null)
            {
               this.toastSprite.parent.removeChild(this.toastSprite);
            }
         }
         catch(e:Error)
         {
         }
         this.toastSprite = null;
         this.toastCloseTF = null;
      }

      private function onToastFrame(param1:Event) : void
      {
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:Number = NaN;
         var _loc4_:Number = NaN;
         try
         {
            _loc3_ = int(getTimer());
            _loc1_ = _loc3_ - this.toastLastTick;
            this.toastLastTick = _loc3_;
            if(this.toastState == "enter")
            {
               this.toastPhase += _loc1_;
               _loc2_ = Math.min(1,this.toastPhase / 250);
               this.toastSprite.y = TOAST_Y + 12 * (1 - _loc2_);
               this.toastSprite.alpha = _loc2_;
               if(_loc2_ >= 1)
               {
                  this.toastState = "hold";
                  this.toastPhase = 0;
               }
            }
            else if(this.toastState == "hold")
            {
               if(!this.toastHover)
               {
                  this.toastPhase += _loc1_;
                  if(this.toastPhase >= 12000)
                  {
                     this.toastState = "fadeout";
                     this.toastPhase = 0;
                  }
               }
            }
            else if(this.toastState == "fadeout")
            {
               this.toastPhase += _loc1_;
               _loc4_ = Math.min(1,this.toastPhase / 300);
               this.toastSprite.alpha = 1 - _loc4_;
               if(_loc4_ >= 1)
               {
                  this.removeToast();
               }
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onToastBodyClick(param1:MouseEvent) : void
      {
         try
         {
            this.openWindow();
         }
         catch(err:Error)
         {
         }
      }

      private function onToastCloseClick(param1:MouseEvent) : void
      {
         try
         {
            param1.stopPropagation();
            this.removeToast();
         }
         catch(err:Error)
         {
         }
      }

      private function onToastCloseOver(param1:MouseEvent) : void
      {
         try
         {
            if(this.toastCloseTF != null)
            {
               this.toastCloseTF.textColor = 16777215;
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onToastCloseOut(param1:MouseEvent) : void
      {
         try
         {
            if(this.toastCloseTF != null)
            {
               this.toastCloseTF.textColor = 11184810;
            }
         }
         catch(err:Error)
         {
         }
      }

      private function onToastOver(param1:MouseEvent) : void
      {
         this.toastHover = true;
      }

      private function onToastOut(param1:MouseEvent) : void
      {
         this.toastHover = false;
      }
   }
}
