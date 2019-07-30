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

struct AlgorithmSettings {
   IndicatorSettings atr;
   IndicatorSettings confirmationIndicator;
   IndicatorSettings secondConfirmationIndicator;
};
