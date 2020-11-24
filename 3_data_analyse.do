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


/* RUN APPROPRIATE PREPARE FILE BEFORE RUNNING AN ANALYSIS DO FILE.
This do file estimates the following balance measures:
- standardised difference
- f statistic
- t statistic
- percent reduction in prevalence 
- KS statistic 
- overlapping coefficient
- levy distance
- cumulative prevalence diagnostics 

in X4 (Scenarios 1-2B) or X8 (Scenarios 3-5) for both the correct and
misspecificed propensity scores estimated in the prepare file.

Results are saved in six different datasets: (1) matched data (2) stratified 
10 strata (3) IPT weights (4) overlap weights (5) stratified with 20 strata
and (6) IPT trimmed weights  */ 

use "$resultsdir/analyse.dta"


*Results are named by scenario number, PS method, R^2 and sample size. 
*Postfile datasets should be named appropriately before running do file. 
*postfile matching ps x sd f t perc_red ks ovl levy cpks km wkm using "$resultsdir/S4_match_20_5000.dta", replace every(10)
*postfile strata ps x  sd f t perc_red ks ovl levy   cpks km wkm  using "$resultsdir/S4_strata_20_5000.dta", replace every(10)
*postfile weighted ps x sd f t perc_red ks ovl levy cpks km wkm  using "$resultsdir/S4_IPTW_20_5000.dta", replace every(10)
postfile weighted_ovl ps  x sd f t perc_red ks ovl levy cpks km wkm  using "$resultsdir/S4_overlap_20_5000.dta", replace every(10)
*postfile strataB ps x  sd f t perc_red ks ovl levy cpks km wkm  using "$resultsdir/S4_strataB_20_5000.dta", replace every(10)
*postfile weightedB ps x  sd f t perc_red ks ovl levy cpks km wkm using  "$resultsdir/S4_IPTWB_20_5000.dta", replace every(10)

*Comment in appropriate definition of j:

local j = 8

