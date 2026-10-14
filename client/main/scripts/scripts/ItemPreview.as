package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol735")]
   public class ItemPreview extends MovieClip
   {

      private static const WHITE_GLOW:GlowFilter = new GlowFilter(16777215,1,8,8,2,1,false,false);

      public var btnClose:SimpleButton;

      internal var rootClass:MovieClip = MovieClip(Game.root);

      internal var mcStage:MovieClip;

      internal var curItem:Object;

      internal var sLinkArmor:String = "";

      internal var sLinkCape:String = "";

      internal var sLinkHelm:String = "";

      internal var sLinkPet:String = "";

      internal var sLinkWeapon:String = "";

      private var assetLoader:PreviewAssetLoader;

      public function ItemPreview()
      {
         super();
         this.x = 50;
         this.y = 90;
         this.btnClose.addEventListener(MouseEvent.CLICK,this.xClick,false,0,true);
         this.mcStage = MovieClip(this.addChild(new MovieClip()));
      }

      private function ensureAssetLoader() : void
      {
         if(this.assetLoader == null)
         {
            this.assetLoader = new PreviewAssetLoader(this.mcStage,this.rootClass,false);
         }
      }

      private function xClick(param1:MouseEvent) : *
      {
         this.btnClose.removeEventListener(MouseEvent.CLICK,this.xClick);
         if(this.assetLoader != null)
         {
            this.assetLoader.dispose();
            this.assetLoader = null;
         }
         this.rootClass.clearModalStack();
      }

      public function loadItem(param1:Object) : void
      {
         this.ensureAssetLoader();
         if(this.curItem != param1)
         {
            this.curItem = param1;
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
               case "ho":
                  this.loadHouse(param1.sFile);
                  break;
               case "hi":
                  this.loadItemFile();
            }
         }
      }

      private function clearStage() : void
      {
         this.ensureAssetLoader();
         this.assetLoader.clearLoaderStack();
         var _loc1_:* = int(this.mcStage.numChildren - 1);
         while(_loc1_ >= 0)
         {
            this.mcStage.removeChildAt(_loc1_);
            _loc1_--;
         }
      }

      private function loadWeapon(param1:String, param2:String) : void
      {
         this.clearStage();
         this.sLinkWeapon = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"weapon",this.onLoadWeaponComplete,this.onLoadError);
      }

      private function loadCape(param1:String, param2:String) : void
      {
         this.clearStage();
         this.sLinkCape = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"cape",this.onLoadCapeComplete,this.onLoadError);
      }

      private function loadHelm(param1:String, param2:String) : void
      {
         this.clearStage();
         this.sLinkHelm = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"helm",this.onLoadHelmComplete,this.onLoadError);
      }

      private function loadPet(param1:String, param2:String) : void
      {
         this.clearStage();
         this.sLinkPet = param2;
         this.assetLoader.loadAsset(Game.serverFilePath + param1,param2,"pet",this.onLoadPetComplete,this.onLoadError);
      }

      private function loadHouse(param1:String) : void
      {
         this.clearStage();
         var _loc1_:String = this.curItem.sFile.substring(0,this.curItem.sFile.length - 4);
         var _loc2_:String = "maps/" + _loc1_ + "_preview.swf";
         this.assetLoader.loadAsset(Game.serverFilePath + _loc2_,"","house",this.onLoadHouseComplete,this.onLoadError);
      }

      internal function onLoadHouseComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:String = this.curItem.sFile.substring(0,this.curItem.sFile.length - 4);
         var _loc3_:int = this.curItem.sFile.lastIndexOf("/") + 1;
         var _loc4_:String = _loc2_.substr(_loc3_).split("-").join("_") + "_preview";
         var _loc5_:Class = this.assetLoader.getDefinition(_loc4_);
         if(_loc5_ != null)
         {
            _loc1_ = new _loc5_();
            _loc1_.x = 150;
            _loc1_.y = 200;
            this.mcStage.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      private function loadArmor(param1:String, param2:String) : void
      {
         this.clearStage();
         this.sLinkArmor = param2;
         var _loc1_:* = this.mcStage.addChild(new AvatarMC());
         _loc1_.strGender = this.rootClass.world.myAvatar.objData.strGender;
         _loc1_.x = 150;
         _loc1_.y = 250;
         _loc1_.scaleX = _loc1_.scaleY = 1.65;
         _loc1_.pAV = this.rootClass.world.myAvatar;
         _loc1_.world = MovieClip(Game.root).world;
         _loc1_.hideHPBar();
         _loc1_.name = "previewMC";
         _loc1_.loadArmor(param1,param2);
         this.addGlow(_loc1_.mcChar);
      }

      internal function onLoadWeaponComplete(param1:Event, param2:String, param3:String) : void
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
         mc.x = 150;
         mc.y = 180;
         mc.scaleX = mc.scaleY = 0.3;
         this.mcStage.addChild(mc);
         this.addGlow(mc);
      }

      internal function onLoadCapeComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Class = this.assetLoader.getDefinition(this.sLinkCape);
         if(_loc2_ != null)
         {
            _loc1_ = new _loc2_();
            _loc1_.x = 150;
            _loc1_.y = 150;
            _loc1_.scaleX = _loc1_.scaleY = 0.5;
            this.mcStage.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      internal function onLoadHelmComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Class = this.assetLoader.getDefinition(this.sLinkHelm);
         if(_loc2_ != null)
         {
            _loc1_ = new _loc2_();
            _loc1_.x = 170;
            _loc1_.y = 200;
            this.mcStage.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      internal function onLoadPetComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Class = this.assetLoader.getDefinition(this.sLinkPet);
         if(_loc2_ != null)
         {
            _loc1_ = new _loc2_();
            _loc1_.x = 150;
            _loc1_.y = 250;
            _loc1_.scaleX = _loc1_.scaleY = 2;
            this.mcStage.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      private function addGlow(param1:MovieClip) : void
      {
         param1.filters = [WHITE_GLOW];
      }

      private function loadItemFile() : void
      {
         this.clearStage();
         this.assetLoader.loadAsset(Game.serverFilePath + this.curItem.sFile,this.curItem.sLink,"houseitem",this.onLoadItemFileComplete,this.onLoadError);
      }

      internal function onLoadItemFileComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc1_:* = undefined;
         var _loc2_:Class = this.assetLoader.getDefinition(this.curItem.sLink);
         if(_loc2_ != null)
         {
            _loc1_ = new _loc2_();
            _loc1_.x = 150;
            _loc1_.y = 250;
            if(_loc1_.height > 225)
            {
               _loc1_.height = 225;
               _loc1_.scaleX = _loc1_.scaleY;
            }
            if(_loc1_.width > 275)
            {
               _loc1_.width = 275;
               _loc1_.scaleY = _loc1_.scaleX;
            }
            this.mcStage.addChild(_loc1_);
            this.addGlow(_loc1_);
         }
      }

      private function onLoadError(param1:String) : void
      {
         trace("[Load] ERR ItemPreview load: " + param1);
      }
   }
}
