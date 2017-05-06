********************************************************************************
********************************************************************************
clear all
set more off

// Author: Chris Miyinzi Mwungu
// Date: May 06, 2017
// Created using Stata/SE 14.1

*Setting Working Directory
cd "C:\Users\cmwungu\Desktop\Reshaping and Merging data"

*Importing the CSV file
import delimited "dataset_wide.csv"

*Reshaping from wide to long
reshape long amount_ton_n_ amount_ton_p_ amount_ton_k_, i(id_event) j(rep)string

*Assigning Variable labels 
la var id_event "Household ID"
la var amount_ton_n_ "Nitrogen Amount"
la var amount_ton_p_ "Phosphorus Amount"
la var amount_ton_k_ "Potassium Amount"

*Renaming ID Variable
rename id_event ID

*Collapsing to compute total amount of each fertilizer
collapse (sum) amount_ton_n_ amount_ton_p_ amount_ton_k_, by(ID)
save dataset_wide
clear all

*Importing the Yield CSV file and merge it with 
import delimited "yield_inf.csv"

*Renaming ID Variable
rename id ID

*Assigning Variable labels 
la var ID "Household ID"
la var variety "Seed Variety"
la var yield "Amount Harvested in Tonnes"

*Destring Variety
replace variety ="1" if variety == "var1"
replace variety ="2" if variety == "var2"
replace variety ="3" if variety == "var3"
destring variety,replace
la define Var 1 Var1 2 Var2 3 Var3
la values variety Var
save yield_info

*Load dataset_wide data
clear all
use dataset_wide

*Merging data 
merge 1:1 ID using yield_info
order ID variety
drop _merge
save merged

*Saving in Excel
export excel merged.xls, firstrow(varlabels)

********************************************************************************
*Collapsing from long to wide
clear all

*Importing the Yield CSV file and merge it with 
import delimited "dataset_long.csv"

ds id_event time,not
return list
reshape wide `r(varlist)' , i( id_event) j( time)
export excel reshaped_to_wide.xls, firstrow(variables)

********************************************************************************
* END OF CODE ******************************************************************
********************************************************************************












