       //***********************************************************************
       // MIT License
       //
       // Copyright (c) 2017 Edoardo Luppi
       //
       // Permission is hereby granted, free of charge, to any person obtaining a copy
       // of this software and associated documentation files (the "Software"), to deal
       // in the Software without restriction, including without limitation the rights
       // to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
       // copies of the Software, and to permit persons to whom the Software is
       // furnished to do so, subject to the following conditions:
       //
       // The above copyright notice and this permission notice shall be included in all
       // copies or substantial portions of the Software.
       //
       // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
       // IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
       // FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
       // AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
       // LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
       // OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
       // SOFTWARE.
       //
       // @author Edoardo Luppi
       // @description RPG implementation of an HashMap
       //***********************************************************************
       ctl-opt nomain option(*srcstmt) bnddir('QC2LE':'UTILS');

       dcl-c HASHMAP_SIZE %size(hashMapTpl);
       dcl-c BUCKET_SIZE %size(bucketTpl);
       dcl-c ENTRY_SIZE %size(entryTpl);
       dcl-c LOAD_FACTOR 0.72;

      /include le/qcopysrc,memcpy
      /include le/qcopysrc,utils

       dcl-ds hashMapTpl qualified template;
         bucketsPtr pointer;
         size uns(10);
         allocatedSize uns(10);
         loadFactor packed(3:2);
         threshold uns(10);
       end-ds;

       dcl-ds bucketTpl qualified template align;
         entryPtr pointer;
       end-ds;

       dcl-ds entryTpl qualified template align;
         nextEntryPtr pointer;
         keyPtr pointer;
         keySize uns(10);
         valuePtr pointer;
         valueSize uns(10);
         hashCode zoned(63);
         *n char(9);
       end-ds;

       //***********************************************************************
       // hashMapNew
       //***********************************************************************
       dcl-proc hashMapNew export;

         dcl-pi *n pointer;
           initialSize uns(10) const;
           loadFactor packed(3:2) const options(*nopass);
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);
         dcl-ds bucket likeds(bucketTpl) based(bucketPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s hashMapPtr pointer inz(*null);
         dcl-s bucketPtr pointer inz(*null);
         dcl-s entryPtr pointer inz(*null);
         dcl-s loadFactor_ packed(3:2) inz;
         dcl-s i uns(10) inz;

         if (%parms > 1);
           loadFactor_ = loadFactor;
         else;
           loadFactor_ = LOAD_FACTOR;
         endif;

         allocSpace(hashMapPtr:HASHMAP_SIZE);
         hashMap.size = 0;
         hashMap.allocatedSize = getNearestExpOf2(initialSize);
         hashMap.loadFactor = loadFactor_;
         hashMap.threshold = loadFactor_ * hashMap.allocatedSize;
         allocSpace(hashMap.bucketsPtr:BUCKET_SIZE * hashMap.allocatedSize);

         return hashMapPtr;

       end-proc;

       //***********************************************************************
       // hashMapDispose
       //***********************************************************************
       dcl-proc hashMapDispose export;

         dcl-pi *n;
           hashMapPtr pointer;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);

         if (hashMapPtr <> *null);
           hashMapClear(hashMapPtr);
           deallocSpace(hashMapPtr);
         endif;

       end-proc;

       //***********************************************************************
       // hashMapClear
       //***********************************************************************
       dcl-proc hashMapClear export;

         dcl-pi *n;
           hashMapPtr pointer const;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);
         dcl-ds bucket likeds(bucketTpl) based(bucketPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s bucketPtr pointer inz(*null);
         dcl-s entryPtr pointer inz(*null);
         dcl-s tempPtr pointer inz(*null);
         dcl-s i uns(10) inz;

         for i = 1 to hashMap.allocatedSize;
           bucketPtr = getBucket(hashMap.bucketsPtr:i);
           entryPtr = bucket.entryPtr;

           dow (entryPtr <> *null);
             tempPtr = entry.nextEntryPtr;
             disposeEntry(entryPtr);
             entryPtr = tempPtr;
           enddo;

           bucket.entryPtr = *null;
         endfor;

         hashMap.size = 0;

       end-proc;

       //***********************************************************************
       // hashMapSize
       //***********************************************************************
       dcl-proc hashMapSize export;

         dcl-pi *n uns(10);
           hashMapPtr pointer const;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);

         return hashMap.size;

       end-proc;

       //***********************************************************************
       // hashMapPut
       //***********************************************************************
       dcl-proc hashMapPut export;

         dcl-pi *n;
           hashMapPtr pointer const;
           keyPtr pointer const;
           keySize uns(10) const;
           valuePtr pointer const;
           valueSize uns(10) const;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);

         hashMap.size += 1;
         ensureCapacity(hashMapPtr:hashMap.size);
         addEntry(
            hashMap.bucketsPtr:
            hashMap.allocatedSize:
            getHashCode(keyPtr:keySize):
            keyPtr:
            keySize:
            valuePtr:
            valueSize
         );

       end-proc;

       //***********************************************************************
       // hashMapGet
       //***********************************************************************
       dcl-proc hashMapGet export;

         dcl-pi *n pointer;
           hashMapPtr pointer const;
           keyPtr pointer const;
           keySize uns(10) const;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);
         dcl-ds bucket likeds(bucketTpl) based(bucketPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s bucketPtr pointer inz(*null);
         dcl-s entryPtr pointer inz(*null);
         dcl-s hashCode zoned(63) inz;
         dcl-s bucketIndex uns(10) inz;

         hashCode = getHashCode(keyPtr:keySize);
         bucketIndex = getBucketIndex(hashCode:hashMap.allocatedSize);
         bucketPtr = getBucket(hashMap.bucketsPtr:bucketIndex);
         entryPtr = bucket.entryPtr;

         dow (entryPtr <> *null);
           if (entry.hashCode = hashCode);
             return entry.valuePtr;
           endif;

           entryPtr = entry.nextEntryPtr;
         enddo;

         return *null;

       end-proc;

       //***********************************************************************
       // hashMapContainsKey
       //***********************************************************************
       dcl-proc hashMapContainsKey export;

         dcl-pi *n ind;
           hashMapPtr pointer const;
           keyPtr pointer const;
           keySize uns(10) const;
         end-pi;

         return hashMapGet(hashMapPtr:keyPtr:keySize) <> *null;

       end-proc;

       //***********************************************************************
       // hashMapContainsValue
       //***********************************************************************
       dcl-proc hashMapContainsValue export;

         dcl-pi *n ind;
           hashMapPtr pointer const;
           valuePtr pointer const;
           valueSize uns(10) const;
         end-pi;

         // TODO

       end-proc;

       //***********************************************************************
       // hashMapRemove
       //***********************************************************************
       dcl-proc hashMapRemove export;

         dcl-pi *n;
           hashMapPtr pointer const;
           keyPtr pointer const;
           keySize uns(10) const;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);
         dcl-ds bucket likeds(bucketTpl) based(bucketPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s bucketPtr pointer inz(*null);
         dcl-s entryPtr pointer inz(*null);
         dcl-s hashCode zoned(63) inz;
         dcl-s bucketIndex uns(10) inz;

         hashCode = getHashCode(keyPtr:keySize);
         bucketIndex = getBucketIndex(hashCode:hashMap.allocatedSize);
         bucketPtr = getBucket(hashMap.bucketsPtr:bucketIndex);
         entryPtr = bucket.entryPtr;

         dow (entryPtr <> *null);
           if (entry.hashCode = hashCode);
             if (entryPtr = bucket.entryPtr);
               bucket.entryPtr = *null;
             endif;

             deallocSpace(entryPtr);
             hashMap.size -= 1;
             return;
           endif;

           entryPtr = entry.nextEntryPtr;
         enddo;

       end-proc;

       //***********************************************************************
       // getHashCode
       //***********************************************************************
       dcl-proc getHashCode;

         dcl-pi *n zoned(63);
           objectPtr pointer const;
           objectSize uns(10) const;
         end-pi;

         dcl-pr Qc3CalculateHash extproc('Qc3CalculateHash');
           inData pointer value;
           inDataSize int(10) const;
           inDataFormat char(8) const;
           algorithmDescription pointer value;
           algorithmFormat char(8) const;
           CryptographicServiceProvider char(1) const;
           CryptographicDeviceName char(10) const options(*omit);
           hash pointer value;
           apiError pointer value;
         end-pr;

         dcl-pr cvthc extproc('cvthc');
           target pointer value;
           source pointer value;
           sourceSize int(10) value;
         end-pr;

         dcl-pr cvtch extproc('cvtch');
           target pointer value;
           source pointer value;
           sourceSize int(10) value;
         end-pr;

         dcl-ds algd0500 qualified inz;
           hashingAlgorithm int(10) inz(HASH_SHA1);
         end-ds;

         dcl-ds apiError qualified inz;
           bytesProvided int(10);
           bytesAvailable int(10);
           exceptionId char(7);
           reserved char(1);
         end-ds;

         dcl-c HASH_MD5 1;
         dcl-c HASH_SHA1 2;
         dcl-c HASH_SHA256 3;
         dcl-c HASH_SHA384 4;
         dcl-c HASH_SHA512 5;
         dcl-c HEX_LENGTH %len(hex);
         dcl-c HEX_NUM_SIZE %size(hexNumber);

         dcl-s hash char(64) inz;
         dcl-s hex char(40) inz;
         dcl-s hexChar char(2) inz;
         dcl-s hexNumber int(3) inz;
         dcl-s integerValue zoned(63) inz;
         dcl-s incrementalValue zoned(63) inz;
         dcl-s i uns(3) inz;

         if (objectPtr = *null);
           return 1;
         endif;

         Qc3CalculateHash(
            objectPtr:
            objectSize:
            'DATA0100':
            %addr(algd0500):
            'ALGD0500':
            '0':
            *omit:
            %addr(hash):
            %addr(apiError)
         );

         cvthc(%addr(hex):%addr(hash):%len(hash) * 2);
         integerValue = 0;
         incrementalValue = 0;

         for i = HEX_LENGTH downto 1;
           hexChar = '0' + %subst(hex:HEX_LENGTH - i + 1:1);
           cvtch(%addr(hexNumber):%addr(hexChar):HEX_NUM_SIZE * 2);
           integerValue = (hexNumber * (16 ** (i - 1)));
           incrementalValue += integerValue;
         endfor;

         return incrementalValue;

       end-proc;

       //***********************************************************************
       // getBucketIndex
       //***********************************************************************
       dcl-proc getBucketIndex;

         dcl-pi *n uns(10);
           hashCode zoned(63) const;
           allocatedSize uns(10) const;
         end-pi;

         dcl-s index uns(10) inz;

         index = %rem(hashCode:allocatedSize);

         if (index = 0);
           index = 1;
         endif;

         return index;

       end-proc;

       //***********************************************************************
       // getBucket
       //***********************************************************************
       dcl-proc getBucket;

         dcl-pi *n pointer;
           bucketsPtr pointer const;
           index uns(10) const;
         end-pi;

         return bucketsPtr + (BUCKET_SIZE * (index - 1));

       end-proc;

       //***********************************************************************
       // getNearestExpOf2
       //***********************************************************************
       dcl-proc getNearestExpOf2;

         dcl-pi *n uns(10);
           number uns(10) const;
         end-pi;

         dcl-s newNumber uns(10) inz(1);

         dow (newNumber < number);
           newNumber *= 2;
         enddo;

         return newNumber;

       end-proc;

       //***********************************************************************
       // disposeEntry
       //***********************************************************************
       dcl-proc disposeEntry;

         dcl-pi *n;
           entryPtr pointer;
         end-pi;

         dcl-ds entry likeds(entryTpl) based(entryPtr);

         deallocSpace(entry.keyPtr);
         deallocSpace(entry.valuePtr);
         deallocSpace(entryPtr);

       end-proc;

       //***********************************************************************
       // ensureCapacity
       //***********************************************************************
       dcl-proc ensureCapacity;

         dcl-pi *n;
           hashMapPtr pointer const;
           size uns(10) const;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);

         if (size > hashMap.threshold);
           hashMap.allocatedSize *= 2;
           allocSpace(hashMap.bucketsPtr:BUCKET_SIZE * hashMap.allocatedSize);
           hashMap.threshold = hashMap.allocatedSize * hashMap.loadFactor;
           rebuild(hashMapPtr);
         endif;

       end-proc;

       //***********************************************************************
       // addEntry
       //***********************************************************************
       dcl-proc addEntry;

         dcl-pi *n;
           bucketsPtr pointer const;
           bucketsSize uns(10) const;
           hashCode zoned(63) const;
           keyPtr pointer const;
           keySize uns(10) const;
           valuePtr pointer const;
           valueSize uns(10) const;
         end-pi;

         dcl-ds bucket likeds(bucketTpl) based(bucketPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s bucketPtr pointer inz(*null);
         dcl-s entryPtr pointer inz(*null);
         dcl-s oldEntryPtr pointer inz(*null);
         dcl-s bucketIndex uns(10) inz;

         bucketIndex = getBucketIndex(hashCode:bucketsSize);
         bucketPtr = getBucket(bucketsPtr:bucketIndex);
         entryPtr = bucket.entryPtr;

         if (entryPtr = *null);
           allocSpace(entryPtr:ENTRY_SIZE);
           bucket.entryPtr = entryPtr;
         else;
           // Bucket gia' in uso.
           // Ciclo la lista di elementi gia' presenti, per cercare una eventuale corrispondenza.
           dow (entryPtr <> *null);
             if (entry.hashCode = hashCode);
               // Elemento gia' presente in questo bucket. Sovrascrivo il valore.
               allocSpace(entry.valuePtr:valueSize);
               memcpy(entry.valuePtr:valuePtr:valueSize);
               entry.valueSize = valueSize;
               return;
             endif;

             if (entry.nextEntryPtr = *null);
               leave;
             endif;

             entryPtr = entry.nextEntryPtr;
           enddo;

           // Elemento non presente nel bucket. Lo aggiungo in testa.
           // Copio il vecchio elemento iniziale, per poi referenziarlo come elemento successivo.
           allocSpace(oldEntryPtr:ENTRY_SIZE);
           memcpy(oldEntryPtr:entryPtr:ENTRY_SIZE);
           entry.keyPtr = *null;
           entry.valuePtr = *null;
         endif;

         allocSpace(entry.keyPtr:keySize);
         allocSpace(entry.valuePtr:valueSize);
         memcpy(entry.keyPtr:keyPtr:keySize);
         memcpy(entry.valuePtr:valuePtr:valueSize);
         entry.nextEntryPtr = oldEntryPtr;
         entry.keySize = keySize;
         entry.valueSize = valueSize;
         entry.hashCode = hashCode;

       end-proc;

       //***********************************************************************
       // rebuild
       //***********************************************************************
       dcl-proc rebuild;

         dcl-pi *n;
           hashMapPtr pointer const;
         end-pi;

         dcl-ds hashMap likeds(hashMapTpl) based(hashMapPtr);
         dcl-ds bucket likeds(bucketTpl) based(bucketPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s newBucketsPtr pointer inz(*null);
         dcl-s bucketPtr pointer inz(*null);
         dcl-s entryPtr pointer inz(*null);
         dcl-s i uns(10) inz;

         // Alloco un nuovo spazio dove sistemare gli elementi.
         allocSpace(newBucketsPtr:BUCKET_SIZE * hashMap.allocatedSize);

         for i = 1 to %int(hashMap.allocatedSize / 2);
           bucketPtr = getBucket(hashMap.bucketsPtr:i);
           entryPtr = bucket.entryPtr;

           dow (entryPtr <> *null);
             addEntry(
                newBucketsPtr:
                hashMap.allocatedSize:
                entry.hashCode:
                entry.keyPtr:
                entry.keySize:
                entry.valuePtr:
                entry.valueSize
             );

             entryPtr = entry.nextEntryPtr;
           enddo;
         endfor;

         hashMapClear(hashMapPtr);
         deallocSpace(hashMap.bucketsPtr);
         hashMap.bucketsPtr = newBucketsPtr;

       end-proc;

