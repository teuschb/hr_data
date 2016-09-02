****  SAS Program to Read in Separations
****  DATA.gov RAW Data Sets for general public consumption;
****  Program Creates 15 temporary SAS data sets for data analysis;                                     
****    - SEPDATA table;
****    - 14 Dimension Translations tables (DTtables) 
****
****  NOTE: 
****    - Change PATH1 Statement below to directory path Raw Data sets are in;	 
****    - Change FILENAME Statements for SEPDATA
****       to correct SEPDATA year (e.g. SEPDATA_FY2015.txt);
****    -    change FYYYYY to appropriate processing fiscal year;
****

*** Define Path for FILENAME (PATH1) statement ***;
%LET PATH1=C:\TEMP\;  * DYNAMICS Raw Data delimited text files;

*** Read In SEPDATA table;
* define the DYNAMICS text file extract via FILENAME statements;
FILENAME SEPDATA "&PATH1.SEPDATA_FY2015.txt";

DATA SEPDATA;
INFILE SEPDATA firstobs=2 dlm=',' dsd missover;
INFORMAT	AGYSUB		$4.;
INFORMAT	SEP			$2.;
INFORMAT	EFDATE		$6.;
INFORMAT	AGELVL		$1.;
INFORMAT	GENDER		$1.;
INFORMAT	GSEGRD		$2.;
INFORMAT	LOSLVL		$1.;
INFORMAT	LOC			$2.;
INFORMAT	OCC			$4.;
INFORMAT	PATCO		$1.;
INFORMAT	PPGRD		$5.;
INFORMAT	SALLVL		$1.;
INFORMAT	TOA			$2.;
INFORMAT	WORKSCH		$1.;
INFORMAT 	EMPLOYMENT 	COMMA10.;
INFORMAT 	SALARY 		DOLLAR8.;
INFORMAT 	LOS 		4.1;
FORMAT		AGYSUB		$4.;
FORMAT		SEP			$2.;
FORMAT		EFDATE		$6.;
FORMAT		AGELVL		$1.;
FORMAT		GENDER		$1.;
FORMAT		GSEGRD		$2.;
FORMAT		LOC			$2.;
FORMAT		LOSLVL		$1.;
FORMAT		OCC			$4.;
FORMAT		PATCO		$1.;
FORMAT		PPGRD		$5.;
FORMAT		SALLVL		$1.;
FORMAT		TOA			$2.;
FORMAT		WORKSCH		$1.;
FORMAT 	 	EMPLOYMENT 	COMMA10.;
FORMAT   	SALARY 		DOLLAR8.;
FORMAT   	LOS 		4.1;
INPUT
AGYSUB
SEP
EFDATE
AGELVL
GENDER
GSEGRD
LOSLVL
LOC
OCC
PATCO
PPGRD
SALLVL
TOA
WORKSCH
EMPLOYMENT 	
SALARY 		
LOS;
RUN;
** End SEPDATA table processing;

*** Read In Agency Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTagy "&PATH1.DTagy.txt";
DATA DTagy;
INFILE DTagy firstobs=2 dlm=',' dsd missover;
INPUT
AGYTYP 	: $1.
AGYTYPT : $52.
AGY 	: $2.
AGYT 	: $78.
AGYSUB 	: $4.
AGYSUBT : $114.;
RUN;
** End Agency Dimension Translation Table processing;

*** Read In Separation Dimension Translation Table;
* define the DYNAMICS text file extract (Static File);
FILENAME DTsep "&PATH1.DTsep.txt";
DATA DTsep;
INFILE DTsep firstobs=2 dlm=',' dsd missover;
INPUT
SEP		: $2.
SEPT	: $48.;
RUN;
** End Separation Dimension Translation Table processing;

*** Read In Effective Date Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTefdate "&PATH1.DTefdate.txt";
DATA DTefdate;
INFILE DTefdate firstobs=2 dlm=',' dsd missover;
INPUT 
QTR		: $1.
QTRT 	: $12.
EFDATE	: $6.
EFDATET	: $8.;
RUN;
** End Effective Date Dimension Translation Table processing;

