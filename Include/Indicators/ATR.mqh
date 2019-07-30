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
   ATR(IndicatorSettings& settings) : Indicator(settings){} ;
   ~ATR() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      int atrPeriod = (int) getParamLong(0);
      return iATR(symbol, bufferNum, atrPeriod, shift); 
   }
  };
