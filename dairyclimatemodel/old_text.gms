$include settings.gms

* Set Declarations
$include set_definitions.gms


$include "data\parameters.gms"
*$exit

execute_unload "results/prices.gdx"
prices_milk;



set
scen /Base,scen1/
hh /hh1,hh2/
ghg /ghg1,ghg2/
;

parameter
ghgs(scen,hh,ghg)
;
ghgs('Base','hh1','ghg1')=0.75;
ghgs('Base','hh2','ghg1')=1;
ghgs('Base','hh1','ghg2')=0.45;
ghgs('Base','hh2','ghg2')=1.2;

ghgs('scen1','hh1','ghg1')=.65;
ghgs('scen1','hh2','ghg1')=.55;
ghgs('scen1','hh1','ghg2')=.35;
ghgs('scen1','hh2','ghg2')=.125;


execute_unload "results/testgraph.gdx"
ghgs;




Parameters
p_yldCrop(hh,c)
p_arable_land(hh,y)
p_total_land(hh,y)
p_labourdemcrop(c,m)
p_crop_sell_price(hh,y,c)
p_cropcosts(hh,c)

;
v_feedbalance.lo(hh,feed,y,m)= -eps;
v_feedbuy.fx(hh,feed_on_farm,y,m)=0;
v_feedons.lo(hh,feed,y,m)=-eps;
v_feedbuy.lo(hh,feed,y,m)=-eps;
v_residuesfeedm.lo(hh,residues,y,m)=-eps;

v_fdcons.lo(hh,aaact,type,inten,y,m,feed)=0;


* can't sell, buy, or slaughter local reproduction animals
*v_aactLevsell.fx(hh,'reprod_loc',type,inten,minten,y,m)=0;
*v_aactLevbuy.fx(hh,'reprod_loc',type,inten,minten,y,m)=0;
* can't sell, buy, or slaughter reproductive animals
*v_aactLevsell.fx(hh,'reprod_imp',type,inten,minten,y,m)=0;
*v_aactLevbuy.fx(hh,'reprod_imp',type,inten,minten,y,m)=0;
*v_aactLevsell.fx(hh,'reprod_imp',type,inten,minten,y,m)=0;
*v_aactLevsell.fx(hh,'reprod_loc',type,inten,minten,y,m)=0;


Variables
v_areaCrop(hh,y,c)
v_prdCrop(hh,y,c)
v_crop_sales_cash(hh,y,cash)
v_crop_food(hh,y,food)
v_totallabourdemcrop(hh,y,m)
v_residuesfieldm(hh,residues,y,m)
v_residues(hh,y,residues,m)
;

** Variable bounds
v_areaCrop.lo(hh,y,c)=0;

Equations
e_arable_land
crp_prd
crp_fate_food_byprd
residues_prod
residues_field
labourdemand
;




*- Arable land constraint
e_arable_land(hh,y)..                            Sum(c,v_areaCrop(hh,y,c)) =e=   p_arable_land(hh,y)    ;


*- Crop production
crp_prd(hh,y,c)..                              v_areaCrop(hh,y,c)*p_yldCrop(hh,c)     =e=  v_prdCrop(hh,y,c)  ;

*- Amount of residues produced
crp_fate_food_byprd(hh,y,residues,m)..   v_residues(hh,y,residues,m) =e= Sum(crop_residue(food,residues), (v_prdCrop(hh,y,food)/p_harvestindex(food)) - v_prdCrop(hh,y,food) )/12;

*- Accounting equation for residues ; residues go either to livestock or are left on field
residues_prod(hh,y,residues,m)..         v_residues(hh,y,residues,m) =e=   v_residuesfeedm(hh,residues,y,m) + v_residuesfieldm(hh,residues,y,m);

residues_field(hh,y,residues,m)..         v_residuesfieldm(hh,residues,y,m) =e=   Sum(crop_residue(food,residues), v_residues(hh,y,residues,m)*p_res_FRAC_soil(hh,food));


*- Labour demand for crop production
labourdemand(hh,y,m)..                     Sum((c),v_areaCrop(hh,y,c)*p_labourdemcrop(c,m))    =e= v_totallabourdemcrop(hh,y,m);


Model cropMod
/
e_arable_land
crp_prd
crp_fate_food_byprd
residues_prod
residues_field
labourdemand
/

