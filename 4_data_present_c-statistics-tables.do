*Set directory
global resultsdir R:/Projects/missing_data_and_propensity_scores/PhD_Analyses/PhD_Chapter3/datasets_results

* c-statistic tables with varying sample size
clear
set more off

tempfile roc
postfile roc ss sd t perc_red ks ovl levy cpks km wkm using "`roc'", replace

foreach scen in  1 2 3 4 5 6 {

	foreach ss of numlist 5000 2000 500{
	
		use "$resultsdir/S`scen'_overlap_20_`ss'.dta", clear
		
		replace ps = 0 if ps == 1
		replace ps = 1 if ps == 2
			
		foreach var of varlist sd t perc_red ks ovl levy cpks km wkm {
			replace `var' = round(`var',0.00001)
			capture logistic ps `var' 
			if e(converged)==1{
				lroc 
				local c_`scen'_`var'_`ss' = r(area)
			}
			else{
				local c_`scen'_`var'_`ss' = 1000
			}
		}
	}

	post roc (5000) (`c_`scen'_sd_5000') (`c_`scen'_t_5000') (`c_`scen'_perc_red_5000')	(`c_`scen'_ks_5000')	(`c_`scen'_ovl_5000')	(`c_`scen'_levy_5000')	(`c_`scen'_cpks_5000')	(`c_`scen'_km_5000') (`c_`scen'_wkm_5000')	
	post roc (2000) (`c_`scen'_sd_2000') (`c_`scen'_t_2000') (`c_`scen'_perc_red_2000')	(`c_`scen'_ks_2000')	(`c_`scen'_ovl_2000')	(`c_`scen'_levy_2000')	(`c_`scen'_cpks_2000')	(`c_`scen'_km_2000') (`c_`scen'_wkm_2000')	
	post roc (500)  (`c_`scen'_sd_500')  (`c_`scen'_t_500')  (`c_`scen'_perc_red_500')	(`c_`scen'_ks_500')	    (`c_`scen'_ovl_500')	(`c_`scen'_levy_500')	(`c_`scen'_cpks_500')	(`c_`scen'_km_500')	 (`c_`scen'_wkm_500')	
}
postclose roc
		
use "`roc'", clear
format *  %6.3f
egen Scenario = seq(), f(1) t(6) b(3)
listtex Scenario ss sd t perc_red ks ovl levy ks km wkm using "R:/Projects/missing_data_and_propensity_scores/PhD_Analyses/PhD_Chapter3/manuscript/tables/c_overlap_ss.tex", replace end(\\)

* c-statistic tables with varying R^2
clear
set more off

tempfile roc
postfile roc r sd t perc_red ks ovl levy cpks km wkm using "`roc'", replace

foreach scen in  2 3 4 5 6 {

	foreach r of numlist 20 10 5{
	
		use "$resultsdir/S`scen'_IPTW_`r'_5000.dta", clear
		
		replace ps = 0 if ps == 1
		replace ps = 1 if ps == 2
			
		foreach var of varlist sd t perc_red ks ovl levy cpks km wkm {
			replace `var' = round(`var',0.00001)
			capture logistic ps `var' 
			if e(converged)==1{
				lroc 
				local c_`scen'_`var'_`r' = r(area)
			}
			else{
				local c_`scen'_`var'_`r' = 1000
			}
		}
	}

	post roc (20) (`c_`scen'_sd_20') (`c_`scen'_t_20') (`c_`scen'_perc_red_20')	(`c_`scen'_ks_20')	(`c_`scen'_ovl_20')	(`c_`scen'_levy_20')	(`c_`scen'_cpks_20')	(`c_`scen'_km_20') (`c_`scen'_wkm_20')	
	post roc (10) (`c_`scen'_sd_10') (`c_`scen'_t_10') (`c_`scen'_perc_red_10')	(`c_`scen'_ks_10')	(`c_`scen'_ovl_10')	(`c_`scen'_levy_10')	(`c_`scen'_cpks_10')	(`c_`scen'_km_10') (`c_`scen'_wkm_10')	
	post roc (5)  (`c_`scen'_sd_5')  (`c_`scen'_t_5')  (`c_`scen'_perc_red_5')	(`c_`scen'_ks_5')	(`c_`scen'_ovl_5')	(`c_`scen'_levy_5')	    (`c_`scen'_cpks_5')	    (`c_`scen'_km_5')  (`c_`scen'_wkm_5')	
}
postclose roc
		
use "`roc'", clear
format *  %6.3f
egen Scenario = seq(), f(2) t(6) b(3)
listtex Scenario r sd t perc_red ks ovl levy ks km wkm using "R:/Projects/missing_data_and_propensity_scores/PhD_Analyses/PhD_Chapter3/manuscript/tables/c_IPTW_r.tex", replace end(\\)


