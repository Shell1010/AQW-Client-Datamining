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
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:* = undefined;
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
            _loc2_ = param1 is Array ? "a" : "o";
            param2.xmlStr += "<obj t=\'" + _loc2_ + "\' o=\'" + param4 + "\'>" + this.eof;
         }
         for(_loc1_ in param1)
         {
            _loc3_ = typeof param1[_loc1_];
            _loc4_ = param1[_loc1_];
            if(_loc3_ == "boolean" || _loc3_ == "number" || _loc3_ == "string" || _loc3_ == "null")
            {
               if(_loc3_ == "boolean")
               {
                  _loc4_ = Number(_loc4_);
               }
               else if(_loc3_ == "null")
               {
                  _loc3_ = "x";
                  _loc4_ = "";
               }
               else if(_loc3_ == "string")
               {
                  _loc4_ = Entities.encodeEntities(_loc4_);
               }
               if(this.debug)
               {
                  param2.xmlStr += this.tabs.substr(0,param3 + 1);
               }
               param2.xmlStr += "<var n=\'" + _loc1_ + "\' t=\'" + _loc3_.substr(0,1) + "\'>" + _loc4_ + "</var>" + this.eof;
            }
            else if(_loc3_ == "object")
            {
               this.obj2xml(_loc4_,param2,param3 + 1,_loc1_);
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
         var _loc1_:String = null;
         var _loc2_:XML = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:int = 0;
         var _loc9_:XMLList = param1.children();
         for each(_loc2_ in _loc9_)
         {
            _loc1_ = _loc2_.name().toString();
            if(_loc1_ == "obj")
            {
               _loc3_ = _loc2_.@o;
               _loc4_ = _loc2_.@t;
               if(_loc4_ == "a")
               {
                  param2[_loc3_] = [];
               }
               else if(_loc4_ == "o")
               {
                  param2[_loc3_] = {};
               }
               this.xml2obj(_loc2_,param2[_loc3_]);
            }
            else if(_loc1_ == "var")
            {
               _loc5_ = _loc2_.@n;
               _loc6_ = _loc2_.@t;
               _loc7_ = _loc2_.toString();
               if(_loc6_ == "b")
               {
                  param2[_loc5_] = _loc7_ == "0" ? false : true;
               }
               else if(_loc6_ == "n")
               {
                  param2[_loc5_] = Number(_loc7_);
               }
               else if(_loc6_ == "s")
               {
                  param2[_loc5_] = _loc7_;
               }
               else if(_loc6_ == "x")
               {
                  param2[_loc5_] = null;
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
