$ontext
This module includes equations that calculate GHG emissions from dairy production on the farm.
Note that these equations are run using a separate solve statement (i.e. they are not included in the main model) in order to
reduce the solve time and size of the model. The emissions intensities are calculated in 'gen_baseline.gms' by dividing these emissions by total milk and meat production
$offtext



Variables
dummy                                                          'Dummy variable for solving emissions module equations'
v_enteric_methane(hh,y)                                        'Enteric methane emissions (kg CO2eq/household/year)'
v_Ym(hh,aaact,type,inten,minten,year,m)                        'Methane conversion factor for a given animal (Ym) (%)'
v_VS(hh,aaact,type,inten,minten,y,m)                           'Volatile solids from manure (kg/household/month)'
v_manure_methane(hh,y)                                         'Manure methane (kg CO2eq/household/year)'
v_manure_nitrous_oxide_direct(hh,y)                            'Direct manure nitrous oxide (kg CO2eq/household/year)'
v_manure_nitrous_oxide_leach(hh,y)                             'Leached manure nitrous oxide (kg CO2eq/household/year)'
v_manure_nitrous_oxide_vol(hh,y)                               'Volatilized manure nitrous oxide (kg CO2eq/household/year)'
v_nitrogen_intake(hh,aaact,type,inten,minten,y,m)              'Nitrogen intake for a given animal (kg N/head/month)'
v_nitrogen_retained_lact(hh,aaact,type,inten,minten,y,m)       'Nitrogen retained for lactation for a given cow (kg/head/month)'
v_nitrogen_retained_gain(hh,aaact,type,inten,minten,y,m)       'Nitrogen retained for gain for a given animal (kg/head/month)'
v_nitrogen_excretion(hh,aaact,type,inten,minten,y,m)           'Nitrogen excreted for a given animal (kg/head/month)'
v_soil_nitrous_oxide(hh,y)                                     'Soil nitrous oxide from all feed sources (note that non-feed crops are excluded) (kg CO2eq/household/year)'
v_fossil_fuel_CO2(hh,y)                                        'Carbon dioxide from fossil fuel energy (kg CO2/household/year)'
v_LUC_CLC(hh,y)                                                'Carbon dioxide emissions from land converted to cropland (kg CO2/household/year)'
;




Equations
e_dummy
e_enteric_fermentation           'Enteric fermentation from cattle in the herd'
e_Ym                             'Methane conversion factor (Ym)'
e_VS                             'Manure volatile solids'
e_manure_methane                 'Manure methane'
e_nitrogen_intake                'Nitrogen intake'
e_nitrogen_retained_lact         'Nitrogen retained for lactation'
*e_nitrogen_retained_gain         'Nitrogen retained for gain'
e_nitrogen_excretion             'Nitrogen excretion'
e_manure_nitrous_oxide_direct    'Direct manure nitrous oxide'
e_manure_nitrous_oxide_leach     'Leached manure nitrous oxide'
e_manure_nitrous_oxide_vol       'Volatilized manure nitrous oxide'
e_soil_nitrous_oxide             'Soil nitrous oxide'
e_fossil_fuel_energy             'Fossil fuel energy'
;


e_enteric_fermentation(hh,y)..                                                    v_enteric_methane(hh,y) =e=   28*Sum((aaact,type,minten,inten,m),30*v_aactLev(hh,aaact,type,inten,minten,y,m)*v_grossEnergy(hh,aaact,type,inten,minten,y,m)*v_Ym(hh,aaact,type,inten,minten,y,m)/(100*55.65))     ;

e_Ym(hh,aaact,type,inten,minten,y,m)..                                            v_Ym(hh,aaact,type,inten,minten,y,m)       =e= 3.7 - 0.243*v_dryMatterIntake(hh,y,m,aaact,type,inten) + 0.0059*10*v_NDF(hh,y,m,aaact,type,inten,minten)   +  0.0057*10*v_dmd(hh,y,m,aaact,type,inten,minten) ;
*3.7 - 0.243*p_DMI(y_fwd,r,breed,cohort,scen)+0.0059*10*p_ADF_intake(y_fwd,r,breed,cohort,scen)+0.0057*10*p_dry_matter_digestibility(y_fwd,r,breed,cohort,scen)/100             ;

* 3.7 - 0.243*p_DMI(y_fwd,r,breed,cohort,scen)+0.0059*10*p_ADF_intake(y_fwd,r,breed,cohort,scen)+0.0057*10*p_dry_matter_digestibility(y_fwd,r,breed,cohort,scen)/100 ;
*e_Ym_coeff(hh,aaact,type,inten,minten,y,m)..                                      v_Ym_coeff(hh,aaact,type,inten,minten,y,m)*v_grossEnergy(hh,aaact,type,inten,minten,y,m)    =e=  (.05)*100*v_digestibleEnergy(hh,aaact,type,inten,minten,y,m) ;

* the below equation needs to be revised, see the equation listings in the appendix
e_VS(hh,aaact,type,inten,minten,y,m)..                                            v_VS(hh,aaact,type,inten,minten,y,m) =e= 30*((v_grossEnergy(hh,aaact,type,inten,minten,y,m)-v_digestibleEnergy(hh,aaact,type,inten,minten,y,m))+((0.04*v_grossEnergy(hh,aaact,type,inten,minten,y,m)))*(0.92/18.45));

e_manure_methane(hh,y)..                                                          v_manure_methane(hh,y)  =e=   28*Sum((breed_aaact(breed,aaact),type,inten,minten,m),v_aactLev(hh,aaact,type,inten,minten,y,m)*v_VS(hh,aaact,type,inten,minten,y,m)*p_B0*0.67*p_MCF(breed))          ;

