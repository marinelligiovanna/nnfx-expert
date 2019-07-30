//+------------------------------------------------------------------+
//|                                                   Indicators.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property strict

#include "../Util.mqh"
#include "./Indicator.mqh"
#include "./ATR.mqh"
#include "./KalmanFilter.mqh"
#include "./KusKusStartlight.mqh"


class Indicators {

public:
   static Indicator* getInstance(IndicatorSettings& settings);

};

static Indicator* Indicators::getInstance(IndicatorSettings& settings){
   
   Indicator* indicator;
   
   if(settings.id == IND_ATR)
      indicator = new ATR(settings);
   else if (settings.id == IND_KALMAN_FILTER)
      indicator = new KalmanFilter(settings);
   else if (settings.id == IND_KUSKUS_STARLIGHT)
      indicator = new KusKusStartlight(settings);
   else
      indicator = new ATR(settings);
   
   return indicator;
   
}