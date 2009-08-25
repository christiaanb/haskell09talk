%%
%% caes_presentation.cls
%%
%% Copyright (C) 2008 CAES (http://caes.ewi.utwente.nl)
%%
%% Authors         : Pascal Wolkotte
%% Created On      : March 13 2008
%%
%% $Author: bakkerv $
%% $Date: 2008-03-25 10:31:52 +0100 (Tue, 25 Mar 2008) $
%% $Revision: 45 $
%% $HeadURL: https://ewi630/svn/general/templates/caes/trunk/caes_presentation.cls $
%% 

% -- BASIC SETTINGS --
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{caes_presentation}[2008/03/13 Standard document class for presentations of the CAES group]                       % Name of this class-file

\DeclareOption{empty}{\PassOptionsToPackage{\CurrentOption}{beamerthemecaes}}
\DeclareOption{powerpoint}{\PassOptionsToPackage{\CurrentOption}{beamerthemecaes}}
\DeclareOption{chameleonA}{\PassOptionsToPackage{\CurrentOption}{beamerthemecaes}}
\DeclareOption{chameleonB}{\PassOptionsToPackage{\CurrentOption}{beamerthemecaes}}
\DeclareOption{energy}{\PassOptionsToPackage{\CurrentOption}{beamerthemecaes}}


\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
%\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass[t,12pt,hyperref={unicode},notes=show]{beamer}

\pdfpageattr {/Group << /S /Transparency /I true /CS /DeviceRGB>>} %Solves colorshift due to transparency in figures
\RequirePackage{tikz}
\RequirePackage{url}

\usetheme{caes}
\date{\today}
\institute[University of Twente]{\raggedleft
Computer Architecture for Embedded Systems (CAES) group\\
Faculty of Electrical Engineering, Mathematics and Computer Science\\
University of Twente\\
\url{http://caes.ewi.utwente.nl} \hfill Enschede, The Netherlands}

\makeatletter
\def\caestitle{\maketitle}
\def\maketitle{ {\setbeamertemplate{navigation symbols}[none]\ifbeamer@inframe\titlepage\else\frame[b]{\titlepage}\fi} }
\makeatother

%\RequirePackage{caes}


% -- END OF CLASS --
