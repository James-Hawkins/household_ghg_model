
$onglobal
$ontext
This module includes all the livestock related equations, including milk and meat production based on the quantity of adult females and animals being culled, feed intake,
feed balance equations, specification of minimum energy and protein requirements, livestock labour, livestock nutrient and dry matter intake, and livestock related land use
(e.g. rangeland requirements). Different levels of livestock productivity in this module are handled using the 'intensity' index. A given animal can be classifed as intensive,
medium, or extensive, each one with corresponding values for milk yield (in the case of an adult female), and daily live weight gain (in the case of a growing animal).
Depending on what intensity level an animal is categorized as, the daily requirement for energy and protein is specifed in accordance with this animal's required nutrient intake.


$offtext



Variables
  v_dmd(hh,y,m,aaact,type,inten,minten)                     'Monthly mean dry matter digestibility (g/100 g DM)'
  v_ADF(hh,y,m,aaact,type,inten,minten)                     'Acid detergent fibre intake (g/100g DM)'
  v_NDF(hh,y,m,aaact,type,inten,minten)                     'Neutral detergent fibre intake (g/100g DM)'
  v_diet_N(hh,y,m,aaact,type,inten,minten)                  'Dietary N intake (g/100g DM)'
  v_prodQmilk(hh,aaact,type,inten,year,m)                   'Milk produced (kg/month/animal)'
  v_prodQmeat(hh,aaact,type,inten,year,m)                   'Meat produced (kg/month/animal)'
  v_milkprod(hh,cow,type,inten,year)                        'Milk production per cow per day during lactation (kg/head/day)'
;


Nonnegative variables
  v_totallabourdemlive(hh,year,m)                           'Person-days of labour/month/herd'
  v_grossEnergy(hh,aaact,type,inten,minten,year,m)          'Gross energy intake per animal per day (MJ/hd/d)'
  v_netEnergy(hh,aaact,type,inten,minten,year,m)            'Net energy requirement (MJ/hd/d)'
  v_digestibleEnergy(hh,aaact,type,inten,minten,y,m)        'Digestible energy intake per animal per day (MJ/hd/d)'
  v_cp_intake(hh,year,m,aaact,type,inten,minten)
  v_dryMatterIntake(hh,y,m,aaact,type,inten)           'Dry matter intake (kg/hd/d)'
  v_graze_dmd(hh,y)                                    'Estimated demand for grazing land (ha/hh/yr)'
  v_pasture_land(hh,y)                                 'Amount of land dedicated to pasture production (ha/hh/yr)'
  v_feedbalance(hh,feed,year,m)                        'kg feed carried over to next month'
  v_feedbuy(hh,feed_off_farm,y,m)                      'kg of a feed purchased in a given month (kg/hh/month)'
  v_fdcons(hh,aaact,type,inten,y,m,feed)               'Amount of a specific feed consumed per animal per day (kg as fed)'
  v_feedons(hh,feed,year,m)                            'Total kg of a feed consumed per month (for all cattle) (as fed) (kg/hh/month)'

  v_aactLev(hh,aaact,type,inten,minten,year,m)          'Livestock activity level (head)'
  v_aactLevsell(hh,aaact,type,inten,minten,year,m)      'Sell livestock (head)'
  v_aactLevbuy(hh,aaact,type,inten,minten,year,m)       'Buy livestock (head)'
;

*fix starting values for livestock numbers in first month and first year
v_aactLev.fx(hh,aaact,type,inten,minten,'y01','m01')=v0_aactLev(hh,aaact,type,inten,minten);

v_aactLev.fx(hh,aaact,type,'int',minten,y,m)=0;
v_aactLev.fx(hh,aaact,type,'med',minten,y,m)=0;


v_aactLevbuy.fx(hh,young,type,inten,minten,y,lastm)=0    ;
v_aactLevsell.fx(hh,young,type,inten,minten,y,lastm)=0  ;
v_aactLevbuy.fx(hh,weaner,type,inten,minten,y,lastm)=0    ;
v_aactLevsell.fx(hh,weaner,type,inten,minten,y,lastm)=0  ;
v_aactLevbuy.fx(hh,reprod,type,inten,minten,y,lastm)=0    ;
v_aactLevsell.fx(hh,reprod,type,inten,minten,y,lastm)=0  ;

*v_aactLevbuy.lo(hh,weaner,type,inten,minten,y,m)=    ;
*v_aactLevsell.lo(hh,weaner,type,inten,minten,y,m)=0  ;


