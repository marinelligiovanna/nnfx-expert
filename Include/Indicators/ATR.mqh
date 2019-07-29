//+------------------------------------------------------------------+
//|                                                          ATR.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

#include "./Indicator.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class ATR : public Indicator
  {
private:

public:
   ATR() : Indicator("ATR", CHART_INDICATOR){} ;
   ~ATR() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      return iATR(symbol, bufferNum, 14, shift); 
   }
  };
