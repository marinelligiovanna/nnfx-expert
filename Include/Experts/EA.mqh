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
   
   ATR* _atr;
   Indicator* _confIndicator;
   Indicator* _secondConfIndicator;
   
public:
   EA(string settingsFileName);
   ~EA();
   
   void setIndicators();
};
  
EA::EA(string settingsFileName){
   _settings = Util::loadAlgorithmSettings(settingsFileName);
   
   _atr = Indicators::getInstance(_settings.atr);
   _confIndicator = Indicators::getInstance(_settings.confirmationIndicator);
   _secondConfIndicator = Indicators::getInstance(_settings.secondConfirmationIndicator);
}

EA::~EA() {
   

}
//+------------------------------------------------------------------+
