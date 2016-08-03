****  SAS Program to Read in DATA.gov FedScope Employment Cube RAW Data Sets for general public consumption;
****  Program Creates 18 temporary SAS data sets for data analysis;                                     
****    - FACTDATA_MMMYYYY table and 17 Dimension Translations tables (DTtables);       
****
****  NOTE: 
****    - Change PATH1 Statement below to directory path Raw Data sets are in;	 
****    - Change FILENAME Statement for FACTDATA to correct FACTDATA month (e.g. FACTDATA_DEC2015.txt);
****    -    change MMMYYYY to appropriate processing month/year;
****

*** Define Path for FILENAME (PATH1) statement ***;
%LET PATH1=C:\TEMP\;  * STATUS Raw Data delimited text files;

*** Read In FACTDATA table;
* define the STATUS text file extract via FILENAME statement;
FILENAME FACTDATA "&PATH1.FACTDATA_DEC2015.txt";

DATA FACTDATA;
INFILE FACTDATA firstobs=2 dlm=',' dsd missover;
INFORMAT	AGYSUB		$4.;
INFORMAT	LOC			$2.;
INFORMAT	AGELVL		$1.;
INFORMAT	EDLVL		$2.;
INFORMAT	GENDER		$1.;
INFORMAT	GSEGRD		$2.;
INFORMAT	LOSLVL		$1.;
INFORMAT	OCC			$4.;
INFORMAT	PATCO		$1.;
INFORMAT	PPGRD		$5.;
INFORMAT	SALLVL		$1.;
INFORMAT	STEMOCC		$4.;
INFORMAT	SUPERVIS	$1.;
INFORMAT	TOA			$2.;
INFORMAT	WORKSCH		$1.;
INFORMAT	WORKSTAT	$1.;
INFORMAT	DATECODE	$6.;
INFORMAT 	EMPLOYMENT 	COMMA10.;
INFORMAT 	SALARY 		DOLLAR8.;
INFORMAT 	LOS 		4.1;
FORMAT		AGYSUB		$4.;
FORMAT		LOC			$2.;
FORMAT		AGELVL		$1.;
FORMAT		EDLVL		$2.;
FORMAT		GENDER		$1.;
FORMAT		GSEGRD		$2.;
FORMAT		LOSLVL		$1.;
FORMAT		OCC			$4.;
FORMAT		PATCO		$1.;
FORMAT		PPGRD		$5.;
FORMAT		SALLVL		$1.;
FORMAT		STEMOCC		$4.;
FORMAT		SUPERVIS	$1.;
FORMAT		TOA			$2.;
FORMAT		WORKSCH		$1.;
FORMAT		WORKSTAT	$1.;
FORMAT		DATECODE	$6.;
FORMAT 	 	EMPLOYMENT 	COMMA10.;
FORMAT   	SALARY 		DOLLAR8.;
FORMAT   	LOS 		4.1;
INPUT
AGYSUB
LOC
AGELVL
EDLVL
GENDER
GSEGRD
LOSLVL
OCC
PATCO
PPGRD
SALLVL
STEMOCC
SUPERVIS
TOA
WORKSCH
WORKSTAT
DATECODE
EMPLOYMENT 	
SALARY 		
LOS;
RUN;
** End FACTDATA table processing;

*** Read In Agency Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
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

*** Read In Location Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
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

*** Read In Age Level Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTagelvl "&PATH1.DTagelvl.txt";
DATA DTagelvl;
INFILE DTagelvl firstobs=2 dlm=',' dsd missover;
INPUT 
AGELVL 	: $1.
AGELVLT : $12.;
RUN;
** End Age Level Translation Table processing;

*** Read In Education Level Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTedlvl "&PATH1.DTedlvl.txt";
DATA DTedlvl;
INFILE DTedlvl firstobs=2 dlm=',' dsd missover;
INPUT 
EDLVLTYP	: $2.
EDLVLTYPT 	: $27.
EDLVL		: $2.
EDLVLT		: $83.;
RUN;
** End Education Level Dimension Translation Table processing;

*** Read In Gender Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTgender "&PATH1.DTgender.txt";
DATA DTgender;
INFILE DTgender firstobs=2 dlm=',' dsd missover;
INPUT
GENDER 	: $1.
GENDERT : $11.;
RUN;
** End Gender Dimension Translation Table processing;

*** Read In GSEGRD Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTgsegrd "&PATH1.DTgsegrd.txt";
DATA DTgsegrd;
INFILE DTgsegrd firstobs=2 dlm=',' dsd missover;
INPUT GSEGRD : $2.;
RUN;
** End GSEGRD Dimension Translation Table processing;

*** Read In Length of Service Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTloslvl "&PATH1.DTloslvl.txt";
DATA DTloslvl;
INFILE DTloslvl firstobs=2 dlm=',' dsd missover;
INPUT 
LOSLVL 	: $1.
LOSLVLT : $16.;
RUN;
** End Length of Service Dimension Translation Table processing;

*** Read In Occupation Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
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
* define the STATUS text file extract via FILENAME statement;
FILENAME DTpatco "&PATH1.DTpatco.txt";
DATA DTpatco;
INFILE DTpatco firstobs=2 dlm=',' dsd missover;
INPUT 
PATCO 	: $1.
PATCOT 	: $18.;
RUN;
** End PATCO Dimension Translation Table processing;

*** Read In Pay Plan & Grade Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
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
* define the STATUS text file extract via FILENAME statement;
FILENAME DTsallvl "&PATH1.DTsallvl.txt";
DATA DTsallvl;
INFILE DTsallvl firstobs=2 dlm=',' dsd missover;
INPUT 
SALLVL 	: $1.
SALLVLT : $19.;
RUN;
** End Salary Level Dimension Translation Table processing;

*** Read In STEM Occupation Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTstem "&PATH1.DTstemocc.txt";
DATA DTstemocc;
INFILE DTstem firstobs=2 dlm=',' dsd missover;
INPUT 
STEMAGG		: $1.
STEMAGGT	: $21.
STEMTYP		: $2.
STEMTYPT	: $23.
STEMOCC		: $4.
STEMOCCT	: $65.;
RUN;
** End STEM Occupation Dimension Translation Table processing;

*** Read In Supervisory Status Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTsuper "&PATH1.DTsuper.txt";
DATA DTsuper;
INFILE DTsuper firstobs=2 dlm=',' dsd missover;
INPUT
SUPERTYP	: $1.
SUPERTYPT	: $14.
SUPERVIS	: $1.
SUPERVIST	: $28.;
RUN;
** End Supervisory Status Dimension Translation Table processing;

*** Read In Type of Appointment Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
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
* define the STATUS text file extract via FILENAME statement;
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

*** Read In Work Status Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTwkstat "&PATH1.DTwkstat.txt";
DATA DTwkstat;
INFILE DTwkstat firstobs=2 dlm=',' dsd missover;
INPUT 
WORKSTAT	: $1.
WORKSTATT	: $32.;
RUN;
** End Work Status Dimension Translation Table processing;

*** Read In Date Dimension Translation Table;
* define the STATUS text file extract via FILENAME statement;
FILENAME DTdate "&PATH1.DTdate.txt";
DATA DTdate;
INFILE DTdate firstobs=2 dlm=',' dsd missover;
INPUT 
DATECODE	: $6.
DATECODET	: $8.;
RUN;
** End Date Dimension Translation Table processing;
**** END OF PROGRAM TO READ IN DATA.gov FEDSCOPE EMPLOYMENT CUBE RAW DATA SETS, ****;
**** CREATING 18 TEMPORARY DATA SETS FOR DATA ANALYSIS ****;
