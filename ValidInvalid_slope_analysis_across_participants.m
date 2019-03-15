
load('All_Sub_slope_analyis_regress.mat');
ttest2(AllSub_sl_InvalidTrials(1:11,1),AllSub_sl_ValidTrials(1:11,1),'Tail','right','Vartype','unequal');

a = find(AllSub_sl_InvalidTrials<0);
b = find(AllSub_sl_ValidTrials<0);

c = AllSub_pVal_sl_InvalidTrials(a);
d = AllSub_pVal_sl_ValidTrials(b);

e = nnz(c<0.05);
f = nnz(d<0.05);