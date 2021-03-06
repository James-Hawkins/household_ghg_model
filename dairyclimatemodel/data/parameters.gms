*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
* #1 Core model parameters   (all parameters are declared in terms of generic sets)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*

Parameters
cropnutrientsdata        'Nutrition properties of feeds'
labourdata               'Labour requirements for livestock'
prodparams               'Productivity parameters for livestock'
startfeed                'Starting feed balance'
startlivestock           'Starting livestock quantities'
transferrate             'Transfer rate for feed biomass'
maintenanceExpense       'General expenses on livestock'
mortality                'Mortality rate of livestock'
prices_lives             'Sale and purchase prices of livestock'
prices_milk              'Sale price of milk'
prices_milk_contract     'Sale price of milk under a contract'
prices_meat              'Sale price of meat'
prices_feed              'Feed prices'
offfarm_income           'Annual off farm income (lc/hh/year)'
labour_rate              'Wage rate for hired labour'
arable_land              'Available arable land per household'
hhold_size               'Number of dependents per household'
area_crop                'Area dedicated to a given crop (ha)'
rangeland                'Available rangeland (ha)'
crop_price               'sale prices of crops (lc/Mg)'
crop_labour              'monthly crop labour demand in hours per hectare'
crop_costs               'costs of crop production per ha'
livestock_labour         'labour requirements for livestock'
total_ag_land            'Total agricultural land owned by the household'
crop_yield               'Yields of crops (Mg/ha/year)'
crop_yield_off_farm      'Yields of feed crops grown off farm (Mg/ha/year)'
start_cash               'amount of cash available to the household in first year (lc/hh)'
rangeland_yield          'Yield of rangeland (Mg DM/ha/m)'
harvest_index            'Harvest index for crops (ratio)'
;

$call "gdxxrw.exe data/household_data.xlsx o=data/household_data.gdx index=index!A3"
$GDXIN "data/household_data.gdx"
*household specific params
$LOAD offfarm_income
$LOAD total_ag_land
$LOAD hhold_size
$LOAD arable_land
$LOAD start_cash
$LOAD rangeland
$LOAD crop_price
$LOAD area_crop
$LOAD crop_costs
$LOAD crop_yield
$LOAD rangeland_yield
$LOAD startfeed
$LOAD startlivestock
$LOAD maintenanceExpense
$LOAD mortality
$GDXIN


$call "gdxxrw.exe data/model_data.xlsx o=data/model_data.gdx index=index!A3"
$GDXIN "data/model_data.gdx"
*general model parameters
*$LOAD crop_price
$LOAD prices_lives
$LOAD prices_milk
$LOAD prices_milk_contract
$LOAD prices_meat
$LOAD prices_feed
$LOAD labour_rate
$LOAD cropnutrientsdata
$LOAD crop_labour
$LOAD crop_yield_off_farm
$LOAD labourdata
$LOAD prodparams
$LOAD harvest_index
$GDXIN







Parameters


* general household parameters
  p_hhold_adult_equivalents(hh)      'Amount of household adult equivalents (AE/hh)'
  p_cash(hh)                         'Starting cash balance (lc/hh)'
  p_offFarmIncome(hh)                'Annual off farm income (lc/hh/yr)'
  p_labouravailablehome(hh,y,m)      'Total labour available from the home (person-days per month)'
  p_arable_land(hh,y)                'Arable land owned by the household (ha)'
  p_total_land(hh,y)                 'Total land owned by the household (ha)'
  p_rangeland(hh,y)                  'Total available rangeland (ha)'
  p_hhold_members(hh,hhold_member)   'Households dependents (people/hh)'
  p_offFarm_wage(hh)                 'Wage rate for off farm employment (lc/person/hour)'

* farm cost parameters
  p_cropcosts(hh,c)                        'Costs related to crop production (lc/ha/year)'
  p_maintExpense(hh,aaact,type,minten)     'Annual expenses per head of livestock (lc/hd/yr)'

