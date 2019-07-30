//+------------------------------------------------------------------+
//|                                                    Indicator.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

#include "../Util.mqh"

class Indicator {

private:
   TradeSignal getChartIndicatorSignal(string symbol, int shift);
   TradeSignal getZeroCrossIndicatorSignal(string symbol, int shift);

protected:
   
   // Indicator attributes
   IndicatorSettings _settings;
   int _paramsSize;
   
   // Buffers to implement getSignal
   int _longBufferNum;
   int _shortBufferNum;
   int _bufferNum;
   
   // Methods to get value of parameters
   double getParamDouble(int index, double defaultValue);
   string getParamString(int index, string defaultValue);
   long getParamLong(int index, long defaultValue);
   
   double getParamDouble(string name, double defaultValue);
   string getParamString(string name, string defaultValue);
   long getParamLong(string name, long defaultValue);
  
public:
   Indicator(IndicatorSettings& settings);
   ~Indicator();
   
   virtual double getValue(string symbol, int bufferNum, int shift);
   virtual TradeSignal getSignal(string symbol, int shift);
};


Indicator::Indicator(IndicatorSettings& settings) {
   _settings = settings;
   _paramsSize = ArraySize(_settings.params);
}

/**
* Return the value of a parameter of type double. If the parameter has no value set,
* returns a defaultValue
*
* @param index The index on params array of the desired parameter.
* @param defaultValue The default value of the parameter in the case it is not found.
**/
double Indicator::getParamDouble(int index, double defaultValue = EMPTY_VALUE) {
   if(index > _paramsSize - 1) return defaultValue;
   
   double paramValue = defaultValue;
   Param param = _settings.params[index];
   
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
* Return the value of a parameter of type double. If the parameter has no value set,
* returns a defaultValue
*
* @param name The name of the desired parameter.
* @param defaultValue The default value of the parameter in the case it is not found.
**/
double Indicator::getParamDouble(string name, double defaultValue = EMPTY_VALUE){
   double paramValue = defaultValue;
   
   for(int i = 0; i < _paramsSize; i++){
      if(name == _settings.params[i].name)
         paramValue = _settings.params[i].double_value;
   }
   
   return paramValue == NULL || paramValue == EMPTY_VALUE ? defaultValue : paramValue;  
}

/**
* Return the value of a parameter of type string. If the parameter has no value set,
* returns a defaultValue
*
* @param index The index on params array of the desired parameter.
* @param defaultValue The default value of the parameter in the case it is not found.
**/
string Indicator::getParamString(int index, string defaultValue = NULL) {
   if(index > _paramsSize - 1) return defaultValue;
   
   string paramValue = defaultValue;
   Param param = _settings.params[index];
   
   if(param.type == TYPE_STRING)
      paramValue = param.string_value;
   else
      paramValue = defaultValue;
      
    return paramValue == NULL ? defaultValue : paramValue;   
}

/**
* Return the value of a parameter of type string. If the parameter has no value set,
* returns a defaultValue
*
* @param name The name of the desired parameter.
* @param defaultValue The default value of the parameter in the case it is not found.
**/
string Indicator::getParamString(string name,string defaultValue = NULL){
   string paramValue = defaultValue;
   
   for(int i = 0; i < _paramsSize; i++){
      if(name == _settings.params[i].name)
         paramValue = _settings.params[i].string_value;
   }
   
   return paramValue == NULL ? defaultValue : paramValue;   
}

/**
* Return the value of a parameter of type long. If the parameter has no value set,
* returns a defaultValue
*
* @param name The name of the desired parameter.
* @param defaultValue The default value of the parameter in the case it is not found.
**/
long Indicator::getParamLong(int index, long defaultValue = NULL) {
   if(index > _paramsSize - 1) return defaultValue;
   
   long paramValue = defaultValue;
   Param param = _settings.params[index];
   
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
* Return the value of a parameter of type long. If the parameter has no value set,
* returns a defaultValue
*
* @param name The name of the desired parameter.
* @param defaultValue The default value of the parameter in the case it is not found.
**/
long Indicator::getParamLong(string name,long defaultValue = NULL){
   
   long paramValue = defaultValue;
   for(int i = 0; i < _paramsSize; i++){
      if(name == _settings.params[i].name)
         paramValue = _settings.params[i].integer_value;
   }
   
   return paramValue == NULL || paramValue == EMPTY_VALUE ? defaultValue : paramValue;
}

/**
* Default implementation of getSignal function.
* Returns a trade signal according the trading rule of the indicator type.
*
* @param symbol The Symbol of the instrument.
* @param shift the shift in buffer to be considered when looking at indicator values.
**/
TradeSignal Indicator::getSignal(string symbol,int shift){
   
   if(_settings.type == CHART_INDICATOR) 
      return getChartIndicatorSignal(symbol, shift);
   else if(_settings.type == ZERO_LINE_CROSS) 
      return getZeroCrossIndicatorSignal(symbol, shift);
   else 
      return NEUTRAL;

}

/**
* Returns a trade signal for the Chart Indicator type.
*
* @param symbol The Symbol of the instrument.
* @param shift the shift in buffer to be considered when looking at indicator values.
**/
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

/**
* Returns a trade signal for the Zero Cross Indicator type.
*
* @param symbol The Symbol of the instrument.
* @param shift the shift in buffer to be considered when looking at indicator values.
**/
TradeSignal Indicator::getZeroCrossIndicatorSignal(string symbol,int shift){
   double indicatorVal = getValue(symbol, _bufferNum, shift);
      
   if(indicatorVal > 0.0) 
      return LONG;
   else if(indicatorVal < 0.0) 
      return SHORT;
   else
      return NEUTRAL;   
}

Indicator::~Indicator() {}

