import tensorflow as tf
import scipy.io as scio
import inference
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
import change_data
import train
import numpy as np
TIME = 100
True_name = 'true_labels.txt'
Pred_name = 'pred_labels.txt'

def plot_confusion_matrix(labels = None ,cm = None, title='Confusion Matrix', cmap=plt.cm.binary):
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    xlocations = np.array(range(len(labels)))
    plt.xticks(xlocations, labels, rotation=90)
    plt.yticks(xlocations, labels)
    plt.ylabel('True label')
    plt.xlabel('Predicted label')


def Print_matrix(labels = None,name1 = 'true_labels.txt',name2 = 'pred_labels.txt'):
    y_true = np.loadtxt(name1)
    y_pred = np.loadtxt(name2)
    tick_marks = np.array(range(len(labels))) + 0.5
    cm = confusion_matrix(y_true, y_pred)
    np.set_printoptions(precision=2)
    cm_normalized = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
    print(cm_normalized)
    plt.figure(figsize=(10, 6), dpi=120)
    ind_array = np.arange(len(labels))
    x, y = np.meshgrid(ind_array, ind_array)
    for x_val, y_val in zip(x.flatten(), y.flatten()):
        c = cm_normalized[y_val][x_val]
        if c > 0.01:
            plt.text(x_val, y_val, "%0.2f" % (c,), color='yellow', fontsize=7, va='center', ha='center')
    # offset the tick
    plt.gca().set_xticks(tick_marks, minor=True)
    plt.gca().set_yticks(tick_marks, minor=True)
    plt.gca().xaxis.set_ticks_position('none')
    plt.gca().yaxis.set_ticks_position('none')
    plt.grid(True, which='minor', linestyle='-')
    plt.gcf().subplots_adjust(bottom=0.15)

    plot_confusion_matrix(labels,cm_normalized, title='confusion matrix')
    # show confusion matrix
    plt.savefig('confusion_matrix.png', format='png')
    plt.show()

def evaluate_2(datafile):
    x = tf.placeholder(tf.float32, [None,change_data.TRAINDATA_SIZE1,change_data.TRAINDATA_SIZE2], name='x-input')
    y_ = tf.placeholder(tf.float32, [None,change_data.LABEL_SIZE], name='y-input')
    data = scio.loadmat(datafile)
    testdata = data['testdata']
    testlabel = data['testlabel']
    testdata2, testlabel2 = change_data.Change(testdata, testlabel)
    test_feed = {x:testdata2, y_: testlabel2}
    reshape_x = tf.reshape(x, [-1,80,80,1])
    y = inference.inference(reshape_x,None,None,1)
    correct_prediction = tf.equal(tf.argmax(y, 1), tf.argmax(y_, 1))
    label = tf.argmax(y, 1)
    label_1 = tf.argmax(y_,1)
    accurcy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
    variable_averages = tf.train.ExponentialMovingAverage(train.MOVING_AVERAGE_DECAY)
    variable_to_restore = variable_averages.variables_to_restore()
    saver = tf.train.Saver(variable_to_restore)
    with tf.Session() as sess:
        ckpt = tf.train.get_checkpoint_state(train.MODEL_SAVE_PATH)
        if ckpt and ckpt.model_checkpoint_path:
            saver.restore(sess,ckpt.model_checkpoint_path)
            global_step = ckpt.model_checkpoint_path.split('/')[-1].split('-')[-1]
            test_acc = sess.run(accurcy,feed_dict=test_feed)
            test_label = sess.run(label, feed_dict=test_feed)
            train_label = sess.run(label_1, feed_dict=test_feed)
            print('After %s training steps ,test  accuracy using average model is %g' % (global_step, test_acc))
            #print(test_label)
            #print(train_label)
            np.savetxt(Pred_name,test_label)
            np.savetxt(True_name, train_label)
            labels = np.array(range(inference.NUM_LABELS - 1)) + 1
            Print_matrix(labels,True_name,Pred_name)
        else:
            print('NO checkpoint file found')
            return

def main(argv=None):
    datafile = 'D://Deeplearning//train_data//data'
    evaluate_2(datafile)

if __name__ == '__main__':
   tf.app.run()
