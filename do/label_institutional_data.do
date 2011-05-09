// label_institutional_data.do
set more off

/*
	02DEC2010: File copied from L-SLIS files.

	09JUL09: File Created.
	Any introductory comments go here.
*/

/*
	Change the name here to reflect the new name of the do file.
	Stata will use this name in all the logs, etc.
*/
local dofilename "label_institutional_data"

/*
	header.do, which is called here, will log all the results of
	the do file into the appropriate directory.
	
	If you want an output directory, keep this file as is.
	Otherwise, uncomment the local makeoutput = 0 line.
*/
// local makeoutput = 1
local makeoutput = 0
include do/header.do

capture program drop my_encode
program my_encode
	syntax varname, generate(namelist) *
	capture encode `varlist', generate(`generate') `options'
	if _rc==107 {
		clonevar `generate' = `varlist'
	} 
end

// Sample Command to load the data file.
use "`workdatapath'initial_retention_data"

// APPTYPE
include do/apptype_codes.do
encode DIR_ENTRY_APPTYPE, generate(apptype) label(apptype_codes)
include do/apptype_en_label.do
label values apptype apptype_en_label

tabulate apptype, missing

// COUNTY
/*
	This one is made a bit difficult because we don't know
	the province. We have to figure it out from other information.
	
	We know the Postal Code, and if the first letter is "G" or "J",
	then the student is from Québec.
*/
generate fsa1 = substr(POSTAL_CD,1,1)
generate fsa3 = substr(POSTAL_CD,1,3)
generate province = .
replace province = 10 if fsa1=="A"	// Newfoundland and Labrador
replace province = 12 if fsa1=="B"	// Nova Soctia
replace province = 11 if fsa1=="C"	// Prince Edward Island
replace province = 13 if fsa1=="E"	// New Brunswick
replace province = 24 if fsa1=="G"	// Eastern Québec
replace province = 24 if fsa1=="H"	// Metro Montréal
replace province = 24 if fsa1=="J"	// Western Québec
replace province = 35 if fsa1=="K"	// Eastern Ontario
replace province = 35 if fsa1=="L"	// Central Ontario
replace province = 35 if fsa1=="M"	// Metro Toronto
replace province = 35 if fsa1=="N"	// Southwestern Ontario
replace province = 35 if fsa1=="P"	// Nothern Ontario
replace province = 46 if fsa1=="R"	// Manitoba
replace province = 47 if fsa1=="S"	// Saskatchewan
replace province = 48 if fsa1=="T"	// Alberta
replace province = 59 if fsa1=="V"	// British Columbia
replace province = 60 if fsa1=="X"	// NWT & Nunavut
replace province = 61 if fsa1=="Y"	// Yukon

label define province 10 "Newfoundland and Labrador", add
label define province 11 "Prince Edward Island", add
label define province 12 "Nova Scotia", add
label define province 13 "New Brunswick", add
label define province 24 "Quebec", add
label define province 35 "Ontario", add
label define province 46 "Manitoba", add
label define province 47 "Saskatchewan", add
label define province 48 "Alberta", add
label define province 59 "British Columbia", add
label define province 60 "Northwest Territories", add
label define province 61 "Yukon", add
label define province 62 "Nunavut", add

label values province province

tabulate province
tab2 apptype province, missing

clonevar county = COUNTY
replace county = county + 100 if province==24

tab2 county province, missing

include do/county_en_label.do
label values county county_en_label

tabulate county, missing

tabulate province if missing(county)

tabulate county if province!=24 & province!=35, missing

tabulate province if !missing(county) & province!=24 & province!=35

// CREDENTIAL_CD
include do/credential_cd_codes.do
my_encode CREDENTIAL_CD, generate(credential_cd) label(credential_cd_codes)
my_encode J_CREDENTIAL_CD, generate(j_credential_cd) label(j_credential_cd)
include do/credential_cd_en_label.do
label values credential_cd credential_cd_en_label
label values j_credential_cd credential_cd_en_label

tabulate credential_cd, missing
tabulate j_credential_cd, missing

// IMSTAT
/*
	IMSTAT is already numeric.
*/
rename IMSTAT imstat
include do/imstat_en_label.do
label values imstat imstat_en_label

tabulate imstat, missing

// KIND_OF_PROGRAM_CD
include do/kind_of_program_cd_codes.do
my_encode KIND_OF_PROGRAM_CD, generate(kind_of_program_cd) label(kind_of_program_cd_codes)
include do/kind_of_program_cd_en_label.do
label values kind_of_program_cd kind_of_program_cd_en_label

tabulate kind_of_program_cd, missing

// MOTHER_TOUNGE
include do/mother_tongue_codes.do
my_encode MOTHER_TONGUE, generate(mother_tongue) label(mother_tongue_codes)
include do/mother_tongue_en_label.do
label values mother_tongue mother_tongue_en_label

tabulate mother_tongue, missing

// PRINC_TEACHING_LNG
include do/princ_teaching_lng_codes.do
my_encode PRINC_TEACHING_LNG, generate(princ_teaching_lng) label(princ_teaching_lng_codes)
include do/princ_teaching_lng_en_label.do
label values princ_teaching_lng princ_teaching_lng_en_label

