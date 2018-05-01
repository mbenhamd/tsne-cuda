import sys
sys.path.append('bhtsne')
sys.path.append('Multicore-TSNE')
from timeit import default_timer as timer
from collections import namedtuple

import numpy as np
from mnist import MNIST
#import bhtsne
from sklearn.manifold import TSNE as skTSNE
#from MulticoreTSNE import MulticoreTSNE as mcTSNE
import pickle as pkl

Test = namedtuple('Test', ('name', 'func', 'results'))

tests = []
tests.append(Test('SKLEARN', lambda array: skTSNE(n_components=2, perplexity=50, n_iter_without_progress=1000).fit_transform(array), []))
tests.append(Test('BHTSNE', lambda array: bhtsne.run_bh_tsne(array, perplexity=50), []))
tests.append(Test('MULTICORE-1', lambda array: mcTSNE(n_jobs=1, perplexity=50, n_iter_without_progress=1000).fit_transform(array), []))
tests.append(Test('MULTICORE-2', lambda array: mcTSNE(n_jobs=2, perplexity=50, n_iter_without_progress=1000).fit_transform(array), []))
tests.append(Test('MULTICORE-3', lambda array: mcTSNE(n_jobs=3, perplexity=50, n_iter_without_progress=1000).fit_transform(array), []))
tests.append(Test('MULTICORE-4', lambda array: mcTSNE(n_jobs=4, perplexity=50, n_iter_without_progress=1000).fit_transform(array), []))

sizes = [500, 1000, 2000, 4000, 8000, 16000, 32000]


def load_cifar10():
  def unpickle(file):
    import pickle
    with open(file, 'rb') as fo:
        d = pickle.load(fo, encoding='bytes')
    
    return d[b"data"]
  batches = []
  for i in range(1, 6):
    batches.append(unpickle("../cifar-10/python_data/data_batch_%d" % i))
  return np.concatenate(batches, axis=0)


def load_mnist():
    mndata = MNIST('../')
    testarray, _ = mndata.load_training()
    return testarray
    

def time(func, array):
    start = timer()
    func(array)
    end = timer()
    return end - start

for size in sizes:
 #   print('Running on array of size ({}, 50)'.format(size))
   #testarray = np.random.random((size, 50))
   #testarray = load_mnist()
   testarray = load_cifar10()
   print(testarray.shape)
   for test in tests:
        test.results.append(time(test.func, testarray))
        print('\t{:<12} : {:0.2f}'.format(test.name, test.results[-1]))

for test in tests:
    print(test.name, ':', test.results)
with open('benchmark_results.pkl', 'wb') as f:
    pkl.dump({test.name : test.results for test in tests}, f)
