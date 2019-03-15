function [x,y,z,combos] = Bifurcation(sig,rho,beta,endTime,Ntrials)

    numPoints = 50;

    %% Set up trials
    % Conditions to be used
    switch numel(sig)
        case 1
            sigmaCon = sig;
        case 2 
            sigmaCon = linspace(sig(1),sig(end),Ntrials);
        otherwise
            sigmaCon = sig;
    end

    switch numel(sig)
        case 1
            rhoCon = rho;
        case 2 
            rhoCon = linspace(rho(1),rho(end),Ntrials);
        otherwise
            rhoCon = rho;
    end

    switch numel(sig)
        case 1
            betaCon = beta;
        case 2 
            betaCon = linspace(beta(1),beta(end),Ntrials);
        otherwise
            betaCon = beta;
    end

    % Set all possible comonations
    sets = {sigmaCon,rhoCon,betaCon};
    [s,r,b] = ndgrid(sets{:});
    combos = [s(:),r(:),b(:)];

    %% Integrate out to steady state starting a small pertibation
    % Only will look at the positive conditions
    X = cell(1,size(combos,1));
    for m = 1:size(combos,1)
        %% Steady State Condition
        sig = combos(m,1);
        rho = combos(m,2);
        bet = combos(m,3);
        zs = rho - 1;
        ys = beta*(rho-1);
        xs = ys;
        [~,X{m}] = ode15s(@(t,x)Lorenz(t,x,rho,sig,bet),[0 endTime],[zs+eps,ys(1)+eps,xs+eps]);
    end
    x = cell(1,size(combos,1));
    y = x;
    z = x;
    for m = 1:size(combos,1)
        x{m} = X{m}(:,1);
        y{m} = X{m}(:,2);
        z{m} = X{m}(:,3);
    end
    %% Plot the figures
    % Note: This is only for the Rho Condition
    % Rho and x
    figure
    hold on
    for m = 1:size(combos,1)
        if size(x{m},1) < numPoints
            plot(combos(m,2)*ones(size(x{m},1)),x{m}(:,1),...
                'LineStyle','none','Marker','.','Color','blue');
        else
            plot(combos(m,2)*ones(numPoints,1),x{m}((end-numPoints+1):end,1),...
                'LineStyle','none','Marker','.','Color','blue');
        end
    end
    hold off
    xlabel('Rho Value')
    ylabel('x')
    title('Bifurcation of x with respact to Rho')
    
    % Rho and y
    figure
    hold on
    for m = 1:size(combos,1)
        if size(x{m},1) < numPoints
            plot(combos(m,2)*ones(size(y{m},1)),y{m}(:,1),...
                'LineStyle','none','Marker','.','Color','blue');
        else
            plot(combos(m,2)*ones(numPoints,1),y{m}((end-numPoints+1):end,1),...
                'LineStyle','none','Marker','.','Color','blue');
        end
    end
    hold off
    xlabel('Rho Value')
    ylabel('y')
    title('Bifurcation of y with respact to Rho')
    
    % Rho and z
   figure
    hold on
    for m = 1:size(combos,1)
        if size(x{m},1) < numPoints
            plot(combos(m,2)*ones(size(z{m},1)),z{m}(:,1),...
                'LineStyle','none','Marker','.','Color','blue');
        else
            plot(combos(m,2)*ones(numPoints,1),z{m}((end-numPoints+1):end,1),...
                'LineStyle','none','Marker','.','Color','blue');
        end
    end
    hold off
    xlabel('Rho Value')
    ylabel('z')
    title('Bifurcation of z with respact to Rho')
    
    
end

function dF = Lorenz(~,x,rho,sigma,beta)
    z = x(3);
    y = x(2);
    x = x(1);
    
    dx = sigma*(y-x);
    dy = x*(rho-z)-y;
    dz = x*y-beta*z;
    
    dF = [
        dx
        dy
        dz
        ];
end