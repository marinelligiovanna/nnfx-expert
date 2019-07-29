//+------------------------------------------------------------------+
//|                                                         Util.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property strict

const string SETTINGS_FOLDER = "./Presets";

struct Indicator {
   string name;
   MqlParam params[];
};

struct Settings {
   Indicator atr;
   Indicator confirmation;
   Indicator secondConfirmation;
};

Settings loadSettings(string presetFileName){
   Settings settings;
   ResetLastError();
   int fHandle = FileOpen("..//" + SETTINGS_FOLDER +"//" + presetFileName, FILE_READ|FILE_TXT|FILE_ANSI);
   if(fHandle != INVALID_HANDLE) {
      PrintFormat("%s file is available for reading",InpFileName);
      PrintFormat("File path: %s\\Files\\",TerminalInfoString(TERMINAL_DATA_PATH));
      //--- additional variables
      int    str_size;
      string str;
      //--- read data from the file
      while(!FileIsEnding(file_handle))
        {
         //--- find out how many symbols are used for writing the time
         str_size=FileReadInteger(file_handle,INT_VALUE);
         //--- read the string
         str=FileReadString(file_handle,str_size);
         //--- print the string
         PrintFormat(str);
        }
      //--- close the file
      FileClose(file_handle);
      PrintFormat("Data is read, %s file is closed",InpFileName);
   }
   else
      PrintFormat("Failed to open %s file, Error code = %d",InpFileName,GetLastError());
   
   
   return settings;
}