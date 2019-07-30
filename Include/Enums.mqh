//+------------------------------------------------------------------+
//|                                                        Enums.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property strict

enum TradeSignal {
   LONG,
   SHORT,
   NEUTRAL
};


enum IndicatorType {
   TWO_LINES_CROSS,
   ZERO_LINE_CROSS,
   CHART_INDICATOR,
   NONE
};


enum IndicatorID {
   IND_DEFAULT,
   IND_ATR,
   IND_KALMAN_FILTER,
   IND_KUSKUS_STARLIGHT
};

enum PositionSide {
   POS_LONG=1,
   POS_SHORT=-1,
   POS_NEUTRAL=0
};