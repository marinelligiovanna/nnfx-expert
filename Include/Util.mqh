//+------------------------------------------------------------------+
//|                                                         Util.mqh |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql4.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql4.com"
#property strict

const string ATR_TAG = "#ATR";
const string CONFIRMATION_INDICATOR_TAG = "#ConfirmationIndicator";
const string SECOND_CONFIRMATION_INDICATOR_TAG = "#SecondConfirmationIndicator";

struct Param {
   string name;
   ENUM_DATATYPE type;
   double double_value;
   long integer_value;
   string string_value;
};

struct IndicatorSetting {
   string name;
   Param params[];
};

struct Settings {
   IndicatorSetting atr;
   IndicatorSetting confirmationIndicator;
   IndicatorSetting secondConfirmationIndicator;
};


Settings loadSettings(string presetFileName){
   Settings settings;
   IndicatorSetting indSetting;
   
   ResetLastError();
   int fHandle = FileOpen(presetFileName, FILE_READ|FILE_TXT|FILE_ANSI);
   
   
   if(fHandle != INVALID_HANDLE) {
   
      while(!FileIsEnding(fHandle)) {
         int lineSize = FileReadInteger(fHandle,INT_VALUE);
         const string line = FileReadString(fHandle,lineSize);
         
         if(line == ATR_TAG)
            indSetting = settings.atr;
         else if (line == CONFIRMATION_INDICATOR_TAG)
            indSetting = settings.confirmationIndicator;
         else if (line == SECOND_CONFIRMATION_INDICATOR_TAG)
            indSetting = settings.secondConfirmationIndicator;
         else if (line == "")
            indSetting = indSetting;
         else 
            setIndicatorSetting(indSetting, line);
        
      }
      FileClose(fHandle);
   }
   else
      PrintFormat("Failed to open %s file, Error code = %d",presetFileName,GetLastError());
   
   return settings;
}

void setIndicatorSetting(IndicatorSetting &setting, string paramStr){
   // Split the parameter using the '=' as separator.
   string paramArr[];
   StringSplit(paramStr, '=', paramArr);
  
   
   if(ArraySize(paramArr) >= 2){
      string name = paramArr[0];
      string valueStr = paramArr[1];
      
      string nameLwr = name;
      StringToLower(nameLwr);
      // If the param is the indicator name, set it on settings and return;
      if(nameLwr == "name"){
         setting.name = valueStr;
         return;
      }
      
      // Else it is an indicator param.
      // Resize the setting param to put one more element
      int paramsSize = ArraySize(setting.params);
      ArrayResize(setting.params, paramsSize + 1);
      Param param;
      
      // Set the new param values
      param.name = name;
      
      if(StringFind(valueStr, "\"", 0) >= 0){
         param.type = TYPE_STRING;
         param.string_value = valueStr;
      }
      else if (StringFind(valueStr, ".", 0) >= 0 && StringFind(valueStr, "\"", 0) < 0){
         param.type = TYPE_DOUBLE;
         param.double_value = StringToDouble(valueStr);
      }
      else {
         param.type = TYPE_INT;
         param.integer_value = StringToInteger(valueStr);
      }
      
      setting.params[paramsSize] = param;
   }
   
}