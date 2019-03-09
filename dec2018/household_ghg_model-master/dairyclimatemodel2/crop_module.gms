$ontext
This module includes all equations relating to the crop enterprise, including crop areas, crop production, labour requirements for cropping activities, and accounting equations for
different crop products (e.g. maize as silage vs. grain, residues)

$offtext


Parameters
p_yldCrop(hh,c,m)                  'Crop yield (kg/ha/month)'
p_arable_land(hh,y)                'Arable land per household (ha)'
p_total_land(hh,y)                 'Total land per household (ha)'
p_labourdemcrop(c,m)               'Total labour requirements for crop activties (person-days/household/month)'
p_crop_sell_price(hh,y,c)          'Selling price of crops (TSh/kg)'
p_cropcosts(hh,c)                  'Costs of crop production (TSh/ha/year)'
p_yield_feed_crop(feed_off_farm)   'Yield of feed crops produced off farm (kg/ha)'
;
p_yield_feed_crop(feed_off_farm)=crop_yield_off_farm(feed_off_farm,'yield');

Variables
v_prdCrop(hh,y,c,m)                     'Crop production (Mg/m)'
v_crop_sales_cash(hh,y,cash)            'Cash crops (Mg)'
v_crop_food(hh,y,food)                  'Food crops produced (Mg)'
v_crp_feed(hh,y,feed,m)                 'Fodder crops produced (Mg)'
v_crp_cons(hh,y,food,m)                 'kg of food crop consumed per month by the household (kg/hh/year)'
v_totallabourdemcrop(hh,y,m)            'Monthly labour demand for cropping activities (person-days per month)'
v_residuesfieldm(hh,residues,y,m)       'Residues left on field (kg)'
v_residues(hh,y,residues,m)             'Residues produced (kg/year)'
v_residuesfeedm(hh,residues,year,m)     'residues of feed coming from on farm production'
v_feed_crop_land(hh,y)                  'Total land for feed crops (ha/hh/year)'
v_feed_crop_land_off_farm(hh,y)         'Total land for feed crops produced off farm (ha/year)'
v_feed_crop_land_on_farm(hh,y)          'Total land for feeds crops produced on farm (ha/year)'
;

Nonnegative Variables
v_areaCrop(hh,y,c)            'Area dedicated to crop c (ha/hh/year)'
;

** Variable bounds
v_areaCrop.lo(hh,y,c)=0;

Equations
e_arable_land                     'Arable land constraint (for crops, excluding pasture)'
e_total_land_holdings             'Total land constraint (for all crops plus pasture)'
e_crp_prd                         'Define crop production (Mg/ha/yr) based on area and yield'
e_crp_fate_food_byprd             'Define the quantity of residues produced (Mg)'
e_food_silage                     'Define amount of maize being used as maize silage'
e_residues_prod                   'Accounting equation for the fate of residues'
e_residues_field                  'Define quantity of residues left on field (Mg)'
e_labourdemand                    'Define the labour required for cropping activities (person-days per household per month)'
;


e_arable_land(hh,y)..                            Sum(crop_not_pasture(c),v_areaCrop(hh,y,c)) =e=   p_arable_land(hh,y)    ;

e_total_land_holdings(hh,y)..                    Sum(c,v_areaCrop(hh,y,c))        =l= p_total_land(hh,y) ;

e_crp_prd(hh,y,c,m)..                            v_areaCrop(hh,y,c)*p_yldCrop(hh,c,m)/1000     =e=  v_prdCrop(hh,y,c,m)  ;

e_crp_fate_food_byprd(hh,y,residues,m)..         v_residues(hh,y,residues,m) =e= Sum(crop_residue(food,residues), (v_prdCrop(hh,y,food,m)/p_harvestindex(food)) - v_prdCrop(hh,y,food,m) )/12;

e_food_silage(hh,y,m)..                          v_prdCrop(hh,y,'maize',m) =e=   v_crp_cons(hh,y,'maize',m) + Sum(crop_silage('maize','maize_silage'),v_crp_feed(hh,y,'maize_silage',m));

e_residues_prod(hh,y,residues,m)..               v_residues(hh,y,residues,m) =e=   v_residuesfeedm(hh,residues,y,m) + v_residuesfieldm(hh,residues,y,m);

e_residues_field(hh,y,residues,m)..              v_residuesfieldm(hh,residues,y,m) =e=   Sum(crop_residue(food,residues), v_residues(hh,y,residues,m)*p_res_FRAC_soil(hh,food));

e_labourdemand(hh,y,m)..                         Sum((c),v_areaCrop(hh,y,c)*p_labourdemcrop(c,m))    =e= v_totallabourdemcrop(hh,y,m);




Model cropMod
/
e_arable_land
e_total_land_holdings
e_crp_prd
e_crp_fate_food_byprd
e_food_silage
e_residues_prod
e_residues_field
e_labourdemand
/

