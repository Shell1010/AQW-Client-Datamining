package
{
   import flash.display.MovieClip;
   import flash.text.*;
   import flash.utils.getQualifiedClassName;

   public class worldMap extends MovieClip
   {

      public var rootClass:*;

      private var worldObject:Object;

      private var areaObject:Object;

      private var nodeObject:Object;

      private var cutsceneObject:Object;

      public function worldMap(param1:Object)
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Number = NaN;
         var _loc10_:String = null;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:* = undefined;
         var _loc16_:* = undefined;
         var _loc17_:* = undefined;
         var _loc18_:Object = null;
         var _loc19_:String = null;
         var _loc20_:* = undefined;
         var _loc21_:* = undefined;
         var _loc22_:* = undefined;
         var _loc23_:* = undefined;
         var _loc24_:* = undefined;
         var _loc25_:Array = null;
         var _loc26_:String = null;
         var _loc27_:String = null;
         var _loc28_:* = undefined;
         super();
         worldObject = param1;
         worldObject.areas = new Array();
         areaObject = new Object();
         nodeObject = new Object();
         cutsceneObject = new Object();
         var _loc29_:* = "m";
         for(_loc3_ in worldObject)
         {
            if(getQualifiedClassName(worldObject[_loc3_]) == "Object")
            {
               _loc2_ = _loc29_ + worldObject[_loc3_].regionID;
               worldObject.areas.push(_loc2_);
               areaObject[_loc2_] = new Object();
               areaObject[_loc2_] = worldObject[_loc3_];
               areaObject[_loc2_].mapTitle = worldObject[_loc3_].regionName;
               areaObject[_loc2_].nodes = new Array();
               for(_loc14_ in worldObject[_loc3_])
               {
                  if(getQualifiedClassName(worldObject[_loc3_][_loc14_]) == "Array" && _loc14_ != "nodes")
                  {
                     _loc15_ = 0;
                     while(_loc15_ < worldObject[_loc3_][_loc14_].length)
                     {
                        _loc1_ = String(worldObject[_loc3_][_loc14_][_loc15_].mapName).toLowerCase() + worldObject[_loc3_].regionID;
                        nodeObject[_loc1_] = new Object();
                        nodeObject[_loc1_] = worldObject[_loc3_][_loc14_][_loc15_];
                        nodeObject[_loc1_].area = String(_loc2_);
                        areaObject[_loc2_].nodes.push(_loc1_);
                        nodeObject[_loc1_].cuts = new Array();
                        for(_loc16_ in worldObject[_loc3_][_loc14_][_loc15_])
                        {
                           if(getQualifiedClassName(worldObject[_loc3_][_loc14_][_loc15_][_loc16_]) == "Array" && _loc16_ != "cuts")
                           {
                              _loc17_ = 0;
                              while(_loc17_ < worldObject[_loc3_][_loc14_][_loc15_][_loc16_].length)
                              {
                                 _loc18_ = worldObject[_loc3_][_loc14_][_loc15_][_loc16_][_loc17_];
                                 if(_loc18_.qsIndex == nodeObject[_loc1_].qsValue)
                                 {
                                    _loc19_ = _loc1_ + "c" + String(_loc17_);
                                    cutsceneObject[_loc19_] = new Object();
                                    cutsceneObject[_loc19_].node = _loc1_;
                                    cutsceneObject[_loc19_] = _loc18_;
                                    nodeObject[_loc1_].cuts.push(_loc19_);
                                 }
                                 _loc17_++;
                              }
                           }
                        }
                        _loc15_++;
                     }
                  }
               }
            }
         }
         _loc4_ = ",";
         _loc5_ = ":";
         for(_loc11_ in worldObject)
         {
            for(_loc20_ in worldObject[_loc11_])
            {
               if(_loc20_ == "description")
               {
                  _loc6_ = String(worldObject[_loc11_][_loc20_]);
                  _loc8_ = _loc6_.split(_loc4_);
                  _loc21_ = 0;
                  while(_loc21_ < _loc8_.length)
                  {
                     _loc7_ = _loc8_[_loc21_];
                     _loc9_ = _loc7_.indexOf(_loc5_);
                     if(_loc9_ > -1)
                     {
                        _loc10_ = _loc7_.slice(0,_loc9_);
                        worldObject[_loc11_][_loc10_] = _loc7_.slice(_loc9_ + 1,_loc7_.length);
                     }
                     else if(_loc7_ != "")
                     {
                        worldObject[_loc11_][_loc7_] = "";
                     }
                     _loc21_++;
                  }
                  _loc8_ = null;
               }
            }
         }
         for(_loc12_ in areaObject)
         {
            for(_loc22_ in areaObject[_loc12_])
            {
               if(_loc22_ == "strExtra")
               {
                  _loc6_ = String(areaObject[_loc12_][_loc22_]);
                  _loc8_ = _loc6_.split(_loc4_);
                  _loc23_ = 0;
                  while(_loc23_ < _loc8_.length)
                  {
                     _loc7_ = _loc8_[_loc23_];
                     _loc9_ = _loc7_.indexOf(_loc5_);
                     if(_loc9_ > -1)
                     {
                        _loc10_ = _loc7_.slice(0,_loc9_);
                        areaObject[_loc12_][_loc10_] = _loc7_.slice(_loc9_ + 1,_loc7_.length);
                     }
                     else if(_loc7_ != "")
                     {
                        areaObject[_loc12_][_loc7_] = "";
                     }
                     _loc23_++;
                  }
                  _loc8_ = null;
               }
            }
         }
         for(_loc13_ in nodeObject)
         {
            for(_loc24_ in nodeObject[_loc13_])
            {
               switch(_loc24_)
               {
                  case "minLevel":
                  case "maxLevel":
                  case "qsValue":
                  case "questMin":
                  case "questMax":
                     nodeObject[_loc13_][_loc24_] = Number(nodeObject[_loc13_][_loc24_]);
                     break;
                  case "bUpgrade":
                     if(typeof nodeObject[_loc13_][_loc24_] == "string")
                     {
                        if(nodeObject[_loc13_][_loc24_] == "False" || nodeObject[_loc13_][_loc24_] == "false")
                        {
                           nodeObject[_loc13_][_loc24_] = false;
                        }
                        else
                        {
                           nodeObject[_loc13_][_loc24_] = true;
                        }
                     }
                     break;
                  case "strExtra":
                     _loc6_ = String(nodeObject[_loc13_][_loc24_]);
                     _loc25_ = null;
                     _loc25_ = _loc6_.split(_loc4_);
                     _loc28_ = 0;
                     while(_loc28_ < _loc25_.length)
                     {
                        _loc26_ = _loc25_[_loc28_];
                        _loc9_ = _loc26_.indexOf(_loc5_);
                        if(_loc9_ > -1)
                        {
                           _loc27_ = _loc26_.slice(0,_loc9_);
                           nodeObject[_loc13_][_loc27_] = _loc26_.slice(_loc9_ + 1,_loc26_.length);
                        }
                        else if(_loc26_ != "")
                        {
                           nodeObject[_loc13_][_loc26_] = "";
                        }
                        _loc28_++;
                     }
               }
            }
         }
      }

      internal function get World() : Object
      {
         return worldObject;
      }

      internal function get Areas() : Object
      {
         return areaObject;
      }

      internal function get Nodes() : Object
      {
         return nodeObject;
      }

      internal function get Cutscenes() : Object
      {
         return cutsceneObject;
      }

      internal function specificArea(param1:String) : Object
      {
         if(areaObject[param1] != null)
         {
            return areaObject[param1];
         }
         return null;
      }

      internal function getAreaNameByTitle(param1:String) : String
      {
         var _loc1_:* = undefined;
         for(_loc1_ in areaObject)
         {
            if(areaObject[_loc1_].mapTitle != undefined)
            {
               if(areaObject[_loc1_].mapTitle == param1)
               {
                  return _loc1_;
               }
            }
         }
         return null;
      }

      internal function getAreaByTitle(param1:String) : Object
      {
         var _loc1_:* = undefined;
         for(_loc1_ in areaObject)
         {
            if(areaObject[_loc1_].mapTitle != undefined)
            {
               if(areaObject[_loc1_].mapTitle == param1)
               {
                  return areaObject[_loc1_];
               }
            }
         }
         return null;
      }

      internal function getAreaByLink(param1:String) : Object
      {
         var _loc1_:* = undefined;
         for(_loc1_ in areaObject)
         {
            if(areaObject[_loc1_].strLink != undefined)
            {
               if(areaObject[_loc1_].strLink == param1)
               {
                  return areaObject[_loc1_];
               }
            }
         }
         return null;
      }

      internal function specificNode(param1:String) : Object
      {
         if(nodeObject[param1] != null)
         {
            return nodeObject[param1];
         }
         return null;
      }

      internal function specificCutscene(param1:String) : Object
      {
         if(cutsceneObject[param1] != null)
         {
            return cutsceneObject[param1];
         }
         return null;
      }
   }
}
