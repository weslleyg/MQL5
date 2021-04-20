//+------------------------------------------------------------------+
//|                                                       EA_PFR.mq5 |
//|                                         Copyright 2019, Weslley. |
//|                                      https://github.com/weslleyg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Weslley."
#property link      "https://github.com/weslleyg"
#property version   "1.00"

#include <Trade\Trade.mqh>
CTrade trade;

MqlRates rates[];

int OnInit()
{

   ArraySetAsSeries(rates,true);
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{

}

void OnTick()
{
   double ask, bid, last, low, tp;
   
   ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   last = SymbolInfoDouble(_Symbol, SYMBOL_LAST);
   
   int copyR = CopyRates(_Symbol,_Period,0,4,rates);
   
   low = rates[1].low;
   
   tp = rates[1].high + ((rates[1].high - rates[1].low) * 2);
   
   if(!isPFR()) 
   {
      Print("Não tem sinal");
   } else {
      if(copyR > 0 && PositionsTotal() == 0) 
      {
         Print("Tem sinal");
         trade.Buy(0.1, _Symbol, ask, low, tp, "");  
      }
   }
}

bool isPFR()
{
   
   int copyR = CopyRates(_Symbol,_Period,0,4,rates);
   
   if(copyR > 0)
   {
      if(rates[1].low < rates[2].low 
         && rates[1].low < rates[3].low
         && rates[1].close > rates[2].close
         && rates[1].low < rates[0].low)
      {  
         return true;
      }
   } else Alert("Falha ao receber dados históricos para o símbolo ",_Symbol);
   
   return false;
}