tabulate princ_teaching_lng, missing

// SUBJECT_CD
include do/subject_cd_codes.do
include do/subject_cd_en_label.do
foreach i of varlist MAIN_SUBJECT1_CD MAIN_SUBJECT2_CD J_MAIN_SUBJECT1_CD /* J_MAIN_SUBJECT2_CD */ {
	local lower_i = lower("`i'")
	my_encode `i', generate(`lower_i') label(subject_cd_codes)
	label values `lower_i' subject_cd_en_label
	tabulate `lower_i', missing
	display _n
}

// UG_SPEC_LEVEL_CD
include do/ug_spec_level_cd_codes.do
my_encode UG_SPEC_LEVEL_CD, generate(ug_spec_level_cd) label(ug_spec_level_cd_codes)
include do/ug_spec_level_cd_en_label.do
label values ug_spec_level_cd ug_spec_level_cd_en_label

tabulate ug_spec_level_cd, missing

// ECON_REGION_ORIGIN
include do/econ_region_codes.do
label values ECON_REGION_ORIGIN econ_region_codes

tabulate ECON_REGION_ORIGIN

recode ECON_REGION_ORIGIN 	(1010/1040	= 10) ///
							(1110 		= 11) ///
							(1210/1250	= 12) ///
							(1310/1350	= 13) ///
							(2410/2490	= 24) ///
							(3510/3595	= 35) ///
							(4610/4680	= 46) ///
							(4710/4760	= 47) ///
							(4810/4880	= 48) ///
							(5910/5980	= 59) ///
							(6010		= 60) ///
							(6110		= 61) ///
							(6210		= 62) ///
							(nonmissing = .) ///
							(missing = .) ///
							, generate(er_province)
							
label values er_province province
tab2 province er_province

// SESSION_CD
label define SESSION_CD 19979 "September 1997", add
label define SESSION_CD 19989 "September 1998", add
label define SESSION_CD 19999 "September 1999", add
label define SESSION_CD 20009 "September 2000", add
label define SESSION_CD 20019 "September 2001", add
label define SESSION_CD 20029 "September 2002", add
label define SESSION_CD 20039 "September 2003", add
label define SESSION_CD 20049 "September 2004", add
label define SESSION_CD 20059 "September 2005", add
label define SESSION_CD 20069 "September 2006", add
label define SESSION_CD 20079 "September 2007", add
label define SESSION_CD 20089 "September 2008", add
label define SESSION_CD 20099 "September 2009", add

label values SESSION_CD SESSION_CD

tostring SESSION_CD, generate(SESSION_CD_STR)
generate session_date = ym(real(substr(SESSION_CD_STR,1,4)),real(substr(SESSION_CD_STR,5,1)))
format %tm session_date

recode SESSION_CD	(19979 =	1 "September 1997") ///
					(19989 =	2 "September 1998") ///
					(19999 =	3 "September 1999") ///
					(20009 =	4 "September 2000") ///
					(20019 = 	5 "September 2001") ///
					(20029 =	6 "September 2002") ///
					(20039 =	7 "September 2003") ///
					(20049 =	8 "September 2004") ///
					(20059 =	9 "September 2005") ///
					(20069 =	10 "September 2006") ///
					(20079 =	11 "September 2007") ///
					(20089 =	12 "September 2008") ///
					(20099 =	13 "September 2009") ///
					, generate(session_cd)

recode COHORT		(1997 =	1 "1997") ///
					(1998 =	2 "1998") ///
					(1999 =	3 "1999") ///
					(2000 =	4 "2000") ///
					(2001 = 5 "2001") ///
					(2002 =	6 "2002") ///
					(2003 =	7 "2003") ///
					(2004 =	8 "2004") ///
					(2005 =	9 "2005") ///
					(2006 =	10 "2006") ///
					(2007 =	11 "2007") ///
					(2008 =	12 "2008") ///
					(2009 = 13 "2009") ///
					, generate(cohort)
					
compare session_cd cohort
tab2 session_cd cohort

generate int entry_month = ym(COHORT, 9)
format %tm entry_month

generate long entry_day = mdy(9, 1, COHORT)
format %td entry_day


// GENDER

label define gender_codes 0 "F" 1 "H"
my_encode GENDER, generate(gender) label(gender_codes)
label define gender_en_label 0 "Female" 1 "Male"
label values gender gender_en_label

// BIRTH_DT

generate long birth_dt = date(BIRTH_DT, "`bdate_format'")
format birth_dt %td

generate birth_year = yofd(birth_dt)
tab birth_year
tab2 birth_year cohort

tabulate cohort, summarize(birth_year)

generate long age_days = entry_day - birth_dt
generate float age_float = age_days / 365.25
generate int age = floor(age_float)

tab age
tabulate cohort, summarize(age)

