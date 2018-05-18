function stocks = hist_stock_data(S, E, varargin)
% HIST_STOCK_DATA     Obtain historical stock data

%S=start date (numerical matlab value) of stock data
%E=end date (numerical matlab value) of stock data
%varargin= 1 x n cell-array with yahoo stock symbols (e.g. DAI.DE for
%Daimler listed on XETRA)
%As a result, you get a structure array with infos, prices, volumes of all
%stock symbols provided

% Created by Julian Hess
% January 05, 2014

if day(S)<10
    S_tag=strcat('0',num2str(day(S)));
else
    S_tag=num2str(day(S));
end
if day(E)<10
    E_tag=strcat('0',num2str(day(E)));
else
    E_tag=num2str(day(E));
end
if month(S)<10
    S_mon=strcat('0',num2str(month(S)));
else
    S_mon=num2str(month(S));
end
if month(E)<10
    E_mon=strcat('0',num2str(month(E)));
else
    E_mon=num2str(month(E));
end

S_long=strcat(S_tag,S_mon,num2str(year(S)));
E_long=strcat(E_tag,E_mon,num2str(year(E)));
varargin=varargin{1,1};
start_date=S_long;
end_date=E_long;


stocks = struct([]);        % initialize data structure

% split up beginning date into day, month, and year.  The month is
% subracted is subtracted by 1 since that is the format that Yahoo! uses
bd = start_date(1:2);       % beginning day
bm = sprintf('%02d',str2double(start_date(3:4))-1); % beginning month
by = start_date(5:8);       % beginning year

% split up ending date into day, month, and year.  The month is subracted
% by 1 since that is the format that Yahoo! uses
ed = end_date(1:2);         % ending day
em = sprintf('%02d',str2double(end_date(3:4))-1);   % ending month
ey = end_date(5:8);         % ending year

% determine if user specified frequency
temp = find(strcmp(varargin,'frequency') == 1); % search for frequency
if isempty(temp)                            % if not given
    freq = 'd';                             % default is daily
else                                        % if user supplies frequency
    freq = varargin{temp+1};                % assign to user input
    varargin(temp:temp+1) = [];             % remove from varargin
end
clear temp

% Determine if user supplied ticker symbols or a text file
if isempty(strfind(varargin{1},'.txt'))     % If individual tickers
    tickers = varargin;                     % obtain ticker symbols
else                                        % If text file supplied
    tickers = textread(varargin{1},'%s');   % obtain ticker symbols
end

h = waitbar(0);           % create waitbar
set(h,'Name','Please Wait for Data from yahoo...');
idx = 1;                                    % idx for current stock data

% cycle through each ticker symbol and retrieve historical data
for i = 1:length(tickers)
    
    % update waitbar to display current ticker
    waitbar((i-1)/length(tickers),h,sprintf('%s %s %s%0.2f%s', ...
        'Retrieving stock data for',tickers{i},'(',(i-1)*100/length(tickers),'%)'))
        
    % download historical data using the Yahoo! Finance website
    [temp, status] = urlread(strcat('http://ichart.finance.yahoo.com/table.csv?s='...
        ,tickers{i},'&a=',bm,'&b=',bd,'&c=',by,'&d=',em,'&e=',ed,'&f=',...
        ey,'&g=',freq,'&ignore=.csv'));
    
    if status
        % organize data by using the comma delimiter
        [date, op, high, low, cl, volume, adj_close] = ...
            strread(temp(43:end),'%s%s%s%s%s%s%s','delimiter',',');

        stocks(idx).Ticker = tickers{i};        % obtain ticker symbol
        stocks(idx).Date = datenum(date);        % save date data
        stocks(idx).Open = str2double(op);      % save opening price data
        stocks(idx).High = str2double(high);    % save high price data
        stocks(idx).Low = str2double(low);      % save low price data
        stocks(idx).Close = str2double(cl);     % save closing price data
        stocks(idx).Volume = str2double(volume);      % save volume data
        stocks(idx).AdjClose = str2double(adj_close); % save adjustied close data
        
        
    else
        stocks(idx).Ticker = tickers{i};        % obtain ticker symbol
        stocks(idx).Date = nan;        % save date data
        stocks(idx).Open = nan;      % save opening price data
        stocks(idx).High = nan;    % save high price data
        stocks(idx).Low = nan;      % save low price data
        stocks(idx).Close = nan;     % save closing price data
        stocks(idx).Volume = nan;      % save volume data
        stocks(idx).AdjClose = nan; % save adjustied close data  
    end
    idx = idx + 1;                          % increment stock index
    
    % clear variables made in for loop for next iteration
    clear date op high low cl volume adj_close temp status
    
    % update waitbar
    waitbar(i/length(tickers),h)
end
close(h)    % close waitbar