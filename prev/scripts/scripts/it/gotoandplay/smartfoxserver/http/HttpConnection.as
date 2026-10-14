package it.gotoandplay.smartfoxserver.http
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.net.*;

   public class HttpConnection extends EventDispatcher
   {

      private static const HANDSHAKE:String = "connect";

      private static const DISCONNECT:String = "disconnect";

      private static const CONN_LOST:String = "ERR#01";

      public static const HANDSHAKE_TOKEN:String = "#";

      private static const servletUrl:String = "BlueBox/HttpBox.do";

      private static const paramName:String = "sfsHttp";

      private var sessionId:String;

      private var connected:Boolean = false;

      private var ipAddr:String;

      private var port:int;

      private var webUrl:String;

      private var urlLoaderFactory:LoaderFactory;

      private var urlRequest:URLRequest;

      private var codec:IHttpProtocolCodec;

      public function HttpConnection()
      {
         super();
         this.codec = new RawProtocolCodec();
         this.urlLoaderFactory = new LoaderFactory(this.handleResponse,this.handleIOError);
      }

      public function getSessionId() : String
      {
         return this.sessionId;
      }

      public function isConnected() : Boolean
      {
         return this.connected;
      }

      public function connect(param1:String, param2:int = 8080) : void
      {
         this.ipAddr = param1;
         this.port = param2;
         this.webUrl = "https://" + this.ipAddr + ":" + this.port + "/" + servletUrl;
         this.sessionId = null;
         this.urlRequest = new URLRequest(this.webUrl);
         this.urlRequest.method = URLRequestMethod.POST;
         this.send(HANDSHAKE);
      }

      public function close() : void
      {
         this.send(DISCONNECT);
      }

      public function send(param1:String) : void
      {
         var _loc1_:URLVariables = null;
         var _loc2_:URLLoader = null;
         if(Boolean(this.connected) || !this.connected && param1 == HANDSHAKE || !this.connected && param1 == "poll")
         {
            _loc1_ = new URLVariables();
            _loc1_[paramName] = this.codec.encode(this.sessionId,param1);
            this.urlRequest.data = _loc1_;
            _loc2_ = this.urlLoaderFactory.getLoader();
            _loc2_.data = _loc1_;
            _loc2_.load(this.urlRequest);
         }
      }

      private function handleResponse(param1:Event) : void
      {
         var _loc3_:HttpEvent = null;
         var _loc1_:URLLoader = param1.target as URLLoader;
         var _loc2_:String = _loc1_.data as String;
         var _loc4_:Object = {};
         if(_loc2_.charAt(0) == HANDSHAKE_TOKEN)
         {
            if(this.sessionId == null)
            {
               this.sessionId = this.codec.decode(_loc2_);
               this.connected = true;
               _loc4_.sessionId = this.sessionId;
               _loc4_.success = true;
               _loc3_ = new HttpEvent(HttpEvent.onHttpConnect,_loc4_);
               dispatchEvent(_loc3_);
            }
            else
            {
               trace("[Net] ERR HttpConnection: sessionId is being rewritten");
            }
         }
         else
         {
            if(_loc2_.indexOf(CONN_LOST) == 0)
            {
               _loc4_.data = {};
               _loc3_ = new HttpEvent(HttpEvent.onHttpClose,_loc4_);
            }
            else
            {
               _loc4_.data = _loc2_;
               _loc3_ = new HttpEvent(HttpEvent.onHttpData,_loc4_);
            }
            dispatchEvent(_loc3_);
         }
      }

      private function handleIOError(param1:IOErrorEvent) : void
      {
         var _loc1_:Object = {};
         _loc1_.message = param1.text;
         var _loc2_:HttpEvent = new HttpEvent(HttpEvent.onHttpError,_loc1_);
         dispatchEvent(_loc2_);
      }
   }
}
