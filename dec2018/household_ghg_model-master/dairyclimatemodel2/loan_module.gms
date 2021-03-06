$ontext
This module includes all the equations relating to the loan. The equations in this model are only included if credit is turned on in 'gen_baseline.gms'

$offtext

Variables
v_loan(hh)                  'Value of loan taken out by household (TSh/hh)'
v_loan_principle(hh,y)      'Remaining principle on loan in a given year (TSh)'
v_loan_installment(hh,y)    'Installment paid towards loan principle in a given year (TSh)'
v_credit_interest(hh,y,m)   'Interest paid on loan in a given month (TSh/month)'
;




Parameters
p_r_loan(hh)                  'Interest rate on loan (as a fraction)'
p_loan_installment(hh)        'Loan installment in current year (TSh)'
p_loan_principle(hh,year)     'Loan principle in a given year (TSh)'
p_loan_value(hh)              'Initial loan value (TSh)'
p_credit_interest(hh)         'Credit interest (TSh)'
;

p_loan_principle(hh,y)=0;
p_loan_value(hh)=0    ;
p_loan_installment(hh)=0 ;
p_credit_interest(hh) =0;
*p_r_loan(hh)  =0.15;


* Specify maximum loan amount of 10,000 lc
v_loan.up(hh)=0;
v_loan.lo(hh)=0   ;


Equations
loan_installment    'Annual payment on loan (10% of principle is paid back per year) (lc/yr)'
loan_principle      'Amortization schedule for loan'
loan_payments       'Annual payment on loan interest (lc/yr)'

;

loan_installment(hh,y)..                   v_loan_installment(hh,y) =e=   v_loan(hh)*(0.1)  ;

loan_principle(hh,y)..                     v_loan_principle(hh,y) =e=  v_loan(hh) - (ord(y)*v_loan_installment(hh,y))   ;

loan_payments(hh,y,m)..                      v_credit_interest(hh,y,m) =e=   p_r_loan(hh)*v_loan_principle(hh,y)/12     ;



model loanmod
/
loan_payments
loan_principle
loan_installment
/
