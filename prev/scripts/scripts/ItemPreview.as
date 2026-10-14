package
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol743")]
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
         var _loc2_:String = this.curItem.sFile.substring(0,this.curItem.sFile.length - 4);
         var _loc3_:String = "maps/" + _loc2_ + "_preview.swf";
         this.assetLoader.loadAsset(Game.serverFilePath + _loc3_,"","house",this.onLoadHouseComplete,this.onLoadError);
      }

      internal function onLoadHouseComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:String = this.curItem.sFile.substring(0,this.curItem.sFile.length - 4);
         var _loc6_:int = this.curItem.sFile.lastIndexOf("/") + 1;
         var _loc7_:String = _loc5_.substr(_loc6_).split("-").join("_") + "_preview";
         var _loc8_:Class = this.assetLoader.getDefinition(_loc7_);
         if(_loc8_ != null)
         {
            _loc4_ = new _loc8_();
            _loc4_.x = 150;
            _loc4_.y = 200;
            this.mcStage.addChild(_loc4_);
            this.addGlow(_loc4_);
         }
      }

      private function loadArmor(param1:String, param2:String) : void
      {
         this.clearStage();
         this.sLinkArmor = param2;
         var _loc3_:* = this.mcStage.addChild(new AvatarMC());
         _loc3_.strGender = this.rootClass.world.myAvatar.objData.strGender;
         _loc3_.x = 150;
         _loc3_.y = 250;
         _loc3_.scaleX = _loc3_.scaleY = 1.65;
         _loc3_.pAV = this.rootClass.world.myAvatar;
         _loc3_.world = MovieClip(Game.root).world;
         _loc3_.hideHPBar();
         _loc3_.name = "previewMC";
         _loc3_.loadArmor(param1,param2);
         this.addGlow(_loc3_.mcChar);
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
         var _loc6_:* = undefined;
         var _loc5_:Class = this.assetLoader.getDefinition(this.sLinkCape);
         if(_loc5_ != null)
         {
            _loc6_ = new _loc5_();
            _loc6_.x = 150;
            _loc6_.y = 150;
            _loc6_.scaleX = _loc6_.scaleY = 0.5;
            this.mcStage.addChild(_loc6_);
            this.addGlow(_loc6_);
         }
      }

      internal function onLoadHelmComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc6_:* = undefined;
         var _loc5_:Class = this.assetLoader.getDefinition(this.sLinkHelm);
         if(_loc5_ != null)
         {
            _loc6_ = new _loc5_();
            _loc6_.x = 170;
            _loc6_.y = 200;
            this.mcStage.addChild(_loc6_);
            this.addGlow(_loc6_);
         }
      }

      internal function onLoadPetComplete(param1:Event, param2:String, param3:String) : void
      {
         var _loc6_:* = undefined;
         var _loc5_:Class = this.assetLoader.getDefinition(this.sLinkPet);
         if(_loc5_ != null)
         {
            _loc6_ = new _loc5_();
            _loc6_.x = 150;
            _loc6_.y = 250;
            _loc6_.scaleX = _loc6_.scaleY = 2;
            this.mcStage.addChild(_loc6_);
            this.addGlow(_loc6_);
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
         var _loc6_:* = undefined;
         var _loc5_:Class = this.assetLoader.getDefinition(this.curItem.sLink);
         if(_loc5_ != null)
         {
            _loc6_ = new _loc5_();
            _loc6_.x = 150;
            _loc6_.y = 250;
            if(_loc6_.height > 225)
            {
               _loc6_.height = 225;
               _loc6_.scaleX = _loc6_.scaleY;
            }
            if(_loc6_.width > 275)
            {
               _loc6_.width = 275;
               _loc6_.scaleY = _loc6_.scaleX;
            }
            this.mcStage.addChild(_loc6_);
            this.addGlow(_loc6_);
         }
      }

      private function onLoadError(param1:String) : void
      {
         trace("[Load] ERR ItemPreview load: " + param1);
      }
   }
}
