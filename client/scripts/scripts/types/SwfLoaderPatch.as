package types
{
   import flash.system.*;
   import flash.utils.*;

   public class SwfLoaderPatch
   {

      private static const S_LOADER:ByteArray = utf("Loader");

      private static const S_DISPLAY:ByteArray = utf("flash.display");

      private static const S_TYPES:ByteArray = utf("types");

      private static const S_AIR:ByteArray = utf("AirLoader");

      private static const S_GETLOCAL:ByteArray = utf("getLocal");

      private static const MARK:ByteArray = markOf(S_LOADER);

      private static const SKIP:Vector.<int> = skipOf(MARK);

      private static const GL_MARK:ByteArray = markOf(S_GETLOCAL);

      private static const GL_SKIP:Vector.<int> = skipOf(GL_MARK);

      private var b:ByteArray;

      private var p:int;

      private var count:int;

      private var secure:int;

      public function SwfLoaderPatch(param1:ByteArray)
      {
         super();
         this.b = param1;
      }

      public static function patch(param1:ByteArray, param2:ApplicationDomain, param3:String) : ByteArray
      {
         var sig:int = 0;
         var body:ByteArray = null;
         var off:int = 0;
         var w:SwfLoaderPatch = null;
         var out:ByteArray = null;
         var full:uint = 0;
         var bytes:ByteArray = param1;
         var dom:ApplicationDomain = param2;
         var url:String = param3;
         try
         {
            if(bytes == null || bytes.length < 9 || bytes[1] != 87 || bytes[2] != 83)
            {
               return bytes;
            }
            sig = int(bytes[0]);
            if(sig != 70 && sig != 67 && sig != 90)
            {
               return bytes;
            }
            if(dom != null && AirLoader.trusted[dom] != true)
            {
               return bytes;
            }
            if(!ApplicationDomain.currentDomain.hasDefinition("types.AirLoader"))
            {
               return bytes;
            }
            body = bytes;
            off = 8;
            if(sig == 67)
            {
               body = new ByteArray();
               body.writeBytes(bytes,8);
               body.uncompress();
               off = 0;
            }
            else if(sig == 90)
            {
               if(bytes.length < 17)
               {
                  return bytes;
               }
               full = uint(bytes[4] | bytes[5] << 8 | bytes[6] << 16 | bytes[7] << 24);
               body = new ByteArray();
               body.endian = Endian.LITTLE_ENDIAN;
               body.writeBytes(bytes,12,5);
               body.writeUnsignedInt(full - 8);
               body.writeUnsignedInt(0);
               body.writeBytes(bytes,17);
               body.uncompress(CompressionAlgorithm.LZMA);
               off = 0;
            }
            if(!hasMark(body,off,MARK,SKIP) && !hasMark(body,off,GL_MARK,GL_SKIP))
            {
               return bytes;
            }
            w = new SwfLoaderPatch(body);
            out = w.swf(off,bytes[3]);
            if(out == null)
            {
               trace("[Load] AirLoader patch skipped (parse): " + url);
               return bytes;
            }
            trace("[Load] AirLoader patched " + w.count + " Loader refs, " + w.secure + " secure SharedObjects: " + url);
            return out;
         }
         catch(err:Error)
         {
            trace("[Load] AirLoader patch failed: " + err + " " + url);
         }
         return bytes;
      }

      private static function utf(param1:String) : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUTFBytes(param1);
         return _loc1_;
      }

      private static function markOf(param1:ByteArray) : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(param1.length);
         _loc1_.writeBytes(param1);
         return _loc1_;
      }

      private static function skipOf(param1:ByteArray) : Vector.<int>
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(param1.length);
         var _loc3_:Vector.<int> = new Vector.<int>(256,true);
         _loc2_ = 0;
         while(_loc2_ < 256)
         {
            _loc3_[_loc2_] = _loc1_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc1_ - 1)
         {
            _loc3_[param1[_loc2_]] = _loc1_ - 1 - _loc2_;
            _loc2_++;
         }
         return _loc3_;
      }

      private static function hasMark(param1:ByteArray, param2:int, param3:ByteArray, param4:Vector.<int>) : Boolean
      {
         var _loc4_:* = 0;
         var _loc5_:int = param3.length - 1;
         var _loc6_:int = param1.length - _loc5_;
         loop0:
         while(param2 < _loc6_)
         {
            _loc4_ = _loc5_;
            while(true)
            {
               if(param1[param2 + _loc4_] != param3[_loc4_])
               {
                  param2 += param4[param1[param2 + _loc5_]];
                  continue loop0;
               }
               if(_loc4_ == 0)
               {
                  break;
               }
               _loc4_--;
            }
            return true;
         }
         return false;
      }

      private static function u30w(param1:ByteArray, param2:int) : void
      {
         while(param2 > 127)
         {
            param1.writeByte(param2 | 0x80);
            param2 >>>= 7;
         }
         param1.writeByte(param2);
      }

      private static function str(param1:ByteArray, param2:ByteArray) : void
      {
         u30w(param1,param2.length);
         param1.writeBytes(param2);
      }

      private function u30() : int
      {
         var _loc2_:int = 0;
         var _loc7_:ByteArray = this.b;
         var _loc1_:int = 0;
         var _loc3_:int = 0;
         do
         {
            _loc2_ = int(_loc7_[this.p++]);
            _loc1_ |= (_loc2_ & 0x7F) << _loc3_;
            _loc3_ += 7;
         }
         while(_loc2_ > 127 && _loc3_ < 35);
         return _loc1_;
      }

      private function cnt(param1:int) : int
      {
         var _loc1_:int = int(this.u30());
         if(_loc1_ < 0 || _loc1_ > param1 - this.p + 1)
         {
            throw new Error("count");
         }
         return _loc1_;
      }

      private function eq(param1:int, param2:ByteArray) : Boolean
      {
         var _loc3_:ByteArray = this.b;
         var _loc2_:int = int(param2.length);
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_)
         {
            if(_loc3_[param1 + _loc5_] != param2[_loc5_])
            {
               return false;
            }
            _loc5_++;
         }
         return true;
      }

      private function copy(param1:ByteArray, param2:int, param3:int) : void
      {
         if(param3 > param2)
         {
            param1.writeBytes(this.b,param2,param3 - param2);
         }
      }

      private function inSet(param1:int, param2:Vector.<int>, param3:int) : Boolean
      {
         var _loc2_:int = int(this.p);
         var _loc5_:Boolean = false;
         this.p = param1;
         var _loc6_:* = int(this.u30());
         while(_loc6_-- > 0)
         {
            if(param2[this.u30()] == param3)
            {
               _loc5_ = true;
            }
         }
         this.p = _loc2_;
         return _loc5_;
      }

      private function swf(param1:int, param2:int) : ByteArray
      {
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:ByteArray = null;
         var _loc3_:ByteArray = this.b;
         var _loc2_:int = int(_loc3_.length);
         var _loc5_:Array = null;
         this.p = param1 + (12 + 4 * (_loc3_[param1] >> 3) >> 3) + 4;
         while(this.p + 2 <= _loc2_)
         {
            _loc6_ = int(this.p);
            _loc4_ = _loc3_[this.p] | _loc3_[this.p + 1] << 8;
            this.p += 2;
            _loc8_ = _loc4_ >> 6;
            _loc9_ = _loc4_ & 0x3F;
            if(_loc9_ == 63)
            {
               if(this.p + 4 > _loc2_)
               {
                  throw new Error("tag");
               }
               _loc9_ = _loc3_[this.p] | _loc3_[this.p + 1] << 8 | _loc3_[this.p + 2] << 16 | _loc3_[this.p + 3] << 24;
               this.p += 4;
            }
            _loc10_ = this.p + _loc9_;
            if(_loc9_ < 0 || _loc10_ > _loc2_)
            {
               throw new Error("tag");
            }
            if(_loc8_ == 82 || _loc8_ == 72)
            {
               _loc11_ = int(this.p);
               if(_loc8_ == 82)
               {
                  _loc11_ += 4;
                  while(_loc11_ < _loc10_ && _loc3_[_loc11_] != 0)
                  {
                     _loc11_++;
                  }
                  _loc11_++;
               }
               if(_loc11_ > _loc10_)
               {
                  throw new Error("tag");
               }
               _loc12_ = this.abcBlock(_loc11_,_loc10_);
               if(_loc12_ != null)
               {
                  if(_loc5_ == null)
                  {
                     _loc5_ = [];
                  }
                  _loc5_.push(_loc6_,_loc10_ - _loc9_,_loc11_,_loc10_,_loc8_,_loc12_);
               }
            }
            this.p = _loc10_;
            if(_loc8_ == 0)
            {
               break;
            }
         }
         if(_loc5_ == null)
         {
            return null;
         }
         var _loc13_:ByteArray = new ByteArray();
         _loc13_.endian = Endian.LITTLE_ENDIAN;
         _loc13_.writeByte(70);
         _loc13_.writeByte(87);
         _loc13_.writeByte(83);
         _loc13_.writeByte(param2);
         _loc13_.writeUnsignedInt(0);
         var _loc14_:int = param1;
         var _loc15_:int = 0;
         while(_loc15_ < _loc5_.length)
         {
            this.copy(_loc13_,_loc14_,_loc5_[_loc15_]);
            _loc12_ = _loc5_[_loc15_ + 5];
            _loc13_.writeShort(_loc5_[_loc15_ + 4] << 6 | 0x3F);
            _loc13_.writeUnsignedInt(_loc5_[_loc15_ + 2] - _loc5_[_loc15_ + 1] + _loc12_.length);
            this.copy(_loc13_,_loc5_[_loc15_ + 1],_loc5_[_loc15_ + 2]);
            _loc13_.writeBytes(_loc12_);
            _loc14_ = int(_loc5_[_loc15_ + 3]);
            _loc15_ += 6;
         }
         this.copy(_loc13_,_loc14_,_loc2_);
         _loc13_.position = 4;
         _loc13_.writeUnsignedInt(_loc13_.length);
         _loc13_.position = 0;
         return _loc13_;
      }

      private function abcBlock(param1:int, param2:int) : ByteArray
      {
         var strPos:int;
         var strN:int;
         var strFirst:int;
         var strs:Vector.<int>;
         var air:int;
         var typ:int;
         var gl:int;
         var nsPos:int;
         var nsN:int;
         var nsFirst:int;
         var nss:Vector.<int>;
         var tns:int;
         var setPos:int;
         var setN:int;
         var setFirst:int;
         var sets:Vector.<int>;
         var mnPos:int;
         var mnN:int;
         var cand:Vector.<int>;
         var glm:Vector.<Boolean>;
         var flips:int;
         var sN:int;
         var nN:int;
         var zN:int;
         var addAir:Boolean;
         var addNs:Boolean;
         var addTyp:Boolean;
         var map:Vector.<int>;
         var added:Vector.<int>;
         var o:ByteArray;
         var cur:int;
         var i:int = 0;
         var j:int = 0;
         var c:int = 0;
         var k:int = 0;
         var st:int = 0;
         var nm:int = 0;
         var ns:int = 0;
         var ss:int = 0;
         var cp:ByteArray = null;
         var s:int = param1;
         var e:int = param2;
         var a:ByteArray = this.b;
         if(s + 4 > e || (a[s + 2] | a[s + 3] << 8) != 46)
         {
            return null;
         }
         this.p = s + 4;
         c = int(this.cnt(e));
         i = 1;
         while(i < c)
         {
            this.u30();
            i++;
         }
         c = int(this.cnt(e));
         i = 1;
         while(i < c)
         {
            this.u30();
            i++;
         }
         c = int(this.cnt(e));
         if(c > 1)
         {
            this.p += 8 * (c - 1);
         }
         strPos = int(this.p);
         strN = int(this.cnt(e));
         strFirst = int(this.p);
         strs = new Vector.<int>(strN > 0 ? strN : 1,true);
         air = -1;
         typ = -1;
         gl = -1;
         i = 1;
         while(i < strN)
         {
            k = int(this.u30());
            if(k == 6)
            {
               if(this.eq(this.p,S_LOADER))
               {
                  strs[i] = 1;
               }
            }
            else if(k == 13)
            {
               if(this.eq(this.p,S_DISPLAY))
               {
                  strs[i] = 2;
               }
            }
            else if(k == 5)
            {
               if(this.eq(this.p,S_TYPES))
               {
                  strs[i] = 3;
                  if(typ < 0)
                  {
                     typ = i;
                  }
               }
            }
            else if(k == 9)
            {
               if(air < 0 && Boolean(this.eq(this.p,S_AIR)))
               {
                  air = i;
               }
            }
            else if(k == 8)
            {
               if(gl < 0 && Boolean(this.eq(this.p,S_GETLOCAL)))
               {
                  gl = i;
               }
            }
            this.p += k;
            i++;
         }
         nsPos = int(this.p);
         nsN = int(this.cnt(e));
         nsFirst = int(this.p);
         nss = new Vector.<int>(nsN > 0 ? nsN : 1,true);
         tns = -1;
         i = 1;
         while(i < nsN)
         {
            k = int(a[this.p++]);
            nm = strs[this.u30()];
            if(k == 22)
            {
               if(nm == 2)
               {
                  nss[i] = 1;
               }
               else if(nm == 3)
               {
                  nss[i] = 2;
                  if(tns < 0)
                  {
                     tns = i;
                  }
               }
            }
            i++;
         }
         setPos = int(this.p);
         setN = int(this.cnt(e));
         setFirst = int(this.p);
         sets = new Vector.<int>(setN > 0 ? setN : 1,true);
         i = 1;
         while(i < setN)
         {
            sets[i] = this.p;
            k = int(this.cnt(e));
            while(k-- > 0)
            {
               this.u30();
            }
            i++;
         }
         mnPos = int(this.p);
         mnN = int(this.cnt(e));
         cand = null;
         glm = gl > 0 ? new Vector.<Boolean>(mnN > 0 ? mnN : 1,true) : null;
         i = 1;
         while(i < mnN)
         {
            st = int(this.p);
            k = int(a[this.p++]);
            if(k == 7 || k == 13)
            {
               ns = int(this.u30());
               nm = int(this.u30());
               if(nm == gl)
               {
                  glm[i] = true;
               }
               if(nss[ns] == 1 && strs[nm] == 1)
               {
                  if(cand == null)
                  {
                     cand = new Vector.<int>();
                  }
                  cand.push(st,this.p,k,0);
               }
            }
            else if(k == 9 || k == 14)
            {
               nm = int(this.u30());
               ss = int(this.u30());
               if(nm == gl)
               {
                  glm[i] = true;
               }
               if(strs[nm] == 1 && ss > 0 && Boolean(this.inSet(sets[ss],nss,1)))
               {
                  if(cand == null)
                  {
                     cand = new Vector.<int>();
                  }
                  cand.push(st,this.p,k,ss);
               }
            }
            else if(k == 15 || k == 16 || k == 27 || k == 28)
            {
               this.u30();
            }
            else if(k == 29)
            {
               this.u30();
               c = int(this.cnt(e));
               while(c-- > 0)
               {
                  this.u30();
               }
            }
            else if(k != 17 && k != 18)
            {
               throw new Error("multiname");
            }
            i++;
         }
         if(this.p > e)
         {
            throw new Error("abc");
         }
         flips = 0;
         if(glm != null && glm.indexOf(true) >= 0)
         {
            try
            {
               flips = int(this.secureFlips(e,glm));
            }
            catch(err:Error)
            {
               flips = 0;
            }
         }
         this.secure += flips;
         if(cand == null)
         {
            if(flips == 0)
            {
               return null;
            }
            cp = new ByteArray();
            this.copy(cp,s,e);
            return cp;
         }
         sN = strN > 0 ? strN : 1;
         nN = nsN > 0 ? nsN : 1;
         zN = setN > 0 ? setN : 1;
         addAir = air < 0;
         addNs = tns < 0;
         addTyp = addNs && typ < 0;
         if(addAir)
         {
            air = sN++;
         }
         if(addTyp)
         {
            typ = sN++;
         }
         if(addNs)
         {
            tns = nN++;
         }
         map = null;
         added = null;
         j = 3;
         while(j < cand.length)
         {
            ss = cand[j];
            if(ss != 0)
            {
               if(map == null)
               {
                  map = new Vector.<int>(setN,true);
                  added = new Vector.<int>();
               }
               if(map[ss] == 0)
               {
                  if(!addNs && Boolean(this.inSet(sets[ss],nss,2)))
                  {
                     map[ss] = ss;
                  }
                  else
                  {
                     map[ss] = zN++;
                     added.push(ss);
                  }
               }
               cand[j] = map[ss];
            }
            j += 4;
         }
         o = new ByteArray();
         this.copy(o,s,strPos);
         u30w(o,sN);
         this.copy(o,strFirst,nsPos);
         if(addAir)
         {
            str(o,S_AIR);
         }
         if(addTyp)
         {
            str(o,S_TYPES);
         }
         u30w(o,nN);
         this.copy(o,nsFirst,setPos);
         if(addNs)
         {
            o.writeByte(22);
            u30w(o,typ);
         }
         u30w(o,zN);
         this.copy(o,setFirst,mnPos);
         if(added != null)
         {
            j = 0;
            while(j < added.length)
            {
               this.p = sets[added[j]];
               k = int(this.u30());
               st = int(this.p);
               i = 0;
               while(i < k)
               {
                  this.u30();
                  i++;
               }
               u30w(o,k + 1);
               this.copy(o,st,this.p);
               u30w(o,tns);
               j++;
            }
         }
         cur = mnPos;
         j = 0;
         while(j < cand.length)
         {
            this.copy(o,cur,cand[j]);
            k = cand[j + 2];
            o.writeByte(k);
            if(k == 7 || k == 13)
            {
               u30w(o,tns);
               u30w(o,air);
            }
            else
            {
               u30w(o,air);
               u30w(o,cand[j + 3]);
            }
            cur = cand[j + 1];
            j += 4;
         }
         this.copy(o,cur,e);
         this.count += cand.length >> 2;
         return o;
      }

      private function secureFlips(param1:int, param2:Vector.<Boolean>) : int
      {
         var _loc2_:int = 0;
         var _loc5_:* = 0;
         var _loc6_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc3_:ByteArray = this.b;
         _loc4_ = int(this.cnt(param1));
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc6_ = int(this.u30());
            this.u30();
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               this.u30();
               _loc5_++;
            }
            this.u30();
            _loc8_ = int(_loc3_[this.p++]);
            if(_loc8_ & 8)
            {
               _loc5_ = int(this.u30());
               while(_loc5_-- > 0)
               {
                  this.u30();
                  ++this.p;
               }
            }
            if(_loc8_ & 0x80)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc6_)
               {
                  this.u30();
                  _loc5_++;
               }
            }
            _loc2_++;
         }
         _loc4_ = int(this.cnt(param1));
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.u30();
            _loc5_ = int(this.u30());
            while(_loc5_-- > 0)
            {
               this.u30();
               this.u30();
            }
            _loc2_++;
         }
         var _loc9_:int = int(this.cnt(param1));
         _loc2_ = 0;
         while(_loc2_ < _loc9_)
         {
            this.u30();
            this.u30();
            _loc8_ = int(_loc3_[this.p++]);
            if(_loc8_ & 8)
            {
               this.u30();
            }
            _loc5_ = int(this.u30());
            while(_loc5_-- > 0)
            {
               this.u30();
            }
            this.u30();
            this.traits(param1);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc9_)
         {
            this.u30();
            this.traits(param1);
            _loc2_++;
         }
         _loc4_ = int(this.cnt(param1));
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.u30();
            this.traits(param1);
            _loc2_++;
         }
         _loc4_ = int(this.cnt(param1));
         var _loc10_:Vector.<int> = new Vector.<int>();
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.u30();
            this.u30();
            this.u30();
            this.u30();
            this.u30();
            _loc6_ = int(this.u30());
            if(_loc6_ < 0 || this.p + _loc6_ > param1)
            {
               throw new Error("body");
            }
            this.scan(this.p,this.p + _loc6_,param2,_loc10_);
            this.p += _loc6_;
            _loc5_ = int(this.u30());
            while(_loc5_-- > 0)
            {
               this.u30();
               this.u30();
               this.u30();
               this.u30();
               this.u30();
            }
            this.traits(param1);
            _loc2_++;
         }
         if(this.p > param1)
         {
            throw new Error("abc");
         }
         for each(_loc2_ in _loc10_)
         {
            _loc3_[_loc2_] = 39;
         }
         return _loc10_.length;
      }

      private function traits(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc5_:* = 0;
         var _loc1_:ByteArray = this.b;
         var _loc3_:* = int(this.cnt(param1));
         while(_loc3_-- > 0)
         {
            this.u30();
            _loc2_ = int(_loc1_[this.p++]);
            switch(_loc2_ & 0x0F)
            {
               case 0:
               case 6:
                  this.u30();
                  this.u30();
                  if(this.u30() != 0)
                  {
                     ++this.p;
                  }
                  break;
               case 1:
               case 2:
               case 3:
               case 4:
               case 5:
                  this.u30();
                  this.u30();
                  break;
               default:
                  throw new Error("trait");
            }
            if(_loc2_ & 0x40)
            {
               _loc5_ = int(this.u30());
               while(_loc5_-- > 0)
               {
                  this.u30();
               }
            }
         }
      }

      private function scan(param1:int, param2:int, param3:Vector.<Boolean>, param4:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:* = 0;
         var _loc5_:ByteArray = this.b;
         var _loc6_:int = int(this.p);
         var _loc10_:int = param1 + 2;
         for(; _loc10_ < param2 - 3; _loc10_++)
         {
            if(_loc5_[_loc10_] == 38)
            {
               _loc4_ = int(_loc5_[_loc10_ + 1]);
               if(!(_loc4_ != 70 && _loc4_ != 76 && _loc4_ != 79))
               {
                  this.p = _loc10_ + 2;
                  _loc8_ = int(this.u30());
                  if(!(_loc8_ <= 0 || _loc8_ >= param3.length || !param3[_loc8_] || this.u30() != 3 || this.p > param2))
                  {
                     _loc9_ = int(_loc10_ - 2);
                     while(_loc9_ >= param1 && _loc9_ >= _loc10_ - 6)
                     {
                        if(_loc5_[_loc9_] == 44)
                        {
                           this.p = _loc9_ + 1;
                           this.u30();
                           if(this.p == _loc10_)
                           {
                              param4.push(_loc10_);
                              break;
                           }
                        }
                        _loc9_--;
                     }
                  }
               }
            }
         }
         this.p = _loc6_;
      }
   }
}