* crop parameters
  p_harvestindex(food)             'Harvest index of different crops (ratio of grain to total biomass)'
  p_res_FRAC_soil(hh,food)         'Parameter defining the fraction of total residues being left on the field (fraction, e.g. 0.4)'
  p_yldCrop(hh,c,m)                'Crop yields (kg/ha/year)'
  p_transferrate                   'transfer rate of feed biomass'
  p_forage_yield(m)                'yield of forage (tons DM/ha/yr)'


* household food parameters
  p_nutrientrequirement(hh,nut)    'Nutrient requirement of the given nutrient per AE per year (per AE per year)'
  p_nutrientproperty(food,nut)     'Nutrient density of the given nutrient per unit food (per kg)'
  p_FRAC_farmproduce(nut)          'Fraction of a given nutrient coming from farm produce'


* livestock parameters
  p_rateFert(aaact,type,inten)              'fertility rate, young born per female adult per month'
  p_mreprodf(aaact,type,inten)              'number of males reproduction animals per female breeder'
  p_sexratio(aaact,type,inten)              'birth ratio male and female'
  p_survivalrate(aaact,type,inten)          'survival rate,% of livestock that survive each year'
  p_grad(aaact,type,inten)                  'months in class, used for livestock dynamics, for example a young animal is in young class for X months, the moves to weaner class (aaact)'
  p_mort(aaact,type,minten)                 'fraction of animals that die (monthly)'
  p_gain(aaact,type,inten)                  'Average daily gain for a given animal (kg/head/day)'
  p_milkprod(aaact,type,inten)              'milk produced per adult female (kg/head/day)'
  p_salesw(aaact,type,inten)                'sales weight of a given animal'
  p_dress_pct(aaact,type,inten)             'dressing percentage of aninal (expressed as fraction)'
  p_corrfc_en(cow)
* starting livestock numbers
  v0_aactLev(hh,aaact,type,inten,minten)    'parameter used to specify livestock numbers in 1st period of each iteration'

* starting feed balance
  p_s(hh,feed)                              'starting feed balance in kg'

* labour demand
  p_labour_lives(m,inten,aaact,type)             'labour demand for each activity in each season and intensification level across households'
  p_labourdemcrop(c,m)                            'labour requirements for crop activities ()'


* prices
  p_milkPrice                                     'Price of milk (lc/l)'
  p_milkPrice_contract                            'Price of milk under a buyer-agreement (lc/l)'
  p_meatPrice                                     'Price of meat (lc/kg)'
  p_salesPrice(hh,aaact)                          'Sales price of a given animal (lc/head)'
  p_purchPrice(hh,aaact)                          'Purchase price of a given animal (lc/head)'
  p_labourPrice(hh)                               'Hired labour price (lc/hour)'
  p_feedPrice(feed)                               'Feed prices (for purchased feeds) in lc per kg'
*  p_buyPrice(aaact,type,inten)                   'buy price of livestock'
  p_crop_sell_price(hh,y,c)                        'Sell price of crops (lc/kg)'


*nutrient properties
  p_dryMatter(feed)
  p_grossEnergy(feed)
  p_netEnergy(feed)
  p_digestibleEnergy(feed)
  p_crudeProtein(feed)
  p_ADF(feed)
  p_NDF(feed)
;

**---- Household parameters

* quantity of household dependents
p_hhold_members(hh,hhold_member)=hhold_size(hhold_member,hh);

*- Financial parameters
p_offFarmIncome(hh)=offfarm_income(hh)  ;
p_offFarm_wage(hh)=3000;
p_cropcosts(hh,c)=crop_costs(hh,c) ;
p_cash(hh)  = start_cash(hh)  ;
p_labourPrice(hh)= labour_rate(hh,'lives');
p_maintExpense(hh,aaact,type,minten)= maintenanceExpense(hh,aaact,type,minten);



*- Crop and forage parameters
* rangeland available in hectares
p_rangeland(hh,y)= rangeland('rangeland',hh);

*arable land available in hectares
p_arable_land(hh,y)=arable_land(hh);

