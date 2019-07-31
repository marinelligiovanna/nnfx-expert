//+------------------------------------------------------------------+
//|                                                      Structs.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property strict

#include "./Enums.mqh"

struct Param {
   string name;
   ENUM_DATATYPE type;
   double double_value;
   long integer_value;
   string string_value;
};

struct IndicatorSettings {
   string name;
   IndicatorID id;
   IndicatorType type;
   Param params[];
};

/**
* Struct containing all the settings of an algorithm run.
* Those settings will be loaded according a preset file
* saved on Files folder of MQL4.
**/
struct AlgorithmSettings {
   double risk;
   double atr_sl_multiplier;
   double atr_tp_multiplier;
   
   IndicatorSettings atr; // ATR
   IndicatorSettings ci;  // Confirmation Indicator
   IndicatorSettings ci2; // Second Confirmation Indicator
   
   AlgorithmSettings(){
      risk = 0.02;
      atr_sl_multiplier = 1.5;
      atr_tp_multiplier = 1.0;
   }
};

struct Position {
   string symbol;
   double price;
   long qty;
   TradeSignal side;
   
   Position(){
      symbol = NULL;
      price = EMPTY_VALUE;
      qty = EMPTY_VALUE;
      side = NEUTRAL;
   };
};