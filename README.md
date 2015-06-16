# semantic_affordance

Code for reproducing the results described in the paper:

Y.-W. Chao, Z. Wang, R. Mihalcea, and J. Deng  
**Mining Semantic Affordances of Visual Object Categories**  
Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition (**CVPR**), 2015  

If you use this code, please cite our work:

    @INPROCEEDINGS{chao:cvpr2015,
      author = {Yu-Wei Chao and Zhan Wang and Rada Mihalcea and Jia Deng},
      title = {Mining Semantic Affordances of Visual Object Categories},
      booktitle = {Proceedings of the IEEE Conference on Computer Vision and Pattern Recognition},
      year = {2015},
    }

Check out the [project site](http://www.umich.edu/~ywchao/semantic_affordance/) for more details.

## Quick start

1. Download a copy of our [affordance dataset](http://www.umich.edu/~ywchao/semantic_affordance/data/affordance_data.tar.gz) and unzip the file.

2. Change Matlab's current directory into the directory of this README.

3. Change the path `data_dir` in `config.m` to the downloaded folder `affordance_data/`.
```MATLAB
data_dir = '/z/ywchao/datasets/affordance_data/';
```

4. Run `setup` to prepare the required files.
  -  Generate ground-truth binary labels from afforadance data
  -  Generate WordNet similarity measures for 91 MS-COCO object categories
  -  Download KPMF code

5. Run `demo_cf_nn` and `demo_cf_kpmf` to reproduce the NN and KPMF results.

