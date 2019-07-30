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
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class KalmanFilter : public Indicator {
public:
   KalmanFilter(const Param &params[]) : Indicator("kalman-filter-indicator", CHART_INDICATOR, params) {
      _longBufferNum = 1;
      _shortBufferNum = 0;
   };
   
   ~KalmanFilter() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      long mode = getParamLong("mode", 6);
      double k = getParamDouble("k", 1.0);
      double sharpness = getParamDouble("sharpness", 1.0);
      long drawBegin = getParamLong("drawBegin", 500);
   
      return iCustom(symbol, 
                     0, 
                     _name, 
                     bufferNum, 
                     shift, 
                     mode, 
                     k, 
                     sharpness, 
                     drawBegin);
   };
   
};
