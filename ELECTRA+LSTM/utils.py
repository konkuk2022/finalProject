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
    fpr_micro, tpr_micro, _ = metrics.roc_curve(labels.ravel(), preds.ravel())
    auc_micro = metrics.auc(fpr_micro, tpr_micro)
    
    classification_report = metrics.classification_report(labels, preds, zero_division=0)
    
    return {"auc_micro": auc_micro, "classification_report": classification_report}

def loss_function(outputs, labels):
    if labels is None:
        return None
    return nn.BCEWithLogitsLoss()(outputs, labels.float())

def loss_function2(outputs, labels):
    # outputs, label 구성이 outputs[0] = cls, outputs[1] = 1st_sep, outputs[2] = end_sep로 되어있다고 가정하고 코드 작성
    bce_loss = nn.BCEWithLogitsLoss()
    
    loss0 = bce_loss(outputs[0],labels[0].float())
    loss1 = bce_loss(outputs[1],labels[1].float())
    loss2 = bce_loss(outputs[2],labels[2].float())
    
    return loss0+loss1+loss2

def one_hot_encoder(dataset, n_labels=44):
    one_hot = [0] * n_labels
    label_idx = dataset
    for idx in label_idx:
        one_hot[int(idx)] = 1
    return torch.LongTensor(one_hot)

def compute_metrics(preds, labels, config):
    preds = torch.stack(preds)
    preds = torch.sigmoid(preds)
    preds = preds.cpu().detach().numpy()
    preds = np.where(preds > config.threshold, 1, 0)
        
    labels = torch.stack(labels)
    labels = labels.cpu().detach().numpy()
        
    auc_score = log_metrics(preds, labels)["auc_micro"]
    classification_report = log_metrics(preds, labels)["classification_report"]

    return auc_score, classification_report