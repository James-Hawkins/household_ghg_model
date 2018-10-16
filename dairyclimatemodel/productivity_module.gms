$ontext
This module estimates actual productivity parameters in the recursive loop of the model
The actual availability of residues, fodders, cut and carry pasture, concentrates, and grazed pasture is specified in each month based on the outcome of the model for the given iteration
First, dry matter intake is estimated
Then, intake of nutrients are estimated and compared against potential values


$offtext


Equations
e_diet_NDF                    'Calculate NDF intake'
e_diet_N                      'Calculate N intake'
e_dry_matter_digestibility    'Calculate dry matter digestibility based on N and ADF intake'
e_feedintake                  'Calculate feed intake assuming the animal eats to potential requirement'
e_feed_available              'Specify the actual amount of feed available in each month for the cattle to consume'
e_feedbal                     'Specify that the cattle can only consume as much feed as there is available in each month'
e_actual_protein              'Calculate actual protein intake'
e_actual_energy               'Calculate actual energy intake'
;


e_diet_NDF(hh,y,m,aaact,type,inten,minten)..       v_ADF(hh,y,m,aaact,type,inten,minten)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)) =e=   100*Sum(feed,v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_ADF(feed)) ;
e_diet_N(hh,y,m,aaact,type,inten,minten)..          v_diet_N(hh,y,m,aaact,type,inten,minten)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)) =e=  100*Sum(feed,v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_crudeProtein(feed)/6.25)  ;

e_dry_matter_digestibility(hh,y,m,aaact,type,inten,minten)..            v_dmd(hh,y,m,aaact,type,inten,minten) =e= 83.58 - 0.824*v_ADF(hh,y,m,aaact,type,inten,minten) + 2.626*v_diet_N(hh,y,m,aaact,type,inten,minten) ;

e_feedintake(hh,y,m,aaact,type,inten)..          p_netEnergy_req(aaact,type,inten,'ext')*(1/0.9)   =e= Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed))*18.1*v_dmd(hh,y,m,aaact,type,inten,'ext')/100;

e_feed_available(hh,feed,m)..                           v_feed_available(hh,feed,m) =e=   200;

e_feedbal()..                                          v_feed_available(hh,feed,m)  =gt= 30*sum((aaact,type,inten,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*v_fdcons(hh,aaact,type,inten,y,m,feed));


e_actual_protein  ;

e_actual_energy    ;


* maximum potential
 $(actual energy eq (maximum))                                                    specify weight
  $(actual energy eq (maximum))                                                   specify milk


 $((actual energy gt maintenance) and (actual energy lt (maintenance + lactation)))    specify weight
 $((actual energy gt maintenance) and (actual energy lt (maintenance + lactation)))    specify milk



* weight loss
 $(actual energy lt (maintenance)) specify new weight
 $(actual energy lt (maintenance)) specify milk is zero


* death
 $(actual energy lt (cutoff)) specify new weight
 $(actual energy lt (cutoff)) specify milk is zero





loop((aaact,type,inten,minten,m),
e_diet_NDF(hh,y,m,aaact,type,inten,minten)..       v_ADF(hh,y,m,aaact,type,inten,minten)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)) =e=   100*Sum(feed,v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_ADF(feed)) ;

e_diet_N(hh,y,m,aaact,type,inten,minten)..          v_diet_N(hh,y,m,aaact,type,inten,minten)*Sum((feed),v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)) =e=  100*Sum(feed,v_fdcons(hh,aaact,type,inten,y,m,feed)*p_dryMatter(feed)*p_crudeProtein(feed)/6.25)  ;

v_dmd.fx(hh,y,m,aaact,type,inten,minten) =e= 83.58 - 0.824*v_ADF(hh,y,m,aaact,type,inten,minten) + 2.626*v_diet_N(hh,y,m,aaact,type,inten,minten) ;

v_dryMatterIntake.fx(hh,y,m,aaact,type,inten)=p_netEnergy_req(aaact,type,inten,'ext')/(18.1*v_dmd(hh,y,m,aaact,type,inten,'ext')/100);

e_feedons(hh,feed,y,m)..                            v_feedons(hh,feed,y,m) =e= 30*sum((aaact,type,inten,minten),v_aactLev(hh,aaact,type,inten,minten,y,m)*v_fdcons(hh,aaact,type,inten,y,m,feed));

e_feedbal(hh,ration,y,m).. v_feedbalance(hh,ration,y,m-1)*(p_transferrate)$(ord (m) gt 1) + v_feedbalance(hh,ration,y-1,'m12')*(p_transferrate)$((ord (y) gt 1) and (ord(m) eq 1)) + p_s(hh,ration)$((ord(m) eq 1) and (ord(y) eq 1)) + Sum(residues_ration(residues,ration),v_residuesfeedm(hh,residues,y,m))*1000 + Sum((fodder_feed(fodder,ration)),v_prdCrop(hh,y,fodder,m)*1000) + v_feedbuy(hh,ration,y,m) - v_feedons(hh,ration,y,m) =e=  v_feedbalance(hh,ration,y,m);

** now calculate actual productivity

if ((energy intake eq (maintenance + lactation)),then


if else((energy intake gt maintenance)) and (energy intake lt (maintenance + lactation)),  then

if else ((energy intake lt maintenance) and (energy intake gt death_value)), then

else dead






);
