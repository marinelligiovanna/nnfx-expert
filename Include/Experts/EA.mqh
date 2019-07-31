//+------------------------------------------------------------------+
//|                                                           EA.mqh |
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
#include "../Indicators/Indicators.mqh"
#include "../Util.mqh"

class EA {
private:
   AlgorithmSettings _settings;
   string _symbol;
   Position _position;
   
   ATR* _atr;
   Indicator* _ci;
   Indicator* _ci2;
   
   double _atrVal;
   TradeSignal _ciSignal;
   TradeSignal _ci2Signal;
   TradeSignal _newSignal;
   
public:
   EA(string symbol, string settingsFileName);
   ~EA();
   
   void setIndicators(int shift);
   bool signalChanged(void);
   void sendNewOrder(void);
   
};
  
EA::EA(string symbol, string settingsFileName){
   _symbol = symbol;
   _settings = Util::loadAlgorithmSettings(settingsFileName);
   
   _atr = Indicators::getInstance(_settings.atr);
   _ci = Indicators::getInstance(_settings.ci);
   _ci2 = Indicators::getInstance(_settings.ci2);
   
}

void EA::setIndicators(int shift){
   _atrVal = _atr.getValue(_symbol, 0, shift);
   _ciSignal = _ci.getSignal(_symbol, shift);
   _ci2Signal = _ci2.getSignal(_symbol, shift);
   
   // Set the new trading signal according the indicators.
   if(_ciSignal != _ci2Signal)
      _newSignal = NEUTRAL;
   else
      _newSignal = _ciSignal;
   
}

bool EA::signalChanged(void){
   return _newSignal != _position.side;
}

EA::~EA() {
   
   delete(_atr);
   delete(_ci);
   delete(_ci2);

}
//+------------------------------------------------------------------+
