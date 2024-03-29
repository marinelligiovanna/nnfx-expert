//+------------------------------------------------------------------+
//|                                                   NeuroProba.mq4 |
//|                      Copyright © 2005, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2005, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"
//----
#property indicator_separate_window
#property indicator_buffers 3
#property indicator_color1 Green
#property indicator_color2 Blue
#property indicator_color3 Red
//---- input parameters
extern int       BeginBar=300; // íà÷àëüíûé áàð â îáó÷àþùåé âûáîðêå
extern int       EndBar=201; // êîíå÷íûé áàð â îáó÷àþùåé âûáîðêå
extern int       StudyNumber=100; // êîëè÷åñòâî îáó÷àþùèõ öèêëîâ
extern double    Betta=0.5; // êðóòèçíà ñèãìîèäàëüíîé ôóíêöèè
extern double    StudyCoeff=0.1; // êîýôôèöèåíò îáó÷åíèÿ
extern double    MaxRandom=0.66;//2.0/MathSqrt(9);
//---- buffers
double NeuroExitBuffer[]; // âûõîäíûå çíà÷åíèÿ íåéðîñåòè
double TeacherBuffer[]; // ýòàëîííûå çíà÷åíèÿ íåéðîñåòè (îáó÷àþùèå ñèãíàëû)
double ErrorBuffer[]; // îòêëîíåíèÿ íà êàæäîì áàðå
//---- 
double deviation; // îòêëîíåíèå íà êàæäîì øàãå îáó÷åíèÿ 
double GradientFirstLay[9][9];// äëÿ ðàñ÷åòà ãðàäèåíòà 1-ãî ñëîÿ
double GradientSecondLay[9]; //  äëÿ ðàñ÷åòà ãðàäèåíòà 2-ãî ñëîÿ
double OutputFirstLay[9]; // ñóììà âûõîäà êàæäîãî íåéðîíà
double SecondSum;// ñóììà âûõîäíîãî ñëîÿ - àðãóìåíò ñèãìîèäàëüíîé ôóíêöèè
double FirstLayWeights[9][9]; // âåñà íåéðîíîâ ïåðâîãî (ñêðûòîãî ñëîÿ)
double OutputSecondWeights[9]; // âåñà âûõîäíîãî íåéðîíà
double InputNormalX[100][9]; // íîðìàëèçîâàííàÿ âûáîðêà âõîäíûõ ñèãíàëîâ
double InputX[9]; // òåêóùèé âõîäíîé âåêòîð (íåíîðìàëèçîâàííûé)
double Normà;// íîðìà òåêóùåãî âõîäíîãî âåêòîðà
double U_First[9];// çíà÷åíèÿ íà âûõîäå ñëîÿ ñêðûòûõ (âõîäíûõ) íåéðîíîâ
double U_Second;//  çíà÷åíèå íà âûõîäå âûõîäíîãî íåéðîíà (àðãóìåíò ñèãìîèäàëüíîé ôóíêöèè)
double SigmaCurr;
double Differ;
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double NormalRand(double MaxValue=1.0)
  {
   double answer;
   answer=MathRand()/32767.0;
   answer=MaxValue*answer;
   return(answer);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double Sigma(double argument)
  {
   double help;
   help=(MathExp(argument)-MathExp(-argument))/(MathExp(argument)+MathExp(-argument));
   return(help);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
double GetArgument()
  {
   int j;
   double answer=0.0;
   for(j=0;j<9;j++)
     {
      answer=answer+OutputSecondWeights[j]*OutputFirstLay[j];
     }
   return(answer);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void GetFirstLayOutput()
  {
   int j,t;
   for(j=0;j<9;j++)
     {
      OutputFirstLay[j]=0.0;
      for(t=0;t<9;t++)
        {
         OutputFirstLay[j]=OutputFirstLay[j]+FirstLayWeights[j,t]*InputX[t];
        }
     }
   return(0);
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void SetGradientWeights()
  {
   int j,t;
   for(j=0;j<9;j++)
     {
      //GradientFirstLay[j,t]=0.0;
      for(t=0;t<9;t++)
        {
         GradientFirstLay[j,t]=OutputSecondWeights[j]*InputX[t]*deviation*Differ;
         //GradientFirstLay[j,t]=GradientFirstLay[j,t]+OutputSecondWeights[j]*InputX[t];
        }
      //GradientFirstLay[j,t]=GradientFirstLay[j,t]*deviation*Differ;
      GradientSecondLay[j]=OutputFirstLay[j]*deviation*Differ;
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void ChangeWeigts()
  {
   int i,k;
   for(i=0;i<9;i++)
     {
      for(k=0;k<9;k++)
        {
         FirstLayWeights[i,k]=FirstLayWeights[i,k]-StudyCoeff*GradientFirstLay[i,k];
        }
      OutputSecondWeights [i]=OutputSecondWeights [i]-StudyCoeff*GradientSecondLay[i];// èçìåíåíèå âåñîâ âûõîäíîãî íåéðîíà
     }
  }
//+------------------------------------------------------------------+
//|                                                                  |
//+------------------------------------------------------------------+
void PrintWeights()
  {
   int i,k;
   for(i=0;i<9;i++)
     {
      for(k=0;k<9;k++)
        {
         //         Print("W1["+i+","+k+"]=",FirstLayWeights[i,k]);
        }
      //      Print("W2["+i+"]=",OutputSecondWeights[i]);
     }
  }
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,NeuroExitBuffer);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,TeacherBuffer);
   SetIndexStyle(2,DRAW_LINE);
   SetIndexBuffer(2,ErrorBuffer);
   SetIndexLabel(0,"Answer");
   SetIndexLabel(1,"Teacher");
   SetIndexLabel(2,"Error");
   ArrayInitialize(NeuroExitBuffer,0.0);
   ArrayInitialize(TeacherBuffer,0.0);
   ArrayInitialize(ErrorBuffer,0.0);
//----
   int i,k,m,n,p; // m - èíäåêñ âåñîâ âûõîäíîãî íåéðîíà, p - ñ÷åò÷èê öèêëà îáó÷åíèÿ
   for(i=BeginBar;i>=EndBar;i--)
     {
      Normà=0.0;
      for(k=0;k<=8;k++)
        {InputX[k]=Close[i]-Close[i+k+1];
         Normà=Normà+InputX[k]*InputX[k];
        }
      Normà=MathSqrt(Normà);
      for(k=0;k<=8;k++)
        {
         InputNormalX[BeginBar-i,k]=InputX[k]/Normà;
         TeacherBuffer[BeginBar-i]=0.0;
         if (iCustom(NULL,0,"Kaufman2",1,i)>0) TeacherBuffer[BeginBar-i]=1;
         if (iCustom(NULL,0,"Kaufman2",2,i)>0) TeacherBuffer[BeginBar-i]=-1;
         //TeacherBuffer[BeginBar-i]=iCustom(NULL,0,"KaufmanTrend",0,BeginBar);      
        }
     }
   MathSrand(LocalTime());
//----
   for(i=0;i<9;i++)
     {
      for(k=0;k<9;k++)
        {
         FirstLayWeights[i,k]=NormalRand(MaxRandom);
         //         Print("FirstLayWeights["+i+","+k+"]=",FirstLayWeights[i,k]);
        }
      OutputSecondWeights[i]=NormalRand(MaxRandom);
     }
   PrintWeights();
   //   Print("Sigma=",Sigma(NormalRand()));
   Print("Èíèöèàëèçàöèÿ çàêîí÷åíà");
//----
   for(p=1;p<=StudyNumber;p++) // öèêë îáó÷åíèÿ - p-íîìåð îáó÷åíèÿ
     {
      for(n=0;n<100;n++) // ïðîõîä ïî âûáîðêå âõîäíûõ ñèãíàëîâ -  n-íîìåð îáó÷àþùåãî ñèãíàëà
        {
         for(int z=0;z<9;z++) InputX[z]=InputNormalX[n,z]; // çàïîëíèì âõîäíîé âåêòîð èç ìàññèâà ïîäãîòîâëåííûõ íîðìàëèçîâàííûõ âåêòîðîâ
         GetFirstLayOutput();
         U_Second=GetArgument();
         Print("p=",p," n=",n," U_Second=",U_Second);
         PrintWeights();
         SigmaCurr=Sigma(Betta*U_Second);
         Differ=Betta*(1-SigmaCurr*SigmaCurr); // ïðîèçâîäíàÿ îò òàíãåíñà ãèïåðáîëè÷åñêîãî
         deviation=TeacherBuffer[BeginBar-n]-SigmaCurr; //îøèáêà ïîëó÷åíà, òåïåðü íàäî ïîäêîððåêòèðîâàòü âåñà
         SetGradientWeights();
         ChangeWeigts();
        }// ïðîõîä ïî âûáîðêå âõîäíûõ ñèãíàëîâ   
     }// öèêë îáó÷åíèÿ
//----
   PrintWeights();
   Comment("Îáó÷åíèå çàêîí÷åíî");
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int i,m;
   int counted_bars=IndicatorCounted();
   if (counted_bars<0) return(-1);
   int limit;
   //limit=Bars-10-counted_bars;
   limit=300;
   for(i=limit;i>=0;i--)
     {
      if (iCustom(NULL,0,"Kaufman2",1,i)>0) TeacherBuffer[i]=1;
      if (iCustom(NULL,0,"Kaufman2",2,i)>0) TeacherBuffer[i]=-1;
      Normà=0.0;
      for(m=0;m<9;m++)
        {
         InputX[m]=Close[i]-Close[i+m+1];
         Normà=Normà+InputX[m]*InputX[m];
        }
      Normà=MathSqrt(Normà);
      Print("Normà=",Normà);
      for(m=0;m<9;m++)
        {
         InputX[m]=InputX[m]/Normà;
        }
      GetFirstLayOutput();
      U_Second=GetArgument();
      Print("U_Second=",U_Second);
      NeuroExitBuffer[i]=Sigma(Betta*U_Second);
      //Print("NeuroExitBuffer["+i+"]=",NeuroExitBuffer[i]);
      ErrorBuffer[i]=TeacherBuffer[i]-NeuroExitBuffer[i];
     }
//---- TODO: add your code here
//----
   return(0);
  }
//+------------------------------------------------------------------+