*** Read In Age Level Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTagelvl "&PATH1.DTagelvl.txt";
DATA DTagelvl;
INFILE DTagelvl firstobs=2 dlm=',' dsd missover;
INPUT 
AGELVL 	: $1.
AGELVLT : $12.;
RUN;
** End Age Level Translation Table processing;

*** Read In Gender Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTgender "&PATH1.DTgender.txt";
DATA DTgender;
INFILE DTgender firstobs=2 dlm=',' dsd missover;
INPUT
GENDER 	: $1.
GENDERT : $11.;
RUN;
** End Gender Dimension Translation Table processing;

*** Read In GSEGRD Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTgsegrd "&PATH1.DTgsegrd.txt";
DATA DTgsegrd;
INFILE DTgsegrd firstobs=2 dlm=',' dsd missover;
INPUT GSEGRD : $2.;
RUN;
** End GSEGRD Dimension Translation Table processing;

*** Read In Length of Service Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTloslvl "&PATH1.DTloslvl.txt";
DATA DTloslvl;
INFILE DTloslvl firstobs=2 dlm=',' dsd missover;
INPUT 
LOSLVL 	: $1.
LOSLVLT : $16.;
RUN;
** End Length of Service Dimension Translation Table processing;

*** Read In Location Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTloc "&PATH1.DTloc.txt";
DATA DTloc;
INFILE DTloc firstobs=2 dlm=',' dsd missover;
INPUT 
LOCTYP 		: $1.
LOCTYPT 	: $17.
LOC			: $2.
LOCT		: $47.;
RUN;
** End Location Dimension Translation Table processing;

*** Read In Occupation Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTocc "&PATH1.DTocc.txt";
DATA DTocc;
INFILE DTocc firstobs=2 dlm=',' dsd missover;
INPUT 
OCCTYP 	: $1.
OCCTYPT : $12.
OCCFAM 	: $2.
OCCFAMT : $45.
OCC 	: $4.
OCCT 	: $83.;
RUN;
** End Occupation Dimension Translation Table processing;

*** Read In PATCO Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTpatco "&PATH1.DTpatco.txt";
DATA DTpatco;
INFILE DTpatco firstobs=2 dlm=',' dsd missover;
INPUT 
PATCO 	: $1.
PATCOT 	: $18.;
RUN;
** End PATCO Dimension Translation Table processing;

*** Read In Pay Plan & Grade Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTppgrd "&PATH1.DTppgrd.txt";
DATA DTppgrd;
INFILE DTppgrd firstobs=2 dlm=',' dsd missover;
INPUT 
PPTYP 		: $1.
PPTYPT 		: $57.
PPGROUP 	: $2.
PPGROUPT	: $36.
PAYPLAN 	: $2.
PAYPLANT 	: $113.
PPGRD 		: $5.;
RUN;
** End Pay Plan & Grade Dimension Translation Table processing;

*** Read In Salary Level Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTsallvl "&PATH1.DTsallvl.txt";
DATA DTsallvl;
INFILE DTsallvl firstobs=2 dlm=',' dsd missover;
INPUT 
SALLVL 	: $1.
SALLVLT : $19.;
RUN;
** End Salary Level Dimension Translation Table processing;

*** Read In Type of Appointment Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTtoa "&PATH1.DTtoa.txt";
DATA DTtoa;
INFILE DTtoa firstobs=2 dlm=',' dsd missover;
INPUT
TOATYP 	: $1.
TOATYPT : $13.
TOA 	: $2.
TOAT 	: $50.;
RUN;
** End Type of Appointment Dimension Translation Table processing;

*** Read In Work Schedule Dimension Translation Table;
* define the DYNAMICS text file extract via FILENAME statement;
FILENAME DTwrksch "&PATH1.DTwrksch.txt";
DATA DTwrksch;
INFILE DTwrksch firstobs=2 dlm=',' dsd missover;
INPUT
WSTYP 	  : $1.
WSTYPT 	  : $13.
WORKSCH   : $1.
WORKSCHT  : $36.;
RUN;
** End Work Schedule Dimension Translation Table processing;
**** END OF PROGRAM TO READ IN Separations DATA.gov RAW DATA SETS, ****;
**** CREATING 15 TEMPORARY DATA SETS FOR DATA ANALYSIS ****;
