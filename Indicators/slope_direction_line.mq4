//+------------------------------------------------------------------+
//|                                         Slope Direction Line.mq4 |
//|                                               Yuriy Tokman (YTG) |
//|                                               http://ytg.com.ua/ |
//+------------------------------------------------------------------+
#property copyright "Yuriy Tokman (YTG)"
#property link      "http://ytg.com.ua/"
#property version   "1.00"
#property strict
#property indicator_chart_window
//---
#property indicator_chart_window
#property indicator_buffers 3 
#property indicator_color2 Red 
#property indicator_color3 Blue
#property indicator_width2 2
#property indicator_width3 2
//---
extern int       period        = 32;
extern double FilterNumber     = 2;
extern int       ma_method     = 3;
extern int       applied_price = 0;
//---- buffers 
double B0[];
double B1[];
double B2[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- indicator buffers mapping
   int shift_begin=int(MathSqrt(period)+period+1);
   IndicatorShortName("Slope_Direction_Line("+DoubleToStr(period,0)+")");
   SetIndexBuffer(0,B0);
   SetIndexBuffer(1,B1);
   SetIndexBuffer(2,B2);
   SetIndexStyle(0,DRAW_NONE);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexDrawBegin(1,shift_begin);
   SetIndexDrawBegin(2,shift_begin);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
  {
//---
   int limit=rates_total-prev_calculated;
   if(prev_calculated==0)limit--;
   else  limit++;
//---
   for(int i=0; i<limit && !IsStopped(); i++)
      B0[i]=2*MA(i,(int)MathRound((double)period/FilterNumber))-MA(i,period);
//---
   for(int i=0; i<limit && !IsStopped(); i++)
      B1[i]=iMAOnArray(B0,0,(int)MathRound(MathSqrt(period)),0,ma_method,i);
//---
   for(int i=0; i<limit && !IsStopped(); i++)
     {
      if(B1[i]>B1[i+1]) B2[i]=B1[i];
      else B2[i]=EMPTY_VALUE;
     }
//--- return value of prev_calculated for next call
   return(rates_total);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double MA(int shift,int p)
  {
   return(iMA(Symbol(), 0, p, 0, ma_method, applied_price, shift));
  }
//+------------------------------------------------------------------+
