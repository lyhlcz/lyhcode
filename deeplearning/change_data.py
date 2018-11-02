import tensorflow as tf
import numpy as np
TRAINDATA_SIZE1 = 20
TRAINDATA_SIZE2 = 320
LABEL_SIZE = 6


def Change(traindata,trainlabel):
    trainlabel1 = trainlabel.flatten()
    for v in range(len(trainlabel1)):
        trainlabel1[v] = trainlabel1[v]
    trainlabel2 = tf.one_hot(trainlabel1, LABEL_SIZE)
    with tf.Session() as sess:
        trainlabel3 = sess.run(trainlabel2)
    b = np.zeros((TRAINDATA_SIZE1, TRAINDATA_SIZE2))
    traindata1 = np.tile(b, (traindata.size, 1))
    traindata2 = traindata1.reshape((traindata.size, TRAINDATA_SIZE1, TRAINDATA_SIZE2))
    for i in range(traindata.size):
        for j in range(TRAINDATA_SIZE1):
            if traindata[i][0].shape[1] <= TRAINDATA_SIZE2:
                for k in range(traindata[i][0].shape[1]):
                    traindata2[i][j][k] = traindata[i][0][j][k]
            else:
                for p in range(TRAINDATA_SIZE2):
                    traindata2[i][j][p] = traindata[i][0][j][p]
    return (traindata2,trainlabel3)


def next_batches(inputs=None, targets=None, batch_size=None, shuffle=False,step = None):
    assert len(inputs) == len(targets)
    start_id = range(0, len(inputs), batch_size)
    start_idx = start_id[step%len(start_id)]
    end_idx = start_idx + batch_size
    if end_idx >= len(inputs):
        end_idx = len(inputs) - 1
    if shuffle:
        indices = np.arange(len(inputs))
        np.random.shuffle(indices)
        excerpt = indices[start_idx:end_idx]
    else:
        excerpt = slice(start_idx, end_idx)
    return inputs[excerpt], targets[excerpt]