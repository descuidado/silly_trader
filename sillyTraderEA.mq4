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
input double  klose_percent = 25;
extern double klose = 1000;
bool opennewtrade = true;
//input bool     reverse = True;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(60);
//klose = AccountBalance() + ((AccountBalance() /100) * klose_percent);
//lotsize = AccountBalance() / 10000;
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
   if(AccountBalance() == AccountEquity() && !opennewtrade)
     {
      opennewtrade = true;
      //klose = AccountBalance() + ((AccountBalance() /100) * klose_percent);
      klose = klose + 100;
      //lotsize = AccountBalance() / 100000;
     }
     
   if(opennewtrade)
     {
      int h=TimeHour(TimeCurrent());
      static datetime Time0;
      bool newBar = (Time0 != Time[0]);
      Time0 = Time[0];

      if(newBar)
        {
         double rsi_value_current = iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 0);
         double rsi_value_previos = iRSI(Symbol(), PERIOD_CURRENT, 14, PRICE_CLOSE, 1);
         if((rsi_value_current < rsi_value_previos) && rsi_value_current < 50)
           //if(Open[1] < Close[1])
           {
            int sell = OrderSend(Symbol(), OP_SELL, lotsize, NormalizeDouble(Bid,Digits), slippage, stopLoss,
                                 NormalizeDouble(Ask - takeProfit*Point, Digits),
                                 //0,
                                 comment, magicNumber, NULL, Red);
           }
         //else
         if((rsi_value_current > rsi_value_previos) && rsi_value_current > 50 )
           {
            int buy = OrderSend(Symbol(), OP_BUY, lotsize, NormalizeDouble(Ask,Digits), slippage, stopLoss,
                                NormalizeDouble(Bid + takeProfit*Point, Digits),
                                //0,
                                comment, magicNumber, NULL, Blue);
           }
        }
     }

   if(AccountEquity() > klose)
     {
      opennewtrade = false;
      for(int i=1; i<=OrdersTotal(); i++)        //Cycle for all orders..
        {
         //displayed in the terminal
         if(OrderSelect(i-1,SELECT_BY_POS)==true)//If there is the next one
           {
            OrderClose(OrderTicket(), OrderLots(), OrderClosePrice(), slippage, Black);
           }
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