38  nutrientparam
 139  transferrate
 140  maintenanceExpense
 141  mortality
 142  diets
 143  prices_lives
 144  prices_milk
 145  prices_meat
 146  prices_feed
 147  labour_rate
 148  arable_land
 149  hhold_size
 150  livestock_holdings
 151  area_crop
 152  crop_price
 153  crop_labour        'monthly crop demand in hours per hectare'
 154  crop_costs         'costs of crop production per ha'
 155  livestock_labour
 156  total_ag_land
 157  crop_yield
 158  hhold_size
 159  off_farm_income
 160  labour_rate
 161  ;
 162
 163
 164
GDXIN   G:\Model\data/data.gdx
--- LOAD  cropnutrientsdata = 1:cropnutrientsdata
--- LOAD  labourdata = 2:labourdata
--- LOAD  prodparams = 3:prodparams
--- LOAD  startfeed = 4:startfeed
--- LOAD  feedsupply = 5:feedsupply
--- LOAD  startlivestock = 6:startlivestock
--- LOAD  maintenanceExpense = 7:maintenanceExpense
--- LOAD  mortality = 8:mortality
--- LOAD  diets = 9:diets
--- LOAD  prices_lives = 10:prices_lives
--- LOAD  prices_milk = 11:prices_milk
--- LOAD  prices_meat = 12:prices_meat
--- LOAD  prices_feed = 13:prices_feed
--- LOAD  arable_land = 14:arable_land
--- LOAD  total_ag_land = 15:total_ag_land
--- LOAD  hhold_size = 16:hhold_size
--- LOAD  area_crop = 18:area_crop
--- LOAD  crop_price = 19:crop_price
--- LOAD  crop_labour = 20:crop_labour
--- LOAD  crop_costs = 21:crop_costs
--- LOAD  crop_yield = 17:crop_yield
--- LOAD  labour_rate = 23:labour_rate
 190
 191
 192
 193
 194
 195
 196
 197
 198  Parameters
 199  * crop nutrient data
 200    p_nutcontent(anut,feed)                   'net and gross energy content
      per kg feed in MJ, % metabolizable and % crude protein of feed, %dry matte
      r of feed'
 201
 202  * demographic data
 203    p_rateFert(aaact,type,inten)              'fertility rate, young born pe
      r female adult per month'
 204    p_mreprodf(aaact,type,inten)              'number of males reproduction
      animals per female breeder'




Sets

*-- household sets
hh households          /hh1/

* -- household members
hhold_member /total,over_65,under_15,adult/

*-- time sets
m twelve months                                  /m01*m12/
year years                                       /1*20,y01*y12/
y(year) years in model horizon                   /y01*y02/
y2(year) years in current run or recursive steps /1*2/

firsty(y2) /1/
firstm(m)  /m01/
lasty(y2)  /2/
lastm(m)   /m12/



*-- types of animals
type             /dairy/

*-- intensity sets
inten intensity level for feeding  /ext,med,int/
minten level for maintenance       /ext,med,int/


*- nutrient sets
anut /netenergy,grossenergy,crudeprotein,metabolisableprotein,drymatter,digestibility/

