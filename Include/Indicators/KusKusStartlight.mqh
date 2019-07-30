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

class KusKusStartlight : public Indicator {

public:
   KusKusStartlight(const MqlParam &params[]) : Indicator("kuskus-starlight-indicator", ZERO_LINE_CROSS, params) {
      _bufferNum = 0;
   };
   ~KusKusStartlight() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      long rangePeriods = getParamLong(0, 30);
      double priceSmoothing = getParamDouble(1, 0.3);
      double indexSmoothing = getParamDouble(2, 0.3);
      long drawType = getParamLong(3, 3);
      long drawSize = getParamLong(4, 0);
   
      return iCustom(symbol, 
                     0, 
                     _name, 
                     bufferNum, 
                     shift,
                     rangePeriods,
                     priceSmoothing,
                     indexSmoothing,
                     drawType,
                     drawSize);
   }
   
  };