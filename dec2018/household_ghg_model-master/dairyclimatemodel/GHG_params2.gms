*v_aactLev.l(hh,aaact,type,inten,minten,y,m)=0 ;
*v_grossEnergy.l(hh,aaact,type,inten,minten,y,m)=0;
*v_digestibleEnergy.l(hh,aaact,type,inten,minten,y,m)=0;
*v_fdcons.l(hh,aaact,type,inten,y,m,feed)=0;
*v_graze_dmd.l(hh,y,m)=0;
*v_dryMatterIntake.l(hh,y,m,aaact,type,inten)=0;
*v_areaCrop.l(hh,y,c)=0;

v_aactLev.lo(hh,aaact,type,inten,minten,y,m)=0 ;
v_aactLev.up(hh,aaact,type,inten,minten,y,m)=+inf ;

v_grossEnergy.lo(hh,aaact,type,inten,minten,y,m)=0;
v_grossEnergy.up(hh,aaact,type,inten,minten,y,m)=+inf;

v_digestibleEnergy.lo(hh,aaact,type,inten,minten,y,m)=0;
v_digestibleEnergy.up(hh,aaact,type,inten,minten,y,m)=+inf;

v_fdcons.lo(hh,aaact,type,inten,y,m,feed)=0;
v_fdcons.up(hh,aaact,type,inten,y,m,feed)=+inf;

v_graze_dmd.lo(hh,y)=0;
v_graze_dmd.up(hh,y)=+inf;

v_dryMatterIntake.lo(hh,y,m,aaact,type,inten)=0;
v_dryMatterIntake.up(hh,y,m,aaact,type,inten)=+inf;

v_areaCrop.lo(hh,y,c)=0;
v_areaCrop.up(hh,y,c)=+inf;