*-- animal activity related sets
aaact  animal activity /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc,adultf_loc,reprod_loc,youngf_imp,youngm_imp,weanerf_imp,weanerm_imp,adultf_imp,reprod_imp/
aaact_loc(aaact)       /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc,adultf_loc,reprod_loc/
aaact_imp(aaact)       /youngf_imp,youngm_imp,weanerf_imp,weanerm_imp,adultf_imp,reprod_imp/
young(aaact)           /youngm_loc,youngf_loc,youngm_imp,youngf_imp/
young_imp(aaact)       /youngm_imp,youngf_imp/
young_loc(aaact)       /youngm_loc,youngf_loc/
weaner(aaact)          /weanerm_loc,weanerf_loc,weanerm_imp,weanerf_imp/
weaner_loc(aaact)      /weanerm_imp,weanerf_imp/
weaner_imp(aaact)      /weanerm_loc,weanerf_loc/
adult(aaact)           /adultf_loc,reprod_loc,adultf_imp,reprod_imp/
adult_loc(aaact)       /adultf_loc,reprod_loc/
adult_imp(aaact)       /adultf_imp,reprod_imp/
adultf(aaact)          /adultf_loc,adultf_imp/
adultf_imp(aaact)      /adultf_imp/
adultf_loc(aaact)      /adultf_loc/
male(aaact)            /youngm_loc,weanerm_loc,reprod_loc,youngm_imp,weanerm_imp,reprod_imp/
male_loc(aaact)        /youngm_loc,weanerm_loc,reprod_loc/
male_imp(aaact)        /youngm_imp,weanerm_imp,reprod_imp/
reprod(aaact)          /reprod_loc,reprod_imp/
reprod_loc(aaact)      /reprod_loc/
reprod_imp(aaact)      /reprod_imp/
yfemale(aaact)         /youngf_loc,youngf_imp/
yfemale_loc(aaact)     /youngf_loc/
yfemale_imp(aaact)     /youngf_imp/
notadult(aaact)        /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc,youngf_imp,youngm_imp,weanerf_imp,weanerm_imp/
notadultf(aaact)        /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc,youngf_imp,youngm_imp,weanerf_imp,weanerm_imp,reprod_loc,reprod_imp/
notadult_loc(aaact)    /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc/
notadult_imp(aaact)    /youngf_imp,youngm_imp,weanerf_imp,weanerm_imp/



*-- crop and grazing related sets
c           'all crops that are produced by the household'   /beans,maize,napier,tea,sorghum,groundnut/
food(c)     'food crops'                                     /beans,maize,sorghum,groundnut/
fodder(c)   'fodder crops'                                   /napier/
cash(c)     'cash crops'                                     /tea/


feed                      'feed sources'                                 /maize_residue,cpea_residue,soyb_residue,grnut_residue,bean_residue,sorgh_residue,sunflower_seed_cake,cotton_seed_cake,maize_bran,grass,grass_hay,napier/
feed_off_farm(feed)       'feed from off farm'                           /sunflower_seed_cake,cotton_seed_cake,maize_bran/
feed_on_farm(feed)        'feed from on farm'                            /maize_residue,cpea_residue,soyb_residue,grnut_residue,bean_residue,sorgh_residue,grass,grass_hay,napier/
residues(feed)            'crop residues'                                /maize_residue,bean_residue,grnut_residue,sorgh_residue,soyb_residue,cpea_residue/
grazed(feed)              'grazed feed intake'                           /grass/
ration(feed)              'feeds that are provided in ration'            /maize_residue,bean_residue,cpea_residue,grnut_residue,sorgh_residue,soyb_residue,grass_hay,napier/
*sunflower_seed_cake,cotton_seed_cake,maize_bran,


**-- Mappings

crop_residue(c,residues) /maize.maize_residue,beans.bean_residue,groundnut.grnut_residue,sorghum.sorgh_residue/
fodder_feed(fodder,feed) /napier.napier/
residues_ration(residues,ration) /maize_residue.maize_residue,bean_residue.bean_residue,grnut_residue.grnut_residue,sorgh_residue.sorgh_residue,soyb_residue.soyb_residue,cpea_residue.cpea_residue/
;
x(hh,aaact,type,inten,lasty,lastm)=0;

*v_residuesbuy.fx(reg,inout,year,m)=0;
*v_residuessellm.fx(reg,inout,year,m)=0;

p_s(hh,feed)=p_feedSupply(hh,feed);



*v_residuesfeedm.fx(hh,feed,y,'m06')$(ord(y) gt 1)=   300;
*v_residuesbuy.fx(hh,feed,y,m)         =0;



** Variable Bounds  (to prevent calcualtion errors)
** feed related bounds
v_feedbalance.lo(hh,feed,y,m)= -eps;
v_residuesfeedm.lo(hh,residues,y,m)=-eps;
v_feedbuy.lo(hh,feed,y,m)=-eps;
v_feedbuy.fx(hh,feed_on_farm,y,m)=0;
v_feedons.lo(hh,feed,y,m)=-eps;

**animal related bounds
v_aactLev.lo(hh,aaact,type,inten,minten,year,m)=0;
v_aactLevbuy.lo(hh,aaact,type,inten,minten,year,m)=0;
v_aactLevsell.lo(hh,aaact,type,inten,minten,year,m)=0;

** productivity related bounds
v_prodQmilk.fx(hh,notadultf,type,inten,year,m)=0;

