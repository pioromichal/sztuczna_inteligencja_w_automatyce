function du=DMC_du(y,yzad,ke,ku,du_p)
e=yzad-y;
du = ke*e - ku*du_p;
end