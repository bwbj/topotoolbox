function c = chitransform(S,A,varargin)

% Coordinate transformation using the integral approach
%
% Syntax
%
%     c = chitransform(S,A)
%     c = chitransform(S,A,pn,pv,...)
%
% Description
%
%     chitransform transforms the horizontal spatial coordinates of a river
%     longitudinal profile using an integration in upstream direction of
%     drainage area (chi, see Perron and Royden, 2013).
%
% Input arguments
%
%     S     STREAMobj
%     A     upslope area as returned by the function flowacc
%     
% Parameter name/value pairs
%
%     'a0'     reference area (default=1e6)
%     'mn'     mn-ratio (default=0.45)
%     'plot'   0 : no plot (default)
%              1 : chimap
%
% Output argument
%
%     c     node attribute list (nal) of chi values
%
% Example
%
%
% See also: chiplot
%
% References:
%     
%     Perron, J. & Royden, L. (2013): An integral approach to bedrock river 
%     profile analysis. Earth Surface Processes and Landforms, 38, 570-576.
%     [DOI: 10.1002/esp.3302]
%     
% Author: Wolfgang Schwanghart (w.schwanghart[at]geo.uni-potsdam.de)
% Date: 29. December, 2015


% Parse Inputs
p = inputParser;         
p.FunctionName = 'chitransform';
addRequired(p,'S',@(x) isa(x,'STREAMobj'));
addRequired(p,'A', @(x) isa(x,'GRIDobj') || isnal(S,x));

addParamValue(p,'mn',0.45,@(x) isscalar(x) || isempty(x));
addParamValue(p,'a0',1e6,@(x) isscalar(x) && isnumeric(x));
addParamValue(p,'plot',false);

parse(p,S,A,varargin{:});

% get node attribute list with elevation values
if isa(A,'GRIDobj')
    validatealignment(S,A);
    a = getnal(S,A);
elseif isnal(S,A);
    a = A;
else
    error('Imcompatible format of second input argument')
end


a = ((p.Results.a0) ./a).^p.Results.mn;
c = cumtrapz(S,a);

if p.Results.plot
    plotc(S,c)
end

