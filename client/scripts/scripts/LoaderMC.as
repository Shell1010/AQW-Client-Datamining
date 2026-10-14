package
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.text.TextField;
   import types.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol2150")]
   public class LoaderMC extends MovieClip
   {

      public var btnCancel:SimpleButton;

      public var mcPct:TextField;

      public var strLoad:TextField;

      internal var mcDest:MovieClip;

      internal var isEvent:Boolean = false;

      private var rootClass:MovieClip;

      public var history:Object = {};

      private var _file:String;

      private var loadSeq:int = 0;

      public function LoaderMC(param1:MovieClip)
      {
         super();
         this.btnCancel.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.rootClass = param1;
      }

      public function loadFile(param1:MovieClip, param2:String, param3:String, param4:Boolean = false) : void
      {
         this._file = param2;
         var _loc1_:Number = new Date().getTime();
         if(param2.indexOf("https://") == -1 && param2.indexOf("http://") == -1 && param2.indexOf("file://") == -1)
         {
            param2 = Game.serverFilePath + param2;
         }
         this.isEvent = param4;
         if(param3 != "Inline Asset")
         {
            MovieClip(Game.root).addChild(this);
         }
         this.mcDest = param1;
         var _loc2_:* = new AirLoader();
         _loc2_.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.onContentError,false,0,true);
         _loc2_.contentLoaderInfo.addEventListener(Event.INIT,this.onFileLoadComplete,false,0,true);
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onFileLoadComplete,false,0,true);
         _loc2_.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.onFileLoadProgress,false,0,true);
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadError,false,0,true);
         _loc2_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFileLoadSecurityError,false,0,true);
         this.history[param2 + "#" + ++this.loadSeq] = {
            "ts":_loc1_,
            "ldr":_loc2_,
            "dest":param1,
            "evt":param4
         };
         trace("[Load] LoaderMC loadFile: " + param2);
         _loc2_.load(new URLRequest(Game.vurl(param2)),new LoaderContext(false,new ApplicationDomain(ApplicationDomain.currentDomain)));
      }

      private function onContentError(param1:UncaughtErrorEvent) : void
      {
         var _loc3_:Error = null;
         param1.preventDefault();
         param1.stopImmediatePropagation();
         try
         {
            _loc3_ = param1.error as Error;
            trace("[Load] ERR LoaderMC suppressed: " + (_loc3_ != null ? _loc3_.message : String(param1.error)));
         }
         catch(e2:Error)
         {
         }
      }

      private function onFileLoadComplete(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:* = this.rootClass.world;
         var _loc4_:Loader = Loader(param1.target.loader);
         var _loc5_:MovieClip = this.mcDest;
         var _loc1_:Boolean = this.isEvent;
         try
         {
            for(_loc2_ in this.history)
            {
               if(this.history[_loc2_].ldr == _loc4_)
               {
                  if(this.history[_loc2_].dest != null)
                  {
                     _loc5_ = this.history[_loc2_].dest;
                  }
                  _loc1_ = Boolean(this.history[_loc2_].evt);
                  delete this.history[_loc2_];
               }
            }
         }
         catch(e:Error)
         {
         }
         _loc4_.contentLoaderInfo.removeEventListener(Event.INIT,this.onFileLoadComplete);
         _loc4_.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onFileLoadComplete);
         _loc4_.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onFileLoadProgress);
         _loc4_.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadError);
         _loc4_.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFileLoadSecurityError);
         try
         {
            if(_loc4_.content != null && _loc5_ != null)
            {
               _loc5_.addChild(_loc4_.content);
            }
         }
         catch(e:Error)
         {
         }
         if(_loc1_ && _loc3_ != null)
         {
            trace("[Load] LoaderMC fileLoaded event -> world");
            _loc3_.mapEventTrigger({
               "cmd":"fileLoaded",
               "args":{"loc":"default"}
            });
         }
         this.isEvent = false;
         this.mcDest = null;
         try
         {
            MovieClip(parent).removeChild(this);
         }
         catch(e:Error)
         {
         }
      }

      private function onFileLoadProgress(param1:ProgressEvent) : void
      {
         var _loc3_:int = Math.floor(param1.bytesLoaded / param1.bytesTotal * 100);
         if(param1.bytesTotal <= 0)
         {
            _loc3_ = 0;
         }
         this.strLoad.text = "Loading!";
         this.mcPct.text = _loc3_ + "%";
      }

      private function onFileLoadError(param1:IOErrorEvent) : void
      {
         trace("[Load] ERR LoaderMC IO: " + param1.text);
         this.strLoad.text = "Load Error";
         this.signalEventLoadDone(Loader(param1.target.loader));
         this.cleanupLoader(Loader(param1.target.loader));
      }

      private function onFileLoadSecurityError(param1:SecurityErrorEvent) : void
      {
         trace("[Load] ERR LoaderMC security: " + param1.text);
         this.strLoad.text = "Security Error";
         this.signalEventLoadDone(Loader(param1.target.loader));
         this.cleanupLoader(Loader(param1.target.loader));
      }

      private function signalEventLoadDone(param1:Loader) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         var _loc5_:String = null;
         var _loc1_:* = undefined;
         try
         {
            _loc3_ = false;
            _loc4_ = false;
            for(_loc5_ in this.history)
            {
               if(this.history[_loc5_].ldr == param1)
               {
                  _loc4_ = true;
                  if(this.history[_loc5_].evt)
                  {
                     _loc3_ = true;
                  }
               }
            }
            if(!_loc4_)
            {
               _loc3_ = this.isEvent;
            }
            _loc1_ = this.rootClass.world;
            if(_loc3_ && _loc1_ != null)
            {
               trace("[Load] LoaderMC fileLoaded event (error path) -> world");
               _loc1_.mapEventTrigger({
                  "cmd":"fileLoaded",
                  "args":{"loc":"default"}
               });
            }
         }
         catch(e:Error)
         {
         }
      }

      private function cleanupLoader(param1:Loader) : void
      {
         var _loc3_:String = null;
         try
         {
            param1.contentLoaderInfo.removeEventListener(Event.INIT,this.onFileLoadComplete);
            param1.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onFileLoadComplete);
            param1.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.onFileLoadProgress);
            param1.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onFileLoadError);
            param1.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFileLoadSecurityError);
            for(_loc3_ in this.history)
            {
               if(this.history[_loc3_].ldr == param1)
               {
                  delete this.history[_loc3_];
                  break;
               }
            }
         }
         catch(e:Error)
         {
         }
         this.mcDest = null;
         try
         {
            MovieClip(parent).removeChild(this);
         }
         catch(e:Error)
         {
         }
      }

      public function closeHistory(param1:MovieClip = null) : void
      {
         var _loc3_:String = null;
         var _loc4_:Loader = null;
         for(_loc3_ in this.history)
         {
            if(!(param1 != null && this.history[_loc3_].dest != param1))
            {
               trace("[Load] LoaderMC closeHistory killing: " + _loc3_);
               try
               {
                  this.history[_loc3_].ldr.close();
               }
               catch(e:Error)
               {
               }
               try
               {
                  _loc4_ = this.history[_loc3_].ldr;
                  if(_loc4_.content != null && _loc4_.content is MovieClip)
                  {
                     MovieClip(_loc4_.content).stop();
                  }
               }
               catch(e:Error)
               {
               }
               try
               {
                  this.history[_loc3_].ldr.unloadAndStop(true);
               }
               catch(e:Error)
               {
               }
               delete this.history[_loc3_];
            }
         }
         if(param1 == null)
         {
            this.history = {};
         }
      }

      private function onCancelClick(param1:MouseEvent) : void
      {
         MovieClip(Game.root).logout();
         MovieClip(parent).removeChild(this);
      }
   }
}
