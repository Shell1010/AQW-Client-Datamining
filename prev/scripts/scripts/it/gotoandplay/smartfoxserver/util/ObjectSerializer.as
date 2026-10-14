package it.gotoandplay.smartfoxserver.util
{
   public class ObjectSerializer
   {

      private static var instance:ObjectSerializer;

      private var debug:Boolean;

      private var eof:String;

      private var tabs:String;

      public function ObjectSerializer(param1:Boolean = false)
      {
         super();
         this.tabs = "\t\t\t\t\t\t\t\t\t\t\t\t\t";
         this.setDebug(param1);
      }

      public static function getInstance(param1:Boolean = false) : ObjectSerializer
      {
         if(instance == null)
         {
            instance = new ObjectSerializer(param1);
         }
         return instance;
      }

      private function setDebug(param1:Boolean) : void
      {
         this.debug = param1;
         if(this.debug)
         {
            this.eof = "\n";
         }
         else
         {
            this.eof = "";
         }
      }

      public function serialize(param1:Object) : String
      {
         var _loc1_:Object = {};
         this.obj2xml(param1,_loc1_);
         return _loc1_.xmlStr;
      }

      public function deserialize(param1:String) : Object
      {
         var _loc1_:XML = new XML(param1);
         var _loc2_:Object = {};
         this.xml2obj(_loc1_,_loc2_);
         return _loc2_;
      }

      private function obj2xml(param1:Object, param2:Object, param3:int = 0, param4:String = "") : void
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         if(param3 == 0)
         {
            param2.xmlStr = "<dataObj>" + this.eof;
         }
         else
         {
            if(this.debug)
            {
               param2.xmlStr += this.tabs.substr(0,param3);
            }
            _loc4_ = param1 is Array ? "a" : "o";
            param2.xmlStr += "<obj t=\'" + _loc4_ + "\' o=\'" + param4 + "\'>" + this.eof;
         }
         for(_loc3_ in param1)
         {
            _loc5_ = typeof param1[_loc3_];
            _loc6_ = param1[_loc3_];
            if(_loc5_ == "boolean" || _loc5_ == "number" || _loc5_ == "string" || _loc5_ == "null")
            {
               if(_loc5_ == "boolean")
               {
                  _loc6_ = Number(_loc6_);
               }
               else if(_loc5_ == "null")
               {
                  _loc5_ = "x";
                  _loc6_ = "";
               }
               else if(_loc5_ == "string")
               {
                  _loc6_ = Entities.encodeEntities(_loc6_);
               }
               if(this.debug)
               {
                  param2.xmlStr += this.tabs.substr(0,param3 + 1);
               }
               param2.xmlStr += "<var n=\'" + _loc3_ + "\' t=\'" + _loc5_.substr(0,1) + "\'>" + _loc6_ + "</var>" + this.eof;
            }
            else if(_loc5_ == "object")
            {
               this.obj2xml(_loc6_,param2,param3 + 1,_loc3_);
               if(this.debug)
               {
                  param2.xmlStr += this.tabs.substr(0,param3 + 1);
               }
               param2.xmlStr += "</obj>" + this.eof;
            }
         }
         if(param3 == 0)
         {
            param2.xmlStr += "</dataObj>" + this.eof;
         }
      }

      private function xml2obj(param1:XML, param2:Object) : void
      {
         var _loc3_:String = null;
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc2_:int = 0;
         var _loc10_:XMLList = param1.children();
         for each(_loc4_ in _loc10_)
         {
            _loc3_ = _loc4_.name().toString();
            if(_loc3_ == "obj")
            {
               _loc5_ = _loc4_.@o;
               _loc6_ = _loc4_.@t;
               if(_loc6_ == "a")
               {
                  param2[_loc5_] = [];
               }
               else if(_loc6_ == "o")
               {
                  param2[_loc5_] = {};
               }
               this.xml2obj(_loc4_,param2[_loc5_]);
            }
            else if(_loc3_ == "var")
            {
               _loc7_ = _loc4_.@n;
               _loc8_ = _loc4_.@t;
               _loc9_ = _loc4_.toString();
               if(_loc8_ == "b")
               {
                  param2[_loc7_] = _loc9_ == "0" ? false : true;
               }
               else if(_loc8_ == "n")
               {
                  param2[_loc7_] = Number(_loc9_);
               }
               else if(_loc8_ == "s")
               {
                  param2[_loc7_] = _loc9_;
               }
               else if(_loc8_ == "x")
               {
                  param2[_loc7_] = null;
               }
            }
         }
      }

      private function encodeEntities(param1:String) : String
      {
         return param1;
      }
   }
}
