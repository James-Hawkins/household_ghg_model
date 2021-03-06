$setglobal filelocation  C:\Users\James\Documents\GitHub\household_ghg_model\household_ghg_model\dairyclimatemodel2


$setglobal resdir  '%filelocation%results'
$setglobal datdir  '%filelocation%data'

$onUNDF

$eolcom !!


*$LIBINCLUDE GNUPLTXY credit Y-AXIS X-AXIS


$ontext
This file is used to run the global model. It includes all the necessary modules and specifies the model definition (i.e. what modules to include depending on the settings).
The model solve statment is embedded in a loop which is used to run the model sequentially over a multi-year period. After each instance of the solve statement, the variables get saved
and re-defined as intializing parameters in the next instance of the model. Then all the results get exported to excel files.

$offtext





$ontext
***************************
Dairy climate model
***************************
$offtext


* Set Declarations
$include set_definitions.gms

* Data load in
$include "data\parameters.gms"

$include "data\ghg_parameters.gms"

$include "data\nutr_parameters.gms"

$include "data\scenario_parameters.gms"



display
v0_aactLev,
p_B0,
p_FRAC_leach,
p_FRAC_vol,
p_EF_5,
p_EF_4,
p_MCF,p_ADF,p_crudeProtein,
p_Energy_req,
p_digestibleEnergy,
p_grossEnergy,
p_crop_sell_price,
offfarm_income,
p_offFarmIncome,
p_forage_yield,
rangeland_yield,
p_yldCrop,
p_s,
startfeed,
p_netEnergy,
p_dryMatter,
p_transferrate
p_fossil_fuel_emissions,
p_meatPrice,
p_purchPrice,
p_labourPrice;
*$exit



*define scenarios and model versions
$setglobal CREDIT ON
$setglobal output_SCEN OFF
$setglobal RISK ON
$setglobal GHG_Emissions OFF
$setglobal Scenario Base
$setglobal rangeland_constraint ON


** Price scenarios
*p_feedPrice(feed)=(0.75)*prices_feed(feed);
*p_purchPrice(hh,aaact_imp)=0.75*prices_lives(aaact_imp,'buy') ;

*p_milkPrice('Scen')=  prices_milk;
*p_feedPrice(feed,'Scen3')=prices_feed(feed)*(0.75);
*p_purchPrice(hh,aaact,'Scen4')=prices_lives(hh,aaact,'buy')*(0.75);


* Crop module
$include crop_module.gms

* Livestock module
$include livestock_module.gms

* Livestock demographic module
$include demographic_module.gms

* Emissions module
$include emissions_module.gms

* Loan module
$include loan_module.gms

* Household module
$include household_module.gms

* Risk module
$include risk_module.gms

* simulation model
$include simulation_model.gms


* MODEL DEFINITION

Model  DairyClimateModel
/
   livesmod
   demogmod
   cropmod
   Householdmod
   simulation_model
$ifi %RISK%==ON   risk_module
$ifi %CREDIT%==ON   loanmod
$ifi %GHG_Emissions%== ON Emissionsmod
/
;
*DairyClimateModel.SCALEOPT = 10000 ;


* results storage parameters
Parameter
hh1_animals(*,*,*)
ghg_summary(*,*,*)
Model_status(*,*)
credit(*,*,*)
consumption(*,*,*,*,*)
biomass(*,*,*,*,*)
animal_numbers_monthly(*,*,*,*,*)
animal_numbers_annual(*,*,*,*)
financials(*,*,*)
financials_crop(*,*,*)
financials_livestock(*,*,*)
herd_changes(*,*,*,*,*,*,*,*)
herd(*,*,*,*,*,*)
herd2(*,*,*)
diet1(*,*,*,*,*,*)
diet_annual(*,*,*,*,*,*)
labour(*,*,*,*)
diet(*,*,*,*,*,*,*)
GHG_emissions(*,*,*)
GHG_emissions_parameters(*,*,*,*,*,*,*,*)
crops(*,*,*,*)
production(*,*,*)
land(*,*,*)
dry_matter_intake(*,*,*,*,*,*)
total_feed_consumed1(*,*,*,*)
total_feed_consumed2(*,*,*,*,*)
cash_balance(*,*,*)
;



