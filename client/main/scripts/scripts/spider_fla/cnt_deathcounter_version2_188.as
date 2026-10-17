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

   [Embed(source="/_assets/assets.swf", symbol="symbol3797")]
   public dynamic class cnt_deathcounter_version2_188 extends MovieClip
   {

      public var mcContent:MovieClip;

      public var mcTomb:MovieClip;

      public var rootClass:*;

      public var arrTips:Array;

      public var arrAds:Array;

      public var iAdIndex:int;

      public function cnt_deathcounter_version2_188()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,19,this.frame20,56,this.frame57);
      }

      public function clickGo(param1:MouseEvent) : *
      {
         var _loc1_:String = "http://tracking.battleon.com/click.asp?game=AW&campaign=DEATHAQW_" + this.arrAds[this.iAdIndex].sType.toUpperCase();
         sendToURL(new URLRequest(_loc1_));
         navigateToURL(new URLRequest(this.arrAds[this.iAdIndex].sTarget),"_blank");
      }

      public function loadAd() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:Loader = null;
         this.mcContent.mcButtons.chkAds.checkmark.visible = this.mcContent.mcButtons.chkAds.bitChecked = !this.rootClass.userPreference.data.bDeathAd;
         trace("line 90");
         this.mcContent.mcAd.visible = false;
         trace("line 92");
         if(this.rootClass.userPreference.data.bDeathAd)
         {
            _loc1_ = (this.rootClass.date_server.getTime() - this.rootClass.world.myAvatar.objData.dCreated.getTime()) / 1000;
            _loc2_ = _loc1_ / (60 * 60);
            _loc3_ = 0;
            while(_loc3_ < this.arrAds.length)
            {
               if(Boolean(this.arrAds[_loc3_].sType == "member" && this.rootClass.world.myAvatar.isUpgraded()) || Boolean(this.arrAds[_loc3_].sType == "aeextra" && int(this.rootClass.world.myAvatar.objData.iAge) < 13) || Boolean(this.arrAds[_loc3_].sType == "dragonhero") && (Boolean(_loc2_ >= 72 || this.rootClass.world.myAvatar.isUpgraded())))
               {
                  this.arrAds.splice(_loc3_,1);
                  _loc3_--;
               }
               _loc3_++;
            }
            this.iAdIndex = Math.floor(Math.random() * this.arrAds.length);
            this.mcContent.mcAd.removeChildAt(0);
            _loc4_ = new Loader();
            _loc4_.load(new URLRequest(this.rootClass.sFilePath + this.arrAds[this.iAdIndex].sURL));
            this.mcContent.mcAd.addChild(_loc4_);
            this.mcContent.mcAd.visible = true;
         }
         else
         {
            this.mcContent.mcAd.visible = false;
            this.mcContent.mcButtons.txtRes.visible = false;
            this.mcContent.mcButtons.btnRes.visible = false;
         }
      }

      public function onCheckBoxClick(param1:Event) : void
      {
         if(this.rootClass.world.myAvatar.isUpgraded())
         {
            this.rootClass.userPreference.data.bDeathAd = !this.mcContent.mcButtons.chkAds.bitChecked;
            this.rootClass.userPreference.flush();
            this.loadAd();
         }
      }

      internal function frame1() : *
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.arrTips = new Array("Never give you password to ANYONE. AQW staff will never ask for it.","Never share your password or your account with anyone.","Sharing accounts is against the rules and might get you banned!","Strength improves your chance of a critical strike for melee classes.","Learn about Enhancing your weapons by clicking the ENHANCEMENT button in Battleon!","Keep your enhancements up to date!","Remember to rest in between battles!","Intellect increases Magic Power and boosts magical damage and crit for caster classes.","Wisdom only increases evasion for melee classes.","Make sure yo read your tool tips for each skill you unlock!","Mayonnaise should never be heated. It might make you ill!","We were all noobs once. Help out new players!","Members get access to special Member-only areas, classes and items!","Don\'t stare at the sun.","If someone is misbehaving, click on their character portrait to report them!","Go easy on the carbs unless you move a lot.","\"A lot\" is two words, not one."
         ,"Sneevils LOVE boxes!","You can get more item storage from the BANK! Visit Valencia in Battleontown!","You can store items you got with AdventureCoins for FREE in the bank!","Try having breakfast for dinner. You can thank me later.","Clown pants are not heroic.","Remember to link your AQW account to your MASTER ACCOUNT for additional safety!","Lost? You can always /join BattleOn","Trying to catch up with a friend? Type /goto <player name>","You can hide the chat panel by clicking on the arrow on your interface.","If someone is being rude you can IGNORE them by clicking on their character portrait.","To Reply to a private message, just type /r and hit ENTER!","Gain experience, gold and rep by completing quests.","You can buy more space in your backpack from Valencia in Battleontown!","You can use potions or food in battle if you equip it!","Spotted a game bug? Report it on the official AQW forums!","Staff will NEVER offer you free items, gold, ACs, or membership over Twitter or Facebook."
         ,"Looking for things to do? Check your Book of Lore or the Adventure Button in Battleon!","Always read the AQW Design Notes to find out what\'s coming next!","Check out HEROMART.COM for lots of cool AQW shirts, games and more!","Buying stuff at HEROMART.COM will earn you special in-game items!","Game Moderators, Developers and Staff always have a gold name above their head.","Give us your feedback on this week\'s release on the forum, Twitter and Facebook!","Do not share your account information with ANYONE, no matter what they promise you.","Confirm your email to unlock chat and gain Power Gem! Refer a friend to get Friend Gems and unlock Twilly\'s shop!","Never give your email password to anyone!","Cysero\'s left sock might be in your backpack right now!","Don\'t give up now, you\'re just about to win!","YOU are the only Hero who can save Lore. You must return to battle!","Never leave home without an extra HP potion!");
         this.arrAds = new Array({
            "sURL":"DeathAds/DragonHero.swf",
            "sTarget":"https://www.aq.com/order-now/direct/",
            "sType":"dragonhero"
         },{
            "sURL":"DeathAds/DeathAd-MemberUpgrade.jpg",
            "sTarget":"https://www.aq.com/order-now/direct/",
            "sType":"member"
         },{
            "sURL":"DeathAds/250w-aextras.jpg",
            "sTarget":"https://www.aq.com/aeXtras/offers/",
            "sType":"aeextra"
         },{
            "sURL":"DeathAds/ED_320x250-Death.jpg",
            "sTarget":"https://epicduel.artix.com",
            "sType":"epicduel"
         },{
            "sURL":"DeathAds/ED_Death_320x250.jpg",
            "sTarget":"https://epicduel.artix.com/",
            "sType":"Epic Duel"
         },{
            "sURL":"DeathAds/DragonFable-Death-Ad-01.jpg",
            "sTarget":"https://www.Dragonfable.com/",
            "sType":"Dragon Fable"
         },{
            "sURL":"DeathAds/DragonFable-Death-Ad-04.jpg",
            "sTarget":"https://www.Dragonfable.com/",
            "sType":"Dragon Fable"
         },{
            "sURL":"DeathAds/AQDragons-Death-Ad.jpg",
            "sTarget":"https://www.aqdragons.com/",
            "sType":"Dragons"
         },{
            "sURL":"DeathAds/UndeadAssault-Death-Ad.jpg",
            "sTarget":"https://undeadassault.com/",
            "sType":"Undead Assault"
         },{
            "sURL":"DeathAds/BattleGems-Death-Ad.jpg",
            "sTarget":"https://battlegems.artix.com/",
            "sType":"Battle Gems"
         });
         this.iAdIndex = 0;
         this.mcContent.mcAd.addEventListener(MouseEvent.CLICK,this.clickGo);
         this.mcContent.mcAd.buttonMode = true;
         if(this.rootClass.userPreference.data.bDeathAd == null)
         {
            this.rootClass.userPreference.data.bDeathAd = true;
         }
         this.mcContent.mcButtons.chkAds.chkBtn.addEventListener(MouseEvent.CLICK,this.onCheckBoxClick,false,0,true);
         stop();
      }

      internal function frame5() : *
      {
         this.visible = true;
         this.mcContent.txtTip.htmlText = "<b>Death\'s Note:</b> " + this.arrTips[Math.floor(Math.random() * this.arrTips.length)];
         this.loadAd();
      }

      internal function frame20() : *
      {
         stop();
      }

      internal function frame57() : *
      {
         stop();
      }
   }
}
