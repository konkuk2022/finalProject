import numpy as np
import torch
import torch.nn.functional as F
from torch.utils.data import DataLoader
from transformers import ElectraForSequenceClassification, ElectraConfig, AdamW, get_linear_schedule_with_warmup
from tqdm import tqdm
from load_data import *


if __name__ == "__main__":

    data_path = "./data/dataset.xlsx"
    
    train_data, test_data = load_data(data_path)

    train_dataset = EmotionDataset(train_data)
    test_dataset = EmotionDataset(test_data)

    label_list, _ = get_label_info(train_data)

    config = ElectraConfig.from_pretrained(
        "monologg/koelectra-small-v3-discriminator",
        num_labels = len(label_list)
    )

    device = 'cuda' if torch.cuda.is_available() else 'cpu'


    model = ElectraForSequenceClassification.from_pretrained(
        "monologg/koelectra-small-v3-discriminator",
        config=config).to(device)
    
    n_epochs = 5
    batch_size=64
    lr=1e-5

    train_dataloader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
    optimizer = AdamW(model.parameters(), lr=lr)
    scheduler = get_linear_schedule_with_warmup(optimizer, num_warmup_steps=0, num_training_steps = len(train_dataloader)*n_epochs)

    for i in range(n_epochs):
        total_loss = 0
        train_acc = 0.0
        test_acc = 0.0
        best_acc = 0.0
        total = 0
        model.train()

        for input_ids_batch, attention_masks_batch, y_batch in tqdm(train_dataloader):

            optimizer.zero_grad()

            y_batch = y_batch.to(device)
    
            y_pred = model(input_ids_batch.to(device), attention_mask=attention_masks_batch.to(device))[0]
        
            loss = F.cross_entropy(y_pred, y_batch)
            loss.backward()
            optimizer.step()
            scheduler.step()
            total_loss += loss.item()
            y_batch = y_batch.cpu()
            prediction = torch.tensor([torch.argmax(p) for p in y_pred])
            train_acc += torch.sum(prediction == y_batch)
            total += y_batch.size(0)


        print(f"epoch {i+1} train acc {train_acc / (total)} loss: {total_loss / total}")

    model.eval()
    test_dataloader = DataLoader(test_dataset, batch_size=batch_size, shuffle=False)
    test_correct = 0
    test_total = 0

    for input_ids_batch, attention_masks_batch, y_batch in tqdm(test_dataloader):
        y_batch = y_batch.to(device)
        y_pred = model(input_ids_batch.to(device), attention_mask=attention_masks_batch.to(device))[0]
        y_batch = y_batch.cpu()
        prediction = torch.tensor([torch.argmax(p) for p in y_pred])
        train_acc += torch.sum(prediction == y_batch)
        total += y_batch.size(0)

    print("Test Accuracy:", train_acc/total )