v_fdcons.lo(hh,aaact,type,inten,y,m,feed)=0;






*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
* #3 Equations  (all variables are declared in terms of sets specifically defined to this model scenario)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
Equations


*-- production equations
   E_milkproduction   'milk produced'
   E_meatproduction   'meat produced from slaughtered animals'

*-- Feed balance equations
   E_feedbal       'livestock feed balance accounting equation'
   E_feedons       'total amount of a feed consumed per month'
   feed_purchased
*-- Labor equation
   E_laborAA     'labor use for livestock activities'

*-- Rangeland requirement and availability
   E_grazing_demand
   E_rangeland

*-- Feed and nutrition equations
   E_dryMatterIntake_grazed
   E_dryMatterIntake_stallfd
   E_dryMatterIntake
   E_grazing_demand
   E_grossEnergy
   E_energySource
   E_netenergy
   E_netenergy_stallfd
   E_netenergy_grazed
   E_digestibleEnergy
   E_feedIntake
   E_grazed_intake
   E_energyRequired
;

**Equation Definitions



*--  livestock production
* milk
E_milkproduction(hh,aaact,type,inten,y,m)..   v_prodQmilk(hh,aaact,type,inten,y,m) =e= p_milkprod(aaact,type,inten)*30*Sum(minten,v_aactLev(hh,aaact,type,inten,minten,y,m));

* meat
E_meatproduction(hh,aaact,type,inten,y,m)..    v_prodQmeat(hh,aaact,type,inten,y,m)  =e= p_salesw(aaact,type,inten)*Sum(minten,v_aactLevsell(hh,aaact,type,inten,minten,y,m));


