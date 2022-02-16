export PATH=/opt/anaconda3/envs/snakemake/bin/:$PATH

snakemake --cores 40 --config INPUT=/home/duansq/datasets/2022_adult-brain-vasc_EthanWinkler/data/2022_adult-brain-vasc-am-immue_EthanWinkler.rds
snakemake --cores 40 --config INPUT=/home/duansq/datasets/2022_adult-brain-vasc_EthanWinkler/data/am-perivascular/2022_adult-brain-vasc-am-perivascular_EthanWinkler.rds