// PRIMARY_ORG_CD
label define primary_org_cd_codes 1 "ADMIN", add
label define primary_org_cd_codes 2 "ARTS", add
label define primary_org_cd_codes 3 "GENIE", add
label define primary_org_cd_codes 4 "SCIEN", add
label define primary_org_cd_codes 5 "SSAN", add
label define primary_org_cd_codes 6 "SSOC", add
encode PRIMARY_ORG_CD, generate(primary_org_cd) label(primary_org_cd_codes)
label values primary_org_cd primary_org_cd_codes

tab primary_org_cd, missing

// CIP_CD
#delimit ;
label define cip_2digit
	1		"Agriculture, Agricultural Operations and Related Sciences"
	3		"Natural Resources and Conservation"
	4		"Architecture and Related Services"
	5		"Area, Ethnic, Cultural and Gender Studies"
	9		"Communication, Journalism and Related Programs"
	10		"Communications Technologies/Technicians and Support Services"
	11		"Computer and Information Sciences and Support Services"
	12		"Personal and Culinary Services"
	13		"Education"
	14		"Engineering"
	15		"Engineering Technologies/Technicians"
	16		"Aboriginal and Foreign Languages, Literatures and Linguistics"
	19		"Family and Consumer Sciences/Human Sciences"
	21		"Technology Education/Industrial Arts Programs"
	22		"Legal Professions and Studies"
	23		"English Language and Literature/Letters"
	24		"Liberal Arts and Sciences, General Studies and Humanities"
	25		"Library Science"
	26		"Biological and Biomedical Sciences"
	27		"Mathematics and Statistics"
	28		"Reserve Entry Scheme for Officers in the Armed Forces"
	29		"Military Technologies"
	30		"Multidisciplinary/Interdisciplinary Studies"
	31		"Parks, Recreation and Leisure Studies"
	32		"Basic Skills"
	33		"Citizenship Activities"
	34		"Health-related Knowledge and Skills"
	35		"Interpersonal and Social Skills"
	36		"Leisure and Recreational Activities"
	37		"Personal Awareness and Self-improvement"
	38		"Philosophy and Religious Studies"
	39		"Theology and Religious Vocations"
	40		"Physical Sciences"
	41		"Science Technologies/Technicians"
	42		"Psychology"
	43		"Security and Protective Services"
	44		"Public Administration and Social Service Professions"
	45		"Social Sciences"
	46		"Construction Trades"
	47		"Mechanic and Repair Technologies/Technicians"
	48		"Precision Production"
	49		"Transportation and Materials Moving"
	50		"Visual and Performing Arts"
	51		"Health Professions and Related Clinical Sciences"
	52		"Business, Management, Marketing and Related Support Services"
	53		"High School/Secondary Diploma and Certificat Programs"
	54		"History"
	55		"French Language and Literature/Letters"
	60		"Dental, Medical and Veterinary Residency Programs"
	;
#delimit cr
generate int cip_2digit = floor(CIP_CD/10000)
label values cip_2digit cip_2digit

tab cip_2digit, missing