* labour demand
E_laborAA(hh,y,m)..            sum((aaact,inten,type,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*p_labour_lives(m,inten,aaact,type)) + Sum((aaact,type,inten),v_dryMatterIntake_stallfd(hh,y,m,aaact,type,inten)*20/1000)  =e= v_totallabourdemlive(hh,y,m);

* rangeland required
E_grazing_demand(hh,y)..                           v_graze_dmd(hh,y) =e= (1/1000)*Sum((aaact,type,inten,minten,m),30*(v_aactLev(hh,aaact,type,inten,minten,y,m)*v_dryMatterIntake_grazed(hh,y,m,aaact,type,inten)))/sum(m,p_forage_yield(y,m));

* rangeland available
E_rangeland(hh,y)..                                         v_graze_dmd(hh,y) =l= p_rangeland(hh,y);



**-- Feed balance equations
E_feedons(hh,feed,y,m)..v_feedons(hh,feed,y,m) =e= sum((aaact,type,inten,minten)$v0_aactLev(hh,aaact,type,inten,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*v_fdcons(hh,aaact,type,inten,y,m,feed));


feed_purchased(hh,feed_off_farm,y,m)..                          v_feedbuy(hh,feed_off_farm,y,m) =e= v_feedons(hh,feed_off_farm,y,m);

E_feedbal(hh,ration,y,m).. v_feedbalance(hh,ration,y,m-1)*(p_transferrate)$(ord (m) gt 1) + v_feedbalance(hh,ration,y-1,'m12')*(p_transferrate)$((ord (y) gt 1


v_aactLevsell.fx(hh,'adultf_imp',type,inten,minten,'y01','m01')$(ord(y2) gt 1) = v_aactLev.l(hh,'adultf_imp',type,inten,minten,'y01','m12')*p_grad('adultf_imp',type,inten)*(1-p_mort('adultf_imp',type,minten));
v_aactLevsell.fx(hh,'adultf_loc',type,inten,minten,'y01','m01')$(ord(y2) gt 1)= v_aactLev.l(hh,'adultf_loc',type,inten,minten,'y01','m12')*p_grad('adultf_loc',type,inten)*(1-p_mort('adultf_loc',type,minten));
                E_netenergy_stallfd(hh,y,m,aaact,type,inten)..    v_netEnergy_stallfd(hh,y,m,aaact,type,inten)  =e=     Sum((ration),v_fdcons(hh,aaact,type,inten,y,m,ration)*p_dryMatter(ration)*p_netEnergy(ration));

E_netenergy_grazed(hh,y,m,aaact,type,inten)..     v_netEnergy_grazed(hh,y,m,aaact,type,inten)    =e=     Sum((grazed),v_fdcons(hh,aaact,type,inten,y,m,grazed)*p_dryMatter(grazed)*p_netEnergy(grazed));

*E_netenergy(hh,y,m,aaact,type,minten,inten)..             v_netEnergy(hh,aaact,type,inten,minten,y,m) =e= Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_netEnergy(feed));



*fix starting values for livestock numbers in first month and first year (assume extensive to begin)
v_aactLev.fx(hh,aaact,type,inten,minten,'y01','m01')=v0_aactLev(hh,aaact,type,inten,minten);
*fix all livestock numbers to zero if livestock are not observed in first month and first year (note, this should be not be included when breed selection is a decision variable)
*v_aactLev.fx(hh,aaact,type,inten,minten,y,m)$(v0_aactLev(hh,aaact,type,inten,minten)=0)=0;

*can't sell, buy, or consume any young, weaner or reproduction livestock or livestock that weren't in first month and first year
*v_aactLevsell.fx(hh,aaact,type,inten,minten,y,m)$(v0_aactLev(hh,aaact,type,inten,minten)=0)=0;
*v_aactLevbuy.fx(hh,aaact,type,inten,minten,y,m)$(v0_aactLev(hh,aaact,type,inten,minten)=0)=0;
* can't sell, buy, or slaughter local reproduction animals
*v_aactLevsell.fx(hh,'reprod_loc',type,inten,minten,y,m)=0;
v_aactLevbuy.fx(hh,'reprod_loc',type,inten,minten,y,m)=0;
* can't sell, buy, or slaughter reproductive animals
*v_aactLevsell.fx(hh,'reprod_imp',type,inten,minten,y,m)=0;
v_aactLevbuy.fx(hh,'reprod_imp',type,inten,minten,y,m)=0;
v_aactLevSELL.fx(hh,'reprod_imp',type,inten,minten,y,m)=0;
v_aactLevSELL.fx(hh,'reprod_loc',type,inten,minten,y,m)=0;

* can't sell, buy, or slaughter non adults
*v_aactLevsell.fx(hh,notadult,type,inten,minten,y,m)=0;
v_aactLevsell.fx(hh,'weanerf_loc',type,inten,minten,y,m)=0;
v_aactLevsell.fx(hh,'weanerf_imp',type,inten,minten,y,m)=0;
v_aactLevsell.fx(hh,'weanerf_loc',type,inten,minten,y,m)=0;
v_aactLevsell.fx(hh,'weanerm_imp',type,inten,minten,y,m)=0;

v_aactLevbuy.fx(hh,young,type,inten,minten,y,m)=0;
v_aactLevsell.fx(hh,young,type,inten,minten,y,m)=0;

*v_aactLevsell.fx(hh,aaact,type,inten,lasty,lastm)=0;
*v_aactLevbuy.fx(hh,aaact,type,inten,lasty,lastm)=0;
*v_aactLevslaughter.fx(hh,aaact,type,inten,lasty,lastm)=0;

*v_residuesbuy.fx(reg,inout,year,m)=0;
*v_residuessellm.fx(reg,inout,year,m)=0;



*v_residuesfeedm.fx(hh,feed,y,'m06')$(ord(y) gt 1)=   300;
*v_residuesbuy.fx(hh,feed,y,m)         =0;



** Variable Bounds  (to prevent calcualtion errors)
** feed related bounds
v_feedbalance.lo(hh,feed,y,m)= -eps;
v_residuesfeedm.lo(hh,residues,y,m)=-eps;
v_feedbuy.lo(hh,feed,y,m)=-eps;
v_feedbuy.fx(hh,feed_on_farm,y,m)=0;
v_feedons.lo(hh,feed,y,m)=-eps;

**animal related bounds
v_aactLev.lo(hh,aaact,type,inten,minten,year,m)=0;
v_aactLevbuy.lo(hh,aaact,type,inten,minten,year,m)=0;
v_aactLevsell.lo(hh,aaact,type,inten,minten,year,m)=0;

** productivity related bounds
v_prodQmilk.fx(hh,notadultf,type,inten,year,m)=0;

v_fdcons.lo(hh,aaact,type,inten,y,m,feed)=0;
*v_fdcons.fx(hh,aaact,type,inten,y,m,ration)=0;
v_feed_crop_land.fx(hh,y)=0.05;




