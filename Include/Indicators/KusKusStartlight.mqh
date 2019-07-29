//+------------------------------------------------------------------+
//|                                             KusKusStartlight.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+

#include "./Indicator.mqh"

class KusKusStartlight : public Indicator
  {
private:

public:
   KusKusStartlight() : Indicator("kuskus-starlight-indicator", ZERO_LINE_CROSS) {};
   ~KusKusStartlight() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      return iCustom(symbol, 0, _name, bufferNum, shift);
   }
  };