import numpy as np
import pandas as pd
import torch
from torch.utils.data import Dataset
import os
from transformers import AutoTokenizer
from utils import one_hot_encoder

class ELECTRALSTMDataset(Dataset):
    
    def __init__(self, data_path,config):

        data = pd.read_pickle(os.path.dirname(__file__) + data_path)
        self.tokenizer = AutoTokenizer.from_pretrained("beomi/KcELECTRA-base", do_lower_case=False)
        self.text = data.new_text.values
        data.label = data.label.map(lambda x: x.split(","))
        self.labels = data.label.values.tolist()
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

        self.labels[idx] = one_hot_encoder(self.labels[idx])

        return {"input_ids": torch.LongTensor(embeddings["input_ids"]), 
                "attention_mask": torch.LongTensor(embeddings["attention_mask"]), 
                "labels": self.labels[idx]}

