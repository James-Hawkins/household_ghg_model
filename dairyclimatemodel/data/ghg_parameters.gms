** -- Greenhouse gas estimation parameters

Parameters
*data load in
MCF
B0
EF_3
EF_4
EF_5
FRAC_leach
FRAC_vol
soil_N2O_off_farm
soil_N2O
C_storage_land
CO2_Fossil_Fuel
allocation_factor

*parameters as they appear in the model code
** manure related parameters
p_MCF(breed)                        'Methane conversion factor'
p_B0                                'Methane producing capacity'
p_EF_3                              'Emission factor for manure nitrous oxide (fraction)'
p_EF_4                              'Emission factor for indirect manure nitrous oxide (volatilization) (fraction)'
p_EF_5                              'Emission factor for indirect manure nitrous oxide (leaching) (fraction)'
p_FRAC_leach                        'Fraction of manure N that is leached (fraction)'
p_FRAC_vol                          'Fraction of manure N that is volatilized (fraction)'


* soil N2O related parameters
p_nitrous_oxide_offfarm(feed)       'Nitrous oxide emissions from feeds purchased off farm (kg N2O/ha/year)'
p_nitrous_oxide(c)                  'Nitrous oxide emissions from cropland and grassland on farm (kg N2O/ha/yr)'
p_alloc_factor(non_fodder)          'Allocation factor for non fodder crops'

*energy related CO2 emissions
p_fossil_fuel_emissions(feed_off_farm) 'Embodied emissions from feed production (kg CO2eq/Mg feed)'

* LUC related parameters
p_land_C                            'Mean carbon storage content of land (Mg C/ha)'
;


$call "gdxxrw.exe data/ghg_params.xlsx o=data/ghg_params.gdx index=index!A3"
$GDXIN "data/ghg_params.gdx"
$LOAD MCF
$LOAD B0
$LOAD EF_3
$LOAD EF_4
$LOAD EF_5
$LOAD FRAC_leach
$LOAD FRAC_vol
$LOAD C_storage_land
$LOAD CO2_Fossil_Fuel
$LOAD allocation_factor
$LOAD soil_N2O_off_farm
$LOAD soil_N2O
$GDXIN


p_MCF('local')=MCF('local');
p_MCF('improved') = MCF('improved') ;
p_B0 = B0;
p_EF_3=EF_3;
p_EF_4=EF_4;
p_EF_5=EF_5;
p_FRAC_leach =FRAC_leach;
p_FRAC_vol=FRAC_vol;
p_land_C=C_storage_land ;
p_fossil_fuel_emissions(feed_off_farm)=CO2_Fossil_Fuel(feed_off_farm);
p_alloc_factor(non_fodder)=allocation_factor(non_fodder);
p_nitrous_oxide_offfarm(feed_off_farm)=soil_N2O_off_farm(feed_off_farm);
p_nitrous_oxide(c)=soil_N2O(c);

