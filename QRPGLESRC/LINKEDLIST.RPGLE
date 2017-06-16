       //***********************************************************************
       // Un'implementazione di Linkedlist (tratto da Java) in ILE RPG.
       //
       // @author Edoardo Luppi
       //***********************************************************************
       ctl-opt nomain option(*srcstmt) bnddir('QC2LE':'UTILS');

       dcl-c LIST_SIZE %size(listTpl);
       dcl-c NODE_SIZE %size(nodeTpl);

      /include le/qcopysrc,memcpy
      /include le/qcopysrc,utils

       dcl-ds listTpl qualified template;
         firstNodePtr pointer;
         lastNodePtr pointer;
         size uns(10);
         currentNodePtr pointer;
         currentNodeIndex uns(10);
       end-ds;

       dcl-ds nodeTpl qualified template;
         objectPtr pointer;
         objectSize uns(10);
         previousNodePtr pointer;
         nextNodePtr pointer;
       end-ds;

       //***********************************************************************
       // listNew
       //***********************************************************************
       dcl-proc listNew export;

         dcl-pi *n pointer end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);
         dcl-s listPtr pointer inz(*null);

         allocSpace(listPtr:LIST_SIZE);
         list.firstNodePtr = *null;
         list.lastNodePtr = *null;
         list.size = 0;
         list.currentNodePtr = *null;
         list.currentNodeIndex = 0;

         return listPtr;

       end-proc;

       //***********************************************************************
       // listDispose
       //***********************************************************************
       dcl-proc listDispose export;

         dcl-pi *n;
           listPtr pointer;
         end-pi;

         if (listPtr <> *null);
           listClear(listPtr);
           dealloc(n) listPtr;
         endif;

       end-proc;

       //***********************************************************************
       // listClear
       //***********************************************************************
       dcl-proc listClear export;

         dcl-pi *n;
           listPtr pointer const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);
         dcl-ds node likeds(nodeTpl) based(nodePtr);
         dcl-s nodePtr pointer inz(*null);
         dcl-s nextNodePtr pointer inz(*null);

         nodePtr = list.firstNodePtr;

         dow (nodePtr <> *null);
           nextNodePtr = node.nextNodePtr;

           if (node.objectPtr <> *null);
             dealloc(n) node.objectPtr;
           endif;

           dealloc(n) nodePtr;
           nodePtr = nextNodePtr;
         enddo;

         list.firstNodePtr = *null;
         list.lastNodePtr = *null;
         list.size = 0;

       end-proc;

       //***********************************************************************
       // listSize;
       //***********************************************************************
       dcl-proc listSize export;

         dcl-pi *n uns(10);
           listPtr pointer const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);

         return list.size;

       end-proc;

       //***********************************************************************
       // listIsEmpty
       //***********************************************************************
       dcl-proc listIsEmpty export;

         dcl-pi *n ind;
           listPtr pointer const;
         end-pi;

         return listSize(listPtr) = 0;

       end-proc;

       //***********************************************************************
       // listAdd
       //***********************************************************************
       dcl-proc listAdd export;

         dcl-pi *n;
           listPtr pointer const;
           objectPtr pointer const;
           objectSize uns(10) const;
           index uns(10) const options(*nopass);
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);
         dcl-ds newNode likeds(nodeTpl) based(newNodePtr);
         dcl-ds previousNode likeds(nodeTpl) based(previousNodePtr);
         dcl-ds nextNode likeds(nodeTpl) based(nextNodePtr);
         dcl-s newNodePtr pointer inz(*null);
         dcl-s previousNodePtr pointer inz(*null);
         dcl-s nextNodePtr pointer inz(*null);
         dcl-s index_ uns(10) inz;

         if (%parms > 3);
           index_ = index;
         else;
           index_ = list.size + 1;
         endif;

         // Costruisco il nuovo nodo.
         allocSpace(newNodePtr:NODE_SIZE);
         allocSpace(newNode.objectPtr:objectSize);
         memcpy(newNode.objectPtr:objectPtr:objectSize);
         newNode.objectSize = objectSize;

         // Reperisco il nodo gia' presente in questa posizione, il quale
         // poi diventera' il nodo successivo.
         nextNodePtr = getNode(listPtr:index_);

         if (index_ = 1);
           list.firstNodePtr = newNodePtr;
         endif;

         if (nextNodePtr <> *null);
           // La posizione e' gia' occupata. Aggiorno i riferimenti tra i nodi.
           // Nuovo nodo.
           newNode.nextNodePtr = nextNodePtr;
           newNode.previousNodePtr = nextNode.previousNodePtr;
           previousNodePtr = nextNode.previousNodePtr;
           nextNode.previousNodePtr = newNodePtr;
         else;
           // Sto aggiungendo il nodo alla fine (che puo' essere anche l'inizio) della lista.
           newNode.previousNodePtr = list.lastNodePtr;
           previousNodePtr = list.lastNodePtr;
           list.lastNodePtr = newNodePtr;
         endif;

         if (previousNodePtr <> *null);
           previousNode.nextNodePtr = newNodePtr;
         endif;

         list.size += 1;

       end-proc;

       //***********************************************************************
       // listAddNumber
       //***********************************************************************
       dcl-proc listAddNumber export;

         dcl-pi *n;
           listPtr pointer const;
           number packed(22:7) value;
           index uns(10) options(*nopass);
         end-pi;

         if (%parms < 3);
           listAdd(listPtr:%addr(number):%size(number));
         else;
           listAdd(listPtr:%addr(number):%size(number):index);
         endif;

       end-proc;

       //***********************************************************************
       // listAddString
       //***********************************************************************
       dcl-proc listAddString export;

         dcl-pi *n;
           listPtr pointer const;
           string varchar(32767) value;
           index uns(10) options(*nopass);
         end-pi;

         if (%parms < 3);
           listAdd(listPtr:%addr(string:*data):%len(string));
         else;
           listAdd(listPtr:%addr(string:*data):%len(string):index);
         endif;

       end-proc;

       //***********************************************************************
       // listGet
       //***********************************************************************
       dcl-proc listGet export;

         dcl-pi *n pointer;
           listPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds node likeds(nodeTpl) based(nodePtr);
         dcl-s nodePtr pointer inz(*null);

         nodePtr = getNode(listPtr:index);

         return node.objectPtr;

       end-proc;

       //***********************************************************************
       // listGetNumber
       //***********************************************************************
       dcl-proc listGetNumber export;

         dcl-pi *n packed(22:7);
           listPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds node likeds(nodeTpl) based(nodePtr);
         dcl-s nodePtr pointer inz(*null);
         dcl-s number packed(22:7) based(node.objectPtr);

         nodePtr = getNode(listPtr:index);

         return number;

       end-proc;

       //***********************************************************************
       // listGetString
       //***********************************************************************
       dcl-proc listGetString export;

         dcl-pi *n varchar(32767);
           listPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds node likeds(nodeTpl) based(nodePtr);
         dcl-s nodePtr pointer inz(*null);

         nodePtr = getNode(listPtr:index);

         return %str(node.objectPtr:node.objectSize);

       end-proc;

       //***********************************************************************
       // listSet
       //***********************************************************************
       dcl-proc listSet export;

         dcl-pi *n;
           listPtr pointer const;
           objectPtr pointer const;
           objectSize uns(10) const;
           index uns(10) const;
         end-pi;

         dcl-ds node likeds(nodeTpl) based(nodePtr);
         dcl-s nodePtr pointer inz(*null);

         nodePtr = getNode(listPtr:index);
         allocSpace(node.objectPtr:objectSize);
         memcpy(node.objectPtr:objectPtr:objectSize);
         node.objectSize = objectSize;

       end-proc;

       //***********************************************************************
       // listSetNumber
       //***********************************************************************
       dcl-proc listSetNumber export;

         dcl-pi *n;
           listPtr pointer const;
           number packed(22:7) value;
           index uns(10) const;
         end-pi;

         listSet(listPtr:%addr(number):%size(number):index);

       end-proc;

       //***********************************************************************
       // listSetString
       //***********************************************************************
       dcl-proc listSetString export;

         dcl-pi *n;
           listPtr pointer const;
           string varchar(32767) value;
           index uns(10) const;
         end-pi;

         listSet(listPtr:%addr(string:*data):%len(string):index);

       end-proc;

       //***********************************************************************
       // listRemove
       //***********************************************************************
       dcl-proc listRemove export;

         dcl-pi *n;
           listPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);
         dcl-ds node likeds(nodeTpl) based(nodePtr);
         dcl-ds nextNode likeds(nodeTpl) based(nextNodePtr);
         dcl-ds previousNode likeds(nodeTpl) based(previousNodePtr);
         dcl-s nodePtr pointer inz(*null);
         dcl-s nextNodePtr pointer inz(*null);
         dcl-s previousNodePtr pointer inz(*null);

         nodePtr = getNode(listPtr:index);
         nextNodePtr = node.nextNodePtr;
         previousNodePtr = node.previousNodePtr;

         if (nextNodePtr <> *null);
           nextNode.previousNodePtr = previousNodePtr;
         else;
           // Era l'ultimo nodo della lista.
           list.lastNodePtr = previousNodePtr;
         endif;

         if (previousNodePtr <> *null);
           previousNode.nextNodePtr = nextNodePtr;
         else;
           // Era il primo nodo della lista.
           list.firstNodePtr = nextNodePtr;
         endif;

         dealloc(n) node.objectPtr;
         dealloc(n) nodePtr;
         list.size -= 1;

       end-proc;

       //***********************************************************************
       // listIterNext
       //***********************************************************************
       dcl-proc listIterNext export;

         dcl-pi *n pointer;
           listPtr pointer const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);
         dcl-ds node likeds(nodeTpl) based(nextNodePtr);
         dcl-s nextNodePtr pointer inz(*null);

         if (list.currentNodePtr <> *null);
           nextNodePtr = list.currentNodePtr;
           list.currentNodePtr = node.nextNodePtr;
           list.currentNodeIndex += 1;
         endif;

         return nextNodePtr;

       end-proc;

       //***********************************************************************
       // listIterPrevious
       //***********************************************************************
       dcl-proc listIterPrevious export;

         dcl-pi *n pointer;
           listPtr pointer const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);
         dcl-ds node likeds(nodeTpl) based(previousNodePtr);
         dcl-s previousNodePtr pointer inz(*null);

         if (list.currentNodePtr <> *null);
           previousNodePtr = list.currentNodePtr;
           list.currentNodePtr = node.previousNodePtr;
           list.currentNodeIndex -= 1;
         endif;

         return previousNodePtr;

       end-proc;

       //***********************************************************************
       // listIterCurrentIndex
       //***********************************************************************
       dcl-proc listIterCurrentIndex export;

         dcl-pi *n uns(10);
           listPtr pointer const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);

         return list.currentNodeIndex;

       end-proc;

       //***********************************************************************
       // listIterReset
       //***********************************************************************
       dcl-proc listIterReset export;

         dcl-pi *n;
           listPtr pointer const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);

         list.currentNodePtr = list.firstNodePtr;
         list.currentNodeIndex = 0;

       end-proc;

       //***********************************************************************
       // getNode
       //***********************************************************************
       dcl-proc getNode;

         dcl-pi *n pointer;
           listPtr pointer const;
           index uns(10) const;
         end-pi;

         dcl-ds list likeds(listTpl) based(listPtr);
         dcl-ds node likeds(nodeTpl) based(nodePtr);
         dcl-s nodePtr pointer inz(*null);
         dcl-s i uns(10) inz(1);

         if (list.size = 0 or index > list.size);
           return *null;
         endif;

         if (index < list.size / 2);
           nodePtr = list.firstNodePtr;

           dow (nodePtr <> *null and i < index);
             nodePtr = node.nextNodePtr;
             i += 1;
           enddo;
         else;
           nodePtr = list.lastNodePtr;
           i = list.size;

           dow (nodePtr <> *null and i > index);
             nodePtr = node.previousNodePtr;
             i -= 1;
           enddo;
         endif;

         return nodePtr;

       end-proc;

