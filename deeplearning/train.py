import tensorflow as tf
import os
import inference
import scipy.io as scio
import change_data
import numpy as np
BATCH_SIZE = 200
RUEGULARIZATION_RATE = 0.0001
TRAINING_STEPS = 10000
MOVING_AVERAGE_DECAY = 0.99
MODEL_SAVE_PATH = "D:\Deeplearning\model"         #训练模型存入的地址
MODEL_NAME = "training_model.ckpt"                 #训练模型文件名


def train(datafile):
    x = tf.placeholder("float", shape=[None,change_data.TRAINDATA_SIZE1,change_data.TRAINDATA_SIZE2])  # 原始输入
    y_ = tf.placeholder("float", shape=[None, change_data.LABEL_SIZE])  # 目标值
    #y_ = tf.one_hot(y_1, 5)
    data = scio.loadmat(datafile)
    traindata = data['traindata']
    trainlabel = data['trainlabel']
    traindata2,trainlabel2 = change_data.Change(traindata,trainlabel)
    x_image = tf.reshape(x, [-1,80,80,1])
    regularizer = tf.contrib.layers.l2_regularizer(RUEGULARIZATION_RATE)
    y = inference.inference(x_image,1,regularizer,0.5)
    #y_conv = tf.nn.softmax(y)
    # 交叉熵损失
    #y = tf.clip_by_value(y, 1e-10, 1.0)
    #y_conv = tf.clip_by_value(y_conv, 1e-10, 1.0)
    #cross_entropy = -tf.reduce_mean(y_ * tf.log(y_conv))
    #cross_entropy = tf.reduce_mean(tf.square(y_ - y_conv))
    cross_entropy = tf.nn.sparse_softmax_cross_entropy_with_logits(logits=y,labels=tf.argmax(y_,1))
    cross_entropy_mean = tf.reduce_mean(cross_entropy)
    variable_averages = tf.train.ExponentialMovingAverage(MOVING_AVERAGE_DECAY)
    variable_averages_op = variable_averages.apply(tf.trainable_variables())
    correct_prediction = tf.equal(tf.argmax(y_, 1), tf.argmax(y, 1))
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float"))
    loss = cross_entropy_mean + tf.add_n(tf.get_collection('losses'))
    loss_2 = cross_entropy_mean + tf.add_n(tf.get_collection('losses'))
    train_step = tf.train.GradientDescentOptimizer(1e-4).minimize(loss)
    train_op = tf.group(train_step, variable_averages_op)
    saver = tf.train.Saver()
    with tf.Session() as sess:
        tf.global_variables_initializer().run()
        for i in range(TRAINING_STEPS):
            batch = change_data.next_batches(traindata2,trainlabel2,BATCH_SIZE,True,i)
            _, loss_value, acc = sess.run([train_op, loss_2, accuracy], feed_dict={x: batch[0], y_: batch[1]})
            if i%50 == 0:
                print("step %d, loss is %g, training accuracy is %g" % (i,loss_value,acc))
                saver.save(sess,os.path.join(MODEL_SAVE_PATH,MODEL_NAME),global_step = i)
            train_step.run(feed_dict = {x: batch[0], y_: batch[1]} )

def main(argv=None):
    datafile = 'D://Deeplearning//train_data//data'
    train(datafile)
if __name__ == '__main__':
   tf.app.run()