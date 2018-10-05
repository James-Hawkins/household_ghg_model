$ontext
This module includes all general equations related to the household, including labour constraints, cash constraints, and conditions relating to credit expenses.

$offtext



Parameters
p_labouravailablehome(hh,y,m)           'Monthly labour available from household members (person-days per month per household)'
hhold_members(hh,hhold_member)          'Number of people of a given age class in the household'
p_offFarmIncome(hh)                     'Annual off-farm income (lc/hh/year)'
p_credit_interest(hh)                   'Annual expenses on credit interest (lc/hh/year)'
p_cash(hh)                              'Cash balance in beginning month (lc/hh)'
;




Nonnegative Variables
v_hhold_expen(hh,y,m)                'Household expenditure (lc/hh/month)'
v_income(hh,y,m)                     'Total household income (lc/hh/yr)'
v_cash(hh,y,m)                       'Cash available for the household in a given year (lc)'
v_labour_hired(hh,y,m)               'Total hired labour in a given month'
v_labourcrophome(hh,y,m)             'Home labour dedicated to cropping activities (person-days/month)'
v_labourliveshome(hh,y,m)            'Home labour dedicated to livestock activities (person-days/month)'
v_cons(hh,y,m,good)                  ''
v_labour_hired_lives(hh,y,m)         'Hired labour for livestock activities (person-days/month)'
v_labour_hired_crop(hh,y,m)          'Hired labour for cropping activities (person-days/month)'
v_leisure(hh,y,m)                    'Leisure time (person-days/household/month)'
v_tot_credit_expenses(hh,y,m)        'Total loan expenses in a given month (lc/month)'
v_lives_expenses(hh,y,m)             'Total livestock expenses in a given month (lc/month)'
v_crop_expenses(hh,y,m)              'Total crop expenses in a given month (lc/month)'

v_Qmilk_hcons(hh,y,m)                'Milk consumed at home (kg/household/month)'
v_Qmilk_marketed(hh,y,m)             'Total amount of milk marketed (kg/household/month)'
v_Qmilk_marketed_contract(hh,y,m)    'Total amount of milk marketed via a contract (kg/household/month)'
v_Qmilk_marketed_informal(hh,y,m)    'Total amount of milk marketed informally (kg/household/month)'
v_Land_use(hh,y)                     'Total on farm and upstream land use (ha)'
v_crop_Land_use(hh,y)                'Total land dedicated to feed crops (ha)'
;

*specify home consumption of milk and household expenditure
v_Qmilk_hcons.fx(hh,y,m)=5*45/12;
v_hhold_expen.fx(hh,y,laterm)=4000000/12;

*variable bounds
v_leisure.lo(hh,y,m)=0;
v_labour_hired_crop.lo(hh,y,m)=0;

Equations
e_cashconstraint           'Cash constraint when credit is turned off'
e_cashconstraint2          'Cash constraint when credit turned on'
e_cash_flow                'Cash flow equation without credit'
e_cash_flow2               'Cash flow equation with credit'
e_loan_payments            'Payments on loans in a given period'
e_labourbalancetotal       'Labour balance equation'
e_labourbalancecrop        'Labour balance equation for crops'
e_labourbalancelives       'Labour balance equation for livestock'
e_homelabour               'Home labour balance equation'
e_credit_expenses          'Credit expenses in a given month (lc/household/month)'
e_home_produce_demand      'Consumption of home produced food '
e_home_food_demand         'Consumption of milk produced by the household'
e_dairy_land_use           'Calculate sum of cropland, pastureland, and rangeland (ha)'
e_cons                     'Calculate consumption of food and non-food goods'
e_milk_marketed            'Total amount of milk marketed'
e_feed_crop_land           'Total land dedicated to feed crops'
e_feed_crop_land_on_farm   'Total land dedicated to feed crops on farm'
e_feed_crop_land_off_farm  'Total land dedicated to feed crops off farm'
;


*-- Cash constraint

e_cashconstraint(hh,y,m)..   v_lives_expenses(hh,y,m) + v_crop_expenses(hh,y,m) +  sum(good, v_cons(hh,y,m,good))   =l=  v_cash(hh,y-1,'m12')$((ord(y) gt 1) and (ord(m) eq 1)) + v_cash(hh,y,m)$(ord(m) gt 1) + p_cash(hh)$((ord(y) eq 1) and (ord(m) eq 1))  ;
*v_hhold_expen(hh,y,m)   + v_cash(hh,y,m-1)$(ord(m) gt 1)
e_cashconstraint2(hh,y,m)..   v_lives_expenses(hh,y,m) + v_crop_expenses(hh,y,m) +  sum(good, v_cons(hh,y,m,good)) +   v_tot_credit_expenses(hh,y,m) =l=  v_cash(hh,y,m)$(ord(y) gt 1) + v_cash(hh,y,m-1)$(ord(m) gt 1)  + p_cash(hh)$((ord(y) eq 1) and (ord(m) eq 1)) + (1/12)*v_loan(hh)  ;
*+ p_offFarmIncome(hh)*(1/12)

