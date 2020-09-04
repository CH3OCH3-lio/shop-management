# nwafuprojrep
---------------------
一个适用于西北农林科技大学科技类及IT类课程设计报告排版的LaTeX模板。

使用该模板时，文件组织建议按如下方式存储：
```tex
jobname(根目录)
│ 
├── bib(存储参考文献数据库，可以有多个，根据需要增减)
│   └── example.bib                
├── codes(报告中需要的代码源文件，可以有多个，根据需要增减)
│   └── ex04-01.cpp
├── figs(插图目录，根据需要增减)
│   ├── tikz_sum.tex
│   ├── xxx.pdf
│   ├── xxx.png
│   └── xxx.jpg
├── settings(自定义命令、环境等文件、引入宏包文件，可根据需要进行调整)
│   ├── format.tex(自定义命令、环境、宏包设置等)
│   ├── math-commands.tex(自定义数学符号命令)
│   ├── packages.tex(需要引入的宏包)
│   └── terms.tex(自定义术语命令)
├── boxie.sty(盒子宏包，如果需要则置于根目录，并在settings/package.tex中引用该宏包)
├── fvextra.sty(盒子宏包需要的宏包，如果使用了boxie宏包，则必须置于根目录)
├── lstlinebgrd.sty(盒子宏包需要的宏包，如果使用了boxie宏包，则必须置于根目录)
├── main.tex(主控文件，必须存在，且置于根目录)
├── Makefile(make命令需要的脚本文件，如能执行make，可以在根目录执行make命令进行编译)
├── nwafuprojrep.cls(文档类文件，即模板文件，必须存在，且置于根目录)
├── pgf-umlcd.sty(UML图绘制宏包，如果需要则置于根目录，并在settings/package.tex中引用该宏包)
├── tikz-flowchart.sty(流程图绘制宏包，如果需要则置于根目录，并在settings/package.tex中引用该宏包)
├── tikz-imglabels.sty(图像标注/标记宏包，如果需要则置于根目录，并在settings/package.tex中引用该宏包)
└── .latexmkrc(latexmk命令需要的脚本文件，如能执行latexmk，可以在根目录执行latexmk命令进行编译)
```

Happy LaTeXing!~
## 使用说明
---------------------
1. 目前支持西北农林科技大学信息工程学院课程设计报告。
2. 请使用`\documentclass{nwafuprojrep}`命令引入`nwafuprojrep`文档类。

   引入`nwafuprojrep`文档类后，使用`\nwafuset`命令设置报告封面信息
   
```tex
   % 设置封面基本信息，\linebreak 前面不要有空格，
   % 中文之间的空格无法消除
   % 另，在\nwafuset中不可以出现空行
   \nwafuset{
     college = {信息工程学院},            % 学院名称
     projname = {面向对象程序设计},       % 实践课程名称
     title = {\LaTeX{}科技排版实习报告},  % 实习报告题目
     stuno = {2013051289},                % 学号
     author = {\LaTeX{}er},               % 姓名
     major = {计算机科学与技术},          % 专业
     classid = {152},                    % 班级(只填写数字，不要有其它内容)
     adviser = {Registor},                   % 指导教师姓名
     startdate = {2020年8月10日},        % 实践起始日期
     enddate = {8月23日},                % 实践结束日期
   }
```
3. 为确保参考文献样式正确，请务必使用胡振震开发的"biblatex-gb7714-2015样式包"(TeXLive2020中已收录该样式包)，请参考 "https://github.com/hushidong/biblatex-gb7714-2015" 。

4. 文档编译方式

如果采用minted宏包排版代码，则使用如下4次编译：
```shell
	xelatex -shell-escape main.tex
	biber main
	xelatex -shell-escape main.tex
	xelatex -shell-escape main.tex
```
如果采用listings宏包排版代码，则使用如下4次编译：
```shell
	xelatex main.tex
	biber main
	xelatex main.tex
	xelatex main.tex
```
或者采用minted宏包排版代码，用`latexmk`命令编译：

```shell
	latexmk
```

5. 发现个别英文无法正确断行，原因未找到，加了一个`\sloppy`命令进行暂时处理，这会造成当前行字距松散，请适当加入文字解决松散问题。

