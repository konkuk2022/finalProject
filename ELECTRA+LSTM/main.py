import numpy as np
import pandas as pd
import torch
import torch.nn as nn
from torch.nn import functional as F
from torch.utils.data import DataLoader
from torch.optim import AdamW
from transformers import get_linear_schedule_with_warmup


import argparse
import gc

from utils import set_seed, EarlyStopping, compute_metrics
from model import ELECTRALSTMClassification
from dataset import ELECTRALSTMDataset
from trainer import train, test


if __name__ == "__main__":

    device = "cuda" if torch.cuda.is_available() else "cpu"

    args = argparse.ArgumentParser()

    args.add_argument("--embedding_size", type=int, default=768)
    args.add_argument("--num_labels", type=int, default=44)
    args.add_argument("--dropout", type=float, default=0.1)
    args.add_argument("--batch_size", type=int, default=32)
    args.add_argument("--max_length", type=int, default=512)
    args.add_argument("--n_epochs", type=int, default=20)
    args.add_argument("--lr", type=float, default=1e-5)
    args.add_argument("--device", type=str, default=device)
    args.add_argument("--threshold", type=float, default=0.3)
    args.add_argument("--early_stopping_patience", type=int, default=10)
    args.add_argument("--resume_from")

    config = args.parse_args()
    

    set_seed(42)
    print("---prepare dataset---")
    train_dataset = ELECTRALSTMDataset("./train_data.pkl", config)
    valid_dataset = ELECTRALSTMDataset("./val_data.pkl", config)
    test_dataset = ELECTRALSTMDataset("./test_data.pkl", config)

    train_dataloader = DataLoader(train_dataset, batch_size=config.batch_size, shuffle=True)
    valid_dataloader = DataLoader(valid_dataset, batch_size=config.batch_size, shuffle=True)
    test_dataloader = DataLoader(test_dataset, batch_size=config.batch_size, shuffle=False)
    print("---dataset is ready!---")
    if config.resume_from:
        model_data = torch.load(config.resume_from)

        model = ELECTRALSTMClassification(config).to(device)
        model.load_state_dict(model_data["model_state_dict"])

        optimizer = AdamW(model.parameters(), lr=config.lr)
        optimizer.load_state_dict(model_data["optimizer_state_dict"])

        scheduler = get_linear_schedule_with_warmup(optimizer, num_warmup_steps=2500, num_training_steps = 12500)
        scheduler.load_state_dict(model_data["scheduler_state_dict"])

        start_epoch = config.n_epochs - model_data["epoch"]

    else:
        model = ELECTRALSTMClassification(config).to(device)

        optimizer = AdamW(model.parameters(), lr=config.lr)
        scheduler = get_linear_schedule_with_warmup(optimizer, num_warmup_steps=2500, num_training_steps = 12500)
        start_epoch = 0

    early_stopping = EarlyStopping(patience=config.early_stopping_patience, min_delta=0)
    best_val_loss = 1000

    print("---training start---")
    for epoch in range(config.n_epochs):
        gc.collect()
        torch.cuda.empty_cache()

        train_loss = train(model, train_dataloader, scheduler, optimizer, config)
        valid_loss, labels, preds, labels1, preds1, labels2, preds2 = test(model, valid_dataloader, config)

        # 수정
        auc_score, classification_report = compute_metrics(preds, labels, config)
        auc_score1, classification_report1 = compute_metrics(preds1, labels1, config)
        auc_score2, classification_report2 = compute_metrics(preds2, labels2, config)

        
        avg_train_loss, avg_val_loss = train_loss / len(train_dataloader), valid_loss / len(test_dataloader)

        print(f"[{epoch+1}/{config.n_epochs}]")
        print(f"AUC score: {auc_score}")
        print(f"Average Train Loss: {avg_train_loss}")
        print(f"Average Valid Loss: {avg_val_loss}")
        print("-" * 10, "CLS", "-" * 10)
        print(classification_report)
        print("-" * 10, "LSTM first", "-" * 10)
        print(classification_report1)
        print("-" * 10, "LSTM last", "-" * 10)
        print(classification_report2)
        
        print("\n")

        early_stopping(avg_val_loss)
        if early_stopping.early_stop:
            break

        if avg_val_loss < best_val_loss:
            best_val_loss = avg_val_loss
            torch.save({"epoch": epoch, "scheduler_state_dict": scheduler.state_dict(), "optimizer_state_dict": optimizer.state_dict(), "model_state_dict": model.state_dict()}, f"model.{epoch}.pth")
            print(f"Model saved as current valid loss: {best_val_loss}")

    test_loss, labels, preds, labels1, preds1, labels2, preds2 = test(model, test_dataloader, config)
    avg_test_loss = test_loss / len(test_dataloader)
    auc_score, classification_report = compute_metrics(preds, labels, config)
    auc_score1, classification_report1 = compute_metrics(preds1, labels1, config)
    auc_score2, classification_report2 = compute_metrics(preds2, labels2, config)

    print("<test result>")
    print(f"AUC score: {auc_score}")
    print(f"Average Train Loss: {avg_train_loss}")
    print(f"Average Valid Loss: {avg_val_loss}")
    print("-" * 10, "CLS", "-" * 10)
    print(classification_report)
    print("-" * 10, "LSTM first", "-" * 10)
    print(classification_report1)
    print("-" * 10, "LSTM last", "-" * 10)
    print(classification_report2)

    torch.save(model.state_dict(), "final_model.pth")
