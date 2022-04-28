import pandas as pd
from torch.utils.data import Dataset
from transformers import ElectraTokenizer

def load_data(data_path):
    # 랜덤 시드 고정
    SEED = 42
    # 데이터 로드 후 train, test로 split
    df = pd.read_excel(data_path, usecols=[0, 1])
    _, label2int = get_label_info(df)
    df.Emotion = df.Emotion.map(label2int)
    df = df.sample(frac=1, random_state=SEED).copy()
    n = int(len(df) * 0.8)
    train, test = df[:n], df[n:]

    return train, test

def get_label_info(df):
    label2int = {l:idx for idx, l in enumerate(df.Emotion.unique())}
    label_list = df.Emotion.unique().tolist()

    return label_list, label2int

class EmotionDataset(Dataset):

    def __init__(self, data):
        self.dataset= data
        self.dataset.drop_duplicates(subset=["Sentence"], inplace=True)
        self.tokenizer = ElectraTokenizer.from_pretrained("google/electra-base-discriminator")

    def __len__(self):
        return len(self.dataset)

    def __getitem__(self, idx):
        row = self.dataset.iloc[idx].values
        sentence = row[0]
        label = row[1]

        inputs = self.tokenizer(
            sentence,
            return_tensors="pt",
            truncation=True,
            padding="max_length",
            add_special_tokens=True
        )
        input_ids = inputs["input_ids"][0]
        attention_mask = inputs["attention_mask"][0]

        return input_ids, attention_mask, label