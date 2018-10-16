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
