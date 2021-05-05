//+------------------------------------------------------------------+
//|                                                     EAWinWdo.mq5 |
//|                                         Copyright 2019, Weslley. |
//|                                      https://github.com/weslleyg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Weslley."
#property link      "https://github.com/weslleyg"
#property version   "1.00"

#include <Trade\Trade.mqh>

MqlRates rates[];

double               iMABuffer[];
int                  iMAHandle[];

//+------------------------------------------------------------------+
//| Expert initialization variables                                   |
//+------------------------------------------------------------------+

input group          "Media Movel"
input int            MA_Period=13;
input int            MA_Shift=0;
input ENUM_MA_METHOD MA_Method=MODE_SMA;

input group          "Stop Loss/Take Profit"
input int            SL_TP=20;

input group          "Martingale"
input double         Fator_Martingale=1.92;

input group          "Attempts"
input int            Attempts=1;

input group          "Pause"
input double         Init_Pause=00.01;
input double         Stop_Pause=24.00;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ArraySetAsSeries(rates,true);
   SetIndexBuffer(0, iMABuffer, INDICATOR_CALCULATIONS);
   
   iMAHandle = iMA(_Symbol, _Period, MA_Period, MA_Shift, MA_Method, PRICE_CLOSE);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