# delimit ;
label define cip_4digit
	100		"Agriculture, General"
	101		"Agricultural Business and Management"
	102		"Agricultural Mechanization"
	103		"Agricultural Prodeuction Operations"
	106		"Applied Horticulture/Horticultural Business Services"
	109		"Animal Sciences"
	110		"Food Science and Technology"
	112		"Soil Sciences"
	199		"Agriculture, Agriculture Operations and Related Sciences, Other"
	301		"Natural Resources Conservation and Research"
	302		"Natural Resources Management and Policy"
	305		"Forestry"
	306		"Wildlife and Wildlands Science and Management"
	399		"Natural Resources and Conservation, Other"
	402		"Architecture (BArch, BA/BSc, MArch, MA/MSc, PhD)"
	403		"City/Urban, Community and Regional Planning"
	404		"Environmental Design/Architecture"
	409		"Architectural Technology/Technician"
	499		"Architectural and Related Services, Other"
	501		"Area Studies"
	502		"Ethnic, Cultural Minority and Gender Studies"
	599		"Area, Ethnic, Cultural and Gender Studies, Other"
	901		"Communication and Media Studies"
	904		"Journalism"
	907		"Radio, Television and Digital Communication"
	909		"Public Relations, Advertising and Applied Communication"
	999		"Communication, Journalism and Related Programs, Other"
	1001	"Communications Technoloy/Technician"
	1002	"Audiovisual Communications Technologies/Technicians"
	1003	"Graphic Communications"
	1101	"Computer and Information Sciences and Support Services, General"
	1102	"Computer Programming"
	1104	"Information Science/Studies"
	1105	"Computer Systems Analysis/Analyst"
	1107	"Computer Science"
	1108	"Computer Software and Media Applications"
	1110	"Computer/Information Technology Administration and Management"
	1199	"Computer and Information Sciences and Support Services, Other"
	1203	"Funeral Service and Mortuary Science"
	1204	"Cosmetology and Related Personal Grooming Services"
	1205	"Culinary Arts and Related Services"
	1299	"Personal and Culinary Services, Other"
	1301	"Education, General"
	1302	"Bilingual, Multilingual and Multicultural Education"
	1304	"Educational Administration and Supervision"
	1309	"Social and Philosophical Foundations of Education"
	1310	"Special Education and Teaching"
	1311	"Student Counselling and Personnel Services"
	1312	"Teacher Education and Professional Development, Specific Levels and Methods"
	1313	"Teacher Education and Perofesional Development, Specific Subject Areas"
	1314	"Teaching English or French as a SEcond or Foreign Language"
	1315	"Teaching Assistants/Aides"
	1399	"Education, Other"
	1401	"Engineering, General"
	1402	"Aerospace, Aeronautical and Astronautical Engineering"
	1403	"Agricultural/Biological Engineering and Bioengineering"
	1404	"Architectural Engineering"
	1405	"Biomedical/Medical Engineering"
	1407	"Chemical Engineering"
	1408	"Civil Engineering"
	1409	"Computer Engineering"
	1410	"Electrical, Electronics and Communications Engineering"
	1411	"Engineering Mechanics"
	1412	"Engineering Physics"
	1413	"Engineering Science"
	1414	"Environmental/Environmental Health Engineering"
	1419	"Mechancial Engineering"
	1421	"Mining and Mineral Engineering"
	1422	"Naval Architecture and Marine Engineering"
	1423	"Nuclear Engineering"
	1427	"Systems Engineering"
	1433	"Construction Engineering"
	1435	"Industrial Engineering"
	1436	"Manufacturing Engineering"
	1437	"Operations Research"
	1438	"Surveying Engineering"
	1499	"Engineering, Other"
	1500	"Engineering Technology, General"
	1501	"Architectural Engineering Technology/Technician"
	1502	"Civil Engineering Technology/Technician"
	1503	"Electrical and Electronic Engineering Technologies/Technicians"
	1504	"Electromechanical and Instrumentation and Maintenance Technologies/Technicians"
	1505	"Environmental Control Technologies/Technicians"
	1506	"Industrial Production Technologies/Technicians"
	1507	"Quality Control and Safety Technologies/Technicians"
	1508	"Mechanical Engineering Related Technologies/Technicians"
	1509	"Mining and Petroleum Technologies/Technicians"
	1510	"Construction Engineering Technology/Technician"
	1512	"Computer Engineering Technologies/Technicians"
	1513	"Drafting/Design Engineering Technologies/Technicians"
	1599	"Engineering Technologies/Technicians, Other"
	1601	"Linguistic, Comparative and Related Language Studies and Services"
	1609	"Romance Languages, Literatures and Lingusitics"
	1612	"Classics and Classical Languages, Literatures and Linguistics"
	1616	"Sign Language"
	1617	"Second Langauge Learning"
	1900	"Work and Family Studies"
	1901	"Family and Consumer Sciences/Human Sciences, General"
	1905	"Foods, Nutrition and Related Services"
	1906	"Housing and Human Environments"
	1907	"Human Development, Family Studies and Related Services"
	1909	"Apparel and Textiles"
	2100	"Technology Education/Industrial Arts Programs"
	2200	"Non-professional General Legal Studies (Undergraduate)"
	2201	"Law (LLB, JD, BCL)"
	2202	"Legal Research and Advanced Professional Studies (Post-LLB/JD)"
	2203	"Legal Support Services"
	2299	"Legal Professions and Studies, Other"
	2301	"English Language and Literature, General"
	2305	"English Creative Writing"
	2399	"English Language and Literature/Letters, Others"
	2401	"Liberal Arts and Sciences, General Studies and Humanities"
	2402	"UNKNOWN!!!!!"
	2501	"Library Science/Librarianship"
	2503	"Library Assistant/Technician"
	2599	"Library Science, Other"
	2601	"Biology, General"
	2602	"Biochemistry/Biophysics and Molecular Biology"
	2604	"Cell/Cellular Biology and Anatomical Sciences"
	2605	"Microbiological Sciences and Immunology"
	2607	"Zoology/Animal Biology"
	2608	"Genetics"
	2609	"Physiology, Pathology and Related Sciences"
	2610	"Pharmacology and Toxicology"
	2613	"Ecology, Evolution, Systematics and Population Biology"
	2699	"Biological and Biomedical Sciences, Other"
	2701	"Mathematics"
	2703	"Applied Mathematics"
	2705	"Statistics"
	2799	"Mathematics and Statistics, Other"
	2800	"Reserve Entry Scheme for Officers in the Armed Forces"
	2901	"Military Technologies"
	3001	"Biological and Physical Sciences"
	3005	"Peace Studies and Conflict Resolution"
	3006	"Systems Science and Theory"
	3008	"Mathematics and Computer Science"
	3010	"Biopsychology"
	3011	"Gerontology"
	3012	"Historic Preservation and Conservation"
	3013	"Medieval and Renaissance Studies"
	3014	"Museology/Museum Studies"
	3015	"Science, Technology and Society"
	3016	"Accounting and Computer Science"
	3017	"Behavioural Sciences"
	3018	"Natural Sciences"
	3019	"Nutrition Sciences"
	3020	"International/Global Studies"
	3021	"Holocaust and Related Studies"
	3022	"Classical and Ancient Studies"
	3023	"Intercultural/Multicultural and Diversity Studies"
	3024	"Neuroscience"
	3025	"Cognitive Science"
	3099	"Multidisciplinary/Interdisciplinary Studies, Other"
	3101	"Parks, Recreation and Leisure Studies"
	3103	"Parks, Recreation and Leisure Facilities Management"
	3105	"Health and Physical Education/Fitness"
	3199	"Parks, Recreation, Leisure and Fitness Studies, Other"
	3201	"Basic Skills"
	3300	"Citizenship Activities"
	3400	"Health-related Knowledge and Skills"
	3500	"Interpersonal and Social Skills"
	3601	"Leisure and Recreational Activities"
	3700	"Personal Awareness and Self-improvement"
	3801	"Philosophy, Logic and Ethics"
	3802	"Religion/Religious Studies"
	3899	"Philosophy and Religious Studies, Other"
	3902	"Bible/Biblical Studies"
	3903	"Missions/Missionary Studies and Missiology"
	3906	"Theological and Ministerial Studies"
	3907	"Pastoral Counselling and Specialized Ministries"
	3999	"Theology and Religious Vocations, Other"
	4001	"Physical Sciences, General"
	4002	"Astronomy and Astrophysics"
	4004	"Atmospheric Sciences and Meteorology"
	4005	"Chemistry"
	4006	"Geological and Earth Sciences/Geosciences"
	4008	"Physics"
	4099	"Physical Sciences, Other"
	4101	"Biology Technician/Biotechnology Laboratory Technician"
	4103	"Physical Science Technologies/Technicians"
	4199	"Science Technologies/Technicians, Other"
	4201	"Psychology, General"
	4206	"Counselling Psychology"
	4216	"Social Psychology"
	4299	"Psychology, Other"
	4301	"Criminal Justice and Corrections"
	4302	"Fire Protection"
	4399	"Security and Protective Services, Other"
	4400	"Human Services, General"
	4405	"Public Policy Analysis"
	4407	"Social Work"
	4499	"Public Administration and Social Service Professions, Other"
	4501	"Social Sciences, General"
	4502	"Anthropology"
	4503	"Archeology"
	4504	"Criminology"
	4505	"Demography and Population Studies"
	4506	"Economics"
	4507	"Geography and Cartography"
	4509	"International Relations and Affairs"
	4510	"Political Science and Government"
	4511	"Sociology"
	4512	"Urban Studies/Affairs"
	4599	"Social Sciences, Other"
	4600	"Construction Trades, General"
	4601	"Masonry/Mason"
	4602	"Carpentry/Carpenter"
	4603	"Electrical and Power Transmission Installers"
	4605	"Plumbing and Related Water Supply Services"
	4699	"Construction Trades, Other"
	4700	"Mechanic and Repairers, General"
	4701	"Electrical/Electronics Maintenance and Repair Technology"
	4702	"Heating, Air Conditioning, Ventilation and Refrigeration Maintenance Technology/Technician (HAC, HACR, HVAC, HVACR)"
	4703	"Heavy/Industrial Equipment Maintenance Technologies"
	4705	"Stationary Energy Sources Installer and Operator"
	4706	"Vehicle Maintenance and Repair Technologies"
	4799	"Mechanic and Repair Technologies/Technicians, Other"
	4803	"Leatherworking and Upholstery"
	4805	"Precision Metal Working"
	4807	"Woodworking"
	4808	"Boilermaking/Boilermaking"
	4899	"Precision Production, Other"
	4901	"Air Transportation"
	4902	"Ground Transportation"
	4903	"Marine Transportation"
	4999	"Transportation and Materials Moving, Other"
	5001	"Visual and Performing Arts, General"
	5002	"Crafts/Craft Design, Folk Art and Artisanry"
	5003	"Dance"
	5004	"Design and Applied Arts"
	5005	"Drama/Theatre Arts and Stagecraft"
	5006	"Film/Video and Photographic Arts"
	5007	"Fine Arts and Art Studies"
	5009	"Music"
	5099	"Visual and Performing Arts, Other"
	5100	"Health Professions/Allied Health/Health Sciences, General"
	5101	"Chiropractic (DC)"
	5102	"Communication Disorders Sciences and Services"
	5104	"Dentistry (DDS, DMD)"
	5106	"Dental Support Services and Allied Professions"
	5107	"Health and Medical Administrative Services"
	5108	"Allied Health and Medical Assisting Services"
	5109	"Allied Health Diagnostic, Intervention and Treatment Professions"
	5110	"Clinical/Medical Laboratory Science and Allied Professions"
	5111	"Health/Medical Preparatory Programs"
	5112	"Medicine (MD)"
	5114	"Medical Scientist (MSc, PhD)"
	5115	"Mental and Social Health Services and Allied Professions"
	5116	"Nursing"
	5117	"Optometry (OD)"
	5120	"Pharmacy, Pharmaceutical Sciences and Administration"
	5122	"Public Health"
	5123	"Rehabilitation and Therapeutic Professions"
	5124	"Veterinary Medicine (DVM)"
	5126	"Health Aides/Attendants/Orderlies"
	5131	"Dietetics and Clinical Nutrition Services"
	5133	"Alternative and Complementary Medicine and Medical Systems"
	5135	"Somatic Bodywork and Related Therapeutic Services"
	5201	"Business, Management, Marketing and Related Support Services"
	5199	"Health Professions and Related Clinical Sciences, Other"
	5201	"Business/Commerce, General"
	5202	"Business Administration, Management and Operations"
	5203	"Accounting and Related Services"
	5204	"Business Operations"
	5205	"Business/Corporate Communications"
	5206	"Business/Managerial Economics"
	5207	"Entrepreneurial and Small Business Operations"
	5208	"Finance and Financial Management Services"
	5209	"Hospitality Administration/Management"
	5210	"Human Resources Management and Services"
	5211	"International Business/Trade/Commerce"
	5212	"Management Information Systems and Services"
	5213	"Management Sciences and Quantitative Methods"
	5214	"Marketing"
	5215	"Real Estate"
	5216	"Taxation"
	5217	"Insurance"
	5218	"General Sales, Merchandising and Related Marketing Operations"
	5219	"Specialized Sales, Merchandising and Marketing Operations"
	5220	"Construction Management"
	5299	"Business, Management, Marketing and Related Support Services, Other"
	5300	"High School/Secondary Diploma and Certificat Programs"
	5401	"History"
	5501	"French Language and Literature, General"
	5506	"French Literature (France and the French Community)"
	5508	"French Technical and Business Writing"
	6001	"Dental Residency Programs"
	6002	"Medical Residency Programs"
	6003	"Veterinary Residency Programs"
	;