*total land available in hectares
p_total_land(hh,y)=total_ag_land(hh);

* crop and forage yields (Mg/ha)
p_yldCrop(hh,c,m)=crop_yield(c,hh,m);
p_forage_yield(m)=rangeland_yield(m);


**---- Model parameters

* fertility (calving) rate of adult females
p_rateFert(aaact,type,inten)=  prodparams (aaact,type,inten,'p_rateFert');
*
p_mreprodf(aaact,type,inten)=  prodparams (aaact,type,inten,'p_mreprodf');
* ratio of male to female reproductive animals (assumed 0.5)
p_sexratio(aaact,type,inten)=  prodparams (aaact,type,inten,'p_sexratio');

* rate at which animals graduate to new class
p_grad(aaact,type,inten)=prodparams (aaact,type,inten,'graduatetonextclass');
* mortality rate
p_mort(aaact,type,minten)=mortality(aaact,type,minten)/12 ;
p_transferrate=1;
p_gain(aaact,type,inten)=prodparams (aaact,type,inten,'adg');
* milk production (kg)
p_milkprod(adultf,type,inten)=prodparams(adultf,type,inten,'milkprod');

* sales weight (kg)
p_salesw(aaact,type,inten)=prodparams (aaact,type,inten,'fnweight');


p_corrfc_en(cow)=1;

* livestock numbers
v0_aactLev(hh,aaact,type,inten,minten)=startlivestock(hh,aaact,type,inten,minten,'startvalue');

* starting feed balance (kg)
p_s(hh,feed)= startfeed(hh,feed, 'p_s');

* labour requirements
p_labour_lives(m,inten,aaact,'dairy')=labourdata(m,inten,aaact,'dairy');
p_labourdemcrop(c,m)=crop_labour(c,m);

* prices
p_milkPrice=prices_milk;
p_milkPrice_contract=prices_milk_contract;
p_meatPrice=prices_meat;
p_feedPrice(feed)= 0.75*prices_feed(feed);
p_crop_sell_price(hh,y,c)=crop_price(c,hh)  ;
p_salesPrice(hh,aaact)=prices_lives(aaact,'sell') ;
p_purchPrice(hh,aaact_imp)=0.8*prices_lives(aaact_imp,'buy') ;
p_purchPrice(hh,aaact_loc)=prices_lives(aaact_loc,'buy') ;
p_labourPrice(hh)= labour_rate(hh,'lives');


* feed nutrient properties
p_grossEnergy(feed)=cropnutrientsdata('grossenergy',feed) ;
p_dryMatter(feed)=cropnutrientsdata('drymatter',feed) ;
p_netEnergy(feed)=cropnutrientsdata('netenergy',feed) ;
p_digestibleEnergy(feed)=cropnutrientsdata('digestibility',feed)*cropnutrientsdata('grossenergy',feed) ;
p_crudeProtein(feed)=cropnutrientsdata('crudeprotein',feed) ;
p_ADF(feed)=cropnutrientsdata('ADF',feed);
p_NDF(feed)=cropnutrientsdata('NDF',feed)  ;

display    p_NDF,p_ADF;

* human nutrition related parameters
p_nutrientrequirement(hh,'kcal')=2500;
p_nutrientproperty(food,'kcal')=5000;
p_FRAC_farmproduce(nut)=0.2;

**-management or biophysical related parameters
p_harvestindex(food)=harvest_index(food);
p_res_FRAC_soil(hh,food)=0.5;


** -- calculate parameters off of raw data
*calculate monhtly home labour availability based on number of household members of specific age categories
p_labouravailablehome(hh,y,m) = 4*(2*p_hhold_members(hh,'under_15') + 3.5*p_hhold_members(hh,'over_65') + 7*p_hhold_members(hh,'adult'))   ;

*convert actual household members to adult equivalents
p_hhold_adult_equivalents(hh)=0.5*p_hhold_members(hh,'under_15') + p_hhold_members(hh,'over_65') + p_hhold_members(hh,'adult');





