import kss
import numpy as np
import torch

# cosine similarity
def cos_similiarity(v1, v2):
    dot_product = np.dot(v1, v2)
    l2_norm = (np.sqrt(sum(np.square(v1)))*np.sqrt(sum(np.square(v2))))
    similarity = dot_product/l2_norm

    return similarity



# 여러 문장을 나눠서 sep 토큰을 대입
# 여러 문장을 나눠서 sep 토큰을 대입
def kss_sentence(sent,max_length=512):
    x = ''
    split_sent = kss.split_sentences(sent)
    for i,s in enumerate(split_sent):
        if i == 0:
            x = s
        else:
            x += ' [SEP] ' + s
    return x


# 감정 출력을 위한 one hot encoding
def one_hot_encoder(dataset, n_labels=44):
    one_hot = [0] * n_labels
    label_idx = dataset
    for idx in label_idx:
        one_hot[int(idx)] = 1
    return torch.LongTensor(one_hot)
