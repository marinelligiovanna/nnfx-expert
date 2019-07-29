//+------------------------------------------------------------------+
//|                                                    Indicator.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

#include "./IndicatorType.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Indicator
  {
protected:
   string _name;
   IndicatorType _type;
public:
   Indicator(string name, IndicatorType type);
   ~Indicator();
   
   virtual double getValue(string symbol, int bufferNum, int shift);
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Indicator::Indicator(string name, IndicatorType type){
   _name = name;
   _type = type;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Indicator::~Indicator()
  {
  }
//+------------------------------------------------------------------+
