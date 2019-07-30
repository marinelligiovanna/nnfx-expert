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
   Indicator* _confIndicator;
   Indicator* _secondConfIndicator;
   
   double _atrVal;
   TradeSignal _confIndicatorSignal;
   TradeSignal _secondConfIndicatorSignal;
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
   _confIndicator = Indicators::getInstance(_settings.confirmationIndicator);
   _secondConfIndicator = Indicators::getInstance(_settings.secondConfirmationIndicator);
   
}

void EA::setIndicators(int shift){
   _atrVal = _atr.getValue(_symbol, 0, shift);
   _confIndicatorSignal = _confIndicator.getSignal(_symbol, shift);
   _secondConfIndicatorSignal = _secondConfIndicator.getSignal(_symbol, shift);
   
   // Set the new trading signal according the indicators.
   if(_confIndicatorSignal != _secondConfIndicatorSignal)
      _newSignal = NEUTRAL;
   else
      _newSignal = _confIndicatorSignal;
   
}

bool EA::signalChanged(void){
   return _newSignal != _position.side;
}

EA::~EA() {
   
   delete(_atr);
   delete(_confIndicator);
   delete(_secondConfIndicator);

}
//+------------------------------------------------------------------+