## `\nwafuset`详解
---------------------
1. 宏包选项接口

```tex
\nwafu@define@key{
  projtype = {% 实习类型
    choices = {% 可选项
      report,% 报告
      paper,% 论文
    },
    default = report,% 默认值
  },% 
  output = {% 结果输出方式
    choices = {% 可选项
      print,% 打印稿
      epub,% 电子稿
    },
    default = epub,% 默认值
  },   
  fontset = {% 字体选择 
    choices = {% 可选项
      windows,% Windows
      mac,% Mac
      ubuntu,% Ubuntu
      fandol,% Fandol
      none,% 不配置中文字体,需要用户自己配置
    },%
    default = none,% 默认值
  },
  system = {% 操作系统
    choices = {% 可选项
      mac,% Mac
      unix,% Unix/Linux
      windows,% Windows
      auto,% 自动选择
    },%
    default = auto,% 默认值
  },%
  font = {% 英文字体
    choices = {% 可选项
      times,% Times New Roman 
      termes,% TeX Gyre Termes 和 TeX Gyre Heros
      xits,% XITS 字体
      libertinus,% Libertinus 字体
      lm,% Lm 字体
      auto,% 自动选择
      none,% 不配置英文字体,需要用户自己配置
    },
    default = auto,% 默认值
  },
  cjk-font = {% 中文字体
    name = cjk@font,% 别名
    choices = {% 可选项
      windows,% Windows字体 
      mac,% Mac字体 
      noto,% 思源字体 
      fandol,% Fandol字体 
      auto,% 自动选择
      none,% 不配置中文字体,需要用户自己配置
    },
    default = auto,% 自动选择
  },
  math-font = {% 数学字体
    name = math@font,% 别名
    choices = {% 可选项
      xits,% XITS字体
      stix,% STIX字体
      libertinus,% Libertinus字体
      lm,% Lm字体
      none,% 不配置数学字体,需要用户自己配置
    },
    default = xits,% 默认值
  },
}
```

2. 用户接口
```tex
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
  startdate = {% 实习开始日期
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  enddate = {% 实习结束日期
    default = {\the\year-\two@digits{\month}-\two@digits{\day}},
  },
  keydeli = {% 关键字分隔符
    default = {; },% 默认值
  },
}
```

## 注意
---------------------

1. 本文档要求 TeXLive、MacTeX、MikTeX 不低于 2020 年的发行版，并且尽可能将宏包升级到最新，推荐使用TeXLive2020发行版。

2. 使用说明见：**demo.pdf**。

2. **不支持** [CTeX 套装](http://www.ctex.org/CTeXDownload)。

## 主要功能
---------------------
- 方便科技类或IT类课程设计报告排版；
- 定制摘要、关键词、各级节标题、表格、页眉页脚等样式；
- 使用自己开发的[boxie.sty宏包](https://github.com/registor/boxiesty)实现终端窗口模拟、各类代码文本框和“注意”、“重要”、“技巧”和“警告”等文本框；
- 使用自己开发的[tikz-flowchart.sty宏包](https://github.com/registor/tikz-flowchart)实现流程图的绘制；
- 使用改造于`tikz-imagelabels`宏包的`tikz-imglabels`宏包实现插图的注解；
- 使用`floatrow`宏包控制图表浮动体；

## 注意
---------------------
- 由于boxie.sty宏包需要使用fvextra.sty和lstlinebgrd.sty两个宏包处理间隔显示代码行颜色，请确保当前路径下有这两个宏包存在。

## 反馈
---------------------
如果发现代码有问题，请按照以下步骤操作：

1. 将 TeX 发行版和宏包升级到最新，并且将模板升级到 Gitee 上最新版本，查看问题是否已经修复；
2. 在 [Gitee Issues](https://gitee.com/registor/nwafuprojrep/issues)中搜索该问题的关键词；
3. 在 [Gitee Issues](https://gitee.com/registor/nwafuprojrep/issues)中提出新 issue，并回答以下问题：
    - 使用了什么版本的 TeX Live / MacTeX / MikTeX ？
    - 具体的问题是什么？
    - 正确的结果应该是什么样的？
    - 是否应该附上相关源码或者截图？
4. 联系作者：西北农林科技大学信息工程学院耿楠