*-- recursive loop
Loop(y2,

*v_aactLevsell.fx(hh,'adultf_imp',type,inten,minten,'y01','m01') = v_aactLev.l(hh,'adultf_imp',type,inten,minten,'y01','m12')*p_grad('adultf_imp',type,inten)*(1-p_mort('adultf_imp',type,minten));
v_aactLevsell.fx(hh,'adultf_loc',type,inten,minten,'y01','m01')= v_aactLev.l(hh,'adultf_loc',type,inten,minten,'y01','m12')*p_grad('adultf_loc',type,inten)*(1-p_mort('adultf_loc',type,minten));


** these inititial variable values are specified to reduce the solve time of the model.
v_fdcons.l(hh,aaact,type,inten,y,m,feed_off_farm)=0;
v_fdcons.l(hh,aaact,type,inten,y,m,'grass')=20;



SOLVE DairyClimateModel maximizing v_npv using DNLP;  !! best solved with SNOPT
*$include productivity_module.gms

*----- save results from current year
Model_status('Model Status',y2)=DairyClimateModel.modelstat;
animal_numbers_monthly('Animal Activity Levels (head)',hh,aaact,y2,m)=Sum((inten,minten),v_aactLev.l(hh,aaact,'dairy',inten,minten,'y01',m));
animal_numbers_annual('Animal Activity Levels (head)',hh,aaact,y2)=Sum((inten,minten,m),v_aactLev.l(hh,aaact,'dairy',inten,minten,'y01',m))/12;


herd_changes('Animal Sales (hd)',hh,aaact,type,inten,minten,y2,m)=v_aactLevSell.l(hh,aaact,type,inten,minten,'y01',m);
herd_changes('Animal Purchases (hd)',hh,aaact,type,inten,minten,y2,m)=v_aactLevbuy.l(hh,aaact,type,inten,minten,'y01',m);
*herd_changes('Animal Deaths (hd)',hh,aaact,type,inten,minten,y2,m)=;

biomass('Total feed consumption (kg/hh/month)',hh,feed,y2,m)=v_feedons.l(hh,feed,'y01',m);
biomass('Feed Balance (kg/month)',hh,feed,y2,m)=v_feedbalance.l(hh,feed,'y01',m);
biomass('Residues as Feed (Mg)',hh,residues,y2,m)=v_residuesfeedm.l(hh,residues,'y01',m);
biomass('Residues on field (Mg)',hh,y2,residues,m)=v_residuesfieldm.l(hh,residues,'y01',m);
biomass('Feeds purchased (kg/hh/month)',hh,y2,feed_off_farm,m)= v_feedbuy.l(hh,feed_off_farm,'y01',m);


diet1('Diet (kg/hd/day)',hh,aaact,y2,m,feed)=Sum(inten,v_fdcons.l(hh,aaact,'dairy',inten,'y01',m,feed));
diet('Feed intake (kg/hd/day)',hh,aaact,y2,m,inten,feed)=v_fdcons.l(hh,aaact,'dairy',inten,'y01',m,feed);
diet_annual('Diet as percentage(% DMI)',hh,aaact,y2,inten,feed)=100*sum((m),p_dryMatter(feed)*v_fdcons.l(hh,aaact,'dairy',inten,'y01',m,feed))/Sum(m,.0001+v_dryMatterIntake.l(hh,'y01',m,aaact,'dairy',inten));
diet('Gross Energy (MJ/hd/d)',hh,aaact,type,inten,y2,m)=Sum((feed),v_fdcons.l(hh,aaact,type,inten,'y01',m,feed)*p_dryMatter(feed)*p_grossEnergy(feed));
diet('Digestible Energy (MJ/hd/d)',hh,aaact,type,inten,y2,m)=Sum((feed),v_fdcons.l(hh,aaact,type,inten,'y01',m,feed)*p_dryMatter(feed)*p_digestibleEnergy(feed));

dry_matter_intake('Dry matter intake (kg/hd/d)',hh,aaact,inten,y2,m)=v_dryMatterIntake.l(hh,'y01',m,aaact,'dairy',inten) ;
total_feed_consumed1('Total of all feeds consumed (kg)',hh,y2,m)=sum(feed,biomass('Total feed consumption (kg/hh/month)',hh,feed,'y01',m));
total_feed_consumed2('Total of an individual feed consumed (%)',hh,feed,y2,m)=100*v_feedons.l(hh,feed,'y01',m)/(.0001+total_feed_consumed1('Total of all feeds consumed (kg)',hh,y2,m));

*- Financials
financials('Net present value (objective function) (lc)',hh,y2)=v_npv.l;
financials('Household Income (lc/yr)',hh,y2)=sum(m,v_income.l(hh,'y01',m));
financials('Farm Income (lc/yr)',hh,y2)=sum(m,v_income_lives.l(hh,'y01',m)+v_income_crop.l(hh,'y01',m));
financials('Off farm Income (lc/yr)',hh,y2)=v_off_farm_income.l(hh,'y01');
financials('Farm Expenses (lc/yr)',hh,y2)=sum(m,v_crop_expenses.l(hh,'y01',m)+v_lives_expenses.l(hh,'y01',m));
financials('Cash balance (lc/hh)',hh,y2)=0.35*sum(m,v_income.l(hh,'y01',m)) ;

financials_livestock('Livestock Income(lc/hh/y)',hh,y2)= sum(m,v_income_lives.l(hh,'y01',m));
financials_livestock('Milk Revenue total(lc/hh/y)',hh,y2)=sum((m),v_milk_revenue_contract.l(hh,'y01',m)+v_milk_revenue_informal.l(hh,'y01',m));
financials_livestock('Milk Revenue informal(lc/hh/y)',hh,y2)=sum(m,v_milk_revenue_informal.l(hh,'y01',m));
financials_livestock('Milk Revenue formal(lc/hh/y)',hh,y2)=sum(m,v_milk_revenue_contract.l(hh,'y01',m));
financials_livestock('Meat Revenue (lc/hh/y)',hh,y2)=Sum((aaact,type,inten,m),v_prodQmeat.l(hh,aaact,type,inten,'y01',m)*p_meatPrice);
financials_livestock('Livestock Expenses (lc/yr)',hh,y2)=sum(m,v_lives_expenses.l(hh,'y01',m));
financials_livestock('Replacement Costs(lc/yr)',hh,y2)=sum((aaact,type,inten,minten,m),v_aactLevbuy.l(hh,aaact,type,inten,minten,'y01',m)*p_purchPrice(hh,aaact));
financials_livestock('Livestock labour expenses(lc/yr)',hh,y2)=sum(m,v_labour_hired_lives.l(hh,'y01',m)*p_labourPrice(hh)) ;
financials_livestock('Maintenance Expenses(lc/yr)',hh,y2)= sum((aaact,type,m,inten,minten),v_aactLev.l(hh,aaact,type,inten,minten,'y01',m)*p_maintExpense(hh,aaact,type,minten)/12);
financials_livestock('Feed Expenses(lc/yr)',hh,y2)= sum((m,feed_off_farm),v_feedbuy.l(hh,feed_off_farm,'y01',m)*p_feedprice(feed_off_farm));
financials_livestock('Milk marketed informally (lc/yr)',hh,y2)=sum(m,v_Qmilk_marketed_informal.l(hh,'y01',m));
financials_livestock('Milk marketed contract(lc/yr)',hh,y2)=sum(m,v_Qmilk_marketed_contract.l(hh,'y01',m));

financials_crop('Crop income (lc/yr)',hh,y2)=sum(m,v_income_crop.l(hh,'y01',m));
financials_crop('Crop revenue (lc/yr)',hh,y2)=Sum((cash,m), v_prdCrop.l(hh,'y01',cash,m)*p_crop_sell_price(hh,'y01',cash));
financials_crop('Crop Expenses (lc/yr)',hh,y2)=sum(m,v_crop_expenses.l(hh,'y01',m));
financials_crop('General crop expenses(lc/yr)',hh,y2)=Sum(c,v_areaCrop.l(hh,'y01',c)*p_cropcosts(hh,c))    ;
financials_crop('Crop labour expenses(lc/yr)',hh,y2)=Sum(m,v_labour_hired_crop.l(hh,'y01',m)*p_labourPrice(hh)) ;




* milk and meat production
production('Milk produced (kg/hh/y)',hh,y2)=sum((adultf,type,inten,m),v_prodQmilk.l(hh,adultf,type,inten,'y01',m));
production('Meat produced (kg/hh/y)',hh,y2)=Sum((aaact,type,inten,m),v_prodQmeat.l(hh,aaact,type,inten,'y01',m));

* consumption
consumption(hh,y2,m,good,'Household consumption (kg/hh/m)')=v_cons.l(hh,'y01',m,good);


* labour
labour('Total livestock labour (person-days/m)',hh,y2,m)=v_totallabourdemlive.l(hh,'y01',m);
labour('Total crop labour (person-days/m)',hh,y2,m)=v_totallabourdemcrop.l(hh,'y01',m);
labour('Livestock labour hired (person-days/m)',hh,y2,m)=v_labour_hired_lives.l(hh,'y01',m);
labour('Crop labour hired (person-days/m)',hh,y2,m)=v_labour_hired_crop.l(hh,'y01',m) ;
labour('Home labour available (person-days/m)',hh,y2,m)=p_labouravailablehome(hh,'y01',m);
labour('Leisure time (person-days/m)',hh,y2,m)=v_leisure.l(hh,'y01',m);

* Crops
crops('Crop area (ha)',hh,y2,c)=v_areaCrop.l(hh,'y01',c);
crops('Crop production (Mg)',hh,y2,c)=Sum(m,v_prdCrop.l(hh,'y01',c,m)) ;
crops('Crop residues produced (Mg)',hh,y2,residues)=Sum(m,v_residues.l(hh,'y01',residues,m));



* These two lines calculate GHG emissions at a post-model optimization output (based on the results from the model run in each iteration)
$ifi %GHG_Emissions%== OFF $include "GHG_params.gms" ;
$ifi %GHG_Emissions%== OFF Solve Emissionsmod using nlp maximizing dummy;

GHG_emissions('Emissions -- Enteric CH4 (kg/yr)',hh,y2)=v_enteric_methane.l(hh,'y01');
GHG_emissions('Emissions -- Manure CH4 (kg/yr)',hh,y2)=v_manure_methane.l(hh,'y01');
GHG_emissions('Emissions -- Manure N2O (direct) (kg/yr)',hh,y2)=v_manure_nitrous_oxide_direct.l(hh,'y01');
GHG_emissions('Emissions -- Manure N2O (vol) (kg/yr)',hh,y2)=v_manure_nitrous_oxide_vol.l(hh,'y01');
GHG_emissions('Emissions -- Manure N2O (leach) (kg/yr)',hh,y2)=v_manure_nitrous_oxide_leach.l(hh,'y01');
GHG_emissions('Emissions -- Soil N2O (kg/yr)',hh,y2)=v_soil_nitrous_oxide.l(hh,'y01');
GHG_emissions('Emissions -- Fossil Fuel CO2 (kg CO2eq/kg milk)',hh,y2)=v_fossil_fuel_CO2.l(hh,'y01');
GHG_emissions('Emissions -- cropland conversion (kg/yr)',hh,y2)=(44/12)*p_land_C*(1-exp((-.02)*(ord(y2)-1)))*(v_feed_crop_land.l(hh,'y01') -  p0_feed_crop_land(hh,y2)) ;
GHG_emissions('Emissions -- Total(kg CO2eq)',hh,y2)=v_enteric_methane.l(hh,'y01')+v_manure_methane.l(hh,'y01')+v_manure_nitrous_oxide_direct.l(hh,'y01')+v_manure_nitrous_oxide_vol.l(hh,'y01')+v_manure_nitrous_oxide_leach.l(hh,'y01')+v_soil_nitrous_oxide.l(hh,'y01')+v_fossil_fuel_CO2.l(hh,'y01')+GHG_emissions('Emissions -- cropland conversion (kg/yr)',hh,y2);

GHG_emissions('Emissions intensity -- Enteric CH4 (kg CO2eq/kg milk)',hh,y2)=v_enteric_methane.l(hh,'y01')/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- Manure CH4 (kg CO2eq/kg milk)',hh,y2)=v_manure_methane.l(hh,'y01')/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- Manure N2O (direct) (kg CO2eq/kg milk)',hh,y2)=v_manure_nitrous_oxide_direct.l(hh,'y01')/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- Manure N2O (leach)(kg CO2eq/kg milk)',hh,y2)=v_manure_nitrous_oxide_leach.l(hh,'y01')/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- Manure N2O (vol) (kg CO2eq/kg milk)',hh,y2)=v_manure_nitrous_oxide_vol.l(hh,'y01')/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- Soil N2O (kg CO2eq/kg milk)',hh,y2)=v_soil_nitrous_oxide.l(hh,'y01')/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- Fossil Fuel CO2 (kg CO2eq/kg milk)',hh,y2)=v_fossil_fuel_CO2.l(hh,'y01')/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- Cropland conversion (kg CO2eq/kg milk)',hh,y2)=GHG_emissions('Emissions -- cropland conversion (kg/yr)',hh,y2)/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));
GHG_emissions('Emissions intensity -- total(kg CO2eq/kg milk)',hh,y2)=GHG_emissions('Emissions -- Total(kg CO2eq)',hh,y2)/(production('Meat produced (kg/hh/y)',hh,y2)+production('Milk produced (kg/hh/y)',hh,y2));

