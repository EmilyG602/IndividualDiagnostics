if c(os) == "Windows" { 
  global projdir R:/Projects/missing_data_and_propensity_scores/PhD_Analyses
}
else {
  global projdir ~/rdrive/Projects/missing_data_and_propensity_scores
}
global taskdir   $projdir/PhD_Chapter3/
global logdir   $taskdir/output
global dodir    $taskdir/scripts
global datadir  $taskdir/datasets_generated
global resultsdir $taskdir/datasets_results
global texdir $logdir/tex_files

clear
set more off

set seed 03102017

/*
RUN THIS DO FILE BEFORE RUNNING THE ANALYSIS FILE. 
This do file generates the treatment model then estimates two sets of propensity
scores; correct and misspecified. Data are then matched, weighted and stratified
by propensity score. This do file estimates the propensity scores (correct and 
misspecified) then matches, weights and stratifies by each propensity score. 
A dataset is generated which contains the propensity scores, indicator variables 
for if observations are in matched sets, ipt weights (trimmed and not trimmed), 
overlap weights and variables (pd*) identifying the strata. 

Data is saved as analyse.dta (but this dataset is replaced everytime a prepare 
do file is run). Run the analysis do file after this. 

Scenario specific code must be commented in before running this file. 
*/
use "$datadir/generated_data.dta"

rename x_s4 x8

quietly{ 
	
	
	* Comment in for smaller sample sizes
	/*forvalues i = 1(1)1000 {
		preserve
		keep if dataset == `i'
		keep in 1/500 /* Define sample size here*/ 
		tempfile ss500`i'
		save "`ss500`i''"
		restore
	}

	use "`ss5001'", clear
	forvalues i = 2(1)1000{
		capture append using "`ss500`i''"
		}
	*/} 

*Comment in scenario specific propensity score  

*Scenario 1
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 


*Scenario 2
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.5*x8 /*R^2 = 20%*/
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.25*x8 /*R^2 = 10%*/ 
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.125*x8 /*R^2 = 5%*/


*Scenario 3
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.38*x8 /*R^2 = 20%*/
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.19*x8 /*R^2 = 10%*/
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.095*x8 /*R^2 = 5%*/


*Scenario 4
gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 3.5*x8 /*R^2 = 20%*/
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 1.75*x8 /*R^2 = 10%*/
*gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.875*x8 /*R^2 = 5%*/ 
/*
*Scenario 5
gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 1.2*x8 /*R^2 = 20%*/
gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.6*x8 /*R^2 = 10%*/
gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.3*x8 /*R^2 = 5%*/ 

*Scenario 6
gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.4*x8 /*R^2 = 20%*/
gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.2*x8 /*R^2 = 10%*/
gen lpt = 3.7 + 0.99*x1 +0.8*x2 -0.95*x3 + 0.4*x4 - 0.08*x5 + 0.2*x6 + 0.35*x7 + 0.1*x8 /*R^2 = 5%*/ 
*/

gen pt = exp(lpt) / (1+exp(lpt))
gen t = uniform() < pt

*Scenario 1
//global ps1 x1 x2 x3 x4 x5 x6 x7
//global ps2 x2 x3 x4 x5 x6 x7

*Scenarios 2-6
global ps1 x1 x2 x3 x4 x5 x6 x7 x8 
global ps2 x1 x2 x3 x4 x5 x6 x7 


quietly{

	forvalues i = 1(1)1000{

		preserve
	
		keep if dataset == `i'
		
		logistic t $ps1

			
		predict lp1 // gives actual propensity scores
		predict lp1a, xb // gives the logit of the propensity scores
				
		*sum lp1a
		*local cal=0.2*r(sd)
		fgmatch t lp1a, set(set1) diff(diff1) pwt(matched1)
				
		xtile pd1 = lp1, n(10)
		xtile pd1b = lp1, n(20)
		
		propwt t lp1, alt gen(_ovl1)
		propwt t lp1, ipt gen(_wt1)
		sum ipt_wt1, d
		local trim=r(p95)
		gen ipt_wt1b = ipt_wt1
		replace ipt_wt1b = `trim' if ipt_wt1b > `trim'
		
		logistic t $ps2
		predict lp2 // gives actual propensity scores
		predict lp2a, xb // gives the logit of the propensity scores
		
		*sum lp2a
		*local cal=0.2*r(sd)
		fgmatch t lp2a, set(set2) diff(diff2) pwt(matched2)
				
		xtile pd2 = lp2, n(10)
		xtile pd2b = lp2, n(20)
			
		propwt t lp2, alt gen(_ovl2)
		propwt t lp2, ipt gen(_wt2)
		sum ipt_wt2, d
		local trim=r(p95)
		gen ipt_wt2b = ipt_wt1
		replace ipt_wt2b = `trim' if ipt_wt2b > `trim'
	
	
		tempfile props`i'
		save "`props`i''"

		restore
	}

}

use "`props1'", clear
forvalues i = 2(1)1000{
	capture append using "`props`i''"
	}


save "$resultsdir/analyse.dta", replace

