
from tqdm import tqdm
import torch

from utils import loss_function

# train
def train(model, train_dataloader, scheduler, optimizer, config):

    total_loss = 0
        
    model.train()
    
    for train_input in tqdm(train_dataloader):
        optimizer.zero_grad()
        y_batch = train_input["labels"].to(config.device)
        mask = train_input["attention_mask"].to(config.device)
        input_id = train_input["input_ids"].to(config.device)
        sep_idx = torch.where(input_id == 3) # 문장의 index, 문장 내 sep 토큰의 index 두 리스트로 구성됨
        y_pred = model(input_id, mask, sep_idx)
        loss = loss_function(y_pred, y_batch) 
        loss.backward()
        optimizer.step()
        scheduler.step()

        total_loss += loss.item()


    return total_loss


def test(model, test_dataloader, config):
    
    test_loss = 0
    targets = []
    outputs = []

    model.eval()
    with torch.no_grad():
        for test_input in tqdm(test_dataloader):
            y_batch = test_input["labels"].to(config.device)
            mask = test_input["attention_mask"].to(config.device)
            input_id = test_input["input_ids"].squeeze(1).to(config.device)
            sep_idx = torch.where(input_id == 3)
            y_pred = model(input_id, mask, sep_idx)
            loss = loss_function(y_pred, y_batch)
            test_loss += loss.item()

            targets.extend(y_batch)
            outputs.extend(y_pred)

    return test_loss, targets, outputs
