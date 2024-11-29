clear all; close all;
addpath('DMC');
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;

% Parametry symulacji
tk=2500; Tp=10; kk=round(tk/Tp);

% DMC parametry
N=70; Nu=30; D=500; lambda=15;
Dz = 200;


punkty_rozmycia = h2pp*[0.5 0.75 1 1.25 1.5];

ys1=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(1),znajdz_F1pp(punkty_rozmycia(1)));
ys2=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(2),znajdz_F1pp(punkty_rozmycia(2)));
ys3=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(3),znajdz_F1pp(punkty_rozmycia(3)));
ys4=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(4),znajdz_F1pp(punkty_rozmycia(4)));
ys5=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(5),znajdz_F1pp(punkty_rozmycia(5)));

modele = {ys1,ys2,ys3,ys4, ys5};

yz1=odp_jedn_zakl_fun(D, Tp, 20, punkty_rozmycia(1),znajdz_F1pp(punkty_rozmycia(1)));
yz2=odp_jedn_zakl_fun(D, Tp, 20, punkty_rozmycia(2),znajdz_F1pp(punkty_rozmycia(2)));
yz3=odp_jedn_zakl_fun(D, Tp, 20, punkty_rozmycia(3),znajdz_F1pp(punkty_rozmycia(3)));
yz4=odp_jedn_zakl_fun(D, Tp, 20, punkty_rozmycia(4),znajdz_F1pp(punkty_rozmycia(4)));
yz5=odp_jedn_zakl_fun(D, Tp, 20, punkty_rozmycia(5),znajdz_F1pp(punkty_rozmycia(5)));

modele_z = {yz1,yz2,yz3,yz4, yz5};

% mi=[];
% for z=0:0.1:25
%     mi=[mi;fun_przyn_trap(z,punkty_rozmycia, 3)];
% end
% figure;
% plot(0:0.1:25, mi());

for dFD_sign=[-1, 1]
    for dFD_per=[10,50]
        kk=round(tk/Tp);
        kk=kk+1;
        % Wartość zadana
        FD_val=FDpp*(1+dFD_sign*dFD_per/100);
        h2zad = @(t) h2pp;

        % Warunki początkowe symulacji
        h_vals=[h1pp, h2pp];
        % t=0;
        du_p(1:D-1)=0;
        u_p=F1pp;
        F1in_vals(1:kk) = F1pp;
        FD_vals(1:9) = FDpp;
        FD_vals(10:kk) = FD_val;

        h_valsz=[h1pp, h2pp];
        du_pz(1:D-1)=0;
        delta_z(1:Dz)=0;
        u_pz=F1pp;
        F1in_valsz(1:kk) = F1pp;
        for k=2:kk
            % Wyznaczenie czasu dla chwili k do symulacji
            t_k=k*Tp;
            tspan_k=[t_k-Tp t_k];

            % Wyznaczenie nowej wartości sterowania regulatora DMC
            hk=h_vals(end,:);
            % du=DMC_du(hk(2),h2zad(t_k),ke,ku,du_p');
            du = z3_DMC_online_numeryczny(modele, punkty_rozmycia, D, N, Nu, lambda, h2zad(t_k), hk(2), u_p, du_p');

            % Ograniczenia wartości sygnału sterującego
            if u_p+du < 0
                du = 0-u_p;
            end

            u=u_p+du;
            F1in_vals(k)=u;
            u_p=u;

            % % Aktualizacja wektora przyrostów przeszłych
            % du_p=[du, du_p(1:end-1)];
            % Aktualizacja przeszłych przyrostów sterowania
            for n=D-1:-1:2
                du_p(n) = du_p(n-1);
            end
            du_p(1) = du;

            if k<kk
                % Rozwiąż równania ODE
                [~, hk_vals] = skok_mod_nlin(tspan_k, hk, Tp, F1in_vals, FD_vals);
                % h_vals=[h_vals;hk_vals(2:end,:)];
                h_vals=[h_vals;hk_vals(end,:)];
                % t=[t;tk(2:end,:)];
            end
        % end

        %% ddd 
        % Wyznaczenie czasu dla chwili k do symulacji
            % t_k=k*Tp;
            % tspan_k=[t_k-Tp t_k];

            for m=Dz-1:-1:2
                delta_z(m) = delta_z(m-1);
            end
            % Zmiana zakłócenia
            delta_z(1) = FD_vals(k) - FD_vals(k-1);

            % Wyznaczenie nowej wartości sterowania regulatora DMC
            hkz=h_valsz(end,:);
            % du=DMC_du(hk(2),h2zad(t_k),ke,ku,du_p');
            duz = z4_DMC_online_numeryczny_zakl(modele, modele_z, punkty_rozmycia, D, Dz, N, Nu, lambda, h2zad(t_k), hkz(2), u_pz, du_pz', delta_z');


            uz=u_pz+duz;
            F1in_valsz(k)=uz;
            u_pz=uz;

            % % Aktualizacja wektora przyrostów przeszłych
            % du_p=[du, du_p(1:end-1)];
            % Aktualizacja przeszłych przyrostów sterowania
            for n=D-1:-1:2
                du_pz(n) = du_pz(n-1);
            end
            du_pz(1) = duz;

            if k<kk
                % Rozwiąż równania ODE
                [~, hk_valsz] = skok_mod_nlin(tspan_k, hkz, Tp, F1in_valsz, FD_vals);
                % h_vals=[h_vals;hk_vals(2:end,:)];
                h_valsz=[h_valsz;hk_valsz(end,:)];
                % t=[t;tk(2:end,:)];
            end
        end

        % Wyświetlenie wyników w jednym oknie
        figure;
        k_vals=1:Tp:(kk-1)*Tp;
        % Pierwszy wykres - Sygnał wyjściowy
        subplot(2, 1, 1);
        % plot(t, h_vals(:,2));
        plot(k_vals, h_vals(:,2));
        hold on;
        plot(k_vals, h_valsz(:,2));
        plot(k_vals, h2pp * ones(1,kk-1), '--');
        if dFD_sign < 0
            legend('h2(t)  - bez pomiaru z',  'h2(t)  - z pomiarem z','h_{zad}', 'Location','best');
        else
            legend('h2(t)  - bez pomiaru z',  'h2(t)  - z pomiarem z','h_{zad}', 'Location','best');
        end
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title('Sygnał wyjściowy FDMC-SL - uwzglednienie zakłóceń');
        grid on; grid minor;

        % Drugi wykres - Sygnał sterujący
        subplot(2, 1, 2);
        hold on;
        stairs(k_vals, F1in_vals(2:251));
        stairs(k_vals, F1in_valsz(2:251));
        ylabel('Sygnał sterujący');
        yyaxis right;
        stairs(k_vals, FD_vals(2:251));
        ylabel('Sygnał zakłócający');
        if dFD_sign < 0
            legend('F1in - bez pomiaru z', 'F1in - z pomiarem z', 'Location','best');
        else
            legend('F1in - bez pomiaru z', 'F1in - z pomiarem z', 'Location','best');
        end
        xlabel('Czas (t)');
        
        title('Sygnał wejściowy FDMC-SL - uwzglednienie zakłóceń');
        grid on; grid minor;

        file_name = sprintf('wykresy/Zad4/DMC_numer_zmiana_FD_o_%+d_procent.pdf', dFD_sign * dFD_per);

        % Export wykresu do pliku .pdf
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
        % close all;
    end
end