quietly{ 

	forvalues k = 1(1)2{
	
		forvalues i = 1(1)1000 {
		
			preserve
			keep if dataset == `i'
			
			*SD and F statistic	
			*pbalchk t x`j', wt(matched`k') f
			*mat sd = r(smeandiff)
			*mat f = r(fmat)
			*local sd_m`j'_`k' = sd[1,1]
			*local f_m`j'_`k' = f[1,1]
			
			*mat drop sd f 
	
			*pbalchk t x`j', strata(pd`k') f
			*mat sd = r(smeandiff)
			*mat f = r(fmat)
			*local sd_s`j'_`k' = sd[1,1]
			*local f_s`j'_`k' = f[1,1]
				
			*mat drop sd f
		
			*pbalchk t x`j', wt(ipt_wt`k') f
			*mat sd = r(smeandiff)
			*mat f = r(fmat)
			*local sd_w`j'_`k' = sd[1,1]
			*local f_w`j'_`k' = f[1,1]
			
			*mat drop sd f
			
			pbalchk t x`j', wt(alt_ovl`k') f
			mat sd = r(smeandiff)
			mat f = r(fmat)
			local sd_o`j'_`k' = sd[1,1]
			local f_o`j'_`k' = f[1,1]
			
			mat drop sd f
			
			*pbalchk t x`j', strata(pd`k'b) f
			*mat sd = r(smeandiff)
			*mat f = r(fmat)
			*local sd_s`j'_`k'b = sd[1,1]
			*local f_s`j'_`k'b = f[1,1]
				
			*mat drop sd f
		
			*pbalchk t x`j', wt(ipt_wt`k'b) f
			*mat sd = r(smeandiff)
			*mat f = r(fmat)
			*local sd_w`j'_`k'b = sd[1,1]
			*local f_w`j'_`k'b = f[1,1]
			
			*mat drop sd f
			
			*t-statistic 
			*regress x`j' t [pw=matched`k'] 
			*local t_m`j'_`k' = _b[t]/_se[t]
			
			*regress x`j' t i.pd`k'
			*local t_s`j'_`k' = _b[t]/_se[t] 
			
			*regress x`j' t [pw=ipt_wt`k']
			*local t_w`j'_`k' = _b[t]/_se[t]
				
			regress x`j' t [pw=alt_ovl`k']
			local t_o`j'_`k' = _b[t]/_se[t]
				
			regress x`j' t i.pd`k'b
			local t_s`j'_`k'b = _b[t]/_se[t] 
			
			*regress x`j' t [pw=ipt_wt`k'b]
			*local t_w`j'_`k'b = _b[t]/_se[t] 
			
			*Percent reduction in bias
			regress x`j' t 
			local undiff = _b[t]
			*regress x`j' t [pw=matched`k']
			*local diff = _b[t]
			*local perc_red_m`j'_`k' = abs((`diff' - `undiff')/(`undiff'))*100

			*regress x`j' t i.pd`k'
			*local diff = _b[t]
			*local perc_red_s`j'_`k' = abs((`diff' - `undiff')/(`undiff'))*100
			
			*regress x`j' t [pw=ipt_wt`k']
			*local diff = _b[t]
			*local perc_red_w`j'_`k' = abs((`diff' - `undiff')/(`undiff'))*100
				
			regress x`j' t [pw=alt_ovl`k']
			local diff = _b[t]
			local perc_red_o`j'_`k' = abs((`diff' - `undiff')/(`undiff'))*100
				
			*regress x`j' t i.pd`k'b
			*local diff = _b[t]
			*local perc_red_s`j'_`k'b = abs((`diff' - `undiff')/(`undiff'))*100
			
			*regress x`j' t [pw=ipt_wt`k'b]
			*local diff = _b[t]
			*local perc_red_w`j'_`k'b = abs((`diff' - `undiff')/(`undiff'))*100
			
			
			*K-S statistic
			*wks x`j', by(t) wt(matched`k')
			*local ks_m`j'_`k' = r(D)
			
			*wks x`j', by(t) strata(pd`k')
			*local ks_s`j'_`k' = r(D)
			
			*wks x`j', by(t) wt(ipt_wt`k')
			*local ks_w`j'_`k' = r(D)
				
			wks x`j', by(t) wt(alt_ovl`k')
			local ks_o`j'_`k' = r(D)
				
			*wks x`j', by(t) strata(pd`k'b)
			*local ks_s`j'_`k'b = r(D)
			
			*wks x`j', by(t) wt(ipt_wt`k'b)
			*local ks_w`j'_`k'b = r(D)
			
			*Overlapping coefficient 
			*ovl x`j', by(t) wt(matched`k')
			*local ovl_m`j'_`k' = r(ovl)
			
			*ovl x`j', by(t) strata(pd`k')
			*local ovl_s`j'_`k' = r(ovl)
			
			*ovl x`j', by(t) wt(ipt_wt`k')
			*local ovl_w`j'_`k' = r(ovl)
				
			ovl x`j', by(t) wt(alt_ovl`k')
			local ovl_o`j'_`k' = r(ovl)
				
			*ovl x`j', by(t) strata(pd`k'b)
			*local ovl_s`j'_`k'b = r(ovl)
			
			*ovl x`j', by(t) wt(ipt_wt`k'b)
			*local ovl_w`j'_`k'b = r(ovl)

			*Levy Distance
			*levy2 t x`j', wt(matched`k') nodots
			*local levy_m`j'_`k' = r(distance) 
					
			*levy2 t x`j', strata(pd`k') nodots
			*local levy_s`j'_`k' = r(distance)
					
			*levy2 t x`j', wt(ipt_wt`k') nodots
			*local levy_w`j'_`k' = r(distance)
				
			levy2 t x`j', wt(alt_ovl`k') nodots
			local levy_o`j'_`k' = r(distance)
				
			*levy2 t x`j', strata(pd`k'b) nodots
			*local levy_s`j'_`k'b = r(distance)
					
			*levy2 t x`j', wt(ipt_wt`k'b) nodots
			*local levy_w`j'_`k'b = r(distance)
			
			*Cumulative Prevalence Diagnostics 
			
			*Comment in scenario specific code
			
			*Scenario 1-3
			*cp_bal t lp`k' x`j', wkm km ks
			*mat ks = r(ks)
			*mat km = r(km)
			*mat wkm = r(wkm)
			*local cpks`j'_`k' = ks[1,1]
			*local km`j'_`k' = km[1,1]
			*local wkm`j'_`k' = wkm[1,1]
			*mat drop ks km wkm 
			
			*Scenario 4
			catprevdiff t lp`k' x1 x2, pd nd 
			local cpks`j'_`k' = r(pd_x1x2)
			local km`j'_`k' = r(nd_x1x2)
			local wkm`j'_`k' = 0
		 /*
			*Scenario 5
			cp_bal t lp`k' x4, wkm km ks catinteract(x1)
			mat ks = r(ksi)
			mat km = r(kmi)
			mat wkm = r(wkmi)
			local cpks`j'_`k' = ks[1,1]
			local km`j'_`k' = km[1,1]
			local wkm`j'_`k' = wkm[1,1]
			mat drop ks km wkm
			
			*Scenario 6
			cp_bal t lp`k' x4, wkm km ks continteract(x6)
			mat ks = r(ksi)
			mat km = r(kmi)
			mat wkm = r(wkmi)
			local cpks`j'_`k' = ks[1,1]
			local km`j'_`k' = km[1,1]
			local wkm`j'_`k' = wkm[1,1]
			mat drop ks km wkm
			*/

			*post matching (`k') (`j')  (`sd_m`j'_`k'') (`f_m`j'_`k'') (`t_m`j'_`k'') (`perc_red_m`j'_`k'') (`ks_m`j'_`k'') (`ovl_m`j'_`k'') (`levy_m`j'_`k'') (`cpks`j'_`k'') (`km`j'_`k'') (`wkm`j'_`k'')
			*post strata (`k') (`j') (`sd_s`j'_`k'') (`f_s`j'_`k'') (`t_s`j'_`k'') (`perc_red_s`j'_`k'') (`ks_s`j'_`k'') (`ovl_s`j'_`k'') (`levy_s`j'_`k'') (`cpks`j'_`k'') (`km`j'_`k'') (`wkm`j'_`k'')
			*post weighted (`k') (`j')  (`sd_w`j'_`k'') (`f_w`j'_`k'') (`t_w`j'_`k'') (`perc_red_w`j'_`k'') (`ks_w`j'_`k'') (`ovl_w`j'_`k'') (`levy_w`j'_`k'') (`cpks`j'_`k'') (`km`j'_`k'') (`wkm`j'_`k'')
			post weighted_ovl (`k') (`j')  (`sd_o`j'_`k'') (`f_o`j'_`k'') (`t_o`j'_`k'') (`perc_red_o`j'_`k'') (`ks_o`j'_`k'') (`ovl_o`j'_`k'') (`levy_o`j'_`k'') (`cpks`j'_`k'') (`km`j'_`k'') (`wkm`j'_`k'')
			*post strataB (`k') (`j')  (`sd_s`j'_`k'b') (`f_s`j'_`k'b') (`t_s`j'_`k'b') (`perc_red_s`j'_`k'b') (`ks_s`j'_`k'b') (`ovl_s`j'_`k'b') (`levy_s`j'_`k'b') (`cpks`j'_`k'') (`km`j'_`k'') (`wkm`j'_`k'')
			*post weightedB (`k') (`j') (`sd_w`j'_`k'b') (`f_w`j'_`k'b') (`t_w`j'_`k'b') (`perc_red_w`j'_`k'b') (`ks_w`j'_`k'b') (`ovl_w`j'_`k'b') (`levy_w`j'_`k'b') (`cpks`j'_`k'') (`km`j'_`k'') (`wkm`j'_`k'')
		
			restore
		}
	
	}

}

*postclose matching
*postclose strata
*postclose weighted 
postclose weighted_ovl
*postclose strataB
*postclose weightedB



