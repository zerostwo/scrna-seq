from pyscenic.cli.utils import load_signatures
import pandas as pd
import sys

print(sys.argv)
regulons = load_signatures(sys.argv[1])
# regulons = [r.rename(r.name.replace('(+)',' ('+str(len(r))+'g)')) for r in regulons]

res = pd.DataFrame()
for r in regulons:
    print(r.name)
    data = {'tfs':r.name, 'target':r.genes}
    df = pd.DataFrame(data)
    res = res.append(df)

res.to_csv(sys.argv[2], index =False)