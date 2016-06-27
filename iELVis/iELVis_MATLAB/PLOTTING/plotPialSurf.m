% plotPialSurf() - Function for plotting Freesurfer surfaces
%                  with or without colored overlays or electrodes.
%
% Usage:
%  >> cfgOut=plotPialSurf(fsSub,cfg);
%
% Required Input:
%   fsSub - Name of the subject's freesurfer directory (full path not
%          needed)
%
% Optional Inputs:
%   cfg variable with the following possible fields:
%
%    Electrode Options:
%     elecCoord            -If 'n', no electrodes will be rendered in the
%                           figure.  If 'y', electrode coordinates will be
%                           taken from *.LEPTO file in patient's
%                           FreeSurfer folder.  Alternatively, you
%                           can pass a 2D matrix of coordinates
%                           instead. The first 3 columns of such a matrix
%                           should be RAS coordinates and the fourth column
%                           is a binary matrix that is 1 if the electrode
%                           is on/in the left hemisphere. {default: 'y'}
%     elecSize             -Size of electrode markers (disks or spheres).
%                           This also determines thickness of lines connecting
%                           electrodes (if any) and electrode labels (if
%                           shown). {default=8};
%     elecShape            -'marker' or 'sphere': The shape used to
%                           represent electrodes. {default: 'marker'}
%     elecColors           -2D matrix of colors to fill electrodes
%                           (rows=electrodes, columns=RGB values), a column 
%                           vector of values that will be automatically converted
%                           into a color scale, or 'r' to make all red.
%                           {default: all electrodes filled with black}
%     edgeBlack            -If 'y', electrodes will all have a black
%                           border. Otherwise, border will be same color as
%                           marker. This argument has no effect if
%                           electrodes are represented as spheres. {default:
%                           'y'}
%     elecNames            -Cell array of the names of the electrodes to
%                           which the rows of elecColors corresponds.
%                           Electrodes not included in elecNames will be
%                           colored black. Note, THESE SHOULD BE MGRID
%                           NAMES. {default: not used}
%     clickElec            -If 'y', clicking on electrodes will reveal
%                           their names in a textbox. Clicking on the box
%                           should make it disapper. Disabled if 'n'. {default: 'y'}
%     badChans             -Cell array of the names of bad electrodes that
%                           should be plotted black (for when other
%                           electrodes are in color). {default: not used}
%     ignoreChans          -Cell array of the names of electrodes that
%                           will not be shown. {default: not used}
%     ignoreDepthElec    -'y' or 'n': If 'y', depth electrodes will not
%                           be shown. {default: 'y'}
%     onlyShow             -Cell array of the names of the only electrodes
%                           you want to be shown. If an electrode is listed
%                           both in onlyShow and ignoreChans, it will not
%                           be shown. {default: not used}
%     pullOut              -Factor via which to project electrodes out from
%                           the center of view. Helpful for when electrodes
%                           sink into the cortical surface. {default: 1}
%     showLabels           -'y' on 'n': If 'y', the name of the first and
%                           last electrode of each strip and each corner of
%                           the 64 chan grid will be shown next to electrode.
%                           {default: 'y'}
%     pairs                -A nx4, nx5, or nx6 cell array specifying n pairs of
%                           electrodes to be connected with lines.
%                           The first two columns indicate which electrodes
%                           are in the pair.
%                           The third column is a 3 element vector indicating
%                           the RGB color of the line that will be drawn
%                           to join the pair of electrodes.
%                           The fourth column is 'l' or 'r' to indicate
%                           which hemisphere the electrodes are on.
%                           The fifth, optional, column is the text that
%                           will appear when the line joining the electrodes
%                           is clicked on.
%                           The sixth, optional, column is the connection
%                           strength for each pair. The maximum value will
%                           correspond to lineWidth; others will be a ratio
%                           of that value.
%                           {default: not used}
%     lineWidth            -Thickness of line connecting pairs of
%                           electrodes. {default: elecSize/3}
%     elecCbar             -'y' or 'n': Plot colorbar next to brain. {default:
%                           'y' if funcfname elecColors argument specified,
%                           'n' otherwise}
%     elecColorScale       -'absmax','minmax', 'justpos', 'justneg',
%                           or numeric vector [minval maxval].  The limits
%                           that define the electrode data color scale.
%                           {default: 'absmax'}.
%     elecUnits             -A string or []. The title of the colorbar
%                           (e.g., 'z-score'). If empty, not title is drawn.
%                           {default: []}
%
%    Surface Options:
%     surfType             -'pial' or 'inflated': Type of Freesurfer surface
%                           to plot. If inflated, gyri and sulci are marked
%                           dark and light grey. {default='pial'};
%     overlayParcellation -If 'DK', Freesurfer Desikan-Killiany (36 area)
%                           cortical parcellation is plotted on the surface.
%                           If 'D', Freesurfer Destrieux (76 area)
%                           parcellation is used. If 'Y7' or 'Y17', Yeo 
%                           7 or 17-network atlas is used, respectively.
%                           You need to first run createIndivYeoMapping.m
%                           on the individual's data to create Y7 and & Y17 
%                           mappings as they are not produced by default by 
%                           recon-all. {default: not used}
%     parcellationColors  -Optional N-by-3 numeric array with RGB indexes
%                           (0:255) for each of the ROIs in the
%                           overlayParcellation. The colors for each ROI
%                           need to be in the exact same order as that of
%                           the default Freesurfer color table (you can get
%                           that by using the Freesurfer-MATLAB function
%                           [averts,albl,actbl=read_annotation(fname.annot);
%                           the ROIs are listed in actbl.struct_names and
%                           their numeric labels (found in albl) in
%                           actbl.table).
%                           {default: not used; the default Freesurfer
%                           colors for the parcellation are used instead}
%     opaqueness           -[1 to 0] The "alpha" level of the pial surface.
%                           0 means the surface is completely transparent.
%                           1 means that it is completely opaque.
%                           {default: 1}
%     view                 -Angle and lighting with which to view brain.
%                           This also defines which hemisphere to plot.
%                           Options include:
%                             'omni' - 6 views of each hemisphere. When you
%                             use this option with the funcfname option,
%                             funcfname needs to be a cell array of two
%                             filenames. The first specifies the left hem
%                             values and the second the right.
%                             'lomni' - 6 views of left hemisphere
%                             'l' - Left hem lateral
%                             'lm' - Left hem medial
%                             'lo' - Left hem occipital
%                             'lf' - Left hem frontal
%                             'lim' - Left hem inferior-medial
%                             'li' - Left hem inferior
%                             'ls' - Left hem superior
%                             'lsv' - Left hem superior and vertically
%                                     aligned
%                             'liv' - Left hem inferior and vertically
%                                     aligned
%                           Replace 'l' with 'r' to get these views of the
%                           right hemisphere. Alternatively, you can define
%                           everything yourself like so:
%                                   brainView.light=[1 0 0];
%                                   brainView.hem='r';
%                                   brainView.eyes=[45 0]
%                                   cfg.view=brainView
%
%    Neuroimaging Options:
%     pialOverlay          -Filename or cell array of filenames of
%                           functional data to plot.  If plotting both 
%                           hemispheres, use a cell array with the left hem
%                           filename as the 1st element and the right as
%                           the 2nd element. Be sure to include file paths. 
%                           {default: not used}
%     olayColorScale       -'absmax', 'minmax', 'justpos', 'justneg',
%                           or numeric vector (i.e., [minval maxval]).  The 
%                           limits that define the overlay data color scale. 
%                           {default: 'absmax'}
%     olayThresh           -Overlay data with an absolute value less
%                           than this threshold will not be shown (when
%                           showing positive and negative values). If
%                           olayColorScale is 'justpos' then only values
%                           greater than olayThresh will be shown. If
%                           olayColorScale is 'justneg' then only values less
%                           than olayThresh will be shown. {default: not used}
%     olayUnits            -A string or []. The title of the overlay colorbar
%                           (e.g., 'z-score'). If empty, not title is drawn.
%                           {default: []}
%     olayCbar             -'y' or 'n': Plot colorbar next to brain. {default:
%                           'y' if pialOverlay argument specified, 'n' otherwise}
%
%
%    Other Options:
%     axis                 -Handle of axis in which to make plot.
%                           {default: new axis created}
%     figId                -Handle of figure in which to make plot.
%                           {default: new figure created}
%     clearFig             -'y' or 'n'; If 'y', the figured is cleared
%                           before the plot is created. {default: 'y'}
%     backgroundColor      -Standard Matlab color argument (e.g., 'k' or
%                           [.1 .5 .3]). The axis background color.
%                           {default: not used}
%     title                -Title to place on figure. {default: 'y'}
%     fsurfSubDir          -The path to the FreeSurfer subject directory.
%                           Necessary if running MATLAB on Windows.
%                           {default: taken from shell}
%     clearGlobal          -If 'n', some plotting information is left in
%                           global memory. Useful for speeding *omni plots.
%                           {default: 'y'}
%     verbLevel            - An integer specifying the amount of information you want
%                           this function to provide about what it is doing during runtime.
%                            Options are:
%                             0 - quiet, only show errors, warnings, and external function reports
%                             1 - stuff anyone should probably know
%                             2 - stuff you should know the first time you start working
%                                 with a data set {default value}
%                             3 - stuff that might help you debug (show all
%                                 reports)
%
% Example:
% % Plot electrodes on brain with Desikan-Killiany cortical parcellation
% cfg=[];
% cfg.view='l';
% cfg.figId=1;
% cfg.overlayParcellation='DK';
% cfg.showLabels='y';
% cfg.title=[];
% cfgOut=plotPialSurf('PT001',cfg);
%
% % Plot depths with a semi-transparent pial surface
% cfg=[];
% cfg.view='li';
% cfg.ignoreDepthElec='n';
% cfg.opaqueness=.5;
% cfg.title=[];
% cfgOut=plotPialSurf('PT001',cfg);
%
% % Plot electrodes as spheres, color coded to reflect correlation value
% elecNames=cell(6,1);
% for a=1:6,
%     elecNames{a}=sprintf('lOs%d',a);
% end
% cfg=[];
% cfg.view='l';
% cfg.figId=1;
% cfg.elecShape='sphere';
% cfg.elecColors=rand(6,1);
% cfg.elecColorScale='minmax';
% cfg.showLabels='n';
% cfg.elecUnits='r';
% cfg.elecNames=elecNames;
% cfg.elecSize=2;
% cfg.title='PT001: Stimulus Correlations';
% cfgOut=plotPialSurf('PT001',cfg);
%
% % Plot bars between electrodes, color coded to reflect bipolar reference correlation value
% pairs=[];
% ct=0;
% for a=1:7,
%     ct=ct+1;
%     pairs{ct,1}=sprintf('Grid%d',a);
%     pairs{ct,2}=sprintf('Grid%d',a+1);
%     pairs{ct,3}=rand(1,3); % RGB val
%     pairs{ct,4}='L';
% end
% for a=1:7,
%     ct=ct+1;
%     pairs{ct,1}=sprintf('Grid%d',a+8);
%     pairs{ct,2}=sprintf('Grid%d',a+1+8);
%     pairs{ct,3}=rand(1,3); % RGB val
%     pairs{ct,4}='L';
% end
% cfg=[];
% cfg.view='l';
% cfg.figId=2;
% cfg.pairs=pairs;
% cfg.showLabels='n';
% cfg.elecUnits='r';
% cfg.title='PT001: Stimulus Correlations';
% cfg_out=plotPialSurf('PT001',cfg);
%
% % Overlay fMRI statistical map from FreeSurfer mgh file
% cfg=[];
% cfg.view='lomni';
% cfg.figId=2;
% cfg.olayUnits='z';
% cfg.pialOverlay='handMotorLH.mgh';
% cfgOut=plotPialSurf('PT001',cfg);
%
%
%  Authors:
%   David M. Groppe, Stephan Bickel, Pierre M�gevand, Andrew Dykstra
%   Laboratory for Multimodal Human Brain Mapping
%   Feinstein Institute for Medical Research
%   Manhasset, New York
%


% HISTORY:
% adykstra/ck 08-2010; get_loc_snap_mgh
% sb 05-2011: do not save graph option
% sb 06-2011: added config structure as input
% dg 03-2011: massively re-written
% dg 5/15/2011: ESM bars between electrodes now also affected by "pullOut"
%  option
% dg 1/3/2013: Updated comments and got rid of underscores in most arguments.
%  Also slightly modified SB's modifications to funcfname argument so that
%  you can pass a vector of values instead of a filename.
% dg 5/13/13: Comments to "pairs" option added (and now pairs can have four
%  columns). click_text changed to clickText3D so that text doesn't
%  disappear into brain.
% dg 9/9/13 changed nominal colors from Destrieux palette to
%  distinguishable_colors.m
% dg 1/2/14 omni, lomni, and romni views added; cfg.units option added
% mm 24/02/14: pairs can know have 5 columns to specify lineWidth for each
%  pairs
% pm x/xx/14 debug passing 2D numeric array for elecCoord
% pm 7/18/14 added optional parcellationColors input
% pm 7/24/14 debug passing 2D numeric array for elecCoord AND overlayParcellation
% pm 7/28/14 debug passing 2D numeric array for elecCoord AND inflated pial surface
% pm 8/12/14 debug ?omni view
% dg 4/15 elecColors can now be a vector of values from which a elecColorScale
% is automatically derived
% dg 6/15 now expects electrode coordinates and names in YangWang method format
% dg 9/15 elecSize now properly modulates sphere
% As of 2016, revision history will be kept on GitHub


%% TO DO
% do auto colormap for electrodes (both jet and rb)?
% Size of electrodes should be relative to brain size?
% Make elecColors and colorbar work for bipolar lines too

function cfgOut=plotPialSurf(fsSub,cfg)

%% Parse parameters
if ~isfield(cfg, 'elecSize'),       elecSize = 8;          else  elecSize = cfg.elecSize;      end
if ~isfield(cfg, 'snap2surf'),      snap2surf = 0;         else  snap2surf = cfg.snap2surf;      end
if ~isfield(cfg, 'surfType'),       surfType = 'pial';     else  surfType = cfg.surfType;     end
if ~isfield(cfg, 'elecCoord'),      elecCoord= 'yes';      else  elecCoord = cfg.elecCoord;       end
if ~isfield(cfg, 'elecColors'),     elecColors= [];        else  elecColors = cfg.elecColors;        end
if ~isfield(cfg, 'elecColorScale'), elecColorScale='absmax';   else elecColorScale=cfg.elecColorScale; end
if ~isfield(cfg, 'elecCbar'),       elecCbar=[];          else elecCbar=cfg.elecCbar; end
if ~isfield(cfg, 'elecUnits'),      elecUnits=[];            else elecUnits=cfg.elecUnits; end
if ~isfield(cfg, 'pullOut'),        pullOut= 1;            else  pullOut = cfg.pullOut; end
if ~isfield(cfg, 'view'),           brainView= 'l';       else  brainView = cfg.view; end
if ~isfield(cfg, 'axis'),           hAx=[];               else  hAx=cfg.axis; end
if ~isfield(cfg, 'overlayParcellation'), overlayParcellation=0;  else  overlayParcellation=cfg.overlayParcellation; end
if ~isfield(cfg, 'parcellationColors'),  parcellationColors= []; else  parcellationColors= cfg.parcellationColors;  end
if ~isfield(cfg, 'figId'),         hFig=[];              else  hFig=cfg.figId; end
if ~isfield(cfg, 'clearFig'),       clearFig=1;            else  clearFig=cfg.clearFig; end
if ~isfield(cfg, 'title'),          surfTitle='default';  else surfTitle=cfg.title; end
if ~isfield(cfg, 'elecNames'),      color_elecnames=[];    else color_elecnames=cfg.elecNames; end
if ~isfield(cfg, 'badChans'),       badChans=[];           else badChans=cfg.badChans; end
if ~isfield(cfg, 'ignoreChans'),    ignoreChans=[];        else ignoreChans=cfg.ignoreChans; end
if ~isfield(cfg, 'clickElec'),      clickElec='y'; else clickElec=cfg.clickElec; end
if ~isfield(cfg, 'fsurfSubDir'),  fsDir=[];             else fsDir=cfg.fsurfSubDir; end
if ~isfield(cfg, 'verbLevel'),      verbLevel=2;           else verbLevel=cfg.verbLevel; end
if ~isfield(cfg, 'backgroundColor'), backgroundColor=[]; else backgroundColor=cfg.backgroundColor; end
if ~isfield(cfg, 'pairs'), electrode_pairs=[];  else electrode_pairs=cfg.pairs; end
if ~isfield(cfg, 'lineWidth'), lineWidth=[];  else lineWidth=cfg.lineWidth; end
if ~isfield(cfg, 'onlyShow'), onlyShow=[];  else onlyShow=cfg.onlyShow; end
if ~isfield(cfg, 'ignoreDepthElec'), ignoreDepthElec='y'; else ignoreDepthElec=cfg.ignoreDepthElec; end
if ~isfield(cfg, 'edgeBlack'),      edgeBlack='y';         else edgeBlack=cfg.edgeBlack; end
if ~isfield(cfg, 'elecShape'), electrodeshape='marker';  else electrodeshape=cfg.elecShape; end
if ~isfield(cfg, 'showLabels'), showLabels=0;  else showLabels=universalYes(cfg.showLabels); end
if ~isfield(cfg, 'opaqueness'),      opaqueness=1;          else opaqueness=cfg.opaqueness; end
if ~isfield(cfg, 'clearGlobal'),    clearGlobal=1;          else clearGlobal=cfg.clearGlobal; end
if ~isfield(cfg, 'pialOverlay'),    pialOverlay=[];         else pialOverlay=cfg.pialOverlay; end 
if ~isfield(cfg, 'olayColorScale'), olayColorScale='absmax';  else olayColorScale=cfg.olayColorScale; end
if ~isfield(cfg, 'olayThresh'), olayThresh=0;  else olayThresh=cfg.olayThresh; end 
if ~isfield(cfg, 'olayCbar'),       olayCbar=[];          else olayCbar=cfg.olayCbar; end 
if ~isfield(cfg, 'olayUnits'),      olayUnits=[];         else olayUnits=cfg.olayUnits; end

global overlayData elecCbarMin elecCbarMax olayCbarMin olayCbarMax; % Needed for ?omni plots

try 
checkCfg(cfg,'plotPialSurf.m');
elecCmapName=[]; % needed for cfgOut
olayCmapName=[]; % needed for cfgOut

if strcmpi(brainView,'omni')
    cfgOut=plotPialOmni(fsSub,cfg);
    return;
elseif strcmpi(brainView,'lomni') || strcmpi(brainView,'romni')
    cfgOut=plotPialHemi(fsSub,cfg);
    return;
end

% FreeSurfer Subject Directory
if isempty(fsDir)
    fsDir=getFsurfSubDir();
end

% Folder with surface files
subFolder=fullfile(fsDir,fsSub);
if ~exist(subFolder,'dir')
   error('FreeSurfer folder for %s not found.',subFolder); 
end
surfacefolder=fullfile(fsDir,fsSub,'surf');

% Get side of brain to show
if ischar(brainView),
    if findstr(brainView,'l')
        side='l';
    else
        side='r';
    end
else
    side=lower(brainView.hem);
    if ~strcmpi(side,'l') && ~strcmpi(side,'r')
        error('cfg.brainView.hem needs to be ''l'' or ''r''.');
    end
end

% Set/check electrode colorbar plotting options
if isempty(elecCbar)
    if ~isempty(elecColors) && ~ischar(elecColors)
        elecCbar='y';
    else
        elecCbar='n';
    end
end
if isempty(olayCbar)
    if ~isempty(pialOverlay)
        olayCbar='y';
    else
        olayCbar='n';
    end
end

%% %%%%%%%%%% Start Main Function %%%%%%%
verbReport('**** PLOTTING CORTICAL SURFACE WITH "plotPialSurf.m" ****', ...
    2,verbLevel);


%% MAKE FIGURE/AXIS
if ~isempty(hFig),
    figure(hFig);
else
    hFig=figure;
end
if universalYes(clearFig),
    clf;
end
if ~isempty(backgroundColor)
    set(hFig,'color',backgroundColor);
end
if ~isempty(hAx),
    axes(hAx);
else
    hAx=gca;
end


%% If plotting on inflated surface, load curvature values so that sulci and
% gyri can be seen
if strcmpi(surfType,'inflated')
    if side == 'r'
        curv = read_curv(fullfile(surfacefolder,'rh.curv'));
    else
        curv = read_curv(fullfile(surfacefolder,'lh.curv'));
    end
    curvMap=zeros(length(curv),3);
    pcurvIds=find(curv>=0);
    curvMap(pcurvIds,:)=repmat([1 1 1]*.3,length(pcurvIds),1);
    ncurvIds=find(curv<0);
    curvMap(ncurvIds,:)=repmat([1 1 1]*.7,length(ncurvIds),1);
end

%% Initialize pial surface coloration
% Color gyri and sulci different shades of grey
if side == 'r'
    curv = read_curv(fullfile(surfacefolder,'rh.curv'));
else
    curv = read_curv(fullfile(surfacefolder,'lh.curv'));
end
if strcmpi(surfType,'inflated')
    overlayDataTemp=zeros(length(curv),3);
    pcurvIds=find(curv>=0);
    overlayDataTemp(pcurvIds,:)=repmat([1 1 1]*.3,length(pcurvIds),1);
    ncurvIds=find(curv<0);
    overlayDataTemp(ncurvIds,:)=repmat([1 1 1]*.7,length(ncurvIds),1);
else
    overlayDataTemp=ones(length(curv),3)*.7;
end


if ~isempty(overlayData) || ~isempty(pialOverlay)
    % Pial Surface Overlay (e.g., fMRI statistical maps)
    if  ~isempty(pialOverlay)
        [pathstr, name, ext]=fileparts(pialOverlay);
        if strcmpi(ext,'.mgh')
            % FreeSurfer formatted file
            mgh = MRIread(pialOverlay);
            overlayData=mgh.vol;
        else
            % mat file that needs to contain an mgh variable
            if ~exist(pialOverlay,'file')
                error('File %s not found.',pialOverlay);
            end
            load(pialOverlay,'overlayData');
            if ~exist('overlayData','var')
                error('File %s does NOT contain a variable called overlayData.',pialOverlay);
            end
        end
    end
    if isvector(overlayData)
        %overlayData is a vector of values that needs to be converted to
        %RGB
        olayDataVec=overlayData;
        [overlayData, oLayLimits, olayCmapName]=vals2Colormap(olayDataVec,olayColorScale);
        olayCbarMin=oLayLimits(1);
        olayCbarMax=oLayLimits(2);
        if strcmpi(olayColorScale,'justpos')
            maskIds=find(olayDataVec<=olayThresh);
            overlayData(maskIds,:)=overlayDataTemp(maskIds,:); % make subthreshold values grey
            %overlayData(maskIds,:)=repmat([.7 .7 .7],length(maskIds),1); % make subthreshold values grey
        elseif strcmpi(olayColorScale,'justneg')
            maskIds=find(olayDataVec>=olayThresh);
            overlayData(maskIds,:)=overlayDataTemp(maskIds,:); % make superthreshold values grey
            %overlayData(maskIds,:)=repmat([.7 .7 .7],length(maskIds),1); % make superthreshold values grey
        elseif olayThresh~=0
            maskIds=find(abs(olayDataVec)<=olayThresh);
            overlayData(maskIds,:)=overlayDataTemp(maskIds,:); % make abs subthreshold values grey
            %overlayData(maskIds,:)=repmat([.7 .7 .7],length(maskIds),1); % make abs subthreshold values grey
        end
        clear olayDataVec
    end
else
    overlayData=overlayDataTemp;
end
clear overlayDataTemp


%% READ SURFACE
global cort %speeds up omni a tiny bit
if isempty(cort)
    if side == 'r'
        [cort.vert cort.tri]=read_surf(fullfile(surfacefolder,['rh.' surfType]));
    else
        [cort.vert cort.tri]=read_surf(fullfile(surfacefolder,['lh.' surfType]));
    end
    if min(min(cort.tri))<1
        cort.tri=cort.tri+1; %sometimes this is needed sometimes not. no comprendo. DG
    end
end


%% PLOT SURFACE
tripatchDG(cort,hFig,overlayData); %this plots the brain
rotate3d off;


%% If specified, overlay cortical parcellation
if overlayParcellation,
    labelFolder=fullfile(fsDir,fsSub,'label');
    if ~isempty(labelFolder) && (labelFolder(end)~='/')
        labelFolder=[labelFolder '/'];
    end
    if strcmpi(overlayParcellation,'DK')
        annotFname=fullfile(labelFolder,[side 'h.aparc.annot']); %Desikan-Killiany 36 area atlas
        [averts,albl,actbl]=read_annotation(annotFname);
        actbl.table(1,1:3)=255*[1 1 1]*.7; %make medial wall the same shade of grey as functional plots
    elseif strcmpi(overlayParcellation,'D')
        annotFname=fullfile(labelFolder,[side 'h.aparc.a2009s.annot']); %Destrieux 76 area atlas
        [averts,albl,actbl]=read_annotation(annotFname);
        actbl.table(43,1:3)=255*[1 1 1]*.7; %make medial wall the same shade of grey as functional plots
    elseif strcmpi(overlayParcellation,'Y7')
        if strcmpi(fsSub,'fsaverage')
            annotFname=fullfile(labelFolder,[side 'h.Yeo2011_7Networks_N1000.annot']); % Yeo et al. 2011
            [averts,albl,actbl]=read_annotation(annotFname);
        else
            annotFname=fullfile(labelFolder,[side 'h_Yeo2011_7Networks_N1000.mat']); % Yeo et al. 2011
            load(annotFname);
            albl=label;
            actbl=colortable;
            clear colortable label vertices
            actbl.table(1,1:3)=255*[1 1 1]*.7; %make medial wall the same shade of grey as functional plots
        end
    elseif strcmpi(overlayParcellation,'Y17')
        if strcmpi(fsSub,'fsaverage')
            annotFname=fullfile(labelFolder,[side 'h.Yeo2011_17Networks_N1000.annot']); % Yeo et al. 2011
            [averts,albl,actbl]=read_annotation(annotFname);
        else
            annotFname=fullfile(labelFolder,[side 'h_Yeo2011_17Networks_N1000.mat']); % Yeo et al. 2011
            load(annotFname);
            albl=label;
            actbl=colortable;
            clear colortable label vertices
            actbl.table(1,1:3)=255*[1 1 1]*.7; %make medial wall the same shade of grey as functional plots
        end
    elseif exist(overlayParcellation,'file')
        [averts,albl,actbl]=read_annotation(overlayParcellation);
        %  actbl.table(43,1:3)=255*[1 1 1]*.7; %make medial wall the same shade of grey as functional plots
    else
        error('overlayParcellation argument needs to take a value of ''D'',''DK'',''Y7'', or ''Y17''.');
    end
    if ~isempty(parcellationColors)
        if size(parcellationColors,1)~=size(actbl.table,1)
            error('plotPialSurf:colors_parcellation_size1','parcellationColors argument needs to have \n the same number of rows as the number of ROIs \n in the parcellation. For %s, %d.',overlayParcellation,size(actbl.table,1));
        end
        if size(parcellationColors,2)~=3
            error('plotPialSurf:colors_parcellation_size2','parcellationColors must be an N-by-3 array.');
        end
        actbl.table(:,1:3)=parcellationColors;
    end
    clear averts;
    [~,locTable]=ismember(albl,actbl.table(:,5));
    locTable(locTable==0)=1; % for the case where the label for the vertex says 0
    fvcdat=actbl.table(locTable,1:3)./255; %scale RGB values to 0-1
    clear locTable;
    hTsurf=trisurf(cort.tri, cort.vert(:, 1), cort.vert(:, 2), cort.vert(:, 3),...
        'FaceVertexCData', fvcdat,'FaceColor', 'interp','FaceAlpha',1);
    if ~strcmpi(elecCoord,'no') && ~strcmpi(elecCoord,'n')
        cfg_elec2parc=[];
        cfg_elec2parc.fsurfSubDir=fsDir;
        if isnumeric(elecCoord)
            cfg_elec2parc.elecCoord=elecCoord;
            cfg_elec2parc.elecNames=cfg.elecNames;
        end
        elecAssign=[];
    end
else
    elecAssign=[];
end


%% Set Lighting & View
shading interp; lighting gouraud; material dull; axis off, hold on
if ischar(brainView)
    switch brainView
        case 'r'
            l=light('Position',[1 0 0]);
            view(90,0)
        case 'rm'
            l=light('Position',[-1 0 0]);
            view(270,0)
        case 'rim'
            l=light('Position',[-1 0 0]);
            view(270,-45)
        case 'ri'
            l=light('Position',[0 0 -1]);
            view(90,-90)
        case 'ro'
            l=light('Position',[0 -1 0]);
            view(0,0)
        case 'lo'
            l=light('Position',[0 -1 0]);
            view(0,0)
        case 'rf'
            l=light('Position',[0 1 0]);
            view(180,0)
        case 'lf'
            l=light('Position',[0 1 0]);
            view(180,0)
        case 'rs'
            l=light('Position',[0 0 1]);
            view(90,90);
        case 'rsv' %superior & vertically aligned
            l=light('Position',[0 0 1]);
            view(0,90);
        case 'l'
            l=light('Position',[-1 0 0]);
            view(270,0);
        case 'lm'
            l=light('Position',[1 0 0]);
            view(90,0);
        case 'li'
            l=light('Position',[0 0 -1]);
            view(90,-90);
        case 'lim'
            l=light('Position',[-1 0 0]);
            view(270,-45);
        case 'ls'
            l=light('Position',[0 0 1]);
            view(270,90);
        case 'lsv' %superior & vertically aligned
            l=light('Position',[0 0 1]);
            view(0,90);
        case 'liv' %inferior & vertically aligned
            l=light('Position',[0 0 -1]);
            view(0,-90);
        case 'riv' %inferior & vertically aligned
            l=light('Position',[0 0 -1]);
            view(0,-90);
    end
    clear l
else
    light('Position',brainView.light);
    view(brainView.eyes)
end
alpha(opaqueness);


%% PLOT ELECTRODES (optional)
if universalNo(elecCoord)
    verbReport('...not plotting electrodes',2,verbLevel);
else
    if isnumeric(elecCoord)
        % Electrode coordinates passed as argument
        if size(elecCoord,2)==4
            display('...Electrode input is matrix with coordinates.');
            RAS_coor=elecCoord(:,1:3);
            if side=='l',
                showElecIds=find(elecCoord(:,4));
            else
                showElecIds=find(~elecCoord(:,4));
            end
            % elecNames=cfg.elecNames(showElecIds);
            color_elecnames=cfg.elecNames(showElecIds);
            elecNames=color_elecnames; % ?? if these variables are redundant, we should just remove them
            if strcmpi(surfType,'inflated')
                cfg_pvox2inf=[];
                cfg_pvox2inf.fsurfSubDir=fsDir;
                cfg_pvox2inf.elecCoord=elecCoord(showElecIds,:);
                cfg_pvox2inf.elecNames=color_elecnames;
                RAS_coor=pial2InfBrain(fsSub,cfg_pvox2inf);
            else
                RAS_coor=RAS_coor(showElecIds,:);
            end
        else
            error('...Electrode input is numeric but doesn''t have 3 coordinates + binary hemisphere column');
        end
    else
        % electrode coordinates and names to be read from .LEPTO and .electrodeNames files
        verbReport(sprintf('...Overlaying electrodes. Taking coordinates from %s.LEPTO and %s.electrodeNames in elec_recon folder. Use cfg.eleccord=''n''; if not wanted.',fsSub,fsSub), ...
            2,verbLevel);
        if strcmpi(surfType,'inflated')
            coordFname=fullfile(fsDir,fsSub,'elec_recon',[fsSub '.INF']);
        else
            coordFname=fullfile(fsDir,fsSub,'elec_recon',[fsSub '.LEPTO']);
        end
        elecCoordCsv=csv2Cell(coordFname,' ',2);
        nElecTotal=size(elecCoordCsv,1);
        RAS_coor=zeros(nElecTotal,3);
        for csvLoopA=1:nElecTotal,
            for csvLoopB=1:3,
                RAS_coor(csvLoopA,csvLoopB)=str2num(elecCoordCsv{csvLoopA,csvLoopB});
            end
        end

        elecInfoFname=fullfile(fsDir,fsSub,'elec_recon',[fsSub '.electrodeNames']);
        elecInfo=csv2Cell(elecInfoFname,' ',2);

        % Remove elecs in opposite hemisphere
        if side=='l'
            showElecIds=find(cellfun(@(x) strcmp(x,'L'),elecInfo(:,3)));
        else
            showElecIds=find(cellfun(@(x) strcmp(x,'R'),elecInfo(:,3)));
        end
        
        % Remove depth elecs if requested
        if universalYes(ignoreDepthElec),
            verbReport('...not plotting depth electrodes (if any exist)', ...
                2,verbLevel);
            depthElecIds=find(cellfun(@(x) strcmp(x,'D'),elecInfo(:,2)));
            showElecIds=setdiff(showElecIds,depthElecIds);
        end
        
        RAS_coor=RAS_coor(showElecIds,:);
        elecInfo=elecInfo(showElecIds,:);
        elecNames=elecInfo(:,1);
    end

    % Pull electrodes out from the brain towards the viewer
    nRAS=size(RAS_coor,1);
    if pullOut,
        verbReport(sprintf('...pulling out electrodes by factor %f. cfg.pullOut=0 if not wanted.\n',pullOut), ...
            2,verbLevel);
        v=axis;
        campos=get(gca,'cameraposition');
        %camtarg=get(gca,'cameratarget'); ?? Should we check that this is set to 0?
        err=repmat(campos,nRAS,1)-RAS_coor;
        nrmd=err./repmat(sqrt(sum(err.^2,2)),1,3);
        RAS_coor=RAS_coor+nrmd*pullOut;
    end
    
    % Plot lines joining electrodes ?? update this
    if ~isempty(electrode_pairs),
        % Remove all electrode pairs not on this hemisphere
        nPairs=length(electrode_pairs);
        usePairs=zeros(nPairs,1);
        for pairLoop=1:nPairs,
            if strcmpi(electrode_pairs{pairLoop,4},side)
                usePairs(pairLoop)=1;
            end
        end
        electrode_pairs=electrode_pairs(find(usePairs),:);
        clear usePairs nPairs
        
        if isempty(lineWidth)
            lineWidth=elecSize/3;
        end
        if size(electrode_pairs,2)<=5
            electrode_pairs(:,6) ={lineWidth};
        elseif size(electrode_pairs,2)>5
            % normalize lineWidth
            electrode_pairs(:,6) = cellfun(@rdivide,electrode_pairs(:,6), ...
                num2cell(repmat(max([electrode_pairs{:,6}]), [size(electrode_pairs,1) 1])),'UniformOutput',false);
            electrode_pairs(:,6) = cellfun(@times,electrode_pairs(:,6), ...
                num2cell(repmat(lineWidth, [size(electrode_pairs,1) 1])),'UniformOutput',false);
        end
        
        n_pairs=size(electrode_pairs,1);
        pair_ids=[0 0];
        for a=1:n_pairs,
            for b=1:2,
                [got_it, pair_ids(b)]=ismember(lower(electrode_pairs{a,b}),lower(elecNames));
                if ~got_it
                    error('Channel %s is in electrode pairs but not in pialVox electrode names.',electrode_pairs{a,b});
                end
            end
            hl=plot3([RAS_coor(pair_ids(1),1) RAS_coor(pair_ids(2),1)], ...
                [RAS_coor(pair_ids(1),2) RAS_coor(pair_ids(2),2)], ...
                [RAS_coor(pair_ids(1),3) RAS_coor(pair_ids(2),3)],'-');
            if isnumeric(electrode_pairs{a,3})
                set(hl,'color',electrode_pairs{a,3},'lineWidth',lineWidth);
            else
                set(hl,'color',str2num(electrode_pairs{a,3}),'lineWidth',lineWidth);
            end
            
            if size(electrode_pairs,2)>4 && ~isempty(electrode_pairs{a,5})
                clickText3D(hl,[electrode_pairs{a,1} '-' electrode_pairs{a,2} ': ' electrode_pairs{a,5}],2);
            else
                clickText3D(hl,[electrode_pairs{a,1} '-' electrode_pairs{a,2}],2);
            end
        end
    end
    
    % Make electrodes black if no input given
    if isempty(elecColors)
        elecColors = zeros(size(RAS_coor));
    elseif ischar(elecColors) && strcmp(elecColors,'r')
        elecColors = zeros(size(RAS_coor));
        elecColors(:,1) = 1;
    elseif isvector(elecColors) && size(elecColors,2)~=3
        % we need the second condition in case wants to plot a single
        % electrode and passes an rgb vector to specify the color
        if isnumeric(elecColorScale)
            type='minmax';
            elecCbarMin=elecColorScale(1);
            elecCbarMax=elecColorScale(2);
        else
            type=elecColorScale;
        end
        if verLessThan('matlab','8.0.1')
            elecCmapName='jet';
        else
            elecCmapName='parula';
        end
        if isempty(elecCbarMin),
            % make electrode colormap
            [elecColors, elecLimits, elecCmapName]=vals2Colormap(elecColors,type,elecCmapName);
            elecCbarMin=elecLimits(1);
            elecCbarMax=elecLimits(2);
        else
            [elecColors, elecLimits, elecCmapName]=vals2Colormap(elecColors,type,elecCmapName,[elecCbarMin elecCbarMax]);
        end
    else
        % elecColorScale consists of a matrix or vector of RGB values
        if ~universalNo(elecCbar),
            if isnumeric(elecColorScale) && isvector(elecColorScale) && length(elecColorScale)==2
                elecCbarMin=min(elecColorScale);
                elecCbarMin=max(elecColorScale);
            else
                error('When cfg.elecColors is a matrix of RGB values, elecColorScale needs to specify the min and max of the colorscale.');
            end
        end
    end
    if ~isempty(color_elecnames),
        n_color_electrodes=length(color_elecnames);
        used_color_electrodes=zeros(1,n_color_electrodes);
    end
    if isempty(onlyShow),
        %if user didn't specify a subset of electrodes to show, attempt to
        %show all of them
        onlyShow=elecNames;
    end
    if ~isempty(ignoreChans),
        onlyShow=setdiff(onlyShow,ignoreChans);
    end
    
    % Prepare variables if electrodes are to be drawn as spheres
    if strcmpi(electrodeshape,'sphere')
        elecSphere=1;
        [sphX, sphY, sphZ]=sphere(20);
        Zdim=size(sphZ);
        scale_sph=elecSize;
        sphX=sphX*scale_sph;
        sphY=sphY*scale_sph;
        sphZ=sphZ*scale_sph;
        sph_colors=zeros(nRAS,3);
        sph_ct=0;
    else
        elecSphere=0;
    end
    
    % Check to make sure colored electrodes have unique names
    if ~isempty(color_elecnames)
       if length(color_elecnames)~=length(unique(color_elecnames)) 
           error('cfg.elecNames has multiple entries with the exact same electrode name.');
       end
    end
    
    for j = 1:nRAS
        if ismember(lower(elecNames{j}),lower(onlyShow)),
            if ~isempty(color_elecnames)
                [have_color, id]=ismember(lower(elecNames{j}),lower(color_elecnames));
                if ~have_color || (~isempty(badChans) && ismember(lower(elecNames{j}),lower(badChans)))
                    % We don't have data for this electrode or have
                    % been instructed to ignore it; plot it black
                    if elecSphere
                        sph_ct=sph_ct+1;
                        h_elec(sph_ct)=surf(sphX+RAS_coor(j,1),sphY+RAS_coor(j,2),sphZ+RAS_coor(j,3),zeros(Zdim));
                        sph_colors(sph_ct,:)=[1 1 1]*.01;
                    else
                        h_elec=plot3(RAS_coor(j,1),RAS_coor(j,2),RAS_coor(j,3),'o','Color','k','MarkerFaceColor','k','MarkerSize',elecSize);
                    end
                    if showLabels,
                        add_name(RAS_coor(j,:),elecNames{j},elecNames,elecSize,[1 1 1])
                    end
                else
                    % Color the electrode to represent data
                    if elecSphere
                        sph_ct=sph_ct+1;
                        h_elec(sph_ct)=surf(sphX+RAS_coor(j,1),sphY+RAS_coor(j,2),sphZ+RAS_coor(j,3),zeros(Zdim));
                        sph_colors(sph_ct,:)=elecColors(id,:);
                        used_color_electrodes(id)=1;
                        %colormap(gca,elecColors(id,:));
                        %shading interp; lighting gouraud; material dull;
                        %set(h_sph(j),'facecolor',elecColors(id,:));
                    else
                        if universalYes(edgeBlack)
                            markeredgecolor=[0 0 0];
                        else
                            markeredgecolor=elecColors(id,:);
                        end
                        h_elec=plot3(RAS_coor(j,1),RAS_coor(j,2),RAS_coor(j,3),'o', ...
                            'Color',elecColors(id,:),'MarkerFaceColor', elecColors(id,:),'MarkerSize',elecSize, ...
                            'MarkerEdgeColor',markeredgecolor,'lineWidth',2);
                        used_color_electrodes(id)=1;
                    end
                    if showLabels,
                        add_name(RAS_coor(j,:),elecNames{j},elecNames,elecSize,elecColors(id,:));
                    end
                end
            else
                if elecSphere
                    sph_ct=sph_ct+1;
                    h_elec(sph_ct)=surf(sphX+RAS_coor(j,1),sphY+RAS_coor(j,2),sphZ+RAS_coor(j,3),zeros(Zdim));
                    %colormap(gca,elecColors(j,:))
                    %set(h_sph(j),'facecolor',elecColors(j,:));
                    %shading interp; lighting gouraud; material dull;
                    sph_colors(sph_ct,:)=elecColors(j,:);
                else
                    h_elec=plot3(RAS_coor(j,1),RAS_coor(j,2),RAS_coor(j,3),'o','Color',elecColors(j,:),'MarkerFaceColor', elecColors(j,:),'MarkerSize',elecSize);
                    if showLabels,
                        add_name(RAS_coor(j,:),elecNames{j},elecNames,elecSize,elecColors(j,:))
                    end
                end
            end
            hold all
            if universalYes(clickElec),
                if isempty(elecAssign)
                    if elecSphere,
                        set(h_elec(sph_ct),'userdata',elecNames{j});
                    else
                        set(h_elec,'userdata',elecNames{j});
                    end
                else
                    if elecSphere,
                        set(h_elec(sph_ct),'userdata',elecNames{j});
                    else
                        set(h_elec,'userdata',[elecNames{j} ' ' elecAssign{j,2}]);
                    end
                end
                % This click_text code should put the text out towards the
                % viewer (so it doesn't get stuck in the brain)
                % Note: pop_fact=5 in the below code might be too far for lateral surfaces
                bdfcn=['Cp = get(gca,''CurrentPoint''); ' ...
                    'Cp=Cp(1,1:3);', ...
                    'v=axis;', ...
                    'campos=get(gca,''cameraposition'');', ...
                    'df=Cp-campos;', ...
                    'nrmd=df/sqrt(sum(df.^2));', ...
                    'pop_fact=5;', ...
                    'eval(sprintf(''Cp=Cp-%d*nrmd;'',pop_fact));', ...
                    'dat=get(gcbo,''userdata'');', ...
                    'ht=text(Cp(1),Cp(2),Cp(3),sprintf(''%s'',dat));', ...
                    'set(ht,''backgroundColor'',''w'',''horizontalalignment'',''center'',''verticalalignment'',''middle'',''buttondownfcn'',''delete(gcbo);'');'];
                if elecSphere,
                    set(h_elec(sph_ct),'buttondownfcn',bdfcn);
                else
                    set(h_elec,'buttondownfcn',bdfcn);
                end
            end
        end
        %NOTE:
        % x dimension is lateral/medial  (+=lateral)
        % y dimension is ant/posterior (+=anterior)
        % z dimension is superior/inferior (+=superior)
    end
    if verbLevel>1,
        if ~isempty(color_elecnames),
            not_found=find(used_color_electrodes==0);
            if not_found
                warning('Number of colored electrodes NOT FOUND: %d\n',length(not_found));
                for dg=not_found,
                    fprintf('%s\n',color_elecnames{dg});
                end
            end
        end
    end
    if elecSphere,
        shading interp; lighting gouraud; material dull;
        %for some reason the shading command resets of the colors of all the
        %spheres, thus the need for this silly loop.  There is surely a more
        %elegant way to deal with this.
        for a=1:sph_ct,
            set(h_elec(a),'facecolor',sph_colors(a,:));
        end
    end
end


%% Add Title
if strcmpi(surfTitle,'default'),
    if ischar(brainView)
        surfTitle=[fsSub '; ' brainView '; '];
    else
        surfTitle=[fsSub '; ' brainView.hem '; '];
    end
    title(surfTitle,'fontsize',20);
elseif ~isempty(surfTitle)
    title(surfTitle,'fontsize',20);
end


%% Colorbar
hElecCbar=[]; % needs to be declared for cfgOut even if colorbar not drawn
hOlayCbar=[]; % needs to be declared for cfgOut even if colorbar not drawn
if universalYes(elecCbar) && universalYes(olayCbar)
    % Plot both electrode AND olay colorbar
    if isempty(elecCbarMin) || isempty(elecCbarMax)
        fprintf('elecCbarMin or elecCbarMax are empty. Cannot draw colorbar.\n');
    else
        pos=[0.9158 0.1100 0.0310 0.8150];
        cbarFontSize=12;
        cbarDGplus(pos,[elecCbarMin elecCbarMax],elecCmapName,5,elecUnits,'top',cbarFontSize);
    end
    
    pos=[0.1 0.05 0.8150 0.0310];
    cbarDGplus(pos,[olayCbarMin olayCbarMax],olayCmapName,5,olayUnits,'top',cbarFontSize);
elseif universalYes(elecCbar)
    % Plot electrode colorbar only
    if isempty(elecCbarMin) || isempty(elecCbarMax)
        fprintf('elecCbarMin or elecCbarMax are empty. Cannot draw colorbar.\n');
    else
        % Plot electrode colorbar only
        pos=[0.9158 0.1100 0.0310 0.8150];
        cbarDGplus(pos,[elecCbarMin elecCbarMax],elecCmapName,5,elecUnits);
        
        if isequal(get(hFig,'color'),[0 0 0]);
            %If background of figure is black, make colorbar text white
            set(hElecCbar,'xcolor','w'); % fix so that box isn't white? ??
            set(hElecCbar,'ycolor','w');
        end
    end
elseif universalYes(olayCbar)
    % Plot pial surface overlay colorbar only
    pos=[0.9158 0.1100 0.0310 0.8150];
    cbarDGplus(pos,[olayCbarMin olayCbarMax],olayCmapName,5,olayUnits);

    if isequal(get(hFig,'color'),[0 0 0]);
        %If background of figure is black, make colorbar text white
        set(hOlayCbar,'xcolor','w'); % fix so that box isn't white? ??
        set(hOlayCbar,'ycolor','w');
    end
end


%% COLLECT CONFIG OUTPUT
cfgOut.subject=fsSub;
cfgOut.view=brainView;
cfgOut.elecSize=elecSize;
cfgOut.surfType=surfType;
cfgOut.hElecCbar=hElecCbar;
cfgOut.hOlayCbar=hOlayCbar;
cfgOut.hBrain=hAx;
cfgOut.elecCmapName=elecCmapName;
cfgOut.olayCmapName=olayCmapName;
if exist('cfg','var'), cfgOut.cfg=cfg; end
if exist('RAS_coor','var'), cfgOut.electrodeCoords=RAS_coor; end
if exist('elecCbarMin','var'), cfgOut.elecCbarLimits=[elecCbarMin elecCbarMax]; end
if exist('olayCbarMin','var'), cfgOut.olayCbarLimits=[olayCbarMin olayCbarMax]; end

if universalYes(clearGlobal)
    clear global elecCbarMin elecCbarMax olayCbarMin olayCbarMax cort overlayData;
end

catch err
    disp(err.identifier);
    disp(err.message);
    for errLoop=1:length(err.stack),
        disp(err.stack(errLoop).file); 
        fprintf('Line: %d\n',err.stack(errLoop).line); 
    end
    % Delete global variables if function crashes to prevent them from
    % being automatically used the next time plotPialSurf is called.
    clear global elecCbarMin elecCbarMax olayCbarMin olayCbarMax cort overlayData;
end

%%%% END OF MAIN FUNCTION %%%%


%% HELPER FUNCTIONS

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% subfunction add_name
function add_name(xyz,label,all_labels,markersize,rgb)
% Adds an electrode's name next to its location
% right now rgb argument is ignored, fix in the future so that electrode
% names stand out from background? ??

if keyElec(label,all_labels),
    h_t=text(xyz(1),xyz(2),xyz(3),label);
    set(h_t,'color','k','fontweight','bold','fontsize',markersize+4);
    %     if isequal(rgb,[0 0 0]),
    %         set(h_t,'color','w','fontweight','bold','fontsize',markersize+2);
    %     else
    %         set(h_t,'color','k','fontweight','bold','fontsize',markersize+2);
    %     end
end


%% subfunction plotPialOmni
function sub_cfg_out=plotPialOmni(fsSub,cfg)

if ~isfield(cfg, 'figId'),         hFig=[];            else  hFig=cfg.figId; end
if ~isfield(cfg, 'olayThresh'),       olayThresh=[];          else  olayThresh = cfg.olayThresh; end
if ~isfield(cfg, 'figId'),         hFig=[];              else  hFig=cfg.figId; end
if ~isfield(cfg, 'fsurfSubDir'),   fsDir=[];             else fsDir=cfg.fsurfSubDir; end
if ~isfield(cfg, 'elecCoord'),      elecCoord='yes';      else  elecCoord = cfg.elecCoord;       end
if ~isfield(cfg, 'elecSize'),       elecSize=8;          else  elecSize = cfg.elecSize;      end
if ~isfield(cfg, 'elecColors'),     elecColors=[];        else  elecColors = cfg.elecColors;        end
if ~isfield(cfg, 'elecColorScale'),   elecColorScale='absmax';   else elecColorScale=cfg.elecColorScale; end
if ~isfield(cfg, 'olayColorScale'),   olayColorScale='absmax';   else olayColorScale=cfg.olayColorScale; end
if ~isfield(cfg, 'elecUnits'),     elecUnits=[];   else elecUnits=cfg.elecUnits; end
if ~isfield(cfg, 'olayUnits'),      olayUnits=[];         else olayUnits=cfg.olayUnits; end 
if ~isfield(cfg, 'showLabels'),         showLabels='y';            else  showLabels=cfg.showLabels; end
if ~isfield(cfg, 'elecCbar'),     elecCbar=[];   else elecCbar=cfg.elecCbar; end
if ~isfield(cfg, 'olayCbar'),     olayCbar=[];   else elecCbar=cfg.olayCbar; end
if ~isfield(cfg, 'verbLevel'),     verbLevel=0;        else  verbLevel = cfg.verbLevel;        end
if ~isfield(cfg, 'pialOverlay'),    pialOverlay=[];        else pialOverlay=cfg.pialOverlay; end 

if isempty(fsDir)
    fsDir=getFsurfSubDir();
end

clear global elecCbarMin elecCbarMax olayCbarMin olayCbarMax cort;

% Optional electrode color bar variables
if ~isempty(elecColors),
    if isempty(elecCbar)
        elecCbar='y';
    end
end
elecCmapName=[];
if isnumeric(elecColorScale)
    elecUsedLimits=elecColorScale;
else
    elecUsedLimits=[];
end

% Optional pial overlay color bar variables
olayCmapName=[];
olayUsedLimits=[];
if ~isempty(pialOverlay),
    if isempty(olayCbar)
        olayCbar='y';
    end
    if length(pialOverlay)~=2
        error('When you use the "omni" view option and "pialOverlay," pialOverlay needs two filenanes (cfg.pialOverlay{1}=left hem, cfg.pialOverlay{2}=right hem).');
    end
    % Load surf files to get color scale limits
    for a=1:2,
        if ~exist(pialOverlay{a},'file')
            error('File not found: %s',pialOverlay{a});
        end
        dot_id=find(pialOverlay{a}=='.');
        extnsn=pialOverlay{a}(dot_id+1:end);
        if strcmpi(extnsn,'mat')
            load(pialOverlay{a});
        else
            mgh = MRIread(pialOverlay{a});
        end
        switch lower(olayColorScale)
            case 'absmax'
                abs_mx(a)=max(abs(mgh.vol));
            case 'justpos'
                func_mx(a)=max(mgh.vol);
                olayCmapName='autumn';
            case 'justneg'
                func_mn(a)=min(mgh.vol);
                olayCmapName='winter';
            case 'minmax'
                func_mn(a)=min(mgh.vol);
                func_mx(a)=max(mgh.vol);
            otherwise
                %'nominal',
                error('Invalid value of cfg.olayColorScale');
        end
    end
        
    switch lower(olayColorScale)
        case 'absmax'
            olayUsedLimits=[-1 1]*max(abs_mx);
        case 'justpos'
            olayUsedLimits=[olayThresh max(func_mx)];
        case 'justneg'
            olayUsedLimits=[min(func_mn) olayThresh];
        case 'minmax'
            olayUsedLimits=[min(func_mn) max(func_mx)];
    end
end

% Create figure
if isempty(hFig),
    hFig=figure; clf;
else
    figure(hFig); clf;
end
set(hFig,'MenuBar','none','position',[100 190 1000 600],'paperpositionmode','auto');

% Figure out which hemisphere has electrodes
if isnumeric(elecCoord),
    leftCoverage=sum(elecCoord(:,4))>0;
    rightCoverage=sum(~elecCoord(:,4))>0;
else
    % Grab electrode info from subject dir
    elecInfoFname=fullfile(fsDir,fsSub,'elec_recon',[fsSub '.electrodeNames']);
    elecInfo=csv2Cell(elecInfoFname,' ',2);
    leftCoverage=~isempty(findStrInCell('L',elecInfo(:,3)));
    rightCoverage=~isempty(findStrInCell('R',elecInfo(:,3)));
end

% Loop over hemispheres
for h=1:2,
    for v=1:6,
        ax_loc=[0 0 0 0];
        if h==1,
            bview='l';
        else
            bview='r';
        end
        if v==2,
            bview=[bview 'm'];
        elseif v==3,
            bview=[bview 'f'];
        elseif v==4,
            bview=[bview 'o'];
        elseif v==5,
            bview=[bview 'sv'];
        elseif v==6,
            bview=[bview 'iv'];
        end
        switch (h-1)*6+v,
            case 1 %LH lateral
                ax_loc=[0 .67 .4 .3];
            case 2 %LH medial
                ax_loc=[0 .34 .4 .3];
            case 3 %LH frontal
                ax_loc=[.155 .02 .2 .3];
            case 4 %LH occiptal
                ax_loc=[1-.15-.2 .02 .2 .3];
            case 5 %LH superior
                ax_loc=[1-.455-.2 .55 .2 .4];
            case 6 %LH inferior
                ax_loc=[1-.455-.2 .14 .2 .4];
                
            case 7 %RH lateral
                ax_loc=[1-.4 .67 .4 .3];
            case 8 %RH medial
                ax_loc=[1-.4 .34 .4 .3];
            case 9 %RH frontal
                ax_loc=[.045 .02 .2 .3];
            case 10 %RH occipital
                ax_loc=[1-.035-.2 .02 .2 .3];
            case 11 %RH superior
                ax_loc=[.455 .55 .2 .4];
            case 12 %RH inferior
                ax_loc=[.455 .14 .2 .4];
        end
        hAx=axes('position',ax_loc);
        sub_cfg=cfg;
        sub_cfg.view=bview;
        
        sub_cfg.title=[];
        if bview(1)=='l'
            if ~leftCoverage || (ischar(elecCoord) && universalNo(elecCoord)), 
                sub_cfg.elecCoord='n';
            else
                sub_cfg.elecCoord=elecCoord;
                if ~isfield('elecSize',sub_cfg)
                    sub_cfg.elecSize=6;
                end
                sub_cfg.showLabels=showLabels;
            end
        else
            if ~rightCoverage || (ischar(elecCoord) && universalNo(elecCoord)),
                sub_cfg.elecCoord='n';
            else
                sub_cfg.elecCoord=elecCoord;
                if ~isfield('elecSize',sub_cfg)
                    sub_cfg.elecSize=6;
                end
                sub_cfg.showLabels=showLabels;
            end
        end
        
        sub_cfg.figId=hFig;
        sub_cfg.axis=hAx;
        sub_cfg.verbLevel=verbLevel;
        if ~isempty(pialOverlay),
            sub_cfg.pialOverlay=pialOverlay{h};
        end
        sub_cfg.clearFig='n';
        sub_cfg.elecCbar='n';
        sub_cfg.olayCbar='n';
        sub_cfg.olayColorScale=olayUsedLimits;
        if v==6
            sub_cfg.clearGlobal=1; %last view for this hem, clear overlay data from global memory
        else
            sub_cfg.clearGlobal=0;
        end
        sub_cfg_out=plotPialSurf(fsSub,sub_cfg);
        
        % Get electrode colormap limits
        
        if isempty(elecUsedLimits)
            if isfield(sub_cfg_out,'elecCbarLimits')
                elecUsedLimits=sub_cfg_out.elecCbarLimits;
            end
        else
            if ~isempty(sub_cfg_out.elecCbarLimits)
                if elecUsedLimits(2)<sub_cfg_out.elecCbarLimits(2)
                    elecUsedLimits(2)=sub_cfg_out.elecCbarLimits(2);
                end
                if elecUsedLimits(1)>sub_cfg_out.elecCbarLimits(1)
                    elecUsedLimits(1)=sub_cfg_out.elecCbarLimits(1);
                end
            end
        end
        
        if isempty(elecCmapName) && isfield(sub_cfg_out,'elecCmapName')
            elecCmapName=sub_cfg_out.elecCmapName;
        end
    end
end


%% DRAW COLORBAR(S)
if universalYes(elecCbar) && universalYes(olayCbar),
    % Colorbar for electrodes
    pos=[.4 .09 .2 .01];
    cbarDGplus(pos,elecUsedLimits,elecCmapName,5,elecUnits,'right');

    % Colorbar for pial surface overlay (e.g., neuroimaging)
    pos=[.4 .04 .2 .01];
    cbarDGplus(pos,olayUsedLimits,olayCmapName,5,olayUnits,'right');
elseif universalYes(elecCbar),
    % Colorbar for electrodes
    pos=[.4 .06 .2 .03];
    cbarDGplus(pos,elecUsedLimits,elecCmapName,5,elecUnits);
elseif universalYes(olayCbar)
    % Colorbar for pial surface overlay (e.g., neuroimaging)
    pos=[.4 .06 .2 .03];
    cbarDGplus(pos,olayUsedLimits,olayCmapName,5,olayUnits);
end

% Title
if isfield(cfg,'title')
    if ~isempty(cfg.title)
        % Overall Fig Title
        ht=textsc2014(cfg.title,'title');
        set(ht,'fontweight','bold','fontsize',20,'position',[0.5 0.975]);
    end
end
drawnow;


%% subfunction plotPialHemi
function sub_cfg_out=plotPialHemi(fsSub,cfg)

if ~isfield(cfg, 'usemask'),       usemask=[];          else usemask=cfg.usemask; end
if ~isfield(cfg, 'figId'),         hFig=[];            else  hFig=cfg.figId; end
if ~isfield(cfg, 'fsurfSubDir'),   fsDir=[];             else fsDir=cfg.fsurfSubDir; end
if ~isfield(cfg, 'elecCoord'),      elecCoord= 'yes';      else  elecCoord = cfg.elecCoord;       end
if ~isfield(cfg, 'elecSize'),       elecSize = 8;          else  elecSize = cfg.elecSize;      end
if ~isfield(cfg, 'elecColors'),     elecColors= [];        else  elecColors = cfg.elecColors;        end
if ~isfield(cfg, 'elecColorScale'),   elecColorScale=[];   else elecColorScale=cfg.elecColorScale; end
if ~isfield(cfg, 'olayColorScale'),   olayColorScale=[];   else olayColorScale=cfg.olayColorScale; end
if ~isfield(cfg, 'elecUnits'),     elecUnits=[];   else elecUnits=cfg.elecUnits; end
if ~isfield(cfg, 'olayUnits'),      olayUnits=[];         else olayUnits=cfg.olayUnits; end 
if ~isfield(cfg, 'elecCbar'),     elecCbar=[];   else elecCbar=cfg.elecCbar; end
if ~isfield(cfg, 'olayCbar'),     olayCbar=[];   else elecCbar=cfg.olayCbar; end
if ~isfield(cfg, 'verbLevel'),     verbLevel=0;        else  verbLevel = cfg.verbLevel;        end
if ~isfield(cfg, 'pialOverlay'),    pialOverlay=[];        else pialOverlay=cfg.pialOverlay; end 

if ~isempty(elecColors),
    if isempty(elecCbar)
        elecCbar='y';
    end
end
elecCmapName=[];
if ~isempty(pialOverlay),
    if isempty(olayCbar)
        olayCbar='y';
    end
end
olayCmapName=[];

clear global elecCbarMin elecCbarMax olayCbarMin olayCbarMax cort;

hem=cfg.view(1);

if isempty(hFig),
    hFig=figure; clf;
else
    figure(hFig); clf;
end
set(hFig,'MenuBar','none','position',[100 190 800 500],'paperpositionmode','auto');

%% Viewpoints
elecUsedLimits=[];
olayUsedLimits=[];
for v=1:6, %will run 1-6
    ax_loc=[0 0 0 0];
    bview=hem;
    if v==2,
        bview=[bview 'm'];
    elseif v==3,
        if bview(1)=='r',
            bview=[bview 'f'];
        else
            bview=[bview 'o'];
        end
    elseif v==4,
        if bview(1)=='r'
            bview=[bview 'o'];
        else
            bview=[bview 'f'];
        end
    elseif v==5,
        bview=[bview 's'];
    elseif v==6,
        bview=[bview 'i'];
    end
    switch v,
        case 1 % lateral
            ax_loc=[-.03 .52 .55 .45];
        case 2 % medial
            ax_loc=[-.03 .05 .55 .45];
        case 3 % occipital
            ax_loc=[.305 .55 .55 .41];
            %ax_loc=[.29 .55 .55 .41];
        case 4 % frontal
            ax_loc=[.56 .55 .44 .41];
            %ax_loc=[.56 .55 .44 .41];
        case 5 % superior
            ax_loc=[.41 .05 .54 .23];
        case 6 % inferior
            ax_loc=[.41 .31 .54 .23];
    end
    hAx=axes('position',ax_loc);
    
    sub_cfg=cfg;
    sub_cfg.view=bview;
    sub_cfg.title=[];
    sub_cfg.figId=hFig;
    sub_cfg.axis=hAx;
    sub_cfg.verbLevel=verbLevel;
    sub_cfg.clearFig='n';
    sub_cfg.elecCbar='n';
    sub_cfg.olayCbar='n';
    if v==6
        sub_cfg.clearGlobal=1; %last view, clear plotPialSurf from global memory
    else
        sub_cfg.clearGlobal=0;
    end
    sub_cfg_out=plotPialSurf(fsSub,sub_cfg);
    
    % Get electrode colormap limits
    if v==1
        if universalYes(elecCbar)
            elecUsedLimits=sub_cfg_out.elecCbarLimits;
            elecCmapName=sub_cfg_out.elecCmapName;
        end
    end
    if v==1
        if universalYes(olayCbar)
            olayUsedLimits=sub_cfg_out.olayCbarLimits;
            olayCmapName=sub_cfg_out.olayCmapName;
        end
    end
end


%% DRAW COLORBAR(S)
if universalYes(elecCbar) && universalYes(olayCbar),    
    % Colorbar for electrodes
    pos=[.88 .1 .01 .8];
    cbarDGplus(pos,elecUsedLimits,elecCmapName,5,elecUnits);
    
    % Colorbar for pial surface overlay (e.g., neuroimaging)
    pos=[.94 .1 .01 .8];
    cbarDGplus(pos,olayUsedLimits,olayCmapName,5,olayUnits);
elseif universalYes(elecCbar),
    % Colorbar for electrodes
    pos=[.90 .1 .03 .8];
    cbarDGplus(pos,elecUsedLimits,elecCmapName,5,elecUnits);
elseif universalYes(olayCbar)
    % Colorbar for pial surface overlay (e.g., neuroimaging)
    pos=[.90 .1 .03 .8];
    cbarDGplus(pos,olayUsedLimits,olayCmapName,5,olayUnits);
end

% Title
if isfield(cfg,'title')
    if ~isempty(cfg.title)
        % Overall Fig Title
        ht=textsc2014(cfg.title,'title');
        set(ht,'fontweight','bold','fontsize',20,'position',[0.5 0.975]);
    end
end
drawnow;

%subfunction verbReport
function verbReport(report,verbtag,VERBLEVEL)
% verbReport() - Outputs messages if they exceed a desired level of importance.
%
% Usage:
%  >> verbReport(report,verbtag,VERBLEVEL)
%
% Inputs:
%   report    = a string that is some message to the user
%   verbtag   = an intger specifiying the importance of report
%   VERBLEVEL = an integer specifiying a threshold of importance
%               for displaying reports. If verbtag is less than VERBLEVEL, the
%               report will be displayed..
%
% Author: Tom Urbach
% Kutaslab

if nargin<3
    tmpVERBLEVEL = 3;
elseif isempty(VERBLEVEL)
    tmpVERBLEVEL = 3;
else
    tmpVERBLEVEL = VERBLEVEL;
end;

if verbtag <= tmpVERBLEVEL
    if ischar(report)
        fprintf('%s\n',report);
    else
        fprintf('%d\n',report);
    end;
end;