e_cash_flow(hh,y,m)..          v_cash(hh,y,m) =e= p_cash(hh)$((ord(y) eq 1) and (ord(m) eq 1)) + v_cash(hh,y,m-1)$(ord(m) gt 1) + v_cash(hh,y-1,'m12')$((ord(m) eq 1) and (ord(y) gt 1))  + (v_income(hh,y,m-1)$(ord(m) gt 1)) + v_income(hh,y-1,'m12')$((ord(y) gt 1) and (ord(m) eq 1))- sum(good, v_cons(hh,y,m,good)) ;
*- ((v_lives_expenses(hh,y-1,'m12') + v_crop_expenses(hh,y-1,'m12'))$((ord(m) eq 1) and (ord(y) gt 1))) - ((v_lives_expenses(hh,y,m-1) + v_crop_expenses(hh,y,m-1))$(ord(m) gt 1));
*+  p_offFarmIncome(hh)*(1/12)
*+ (v_income(hh,y-1,'m12')$((ord(y) gt 1) and (ord(m) eq 1)))
e_cash_flow2(hh,y,m)..          v_cash(hh,y,m) =e= p_cash(hh)$((ord(y) eq 1) and (ord(m) eq 1)) + v_cash(hh,y,m-1)$(ord(m) gt 1) + v_cash(hh,y-1,'m12')$((ord(m) eq 1) and (ord(y) gt 1)) + (v_income(hh,y,m)$(ord(m) gt 1)) + (v_income(hh,y-1,'m12')$((ord(y) gt 1) and (ord(m) eq 1)))  - sum(good, v_cons(hh,y,m,good)) - (v_tot_credit_expenses(hh,y-1,'m12'))$((ord(m) eq 1) and (ord(y) gt 1))
- ((  v_tot_credit_expenses(hh,y,m))$(ord(m) gt 1) );
*v_lives_expenses(hh,y,m-1) + v_crop_expenses(hh,y,m-1)

e_credit_expenses(hh,y,m)..                     (1/12)*v_credit_interest(hh,y,m)$(ord(y) gt 1) + (1/12)*v_loan_installment(hh,y)$(ord(y) gt 1) + (1/12)*p_credit_interest(hh)$(ord(y) eq 1) + (1/12)*p_loan_installment(hh)$(ord(y) eq 1) =e= v_tot_credit_expenses(hh,y,m) ;

e_labourbalancetotal(hh,y,m)..                  v_totallabourdemcrop(hh,y,m)   + v_totallabourdemlive(hh,y,m)    =e= p_labouravailablehome(hh,y,m) - v_leisure(hh,y,m) + v_labour_hired_crop(hh,y,m) + v_labour_hired_lives(hh,y,m);

e_labourbalancecrop(hh,y,m)..                   v_totallabourdemcrop(hh,y,m)      =e= v_labourcrophome(hh,y,m) + v_labour_hired_crop(hh,y,m) ;

e_labourbalancelives(hh,y,m)..                  v_totallabourdemlive(hh,y,m)    =e= v_labourliveshome(hh,y,m) + v_labour_hired_lives(hh,y,m) ;

e_cons(hh,y,m,good)$(ord(m) gt 1)..                           v_cons(hh,y,m,good) =e= 100000*(0.75 + 0.55*(v_income(hh,y,m) - sum(good2,v_cons(hh,y,m,good2))))/1;

*e_cons(hh,y,m,good)..                           v_cons(hh,y,m,good) =e= (0.75 + 0.5*(v_income(hh,y,m) - sum(good2,v_cons(hh,y,m,good2))));

*(.4)*v_cash(hh,y,m)    ;
*


e_home_produce_demand(hh,food,y,m)..            v_prdCrop(hh,y,food,m)   =e= v_crp_cons(hh,y,food,m);

e_home_food_demand(hh,y,m)..                    sum((type,inten,aaact),v_prodQmilk(hh,aaact,type,inten,y,m)) =e= v_Qmilk_marketed(hh,y,m)  + v_Qmilk_hcons(hh,y,m);

e_milk_marketed(hh,y,m)..                       v_Qmilk_marketed_contract(hh,y,m)  + v_Qmilk_marketed_informal(hh,y,m) =e= v_Qmilk_marketed(hh,y,m) ;

e_homelabour(hh,y,m)..                          p_labouravailablehome(hh,y,m)   =e=   v_labourcrophome(hh,y,m) +  v_labourliveshome(hh,y,m) + v_leisure(hh,y,m)  ;

e_dairy_land_use(hh,y)..                        v_Land_use(hh,y) =e= sum(fodder,v_areaCrop(hh,y,fodder)) +  v_pasture_land(hh,y) +   v_graze_dmd(hh,y)   + sum((m,feed_off_farm),(1/1000)*v_feedbuy(hh,feed_off_farm,y,m)*1);

e_feed_crop_land(hh,y)..                        v_feed_crop_land(hh,y)  =e=   Sum(fodder,v_areaCrop(hh,y,fodder))   +  Sum((feed_off_farm,m), (1/1000)*v_feedbuy(hh,feed_off_farm,y,m)/p_yield_feed_crop(feed_off_farm));

e_feed_crop_land_on_farm(hh,y)..                v_feed_crop_land_on_farm(hh,y)  =e=   Sum(fodder,v_areaCrop(hh,y,fodder))   ;

e_feed_crop_land_off_farm(hh,y)..               v_feed_crop_land_off_farm(hh,y)  =e=    Sum((feed_off_farm,m), (1/1000)*v_feedbuy(hh,feed_off_farm,y,m)/p_yield_feed_crop(feed_off_farm));



Model Householdmod
/
*$ifi %CREDIT%==OFF e_cashconstraint
$ifi %CREDIT%==ON e_cashconstraint2
$ifi %CREDIT%==OFF e_cash_flow
$ifi %CREDIT%==ON e_cash_flow2
e_labourbalancetotal
e_labourbalancecrop
e_labourbalancelives
e_dairy_land_use
e_cons
$ifi %CREDIT%==ON e_credit_expenses
e_homelabour
e_home_produce_demand
e_home_food_demand
*e_dairy_crop_land_use
e_milk_marketed
e_feed_crop_land
e_feed_crop_land_on_farm
e_feed_crop_land_off_farm
/

