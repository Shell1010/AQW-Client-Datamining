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

      private static const PRESSED_CT:ColorTransform = new ColorTransform(0.75,0.75,0.75);

      private static const PLAIN_CT:ColorTransform = new ColorTransform();

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

      private var ringArt:DisplayObject;

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
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            if(param1[_loc2_] != null)
            {
               _loc1_.push(param1[_loc2_]);
            }
            _loc2_++;
         }
         return _loc1_;
      }

      private static function hudSlot(param1:MovieClip) : Rectangle
      {
         var _loc1_:MovieClip = null;
         var _loc2_:DisplayObject = null;
         var _loc3_:Rectangle = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         try
         {
            _loc1_ = param1.ui;
            _loc2_ = _loc1_.iconQuest as DisplayObject;
            if(_loc2_ != null)
            {
               _loc3_ = _loc2_.getBounds(_loc1_);
               if(_loc3_.width > 8 && _loc3_.height > 8 && _loc3_.width < 80 && _loc3_.height < 80)
               {
                  _loc4_ = Math.round(Math.min(_loc3_.width,_loc3_.height));
                  _loc5_ = _loc3_.x + _loc3_.width / 2 - 13;
                  _loc6_ = _loc3_.y + _loc3_.height / 2 - 25;
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
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         try
         {
            _loc1_ = Number(this.rootClass["ts_login_server"]);
            _loc2_ = Number(this.rootClass["ts_login_client"]);
         }
         catch(err:Error)
         {
         }
         MailArt.serverOffsetMs = Boolean(isNaN(_loc1_)) || Boolean(isNaN(_loc2_)) || _loc1_ <= 0 || _loc2_ <= 0 ? 0 : Math.round((_loc1_ - _loc2_) / 900000) * 900000;
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
               this.ringArt = null;
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
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         for each(_loc1_ in this.mails)
         {
            if(_loc1_ != null && !_loc1_.read)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }

      public function isClaimed(param1:Object) : Boolean
      {
         var _loc1_:Object = null;
         if(param1 == null || param1.att == null || param1.att.length == 0)
         {
            return true;
         }
         for each(_loc1_ in param1.att)
         {
            if(_loc1_ == null || _loc1_.ok != 1)
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
         var _loc1_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:int = 0;
         try
         {
            _loc1_ = int(getTimer());
            _loc2_ = false;
            _loc3_ = 0;
            for each(_loc4_ in this.mails)
            {
               if(_loc4_.busy)
               {
                  _loc5_ = 6000 - (_loc1_ - int(_loc4_.busyAt));
                  if(_loc5_ <= 100)
                  {
                     _loc4_.busy = false;
                     _loc2_ = true;
                  }
                  else if(_loc3_ == 0 || _loc5_ < _loc3_)
                  {
                     _loc3_ = _loc5_;
                  }
               }
            }
            if(_loc3_ > 0)
            {
               this.claimTimer = setTimeout(this.onClaimTimeout,_loc3_);
            }
            if(_loc2_)
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
         var _loc1_:int = 0;
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
            _loc1_ = 1100 - (getTimer() - this.listSentAt);
            if(_loc1_ > 0)
            {
               this.pageTimer = setTimeout(this.loadMore,_loc1_);
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
         var _loc1_:int = 0;
         try
         {
            if(this.destroyed)
            {
               return;
            }
            clearTimeout(this.firstTimer);
            _loc1_ = 1100 - (getTimer() - this.listSentAt);
            if(_loc1_ > 0)
            {
               this.firstTimer = setTimeout(this.requestFirstPage,_loc1_);
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
         var _loc1_:int = 0;
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
            _loc1_ = 300 - (getTimer() - this.lastBodyAt);
            if(_loc1_ <= 0)
            {
               this.flushBody();
            }
            else
            {
               this.bodyTimer = setTimeout(this.flushBody,_loc1_);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function flushBody() : void
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = this.bodyWant;
            this.bodyWant = null;
            if(Boolean(this.destroyed) || _loc1_ == null || _loc1_.body != null)
            {
               return;
            }
            _loc1_.bodyBusy = true;
            _loc1_.bodyAt = getTimer();
            this.lastBodyAt = _loc1_.bodyAt;
            this.send("mailBody",[_loc1_.id]);
            this.bodyWaitFor = _loc1_;
            clearTimeout(this.bodyWaitTimer);
            this.bodyWaitTimer = setTimeout(this.onBodyWait,4000);
         }
         catch(e:Error)
         {
         }
      }

      private function onBodyWait() : void
      {
         var _loc1_:Object = null;
         try
         {
            _loc1_ = this.bodyWaitFor;
            this.bodyWaitFor = null;
            if(Boolean(this.destroyed) || _loc1_ == null || _loc1_.body != null || !_loc1_.bodyBusy)
            {
               return;
            }
            _loc1_.bodyBusy = false;
            _loc1_.bodyErr = true;
            if(this.window != null)
            {
               this.window.bodyLoaded(_loc1_);
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
         var _loc1_:int = 0;
         while(_loc1_ < this.mails.length)
         {
            if(this.mails[_loc1_].id == param1)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return -1;
      }

      private function onMailList(param1:Object) : void
      {
         var _loc1_:Array = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:Object = null;
         var _loc8_:Object = null;
         var _loc9_:Object = null;
         var _loc10_:int = 0;
         try
         {
            _loc1_ = param1.mails != null ? dropNulls(param1.mails) : [];
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
               attachItems(_loc1_,param1.items);
               _loc8_ = {};
               for each(_loc2_ in this.mails)
               {
                  if(_loc2_ != null)
                  {
                     _loc8_[_loc2_.id] = true;
                  }
               }
               for each(_loc2_ in _loc1_)
               {
                  if(_loc2_ != null && !_loc8_[_loc2_.id])
                  {
                     this.mails.push(_loc2_);
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
            attachItems(_loc1_,param1.items);
            _loc3_ = {};
            for each(_loc2_ in _loc1_)
            {
               if(_loc2_ != null)
               {
                  _loc3_[_loc2_.id] = true;
               }
            }
            for each(_loc2_ in this.pushed)
            {
               if(_loc2_ != null && !_loc3_[_loc2_.id])
               {
                  _loc1_.unshift(_loc2_);
               }
            }
            this.pushed = [];
            this.pageCursor = 0;
            clearTimeout(this.pageTimer);
            _loc4_ = !this.firstListDone;
            this.firstListDone = true;
            _loc5_ = {};
            _loc6_ = {};
            for each(_loc2_ in this.mails)
            {
               if(_loc2_ != null)
               {
                  if(_loc2_.body != null)
                  {
                     _loc5_[_loc2_.id] = _loc2_.body;
                  }
                  _loc6_[_loc2_.id] = _loc2_;
               }
            }
            this.mails = _loc1_;
            for each(_loc7_ in this.mails)
            {
               if(_loc7_ != null)
               {
                  if(this.readIds[_loc7_.id])
                  {
                     _loc7_.read = 1;
                  }
                  if(_loc5_[_loc7_.id] != null)
                  {
                     _loc7_.body = _loc5_[_loc7_.id];
                  }
                  _loc9_ = _loc6_[_loc7_.id];
                  if(_loc9_ != null && Boolean(_loc9_.busy))
                  {
                     _loc7_.busy = _loc9_.busy;
                     _loc7_.busyAt = _loc9_.busyAt;
                     _loc7_.claimMsg = _loc9_.claimMsg;
                  }
               }
            }
            this.nextCursor = int(param1.next);
            this.pageBusy = false;
            this.lastList = getTimer();
            if(_loc4_)
            {
               _loc10_ = this.unreadCount();
               if(_loc10_ > 0)
               {
                  this.attention = true;
                  this.showToast("You\'ve got mail!",_loc10_ == 1 ? "1 new letter from the AQW Team" : _loc10_ + " new letters from the AQW Team");
                  this.rootClass.chatF.pushMsg("server","You have " + _loc10_ + " unread letter" + (_loc10_ == 1 ? "" : "s") + " in your Mailbox. Click the envelope above your skills to read them.","SERVER","",0);
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
         var _loc1_:Object = null;
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         try
         {
            _loc1_ = param1.mail;
            if(_loc1_ == null)
            {
               return;
            }
            attachItems([_loc1_],param1.items);
            this.pushed.push(_loc1_);
            _loc2_ = int(this.findIndex(_loc1_.id));
            if(_loc2_ >= 0)
            {
               _loc3_ = this.mails[_loc2_];
               if(_loc3_ != null && Boolean(_loc3_.busy))
               {
                  _loc1_.busy = _loc3_.busy;
                  _loc1_.busyAt = _loc3_.busyAt;
                  _loc1_.claimMsg = _loc3_.claimMsg;
               }
               this.mails[_loc2_] = _loc1_;
            }
            else
            {
               this.mails.unshift(_loc1_);
            }
            if(_loc2_ < 0 && this.window == null)
            {
               this.attention = true;
               this.showToast("New letter!",String(_loc1_.subj));
            }
            this.refresh();
         }
         catch(e:Error)
         {
         }
      }

      private function onMailClaim(param1:Object) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         try
         {
            _loc1_ = int(this.findIndex(param1.id));
            if(_loc1_ < 0)
            {
               return;
            }
            _loc2_ = this.mails[_loc1_];
            _loc2_.busy = false;
            if(param1.busy == 1)
            {
               this.refresh();
               return;
            }
            _loc4_ = param1.got != null ? param1.got : [];
            _loc5_ = param1.skip != null ? param1.skip : [];
            _loc3_ = 0;
            while(_loc3_ < _loc4_.length)
            {
               if(_loc2_.att != null && _loc2_.att[_loc4_[_loc3_]] != null)
               {
                  _loc2_.att[_loc4_[_loc3_]].ok = 1;
               }
               _loc3_++;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc5_.length)
            {
               if(_loc2_.att != null && _loc2_.att[_loc5_[_loc3_]] != null)
               {
                  _loc2_.att[_loc5_[_loc3_]].ok = 1;
                  _loc2_.att[_loc5_[_loc3_]].skip = 1;
               }
               _loc3_++;
            }
            if(param1.claimed == 1 && _loc2_.att != null)
            {
               _loc3_ = 0;
               while(_loc3_ < _loc2_.att.length)
               {
                  if(_loc2_.att[_loc3_] != null)
                  {
                     _loc2_.att[_loc3_].ok = 1;
                  }
                  _loc3_++;
               }
            }
            if(this.window != null)
            {
               this.window.claimDone(_loc2_,_loc4_);
               this.window.refreshRows();
            }
            this.refreshBadge();
            if(param1.ok != 1 && param1.msg != null)
            {
               _loc2_.claimMsg = String(param1.msg);
               try
               {
                  this.rootClass.chatF.pushMsg("warning",_loc2_.claimMsg,"SERVER","",0);
               }
               catch(e1:Error)
               {
               }
            }
            else if(param1.ok == 1)
            {
               try
               {
                  this.rootClass.chatF.pushMsg("server","Rewards claimed from \"" + _loc2_.subj + "\".","SERVER","",0);
               }
               catch(e2:Error)
               {
               }
            }
            _loc6_ = param1.notes != null ? param1.notes : [];
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               try
               {
                  this.rootClass.chatF.pushMsg("warning",String(_loc6_[_loc3_]),"SERVER","",0);
               }
               catch(e3:Error)
               {
               }
               _loc3_++;
            }
         }
         catch(e:Error)
         {
         }
      }

      private function onMailBody(param1:Object) : void
      {
         var _loc1_:int = 0;
         var _loc2_:Object = null;
         try
         {
            _loc1_ = int(this.findIndex(param1.id));
            if(_loc1_ < 0)
            {
               return;
            }
            _loc2_ = this.mails[_loc1_];
            if(_loc2_.body != null)
            {
               return;
            }
            _loc2_.bodyBusy = false;
            if(this.bodyWaitFor === _loc2_)
            {
               this.bodyWaitFor = null;
               clearTimeout(this.bodyWaitTimer);
            }
            if(param1.err)
            {
               _loc2_.bodyErr = true;
            }
            else if(param1.gone)
            {
               _loc2_.bodyGone = true;
            }
            else
            {
               _loc2_.body = param1.body != null ? String(param1.body) : "";
            }
            if(this.window != null)
            {
               this.window.bodyLoaded(_loc2_);
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
         var _loc1_:int = 0;
         try
         {
            if(this.hudBtn == null)
            {
               return;
            }
            _loc1_ = this.unreadCount();
            if(_loc1_ == 0)
            {
               this.attention = false;
            }
            this.applyMode();
            this.drawHud();
            if(Boolean(this.attention) && _loc1_ > 0)
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
         var _loc1_:Boolean = false;
         try
         {
            _loc1_ = Boolean(this.uiHidden());
            if(this.hudBtn != null)
            {
               this.hudBtn.visible = !_loc1_;
            }
            if(_loc1_)
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
         var _loc1_:Rectangle = null;
         try
         {
            if(this.hudBtn == null || this.hudMode != "portrait" || Boolean(this.moving))
            {
               return;
            }
            _loc1_ = hudSlot(this.rootClass);
            this.hudBtn.scaleX = this.hudBtn.scaleY = _loc1_.width / (PR * 2);
            this.hudBtn.x = _loc1_.x;
            this.hudBtn.y = _loc1_.y;
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
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         try
         {
            _loc1_ = this.attention ? "center" : "portrait";
            if(_loc1_ == this.hudMode || this.hudBtn == null)
            {
               return;
            }
            _loc2_ = this.hudMode == "center" && _loc1_ == "portrait";
            this.hudMode = _loc1_;
            this.hudBtn.removeEventListener(Event.ENTER_FRAME,this.onMoveFrame);
            this.hudBtn.scaleX = this.hudBtn.scaleY = 1;
            this.moving = _loc2_;
            if(_loc2_)
            {
               this.moveT0 = getTimer();
               this.restSlot = hudSlot(this.rootClass);
               this.hudBtn.x = CX;
               this.hudBtn.y = CY;
               this.hudBtn.addEventListener(Event.ENTER_FRAME,this.onMoveFrame,false,0,true);
            }
            else if(_loc1_ == "center")
            {
               this.hudBtn.x = CX;
               this.hudBtn.y = CY;
            }
            this.drawHud();
            if(!_loc2_ && _loc1_ == "portrait")
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
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         try
         {
            _loc1_ = Math.min(1,(getTimer() - this.moveT0) / 450);
            _loc2_ = 1 - (1 - _loc1_) * (1 - _loc1_) * (1 - _loc1_);
            this.hudBtn.scaleX = this.hudBtn.scaleY = 1 + (this.restSlot.width / 36 - 1) * _loc2_;
            this.hudBtn.x = CX + (this.restSlot.x - CX) * _loc2_;
            this.hudBtn.y = CY + (this.restSlot.y - CY) * _loc2_;
            if(_loc1_ >= 1)
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

      private function ringPlate() : DisplayObject
      {
         var _loc1_:DisplayObject = null;
         if(this.ringArt != null)
         {
            return this.ringArt;
         }
         try
         {
            _loc1_ = new (getDefinitionByName("UIRingPlate") as Class)() as DisplayObject;
            if(_loc1_ != null && this.hudBtn != null)
            {
               this.hudBtn.addChildAt(_loc1_,0);
               this.ringArt = _loc1_;
            }
         }
         catch(e:Error)
         {
         }
         return this.ringArt;
      }

      private function drawHudBg(param1:Boolean) : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:Matrix = null;
         var _loc3_:Graphics = null;
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         var _loc6_:Number = NaN;
         try
         {
            _loc1_ = this.hudBg.graphics;
            _loc1_.clear();
            if(this.ringArt != null)
            {
               this.ringArt.visible = false;
            }
            _loc2_ = new Matrix();
            if(this.bubbleMode())
            {
               this.hudGloss.graphics.clear();
               _loc4_ = this.ringPlate();
               if(_loc4_ != null)
               {
                  _loc4_.scaleX = _loc4_.scaleY = 1;
                  _loc5_ = _loc4_.getBounds(_loc4_);
                  if(_loc5_.width > 0 && _loc5_.height > 0)
                  {
                     _loc6_ = PR * 2 / Math.max(_loc5_.width,_loc5_.height);
                     _loc4_.scaleX = _loc4_.scaleY = _loc6_;
                     _loc4_.x = -_loc5_.x * _loc6_;
                     _loc4_.y = -_loc5_.y * _loc6_;
                     _loc4_.transform.colorTransform = param1 ? PRESSED_CT : PLAIN_CT;
                     _loc4_.visible = true;
                     return;
                  }
               }
               _loc1_.beginFill(1973786);
               _loc1_.drawCircle(PR,PR,PR);
               _loc1_.endFill();
               _loc2_.createGradientBox(PR * 2,PR * 2,Math.PI / 2,0,0);
               _loc1_.lineStyle(1.5,12170138,1,true);
               _loc1_.beginGradientFill(GradientType.LINEAR,param1 ? [2500132,789515] : [4868678,1644823],[1,1],[0,255],_loc2_);
               _loc1_.drawCircle(PR,PR,PR - 2.5);
               _loc1_.endFill();
               return;
            }
            _loc2_.createGradientBox(36,36,Math.PI / 2,0,0);
            _loc1_.lineStyle(1,6974058,1,true);
            _loc1_.beginGradientFill(GradientType.LINEAR,param1 ? [2500134,526344] : [4868682,1381653],[1,1],[0,255],_loc2_);
            _loc1_.drawRoundRect(0,0,36,36,20,20);
            _loc1_.endFill();
            _loc3_ = this.hudGloss.graphics;
            _loc3_.clear();
            _loc3_.beginFill(16777215,param1 ? 0.04 : 0.1);
            _loc3_.drawRoundRect(0,0,36,36 * 0.45,20,20);
            _loc3_.endFill();
         }
         catch(e:Error)
         {
         }
      }

      private function drawEnvelope() : void
      {
         var _loc1_:Graphics = null;
         try
         {
            _loc1_ = this.hudEnvelope.graphics;
            _loc1_.clear();
            if(this.bubbleMode())
            {
               MailArt.envelope(_loc1_,5,7,12,8.5,false,this.unreadCount() > 0);
            }
            else
            {
               MailArt.envelope(_loc1_,7,10,22,16,false,this.unreadCount() > 0);
            }
         }
         catch(e:Error)
         {
         }
      }

      private function drawBadge() : void
      {
         var _loc1_:Graphics = null;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         var _loc4_:TextField = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Matrix = null;
         try
         {
            _loc1_ = this.hudBadge.graphics;
            _loc1_.clear();
            while(this.hudBadge.numChildren > 0)
            {
               this.hudBadge.removeChildAt(0);
            }
            _loc2_ = this.unreadCount();
            _loc3_ = Boolean(this.bubbleMode());
            if(_loc2_ > 0)
            {
               _loc4_ = MailArt.tf(_loc3_ ? 8 : 10,16777215,true);
               _loc4_.text = _loc2_ > 9 ? "9+" : String(_loc2_);
               _loc4_.filters = this.badgeGlow;
               _loc5_ = _loc3_ ? 11 : 15;
               _loc6_ = Math.max(_loc5_,Math.ceil(_loc4_.textWidth) + (_loc3_ ? 5 : 7));
               _loc7_ = (_loc3_ ? 25.5 : 41.5) - _loc6_;
               _loc8_ = (_loc3_ ? 3 : 4) - _loc5_ / 2;
               _loc9_ = new Matrix();
               _loc9_.createGradientBox(_loc6_,_loc5_,Math.PI / 2,_loc7_,_loc8_);
               _loc1_.lineStyle(1,3803658,1,true);
               _loc1_.beginGradientFill(GradientType.LINEAR,[15022389,12000284],[1,1],[0,255],_loc9_);
               _loc1_.drawRoundRect(_loc7_,_loc8_,_loc6_,_loc5_,_loc5_,_loc5_);
               _loc1_.endFill();
               _loc4_.x = Math.round(_loc7_ + (_loc6_ - _loc4_.width) / 2);
               _loc4_.y = Math.round(_loc8_ + (_loc5_ - _loc4_.height) / 2);
               this.hudBadge.addChild(_loc4_);
            }
            else if(this.anyHasRewards())
            {
               _loc1_.lineStyle(1,5913088,1,true);
               _loc1_.beginFill(MailArt.GOLD);
               _loc1_.drawCircle(_loc3_ ? 19 : 32,_loc3_ ? 4 : 5,_loc3_ ? 3.5 : 5);
               _loc1_.endFill();
            }
         }
         catch(e:Error)
         {
         }
      }

      private function anyHasRewards() : Boolean
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.mails)
         {
            if(this.hasRewards(_loc1_))
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
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
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
            _loc1_ = (getTimer() - this.pulseT0) / 1600;
            _loc2_ = (Math.sin(_loc1_ * Math.PI * 2) + 1) / 2;
            _loc3_ = this.hudHover ? 0.95 : Math.round((0.25 + _loc2_ * 0.6) * 20) / 20;
            if(_loc3_ == this.pulseLastA)
            {
               return;
            }
            this.pulseLastA = _loc3_;
            this.pulseGlow.alpha = _loc3_;
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
         var _loc1_:int = 0;
         try
         {
            this.hudHover = true;
            this.applyHoverGlow();
            _loc1_ = this.unreadCount();
            this.rootClass.ui.ToolTip.openWith({"str":(_loc1_ > 0 ? "Mailbox (" + _loc1_ + " unread)" : "Mailbox")});
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
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         try
         {
            _loc1_ = int(getTimer());
            _loc2_ = _loc1_ - this.toastLastTick;
            this.toastLastTick = _loc1_;
            if(this.toastState == "enter")
            {
               this.toastPhase += _loc2_;
               _loc3_ = Math.min(1,this.toastPhase / 250);
               this.toastSprite.y = TOAST_Y + 12 * (1 - _loc3_);
               this.toastSprite.alpha = _loc3_;
               if(_loc3_ >= 1)
               {
                  this.toastState = "hold";
                  this.toastPhase = 0;
               }
            }
            else if(this.toastState == "hold")
            {
               if(!this.toastHover)
               {
                  this.toastPhase += _loc2_;
                  if(this.toastPhase >= 12000)
                  {
                     this.toastState = "fadeout";
                     this.toastPhase = 0;
                  }
               }
            }
            else if(this.toastState == "fadeout")
            {
               this.toastPhase += _loc2_;
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
