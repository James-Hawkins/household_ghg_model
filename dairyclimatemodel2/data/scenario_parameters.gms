** Scenario or simulation specific parameters
Scalar
p_r  'rate of return used in the objective function'   /0.04/
;

Parameters
* Scenario related parameters
  p_r_loan(hh) 'Interest rate on loan'
  p_amort_period(hh) 'Amortization period for the loan (years)'



 p0_graze_dmd(hh,y)                  'Base level of grazing land (ha/hh)'
 p0_feed_crop_land(hh,y2)             'Initial amount of land dedicated to feed crops for livestock (ha/hh)'
;


*$call "gdxxrw.exe data/scenario_params.xlsx o=data/scenario_params.gdx index=index!A3"
*$GDXIN "data/scenario_params.gdx"
*$LOAD

p_amort_period(hh)=10;
p_r_loan(hh)  =0.15;



p0_feed_crop_land(hh,y2)=0.025;
p0_graze_dmd(hh,y)=4;

