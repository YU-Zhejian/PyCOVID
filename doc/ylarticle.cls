%% Based on Stylish Article Version 2.1 (1/10/15) from http://www.LaTeXTemplates.com
%%
%% Original author:
%% Mathias Legrand (legrand.mathias@gmail.com)
%% With extensive modifications by:
%% Vel (vel@latextemplates.com)
%%
%% With extensive modifications by:
%% YU Zhejian (Zhejian.19@intl.zju.edu.cn)
%%
%% License:
%% CC BY-NC-SA 3.0 (http://creativecommons.org/licenses/by-nc-sa/3.0/)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PREPARATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ylarticle}[2020-08-04 v1.3 YLArticle]
\RequirePackage{ifthen}
\RequirePackage{calc}
\AtEndOfClass{\RequirePackage{microtype}}

\newif\if@web \@webfalse
\DeclareOption{web}{\@webtrue\renewcommand\familydefault{\sfdefault}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions*

\LoadClass{article}

\RequirePackage{ifpdf}      % Needed to pick between latex and pdflatex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FONTS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{times}      % Loads the Times-Roman Fonts
\RequirePackage{mathptmx}   % Loads the Times-Roman Math Fonts

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VARIOUS USEFUL PACKAGES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[utf8]{inputenc}
\RequirePackage{amsmath,amsfonts,amssymb}
\RequirePackage{graphicx,xcolor}
\RequirePackage{booktabs}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MARGINS	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[left=2cm,right=2cm,top=2.25cm,bottom=2.25cm,headheight=11pt,letterpaper]{geometry}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FIGURES AND TABLES CAPTIONS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[labelfont={bf,small},labelsep=period,justification=raggedright]{caption}
\setlength{\abovecaptionskip}{0pt}
\setlength{\belowcaptionskip}{0pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% PAGE HEADER
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{url}
\RequirePackage{fancyhdr}  % Needed to define custom headers/footers
\RequirePackage{lastpage}  % Number of pages in the document
\pagestyle{fancy}          % Enables the custom headers/footers
%% Headers
\lhead{\small\bfseries \@Access\\\@Type}
\chead{}
\rhead{\small\bfseries\@PaperTitle\  --- \thepage}
%% Footers
\lfoot{}
\cfoot{}
\rfoot{}
\renewcommand{\headrulewidth}{0pt}% % No header rule
\renewcommand{\footrulewidth}{0pt}% % No footer rule

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SECTION/SUBSECTION/PARAGRAPH SET-UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[explicit]{titlesec}
\if@web
	\titleformat{\section}{\color{color1}\large\bfseries}{}{0em}{\colorbox{color2!10}{\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\centering\arabic{section}. #1}}}[]
	\titleformat{name=\section,numberless}{\color{color1}\large\bfseries}{}{0em}{\colorbox{color2!10}{\parbox{\dimexpr\linewidth-2\fboxsep\relax}{\centering#1}}}[]
	\titleformat{\subsection}{\color{color1}\bfseries}{\thesubsection}{0.5em}{#1}[]
\else
	\titleformat{\section}{\large\scshape}{}{0em}{\centering\arabic{section}. #1}[]
	\titleformat{name=\section,numberless}{\large\scshape}{}{0em}{\centering#1}[]
	\titleformat{\subsection}{\bfseries\itshape}{\thesubsection}{0.5em}{#1}[]
\fi 
\titleformat{\subsubsection}{\small\bfseries}{\thesubsubsection}{0.5em}{#1}[]
\titleformat{\paragraph}[runin]{\small\bfseries}{}{0em}{#1} 
\titlespacing*{\section}{0pc}{3ex \@plus4pt \@minus3pt}{5pt}
\titlespacing*{\subsection}{0pc}{2.5ex \@plus3pt \@minus2pt}{0pt}
\titlespacing*{\subsubsection}{0pc}{2ex \@plus2.5pt \@minus1.5pt}{0pt}
\titlespacing*{\paragraph}{0pc}{1.5ex \@plus2pt \@minus1pt}{10pt}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TABLEOFCONTENTS SET-UP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newlength{\tocsep}
\setlength\tocsep{1.5pc} % Sets the indentation of the sections in the table of contents
\setcounter{tocdepth}{3} % Three levels in the table of contents section: sections, subsections and subsubsections
\usepackage{titletoc}
\contentsmargin{0cm}
\if@web
	\titlecontents{section}[\tocsep]{\addvspace{4pt}\small\bfseries}{\contentslabel[\thecontentslabel]{\tocsep}}{} {\hfill\thecontentspage}[]
	\titlecontents{subsection}[\tocsep]{\addvspace{2pt}}{\contentslabel[\thecontentslabel]{\tocsep}}{}{\ \titlerule*[.5pc]{.}\ \thecontentspage}[]
	\titlecontents*{subsubsection}[\tocsep]{\footnotesize}{}{}{}[\ \textbullet\ ]
\else
	\titlecontents{section}[\tocsep]{\addvspace{4pt}\small\bfseries}{\contentslabel[\thecontentslabel]{\tocsep}}{} {\hfill\thecontentspage}[]
	\titlecontents{subsection}[\tocsep]{\addvspace{2pt}}{\contentslabel[\thecontentslabel]{\tocsep}}{}{\ \titlerule*[.5pc]{.}\ \thecontentspage}[]
	\titlecontents*{subsubsection}[\tocsep]{\footnotesize}{}{}{}[\ \textbullet\ ]
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MULTIPLE AUTHOR SET
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

\newcount\@authcnt
\newcount\@tmpcnt\@tmpcnt\z@

\def\@affiliation{%
\ifnum\@tmpcnt<\@authcnt
	\global\advance\@tmpcnt1
	\raggedright \csname @auth\romannumeral\the\@tmpcnt\endcsname\hfill\\%
	\let\next\@affiliation \vskip1pt
\else
	\let\next\relax
\fi
\next}
\newcommand{\affiliation}[1]{\global\advance\@authcnt1\expandafter\gdef\csname @auth\romannumeral\the\@authcnt\endcsname{#1}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LIST CONTROL
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

\RequirePackage{enumitem}
\setlist{nolistsep}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% TITLEPAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

\newcommand{\PaperTitle}[1]{\def\@PaperTitle{#1}}
\newcommand{\Authors}[1]{\def\@Authors{#1}}
\newcommand{\JournalInfo}[1]{\def\@JournalInfo{#1}}
\newcommand{\Type}[1]{\def\@Type{#1}}
\newcommand{\Access}[1]{\def\@Access{#1}}
\newcommand{\Abstract}[1]{\def\@Abstract{#1}}
\newcommand{\Keywords}[1]{\def\@Keywords{#1}}
\newcommand{\Introduction}{\section*{Introduction}\addcontentsline{toc}{section}{Introduction}}
\newcommand{\keywordname}{Keywords}

\renewcommand{\@maketitle}{%
\if@web
	\twocolumn[{%
	\thispagestyle{empty}%
	\vskip-36pt%
	{\raggedleft\small\bfseries\@JournalInfo\\Copyright \copyright 2019-2020 Authors\par}%
	\vskip20pt%
	{\raggedright\Large\bfseries\@Type\par}
	{\raggedright\color{color1}\bfseries\fontsize{20}{25}\selectfont \@PaperTitle\par}%
	\vskip10pt%
	{\raggedright\color{color1}\fontsize{12}{16}\selectfont \@Authors\par}%
	\vskip18pt%
	\fcolorbox{color1}{white}{%
	\parbox{\textwidth-2\fboxsep-2\fboxrule}{
	\centering%
	\ifx\@Abstract\@empty\else
		\colorbox{color2!10}{
		\parbox{\textwidth-4\fboxsep-2\fboxrule}{%
		\ifx\@Keywords\@empty%
			\textbf{\abstractname}\\\@Abstract%
		\else%
			\textbf{\abstractname}\\\@Abstract\\[4pt]%
			\textbf{\keywordname}\\\@Keywords%
		\fi%
		}}
	\fi
	\vskip4pt%
	\begingroup%
	\raggedright\small%
	\footnotesize\@affiliation\par%
	\endgroup%%
	}}
	\vspace*{1cm}\par}]%
\else
	\twocolumn[{
	{\raggedleft\small\bfseries\@JournalInfo\\Copyright \copyright 2019-2020 Authors\\\@Type\\}%
	{\raggedright\itshape\fontsize{20}{30}\selectfont \@PaperTitle\par}%
	\vskip10pt%
	{\raggedright\fontsize{12}{16}\selectfont\textsc{\@Authors}\par\small\@affiliation\par}%
	\vspace*{1cm}\par}]
	\ifx\@Abstract\@empty\else
		{\noindent\bfseries\abstractname\itshape\space\@Abstract\par}
		\ifx\@Keywords\@empty\else
			{\noindent\textbf{\keywordname}\@Keywords\par}
		\fi
	\fi
\fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% REFERENCES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

\let\oldbibliography\thebibliography
\renewcommand{\thebibliography}[1]{\addcontentsline{toc}{section}{\refname}\oldbibliography{#1}\setlength\itemsep{0pt}}
\setlength{\columnsep}{0.5cm} % Distance between the two columns of text
\setlength{\fboxrule}{0.75pt} % Width of the border around the abstract
\definecolor{color1}{RGB}{0,0,90} % Color of the article title and sections
\definecolor{color2}{RGB}{0,20,20} % Color of the boxes behind the abstract and headings
\renewcommand{\verbatim@font}{\ttfamily\small}
\RequirePackage[none]{hyphenat}

\endinput
