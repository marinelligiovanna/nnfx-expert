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
class KalmanFilter : public Indicator
  {
private:

public:
   KalmanFilter() : Indicator("kalman-filter-indicator", CHART_INDICATOR){};
   ~KalmanFilter() {};
   
   double getValue(string symbol, int bufferNum, int shift){
      return iCustom(symbol, 0, _name, bufferNum, shift);
   }
   
  };
