//+------------------------------------------------------------------+
//|                                                    Indicator.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

#include "../Enums.mqh"
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Indicator
  {
protected:
   string _name;
   IndicatorType _type;
   MqlParam _params[];
   int _paramsSize;
   
   double getParamDouble(int index, double defaultValue);
   string getParamString(int index, string defaultValue);
   long getParamLong(int index, long defaultValue);
  
public:
   Indicator(string name, IndicatorType type, const MqlParam &params[]);
   ~Indicator();
   
   virtual double getValue(string symbol, int bufferNum, int shift);
   virtual TradeSignal getSignal(string symbol, int shift);
};
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Indicator::Indicator(string name, IndicatorType type, const MqlParam &params[]){
   _name = name;
   _type = type;
   
   // Copy params to a protected variable. 
   _paramsSize = ArraySize(params);
   ArrayResize(_params, _paramsSize);
   
   for(int i = 0; i < _paramsSize; i++){
      _params[i] = params[i];
   }
}

double Indicator::getParamDouble(int index, double defaultValue = EMPTY_VALUE){
   if(index > _paramsSize - 1) return defaultValue;
   
   MqlParam param = _params[index];
   switch(param.type){
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
         return param.double_value;
      default:
         return defaultValue;
   };   
}

string Indicator::getParamString(int index, string defaultValue = NULL){
   if(index > _paramsSize - 1) return defaultValue;
   
   MqlParam param = _params[index];
   
   if(param.type == TYPE_STRING)
      return param.string_value;
   else
      return defaultValue;   
}

long Indicator::getParamLong(int index, long defaultValue = NULL){
   if(index > _paramsSize - 1) return defaultValue;
   
   MqlParam param = _params[index];
   
   switch(param.type){
      case TYPE_DOUBLE:
      case TYPE_FLOAT:
      case TYPE_STRING:
         return defaultValue;
      default:
         return param.integer_value;
   };
   
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Indicator::~Indicator()
  {
  }
//+------------------------------------------------------------------+