$ifi %GHG_Emissions%== OFF $include "GHG_params2.gms"  ;

*Credit
credit('Loan (initial value) (lc/yr)',hh,y2)=v_loan.l(hh) ;
credit('Loan payment (lc/yr)',hh,y2)=p_loan_installment(hh);
credit('Loan principle (lc)',hh,y2)=p_loan_principle(hh,y2)   ;
credit('Credit interest (lc/yr)',hh,y2)=p_credit_interest(hh)  ;

cash_balance(hh,y2,m)=v_cash.l(hh,'y01',m);

land('Total land use for dairy production (ha/hh/yr)',hh,y2)=v_Land_use.l(hh,'y01');
land('Total crop land use for dairy production (ha/hh/yr)',hh,y2)=v_feed_crop_land.l(hh,'y01');
land('Total crop land use for dairy production on farm (ha/hh/yr)',hh,y2)=v_feed_crop_land_on_farm.l(hh,'y01') ;
land('Total crop land use for dairy production off farm (ha/hh/yr)',hh,y2)=v_feed_crop_land_off_farm.l(hh,'y01') ;
land('Total rangeland use for dairy production (ha/hh/yr)',hh,y2)=v_graze_dmd.l(hh,'y01');
land('Total pasture land use for dairy production (ha/hh/yr)',hh,y2)=v_pasture_land.l(hh,'y01') ;


