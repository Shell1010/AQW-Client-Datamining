package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Rectangle;
   import flash.text.*;
   import liteAssets.draw.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2123")]
   public class BankPreview extends MovieClip
   {

      private static const WHITE_GLOW:GlowFilter = new GlowFilter(16777215,1,8,8,2,1,false,false);

      private static const PAD:int = 6;

      private static const FAV_SIZE:int = 25;

      private static const BADGE_SIZE:int = 68;

      private static const AVATAR_H:int = 120;

      public var btnDelete:SimpleButton;

      public var mcCoin:MovieClip;

      public var mcPreview:MovieClip;

      public var mcUpgrade:MovieClip;

      public var tInfo:TextField;

      private var iSel:Object;

      private var previewArgs:Object = {};

      private var rootClass:MovieClip;

      private var curItem:Object;

      private var sLinkArmor:String = "";

      private var sLinkCape:String = "";

      private var sLinkHelm:String = "";

      private var sLinkPet:String = "";

      private var sLinkWeapon:String = "";

      private var sLinkMisc:String = "";

      private var assetLoader:PreviewAssetLoader;

      private var efActive:Boolean = false;

      private var favBtn:FavButton;

      private var pw:Number = 255;

      private var ph:Number = 204;

      public function BankPreview()
      {
         super();
         this.mcCoin.visible = false;
         this.mcUpgrade.visible = false;
         this.btnDelete.addEventListener(MouseEvent.CLICK,this.onBtnDeleteClick,false,0,true);
         this.btnDelete.addEventListener(MouseEvent.MOUSE_OVER,this.onDeleteTTOver,false,0,true);
         this.btnDelete.addEventListener(MouseEvent.MOUSE_OUT,this.onDeleteTTOut,false,0,true);
         this.mcCoin.addEventListener(MouseEvent.MOUSE_OVER,this.onCoinTTOver,false,0,true);
         this.mcCoin.addEventListener(MouseEvent.MOUSE_OUT,this.onCoinTTOut,false,0,true);
         this.mcUpgrade.addEventListener(MouseEvent.MOUSE_OVER,this.onUpgradeTTOver,false,0,true);
         this.mcUpgrade.addEventListener(MouseEvent.MOUSE_OUT,this.onUpgradeTTOut,false,0,true);
         this.favBtn = new FavButton(25);
      }

      private function ensureAssetLoader() : void
      {
         if(this.assetLoader == null)
         {
            this.assetLoader = new PreviewAssetLoader(this.mcPreview,this.rootClass,false);
         }
      }

      private function startKillStackProcessing() : void
      {
         if(!this.efActive)
         {
            this.efActive = true;
            addEventListener(Event.ENTER_FRAME,this.onEF,false,0,true);
         }
      }

      private function stopKillStackProcessing() : void
      {
         if(Boolean(this.efActive) && this.assetLoader != null && !this.assetLoader.hasKillStackItems)
         {
            this.efActive = false;
            removeEventListener(Event.ENTER_FRAME,this.onEF);
         }
      }

      public function Open(param1:Object) : void
      {
         this.rootClass = MovieClip(stage.getChildAt(0));
         this.ensureAssetLoader();
         this.x = param1.r.x;
         this.y = param1.r.y;
         this.pw = param1.r.w;
         this.ph = param1.r.h;
         this.layoutBox();
         if(parent != null)
         {
            this.favBtn.x = Math.round(x + this.pw - FAV_SIZE - PAD);
            this.favBtn.y = Math.round(y + this.ph - FAV_SIZE - PAD);
            parent.addChild(this.favBtn);
         }
         this.iSel = param1.item;
         this.fDraw();
      }

      private function layoutBox() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:Rectangle = null;
         _loc1_ = getChildAt(0);
         if(_loc1_ is Shape)
         {
            _loc1_.width = this.pw;
            _loc1_.height = this.ph;
            _loc2_ = _loc1_.getBounds(this);
            _loc1_.x -= _loc2_.x;
            _loc1_.y -= _loc2_.y;
         }
         this.fitBadge(this.mcCoin);
         this.fitBadge(this.mcUpgrade);
         this.mcPreview.x = 0;
         this.mcPreview.y = 0;
         this.tInfo.x = PAD;
         this.tInfo.width = this.pw - PAD * 2 - FAV_SIZE - 4;
      }

      private function fitBadge(param1:DisplayObject) : void
      {
         var _loc1_:Rectangle = param1.getBounds(param1);
         if(_loc1_.width <= 0 || _loc1_.height <= 0)
         {
            return;
         }
         param1.scaleX = param1.scaleY = BADGE_SIZE / Math.max(_loc1_.width,_loc1_.height);
         _loc1_ = param1.getBounds(this);
         param1.x += Math.round(this.pw - PAD - _loc1_.right);
         param1.y += Math.round(PAD - _loc1_.y);
      }

      public function fClose() : void
      {
         this.btnDelete.removeEventListener(MouseEvent.CLICK,this.onBtnDeleteClick);
         this.btnDelete.removeEventListener(MouseEvent.MOUSE_OVER,this.onDeleteTTOver);
         this.btnDelete.removeEventListener(MouseEvent.MOUSE_OUT,this.onDeleteTTOut);
         this.mcCoin.removeEventListener(MouseEvent.MOUSE_OVER,this.onCoinTTOver);
         this.mcCoin.removeEventListener(MouseEvent.MOUSE_OUT,this.onCoinTTOut);
         this.mcUpgrade.removeEventListener(MouseEvent.MOUSE_OVER,this.onUpgradeTTOver);
         this.mcUpgrade.removeEventListener(MouseEvent.MOUSE_OUT,this.onUpgradeTTOut);
         if(this.efActive)
         {
            removeEventListener(Event.ENTER_FRAME,this.onEF);
            this.efActive = false;
         }
         if(this.favBtn != null)
         {
            this.favBtn.dispose();
            this.favBtn = null;
         }
         if(this.assetLoader != null)
         {
            this.assetLoader.dispose();
            this.assetLoader = null;
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }

      public function Show(param1:Object) : void
      {
         if(param1 == null)
         {
            this.Hide();
            return;
         }
         this.iSel = param1;
         this.fDraw();
         this.visible = true;
      }

      public function Hide() : void
      {
         if(this.favBtn != null)
         {
            this.favBtn.bind(null,this.rootClass,true);
         }
         this.visible = false;
      }

      protected function fDraw() : void
      {
         this.btnDelete.visible = false;
         var _loc1_:String = "";
         var _loc2_:String = "";
         var _loc3_:String = "#00CCFF";
         var _loc4_:Object = this.iSel;
         if(_loc4_ != null)
         {
            this.btnDelete.visible = true;
            this.tInfo.htmlText = this.rootClass.getItemInfoStringB(_loc4_);
            this.tInfo.height = this.tInfo.textHeight + 4;
            this.tInfo.y = int(Math.max(PAD,this.ph - PAD - 2 - this.tInfo.textHeight));
            this.mcUpgrade.visible = false;
            this.mcCoin.visible = false;
            if(_loc4_.bUpg == 1)
            {
               this.mcUpgrade.visible = true;
            }
            if(_loc4_.bCoins == 1)
            {
               this.mcUpgrade.visible = false;
               this.mcCoin.visible = true;
            }
            this.loadPreview(_loc4_);
         }
         else
         {
            while(this.mcPreview.numChildren > 0)
            {
               this.mcPreview.removeChildAt(0);
            }
            this.clearPreview();
         }
         if(this.favBtn != null)
         {
            this.favBtn.bind(_loc4_,this.rootClass,true);
         }
         this.btnDelete.visible = false;
      }

      private function onBtnDeleteClick(param1:Event) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:int = 0;
         this.rootClass.mixer.playSound("Click");
         if(FavStore.has(this.iSel.ItemID))
         {
            FavStore.notifyLocked(this.rootClass,"discarding");
         }
         else if(this.iSel.bEquip)
         {
            this.rootClass.MsgBox.notify("Item is currently equipped!");
         }
         else
         {
            _loc1_ = new ModalMC();
            _loc2_ = {};
            _loc2_.params = {};
            if(this.iSel.bCoins != null && this.iSel.bCoins == 1 && (this.iSel.iQty > 0 || this.iSel.sES == "ar"))
            {
               _loc2_.strBody = "<font color=\'#FF0000\'><b>AC items can not be deleted!</b></font>\n\nYou may sell the item if you really want, but there is no limit on AC item storage!";
               _loc2_.btns = "mono";
            }
            else
            {
               if(this.iSel.sES == "ar")
               {
                  _loc2_.strBody = "Are you sure you want to delete \'" + this.iSel.sName + "\' and the rank associated with it?";
               }
               else
               {
                  _loc2_.strBody = "Are you sure you want to delete \'" + this.iSel.sName + "\'?";
               }
               _loc2_.callback = this.deleteRequest;
               _loc3_ = this.iSel.iQty != null ? int(this.iSel.iQty) : 1;
               if(this.iSel.sES == "ar")
               {
                  _loc3_ = 1;
               }
               if(_loc3_ > 1)
               {
                  _loc2_.qtySel = {
                     "min":1,
                     "max":_loc3_
                  };
               }
            }
            _loc2_.glow = "white,medium";
            _loc2_.greedy = true;
            this.rootClass.ui.ModalStack.addChild(_loc1_);
            _loc1_.init(_loc2_);
         }
      }

      public function deleteRequest(param1:Object) : void
      {
         if(param1.accept)
         {
            if(param1.iQty != null)
            {
               this.rootClass.world.sendRemoveItemRequest(this.iSel,param1.iQty);
            }
            else
            {
               this.rootClass.world.sendRemoveItemRequest(this.iSel);
            }
         }
      }

      private function loadPreview(param1:Object) : void
      {
         this.ensureAssetLoader();
         if(param1.sType.toLowerCase() != "enhancement")
         {
            if(this.curItem != param1)
            {
               this.curItem = param1;
               switch(param1.sType)
               {
                  case "House":
                     this.loadHouse(param1.sFile);
                     return;
                  case "Wall Item":
                  case "Floor Item":
                     this.loadHouseItem(param1.sFile,param1.sLink);
                     return;
                  default:
                     switch(param1.sES)
                     {
                        case "Weapon":
                           this.loadWeapon(param1.sFile,param1.sLink);
                           break;
                        case "he":
                           this.loadHelm(param1.sFile,param1.sLink);
                           break;
                        case "ba":
                           this.loadCape(param1.sFile,param1.sLink);
                           break;
                        case "pe":
                           this.loadPet(param1.sFile,param1.sLink);
                           break;
                        case "ar":
                        case "co":
                           this.loadArmor(param1.sFile,param1.sLink);
                           break;
                        case "mi":
                           this.loadMisc(param1.sFile,param1.sLink);
                           break;
                        default:
                           if(param1.sType.toLowerCase() == "item" && String(param1.sLink).toLowerCase() != "none")
                           {
                              this.loadBag(param1);
                           }
                           else if(param1.sES == "am")
                           {
                              this.loadBag(param1,true);
                           }
                           else if(param1.sType.toLowerCase() == "serveruse" || param1.sType.toLowerCase() == "clientuse")
                           {
                              this.loadBag(param1);
                           }
                           else
                           {
                              this.clearPreview();
                           }
                     }
               }
            }
         }
         else
         {
            this.loadEnhancement(param1);
         }
      }

      private function clearPreview() : void
      {
         this.ensureAssetLoader();
         this.assetLoader.clearPreview();
         this.startKillStackProcessing();
         this.curItem = null;
      }

      private function loadEnhancement(param1:*) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var item:* = param1;
         this.clearPreview();
         try
         {
            AssetClass = this.rootClass.world.getClass("iidesign") as Class;
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            trace("[UI] ERR BankPreview: iidesign class: " + err.message);
         }
         mc.scaleX = mc.scaleY = 3;
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }

      private function loadBag(param1:*, param2:Boolean = false) : void
      {
         var _loc1_:MovieClip = null;
         this.clearPreview();
         var _loc2_:Class = this.rootClass.world.getClass("iibag") as Class;
         if(param2 || (param1 == null || !("sFile" in param1) || String(param1.sFile).length < 1 || this.rootClass.world.getClass(param1.sFile) == null))
         {
            _loc2_ = this.rootClass.world.getClass(param1.sIcon) as Class;
         }
         else if(param1 != null && "sFile" in param1 && String(param1.sFile).length > 0 && this.rootClass.world.getClass(param1.sFile) != null)
         {
            _loc2_ = this.rootClass.world.getClass(param1.sFile) as Class;
         }
         try
         {
            _loc1_ = new _loc2_();
            _loc1_.scaleX = _loc1_.scaleY = 3;
            this.mcPreview.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
         catch(e:Error)
         {
         }
      }

      private function loadMisc(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkMisc = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"misc",this.onLoadMiscComplete,this.onLoadError);
      }

      private function loadWeapon(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkWeapon = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"weapon",this.onLoadWeaponComplete,this.onLoadError);
      }

      private function loadCape(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkCape = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"cape",this.onLoadCapeComplete,this.onLoadError);
      }

      private function loadHelm(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkHelm = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"helm",this.onLoadHelmComplete,this.onLoadError);
      }

      private function loadPet(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkPet = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"pet",this.onLoadPetComplete,this.onLoadError);
      }

      private function loadHouse(param1:String) : void
      {
         this.clearPreview();
         var _loc1_:String = param1.substring(0,param1.length - 4);
         var _loc2_:String = "maps/" + _loc1_ + "_preview.swf";
         this.previewArgs.sFile = param1;
         this.assetLoader.loadAsset(Game.serverFilePath + _loc2_,"","house",this.onLoadHouseComplete,this.onLoadError);
      }

      private function onLoadHouseComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:String = this.previewArgs.sFile.substring(0,this.previewArgs.sFile.length - 4);
         var _loc3_:int = this.previewArgs.sFile.lastIndexOf("/") + 1;
         var _loc4_:String = _loc2_.substr(_loc3_).split("-").join("_") + "_preview";
         var _loc5_:Class = this.assetLoader.getDefinition(_loc4_);
         if(_loc5_ != null)
         {
            _loc1_ = new _loc5_();
            this.mcPreview.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      private function loadArmor(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.sLinkArmor = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + "classes/" + this.rootClass.world.myAvatar.objData.strGender + "/" + param1,param2,"armor",this.onLoadArmorComplete,this.onLoadError);
      }

      private function onLoadMiscComplete(param1:Event, param2:String, param3:String) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         var linkage:String = param2;
         var type:String = param3;
         try
         {
            AssetClass = this.assetLoader.getDefinition(this.sLinkMisc);
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }

      private function onLoadWeaponComplete(param1:Event, param2:String, param3:String) : void
      {
         var mc:MovieClip = null;
         var AssetClass:Class = null;
         var e:Event = param1;
         var linkage:String = param2;
         var type:String = param3;
         try
         {
            AssetClass = this.assetLoader.getDefinition(this.sLinkWeapon);
            mc = new AssetClass();
         }
         catch(err:Error)
         {
            mc = e.target.content;
         }
         mc.scaleX = mc.scaleY = 0.3;
         this.mcPreview.addChild(mc);
         this.addGlow(mc);
      }

      private function onLoadCapeComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:Class = null;
         var _loc2_:* = undefined;
         try
         {
            _loc1_ = this.assetLoader.getDefinition(this.sLinkCape);
            _loc2_ = new _loc1_();
            _loc2_.scaleX = _loc2_.scaleY = 0.5;
            this.mcPreview.addChild(_loc2_);
            this.addGlow(_loc2_);
         }
         catch(e:Error)
         {
         }
      }

      private function onLoadHelmComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:Class = null;
         var _loc2_:* = undefined;
         try
         {
            _loc1_ = this.assetLoader.getDefinition(this.sLinkHelm);
            _loc2_ = new _loc1_();
            _loc2_.scaleX = _loc2_.scaleY = 0.8;
            this.mcPreview.addChild(_loc2_);
            this.addGlow(_loc2_);
         }
         catch(e:Error)
         {
         }
      }

      private function onLoadArmorComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = this.mcPreview.addChild(new AvatarMC());
         _loc1_.visible = false;
         _loc1_.strGender = this.rootClass.world.myAvatar.objData.strGender;
         var _loc2_:Avatar = new Avatar(this.rootClass);
         _loc2_.isCharPage = true;
         _loc2_.objData = this.rootClass.copyObj(this.rootClass.world.myAvatar.objData);
         _loc1_.pAV = _loc2_;
         _loc1_.pAV.pMC = _loc1_;
         _loc1_.world = MovieClip(Game.root).world;
         _loc1_.hideHPBar();
         _loc1_.name = "previewMCB";
         var _loc3_:Number = Math.max(1,Math.min(1.6,(this.tInfo.y + 26 - PAD) / AVATAR_H));
         _loc1_.scaleX = _loc1_.scaleY = _loc3_;
         _loc1_.x = int(this.pw / 2);
         _loc1_.y = int(PAD + AVATAR_H * _loc3_);
         this.addGlow(_loc1_.mcChar,false);
         _loc1_.loadArmorPiecesFromDomain(this.sLinkArmor,this.assetLoader.applicationDomain);
         _loc1_.visible = true;
      }

      private function onLoadPetComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Class = this.assetLoader.getDefinition(this.sLinkPet);
         if(_loc2_ != null)
         {
            _loc1_ = new _loc2_();
            _loc1_.scaleX = _loc1_.scaleY = 2;
            this.mcPreview.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      private function addGlow(param1:MovieClip, param2:Boolean = true) : void
      {
         param1.filters = [WHITE_GLOW];
         if(param2)
         {
            this.repositionPreview(param1);
         }
      }

      public function repositionPreview(param1:MovieClip) : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Rectangle = param1.getBounds(this);
         if(_loc2_.width > 0 && _loc2_.height > 0)
         {
            _loc1_ = Math.min((this.ph - PAD * 2) * 0.85 / _loc2_.height,(this.pw - PAD * 2) / _loc2_.width,1.5);
            param1.scaleX *= _loc1_;
            param1.scaleY *= _loc1_;
            _loc2_ = param1.getBounds(this);
         }
         param1.x -= int(_loc2_.x + _loc2_.width / 2 - this.pw / 2);
         param1.y -= int(_loc2_.y - PAD);
      }

      private function loadHouseItem(param1:String, param2:String) : void
      {
         this.clearPreview();
         this.previewArgs.sLink = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"houseitem",this.onloadHouseItemComplete,this.onLoadError);
      }

      private function onloadHouseItemComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Class = this.assetLoader.getDefinition(this.previewArgs.sLink);
         if(_loc2_ != null)
         {
            _loc1_ = new _loc2_();
            this.mcPreview.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      private function onLoadError(param1:String) : void
      {
         trace("[Load] ERR BankPreview load: " + param1);
      }

      private function onDeleteTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"Delete item"});
      }

      private function onDeleteTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }

      private function onCoinTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"This item requires Adventure Coins to purchase."});
      }

      private function onCoinTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }

      private function onUpgradeTTOver(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.openWith({"str":"This item is exclusive to upgraded members."});
      }

      private function onUpgradeTTOut(param1:MouseEvent) : void
      {
         this.rootClass.ui.ToolTip.close();
      }

      private function onEF(param1:Event) : void
      {
         if(this.assetLoader != null)
         {
            this.assetLoader.processKillStack();
            this.stopKillStackProcessing();
         }
      }
   }
}
