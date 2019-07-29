//+------------------------------------------------------------------+
//|                                                        Order.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
class Order {
private:
   string _symbol;
   int _operation;
   double _volume;
   double _price;
   int _slippage;
   double _sl;
   double _tp;
   string _comment;
   int _magic;
   datetime _expiration;   
   int _ticket;
public:
   Order();
   ~Order();
   
   void setSymbol(string symbol) { _symbol = symbol; };
   void setOperation(int operation){ _operation = operation; };
   void setPrice(double price) { _price = price; };
   void setSlippage(int slippage) { _slippage = slippage; };
   void setSL(double sl) { _sl = sl; };
   void setTP(double tp) { _tp = tp; };
   void setComment(string comment) { _comment = comment; };
   void setMagic(int magic) { _magic = magic; };
   void setExpiration(datetime expiration) { _expiration = expiration; };
   
   string getSymbol(void) { return _symbol; };
   int getOperation(void) { return _operation; };
   double getVolume(void) { return _volume; };
   double getPrice(void) { return _price; };
   int getSlippage(void) { return _slippage; };
   double getSL(void) { return _sl; };
   double getTP(void) { return _tp; };
   string getComment(void) { return _comment; };
   int getMagic(void) { return _magic; };
   datetime getExpiration(void) { return _expiration; };
   int getTicket(void) { return _ticket; };
   
  };
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Order::Order(){
   _tp = 0;
   _sl = 0;
   _slippage = 0;
   _magic = 0;  
   _expiration = 0;
}
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
Order::~Order()
  {
  }
//+------------------------------------------------------------------+
