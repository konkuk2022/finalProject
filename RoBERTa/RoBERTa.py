import pandas as pd

from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score

import transformers
from transformers import AutoTokenizer, AdamW, RobertaForSequenceClassification

import torch
from torch.nn import functional as F
from torch.utils.data import DataLoader, Dataset

from tqdm.notebook import tqdm

import numpy as np

df = pd.read_excel('한국어_단발성_대화_데이터셋.xlsx')
df_shuffled = df.sample(frac=1).reset_index(drop=True)

df_shuffled.loc[(df_shuffled['Emotion'] == "공포"), 'Emotion'] = 0  #공포 => 0
df_shuffled.loc[(df_shuffled['Emotion'] == "놀람"), 'Emotion'] = 1  #놀람 => 1
df_shuffled.loc[(df_shuffled['Emotion'] == "분노"), 'Emotion'] = 2  #분노 => 2
df_shuffled.loc[(df_shuffled['Emotion'] == "슬픔"), 'Emotion'] = 3  #슬픔 => 3
df_shuffled.loc[(df_shuffled['Emotion'] == "중립"), 'Emotion'] = 4  #중립 => 4
df_shuffled.loc[(df_shuffled['Emotion'] == "행복"), 'Emotion'] = 5  #행복 => 5
df_shuffled.loc[(df_shuffled['Emotion'] == "혐오"), 'Emotion'] = 6  #혐오 => 6

train, val  = train_test_split(df_shuffled, test_size=0.25, random_state=42)

train = train[['Sentence','Emotion']]
val = val[['Sentence','Emotion']]

class NTDataset(Dataset):
  
    def __init__(self, csv_file):
        self.dataset = csv_file
        self.tokenizer = AutoTokenizer.from_pretrained("klue/roberta-large")

        print(self.dataset.describe())

    def __len__(self):
        return len(self.dataset)

    def __getitem__(self, idx):
        row = self.dataset.iloc[idx, 0:2].values
        text = row[0]
        y = row[1]
        inputs = self.tokenizer(
            text, 
            return_tensors='pt',
            truncation=True,
            max_length=15,
            pad_to_max_length=True,
            add_special_tokens=True
        )

        input_ids = inputs['input_ids'][0]
        attention_mask = inputs['attention_mask'][0]

        return input_ids, attention_mask, y
    
class NTDataset_test(Dataset):
  
    def __init__(self, csv_file):
        self.dataset = csv_file
        self.tokenizer = AutoTokenizer.from_pretrained("klue/roberta-large")

        print(self.dataset.describe())

    def __len__(self):
        return len(self.dataset)

    def __getitem__(self, idx):
        row = self.dataset.iloc[idx, 0:1].values
        text = row[0]
        inputs = self.tokenizer(
            text, 
            return_tensors='pt',
            truncation=True,
            max_length=15,
            pad_to_max_length=True,
            add_special_tokens=True
        )

        input_ids = inputs['input_ids'][0]
        attention_mask = inputs['attention_mask'][0]

        return input_ids, attention_mask
    
train_dataset = NTDataset(train)
val_dataset = NTDataset(val)

device = torch.device("cuda")
model = RobertaForSequenceClassification.from_pretrained("klue/roberta-large", num_labels=7).to(device)

epochs = 3
batch_size = 128

optimizer = AdamW(model.parameters(), lr=1e-5)
train_loader = DataLoader(train_dataset, batch_size=batch_size, shuffle=True)
val_loader = DataLoader(val_dataset, batch_size=batch_size, shuffle=True)

# train
losses = []
accuracies = []
total_loss = 0.0
correct = 0
total = 0

for i in range(epochs):

    model.train()

    for input_ids_batch, attention_masks_batch, y_batch in tqdm(train_loader):
        optimizer.zero_grad()
        y_batch = y_batch.to(device)
        y_pred = model(input_ids_batch.to(device), attention_mask=attention_masks_batch.to(device))[0]
        loss = F.cross_entropy(y_pred, y_batch)
        loss.backward()
        optimizer.step()

        total_loss += loss.item()

        _, predicted = torch.max(y_pred, 1)
        correct += (predicted == y_batch).sum()
        total += len(y_batch)

    losses.append(total_loss)
    accuracies.append(correct.float() / total)
    print("Train Loss:", total_loss / total, "Accuracy:", correct.float() / total)
    
# validation
model.eval()

pred = []
correct = 0
total = 0

for input_ids_batch, attention_masks_batch, y_batch in tqdm(val_loader):
  y_batch = y_batch.to(device)
  y_pred = model(input_ids_batch.to(device), attention_mask=attention_masks_batch.to(device))[0]
  _, predicted = torch.max(y_pred, 1)
  pred.append(predicted)
  correct += (predicted == y_batch).sum()
  total += len(y_batch)

print("val accuracy:", correct.float() / total)

def predict(predict_sentence):

    data = [predict_sentence]
    dataset_another = pd.DataFrame(data)

    another_test = NTDataset_test(dataset_another)
    test_dataloader = DataLoader(another_test, batch_size=batch_size, num_workers=5)
    
    model.eval()

    for input_ids_batch, attention_masks_batch in tqdm(test_dataloader):
        y_pred = model(input_ids_batch.to(device), attention_mask=attention_masks_batch.to(device))[0]
        _, predicted = torch.max(y_pred, 1)
        pred.extend(predicted.tolist())


        test_eval=[]
        for i in y_pred:
            logits=i
            logits = logits.detach().cpu().numpy()

            if np.argmax(logits) == 0:
                test_eval.append("공포가")
            elif np.argmax(logits) == 1:
                test_eval.append("놀람이")
            elif np.argmax(logits) == 2:
                test_eval.append("분노가")
            elif np.argmax(logits) == 3:
                test_eval.append("슬픔이")
            elif np.argmax(logits) == 4:
                test_eval.append("중립이")
            elif np.argmax(logits) == 5:
                test_eval.append("행복이")
            elif np.argmax(logits) == 6:
                test_eval.append("혐오가")

        print(">> 입력하신 내용에서 " + test_eval[0] + " 느껴집니다.")
        
end = 1
while end == 1 :
    sentence = input("하고싶은 말을 입력해주세요 : ")
    if sentence == "0" :
        break
    predict(sentence)
    print("\n")