herd2('Percentage local (%)',hh,y2)=100*sum((m,local),animal_numbers_monthly('Animal Activity Levels (head)',hh,local,y2,m))/sum((m,aaact),.0001+animal_numbers_monthly('Animal Activity Levels (head)',hh,aaact,y2,m));


*--------        Re-initialize variables
*---------------------------------------
* update loan related parameters based on decisions in year y2 == 1
p_loan_value(hh)$(ord(y2) eq 1)=v_loan.l(hh);
p_loan_installment(hh)=p_loan_value(hh)*.1;
p_loan_principle(hh,y2)= p_loan_value(hh) - (ord(y2)*p_loan_installment(hh))   ;
p_credit_interest(hh)=p_loan_principle(hh,y2)*p_r_loan(hh);
p_loan_value(hh)$(ord(y2) gt 1)=p_loan_value(hh);

* set loan related variables to zero in every period after y2 == 1
v_loan.fx(hh)=0;
v_loan_principle.fx(hh,y)=0;
v_credit_interest.fx(hh,y,m)=0;
v_loan_installment.fx(hh,y)=0;

* specify fraction of total income available to be re-invested in the farm.
p_cash(hh)=0.35*sum(m,v_income.l(hh,'y01',m));

*update feed balance
p_s(hh,feed)=v_feedbalance.l(hh,feed,'y01','m12')*(p_transferrate);

