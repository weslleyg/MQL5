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
   
   color BuyColor =clrBlue;
   color SellColor=clrRed;
//--- história do negócio pedido
   HistorySelect(0,TimeCurrent());
//--- cria objetos
   string   name;
   uint     total=HistoryDealsTotal();
   ulong    ticket=0;
   double   price;
   double   profit;
   datetime time;
   string   symbol;
   long     type;
   long     entry;
//--- para todos os negócios
   for(uint i=0;i<total;i++)
     {
      //--- tentar obter ticket negócios
      if((ticket=HistoryDealGetTicket(i))>0)
        {
         //--- obter as propriedades negócios
         price =HistoryDealGetDouble(ticket,DEAL_PRICE);
         time  =(datetime)HistoryDealGetInteger(ticket,DEAL_TIME);
         symbol=HistoryDealGetString(ticket,DEAL_SYMBOL);
         type  =HistoryDealGetInteger(ticket,DEAL_TYPE);
         entry =HistoryDealGetInteger(ticket,DEAL_ENTRY);
         profit=HistoryDealGetDouble(ticket,DEAL_PROFIT);
         //--- apenas para o símbolo atual
         if(price && time && symbol==Symbol())
           {
            //--- cria o preço do objeto
            name="TradeHistory_Deal_"+string(ticket);
            if(entry) ObjectCreate(0,name,OBJ_ARROW_RIGHT_PRICE,0,time,price,0,0);
            else      ObjectCreate(0,name,OBJ_ARROW_LEFT_PRICE,0,time,price,0,0);
            //--- definir propriedades do objeto
            ObjectSetInteger(0,name,OBJPROP_SELECTABLE,0);
            ObjectSetInteger(0,name,OBJPROP_BACK,0);
            ObjectSetInteger(0,name,OBJPROP_COLOR,type?BuyColor:SellColor);
            if(profit!=0) ObjectSetString(0,name,OBJPROP_TEXT,"Profit: "+string(profit));
           }
        }
     }
//--- aplicar no gráfico
   ChartRedraw();
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
       if(count >= 1 && count != Attempts) {
         quantity = quantity * Fator_Martingale;
         trade.Sell(quantity,_Symbol, bid, (SL + last), (last - TP), "");
         count++;
       } else if(count != Attempts) {
         trade.Sell(quantity,_Symbol, bid, (SL + last), (last - TP), "");
         count++;
       }
      }
    } else {
      if(PositionsTotal() == 0)
       {
         if(count >= 1 && count != Attempts) {
            quantity = quantity * Fator_Martingale;
            trade.Buy(quantity, _Symbol, ask, (last - SL), (last + TP), "");
            count++;
         } else if(count != Attempts) {
            trade.Buy(quantity, _Symbol, ask, (last - SL), (last + TP), "");
            count++;
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