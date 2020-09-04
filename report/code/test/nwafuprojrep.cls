%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% nwafuprojrep - 西北农林科技大学科技类课程设计实习报告模板
%% nangeng@nwafu.edu.cn
%% 2020年6月
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}[2017/04/15]
\ProvidesClass{nwafuprojrep}[2020/07/01 v1.1.0 LaTeX cls for NWAFU Project Report]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 摘录自zepinglee的
%% https://github.com/ustctug/ustcthesis
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 报错和警告()
\newcommand\nwafu@error[1]{%
  \ClassError{nwafuprojrep}{#1}{}%
}
\newcommand\nwafu@warning[1]{%
  \ClassWarning{nwafuprojrep}{#1}%
}

% 检查 \LaTeXe{} kernel 版本
\@ifl@t@r\fmtversion{2017/04/15}{}{
  \nwafu@error{%
    TeX Live 2017 or later version is required to compile this document%
  }
}

% 检查编译引擎，要求使用 XeLaTeX。
\RequirePackage{iftex}
\ifXeTeX\else
  \nwafu@error{XeLaTeX is required to compile this document}
\fi


% \subsection{处理选项}

\RequirePackage{kvdefinekeys}
\RequirePackage{kvsetkeys}
\RequirePackage{kvoptions}

% 提供一个 \cs{nwafuset} 命令支持 \emph{key-value} 的方式来设置。
\newcommand\nwafuset{%
  \kvsetkeys{nwafu}%
}

% 同时用 \emph{key-value} 的方式来定义这些接口：
% \begin{latex}
%   \nwafu@define@key{
%     <key> = {
%       name = <name>,
%       choices = {
%         <choice1>,
%         <choice2>,
%       },
%       default = <default>,
%       code = <code>,
%     },
%   }
% \end{latex}

% 其中 |choices| 设置允许使用的值，默认为第一个（或者 \meta{default}）；
% \meta{code} 是相应的内容被设置时执行的代码。

\newcommand\nwafu@define@key[1]{%
  \kvsetkeys{nwafu@key}{#1}%
}
\kv@set@family@handler{nwafu@key}{%
%
% \cs{nwafuset} 会将 \meta{value} 存到 \cs{nwafu@\meta{key}}，
% 但是宏的名字包含 “-” 这样的特殊字符时不方便直接调用，比如 |key = math-style|，
% 这时可以用 |name| 设置 \meta{key} 的别称，比如 |key = math@style|，
% 这样就可以通过 \cs{nwafu@math@style} 来引用。
% |default| 是定义该 \meta{key} 时默认的值，缺省为空。
%
  \@namedef{nwafu@#1@@name}{#1}%
  \def\nwafu@@default{}%
  \def\nwafu@@choices{}%
  \kv@define@key{nwafu@value}{name}{%
    \@namedef{nwafu@#1@@name}{##1}%
  }%
  \kv@define@key{nwafu@value}{code}{%
    \@namedef{nwafu@#1@@code}{##1}%
  }%
  %
  % 由于在定义接口时，\cs{nwafu@\meta{key}@@code} 不一定有定义，
  % 而且在文档类/宏包中还有可能对该 |key| 的 |code| 进行添加。
  % 所以 \cs{nwafu@\meta{key}@@code} 会检查如果在定义文档类/宏包时则推迟执行，否则立即执行。
  %
  \@namedef{nwafu@#1@@check}{}%
  \@namedef{nwafu@#1@@code}{}%
  \@namedef{nwafu@#1@@hook}{%
    \@nameuse{nwafu@#1@@code}%
  }%
  %
  % 保存下 |choices = {}| 定义的内容，在定义 \cs{nwafu@\meta{name}} 后再执行。
  %
  \kv@define@key{nwafu@value}{choices}{%
    \def\nwafu@@choices{##1}%
    \@namedef{nwafu@#1@@reset}{}%
    %
    % \cs{nwafu@\meta{key}@check} 检查 |value| 是否有效，
    % 并设置 \cs{ifnwafu@\meta{name}@\meta{value}}。
    %
    \@namedef{nwafu@#1@@check}{%
      \@ifundefined{%
        ifnwafu@\@nameuse{nwafu@#1@@name}@\@nameuse{nwafu@\@nameuse{nwafu@#1@@name}}%
      }{%
        \nwafu@error{Invalid value "#1 = \@nameuse{nwafu@\@nameuse{nwafu@#1@@name}}"}%
      }%
      \@nameuse{nwafu@#1@@reset}%
      \@nameuse{nwafu@\@nameuse{nwafu@#1@@name}@\@nameuse{nwafu@\@nameuse{nwafu@#1@@name}}true}%
    }%
  }%
  \kv@define@key{nwafu@value}{default}{%
    \def\nwafu@@default{##1}%
  }%
  \kvsetkeys{nwafu@value}{#2}%
  \@namedef{nwafu@\@nameuse{nwafu@#1@@name}}{}%
  %
  % 第一个 \meta{choice} 设为 \meta{default}，
  % 并且对每个 \meta{choice} 定义 \cs{ifnwafu@\meta{name}@\meta{choice}}。
  %
  \kv@set@family@handler{nwafu@choice}{%
    \ifx\nwafu@@default\@empty
      \def\nwafu@@default{##1}%
    \fi
    \expandafter\newif\csname ifnwafu@\@nameuse{nwafu@#1@@name}@##1\endcsname
    \expandafter\g@addto@macro\csname nwafu@#1@@reset\endcsname{%
      \@nameuse{nwafu@\@nameuse{nwafu@#1@@name}@##1false}%
    }%
  }%
  \kvsetkeys@expandafter{nwafu@choice}{\nwafu@@choices}%
  %
  % 将 \meta{default} 赋值到 \cs{nwafu@\meta{name}}，如果非空则执行相应的代码。
  %
  \expandafter\let\csname nwafu@\@nameuse{nwafu@#1@@name}\endcsname\nwafu@@default
  \expandafter\ifx\csname nwafu@\@nameuse{nwafu@#1@@name}\endcsname\@empty\else
    \@nameuse{nwafu@#1@@check}%
    \@nameuse{nwafu@#1@@hook}%
  \fi
  %
  % 定义 \cs{nwafuset} 接口。
  %
  \kv@define@key{nwafu}{#1}{%
    \@namedef{nwafu@\@nameuse{nwafu@#1@@name}}{##1}%
    \@nameuse{nwafu@#1@@check}%
    \@nameuse{nwafu@#1@@hook}%
  }%
}

% 定义接口向 |key| 添加 |code|：

\newcommand\nwafu@option@hook[2]{%
  \expandafter\g@addto@macro\csname nwafu@#1@@code\endcsname{#2}%
}

\nwafu@define@key{  
  fontset = {
    choices = {
      windows,
      mac,
      ubuntu,
      fandol,
      none,
    },
    default = none,
  },
  system = {
    choices = {
      mac,
      unix,
      windows,
      auto,
    },
    default = auto,
  },
  font = {
    choices = {
      times,
      termes,
      xits,
      libertinus,
      lm,
      auto,
      none,
    },
    default = auto,
  },
  cjk-font = {
    name = cjk@font,
    choices = {
      windows,
      mac,
      noto,
      fandol,
      auto,
      none,
    },
    default = auto,
  },
  math-font = {
    name = math@font,
    choices = {
      xits,
      stix,
      libertinus,
      lm,
      none,
    },
    default = xits,
  },
}

% 使用 \pkg{kvoptions} 提供的 key-value 接口，
\SetupKeyvalOptions{
  family  = nwafu,
  prefix  = nwafu@,
  setkeys = \kvsetkeys,
}

% 载入 \cls{ctexart}。
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessKeyvalOptions*

\PassOptionsToPackage{quiet}{fontspec}

% 载入 \cls{ctexart} 文档类，注意要求为 2.4.9 或更高的版本。
\LoadClass[scheme=plain, zihao=-4, fontset=none]{ctexart}[2017/04/01]

% 建议在模板开始处载入全部宏包，不要轻易改变加载顺序。
% \pkg{hyperref} 一般在最后加载。
\RequirePackage{etoolbox}% 为命令和环境打补丁的宏包
% \RequirePackage{amsmath}
% \RequirePackage{fontspec}[2017/03/31]
\RequirePackage{unicode-math}
\RequirePackage[driver=xetex]{geometry}
% \RequirePackage{graphicx}
\RequirePackage{fancyhdr}
% \RequirePackage{color}
\RequirePackage{titletoc}
\RequirePackage{caption}
% \RequirePackage[perpage]{footmisc}
\RequirePackage{url}
% \RequirePackage{calc}
\RequirePackage{enumitem}% 调整列表格式
% \RequirePackage{booktabs}% 三线表格
% \RequirePackage{longtable}% 跨页长表格
% \RequirePackage{multirow,makecell}% 表格行合并，单元格处理
% \RequirePackage{circledsteps}% 带圈数字
%\RequirePackage{titletoc}
% \RequirePackage{fancyhdr}
% \RequirePackage{ulem}% 下划线
% \RequirePackage[backend=biber,
%                 style=gb7714-2015,
%                 maxbibnames=99,% 著录所有作者
%                 maxcitenames=2,% 引用标注中最多显示2个作者
%                 mincitenames=1,% 3个及3个以上的作者截断为1个作者
%                 gbpub=false,
%                 gbnamefmt=familyahead,
%                 url=false,
%                 doi=false,
%                 isbn=false,
%                 gbfieldtype=true, % 输出学位论文标识
%                 ]{biblatex} % 参考文献
                
% 对冲突的宏包报错。
\RequirePackage{filehook}
\newcommand\nwafu@package@conflict[2]{
  \AtBeginOfPackageFile*{#2}{
    \nwafu@error{The "#2" package is incompatible with required "#1"}
  }
}
\nwafu@package@conflict{unicode-math}{amscd}
\nwafu@package@conflict{unicode-math}{amsfonts}
\nwafu@package@conflict{unicode-math}{amssymb}
\nwafu@package@conflict{unicode-math}{bbm}
\nwafu@package@conflict{unicode-math}{bm}
\nwafu@package@conflict{unicode-math}{eucal}
\nwafu@package@conflict{unicode-math}{eufrak}
\nwafu@package@conflict{unicode-math}{mathrsfs}
                

% \subsection{字体}
% 处理 \opt{fontset}
\ifnwafu@fontset@mac
  \nwafuset{
    font     = times,
    cjk-font = mac,
  }
\else
  \ifnwafu@fontset@windows
    \nwafuset{
      font     = times,
      cjk-font = windows,
    }
  \else
    \ifnwafu@fontset@fandol
      \nwafuset{
        font     = termes,
        cjk-font = fandol,
      }
    \else
      \ifnwafu@fontset@ubuntu
        \nwafuset{
          font     = termes,
          cjk-font = noto,
        }
      \fi
    \fi
  \fi
\fi

% 检测系统
\ifnwafu@system@auto
  \IfFileExists{/System/Library/Fonts/Menlo.ttc}{
    \nwafuset{system = mac}
  }{
    \IfFileExists{/dev/null}{
      \IfFileExists{null:}{
        \nwafuset{system = windows}
      }{
        \nwafuset{system = unix}
      }
    }{
      \nwafuset{system = windows}
    }
  }
\fi

% XITS 字体于 2018-10-03 更改了字体的文件名，所以需要判断。
% 原文件名为 \file{xits-regular.otf}、\file{xits-math.otf} 等，
% 后改为 \file{XITS-Regular.otf}、\file{XITSMath-Regular.otf} 等。
\let\nwafu@font@family@xits\@empty
\newcommand\nwafu@set@xits@names{%
  \ifx\nwafu@font@family@xits\@empty
    \IfFontExistsTF{XITSMath-Regular.otf}{%
      \gdef\nwafu@font@family@xits{XITS}%
      \gdef\nwafu@font@style@xits@rm{Regular}%
      \gdef\nwafu@font@style@xits@bf{Bold}%
      \gdef\nwafu@font@style@xits@it{Italic}%
      \gdef\nwafu@font@style@xits@bfit{BoldItalic}%
      \gdef\nwafu@font@name@xits@math@rm{XITSMath-Regular}%
      \gdef\nwafu@font@name@xits@math@bf{XITSMath-Bold}%
    }{%
      \gdef\nwafu@font@family@xits{xits}%
      \gdef\nwafu@font@style@xits@rm{regular}%
      \gdef\nwafu@font@style@xits@bf{bold}%
      \gdef\nwafu@font@style@xits@it{italic}%
      \gdef\nwafu@font@style@xits@bfit{bolditalic}%
      \gdef\nwafu@font@name@xits@math@rm{xits-math}%
      \gdef\nwafu@font@name@xits@math@bf{xits-mathbold}%
    }%
  \fi
}

% Libertinus 字体同样。
\let\nwafu@font@family@libertinus\@empty
\newcommand\nwafu@set@libertinus@names{%
  \ifx\nwafu@font@family@libertinus\@empty
    \IfFontExistsTF{LibertinusSerif-Regular.otf}{%
      \gdef\nwafu@font@family@libertinus@serif{LibertinusSerif}%
      \gdef\nwafu@font@family@libertinus@sans{LibertinusSans}%
      \gdef\nwafu@font@name@libertinus@math{LibertinusMath-Regular}%
      \gdef\nwafu@font@style@libertinus@rm{Regular}%
      \gdef\nwafu@font@style@libertinus@bf{Bold}%
      \gdef\nwafu@font@style@libertinus@it{Italic}%
      \gdef\nwafu@font@style@libertinus@bfit{BoldItalic}%
    }{%
      \gdef\nwafu@font@family@libertinus@serif{libertinusserif}%
      \gdef\nwafu@font@family@libertinus@sans{libertinussans}%
      \gdef\nwafu@font@name@libertinus@math{libertinusmath-regular}%
      \gdef\nwafu@font@style@libertinus@rm{regular}%
      \gdef\nwafu@font@style@libertinus@bf{bold}%
      \gdef\nwafu@font@style@libertinus@it{italic}%
      \gdef\nwafu@font@style@libertinus@bfit{bolditalic}%
    }%
  \fi
}

% 不合理要求：西文字体使用 Times New Roman 和 Arial，
% 但是在 Linux 下没有这两个字体，所以使用它们的克隆版 TeX Gyre Termes 和
% TeX Gyre Heros。
\ifnwafu@font@auto
  \ifnwafu@system@unix
    \nwafuset{font=xits}
  \else
    \nwafuset{font=times}
  \fi
\fi
\newcommand\nwafu@load@font@times{%
  \setmainfont{Times New Roman}%
  \setsansfont{Arial}%
  \ifnwafu@system@mac
    \setmonofont{Menlo}[Scale = MatchLowercase]%
  \else
    \setmonofont{Courier New}[Scale = MatchLowercase]%
  \fi
}
\newcommand\nwafu@load@font@termes{%
  \setmainfont{texgyretermes}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \nwafu@load@texgyre@sans@mono
}
\newcommand\nwafu@load@texgyre@sans@mono{%
  \setsansfont{texgyreheros}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
    Scale          = MatchLowercase,
  ]%
  \setmonofont{texgyrecursor}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
    Scale          = MatchLowercase,
  ]%
}
\newcommand\nwafu@load@font@xits{%
  \nwafu@set@xits@names
  \setmainfont{\nwafu@font@family@xits}[
    Extension      = .otf,
    UprightFont    = *-\nwafu@font@style@xits@rm,
    BoldFont       = *-\nwafu@font@style@xits@bf,
    ItalicFont     = *-\nwafu@font@style@xits@it,
    BoldItalicFont = *-\nwafu@font@style@xits@bfit,
  ]%
  \nwafu@load@texgyre@sans@mono
}
\newcommand\nwafu@load@font@libertinus{%
  \nwafu@set@libertinus@names
  \setmainfont{\nwafu@font@family@libertinus@serif}[
    Extension      = .otf,
    UprightFont    = *-\nwafu@font@style@libertinus@rm,
    BoldFont       = *-\nwafu@font@style@libertinus@bf,
    ItalicFont     = *-\nwafu@font@style@libertinus@it,
    BoldItalicFont = *-\nwafu@font@style@libertinus@bfit,
  ]%
  \setsansfont{\nwafu@font@family@libertinus@sans}[
    Extension      = .otf,
    UprightFont    = *-\nwafu@font@style@libertinus@rm,
    BoldFont       = *-\nwafu@font@style@libertinus@bf,
    ItalicFont     = *-\nwafu@font@style@libertinus@it,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}
\newcommand\nwafu@load@font@lm{%
  \setmainfont{lmroman10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-italic,
    BoldItalicFont = *-bolditalic,
  ]%
  \setsansfont{lmsans10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
  \setmonofont{lmmonolt10}[
    Extension      = .otf,
    UprightFont    = *-regular,
    BoldFont       = *-bold,
    ItalicFont     = *-oblique,
    BoldItalicFont = *-boldoblique,
  ]%
}
\newcommand\nwafu@load@font{%
  \@nameuse{nwafu@load@font@\nwafu@font}%
}
\nwafu@load@font
\nwafu@option@hook{font}{\nwafu@load@font}

% 中文字体
\ifnwafu@cjk@font@auto
  \ifnwafu@system@mac
    \nwafuset{cjk-font = mac}
  \else
    \ifnwafu@system@windows
      \nwafuset{cjk-font = windows}
    \else
      \IfFontExistsTF{Noto Serif CJK SC}{
        \nwafuset{cjk-font = noto}
      }{
        \nwafuset{cjk-font = fandol}
      }
    \fi
  \fi
\fi
\newcommand\nwafu@load@cjk@font@windows{%
  \xeCJKsetup{EmboldenFactor=2}
  \setCJKmainfont{SimSun}[
    AutoFakeBold = true,
    ItalicFont   = KaiTi,
  ]%
  \setCJKsansfont{SimHei}[AutoFakeBold]%
  \setCJKmonofont{FangSong}%
  \setCJKfamilyfont{zhsong}{SimSun}[AutoFakeBold]%
  \setCJKfamilyfont{zhhei}{SimHei}[AutoFakeBold]%
  \setCJKfamilyfont{zhkai}{KaiTi}%
  \setCJKfamilyfont{zhfs}{FangSong}%
}
\newcommand\nwafu@load@cjk@font@mac{%
  \setCJKmainfont{Songti SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = Kaiti SC,
    BoldItalicFont = Kaiti SC Bold,
  ]%
  \setCJKsansfont{Heiti SC}[BoldFont=* Medium]%
  \setCJKmonofont{STFangsong}
  \setCJKfamilyfont{zhsong}{Songti SC}[
    UprightFont = * Light,
      BoldFont  = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Heiti SC}[
    UprightFont = * Light,
    BoldFont    = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{STFangsong}%
  \setCJKfamilyfont{zhkai}{Kaiti SC}[BoldFont = * Bold]%
  \setCJKfamilyfont{zhli}{Baoli SC}%
  \setCJKfamilyfont{zhyuan}{Yuanyi SC}[
    UprightFont = * Light,
    BoldFont    = * Bold,
  ]%
  \xeCJKsetwidth{‘’“”}{1em}%
}

% 注意 Noto CJK 的 regular 字重名字不带“Regular”。
\newcommand\nwafu@load@cjk@font@noto{%
  \setCJKmainfont{Noto Serif CJK SC}[
    UprightFont    = * Light,
    BoldFont       = * Bold,
    ItalicFont     = FandolKai-Regular,
    ItalicFeatures = {Extension = .otf},
  ]%
  \setCJKsansfont{Noto Sans CJK SC}[
    BoldFont    = * Medium,
  ]%
  \setCJKmonofont{Noto Sans Mono CJK SC}%
  \setCJKfamilyfont{zhsong}{Noto Serif CJK SC}[
    UprightFont = * Light,
    UprightFont = * Bold,
  ]%
  \setCJKfamilyfont{zhhei}{Noto Sans CJK SC}[
    BoldFont    = * Medium,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
}
\newcommand\nwafu@load@cjk@font@fandol{%
  \setCJKmainfont{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
    ItalicFont  = FandolKai-Regular,
  ]%
  \setCJKsansfont{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKmonofont{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhsong}{FandolSong}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhhei}{FandolHei}[
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold,
  ]%
  \setCJKfamilyfont{zhfs}{FandolFang}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
  \setCJKfamilyfont{zhkai}{FandolKai}[
    Extension   = .otf,
    UprightFont = *-Regular,
  ]%
}
\ifnwafu@cjk@font@none\else
  \providecommand\songti{\CJKfamily{zhsong}}
  \providecommand\heiti{\CJKfamily{zhhei}}
  \providecommand\fangsong{\CJKfamily{zhfs}}
  \providecommand\kaishu{\CJKfamily{zhkai}}
\fi
\newcommand\nwafu@load@cjk@font{%
  \@nameuse{nwafu@load@cjk@font@\nwafu@cjk@font}%
}
\nwafu@load@cjk@font
\nwafu@option@hook{cjk-font}{\nwafu@load@cjk@font}

% 使用 \pkg{unicode-math} 配置数学字体。
\unimathsetup{
  math-style = ISO,
  bold-style = ISO,
  nabla      = upright,
  partial    = upright,
}
\newcommand\nwafu@load@math@font@xits{%
  \nwafu@set@xits@names
  \setmathfont{\nwafu@font@name@xits@math@rm}[
    Extension    = .otf,
    BoldFont     = \nwafu@font@name@xits@math@bf,
    StylisticSet = 8,
  ]%
  \setmathfont{\nwafu@font@name@xits@math@rm}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {cal,bfcal},
  ]%
}
\newcommand\nwafu@load@math@font@stix{%
  \setmathfont{STIX2Math}[
    Extension    = .otf,
    StylisticSet = 8,
  ]%
  \setmathfont{STIX2Math}[
    Extension    = .otf,
    StylisticSet = 1,
    range        = {cal,bfcal},
  ]%
}
\newcommand\nwafu@load@math@font@libertinus{%
  \nwafu@set@libertinus@names
  \setmathfont{\nwafu@font@name@libertinus@math .otf}%
}
\newcommand\nwafu@load@math@font@lm{%
  \setmathfont{latinmodern-math.otf}%
}
\newcommand\nwafu@load@math@font{%
  \csname nwafu@load@math@font@\nwafu@math@font\endcsname
}
\nwafu@load@math@font
\nwafu@option@hook{math-font}{\nwafu@load@math@font}

% 带圈数字，Times New Roman 没有这些符号的字形，
% 而华文宋体和中易宋体提供了这些字形，
% 配置在 \cs{nwafu@circlefont}。
\ifnwafu@font@times
  \ifnwafu@cjk@font@mac
    \newfontfamily\nwafu@circlefont{Songti SC Light}
  \else
    \ifnwafu@cjk@font@windows
      \newfontfamily\nwafu@circlefont{SimSun}
    \fi
  \fi
\else
  \nwafu@set@xits@names
  \newfontfamily\nwafu@circlefont{%
    \nwafu@font@family@xits-\nwafu@font@style@xits@rm.otf%
  }
\fi

% 目前最广泛使用的印刷的长度单位点（磅）通常指 PostScript point
% \footnote{\url{https://en.wikipedia.org/wiki/Point_(typography)}}，
% 在 \LaTeX{} 中是 bp，比默认的 pt 略大。
% 这里保存起来可以节约编译时间。
\newdimen\bp@
\bp@=1bp

% 下面设置字号。正文字号12bp，行距22bp；
% 其他命令的行距按照相同的的比例设置，如表~\ref{tab:fontsize}。
% \begin{table}[htb]
%   \centering
%   \caption{标准字体命令与字号、行距的对应}
%   \label{tab:fontsize}
%   \begin{tabular}{lllll}
%     \toprule
%     字体命令          & 字号 & bp   & 研究生行距 & 本科生行距 \\
%     \midrule
%     \cs{tiny}         & 小六 & 6.5  & 10.83      & 11.92      \\
%     \cs{scriptsize}   & 六号 & 7.5  & 12.5       & 13.75      \\
%     \cs{footnotesize} & 小五 & 9    & 15         & 16.5       \\
%     \cs{small}        & 五号 & 10.5 & 17.5       & 19.25      \\
%     \cs{normalsize}   & 小四 & 12   & 20         & 22         \\
%     \cs{large}        & 小三 & 15   & 25         & 27.5       \\
%     \cs{Large}        & 小二 & 18   & 30         & 33         \\
%     \cs{LARGE}        & 二号 & 22   & 36.67      & 40.33      \\
%     \cs{huge}         & 小一 & 24   & 40         & 44         \\
%     \cs{Huge}         & 一号 & 26   & 43.33      & 47.67      \\
%     \bottomrule
%   \end{tabular}
% \end{table}

% 行距22bp
% \renewcommand\normalsize{%
%   \@setfontsize\normalsize{12\bp@}{20\bp@}%
%   \abovedisplayskip 12\bp@ \@plus3\bp@ \@minus7\bp@
%   \abovedisplayshortskip \z@ \@plus3\bp@
%   \belowdisplayshortskip 6.5\bp@ \@plus3.5\bp@ \@minus3\bp@
%   \belowdisplayskip \abovedisplayskip
%   \let\@listi\@listI}
% \normalsize
% \renewcommand\small{%
%   \@setfontsize\small{10.5\bp@}{19.25\bp@}%
%   \abovedisplayskip 10.5\bp@ \@plus3\bp@ \@minus6\bp@
%   \abovedisplayshortskip \z@ \@plus3\bp@
%   \belowdisplayshortskip 6.5\bp@ \@plus3.5\bp@ \@minus3\bp@
%   \belowdisplayskip \abovedisplayskip
% }
% \renewcommand\footnotesize{%
%   \@setfontsize\footnotesize{9\bp@}{16.5\bp@}%
%   \abovedisplayskip 9\bp@ \@plus2\bp@ \@minus5\bp@
%   \abovedisplayshortskip \z@ \@plus3\bp@
%   \belowdisplayshortskip 6\bp@ \@plus3\bp@ \@minus3\bp@
%   \belowdisplayskip \abovedisplayskip
% }
% \renewcommand\scriptsize{\@setfontsize\scriptsize{7.5\bp@}{13.75\bp@}}
% \renewcommand\tiny{\@setfontsize\tiny{6.5\bp@}{11.92\bp@}}
% \renewcommand\large{\@setfontsize\large{15\bp@}{27.5\bp@}}
% \renewcommand\Large{\@setfontsize\Large{18\bp@}{33\bp@}}
% \renewcommand\LARGE{\@setfontsize\LARGE{22\bp@}{40.33\bp@}}
% \renewcommand\huge{\@setfontsize\huge{24\bp@}{44\bp@}}
% \renewcommand\Huge{\@setfontsize\Huge{26\bp@}{47.67\bp@}}

% 行距20bp
\renewcommand\normalsize{%
  \@setfontsize\normalsize{12\bp@}{20\bp@}%
  \abovedisplayskip 12\bp@ \@plus3\bp@ \@minus7\bp@
  \abovedisplayshortskip \z@ \@plus3\bp@
  \belowdisplayshortskip 6.5\bp@ \@plus3.5\bp@ \@minus3\bp@
  \belowdisplayskip \abovedisplayskip
  \let\@listi\@listI}
\normalsize
%
% 注意第~\ref{sec:list} 节去掉了列表的间距，所以不再修改 \cs{@listi}。
\renewcommand\small{%
  \@setfontsize\small{10.5\bp@}{17.5\bp@}%
  \abovedisplayskip 10.5\bp@ \@plus3\bp@ \@minus6\bp@
  \abovedisplayshortskip \z@ \@plus3\bp@
  \belowdisplayshortskip 6.5\bp@ \@plus3.5\bp@ \@minus3\bp@
  \belowdisplayskip \abovedisplayskip
}
\renewcommand\footnotesize{%
  \@setfontsize\footnotesize{9\bp@}{15\bp@}%
  \abovedisplayskip 9\bp@ \@plus2\bp@ \@minus5\bp@
  \abovedisplayshortskip \z@ \@plus3\bp@
  \belowdisplayshortskip 6\bp@ \@plus3\bp@ \@minus3\bp@
  \belowdisplayskip \abovedisplayskip
}
\renewcommand\scriptsize{\@setfontsize\scriptsize{7.5\bp@}{12.5\bp@}}
\renewcommand\tiny{\@setfontsize\tiny{6.5\bp@}{10.83\bp@}}
\renewcommand\large{\@setfontsize\large{15\bp@}{25\bp@}}
\renewcommand\Large{\@setfontsize\Large{18\bp@}{30\bp@}}
\renewcommand\LARGE{\@setfontsize\LARGE{22\bp@}{36.67\bp@}}
\renewcommand\huge{\@setfontsize\huge{24\bp@}{40\bp@}}
\renewcommand\Huge{\@setfontsize\Huge{26\bp@}{43.33\bp@}}

% 设置行距的倍数为 1。
\linespread{1}\selectfont

% \subsection{处理语言}

% 由于 Unicode 的一些标点符号是中西文混用的：
% \unicodechar{00B7}、
% \unicodechar{2013}、
% \unicodechar{2014}、
% \unicodechar{2018}、
% \unicodechar{2019}、
% \unicodechar{201C}、
% \unicodechar{201D}、
% \unicodechar{2025}、
% \unicodechar{2026}、
% \unicodechar{2E3A}，
% 所以要根据语言设置正确的字体。
% \footnote{\url{https://github.com/CTeX-org/ctex-kit/issues/389}}
% 所以要根据语言设置正确的字体。
\newcommand\nwafu@setchinese{%
  \xeCJKResetPunctClass
}

\renewcommand\contentsname{目录}
\renewcommand\listfigurename{插图清单}
\renewcommand\listtablename{表格清单}
\renewcommand\figurename{图}
\renewcommand\tablename{表}

% 以下是nwafuprojrep新添加的代码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% geometry settings
%% 页面设定
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\geometry{
  left=28mm,
  right=22mm,
  top=25mm,
  bottom=25mm,
  headheight=20mm,
  headsep=3mm,
  footskip=10mm,
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 标题设置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\def\fnum@figure{\figurename\thefigure}% 删除“图”与编号间的空格
\def\fnum@table{\tablename\thetable}% 删除“表”与编号间的空格
\DeclareCaptionLabelSeparator{labsep}{\hspace{0.5em}}% 图表与标题间的分隔符
\DeclareCaptionFont{hei}{\small\heiti}% 字体
\captionsetup[table]{labelsep=labsep, belowskip=0pt,aboveskip=5pt,labelfont=hei,textfont=hei}
\captionsetup[figure]{labelsep=labsep, belowskip=0pt,aboveskip=5pt,format=hang,labelfont=hei,textfont=hei}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 将列表项缩进方式改为首行缩进的中文格式
%% 需要enumitem宏包
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setlist[description]{
    topsep=0pt,
    itemsep=0pt,
    partopsep=0pt,
    parsep=\parskip,
    labelindent=\parindent,
    labelwidth=1.3em,
    labelsep = .3em,
    itemindent=3.6em,
    leftmargin=!,
}

\setlist[enumerate]{
    topsep=0pt,
    itemsep=0pt,
    partopsep=0pt,
    parsep=\parskip,
    label={\arabic*)},
    labelindent=\parindent,
    labelwidth=1.3em,
    labelsep = .3em,
    itemindent=3.6em,
    leftmargin=!,
}
\setlist[itemize]{
    topsep=0pt,
    itemsep=0pt,
    partopsep=0pt,
    parsep=\parskip,
    labelindent=1.4em,
    labelwidth=1.3em,
    labelsep = .3em,
    itemindent=3em,
    leftmargin=!,
}

% \subsection{封面}
% 定义用户接口：
\nwafu@define@key{
  college = {
    default = {学院名称},
  },
  projname = {
    default = {实习课程名称},
  },
  title = {
    default = {论文题目},
  },
  author = {
    default = {作者姓名},
  },
  stuno = {
    default = {学号},
  },
  major = {
    default = {专业},
  },
  classid = {
    default = {班级号},
  },
  adviser = {
    default = {导师姓名},
  },
  startdate = {
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  enddate = {
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
}

% 常量定义
\newcommand\nwafu@nwafu@name{西北农林科技大学}
\newcommand\nwafu@title@name{题目}
\newcommand\nwafu@stuno@name{学号}
\newcommand\nwafu@author@name{姓名}
\newcommand\nwafu@major@name{专业}
\newcommand\nwafu@classid@name{班级}
\newcommand\nwafu@adviser@name{指导教师}
\newcommand\nwafu@date@name{实践日期}

\ifnwafu@cjk@font@mac
  \providecommand\lishu{\CJKfamily{zhli}}
\else
  \ifnwafu@cjk@font@windows
    \setCJKfamilyfont{zhli}{LiSu}
    \providecommand\lishu{\CJKfamily{zhli}}
  \else
    \nwafu@warning{LiShu font is required}
    \providecommand\lishu{\sffamily}
  \fi
\fi

% 封面
% 排版封面命令
\newcommand\makecover{
  \pagestyle{empty}
  \cleardoublepage
  \nwafu@make@cover@nwafuprojrep
}

% 封面内容排版
\newcommand\nwafu@make@cover@nwafuprojrep{
  \cleardoublepage
  \newgeometry{top=1.0in, bottom=1.0in, left=1.25in, right=1.25in}
  \vfill
  \begin{center}
    \vspace{\stretch{0.2}}

    \linespread{0.8}\kaishu\Huge%\bfseries
    \nwafu@nwafu@name{}\nwafu@college
    
    \uline{\nwafu@projname{}}实习报告
    
    \vspace{\stretch{1.0}}
  \end{center}

  \begin{center}
    \linespread{1.212}%\heiti%\Huge%\fontsize{22bp}{26.4bp}\selectfont%\zihaoer%
    \begin{tabular}{>{\heiti\huge}c@{}>{\heiti\huge}l}    
    {\makebox[3\ccwd][s]{\nwafu@title@name}：} &    
    {\expandafter\uline\expandafter{\nwafu@title}}
    \end{tabular}
    \vspace{\stretch{2.0}}
  \end{center}
  
  \begin{center}    
    \linespread{2.0}\songti\zihao{3}% 目的是计算字符占有宽度
    \newlength{\lablen}
    \setlength{\lablen}{\widthof{\nwafu@adviser@name}}
    \begin{tabular} {>{\songti\zihao{3}}c>{\songti\zihao{3}}c}%
      \makebox[\the\lablen][s]{\nwafu@stuno@name} & \nwafu@stuno \\ \cline{2-2}%
      \makebox[\the\lablen][s]{\nwafu@author@name} & \nwafu@author \\ \cline{2-2}
      \makebox[\the\lablen][s]{{\nwafu@major@name}{\nwafu@classid@name}} & {\nwafu@major} {\nwafu@classid 班} \\ \cline{2-2}      
      \makebox[\the\lablen][s]{\nwafu@adviser@name} & \nwafu@adviser \\ \cline{2-2}
      \makebox[\the\lablen][s]{\nwafu@date@name} & {\nwafu@startdate---\nwafu@enddate} \\ \cline{2-2}
    \end{tabular}
  \end{center}
  \vfill
  \restoregeometry
}

% 添加 PDF 书签，在 \pkg{hyperref} 载入后才有效。
\newcommand\nwafu@pdfbookmark{\@gobble}

% \subsection{正文}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 设置交叉引用增强\autoref命令
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ===========设置引用标记名称============
%\def\equationautorefname~#1\null{公式(#1)\null}%
%\def\footnoteautorefname{脚注}%
%\def\itemautorefname~#1\null{第#1项\null}%
%\def\figureautorefname{图}%
%\def\figureautorefname~#1\null{图#1\null}%
%\def\tableautorefname{表}%
%\def\tableautorefname~#1\null{表#1\null}%
%\def\sectionautorefname~#1\null{第#1节\null}%
%\def\subsectionautorefname~#1\null{第#1小节\null}%
%\def\subsubsectionautorefname~#1\null{第#1小小节\null}%
%\def\theoremautorefname{定理}%
%\def\pageautorefname~#1\null{第~#1~页\null}%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 图片搜索路径设定
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%\graphicspath{{./figs/}{./figure/}{./figures/}{./image/}{./images/}{./graphics/}{./graphic/}{./pictures/}{./picture/}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 禁止段末孤字成行
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\xeCJKsetup{CJKecglue={\hskip 0.10em plus 0.05em minus 0.05em},CheckSingle=true}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 标题格式设定
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ctexset{
  %tocdepth=1,
  section = {
    format+ = \zihao{4} \heiti \raggedright,
    name = {,、},
    number = \chinese{section},
    beforeskip = 1.0ex plus 0.2ex minus .2ex,
    afterskip = 1.0ex plus 0.2ex minus .2ex,
    aftername = \hspace{0.2\ccwd}
  },
  subsection = {
    format+ = \zihao{-4} \heiti \raggedright,
    % name={\thesubsection、},
    name = {(,)},
    number = \arabic{subsection},
    beforeskip = 1.0ex plus 0.2ex minus .2ex,
    afterskip = 1.0ex plus 0.2ex minus .2ex,
    aftername = \hspace{0.3\ccwd},
    %indent=2\ccwd,%
  },
  subsubsection = {
    %name={,},%
    number=\Circled{\arabic{subsubsection}},%
    format+ = \zihao{-4} \songti \raggedright,
    beforeskip = 1.0ex plus 0.2ex minus .2ex,
    afterskip = 1.0ex plus 0.2ex minus .2ex,
    aftername = \hspace{0.3\ccwd},
    %indent=2\ccwd,%
  }
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 目录设置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setcounter{tocdepth}{1}
\renewcommand{\contentsname}{\begin{center} \heiti\zihao{3}目\hspace{\ccwd}录\end{center}\vspace*{2ex}}    
\titlecontents{section}[0em]{\songti \zihao{-4}}
    {\thecontentslabel{}}{}
    {\hspace{.5em}\titlerule*[5pt]{$\cdot$}\contentspage}
    
% 调整目录行距
\pretocmd{\section}{\addtocontents{toc}{\protect\addvspace{3ex}}}{}{}    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 页眉页脚
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 定义正文页码样式(规范无页眉)
\fancypagestyle{main}{
  % 重置页码计数器 
  \setcounter{page}{1}
  % 页眉置为空
  \fancyhead{}
  % 页脚置为空
  \fancyfoot{}
  % 页脚居中显示页码
  \fancyfoot[C]{\songti\small{-\ \thepage\ -}}
  % 取消页眉线
  \renewcommand{\headrulewidth}{0bp}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 定义实习日志环境
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{logentry}[2][]% date, heading
{\par{\bfseries\heiti{}#2：#1}\par}{\par}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 重定义强调字体的代码，
%% 解决默认强调字体是italic，中文用楷体代替，
%% 在此设置为加粗，注意需要使用etoolbox宏包
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\makeatletter
\let\origemph\emph
\newcommand*\emphfont{\normalfont\bfseries}
\DeclareTextFontCommand\@textemph{\emphfont}
\newcommand\textem[1]{%
  \ifdefstrequal{\f@series}{\bfdefault}
    {\@textemph{\CTEXunderline{#1}}}
    {\@textemph{#1}}%
}
\RenewDocumentCommand\emph{s o m}{%
  \IfBooleanTF{#1}
    {\textem{#3}}
    {\IfNoValueTF{#2}
      {\textem{#3}\index{#3}}
      {\textem{#3}\index{#2}}%
     }%
}

% \cs{sloppy} 可以减少“overfull boxes”。
\sloppy

% 禁止扩大段间距。（\href{https://github.com/nwafutug/nwafuprojrep/issues/209}{
%   nwafutug/nwafuprojrep\#209}）
\raggedbottom

% 段间距 0 磅。
\setlength{\parskip}{\z@}

% 首段缩进。
\ctexset{autoindent=2}

% 首段缩进。
\let\@afterindentfalse\@afterindenttrue
\@afterindenttrue

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% URL排版设置
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\urlstyle{same}
\def\UrlBreaks{%
  \do\/%
  \do\a\do\b\do\c\do\d\do\e\do\f\do\g\do\h\do\i\do\j\do\k\do\l%
     \do\m\do\n\do\o\do\p\do\q\do\r\do\s\do\t\do\u\do\v\do\w\do\x\do\y\do\z%
  \do\A\do\B\do\C\do\D\do\E\do\F\do\G\do\H\do\I\do\J\do\K\do\L%
     \do\M\do\N\do\O\do\P\do\Q\do\R\do\S\do\T\do\U\do\V\do\W\do\X\do\Y\do\Z%
  \do0\do1\do2\do3\do4\do5\do6\do7\do8\do9\do=\do/\do.\do:%
  \do\*\do\-\do\~\do\'\do\"\do\-}
\Urlmuskip=0mu plus 0.1mu

% \subsection{数学符号}

% 根据中文的数学排印习惯进行设置：

% 省略号一律居中，所以 \cs{ldots} 不再居于底部。
\def\mathellipsis{\cdots}

% 小于等于号、大于等于号要使用倾斜的字形。
\protected\def\le{\leqslant}
\protected\def\ge{\geqslant}
\AtBeginDocument{%
  \renewcommand\leq{\leqslant}%
  \renewcommand\geq{\geqslant}%
}

% 积分号的上下限默认置于上下两侧。
\removenolimits{%
  \int\iint\iiint\iiiint\oint\oiint\oiiint
  \intclockwise\varointclockwise\ointctrclockwise\sumint
  \intbar\intBar\fint\cirfnint\awint\rppolint
  \scpolint\npolint\pointint\sqint\intlarhk\intx
  \intcap\intcup\upint\lowint
}

% 实部、虚部操作符使用罗马体 $\mathrm{Re}$、$\mathrm{Im}$ 而不是 fraktur 体
% $\Re$、$\Im$。
\AtBeginDocument{%
  \renewcommand\Re{\operatorname{Re}}%
  \renewcommand\Im{\operatorname{Im}}%
}

% \cs{nabla} 使用粗正体。
\AtBeginDocument{%
  \renewcommand\nabla{\mbfnabla}%
}

% 兼容旧的粗体命令：\pkg{bm} 的 \cs{bm} 和 \pkg{amsmath} 的 \cs{boldsymbol}。
\DeclareRobustCommand\bm[1]{{\symbf{#1}}}
\DeclareRobustCommand\boldsymbol[1]{{\symbf{#1}}}

% 兼容 \pkg{amssymb} 中的命令。
\newcommand\square{\mdlgwhtsquare}

% 提供一些方便的命令：
\newcommand\upe{\symup{e}}
\newcommand\upi{\symup{i}}
\newcommand\dif{\mathop{}\!\mathrm{d}}

% \subsection{其他宏包的设置}
% 这些宏包并非格式要求，但是为了方便同学们使用，在这里进行简单设置。
% \subsubsection{\pkg{hyperref} 宏包}
\AtEndOfPackageFile*{hyperref}{
  \hypersetup{
    bookmarksnumbered  = true,
    bookmarksopen      = true,
    bookmarksopenlevel = 1,
    linktoc            = all,
    unicode            = true,
    psdextra           = true,
  }
  %
  \hypersetup{
    colorlinks = true,
    allcolors  = blue,
  }
  % \hypersetup{hidelinks}
  %
  % 填写 PDF 元信息。
  \AtBeginDocument{%
    \hypersetup{
      pdftitle  = \nwafu@title,
      pdfauthor = \nwafu@author,
    }%
  }
  %
  % 添加 PDF 书签
  %
  \newcounter{nwafu@bookmarknumber}
  \renewcommand\nwafu@pdfbookmark[1]{%
    \phantomsection
    \stepcounter{nwafu@bookmarknumber}%
    \pdfbookmark[0]{#1}{nwafusection.\thenwafu@bookmarknumber}%
  }
  %
  % 在 PDF 字符串中去掉换行，以减少 \pkg{hyperref} 的警告信息。
  \pdfstringdefDisableCommands{
    \let\\\@empty
    \let\hspace\@gobble
  }
  %
  % \pkg{hyperref} 与 \pkg{unicode-math} 存在一些兼容性问题
  \@ifpackagelater{hyperref}{2019/04/27}{}{%
    \g@addto@macro\psdmapshortnames{\let\mu\textmu}%
  }
  %
  % 设置中文的 \cs{autoref}。
  % \footnote{\url{https://tex.stackexchange.com/a/66150/82731}}
  \def\equationautorefname~#1\null{公式~(#1)\null}
  \def\footnoteautorefname{脚注}
  \def\itemautorefname~#1\null{第~#1~项\null}
  \def\figureautorefname{图}
  \def\tableautorefname{表}
  \def\partautorefname~#1\null{第~#1~部分\null}
  \def\appendixautorefname{附录}
  \def\chapterautorefname~#1\null{第~#1~章\null}
  \def\sectionautorefname~#1\null{第~#1~节\null}
  \def\subsectionautorefname~#1\null{第~#1~小节\null}
  \def\subsubsectionautorefname~#1\null{第~#1~小小节\null}
  \def\paragraphautorefname~#1\null{第~#1~段\null}
  \def\subparagraphautorefname~#1\null{第~#1~小段\null}
  \def\theoremautorefname{定理}
  \def\HyRef@autopageref#1{\hyperref[{#1}]{第~\pageref*{#1} 页}}
}


% \subsubsection{\pkg{amsthm} 宏包}
\AtEndOfPackageFile*{amsthm}{
  \newtheoremstyle{nwafuplain}
    {}{}
    {}{2\ccwd}
    {\bfseries}{}
    {\ccwd}{}
  \theoremstyle{nwafuplain}
  % 定义新的定理
  \newcommand\nwafu@assertion@name{断言}
  \newcommand\nwafu@assumption@name{假设}
  \newcommand\nwafu@axiom@name{公理}
  \newcommand\nwafu@corollary@name{推论}
  \newcommand\nwafu@definition@name{定义}
  \newcommand\nwafu@example@name{例}
  \newcommand\nwafu@lemma@name{引理}
  \newcommand\nwafu@proof@name{证明}
  \newcommand\nwafu@proposition@name{命题}
  \newcommand\nwafu@remark@name{注}
  \newcommand\nwafu@theorem@name{定理}
  \newtheorem{theorem}             {\nwafu@theorem@name}
  \newtheorem{assertion}  [theorem]{\nwafu@assertion@name}
  \newtheorem{axiom}      [theorem]{\nwafu@axiom@name}
  \newtheorem{corollary}  [theorem]{\nwafu@corollary@name}
  \newtheorem{lemma}      [theorem]{\nwafu@lemma@name}
  \newtheorem{proposition}[theorem]{\nwafu@proposition@name}
  \newtheorem{assumption}          {\nwafu@assumption@name}
  \newtheorem{definition}          {\nwafu@definition@name}
  \newtheorem{example}             {\nwafu@example@name}
  \newtheorem*{remark}             {\nwafu@remark@name}
  % \pkg{amsthm} 单独定义了 proof 环境，这里重新定义以满足格式要求。
  % 原本模仿 \pkg{amsthm} 写成 |\item[\hskip\labelsep\hskip2\ccwd #1\hskip\ccwd]|，
  % 但是却会多出一些间隙。
  \renewenvironment{proof}[1][\nwafu@proof@name]{\par
    \pushQED{\qed}%
    \normalfont \topsep6\p@\@plus6\p@\relax
    \trivlist
      \item\relax\hskip2\ccwd
      \textbf{#1}
      \hskip\ccwd\ignorespaces
    }{%
    \popQED\endtrivlist\@endpefalse
  }
}


% \subsubsection{\pkg{algorithm2e} 宏包}
\AtEndOfPackageFile*{algorithm2e}{
  \SetAlgorithmName{算法}{算法}{算法清单}
  %
  % 设置算法环境的格式。
  \SetAlCapSkip{6\bp@}
  \SetAlCapFnt{\small}
  \SetAlCapNameFnt{\small}
  \SetAlCapNameSty{textbf}
  \SetAlgoCaptionSeparator{\unskip\hspace*{\ccwd}}
}


% \subsubsection{\pkg{siunitx} 宏包}
\AtEndOfPackageFile*{siunitx}{
  \sisetup{
    group-minimum-digits = 4,
    separate-uncertainty = true,
    inter-unit-product   = \ensuremath{{}\cdot{}},
  }
  \sisetup{
    list-final-separator = { 和 },
    list-pair-separator  = { 和 },
    range-phrase         = {～},
  }
}

\endinput
%% End of file `nwafucoursepaper.cls'.
