$ontext
This module has the purpose of defining the objective function of the global model. Note that the objective function that gets executed is dependent on whether risk is turned on/off
in 'gen_baseline.gms'

$offtext



Variables
v_off_farm_income(hh,y)           'Off farm income (lc/hh/year)'
v_income_lives(hh,y,m)            'Income from livestock activities (lc/hh/year)'
v_income_crop(hh,y,m)             'Income from cropping activities (lc/hh/year)'
v_npv                             'Net present value (lc/hh)'
v_milk_revenue_contract(hh,y,m)
v_milk_revenue_informal(hh,y,m)
;


Equations
         e_objective1                     'Objective function when credit is turned off'
         e_objective2                     'Objective function when credit is turned on'
         e_offfarm_income_wo_loan         'Off farm income (lc/hh/year)'
         e_offfarm_income_w_loan          'Off farm income (lc/hh/year)'
         e_farm_income_lives              'Livestock income income definition (lc/hh/year)'
         e_farm_income_crop               'Crop enterprise income definition (lc/hh/year)'
         e_crop_expenses                  'Annual expenses on crop production (lc/hh/year)'
         e_livestock_expenses             'Annual expenses on livestock production (lc/hh/year)'
         e_total_income                   'Total household income (farm plus off farm) in a given year (lc/hh/year)'
         e_milk_revenue_contract
         e_milk_revenue_informal
         e_minimum_nutrient               'Specify minimum required nutrient intake from farm produce (crops)'
         e_milk_contract                  'Specify terms of milk contract'
         e_milk_no_contract               'Constraint on milk for when there is no option of a contract'
;

e_offfarm_income_w_loan(hh,y)..                 v_off_farm_income(hh,y) =e=   p_offFarmIncome(hh) -p_r_loan(hh)*v_loan_principle(hh,y)   - v_loan_installment(hh,y)    ;

e_offfarm_income_wo_loan(hh,y)..                v_off_farm_income(hh,y) =e=   p_offFarmIncome(hh)    ;

e_crop_expenses(hh,y,m)..                       v_crop_expenses(hh,y,m)  =e=  v_labour_hired_crop(hh,y,m)*p_labourPrice(hh) + Sum(c,v_areaCrop(hh,y,c)*p_cropcosts(hh,c)/12);

e_livestock_expenses(hh,y,m)..                  v_lives_expenses(hh,y,m) =e=
(
sum((aaact,type,inten,minten),v_aactLevbuy(hh,aaact,type,inten,minten,y,m)*p_purchPrice(hh,aaact))
+v_labour_hired_lives(hh,y,m)*p_labourPrice(hh)
+sum((feed_off_farm),v_feedbuy(hh,feed_off_farm,y,m)*p_feedprice(feed_off_farm))
+sum((aaact,type,inten,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*p_maintExpense(hh,aaact,type,minten)/12)
);

e_minimum_nutrient(hh,y,nut)..                  Sum((m,food),v_prdCrop(hh,y,food,m)*p_nutrientproperty(food,nut)) =g= p_hhold_adult_equivalents(hh)*p_nutrientrequirement(hh,nut)*p_FRAC_farmproduce(nut);

e_farm_income_crop(hh,y,m)..                    v_income_crop(hh,y,m) =e=  Sum((cash), v_prdCrop(hh,y,cash,m)*p_crop_sell_price(hh,y,cash))  - v_crop_expenses(hh,y,m);
*Sum(cash,v_crop_sales_cash(hh,y,cash)*p_crop_sell_price(hh,y,cash))

e_farm_income_lives(hh,y,m)..                   v_income_lives(hh,y,m) =e= sum((type,inten,aaact),v_prodQmeat(hh,aaact,type,inten,y,m)*p_meatPrice)+   v_milk_revenue_contract(hh,y,m)  + v_milk_revenue_informal(hh,y,m)  - v_lives_expenses(hh,y,m);

e_milk_revenue_contract(hh,y,m)..                v_milk_revenue_contract(hh,y,m) =e=  v_Qmilk_marketed_contract(hh,y,m) * p_milkPrice_contract ;

e_milk_revenue_informal(hh,y,m)..                v_milk_revenue_informal(hh,y,m)  =e=  v_Qmilk_marketed_informal(hh,y,m) * p_milkPrice;


e_milk_contract(hh,y,m)..                       v_Qmilk_marketed_contract(hh,y,m) =l= 10000/12 ;

e_milk_no_contract(hh,y,m)..                    v_Qmilk_marketed_contract(hh,y,m)  =e= 0;

e_total_income(hh,y,m)..                        v_income(hh,y,m) =e=   v_income_lives(hh,y,m)  +  v_income_crop(hh,y,m)  +v_off_farm_income(hh,y)/12 ;    !! revise this to take into account credit expenses
*- v_tot_credit_expenses(hh,y,m)      ;
*
* v_off_farm_income(hh,y)/12
e_objective1..                                  v_npv =e= sum( (hh,y,m) ,v_income(hh,y,m) + v_leisure(hh,y,m)*p_offFarm_wage(hh)*8*.02 / ( 1 + power(p_r,ord(y)) ) )   ;

*e_objective2.. v_npv =e= sum( (hh,y,m) ,(v_income(hh,y,m)- v_stddev_income(hh,y,m)) / ( 1 + power(p_r,ord(y)) ) )   ;




Model simulation_model
/
$ifi %RISK%==OFF  e_objective1
$ifi %RISK%==ON   e_objective2
$ifi %CREDIT%==OFF  e_offfarm_income_wo_loan
$ifi %CREDIT%==ON   e_offfarm_income_w_loan
 e_farm_income_lives
 e_farm_income_crop
 e_total_income
*$ifi %CREDIT%==OFF e_total_income1
*$ifi %CREDIT%==ON  e_total_income2
 e_milk_revenue_contract
 e_milk_revenue_informal
 e_livestock_expenses
 e_crop_expenses
 e_minimum_nutrient
*$ifi %output_SCEN%==ON e_milk_contract
$ifi %output_SCEN%==OFF e_milk_no_contract
/
