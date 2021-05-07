//+------------------------------------------------------------------+
//|                                                     EAWinWdo.mq5 |
//|                                         Copyright 2019, Weslley. |
//|                                      https://github.com/weslleyg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Weslley."
#property link      "https://github.com/weslleyg"
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

MqlRates rates[];

double               iMABuffer[];
int                  iMAHandle;
 
int count = 0, quantity = 1;

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
   
   if(getProfit() < 0) {
      count = -1;
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
   double ask, bid, last;
   
   ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   last = SymbolInfoDouble(_Symbol, SYMBOL_LAST);
     
   if(OnTrend())
    {
      if(PositionsTotal() == 0)
      {
       if(getProfit() < 0) {
         if(count < Attempts) {
            count++;
         }
         if(count >= 1 && count != Attempts) {
            quantity = quantity * Fator_Martingale;
            trade.Sell(quantity,_Symbol, bid, (last + SL), (last - TP), "");
         }
       } else if(count != Attempts) {
          count = 0;
          quantity = 1;
          trade.Sell(quantity,_Symbol, bid, (last + SL), (last - TP), "");
       }
      }
    } else {
      if(PositionsTotal() == 0)
       {
         if(getProfit() < 0) {
             if(count < Attempts) {
               count++;
             }
             if(count >= 1 && count != Attempts) {
               quantity = quantity * Fator_Martingale;
               trade.Buy(quantity, _Symbol, ask, (last - SL), (last + TP), "");
            }
         }
         else if(count != Attempts) {
            count = 0;
            quantity = 1;
            trade.Buy(quantity, _Symbol, ask, (last - SL), (last + TP), "");
         }
       }
    }
    
  }
//+------------------------------------------------------------------+

bool OnTrend()
  {
   double last = SymbolInfoDouble(_Symbol, SYMBOL_LAST);
   
   CopyBuffer(iMAHandle, 0, 0, 3, iMABuffer);  
   
   if(last > iMABuffer[0]) 
    {
     return true;
    }
    
    return false;
  }
  
int getProfit() {
   HistorySelect(0,TimeCurrent());
//--- cria objetos
   uint     total=HistoryDealsTotal();
   ulong    ticket=0;
   double   profit;
   string   symbol;
   
   if(PositionsTotal() == 1) {
      if((ticket=HistoryDealGetTicket(total -2))>0)
        {
         //--- obter as propriedades negócios
         symbol=HistoryDealGetString(ticket,DEAL_SYMBOL);
         profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
         
         if(symbol==Symbol())
           {
            return profit;
           }
        }
   } else if(PositionsTotal() == 0) {
      if((ticket=HistoryDealGetTicket(total -1))>0)
        {
         //--- obter as propriedades negócios
         symbol=HistoryDealGetString(ticket,DEAL_SYMBOL);
         profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
         
         if(symbol==Symbol())
           {
            return profit;
           }
        }
   }
   
   return 1;
}