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
       dcl-pr arrayNew pointer extproc('ARRAYNEW');
         initialSize uns(10) const options(*nopass);
       end-pr;

       dcl-pr arrayDispose extproc('ARRAYDISPOSE');
         arrayPtr pointer;
       end-pr;

       dcl-pr arraySort extproc('ARRAYSORT');
         arrayPtr pointer;
         compareProcedure pointer(*proc) const;
         direction ind const options(*nopass);
       end-pr;

       dcl-pr arraySortNumbers extproc('ARRAYSORTNUMBERS');
         arrayPtr pointer;
         direction ind const options(*nopass);
       end-pr;

       dcl-pr arraySortStrings extproc('ARRAYSORTSTRINGS');
         arrayPtr pointer;
         direction ind const options(*nopass);
       end-pr;

       dcl-pr arrayTrimToSize extproc('ARRAYTRIMTOSIZE');
         arrayPtr pointer const;
       end-pr;

       dcl-pr arrayClear extproc('ARRAYCLEAR');
         arrayPtr pointer const;
       end-pr;

       dcl-pr arraySize uns(10) extproc('ARRAYSIZE');
         arrayPtr pointer const;
       end-pr;

       dcl-pr arrayIsEmpty ind extproc('ARRAYISEMPTY');
         arrayPtr pointer const;
       end-pr;

       dcl-pr arraySet extproc('ARRAYSET');
         arrayPtr pointer;
         objectPtr pointer const;
         objectSize uns(10) const;
         index uns(10) const;
       end-pr;

       dcl-pr arraySetNumber extproc('ARRAYSETNUMBER');
         arrayPtr pointer;
         numberObject packed(22:7) value;
         index uns(10) const;
       end-pr;

       dcl-pr arraySetString extproc('ARRAYSETSTRING');
         arrayPtr pointer;
         stringObject varchar(32767) value;
         index uns(10) const;
       end-pr;

       dcl-pr arrayRemove extproc('ARRAYREMOVE');
         arrayPtr pointer;
         index uns(10) const;
         toIndex uns(10) const options(*nopass);
       end-pr;

       dcl-pr arrayAddAll extproc('ARRAYADDALL');
         arrayPtr pointer;
         fromArrayPtr pointer const;
         index uns(10) const options(*nopass);
       end-pr;

       dcl-pr arrayAdd extproc('ARRAYADD');
         arrayPtr pointer;
         objectPtr pointer const;
         objectSize uns(10) const;
         index uns(10) const options(*nopass);
       end-pr;

       dcl-pr arrayAddNumber extproc('ARRAYADDNUMBER');
         arrayPtr pointer;
         packedObject packed(22:7) value;
         index uns(10) const options(*nopass);
       end-pr;

       dcl-pr arrayAddString extproc('ARRAYADDSTRING');
         arrayPtr pointer;
         stringObject varchar(32767) value;
         index uns(10) const options(*nopass);
       end-pr;

       dcl-pr arrayGet pointer extproc('ARRAYGET');
         arrayPtr pointer const;
         index uns(10) const;
       end-pr;

       dcl-pr arrayGetNumber packed(22:7) extproc('ARRAYGETNUMBER');
         arrayPtr pointer const;
         index uns(10) const;
       end-pr;

       dcl-pr arrayGetString varchar(32767) extproc('ARRAYGETSTRING');
         arrayPtr pointer const;
         index uns(10) const;
       end-pr;

