//+------------------------------------------------------------------+
//|                                                       EA_PFR.mq5 |
//|                                         Copyright 2019, Weslley. |
//|                                      https://github.com/weslleyg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Weslley."
#property link      "https://github.com/weslleyg"
#property version   "1.00"
#property indicator_buffers 2

#include <Trade\Trade.mqh>
CTrade trade;

MqlRates rates[];

double   iMA9Buffer[];
double   iMA80Buffer[];

int      iMA9Handle;
int      iMA80Handle;

int OnInit()
{

   ArraySetAsSeries(rates,true);
   SetIndexBuffer(0, iMA80Buffer, INDICATOR_CALCULATIONS);
   SetIndexBuffer(1, iMA9Buffer, INDICATOR_CALCULATIONS);
   
   iMA9Handle = iMA(_Symbol, _Period, 9, 0, MODE_SMA, PRICE_CLOSE);
   iMA80Handle = iMA(_Symbol, _Period, 80, 0, MODE_SMA, PRICE_CLOSE);
   
   return(INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{

}

void OnTick()
{
   double ask, bid, last, low, high, tp1, tp2;
   
   ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   last = SymbolInfoDouble(_Symbol, SYMBOL_LAST);
   
   CopyBuffer(iMA9Handle, 0, 0, 3, iMA9Buffer);
   CopyBuffer(iMA80Handle, 0, 0, 3, iMA80Buffer);
   
   int copyR = CopyRates(_Symbol,_Period,0,4,rates);
   
   low = rates[1].low;
   high = rates[1].high;
   
   tp1 = rates[1].high + ((rates[1].high - rates[1].low) * 2);
   tp2 = rates[1].low - ((rates[1].high - rates[1].low) * 2);
   
   if(isPFR() == 0) 
   {
      Print(isPFR());
   } else {
      if(_Symbol[3] == 74) 
      {
         if(copyR > 0 && isPFR() == 1 && last >= rates[1].high && last <= rates[1].high + 0.001 && PositionsTotal() == 0 && last > iMA9Buffer[0] && last > iMA80Buffer[0]) 
         {
            Print("Tem compra ");
            trade.Buy(1, _Symbol, ask, low, 0, "");  
         } else if(copyR > 0 && isPFR() == 2 && last <= rates[1].low && last >= rates[1].low - 0.001 && PositionsTotal() == 0 && last < iMA9Buffer[0] && last < iMA80Buffer[0])
         {
            Print("Tem venda ");
            trade.Sell(1, _Symbol, bid, high, 0, ""); 
         }
      }
      
      if(copyR > 0 && isPFR() == 1 && last >= rates[1].high && last <= rates[1].high + 0.00001 && PositionsTotal() == 0 && last > iMA9Buffer[0] && last > iMA80Buffer[0]) 
      {
         Print("Tem compra ");
         trade.Buy(1, _Symbol, ask, low, 0, "");  
      } else if(copyR > 0 && isPFR() == 2 && last <= rates[1].low && last >= rates[1].low - 0.00001 && PositionsTotal() == 0 && last < iMA9Buffer[0] && last < iMA80Buffer[0])
      {
         Print("Tem venda ");
         trade.Sell(1, _Symbol, bid, high, 0, ""); 
      }
   }
   
   if(PositionSelect(_Symbol) == true)
   {
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
      {
         if(rates[1].close < iMA9Buffer[0])
         {
            trade.PositionModify(_Symbol, rates[1].low, 0);
         }
      } else if(rates[1].close > iMA9Buffer[0]) {
         trade.PositionModify(_Symbol, rates[1].high, 0);
      }
   }
}

int isPFR()
{
   
   int copyR = CopyRates(_Symbol,_Period,0,4,rates);
   
   if(copyR > 0)
   {
      if(rates[1].low < rates[2].low 
         && rates[1].low < rates[3].low
         && rates[1].close > rates[2].close
         && rates[1].low < rates[0].low)
      {  
         return 1;
      } else if(rates[1].high > rates[2].high
                && rates[1].high > rates[3].high
                && rates[1].close < rates[2].close
                && rates[1].high > rates[0].high) 
      {
            return 2;
      }
   } else Alert("Falha ao receber dados históricos para o símbolo ",_Symbol);
   
   return 0;
}