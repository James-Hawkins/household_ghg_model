$ontext
This module has the purpose of calculating the standard deviation in net present value based on random input and output prices.
The standard deviations for dairy outputs (milk and meat), inputs (feeds and replacment animals), and on cash crops is based on the the distributions of the variables
obtained fromt the survey. The standard deviation of NPV is then calculated using a monte carlo type method as described in the paper. This involves calculating
the NPV over 100 different iterations, drawing randomly from the distbributions of the four random variables, and then calculating the random NPV these 100 different random NPVs.
$offtext




Set i /i1*i100/

Parameters
sigma_output(outputs)   'Standard deviation of output prices'
/
milk 15
meat 45
/

sigma_feed(feed_off_farm)  'Standard deviation of feed prices'
/
maize_bran            40
sunflower_seed_cake   20
/

sigma_animals(aaact)     'Standard deviation of replacement animal prices'
/
adultf_imp 25
adultf_loc 25
reprod_loc 25
reprod_imp 25
/

sigma_cash_crop(cash)  'Standard deviation of cash crop prices'
/
banana 30
/

OPV(i,outputs)                  'Output price variability'
FPV(i,feed_off_farm)            'Feed price variability'
APV(i,aaact)                    'Animal price variability'
CCPV(i,*)                       'Cash crop price variability'
;

*Specify distributions of cash crop prices, input prices (feeds and animals), and milk and meat prices
CCPV(i,'banana')=normal(1,sigma_cash_crop('banana'));
FPV(i,feed_off_farm)=normal(1,sigma_feed(feed_off_farm));
APV(i,aaact)=normal(1,sigma_animals(aaact));
OPV(i,'milk')= normal(1,sigma_output('milk'));
OPV(i,'meat')= normal(1,sigma_output('meat'));



Variables
v_off_farm_income(hh,y)                     'Off farm income (TSh/hh/year)'
v_income_lives_rd(hh,i,y,m)                 'Income from livestock activities (TSh/hh/year)'
v_lives_expenses_rd(hh,i,y,m)               'Random livestock expenses in ith iteration (TSh/hh/month)'
v_income_crop_rd(hh,i,y,m)                  'Income from cropping activities (Tsh/hh/year)'
v_income_rd(hh,i,y,m)                       'Random income in ith iteration (TSh/hh/month)'
v_npv                                       'Net present value (lc/hh)'
v_dev(i,hh,y,m)                             'Standard deviation of net present value'
v_stddev_income(hh,y,m)                     'Standard deviation of income'
;


Equations
         e_offfarm_income_wo_loan_rd         'Off farm income (lc/hh/year)'
         e_offfarm_income_w_loan_rd          'Off farm income (lc/hh/year)'
         e_farm_income_lives_rd              'Livestock income income definition (lc/hh/year)'
         e_farm_income_crop_rd               'Crop enterprise income definition (lc/hh/year)'
         e_crop_expenses_rd                  'Annual expenses on crop production (lc/hh/year)'
         e_livestock_expenses_rd             'Annual expenses on livestock production (lc/hh/year)'
         e_total_income_rd                   'Total household income (farm plus off farm) in a given year (lc/hh/year)'
         e_milk_contract_rd                  'Specify terms of milk contract'
         e_milk_no_contract_rd               'Specify no milk is marketed under purchase agreement'
         e_dev                               'Specify deviation of income for ith iteration'
         e_stdddev                           'Specify standard deviation of income'
         e_objective2                        'Net present value'
;

e_offfarm_income_w_loan_rd (hh,y)..        v_off_farm_income(hh,y) =e=   p_offFarmIncome(hh) -p_r_loan(hh)*v_loan_principle(hh,y)   - v_loan_installment(hh,y)    ;

e_offfarm_income_wo_loan_rd (hh,y)..       v_off_farm_income(hh,y) =e=   p_offFarmIncome(hh)    ;

e_crop_expenses_rd (hh,y,m)..              v_crop_expenses(hh,y,m)  =e=  v_labour_hired_crop(hh,y,m)*p_labourPrice(hh) + Sum(c,v_areaCrop(hh,y,c)*p_cropcosts(hh,c)/12);

e_livestock_expenses_rd(hh,i,y,m)..        v_lives_expenses_rd(hh,i,y,m) =e=
                                              sum((aaact,type,inten,minten),v_aactLevbuy(hh,aaact,type,inten,minten,y,m)*p_purchPrice(hh,aaact)*APV(i,aaact))
                                           +  v_labour_hired_lives(hh,y,m)*p_labourPrice(hh)
                                           +  sum((feed_off_farm),v_feedbuy(hh,feed_off_farm,y,m)*p_feedprice(feed_off_farm)*FPV(i,feed_off_farm))
                                           +  sum((aaact,type,inten,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*p_maintExpense(hh,aaact,type,minten)/12);

e_farm_income_crop_rd (hh,i,y,m)..         v_income_crop_rd(hh,i,y,m) =e=  Sum((cash), v_prdCrop(hh,y,cash,m)*p_crop_sell_price(hh,y,cash)*CCPV(i,'banana'))  - v_crop_expenses(hh,y,m);

e_farm_income_lives_rd(hh,i,y,m)..         v_income_lives_rd(hh,i,y,m) =e=  v_Qmilk_marketed_contract(hh,y,m) * p_milkPrice_contract + v_Qmilk_marketed_informal(hh,y,m) * p_milkPrice * OPV(i,'milk') - v_lives_expenses_rd(hh,i,y,m);
* sum((type,inten,aaact),v_prodQmeat(hh,aaact,type,inten,y,m)*p_meatPrice*OPV(i,'meat'))+


e_milk_contract_rd (hh,y,m)..              v_Qmilk_marketed_contract(hh,y,m) =l= 10000/12 ;

e_milk_no_contract_rd (hh,y,m)..           v_Qmilk_marketed_contract(hh,y,m)  =e= 0;

e_total_income_rd(hh,i,y,m)..              v_income_rd(hh,i,y,m) =e=  v_off_farm_income(hh,y)/12 + v_income_crop_rd(hh,i,y,m) + v_income_lives_rd(hh,i,y,m)  ;

e_dev(i,hh,y,m)..                          v_dev(i,hh,y,m) =e= v_income(hh,y,m) - v_income_rd(hh,i,y,m)   ;

e_stdddev(hh,y,m)..                        v_stddev_income(hh,y,m) =e=  SQRT{ SUM(i,power(v_dev(i,hh,y,m),2))/CARD(i)}   ;

e_objective2..                             v_npv =e= sum( (hh,y,m) ,((v_income(hh,y,m) - 0.25*v_stddev_income(hh,y,m)) / ( 1 + power(p_r,ord(y))) ) )   ;



Model risk_module
/
$ifi %CREDIT%==OFF  e_offfarm_income_wo_loan_rd
$ifi %CREDIT%==ON   e_offfarm_income_w_loan_rd
 e_farm_income_lives_rd
 e_farm_income_crop_rd
 e_total_income_rd
 e_livestock_expenses_rd
 e_crop_expenses_rd
 e_dev
 e_stdddev
$ifi %output_SCEN%==ON e_milk_contract_rd
$ifi %output_SCEN%==OFF e_milk_no_contract_rd
/
