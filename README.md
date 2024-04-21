### 检测指南

**使用MATLAB命令行运行`TEST.m`文件即可，该文件已设置代数为5、种群规模为20。**

### 其他文件介绍

- `calc.m`就是`test_ur_answer`文件，可用于检验所得成本是否造假。
- `dataform_testA2024.csv`，`dataform_testB2024.csv`，`dataform_train2024.csv`是测试集和训练集。
- `DPGA.m`是完整的改进双种群遗传算法代码，设置了代数为150、种群规模200，移民频率与`TEST.m`有所不同。
- `GA.m`是简单遗传算法代码，可用于与改进的算法进行对比。
- `my_spline.m`是给定的三次样条插值函数。
- `fitness.m`是适应度计算函数，由于经过优化，返回值会与`calc.m`有所不同。
- `StochasticUniversalSampling.m`，`TournamentSelection.m`，`TruncationSelection.m`是三种不同的选择算法，用于拓展研究。
- LaTeX源码文件夹内为论文源代码、可视化文件、样式文件和字体文件。

