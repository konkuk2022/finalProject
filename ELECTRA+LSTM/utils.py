import numpy as np
import random
import torch
import torch.nn as nn
from sklearn import metrics

# 랜덤 시드 고정
def set_seed(SEED):
    np.random.seed(SEED)
    torch.manual_seed(SEED)
    torch.backends.cudnn.deterministic = True
    random.seed(SEED)
    torch.cuda.manual_seed(SEED)  # type: ignore
    torch.cuda.manual_seed_all(SEED) # if use multi-GPU
    torch.backends.cudnn.deterministic = True  # type: ignore
    torch.backends.cudnn.benchmark = True  # type: ignore

class EarlyStopping:

    def __init__(self, patience=10, min_delta=0):

        self.patience = patience
        self.min_delta = min_delta
        self.counter = 0
        self.best_loss = None
        self.early_stop = False
        self.verbose = True
    
    def __call__(self, val_loss):

        if self.best_loss == None:
            self.best_loss = val_loss

        elif self.best_loss - val_loss > self.min_delta:
            self.best_loss = val_loss
            self.counter = 0 # reset counter

        elif self.best_loss - val_loss < self.min_delta:
            self.counter += 1
            
            if self.verbose:
                print(f"Early Stopping Counter: {self.counter}/{self.patience}")
            
            if self.counter >= self.patience:
                print("Early Stopping")
                self.early_stop = True

def log_metrics(preds, labels):
    preds = torch.stack(preds)
    preds = preds.cpu().detach().numpy()
    labels = torch.stack(labels)
    labels = labels.cpu().detach().numpy()
    
    fpr_micro, tpr_micro, _ = metrics.roc_curve(labels.ravel(), preds.ravel())
    auc_micro = metrics.auc(fpr_micro, tpr_micro)
    # f1_macro = metrics.f1_score(labels, preds)
    
    # return {"auc_micro": auc_micro, "f1_macro": f1_macro}
    return {"auc_micro": auc_micro}

def loss_function(outputs, labels):
    if labels is None:
        return None
    return nn.BCEWithLogitsLoss()(outputs, labels.float())

def one_hot_encoder(dataset, n_labels=44):
    one_hot = [0] * n_labels
    label_idx = dataset
    for idx in label_idx:
        one_hot[int(idx)] = 1
    return torch.LongTensor(one_hot)