function [c, ceq] = ograniczenia_NO(du, u, umin, umax, k)
    % Inicjalizacja ograniczeń nierównościowych
    c = [];
    
    % Ograniczenia na wartości sterowania (u w zakresie [umin, umax])
    for p = 1:length(du)
        % Przewidywana wartość sterowania u(k)
        up = u(k-1) + sum(du(1:p)); % u(k) = u(end) + suma(du)

        % Dodaj ograniczenia nierównościowe na u(k)
        c = [c; up - umax]; % u(k) <= umax -> uk - umax <= 0
        c = [c; umin - up]; % u(k) >= umin -> umin - uk <= 0
    end

    % Brak ograniczeń równościowych
    ceq = [];
end