#delimit cr
generate int cip_4digit = floor(CIP_CD/100)
label values cip_4digit cip_4digit

tab cip_4digit, missing

recode cip_2digit ///
	(13 = 1 "Education") ///
	(50 = 2 "Visual and Performing Arts") ///
	(4 5 9 16 19 23 24 25 38 39 44 45 54 55 = 3 "Arts") ///
	(52 = 4 "Business and Commerce") ///
	(1 2 10 11 26 27 40 41 = 5 "Sciences") ///
	(3 14 15 46 47 48 49 = 6 "Architecture and Engineering") ///
	(31 34 36 42 51 = 7 "Health and Fitness") ///
	(12 21 22 28 29 30 32 33 35 37 43 53 60 98/max = .o) ///
	, generate(prgm7)
tab prgm7, missing

capture confirm variable CIP_FRENCH_DESC
if !_rc {
	my_encode CIP_FRENCH_DESC, generate(cip_french_desc)
}
my_encode CIP_ENGLISH_DESC, generate(cip_english_desc)

// POST_CD
my_encode POST_CD, generate(post_cd)

tabulate post_cd, missing

// COOP_IND
label define coop_ind_codes 0 "N" 1 "Y"
my_encode COOP_IND, generate(coop_ind) label(coop_ind_codes)
label define coop_ind_en_label 0 "No Co-Op" 1 "Co-Op Program"
label values coop_ind coop_ind_en_label