e_nitrogen_intake(hh,aaact,type,inten,minten,y,m)..                               v_nitrogen_intake(hh,aaact,type,inten,minten,y,m)  =e= (1/18.45)*(1/6.25)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_grossEnergy(feed))*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_crudeProtein(feed))/(.001+v_dryMatterIntake(hh,y,m,aaact,type,inten));

e_nitrogen_excretion(hh,aaact,type,inten,minten,y,m)..                            v_nitrogen_excretion(hh,aaact,type,inten,minten,y,m)  =e= v_nitrogen_intake(hh,aaact,type,inten,minten,y,m)*0.15;
*- v_nitrogen_retained_lact(hh,aaact,type,inten,minten,y,m) - v_nitrogen_retained_gain(hh,aaact,type,inten,minten,y,m)   ;
* - v_nitrogen_retained_lact(hh,aaact,type,inten,minten,y,m);
* n retained for milk, gain, fetal

e_nitrogen_retained_lact(hh,aaact,type,inten,minten,y,m)..                        v_nitrogen_retained_lact(hh,aaact,type,inten,minten,y,m) =e=   0.035*p_milkprod(aaact,type,inten);

*e_nitrogen_retained_gain(hh,aaact,type,inten,minten,y,m)..                        v_nitrogen_retained_gain(hh,aaact,type,inten,minten,y,m) =e= p_gain(aaact,type,inten)*(268-(7.03*p_NE_gain(hh,aaact,type,inten,minten,y,m)/(.001+p_gain(aaact,type,inten))))/(1000/6.25) ;

e_manure_nitrous_oxide_direct(hh,y)..                                             v_manure_nitrous_oxide_direct(hh,y) =e=  265*Sum((aaact,type,inten,minten,m),30*v_aactLev(hh,aaact,type,inten,minten,y,m)*v_nitrogen_excretion(hh,aaact,type,inten,minten,y,m)*p_EF_3)      ;
*(1/18.45)*(1/6.25)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_grossEnergy(feed))*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_crudeProtein(feed))/(.001+v_dryMatterIntake(hh,y,m,aaact,type,inten));
*265*Sum((aaact,type,inten,minten,m),30*v_aactLev(hh,aaact,type,inten,minten,y,m)*v_nitrogen_excretion(hh,aaact,type,inten,minten,y,m)*p_EF_3)      ;

e_manure_nitrous_oxide_vol(hh,y)..                                                v_manure_nitrous_oxide_vol(hh,y) =e=  265*Sum((aaact,type,inten,minten,m),30*v_aactLev(hh,aaact,type,inten,minten,y,m)*v_nitrogen_excretion(hh,aaact,type,inten,minten,y,m)*p_FRAC_vol*p_EF_4)      ;

e_manure_nitrous_oxide_leach(hh,y)..                                              v_manure_nitrous_oxide_leach(hh,y) =e=  265*Sum((aaact,type,inten,minten,m),30*v_aactLev(hh,aaact,type,inten,minten,y,m)*v_nitrogen_excretion(hh,aaact,type,inten,minten,y,m)*p_FRAC_leach*p_EF_5)      ;

e_soil_nitrous_oxide(hh,y)..                                                      v_soil_nitrous_oxide(hh,y)=e=  265*Sum((fodder),v_areaCrop(hh,y,fodder)*p_nitrous_oxide(fodder)) + 265*Sum((non_fodder),v_areaCrop(hh,y,non_fodder)*p_nitrous_oxide(non_fodder)*p_alloc_factor(non_fodder))*Sum((residues_non_fodder(residues,non_fodder),m),v_residuesfeedm(hh,residues,y,m))/Sum((residues_non_fodder(residues,non_fodder),m),0.001+v_residues(hh,y,residues,m))
+  265*Sum((m,feed_off_farm),v_feedbuy(hh,feed_off_farm,y,m)*p_nitrous_oxide_offfarm(feed_off_farm)/1000);

e_fossil_fuel_energy(hh,y)..                                                      v_fossil_fuel_CO2(hh,y)  =e=    sum((m,feed_off_farm),(1/1000)*v_feedbuy(hh,feed_off_farm,y,m)*p_fossil_fuel_emissions(feed_off_farm));

*e_Total(hh,y)..                                                                   v_Total_GHG_emissions(hh,y)  =e= v_enteric_methane(hh,y) + v_manure_methane(hh,y)  +  v_manure_nitrous_oxide_vol(hh,y) + v_manure_nitrous_oxide_leach(hh,y) + v_manure_nitrous_oxide_direct(hh,y)+ v_soil_nitrous_oxide(hh,y)      ;

*e_Emissions_Intensity(hh,y)..                                                     v_Emissions_Intensity(hh,y)*sum((adultf,type,inten,m),v_prodQmilk(hh,adultf,type,inten,y,m))   =e=  v_Total_GHG_emissions(hh,y)      ;

e_dummy..  dummy =e= 10;

Model Emissionsmod
/
e_enteric_fermentation
e_Ym
e_VS
e_manure_methane
e_nitrogen_intake
e_nitrogen_retained_lact
e_nitrogen_excretion
*e_nitrogen_retained_gain
e_manure_nitrous_oxide_direct
e_manure_nitrous_oxide_leach
e_manure_nitrous_oxide_vol
e_soil_nitrous_oxide
e_fossil_fuel_energy
e_dummy
/





