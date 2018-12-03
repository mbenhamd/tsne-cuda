# TSNE-CUDA

***WARNING: This code is still in active development. While the core code is tested and working, some features need aditional testing.
It's a forked from this [original](https://github.com/CannyLab/tsne-cuda)***

# Future work

- Allow for double precision
- Expand FMM methods
- Add multi-threaded CPU version for those without a GPU
# Known Bugs

- Odd bug with some datasets that causes a hang/gpu memory error. 


# Citation

Please cite this repository if it was useful for your research:

```
@article{chan2018t,
  title={t-SNE-CUDA: GPU-Accelerated t-SNE and its Applications to Modern Data},
  author={Chan, David M and Rao, Roshan and Huang, Forrest and Canny, John F},
  journal={arXiv preprint arXiv:1807.11824},
  year={2018}
}
```

This library is built on top of the following technology, without this tech, none of this would be possible!

[L. Van der Maaten's paper](http://lvdmaaten.github.io/publications/papers/JMLR_2014.pdf)

[Multicore-TSNE](https://github.com/DmitryUlyanov/Multicore-TSNE)

[BHTSNE](https://github.com/lvdmaaten/bhtsne/)

[CUDA Utilities/Pairwise Distance](https://github.com/OrangeOwlSolutions)

[LONESTAR-GPU](http://iss.ices.utexas.edu/?p=projects/galois/lonestargpu)

[FAISS](https://github.com/facebookresearch/faiss)

[GTest](https://github.com/google/googletest)

[CXXopts](https://github.com/jarro2783/cxxopts)


# License

Our code is built using components from FAISS, the Lonestar GPU library, GTest, CXXopts, and OrangeOwl's CUDA utilities. Each portion of the code is governed by their respective licenses - however our code is governed by the BSD-3 license found in LICENSE.txt
