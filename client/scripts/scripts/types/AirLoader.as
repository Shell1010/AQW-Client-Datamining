package types
{
   import flash.display.Loader;
   import flash.events.*;
   import flash.net.*;
   import flash.system.*;
   import flash.utils.*;

   public class AirLoader extends Loader
   {

      public static const IMPORT:Boolean = Security.sandboxType == "application";

      public static const trusted:Dictionary = new Dictionary(true);

      public var opened:Boolean = false;

      public var bytesFetched:Number = 0;

      private var fetch:URLLoader;

      private var fetchCtx:LoaderContext;

      private var fetchURL:String;

      public function AirLoader()
      {
         super();
      }

      public static function trust(param1:ApplicationDomain) : ApplicationDomain
      {
         if(param1 != null)
         {
            trusted[param1] = true;
         }
         return param1;
      }

      override public function load(param1:URLRequest, param2:LoaderContext = null) : void
      {
         if(!IMPORT)
         {
            super.load(param1,param2);
            return;
         }
         this.cancelFetch();
         this.opened = false;
         this.bytesFetched = 0;
         this.fetchURL = param1.url;
         this.fetchCtx = param2 != null ? param2 : new LoaderContext();
         this.fetchCtx["allowCodeImport"] = true;
         this.fetch = new URLLoader();
         this.fetch.dataFormat = URLLoaderDataFormat.BINARY;
         this.fetch.addEventListener(Event.OPEN,this.onFetchOpen);
         this.fetch.addEventListener(ProgressEvent.PROGRESS,this.onFetchProgress);
         this.fetch.addEventListener(Event.COMPLETE,this.onFetched);
         this.fetch.addEventListener(IOErrorEvent.IO_ERROR,this.onFetchError);
         this.fetch.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFetchError);
         this.fetch.load(param1);
      }

      override public function close() : void
      {
         var _loc1_:Boolean = this.fetch != null;
         this.cancelFetch();
         if(!_loc1_)
         {
            super.close();
         }
      }

      private function onFetchOpen(param1:Event) : void
      {
         this.opened = true;
      }

      private function onFetchProgress(param1:ProgressEvent) : void
      {
         this.opened = true;
         this.bytesFetched = param1.bytesLoaded;
      }

      private function onFetched(param1:Event) : void
      {
         var _loc2_:ByteArray = this.fetch.data as ByteArray;
         var _loc3_:LoaderContext = this.fetchCtx;
         this.cancelFetch();
         if(_loc2_ == null || _loc2_.length == 0)
         {
            this.failLoad(_loc3_,"empty response");
            return;
         }
         this.bytesFetched = _loc2_.length;
         loadBytes(SwfLoaderPatch.patch(_loc2_,_loc3_.applicationDomain,this.fetchURL),_loc3_);
      }

      private function onFetchError(param1:Event) : void
      {
         var _loc2_:LoaderContext = this.fetchCtx;
         this.cancelFetch();
         this.failLoad(_loc2_,String(param1));
      }

      private function failLoad(param1:LoaderContext, param2:String) : void
      {
         trace("[Load] ERR AirLoader fetch failed: " + this.fetchURL + " :: " + param2);
         var _loc3_:ByteArray = new ByteArray();
         _loc3_.writeUTFBytes("AIRLOADER-FETCH-FAILED");
         loadBytes(_loc3_,param1);
      }

      private function cancelFetch() : void
      {
         var _loc1_:URLLoader = this.fetch;
         this.fetch = null;
         this.fetchCtx = null;
         if(_loc1_ == null)
         {
            return;
         }
         _loc1_.removeEventListener(Event.OPEN,this.onFetchOpen);
         _loc1_.removeEventListener(ProgressEvent.PROGRESS,this.onFetchProgress);
         _loc1_.removeEventListener(Event.COMPLETE,this.onFetched);
         _loc1_.removeEventListener(IOErrorEvent.IO_ERROR,this.onFetchError);
         _loc1_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onFetchError);
         try
         {
            _loc1_.close();
         }
         catch(err:Error)
         {
         }
      }
   }
}
