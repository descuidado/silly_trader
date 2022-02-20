//+------------------------------------------------------------------+
//|                                                     traderEA.mq4 |
//|                                          Copyright 2021, Whisper |
//|                                       https://www.none-sense.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2021, Whisper"
#property link      "https://www.none-sense.com"
#property version   "1.00"
#property strict
//--- input parameters
input int      stopLoss = 0;
input int      takeProfit = 150;
input string   comment = "OK";
input double   lotsize = 0.01;
input int      slippage = 10;
input int      magicNumber = 228899;
//input bool     reverse = True;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);

//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();

  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   int h=TimeHour(TimeCurrent());
   static datetime Time0;
   bool newBar = (Time0 != Time[0]);
   Time0 = Time[0];

   if(newBar)
     {
      if(h<17 && h>8)
        {
         int buy = OrderSend(Symbol(), OP_BUY, lotsize, NormalizeDouble(Ask,Digits), slippage, stopLoss,
                             NormalizeDouble(Bid + takeProfit*Point, Digits),
                             //0,
                             comment, magicNumber, NULL, Blue);
         int sell = OrderSend(Symbol(), OP_SELL, lotsize, NormalizeDouble(Bid,Digits), slippage, stopLoss,
                              NormalizeDouble(Ask - takeProfit*Point, Digits),
                              //0,
                              comment, magicNumber, NULL, Red);
        }
     }
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---

  }
//+------------------------------------------------------------------+

//+------------------------------------------------------------------+