** re initialize month 1 animal numbers here from month 12 of 'y01'
** note: to allow transitions between intensity levels, sum rhs of below equations over all 'type'
v0_aactLev(hh,young_imp,type,inten,minten)=
v_aactLev.l(hh,'adultf_imp',type,inten,minten,'y01','m12')*p_rateFert('adultf_imp',type,inten)*p_sexratio(young_imp,type,inten)+
v_aactLev.l(hh,young_imp,type,inten,minten,'y01','m12')*(1-p_grad(young_imp,type,inten))*(1-p_mort(young_imp,type,minten))
;

v0_aactLev(hh,young_loc,type,inten,minten)=
v_aactLev.l(hh,'adultf_loc',type,inten,minten,'y01','m12')*p_rateFert('adultf_loc',type,inten)*p_sexratio(young_loc,type,inten)+
v_aactLev.l(hh,young_loc,type,inten,minten,'y01','m12')*(1-p_grad(young_loc,type,inten))*(1-p_mort(young_loc,type,minten))
;

v0_aactLev(hh,'weanerf_imp',type,inten,minten)=
v_aactLev.l(hh,'youngf_imp',type,inten,minten,'y01','m12')*p_grad('youngf_imp',type,inten)
+v_aactLev.l(hh,'weanerf_imp',type,inten,minten,'y01','m12')*(1-p_grad('weanerf_imp',type,inten))*(1-p_mort('weanerf_imp',type,minten))
;

