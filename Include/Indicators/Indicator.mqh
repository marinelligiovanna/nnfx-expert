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
class Indicator {

private:
   TradeSignal getChartIndicatorSignal(string symbol, int shift);
   TradeSignal getZeroCrossIndicatorSignal(string symbol, int shift);

protected:
   
   // Indicator attributes
   string _name;
   IndicatorType _type;
   MqlParam _params[];
   int _paramsSize;
   
   // Buffers to implement getSignal
   int _longBufferNum;
   int _shortBufferNum;
   int _bufferNum;
   
   // Methods to get value of parameters
   double getParamDouble(int index, double defaultValue);
   string getParamString(int index, string defaultValue);
   long getParamLong(int index, long defaultValue);
  
public:
   Indicator(string name, IndicatorType type, const MqlParam &params[]);
   ~Indicator();
   
   virtual double getValue(string symbol, int bufferNum, int shift);
   virtual TradeSignal getSignal(string symbol, int shift);
};


Indicator::Indicator(string name, IndicatorType type, const MqlParam &params[]) {
   _name = name;
   _type = type;
   
   // Copy params to a protected variable. 
   _paramsSize = ArraySize(params);
   ArrayResize(_params, _paramsSize);
   
   for(int i = 0; i < _paramsSize; i++){
      _params[i] = params[i];
   }
}

/**
* Return the value of a parameter of type double. If the parameter has no value set,
* returns a defaultValue
**/
double Indicator::getParamDouble(int index, double defaultValue = EMPTY_VALUE) {
   if(index > _paramsSize - 1) return defaultValue;
   
   double paramValue = defaultValue;
   MqlParam param = _params[index];
   
   switch(param.type){
      case TYPE_FLOAT:
      case TYPE_DOUBLE:
         paramValue = param.double_value;
      default:
         paramValue = defaultValue;
   };
   
   return paramValue == NULL || paramValue == EMPTY_VALUE ? defaultValue : paramValue;   
}

/**
* Return the value of a parameter of type string. If the parameter has no value set,
* returns a defaultValue
**/
string Indicator::getParamString(int index, string defaultValue = NULL) {
   if(index > _paramsSize - 1) return defaultValue;
   
   string paramValue = defaultValue;
   MqlParam param = _params[index];
   
   if(param.type == TYPE_STRING)
      paramValue = param.string_value;
   else
      paramValue = defaultValue;
      
    return paramValue == NULL ? defaultValue : paramValue;   
}

/**
* Return the value of a parameter of type long. If the parameter has no value set,
* returns a defaultValue
**/
long Indicator::getParamLong(int index, long defaultValue = NULL) {
   if(index > _paramsSize - 1) return defaultValue;
   
   long paramValue = defaultValue;
   MqlParam param = _params[index];
   
   switch(param.type){
      case TYPE_DOUBLE:
      case TYPE_FLOAT:
      case TYPE_STRING:
         paramValue = defaultValue;
      default:
         paramValue = param.integer_value;
   };
   
   return paramValue == NULL || paramValue == EMPTY_VALUE ? defaultValue : paramValue;
   
}

/**
* Default implementation of getSignal function.
* Returns a trade signal according the trading rule of the indicator type.
**/
TradeSignal Indicator::getSignal(string symbol,int shift){
   
   if(_type == CHART_INDICATOR) 
      return getChartIndicatorSignal(symbol, shift);
   else if(_type == ZERO_LINE_CROSS) 
      return getZeroCrossIndicatorSignal(symbol, shift);
   else 
      return NEUTRAL;

}

TradeSignal Indicator::getChartIndicatorSignal(string symbol,int shift){

   double longVal = getValue(symbol, _longBufferNum, shift);
   double shortVal = getValue(symbol, _shortBufferNum, shift);   
      
   if(longVal != EMPTY_VALUE && shortVal == EMPTY_VALUE) 
      return LONG;
   else if(longVal == EMPTY_VALUE && shortVal != EMPTY_VALUE) 
      return SHORT;
   else
      return NEUTRAL;

}

TradeSignal Indicator::getZeroCrossIndicatorSignal(string symbol,int shift){
   double indicatorVal = getValue(symbol, _bufferNum, shift);
      
   if(indicatorVal > 0.0) 
      return LONG;
   else if(indicatorVal < 0.0) 
      return SHORT;
   else
      return NEUTRAL;   
}

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Indicator::~Indicator() {

}
//+------------------------------------------------------------------+
