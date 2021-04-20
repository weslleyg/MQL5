//+------------------------------------------------------------------+
//|                                                       EA_PFR.mq5 |
//|                                         Copyright 2019, Weslley. |
//|                                      https://github.com/weslleyg |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, Weslley."
#property link      "https://github.com/weslleyg"
#property version   "1.00"


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

   if(!isPFR()) 
   {
      Print("Nao tem sinal");
   } else {
      Print("Tem sinal");   
   }
}

bool isPFR()
{
   int copyR = CopyRates(_Symbol,_Period,0,4,rates);
   if(copyR > 0)
   {
      int size=fmin(copyR,60);
      
      if(rates[1].low < rates[2].low && rates[1].low < rates[3].low)
      {
         return true;
      }
   } else Alert("Falha ao receber dados históricos para o símbolo ",Symbol());
   
   return false;
}