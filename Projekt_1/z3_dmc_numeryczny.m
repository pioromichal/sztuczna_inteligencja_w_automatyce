clear all; close all;
addpath('DMC');
addpath('funkcje_przynaleznosci');

% Punkt pracy
FDpp=14; F1pp=73; h2pp=15.6384; h1pp = 18.9225; dF1in=10;

% Parametry symulacji
tk=2500; Tp=10; kk=round(tk/Tp);

% DMC parametry
N=70; Nu=30; D=500; lambda=15;


punkty_rozmycia = h2pp*[0.5 0.75 1 1.25 1.5];

ys1=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(1),znajdz_F1pp(punkty_rozmycia(1)));
ys2=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(2),znajdz_F1pp(punkty_rozmycia(2)));
ys3=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(3),znajdz_F1pp(punkty_rozmycia(3)));
ys4=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(4),znajdz_F1pp(punkty_rozmycia(4)));
ys5=odp_jedn_fun(D, Tp, 10, punkty_rozmycia(5),znajdz_F1pp(punkty_rozmycia(5)));

modele = {ys1,ys2,ys3,ys4, ys5};

% mi=[];
% for z=0:0.1:25
%     mi=[mi;fun_przyn_trap(z,punkty_rozmycia, 3)];
% end
% figure;
% plot(0:0.1:25, mi());

for dh2zad_sign=[-1, 1]
    for dh2zad_per=[10,20,30,40,50]
        % Wartość zadana
        h2zad_val=h2pp*(1+dh2zad_sign*dh2zad_per/100);
        h2zad = @(t) h2zad_val;

        % Warunki początkowe symulacji
        h_vals=[h1pp, h2pp];
        % t=0;
        du_p(1:D-1)=0;
        u_p=F1pp;
        F1in_vals(1:kk) = F1pp;
        FD_vals(1:kk) = FDpp;
        for k=1:kk
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
                [tk, hk_vals] = skok_mod_nlin(tspan_k, hk, Tp, F1in_vals, FD_vals);
                % h_vals=[h_vals;hk_vals(2:end,:)];
                h_vals=[h_vals;hk_vals(end,:)];
                % t=[t;tk(2:end,:)];
            end
        end

        % Wyświetlenie wyników w jednym oknie
        figure;
        k_vals=0:Tp:(kk-1)*Tp;
        % Pierwszy wykres - Sygnał wyjściowy
        subplot(2, 1, 1);
        % plot(t, h_vals(:,2));
        plot(k_vals, h_vals(:,2));
        hold on;
        plot(k_vals, h2zad_val * ones(1,kk), '--');
        if dh2zad_sign < 0
            legend('h2(t)', 'h_{zad}', 'Location','northeast');
        else
            legend('h2(t)', 'h_{zad}', 'Location','southeast');
        end
        xlabel('Czas (t)');
        ylabel('Wysokość h_2');
        title('Sygnał wyjściowy FDMC-SL');
        grid on; grid minor;

        % Drugi wykres - Sygnał sterujący
        subplot(2, 1, 2);
        stairs(k_vals, F1in_vals);
        if dh2zad_sign < 0
            legend('F1in(t)', 'Location','northeast');
        else
            legend('F1in(t)', 'Location','southeast');
        end
        xlabel('Czas (t)');
        ylabel('Sygnał sterujący');
        title('Sygnał sterujący FDMC-SL');
        grid on; grid minor;

        file_name = sprintf('wykresy/Zad3/symulacja_DMC_r_zmiana_h2_zad_o_%+d_procent.pdf', dh2zad_sign * dh2zad_per);

        % Export wykresu do pliku .pdf
        exportgraphics(gcf, file_name, 'ContentType', 'vector');
        close all;
    end
end