*v_aactLevbuy.fx(hh,aaact,type,inten,minten,y,lastm)=0;
*v_aactLevsell.fx(hh,aaact,type,inten,minten,y,lastm)=0;



*v_fdcons.fx(hh,aaact_imp,type,inten,y,m,grazed)=0;





*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
* #3 Equations  (all variables are declared in terms of sets specifically defined to this model scenario)
*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*
Equations
*-- production equations
   e_milkproduction   'milk produced from all animals in a given month (kg/hh/month)'
   e_meatproduction   'meat produced from slaughtered animals in a given month (kg/hh/month)'

*-- Feed balance equations
   e_feedbal           'livestock feed balance accounting equation (kg per month)'
   e_feedons           'total amount of a feed consumed per month (from all animals)'
   e_feed_purchased    'total amount of feeds purchased per month (kg/month/hhold)'

*-- Labor equation
   e_laborAA           'labor use for livestock activities (person-days/hh/month)'

*-- Rangeland requirement and availability
   e_grazing_demand             'Demand for grazing land by cattle (ha/hh/year)'
   e_rangeland                  'Availability of rangeland for grazing (ha/hh/year)'
   e_pasture                    'Land dedicated to pasture production (ha/hh/year)'


*-- Feed and nutrition equations
   e_feed_intake                 'Feed intake equation (as fed)'
   e_mlk_prod
   e_protein_intake
   e_dryMatterIntake             'Dry matter intake equation (from Goopy et al. 2018)'
   e_dry_matter_digestibility    'Dry matter digestibility (from Oddy et al. 1983)'
   e_energySource                'Specify required energy intake'
   e_grossEnergy                 'Calculate gross energy intake'
   e_netenergy                   'Calculate net energy'
   e_digestibleEnergy            'Calculate digestible energy'
   e_diet_N                      'Calculate diet N intake'
   e_diet_ADF                    'Calculate diet ADF intake'
   e_diet_NDF                    'Calculate diet NDF intake'
   e_min_protein                 'Minimum protein intake'
;


e_milkproduction(hh,cow,type,inten,y,m)..   v_prodQmilk(hh,cow,type,inten,y,m) =e= 0.6*v_milkprod(hh,cow,type,inten,y)*30*Sum(minten,v_aactLev(hh,cow,type,inten,minten,y,m));
* p_milkprod(aaact,type,inten)

e_meatproduction(hh,aaact,type,inten,y,m)..    v_prodQmeat(hh,aaact,type,inten,y,m)  =e= 0.6*p_salesw(aaact,type,inten)*Sum(minten,v_aactLevsell(hh,aaact,type,inten,minten,y,m));
*p_dress_pct(aaact,type,inten)*
e_laborAA(hh,y,m)..            sum((aaact,inten,type,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*p_labour_lives(m,inten,aaact,type))   =e= v_totallabourdemlive(hh,y,m);

e_feedons(hh,feed,y,m)..                            v_feedons(hh,feed,y,m) =e= 30*sum((aaact,type,inten,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*v_fdcons(hh,aaact,type,inten,y,m,feed));

e_feed_purchased(hh,feed_off_farm,y,m)..            v_feedbuy(hh,feed_off_farm,y,m) =e= v_feedons(hh,feed_off_farm,y,m);

e_feedbal(hh,ration,y,m).. v_feedbalance(hh,ration,y,m-1)*(p_transferrate)$(ord (m) gt 1) + v_feedbalance(hh,ration,y-1,'m12')*(p_transferrate)$((ord (y) gt 1) and (ord(m) eq 1)) + p_s(hh,ration)$((ord(m) eq 1) and (ord(y) eq 1)) + Sum(residues_ration(residues,ration),v_residuesfeedm(hh,residues,y,m))*1000 + v_crp_feed(hh,y,'maize_silage',m)*1000 +  Sum((fodder_feed(fodder,ration)),v_prdCrop(hh,y,fodder,m))*1000 + Sum((feedbuy_ration(ration,feed_off_farm)),v_feedbuy(hh,feed_off_farm,y,m))
- v_feedons(hh,ration,y,m) =e=  v_feedbalance(hh,ration,y,m);

e_grazing_demand(hh,y)..                           v_graze_dmd(hh,y) =e= (1/1000)*Sum((aaact,type,inten,minten,m),30*(v_aactLev(hh,aaact,type,inten,minten,y,m)*p_dryMatter('grass')*v_fdcons(hh,aaact,type,inten,y,m,'grass')))/sum(m,p_forage_yield(m)) ;

e_rangeland(hh,y)..                                v_graze_dmd(hh,y) =l= p_rangeland(hh,y);

e_pasture(hh,y)..                                 v_pasture_land(hh,y) =e= (1/1000)*Sum((aaact,type,inten,minten,m),30*(v_aactLev(hh,aaact,type,inten,minten,y,m)*p_dryMatter('grass_hay')*v_fdcons(hh,aaact,type,inten,y,m,'grass_hay')))/(12*p_forage_yield('m01')) ;

e_dryMatterIntake(hh,y,m,aaact,type,inten)..      v_dryMatterIntake(hh,y,m,aaact,type,inten)   =e=  Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed));





