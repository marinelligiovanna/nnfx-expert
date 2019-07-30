//+------------------------------------------------------------------+
//|                                                 KalmanFilter.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

#include "./Indicator.mqh"
#include "../Enums.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class KalmanFilter : public Indicator {
public:
   KalmanFilter(const MqlParam &params[]) : Indicator("kalman-filter-indicator", CHART_INDICATOR, params) {
      _longBufferNum = 1;
      _shortBufferNum = 0;
   };
   
   ~KalmanFilter() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      long mode = getParamLong(0, 6);
      double K = getParamDouble(1, 1.0);
      double sharpness = getParamDouble(2, 1.0);
      long drawBegin = getParamLong(3, 500);
   
      return iCustom(symbol, 
                     0, 
                     _name, 
                     bufferNum, 
                     shift, 
                     mode, 
                     K, 
                     sharpness, 
                     drawBegin);
   };
   
};
