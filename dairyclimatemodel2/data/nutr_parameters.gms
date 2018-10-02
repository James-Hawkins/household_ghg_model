
**------------------------ Nutrition and cattle diet related parameters

Parameters
energyrequirements
proteinrequirements
energy_gain
p_NE_gain(hh,aaact,type,inten,minten,y,m)  'Daily requirement of net energy for gain (MJ/hd/d)'
p_Energy_req(aaact,type,inten,minten)  'energy requirement  (MJ/head/day)'
p_Protein_req(aaact,type,inten,minten)  'protein requirement (kg/head/day)'

;


$call "gdxxrw.exe data/nutrient_requirements.xlsx o=data/nutrient_requirements.gdx index=index!A3"
$GDXIN "data/nutrient_requirements.gdx"
$LOAD energyrequirements
$LOAD proteinrequirements
$LOAD energy_gain
$GDXIN

p_Energy_req(aaact,'dairy',inten,minten)=energyrequirements('hh1',aaact,'dairy',inten,minten,'energyrequirement');
p_Protein_req(aaact,'dairy',inten,minten)=proteinrequirements('hh1',aaact,'dairy',inten,minten,'proteinrequirement');


* this line converts metabolisable energy requirements for gain to net energy required for gain. this procedure needs to be updated
p_NE_gain(hh,aaact,type,inten,minten,y,m)=1.5*energy_gain(hh,aaact,type,inten,minten,'energyrequirement');