tabulate coop_ind

// USED_TONGUE
label define used_tongue_codes 0 "E" 1 "F"
my_encode USED_TONGUE, generate(used_tongue) label(used_tongue_codes)
label define used_tongue_en_label 0 "English" 1 "French"
label values used_tongue used_tongue_en_label

// CONT2
my_encode CONT2, generate(cont2)
recode cont2 (1 = 1) (. = 0)
label define cont 0 "Leave" 1 "Continue"
label values cont2 cont

tab cont2, missing

// CONT3
my_encode CONT3, generate(cont3)
recode cont3 (1 = 1) (. = 0)
replace cont3 = . if cohort==13 // 2009 observations don't have cont3 yet.
label values cont3 cont

tab cont3, missing

// Course Grades
label define grade_codes 1 "A+", add
label define grade_codes 2 "A", add
label define grade_codes 3 "A-", add
label define grade_codes 4 "B+", add
label define grade_codes 5 "B", add
label define grade_codes 6 "C+", add
label define grade_codes 7 "C", add
label define grade_codes 8 "D+", add
label define grade_codes 9 "D", add
label define grade_codes 10 "E", add
label define grade_codes 11 "F", add
label define grade_codes 12 "ABS", add
label define grade_codes 13 "AUD", add
label define grade_codes 14 "DR", add
label define grade_codes 15 "DFR", add
label define grade_codes 16 "INC", add
label define grade_codes 17 "S", add
label define grade_codes 18 "NNR", add
label define grade_codes 19 "NS", add
label define grade_codes .a "ABS", add
label define grade_codes .b "AUD", add
label define grade_codes .c "DR", add
label define grade_codes .e "DFR", add
label define grade_codes .f "INC", add
label define grade_codes .g "S", add
label define grade_codes .h "NNR", add
label define grade_codes .i "NS", add

