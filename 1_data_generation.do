if c(os) == "Windows" { 
  global projdir R:/Projects/missing_data_and_propensity_scores/PhD_Analyses
}
else {
  global projdir ~/rdrive/Projects/missing_data_and_propensity_scores/PhD_Analyes
}
global taskdir   $projdir/PhD_Chapter3/
global logdir   $taskdir/output
global dodir    $taskdir/scripts
global datadir  $taskdir/datasets_generated
global resultsdir $taskdir/datasets_results
global texdir $logdir/tex_files

clear
set more off

log using "$logdir/data_generation.log", text replace name(generate)

display "Generate datasets run on $S_DATE at $S_TIME"

set seed 16012017

quietly{

	forvalues dataset = 1(1)1000{ 
	
		set obs 5000

		gen dataset = `dataset'

		*Generate confounders
		gen x1 = uniform() < 0.25
		gen x2 = uniform() < 0.5
		gen x3 = uniform() < 0.75

		gen x4 = rnormal()
		gen x5 = rnormal(60,5)

		gen x6 = rgamma(1,2)
		gen x7 = floor(4*uniform()+1)
		
		*Generate Scenario specific variables:
		gen x_s2 = 0.4*(3.5^x4-1)
		gen x_s3 = x4*x4 
		gen x_s4 = x1*x2
		gen x_s5 = x1*x4
		gen x_s6 = x4*x6
	
	
		tempfile s1_`dataset'
	
		save "`s1_`dataset''"
	
		drop *
	
	}

}

use "`s1_1'", 

forvalues dataset = 2(1)1000{

		append using "`s1_`dataset''"
		
		}
		
save "$datadir/generated_data.dta", replace



log close generate 


