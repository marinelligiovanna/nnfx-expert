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

#include "./Structs.mqh"
#include "./Enums.mqh"

class Util {
private:
   static void setIndicatorSetting(IndicatorSettings &setting, string paramStr);
   static IndicatorID getIndicatorID(string indicatorName);
   static IndicatorType getIndicatorType(string indicatorName);
public:
   static AlgorithmSettings loadAlgorithmSettings(string presetFileName);

};

/**
* Load the settings of the algorithm to an AlgorithmSettings struct.
* This method looks at the given file inside MQL4/Files folder
* and build an AlgorithmSettings struct to be used as algorithm parameters
*
* @param presetFileName the name of the file containing the algorithm settings
**/
static AlgorithmSettings Util::loadAlgorithmSettings(string presetFileName){
   AlgorithmSettings settings;
   IndicatorSettings indSetting;
   
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
      PrintFormat("Failed to open %s file, Error code = %d", presetFileName, GetLastError());
   
   return settings;
}

static void Util::setIndicatorSetting(IndicatorSettings &setting, string paramStr){
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
         setting.id = getIndicatorID(valueStr);
         setting.type = getIndicatorType(valueStr);
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

static IndicatorID Util::getIndicatorID(string indicatorName){
   
   if(indicatorName == "ATR" || indicatorName == "atr")
      return IND_ATR;
   if(indicatorName == "kalman-filter-indicator")
      return IND_KALMAN_FILTER;
   if(indicatorName == "kuskus-starlight-indicator")
      return IND_KUSKUS_STARLIGHT;
   
   
   return IND_DEFAULT;
}

static IndicatorType Util::getIndicatorType(string indicatorName){
   if(indicatorName == "kalman-filter-indicator")
      return CHART_INDICATOR;
   if(indicatorName == "kuskus-starlight-indicator")
      return ZERO_LINE_CROSS;
   
   
   return NONE;
}