foreach i of varlist MAT1320 MAT1720 MAT1330 MAT1730 MAT1300 MAT1700 ENG1100 ENG1112 FRA1528 FRA1538 FRA1710 PHI1101 PHI1501 {
	local lower_i = lower("`i'")
	my_encode `i', generate(`lower_i') label(grade_codes)
	tabulate `lower_i', missing
} 

foreach i of varlist MAT1320 MAT1720 MAT1330 MAT1730 MAT1300 MAT1700 ENG1100 ENG1112 FRA1528 FRA1538 FRA1710 PHI1101 PHI1501 {
	local lower_i = lower("`i'")
	tostring `i'_SESSION, replace
	generate `lower_i'_session = ym(real(substr(`i'_SESSION,1,4)),real(substr(`i'_SESSION,5,1)))
	format %tm `lower_i'_session
}

foreach i of varlist mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501 {
	recode `i' (12=.a) (13=.b) (14=.c) (15=.e) (16=.f) (17=.g) (18=.h) (19=.i)
	label values `i' grade_codes
}

// Highest in each category
egen math_highest = rowmin(mat1320 mat1720 mat1330 mat1730 mat1300 mat1700)
label values math_highest grade_codes
tabulate math_highest, missing

egen eng_highest = rowmin(eng1100 eng1112)
label values eng_highest grade_codes
tabulate eng_highest, missing

egen fre_highest = rowmin(fra1528 fra1538 fra1710)
label values fre_highest grade_codes
tabulate fre_highest, missing

egen phil_highest = rowmin(phi1101 phi1501)
label values phil_highest grade_codes
tabulate phil_highest, missing

egen enfr_highest = rowmax(eng1100 eng1112 fra1528 fra1538 fra1710)
label values enfr_highest grade_codes
tabulate enfr_highest, missing

egen any_highest = rowmin(mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501)
label values any_highest grade_codes
tabulate any_highest, missing

// Lowest in each category
egen math_lowest = rowmax(mat1320 mat1720 mat1330 mat1730 mat1300 mat1700)
label values math_lowest grade_codes
tabulate math_highest, missing

egen eng_lowest = rowmax(eng1100 eng1112)
label values eng_lowest grade_codes
tabulate eng_lowest, missing

egen fre_lowest = rowmax(fra1528 fra1538 fra1710)
label values fre_lowest grade_codes
tabulate fre_lowest, missing

egen phil_lowest = rowmax(phi1101 phi1501)
label values phil_lowest grade_codes
tabulate phil_lowest, missing

egen enfr_lowest = rowmin(eng1100 eng1112 fra1528 fra1538 fra1710)
label values enfr_lowest grade_codes
tabulate enfr_lowest, missing

egen any_lowest = rowmax(mat1320 mat1720 mat1330 mat1730 mat1300 mat1700 eng1100 eng1112 fra1528 fra1538 fra1710 phi1101 phi1501)
label values any_lowest grade_codes
tabulate any_lowest, missing

// Admission Average
rename ADMISSION_AVG admission_avg
capture confirm numeric variable admission_avg
if _rc {
	// admission average is not numeric -- convert.
	replace admission_avg = "" if substr(admission_avg,1,2)=="NA"
	replace admission_avg = "" if substr(admission_avg,1,3)=="N\A"
	replace admission_avg = "" if substr(admission_avg,1,3)=="N/A"
	replace admission_avg = "" if substr(admission_avg,1,3)=="N.A"
	replace admission_avg = "" if substr(admission_avg,1,3)=="ADM"
	destring admission_avg, replace ignore("%") float
}

rename PERSON_ID person_id
rename ECON_REGION_ORIGIN econ_region_origin
rename POSTAL_CD postal_cd
capture clonevar CGPA = SGPA
rename CGPA cgpa
rename CIP_CD cip_cd
rename YEAR_OF_STUDY year_of_study
rename SESSION_1_AWARDS session_1_awards
rename GOV_GRANT_SESSION_1 gov_grant_s1
rename GOV_LOAN_SESSION_1 gov_loan_s1
rename SESSION_2_AWARDS session_2_awards
rename GOV_GRANT_SESSION_2 gov_grant_s2
rename GOV_LOAN_SESSION_2 gov_loan_s2
rename PROVINCE new_province

label variable person_id "Personal Identifier"
label variable imstat "Immigration Status"
label variable econ_region_origin "Economic Region of Origin"
label variable postal_cd "Postal Code"
label variable admission_avg "Admission Average"
label variable cgpa "University GPA"
label variable year_of_study "Year of Study"
label variable apptype "Application Type"
label variable fsa1 "First Letter of Postal Code"
label variable province "Province (from Postal Code)"
label variable county "County of Origin"
label variable credential_cd "Credential Code"
label variable j_credential_cd "Credential Code (J)"
label variable kind_of_program_cd "Kind of Program"
label variable mother_tongue "Mother Tongue"
label variable princ_teaching_lng "Principal Teaching Language"
label variable main_subject1_cd "Main Subject 1"
label variable main_subject2_cd "Main Subject 2"
label variable j_main_subject1_cd "Main Subject 1 (J)"
label variable ug_spec_level_cd "University Specific Level Code"
label variable er_province "Province (from Economic Region)"
label variable session_cd "Session"
label variable session_date "Session date"
label variable cohort "Cohort"
label variable entry_month "Month of University Entry"
label variable entry_day "Day of University Entry"
label variable gender "Gender"
label variable birth_dt "Birth Date"
label variable birth_year "Birth Year"
label variable age_days "Age (in days)"
label variable age_float "Age (in years, floating)"
label variable age "Entry Age"
label variable primary_org_cd "Primary Organizational Code"
label variable cip_cd "CIP Code (6 Digit)"
label variable cip_2digit "CIP Code (2 Digit)"
label variable cip_4digit "CIP Code (4 Digit)"
label variable prgm7 "Program (7 Categories)"
capture label variable cip_french_desc "Program (French Description)"
label variable cip_english_desc "Program (English Description)"
label variable post_cd "Post Code (related to program)"
label variable coop_ind "Co-Op Program"
label variable used_tongue "Correspondence Language"
label variable cont2 "Continued to Second Year"
label variable cont3 "Continued to Third Year"
label variable mat1320 "MAT1320 Grade"
label variable mat1720 "MAT1720 Grade"
label variable mat1330 "MAT1330 Grade"
label variable mat1730 "MAT1730 Grade"
label variable mat1300 "MAT1300 Grade"
label variable mat1700 "MAT1700 Grade"
label variable eng1100 "ENG1100 Grade"
label variable eng1112 "ENG1112 Grade"
label variable fra1528 "FRA1528 Grade"
label variable fra1538 "FRA1538 Grade"
label variable fra1710 "FRA1710 Grade"
label variable phi1101 "PHI1101 Grade"
label variable phi1501 "PHI1501 Grade"
label variable math_highest "Highest Math Grade"
label variable eng_highest "Highest English Grade"
label variable fre_highest "Highest French Grade"
label variable phil_highest "Highest Philosophy Grade"
label variable any_highest "Highest Grade"
label variable math_lowest "Lowest Math Grade"
label variable eng_lowest "Lowest English Grade"
label variable fre_lowest "Lowest French Grade"
label variable phil_lowest "Lowest Philosophy Grade"
label variable any_lowest "Lowest Grade"
label variable mat1320_session "MAT1320 Session"
label variable mat1720_session "MAT1720 Session"
label variable mat1330_session "MAT1330 Session"
label variable mat1730_session "MAT1730 Session"
label variable mat1300_session "MAT1300 Session"
label variable mat1700_session "MAT1700 Session"
label variable eng1100_session "ENG1100 Session"
label variable eng1112_session "ENG1112 Session"
label variable fra1528_session "FRA1528 Session"
label variable fra1538_session "FRA1538 Session"
label variable fra1710_session "FRA1710 Session"
label variable phi1101_session "PHI1101 Session"
label variable phi1501_session "PHI1501 Session"
label variable session_1_awards "Session 1 Awards"
label variable gov_grant_s1 "Session 1 Government Grant"
label variable gov_loan_s1 "Session 1 Government Loan"
label variable session_2_awards "Session 2 Awards"
label variable gov_grant_s2 "Session 2 Government Grant"
label variable gov_loan_s2 "Session 2 Government Loan"
label variable new_province "Province (String)"

compress province county credential_cd j_credential_cd kind_of_program_cd mother_tongue
compress princ_teaching_lng main_subject1_cd main_subject2_cd j_main_subject1_cd ug_spec_level_cd

compress er_province session_cd cohort gender primary_org_cd cip_2digit cip_4digit prgm7
capture compress  cip_french_desc
compress cip_english_desc post_cd coop_ind used_tongue cont2 cont3
compress mat* eng* fra* phi* math_highest eng_highest phil_highest any_highest
compress year_of_study session_*_awards gov_grant_s* gov_loan_s*

drop SESSION_CD
drop COHORT
drop GENDER
drop BIRTH_DT
drop COUNTY_CD
drop DIR_ENTRY_APPTYPE
drop POST_CD
drop KIND_OF_PROGRAM_CD
drop CREDENTIAL_CD
drop J_CREDENTIAL_CD
drop MAIN_SUBJECT1_CD
drop MAIN_SUBJECT2_CD
drop J_MAIN_SUBJECT1_CD
drop J_MAIN_SUBJECT2_CD
drop UG_SPEC_LEVEL_CD
drop PRIMARY_ORG_CD
capture drop CIP_FRENCH_DESC
drop CIP_ENGLISH_DESC
drop COOP_IND
drop PRINC_TEACHING_LNG
drop USED_TONGUE
drop MOTHER_TONGUE
drop MAT1300
drop MAT1320
drop MAT1700
drop MAT1720
drop MAT1330
drop MAT1730
drop ENG1100
drop ENG1112
drop FRA1528
drop FRA1538
drop FRA1710
drop PHI1101
drop PHI1501
drop CONT2
drop CONT3
capture drop SGPA
drop MAT*_SESSION
drop ENG*_SESSION
drop FRA*_SESSION
drop PHI*_SESSION

describe, fullnames

save "`workdatapath'labeled_retention_data", replace

include do/footer.do

