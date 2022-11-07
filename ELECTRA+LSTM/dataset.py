import numpy as np
import pandas as pd
import torch
from torch.utils.data import Dataset
import os
from transformers import AutoTokenizer
from utils import one_hot_encoder

class ELECTRALSTMDataset(Dataset):
    
    def __init__(self, data_path,config):

        data = pd.read_pickle(data_path)
        self.tokenizer = AutoTokenizer.from_pretrained("beomi/KcELECTRA-base", do_lower_case=False)
        self.text = data.new_text.values

        data.label = data.label.map(lambda x: x.split(","))
        first_labels = data.split_label.map(lambda x: x[0])
        last_labels = data.split_label.map(lambda x: x[-1])
        labels = data.label.values.tolist()

        self.labels = [one_hot_encoder(label) for label in labels]
        self.first_labels = [one_hot_encoder(label) for label in first_labels]
        self.last_labels = [one_hot_encoder(label) for label in last_labels]

        self.max_length = config.max_length

    def __len__(self):

        return len(self.labels)
    
    def __getitem__(self, idx):
        embeddings = self.tokenizer(self.text[idx],
                                            truncation=True,
                                            max_length=self.max_length,
                                            padding="max_length",
                                            return_token_type_ids=False,
                                            return_attention_mask=True,
                                            add_special_tokens=True)


        return {"input_ids": torch.LongTensor(embeddings["input_ids"]), 
                "attention_mask": torch.LongTensor(embeddings["attention_mask"]), 
                "labels": self.labels[idx],
                "first_labels": self.first_labels[idx],
                "last_labels": self.last_labels[idx]} 
