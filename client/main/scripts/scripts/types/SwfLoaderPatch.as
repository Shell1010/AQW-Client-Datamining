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
         var _loc1_:int = 0;
         var _loc2_:int = int(param1.length);
         var _loc3_:Vector.<int> = new Vector.<int>(256,true);
         _loc1_ = 0;
         while(_loc1_ < 256)
         {
            _loc3_[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc2_ - 1)
         {
            _loc3_[param1[_loc1_]] = _loc2_ - 1 - _loc1_;
            _loc1_++;
         }
         return _loc3_;
      }

      private static function hasMark(param1:ByteArray, param2:int, param3:ByteArray, param4:Vector.<int>) : Boolean
      {
         var _loc1_:* = 0;
         var _loc2_:int = param3.length - 1;
         var _loc3_:int = param1.length - _loc2_;
         loop0:
         while(param2 < _loc3_)
         {
            _loc1_ = _loc2_;
            while(true)
            {
               if(param1[param2 + _loc1_] != param3[_loc1_])
               {
                  param2 += param4[param1[param2 + _loc2_]];
                  continue loop0;
               }
               if(_loc1_ == 0)
               {
                  break;
               }
               _loc1_--;
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
         var _loc1_:int = 0;
         var _loc2_:ByteArray = this.b;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         do
         {
            _loc1_ = int(_loc2_[this.p++]);
            _loc3_ |= (_loc1_ & 0x7F) << _loc4_;
            _loc4_ += 7;
         }
         while(_loc1_ > 127 && _loc4_ < 35);
         return _loc3_;
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
         var _loc1_:ByteArray = this.b;
         var _loc2_:int = int(param2.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            if(_loc1_[param1 + _loc3_] != param2[_loc3_])
            {
               return false;
            }
            _loc3_++;
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
         var _loc1_:int = int(this.p);
         var _loc2_:Boolean = false;
         this.p = param1;
         var _loc3_:* = int(this.u30());
         while(_loc3_-- > 0)
         {
            if(param2[this.u30()] == param3)
            {
               _loc2_ = true;
            }
         }
         this.p = _loc1_;
         return _loc2_;
      }

      private function swf(param1:int, param2:int) : ByteArray
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:ByteArray = null;
         var _loc8_:ByteArray = this.b;
         var _loc9_:int = int(_loc8_.length);
         var _loc10_:Array = null;
         this.p = param1 + (12 + 4 * (_loc8_[param1] >> 3) >> 3) + 4;
         while(this.p + 2 <= _loc9_)
         {
            _loc1_ = int(this.p);
            _loc2_ = _loc8_[this.p] | _loc8_[this.p + 1] << 8;
            this.p += 2;
            _loc3_ = _loc2_ >> 6;
            _loc4_ = _loc2_ & 0x3F;
            if(_loc4_ == 63)
            {
               if(this.p + 4 > _loc9_)
               {
                  throw new Error("tag");
               }
               _loc4_ = _loc8_[this.p] | _loc8_[this.p + 1] << 8 | _loc8_[this.p + 2] << 16 | _loc8_[this.p + 3] << 24;
               this.p += 4;
            }
            _loc5_ = this.p + _loc4_;
            if(_loc4_ < 0 || _loc5_ > _loc9_)
            {
               throw new Error("tag");
            }
            if(_loc3_ == 82 || _loc3_ == 72)
            {
               _loc6_ = int(this.p);
               if(_loc3_ == 82)
               {
                  _loc6_ += 4;
                  while(_loc6_ < _loc5_ && _loc8_[_loc6_] != 0)
                  {
                     _loc6_++;
                  }
                  _loc6_++;
               }
               if(_loc6_ > _loc5_)
               {
                  throw new Error("tag");
               }
               _loc7_ = this.abcBlock(_loc6_,_loc5_);
               if(_loc7_ != null)
               {
                  if(_loc10_ == null)
                  {
                     _loc10_ = [];
                  }
                  _loc10_.push(_loc1_,_loc5_ - _loc4_,_loc6_,_loc5_,_loc3_,_loc7_);
               }
            }
            this.p = _loc5_;
            if(_loc3_ == 0)
            {
               break;
            }
         }
         if(_loc10_ == null)
         {
            return null;
         }
         var _loc11_:ByteArray = new ByteArray();
         _loc11_.endian = Endian.LITTLE_ENDIAN;
         _loc11_.writeByte(70);
         _loc11_.writeByte(87);
         _loc11_.writeByte(83);
         _loc11_.writeByte(param2);
         _loc11_.writeUnsignedInt(0);
         var _loc12_:int = param1;
         var _loc13_:int = 0;
         while(_loc13_ < _loc10_.length)
         {
            this.copy(_loc11_,_loc12_,_loc10_[_loc13_]);
            _loc7_ = _loc10_[_loc13_ + 5];
            _loc11_.writeShort(_loc10_[_loc13_ + 4] << 6 | 0x3F);
            _loc11_.writeUnsignedInt(_loc10_[_loc13_ + 2] - _loc10_[_loc13_ + 1] + _loc7_.length);
            this.copy(_loc11_,_loc10_[_loc13_ + 1],_loc10_[_loc13_ + 2]);
            _loc11_.writeBytes(_loc7_);
            _loc12_ = int(_loc10_[_loc13_ + 3]);
            _loc13_ += 6;
         }
         this.copy(_loc11_,_loc12_,_loc9_);
         _loc11_.position = 4;
         _loc11_.writeUnsignedInt(_loc11_.length);
         _loc11_.position = 0;
         return _loc11_;
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
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = this.b;
         _loc4_ = int(this.cnt(param1));
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            _loc3_ = int(this.u30());
            this.u30();
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.u30();
               _loc2_++;
            }
            this.u30();
            _loc5_ = int(_loc6_[this.p++]);
            if(_loc5_ & 8)
            {
               _loc2_ = int(this.u30());
               while(_loc2_-- > 0)
               {
                  this.u30();
                  ++this.p;
               }
            }
            if(_loc5_ & 0x80)
            {
               _loc2_ = 0;
               while(_loc2_ < _loc3_)
               {
                  this.u30();
                  _loc2_++;
               }
            }
            _loc1_++;
         }
         _loc4_ = int(this.cnt(param1));
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            this.u30();
            _loc2_ = int(this.u30());
            while(_loc2_-- > 0)
            {
               this.u30();
               this.u30();
            }
            _loc1_++;
         }
         var _loc7_:int = int(this.cnt(param1));
         _loc1_ = 0;
         while(_loc1_ < _loc7_)
         {
            this.u30();
            this.u30();
            _loc5_ = int(_loc6_[this.p++]);
            if(_loc5_ & 8)
            {
               this.u30();
            }
            _loc2_ = int(this.u30());
            while(_loc2_-- > 0)
            {
               this.u30();
            }
            this.u30();
            this.traits(param1);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < _loc7_)
         {
            this.u30();
            this.traits(param1);
            _loc1_++;
         }
         _loc4_ = int(this.cnt(param1));
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            this.u30();
            this.traits(param1);
            _loc1_++;
         }
         _loc4_ = int(this.cnt(param1));
         var _loc8_:Vector.<int> = new Vector.<int>();
         _loc1_ = 0;
         while(_loc1_ < _loc4_)
         {
            this.u30();
            this.u30();
            this.u30();
            this.u30();
            this.u30();
            _loc3_ = int(this.u30());
            if(_loc3_ < 0 || this.p + _loc3_ > param1)
            {
               throw new Error("body");
            }
            this.scan(this.p,this.p + _loc3_,param2,_loc8_);
            this.p += _loc3_;
            _loc2_ = int(this.u30());
            while(_loc2_-- > 0)
            {
               this.u30();
               this.u30();
               this.u30();
               this.u30();
               this.u30();
            }
            this.traits(param1);
            _loc1_++;
         }
         if(this.p > param1)
         {
            throw new Error("abc");
         }
         for each(_loc1_ in _loc8_)
         {
            _loc6_[_loc1_] = 39;
         }
         return _loc8_.length;
      }

      private function traits(param1:int) : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = 0;
         var _loc3_:ByteArray = this.b;
         var _loc4_:* = int(this.cnt(param1));
         while(_loc4_-- > 0)
         {
            this.u30();
            _loc1_ = int(_loc3_[this.p++]);
            switch(_loc1_ & 0x0F)
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
            if(_loc1_ & 0x40)
            {
               _loc2_ = int(this.u30());
               while(_loc2_-- > 0)
               {
                  this.u30();
               }
            }
         }
      }

      private function scan(param1:int, param2:int, param3:Vector.<Boolean>, param4:Vector.<int>) : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:* = 0;
         var _loc4_:ByteArray = this.b;
         var _loc5_:int = int(this.p);
         var _loc6_:int = param1 + 2;
         for(; _loc6_ < param2 - 3; _loc6_++)
         {
            if(_loc4_[_loc6_] == 38)
            {
               _loc1_ = int(_loc4_[_loc6_ + 1]);
               if(!(_loc1_ != 70 && _loc1_ != 76 && _loc1_ != 79))
               {
                  this.p = _loc6_ + 2;
                  _loc2_ = int(this.u30());
                  if(!(_loc2_ <= 0 || _loc2_ >= param3.length || !param3[_loc2_] || this.u30() != 3 || this.p > param2))
                  {
                     _loc3_ = int(_loc6_ - 2);
                     while(_loc3_ >= param1 && _loc3_ >= _loc6_ - 6)
                     {
                        if(_loc4_[_loc3_] == 44)
                        {
                           this.p = _loc3_ + 1;
                           this.u30();
                           if(this.p == _loc6_)
                           {
                              param4.push(_loc6_);
                              break;
                           }
                        }
                        _loc3_--;
                     }
                  }
               }
            }
         }
         this.p = _loc5_;
      }
   }
}