v0_aactLev(hh,'weanerf_loc',type,inten,minten)=
v_aactLev.l(hh,'youngf_loc',type,inten,minten,'y01','m12')*p_grad('youngf_loc',type,inten)
+v_aactLev.l(hh,'weanerf_loc',type,inten,minten,'y01','m12')*(1-p_grad('weanerf_loc',type,inten))*(1-p_mort('weanerf_loc',type,minten))
;

v0_aactLev(hh,'weanerm_imp',type,inten,minten)=
v_aactLev.l(hh,'youngm_imp',type,inten,minten,'y01','m12')*p_grad('youngm_imp',type,inten)
+v_aactLev.l(hh,'weanerm_imp',type,inten,minten,'y01','m12')*(1-p_grad('weanerm_imp',type,inten))*(1-p_mort('weanerf_imp',type,minten))
;

v0_aactLev(hh,'weanerm_loc',type,inten,minten)=
v_aactLev.l(hh,'youngm_loc',type,inten,minten,'y01','m12')*p_grad('youngm_loc',type,inten)
+v_aactLev.l(hh,'weanerm_loc',type,inten,minten,'y01','m12')*(1-p_grad('weanerm_loc',type,inten))*(1-p_mort('weanerf_loc',type,minten))
-v_aactLevsell.l(hh,'weanerm_loc',type,inten,minten,'y01','m12')
;

v0_aactLev(hh,'adultf_loc',type,inten,minten)=
v_aactLev.l(hh,'weanerf_loc',type,inten,minten,'y01','m12')*p_grad('weanerf_loc',type,inten)
+v_aactLev.l(hh,'adultf_loc',type,inten,minten,'y01','m12')*(1-p_grad('adultf_loc',type,inten))*(1-p_mort('adultf_loc',type,minten))
-v_aactLevsell.l(hh,'adultf_loc',type,inten,minten,'y01','m12')
+v_aactLevbuy.l(hh,'adultf_loc',type,inten,minten,'y01','m12');

v0_aactLev(hh,'adultf_imp',type,inten,minten)=
v_aactLev.l(hh,'weanerf_imp',type,inten,minten,'y01','m12')*p_grad('weanerf_imp',type,inten)
+v_aactLev.l(hh,'adultf_imp',type,inten,minten,'y01','m12')*(1-p_grad('adultf_imp',type,inten))*(1-p_mort('adultf_imp',type,minten))
-v_aactLevsell.l(hh,'adultf_imp',type,inten,minten,'y01','m12')
+v_aactLevbuy.l(hh,'adultf_imp',type,inten,minten,'y01','m12')
;

v_aactLev.fx(hh,aaact,type,inten,minten,'y01','m01')=v0_aactLev(hh,aaact,type,inten,minten);

);

*$exit

herd('Animal Activity Levels (head)',hh,aaact,type,inten,minten)=Sum((y2,m),animal_numbers_monthly('Animal Activity Levels (head)',hh,aaact,y2,m))/(card(m)*card(y2));





execute_unload "results/results.gdx"
land,
Model_Status,
herd,
total_feed_consumed1,
total_feed_consumed2,
herd_changes,
dry_matter_intake,
labour, financials,
financials_livestock,
financials_crop,
GHG_emissions,
crops,
credit,
production,
consumption,
biomass,
animal_numbers_monthly
animal_numbers_annual,
diet_annual
cash_balance
;

*$exit
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=Model_Status       rng=Model_Status!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=financials         rng=financials!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=financials_crop    rng=financials_crop!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=financials_livestock         rng=financials_livestock!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=labour             rng=labour!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=production         rng=production!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=credit             rng=credit!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=consumption    rng=consumption!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=land     rng=land!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=cash_balance    rng=cash_balance!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=biomass            rng=biomass!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=crops              rng=crops!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=herd               rng=herd!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=herd_changes       rng=herd_changes!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=animal_numbers_monthly     rng=animal_numbers_monthly!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=animal_numbers_annual     rng=animal_numbers_annual!'
*execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=total_feed_consumed rng=total_feed_consumed !'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=dry_matter_intake      rng=dry_matter_intake!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=diet_annual     rng=diet_annual!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=total_feed_consumed1    rng=total_feed_consumed1!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=total_feed_consumed2    rng=total_feed_consumed2!'
execute 'gdxxrw.exe results/results.gdx o=results/results.xls par=GHG_emissions      rng=GHG_emissions!'

