//+------------------------------------------------------------------+
//|                                                  EAWinWdoBUY.mq5 |
//|                                         Copyright 2021, Weslley. |
//|                                      https://github.com/weslleyg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Weslley."
#property link      "https://github.com/weslleyg"
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

MqlRates rates[];

double               iMABuffer[];
int                  iMAHandle;

int tmp = 0;
int count = 0, quantity = 1, totalVol = 1;

datetime tm, ftm;

//+------------------------------------------------------------------+
//| Expert initialization variables                                   |
//+------------------------------------------------------------------+

input group          "Media Movel"
input int            MA_Period=9;
input int            MA_Shift=0;
input ENUM_MA_METHOD MA_Method=MODE_SMA;

input group          "Stop Loss/Take Profit"
input int            SL=20;
input int            TP=20;

input group          "Martingale"
input double         Fator_Martingale=2;

input group          "Attempts"
input int            Attempts=6;

input group          "Pause"
input double         TradeP=0.30;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   ArraySetAsSeries(rates,true);
   SetIndexBuffer(0, iMABuffer, INDICATOR_CALCULATIONS);
   
   iMAHandle = iMA(_Symbol, _Period, MA_Period, MA_Shift, MA_Method, PRICE_CLOSE);
   
   if(TradeP < 1) {
     tmp = ((TradeP * 100) * 60); 
   } else {
     tmp = TradeP * 3600;
   }
   
   for(uint i = 0; i < Attempts; i++) {
      totalVol = totalVol * Fator_Martingale;
   }
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