e_mlk_prod(hh,y,cow,type,inten)..  v_milkprod(hh,cow,type,inten,y)  =e=              min((1/12)*Sum(m,(v_cp_intake(hh,y,m,cow,'dairy',inten,'ext')-0.05)/.06785 )  ,365*p_corrfc_en(cow)*(p_Energy_req(cow,type,inten,'ext')-35)/(0.8*(0.0406*.02+1.509)));

*(1/12)*Sum(m, min((v_cp_intake(hh,y,m,cow,'dairy',inten,'ext')-0.1)/.06785   ,365*p_corrfc_en(cow)*(p_Energy_req(cow,type,inten,'ext')-35)/(0.8*(0.0406*.02+1.509))));


e_energySource(hh,y,m,aaact,type,inten)$(ord(m) gt 1)..          p_Energy_req(aaact,type,inten,'ext')   =e= Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed))*18.1*v_dmd(hh,y,m,aaact,type,inten,'ext')*0.81/100;

e_dry_matter_digestibility(hh,y,m,aaact,type,inten,minten)..            v_dmd(hh,y,m,aaact,type,inten,minten) =e= 83.58 - 0.824*v_ADF(hh,y,m,aaact,type,inten,minten) + 2.626*v_diet_N(hh,y,m,aaact,type,inten,minten) ;

e_min_protein(hh,y,m,aaact,'dairy',inten,minten)$(ord(m) gt 1)..            v_cp_intake(hh,y,m,aaact,'dairy',inten,minten)  =g= .75* p_Protein_req(aaact,'dairy',inten,minten);  !! protein requirments need to be updated

e_protein_intake(hh,y,m,aaact,'dairy',inten,minten)..                            v_cp_intake(hh,y,m,aaact,'dairy',inten,minten) =e=  Sum((feed),v_fdcons(hh,aaact,'dairy',inten,y,m,feed)*p_dryMatter(feed)*p_crudeProtein(feed))*0.9 ;

e_grossEnergy(hh,y,m,aaact,type,minten,inten)..            v_grossEnergy(hh,aaact,type,inten,minten,y,m)   =e= Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_grossEnergy(feed));

e_digestibleEnergy(hh,y,m,aaact,type,minten,inten)..       v_digestibleEnergy(hh,aaact,type,inten,minten,y,m) =e=  (1/100)*v_dmd(hh,y,m,aaact,type,inten,minten)*v_grossEnergy(hh,aaact,type,inten,minten,y,m);

e_diet_ADF(hh,y,m,aaact,type,inten,minten)..       v_ADF(hh,y,m,aaact,type,inten,minten)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)) =e=   100*Sum(feed,v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_ADF(feed)) ;

e_diet_NDF(hh,y,m,aaact,type,inten,minten)..       v_NDF(hh,y,m,aaact,type,inten,minten)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)) =e=   100*Sum(feed,v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_NDF(feed)) ;

e_diet_N(hh,y,m,aaact,type,inten,minten)..          v_diet_N(hh,y,m,aaact,type,inten,minten)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)) =e=  100*Sum(feed,v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_crudeProtein(feed)/6.25)  ;


option limrow=0; option limcol=0;



Model livesmod

/
   e_milkproduction
   e_meatproduction
   e_feedbal
   e_feedons
   e_feed_purchased
   e_laborAA
   e_pasture
   e_mlk_prod
$ifi %rangeland_constraint%==ON    e_rangeland
   e_dry_matter_digestibility
   e_protein_intake
   e_grossEnergy
   e_digestibleEnergy
   e_diet_N
   e_diet_ADF
   e_diet_NDF
   e_dryMatterIntake
   e_grazing_demand
   e_energySource
   e_min_protein
/


