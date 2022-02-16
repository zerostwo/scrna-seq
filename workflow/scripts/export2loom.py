from pyscenic.cli.utils import load_signatures
from pyscenic.aucell import aucell
from pyscenic.binarization import binarize
import pandas as pd

regulons = load_signatures("/home/duansq/pipeline/scrna-seq/results/dc2/scenic/IGF2BP2_group/regulons.csv")
regulons=[r.rename(r.name.replace('(+)', ' ('+str(len(r))+'g)')) for r in regulons]
auc_mtx = pd.read_csv("/home/duansq/pipeline/scrna-seq/results/dc2/scenic/IGF2BP2_group/auc_mtx.csv", sep=',', header=0, index_col=0)
a = [r.name for r in regulons]
auc_mtx.columns = a
