function output = my_spline( premea_vout,premea_tempr,vout )


output=interp1(premea_vout,premea_tempr,vout,'spline');


end

