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
       // @description RPG implementation of a LinkedList
       //***********************************************************************
       dcl-pr listNew pointer extproc('LISTNEW') end-pr;

       dcl-pr listDispose extproc('LISTDISPOSE');
         listPtr pointer;
       end-pr;

       dcl-pr listClear extproc('LISTCLEAR');
         listPtr pointer const;
       end-pr;

       dcl-pr listSize uns(10) extproc('LISTSIZE');
         listPtr pointer const;
       end-pr;

       dcl-pr listIsEmpty ind extproc('LISTISEMPTY');
         listPtr pointer const;
       end-pr;

       dcl-pr listAdd extproc('LISTADD');
         listPtr pointer const;
         objectPtr pointer const;
         objectSize uns(10) const;
         index uns(10) const options(*nopass);
       end-pr;

       dcl-pr listAddNumber extproc('LISTADDNUMBER');
         listPtr pointer const;
         number packed(22:7) value;
         index uns(10) const options(*nopass);
       end-pr;

       dcl-pr listAddString extproc('LISTADDSTRING');
         listPtr pointer const;
         string varchar(32767) value;
         index uns(10) const options(*nopass);
       end-pr;

       dcl-pr listGet pointer extproc('LISTGET');
         listPtr pointer const;
         index uns(10) const;
       end-pr;

       dcl-pr listGetNumber packed(22:7) extproc('LISTGETNUMBER');
         listPtr pointer const;
         index uns(10) const;
       end-pr;

       dcl-pr listGetString varchar(32767) extproc('LISTGETSTRING');
         listPtr pointer const;
         index uns(10) const;
       end-pr;

       dcl-pr listSet extproc('LISTSET');
         listPtr pointer const;
         objectPtr pointer const;
         objectSize uns(10) const;
         index uns(10) const;
       end-pr;

       dcl-pr listSetNumber extproc('LISTSETNUMBER');
         listPtr pointer;
         number packed(22:7) value;
         index uns(10) const;
       end-pr;

       dcl-pr listSetString extproc('LISTSETSTRING');
         listPtr pointer const;
         string varchar(32767) value;
         index uns(10) const;
       end-pr;

       dcl-pr listRemove extproc('LISTREMOVE');
         listPtr pointer const;
         index uns(10) const;
       end-pr;

       dcl-pr listIterNext pointer extproc('LISTITERNEXT');
         listPtr pointer const;
       end-pr;

       dcl-pr listIterPrevious pointer extproc('LISTITERPREVIOUS');
         listPtr pointer const;
       end-pr;

       dcl-pr listIterCurrentIndex uns(10) extproc('LISTITERCURRENTINDEX');
         listPtr pointer const;
       end-pr;

       dcl-pr listIterReset extproc('LISTITERRESET');
         listPtr pointer const;
       end-pr;

