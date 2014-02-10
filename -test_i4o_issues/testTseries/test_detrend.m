absTol = eps()^(2/3);

x = tseries(qq(1,1):qq(3,2),sin(1:10)) ;

observ = double(detrend(x)) ;
expect = [ ...
    0
    0.221770008206370
   -0.392463844370859
   -1.136442781550070
   -1.184620994716695
   -0.351168652063897
    0.739177011042403
    1.225492225135581
    0.802196029942541
    0 ...
    ] ;
myassert(observ, expect, absTol) ;
