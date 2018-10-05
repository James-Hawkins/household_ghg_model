Sets

*-- household sets
hh households          /hh2/

* -- household members
hhold_member /total,over_65,under_15,adult/

*-- time sets
m twelve months                                  /m01*m12/
year years                                       /1*20,y01*y12/
y(year) years in model horizon                   /y01/
y2(year) years in current run or recursive steps /1/

laterm(m) /m02*m12/
firsty(y2) /1/
firstm(m)  /m01/
*lasty(y2)  /2/
lastm(m)   /m12/

*scenarios
scen 'Model scenarios' /Base/
*, Scen1, Scen2, Scen3, Scen4/

good /food, nonfood/

*- nutrients for human consumption
nut /kcal/

*-- types of animals
type             /dairy/

* animal products
outputs /meat,milk/

*-- intensity sets
inten intensity level for feeding  /ext,med,int/
*ext,med,int/
minten level for maintenance       /ext/


*- nutrient sets
anut /netenergy,grossenergy,crudeprotein,metabolisableprotein,drymatter,digestibility,N,ADF,NDF/

*-- animal activity related sets
breed /local,improved/


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
cow(aaact)             /adultf_loc,adultf_imp/
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
notadultf(aaact)       /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc,youngf_imp,youngm_imp,weanerf_imp,weanerm_imp,reprod_loc,reprod_imp/
notadult_loc(aaact)    /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc/
notadult_imp(aaact)    /youngf_imp,youngm_imp,weanerf_imp,weanerm_imp/
local(aaact)           /youngf_loc,youngm_loc,weanerf_loc,weanerm_loc,adultf_loc,reprod_loc/
improved(aaact)        /youngf_imp,youngm_imp,weanerf_imp,weanerm_imp,adultf_imp,reprod_imp/


*-- crop and grazing related sets
c         /beans,maize,sorghum,millet,groundnut,cowpea,banana,napier,pasture/
food(c)   /beans,maize,sorghum,millet,groundnut,cowpea/
fodder(c) /napier,pasture/
silage(c) /maize/
cash(c)   /banana/
non_fodder(c) /beans,maize,sorghum,millet,groundnut,cowpea,banana/
crop_not_pasture(c) /beans,maize,sorghum,millet,groundnut,cowpea,banana,napier/


*feed sets
feed       'feed sources'          /maize_residue,cpea_residue,grnut_residue,bean_residue,sorgh_residue,millet_residue,banana_residue,maize_silage,sunflower_seed_cake,cotton_seed_cake,maize_bran,grass,grass_hay,napier/
feed_off_farm(feed)                /sunflower_seed_cake,cotton_seed_cake,maize_bran/
feed_on_farm(feed)                 /maize_residue,cpea_residue,grnut_residue,bean_residue,sorgh_residue,millet_residue,grass,grass_hay,napier,maize_silage/
residues(feed)                     /maize_residue,bean_residue,grnut_residue,sorgh_residue,cpea_residue,millet_residue,banana_residue/
grazed(feed)                       /grass/
ration(feed)                       /maize_residue,bean_residue,cpea_residue,grnut_residue,sorgh_residue,millet_residue,maize_silage,grass_hay,napier,sunflower_seed_cake,cotton_seed_cake,maize_bran/
feed_on_farm_non_fodder(feed)      /maize_residue,cpea_residue,grnut_residue,bean_residue,sorgh_residue,millet_residue,banana_residue/

**-- Mappings
crop_silage(c,feed)      /maize.maize_silage/
crop_residue(c,residues) /maize.maize_residue,beans.bean_residue,groundnut.grnut_residue,sorghum.sorgh_residue,millet.millet_residue/
fodder_feed(fodder,feed) /napier.napier,pasture.grass_hay/
feedbuy_ration(ration,feed_off_farm) /sunflower_seed_cake.sunflower_seed_cake,cotton_seed_cake.cotton_seed_cake,maize_bran.maize_bran/
residues_ration(residues,ration) /maize_residue.maize_residue,bean_residue.bean_residue,millet_residue.millet_residue,grnut_residue.grnut_residue,sorgh_residue.sorgh_residue,cpea_residue.cpea_residue/
breed_aaact(breed,aaact) /local.youngf_loc,local.youngm_loc,local.weanerf_loc,local.weanerm_loc,local.adultf_loc,local.reprod_loc, improved.youngf_imp,improved.youngm_imp,improved.weanerf_imp,improved.weanerm_imp,improved.adultf_imp,improved.reprod_imp/
residues_non_fodder(residues,non_fodder) /bean_residue.beans,maize_residue.maize,sorgh_residue.sorghum,millet_residue.millet,grnut_residue.groundnut,cpea_residue.cowpea,banana_residue.banana/
;

alias(good,good2)

