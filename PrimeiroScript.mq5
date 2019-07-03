//+------------------------------------------------------------------+
//|                                               PrimeiroScript.mq5 |
//|                                         Copyright 2019, Weslley. |
//|                                      https://github.com/weslleyg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Weslley."
#property link      "https://github.com/weslleyg"
#property version   "1.00"
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
//---
   datetime inicio, fim;
   double lucro = 0, perda = 0;
   int trades = 0;
   double resultado;
   ulong ticket;
   
   MqlDateTime inicio_struct;
   fim = TimeCurrent(inicio_struct);
   inicio_struct.hour = 0;
   inicio_struct.min = 0;
   inicio_struct.sec = 0;
   inicio = StructToTime(inicio_struct);
   
   HistorySelect(inicio, fim);
   
   for(int i=0; i<HistoryDealsTotal(); i++)
   {
      ticket = HistoryDealGetTicket(i);
      if(ticket > 0)
      {
         if(HistoryDealGetString(ticket, DEAL_SYMBOL) == _Symbol)
         {
            trades++;
            resultado = HistoryDealGetDouble(ticket, DEAL_PROFIT);
            if(resultado < 0)
            {
               perda += -resultado;
            }
            else
            {
               lucro += resultado;
            }
         }
      }
      
   }
   
   double fator_lucro;
   if(perda > 0)
   {
      fator_lucro = lucro/perda;
   }
   else
      fator_lucro = -1;
      
   double resultado_liquido = lucro - perda;

   
   Comment("Trades: ", trades, " Lucro: ", DoubleToString(lucro, 2), " Perdas: ", DoubleToString(perda, 2),
    " Resultado: ", DoubleToString(resultado_liquido, 2), " FL: ", DoubleToString(fator_lucro, 2) );
}
//+------------------------------------------------------------------+
