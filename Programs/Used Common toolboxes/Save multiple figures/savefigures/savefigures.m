function savefigures(varargin)
% Saves all open figures (or those specified by input figureHandles) to specified output image type.
% Output filename is based on current axes title for each figure.
%
% syntax:
%   savefigures(figureHandles, outputDirectory)
%
%   where:
%   figureHandles (optional) - figure handle or array of figure handles to save
%                              defaults to all current figures if no argument or
%                              empty argument ([],{},etc)
%   outputDirectory (optional) - directory to place figures in
%                                defaults to uigetdir dialog (if no argument) or current
%                                directory (if argument is empty - [],'',etc)
%
%   additional input parameters are available:
%   'outputFormat' - image formats used with the print function; defaults to '-dpng'
%   'orientation' - 'Portrait' or 'Landscape'; defaults to 'Portrait'
%   'paperType' - standard page sizes; defaults to 'usletter'
%   'margin' - margin to use when saving images (units correspond to paperType); defaults to 0.5
%   'saveFigFlag' - logical flag to save .fig file in addition to printed image; defaults to false
%
%   these parameters are set by:
%   savefigures(figureHandles,outputDirectory,'parameter','value')
%

currdir = cd;

% Set default input values
defaultFigureHandles = sort(findobj('type','figure'));
if nargin < 2
    defaultOutputDirectory = uigetdir(cd,'Select Output Directory');
    if defaultOutputDirectory == 0
        return;
    end
else
    defaultOutputDirectory = currdir;
end

defaultOutputFormat = '-dpng';
expectedOutputFormats = {'-djpeg';
                         '-dpng';
                         '-dtiff';
                         '-dtiffn';
                         '-dmeta';
                         '-dbmpmono';
                         '-dbmp';
                         '-dbmp16m';
                         '-dbmp256';
                         '-dhdf';
                         '-dpbm';
                         '-dpbmraw';
                         '-dpcxmono';
                         '-dpcx24b';
                         '-dpcx256';
                         '-dpcx16';
                         '-dpgm';
                         '-dpgmraw';
                         '-dppm';
                         '-dppmraw';
                         '-dpdf';
                         '-deps';
                         '-depsc';
                         '-deps2';
                         '-depsc2';
                         '-dsvg';
                         '-dps';
                         '-dpsc';
                         '-dps2';
                         '-dpsc2'};
                
defaultOrientation = 'Portrait';
expectedOrientations = {'Portrait';
                        'Landscape'};
                    
defaultPaperType = 'usletter';
expectedPaperTypes = {'usletter';
                      'uslegal';
                      'tabloid';
                      'a0';
                      'a1';
                      'a2';
                      'a3';
                      'a4';
                      'a5';
                      'b0';
                      'b1';
                      'b2';
                      'b3';
                      'b4';
                      'b5';
                      'arch-a';
                      'arch-b';
                      'arch-c';
                      'arch-d';
                      'arch-e';
                      'a';
                      'b';
                      'c';
                      'd';
                      'e'};

defaultMargin = 0.5; % units correspond with 'paperType' setting.
defaultSaveFigFlag = 0;

p = inputParser;
addOptional(p,'figureHandles',defaultFigureHandles,@(x) isempty(x) || isa(x,'matlab.ui.Figure'));
addOptional(p,'outputDirectory',defaultOutputDirectory,@(x) isempty(x) || ischar(x));
addParameter(p,'outputFormat',defaultOutputFormat,@(x) any(validatestring(x,expectedOutputFormats)));
addParameter(p,'orientation',defaultOrientation,@(x) any(validatestring(x,expectedOrientations)));
addParameter(p,'paperType',defaultPaperType,@(x) any(validatestring(x,expectedPaperTypes)));
addParameter(p,'margin',defaultMargin,@(x) isnumeric(x) && x>=0);
addParameter(p,'saveFigFlag',defaultSaveFigFlag,@(x) islogical(x) || isequal(x,1) || isequal(x,0));
parse(p,varargin{:});
figureHandles = p.Results.figureHandles;
outputDirectory = p.Results.outputDirectory;
if isempty(figureHandles)
    figureHandles = defaultFigureHandles;
end
if isempty(figureHandles) || any(~isvalid(figureHandles))
    warning('savefigures:figureHandles','Invalid or empty figure handle(s) detected.');
    return;
end
if isempty(outputDirectory)
    outputDirectory = defaultOutputDirectory;
end
if ~logical(exist(outputDirectory,'dir'))
    warning('savefigures:outputDirectory','Specified output directory ''%s'' does not exist.',outputDirectory);
    return;
end
outputFormat = p.Results.outputFormat;
orientation = p.Results.orientation;
paperType = p.Results.paperType;
margin = p.Results.margin;
saveFigFlag = p.Results.saveFigFlag;

% Send figures to 'figures' directory... whether selected, or as a
% subdirectory of specified output directory.
dirList = regexp(outputDirectory,filesep,'split');
if ~strcmp(dirList{end},'figures')
    if ~exist([outputDirectory, filesep, 'figures'],'dir')
        mkdir(outputDirectory,'figures');
    end
    outputDirectory = [outputDirectory, filesep, 'figures'];
end

% Save the figures
cd(outputDirectory);
for ii = 1:length(figureHandles)
    figure(figureHandles(ii));
	fig_name = get(get(get(figureHandles(ii),'CurrentAxes'),'Title'),'String');
    if isempty(fig_name)
        fig_name = 'Untitled';
    end
    fig_name = regexprep(['figure' num2str(ii),'_',fig_name],'[\<\>\:\"\/\\\|\?\*\s+]','_');
    % Save figure to .fig file if 'saveFigFlag' is set.
    if saveFigFlag
        hgsave(figureHandles(ii),fig_name);
    end
    % Get current figure properties
    curr_paper = get(figureHandles(ii),'PaperType');
    curr_orientation = get(figureHandles(ii),'PaperOrientation');
    curr_pos = get(figureHandles(ii),'PaperPosition');
    % Set figure properties to specified paperType, orientation, etc
    set(figureHandles(ii),'PaperType',paperType);
    set(figureHandles(ii),'PaperOrientation',orientation);
    paperSize = get(figureHandles(ii),'PaperSize');
    set(figureHandles(ii),'PaperPosition',[margin,margin,paperSize(1)-2*margin,paperSize(2)-2*margin]);
    % Save figure to specified format.
    print(fig_name,outputFormat);
    % Return figure properties to current values
    set(figureHandles(ii),'PaperType',curr_paper);
    set(figureHandles(ii),'PaperOrientation',curr_orientation);
    set(figureHandles(ii),'PaperPosition',curr_pos);
end
cd(currdir);
    