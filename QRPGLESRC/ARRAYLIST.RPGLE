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
       // Original idea by Mihael Schmidt.
       // https://github.com/OSSILE
       //
       // @author Edoardo Luppi
       // @description RPG implementation of an ArrayList
       //***********************************************************************
       ctl-opt nomain option(*srcstmt) bnddir('QC2LE':'UTILS');

       dcl-c ARRAY_SIZE %size(arrayTpl);
       dcl-c ENTRY_SIZE %size(entryTpl);
       dcl-c DEFAULT_SIZE 16;

      /include qcopysrc,memcpy
      /include qcopysrc,quicksort
      /include qcopysrc,utils

       dcl-ds arrayTpl qualified template align;
         data pointer;
         size uns(10);
         allocatedSize uns(10);
         modCount uns(10);
         sortDirection ind;
       end-ds;

       dcl-ds entryTpl qualified template align;
         parentPtr pointer;
         objectPtr pointer;
         objectSize uns(10);
         reservedForAlignment char(12);
       end-ds;

       //***********************************************************************
       // arrayNew
       //***********************************************************************
       dcl-proc arrayNew export;

         dcl-pi *n pointer;
           initialSize uns(10) const options(*nopass);
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-s arrayPtr pointer inz(*null);
         dcl-s initialSize_ uns(10) inz;

         if (%parms > 0);
           initialSize_ = initialSize;
         else;
           initialSize_ = DEFAULT_SIZE;
         endif;

         allocSpace(arrayPtr:ARRAY_SIZE);
         allocSpace(array.data:ENTRY_SIZE * initialSize_);
         array.allocatedSize = initialSize_;
         array.size = 0;

         return arrayPtr;

       end-proc;

       //***********************************************************************
       // arrayDispose
       //***********************************************************************
       dcl-proc arrayDispose export;

         dcl-pi *n;
           arrayPtr pointer;
         end-pi;

         if (arrayPtr <> *null);
           arrayClear(arrayPtr);
           deallocSpace(arrayPtr);
         endif;

       end-proc;

       //***********************************************************************
       // arraySort
       //***********************************************************************
       dcl-proc arraySort export;

         dcl-pi *n;
           arrayPtr pointer;
           compareProcedure pointer(*proc) const;
           direction ind const options(*nopass);
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-s direction_ ind inz(*on);

         if (%parms > 2);
           direction_ = direction;
         endif;

         array.sortDirection = direction_;
         quickSort(array.data:array.size:ENTRY_SIZE:compareProcedure);

       end-proc;

       //***********************************************************************
       // arraySortNumbers
       //***********************************************************************
       dcl-proc arraySortNumbers export;

         dcl-pi *n;
           arrayPtr pointer;
           direction ind const options(*nopass);
         end-pi;

         arraySort(arrayPtr:%paddr(compareNumbers):direction);

       end-proc;

       //***********************************************************************
       // arraySortStrings
       //***********************************************************************
       dcl-proc arraySortStrings export;

         dcl-pi *n;
           arrayPtr pointer;
           direction ind const options(*nopass);
         end-pi;

         arraySort(arrayPtr:%paddr(compareStrings):direction);

       end-proc;

       //***********************************************************************
       // arrayTrimToSize
       //***********************************************************************
       dcl-proc arrayTrimToSize export;

         dcl-pi *n;
           arrayPtr pointer const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-s allocatedSize uns(10) inz;

         if (array.size = 0);
           deallocSpace(array.data);
         else;
           allocSpace(array.data:ENTRY_SIZE * array.size);
         endif;

         array.allocatedSize = array.size;

       end-proc;

       //***********************************************************************
       // arrayClear
       //***********************************************************************
       dcl-proc arrayClear export;

         dcl-pi *n;
           arrayPtr pointer const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s entryPtr pointer inz(*null);
         dcl-s i uns(10) inz;

         for i = 1 to array.size;
           disposeEntryObject(arrayPtr:i);
         endfor;

         deallocSpace(array.data);
         array.size = 0;
         array.allocatedSize = 0;

       end-proc;

       //***********************************************************************
       // arraySize
       //***********************************************************************
       dcl-proc arraySize export;

         dcl-pi *n uns(10);
           arrayPtr pointer const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);

         return array.size;

       end-proc;

       //***********************************************************************
       // arrayIsEmpty
       //***********************************************************************
       dcl-proc arrayIsEmpty export;

         dcl-pi *n ind;
           arrayPtr pointer const;
         end-pi;

         return arraySize(arrayPtr) = 0;

       end-proc;

       //***********************************************************************
       // arraySet
       //***********************************************************************
       dcl-proc arraySet export;

         dcl-pi *n;
           arrayPtr pointer;
           objectPtr pointer const;
           objectSize uns(10) const;
           index uns(10) const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s entryPtr pointer inz(*null);

         entryPtr = getEntry(arrayPtr:index);
         allocSpace(entry.objectPtr:objectSize);
         memcpy(entry.objectPtr:objectPtr:objectSize);

       end-proc;

       //***********************************************************************
       // arraySetNumber
       //***********************************************************************
       dcl-proc arraySetNumber export;

         dcl-pi *n;
           arrayPtr pointer;
           numberObject packed(22:7) value;
           index uns(10) const;
         end-pi;

         arraySet(arrayPtr:%addr(numberObject):%size(numberObject):index);

       end-proc;

       //***********************************************************************
       // arraySetString
       //***********************************************************************
       dcl-proc arraySetString export;

         dcl-pi *n;
           arrayPtr pointer;
           stringObject varchar(32767) value;
           index uns(10) const;
         end-pi;

         arraySet(arrayPtr:%addr(stringObject):%size(stringObject):index);

       end-proc;

       //***********************************************************************
       // arrayRemove
       //***********************************************************************
       dcl-proc arrayRemove export;

         dcl-pi *n;
           arrayPtr pointer;
           index uns(10) const;
           toIndex uns(10) const options(*nopass);
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-s toIndex_ uns(10) inz;
         dcl-s positions int(10) inz;

         if (%parms > 2);
           toIndex_ = toIndex;
         else;
           toIndex_ = index;
         endif;

         positions = %int(index) - %int(toIndex_) - 1;
         moveEntries(arrayPtr:toIndex_ + 1:positions);
         array.size += positions;

       end-proc;

       //***********************************************************************
       // arrayAddAll
       //***********************************************************************
       dcl-proc arrayAddAll export;

         dcl-pi *n;
           arrayPtr pointer;
           fromArrayPtr pointer const;
           index uns(10) const options(*nopass);
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-ds fromArray likeds(arrayTpl) based(fromArrayPtr);
         dcl-s index_ uns(10) inz;
         dcl-s fromArraySize uns(10) inz;

         array.allocatedSize += fromArray.allocatedSize;
         allocSpace(array.data:ENTRY_SIZE * array.allocatedSize);

         if (%parms > 2);
           index_ = index;
           moveEntries(arrayPtr:index_:fromArray.size);
         else;
           index_ = array.size + 1;
         endif;

         memcpy(
            array.data + (ENTRY_SIZE * (index_ - 1)):
            fromArray.data:
            ENTRY_SIZE * fromArray.size
         );

         array.size += fromArray.size;

       end-proc;

       //***********************************************************************
       // arrayAdd
       //***********************************************************************
       dcl-proc arrayAdd export;

         dcl-pi *n;
           arrayPtr pointer;
           objectPtr pointer const;
           objectSize uns(10) const;
           index uns(10) const options(*nopass);
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s entryPtr pointer inz(*null);
         dcl-s index_ uns(10) inz;
         dcl-s newSize uns(10) inz;

         newSize = array.size + 1;

         // Verifico se l'array e' in grado di contenere il nuovo elemento.
         // In caso lo ridimensiono.
         ensureCapacity(arrayPtr:newSize);

         if (%parms > 3);
           index_ = index;
         else;
           index_ = newSize;
         endif;

         // Verifico se devo inserire l'elemento nel "mezzo" dell'array, e in caso
         // traslo gli elementi che vengono dopo.
         if (index_ < newSize);
           moveEntries(arrayPtr:index_:1);
         endif;

         // Costruisco il nuovo elemento. A questo punto il dato dovrebbe essere nullo.
         entryPtr = getEntry(arrayPtr:index_);
         allocSpace(entry.objectPtr:objectSize);
         memcpy(entry.objectPtr:objectPtr:objectSize);
         entry.objectSize = objectSize;
         entry.parentPtr = arrayPtr;

         array.size = newSize;

       end-proc;

       //***********************************************************************
       // arrayAddNumber
       //***********************************************************************
       dcl-proc arrayAddNumber export;

         dcl-pi *n;
           arrayPtr pointer;
           numberObject packed(22:7) value;
           index uns(10) const options(*nopass);
         end-pi;

         if (%parms > 2);
           arrayAdd(arrayPtr:%addr(numberObject):%size(numberObject):index);
         else;
           arrayAdd(arrayPtr:%addr(numberObject):%size(numberObject));
         endif;

       end-proc;

       //***********************************************************************
       // arrayAddString
       //***********************************************************************
       dcl-proc arrayAddString export;

         dcl-pi *n;
           arrayPtr pointer;
           stringObject varchar(32767) value;
           index uns(10) const options(*nopass);
         end-pi;

         if (%parms > 2);
           arrayAdd(
              arrayPtr:
              %addr(stringObject:*data):
              %len(stringObject):
              index
           );
         else;
           arrayAdd(arrayPtr:%addr(stringObject:*data):%len(stringObject));
         endif;

       end-proc;

       //***********************************************************************
       // arrayGet
       //***********************************************************************
       dcl-proc arrayGet export;

         dcl-pi *n pointer;
           arrayPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s entryPtr pointer inz(*null);

         entryPtr = getEntry(arrayPtr:index);

         return entry.objectPtr;

       end-proc;

       //***********************************************************************
       // arrayGetNumber
       //***********************************************************************
       dcl-proc arrayGetNumber export;

         dcl-pi *n packed(22:7);
           arrayPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-s object packed(22:7) based(objectPtr);
         dcl-s objectPtr pointer inz(*null);

         objectPtr = arrayGet(arrayPtr:index);

         return object;

       end-proc;

       //***********************************************************************
       // arrayGetString
       //***********************************************************************
       dcl-proc arrayGetString export;

         dcl-pi *n varchar(32767);
           arrayPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s entryPtr pointer inz(*null);

         entryPtr = getEntry(arrayPtr:index);

         return %str(entry.objectPtr:entry.objectSize);

       end-proc;

       //***********************************************************************
       // getEntry
       //***********************************************************************
       dcl-proc getEntry;

         dcl-pi *n pointer;
           arrayPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);

         return array.data + (ENTRY_SIZE * (index - 1));

       end-proc;

       //***********************************************************************
       // disposeEntryObject
       //***********************************************************************
       dcl-proc disposeEntryObject;

         dcl-pi *n;
           arrayPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s entryPtr pointer inz(*null);

         entryPtr = getEntry(arrayPtr:index);

         if (entry.objectPtr <> *null);
           deallocSpace(entry.objectPtr);
         endif;

       end-proc;

       //***********************************************************************
       // moveEntries
       //    IMPORTANT: do not update the size of the array here!
       //***********************************************************************
       dcl-proc moveEntries;

         dcl-pi *n;
           arrayPtr pointer;
           startIndex uns(10) const;
           positions int(10) const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-ds entry likeds(entryTpl) based(entryPtr);
         dcl-s entryPtr pointer inz(*null);
         dcl-s tempPtr pointer inz(*null);
         dcl-s destinationIndex int(10) inz;
         dcl-s bytesToCopy uns(10) inz;
         dcl-s i uns(10) inz;

         // Calcolo l'indice di destinazione;
         destinationIndex = startIndex + positions;

         select;
           when (positions < 0);
             // Sto rimuovendo elementi.
             // Dealloco gli oggetti che non servono piu'.
             for i = destinationIndex to startIndex - 1;
               disposeEntryObject(arrayPtr:i);
             endfor;

             if (startIndex > array.size);
               // Ho gia' deallocato tutto e dato che sono gli elementi terminanti dell'array
               // quelli con cui ho lavorato, non devo fare altro.
               return;
             else;
               // Elimino (sovrascrivo) elementi all'interno dell'array.
               exsr copyBytes;
             endif;

             // Imposto a null i riferimenti non piu' utilizzabili.
             // Non dealloco perche' gli oggetti a cui puntano sono ancora utilizzati.
             for i = array.size downto array.size + positions + 1;
               entryPtr = getEntry(arrayPtr:i);
               entry.objectPtr = *null;
             endfor;
           when (positions > 0);
             // Inserisco nuovi elementi all'interno dell'array.
             exsr copyBytes;

             // Imposto a null i riferimenti non piu' utilizzabili.
             // Non dealloco perche' gli oggetti a cui puntano sono ancora utilizzati.
             for i = startIndex to destinationIndex - 1;
               entryPtr = getEntry(arrayPtr:i);
               entry.objectPtr = *null;
             endfor;
           other;
         endsl;

         //*********************************************************************
         // copyBytes
         //*********************************************************************
         begsr copyBytes;

           bytesToCopy = ENTRY_SIZE * (array.size - startIndex + 1);

           // Alloco uno spazio di memoria temporaneo per copiare gli elementi da spostare.
           allocSpace(tempPtr:bytesToCopy);
           memcpy(tempPtr:getEntry(arrayPtr:startIndex):bytesToCopy);

           // Copio l'area temporanea alla posizione desiderata.
           memcpy(
              getEntry(arrayPtr:destinationIndex):
              tempPtr:
              bytesToCopy
           );

           deallocSpace(tempPtr);

         endsr;

       end-proc;

       //***********************************************************************
       // ensureCapacity
       //***********************************************************************
       dcl-proc ensureCapacity;

         dcl-pi *n;
           arrayPtr pointer;
           elements uns(10) const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);
         dcl-s allocatedSize int(10) inz;

         allocatedSize = array.allocatedSize;

         if (elements <= allocatedSize);
           return;
         endif;

         dow (allocatedSize - elements < 0);
           allocatedSize += (allocatedSize / 2 * (1 + array.modCount / 10)) + 1;
           array.modCount += 1;
         enddo;

         array.allocatedSize = allocatedSize;
         allocSpace(array.data:ENTRY_SIZE * allocatedSize);

       end-proc;

       //***********************************************************************
       // compareNumbers
       //***********************************************************************
       dcl-proc compareNumbers;

         dcl-pi *n int(10);
           element1 likeds(entryTpl) const;
           element2 likeds(entryTpl) const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(element1.parentPtr);
         dcl-s number1 packed(22:7) based(element1.objectPtr);
         dcl-s number2 packed(22:7) based(element2.objectPtr);
         dcl-s result int(3) inz;

         if (number1 > number2);
           result = 1;
         elseif (number1 < number2);
           result = -1;
         endif;

         return getSortResult(result:array.sortDirection);

       end-proc;

       //***********************************************************************
       // compareString
       //***********************************************************************
       dcl-proc compareStrings;

         dcl-pi *n int(10);
           element1 likeds(entryTpl) const;
           element2 likeds(entryTpl) const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(element1.parentPtr);
         dcl-s string1 varchar(32767) inz;
         dcl-s string2 varchar(32767) inz;
         dcl-s result int(3) inz;

         string1 = %str(element1.objectPtr:element1.objectSize);
         string2 = %str(element2.objectPtr:element2.objectSize);

         if (string1 > string2);
           result = 1;
         elseif (string1 < string2);
           result = -1;
         endif;

         return getSortResult(result:array.sortDirection);

       end-proc;

       //***********************************************************************
       // getSortResult
       //***********************************************************************
       dcl-proc getSortResult;

         dcl-pi *n int(3);
           result int(3) const;
           direction ind const;
         end-pi;

         if (direction);
           return result;
         else;
           return -result;
         endif;

       end-proc;

       //***********************************************************************
       // rangeCheck
       //***********************************************************************
       dcl-proc rangeCheck;

         dcl-pi *n;
           arrayPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds array likeds(arrayTpl) based(arrayPtr);

         if (index < 1 or index > array.size + 1);
           throwError(
              'CPF9999':
              '*ESCAPE':
              'Index out of bounds exception: ' + %char(index)
           );
         endif;

       end-proc;

       //***********************************************************************
       // throwError
       //***********************************************************************
       dcl-proc throwError;

         dcl-pi *n;
           messageId char(7) const;
           messageType char(10) const;
           messageText char(250) const options(*varsize);
         end-pi;

         dcl-pr error extpgm('QMHSNDPM');
           messageId char(7) const;
           messageFile char(20) const;
           messageData char(32767) const options(*varsize);
           messageDataLength int(10) const;
           messageType char(10) const;
           stackEntry char(10) const;
           stackCount int(10) const;
           messageKey char(4);
           errorDs char(32767) options(*varsize);
         end-pr;

         dcl-ds errorDs qualified inz;
           bytesProvided int(10);
           bytesAvailable int(10);
         end-ds;

         dcl-s messageKey char(4) inz;

         error(
            messageId:
            'QCPFMSG   *LIBL':
            %trim(messageText):
            %len(%trim(messageText)):
            messageType:
            '*':
            0:
            messageKey:
            errorDs
         );

       end-proc;

