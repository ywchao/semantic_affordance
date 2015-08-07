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

0. Download a copy of our [affordance dataset](http://www.umich.edu/~ywchao/semantic_affordance/data/affordance_data.tar.gz) and unzip the file.

0. Get the source code by cloning the repository: `git clone https://github.com/ywchao/semantic_affordance.git`

0. Change into the source code directory `cd semantic_affordance` and start MATLAB `matlab`. You should see the message `added paths for the experiment!` followed by the MATLAB prompt `>>`.

0. Change the path `data_dir` in `config.m` to the downloaded folder `affordance_data/`.
  <pre>
  data_dir = '/z/ywchao/datasets/affordance_data/';
  </pre>

0. Run `setup` to prepare the required files.
  -  Generate ground-truth binary labels from afforadance data
  -  Generate WordNet similarity measures for 91 MS-COCO object categories
  -  Download KPMF code

0. Run `pca_2d_run` to visualize the object categories in the 2D affordance space.

0. Run `demo_cf_nn` and `demo_cf_kpmf` to reproduce the NN and KPMF results.
  - In the default setting, the code will reproduce the paper's results on 20 PASCAL object categories. To run on 91 MS-COCO object categories, change the variable `param.n_set` from `'pascal'` to `'mscoco'`
  - If you download the [affordance dataset](http://www.umich.edu/~ywchao/semantic_affordance/data/affordance_data.tar.gz) before 2015-08-07, please re-download it as the previous one does not support the MS-COCO experiment.

