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
   KusKusStartlight(IndicatorSettings& settings) : Indicator(settings) {
      _bufferNum = 0;
   };
   ~KusKusStartlight() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      long rangePeriods = getParamLong("rangePeriods", 30);
      double priceSmoothing = getParamDouble("priceSmoothing", 0.3);
      double indexSmoothing = getParamDouble("indexSmoothing", 0.3);
      long drawType = getParamLong("drawType", 3);
      long drawSize = getParamLong("drawSize", 0);
   
      return iCustom(symbol, 
                     0, 
                     _settings.name, 
                     bufferNum, 
                     shift,
                     rangePeriods,
                     priceSmoothing,
                     indexSmoothing,
                     drawType,
                     drawSize);
   }
   
  };