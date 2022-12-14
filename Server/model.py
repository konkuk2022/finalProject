import torch
import torch.nn as nn
from transformers import ElectraConfig, ElectraModel



class ELECTRALSTMClassification(nn.Module):
    def __init__(self, config):
        super().__init__()
        self.device = config.device
        self.config = ElectraConfig.from_pretrained("beomi/KcELECTRA-base",
                                                    problem_type="multi_label_classification",
                                                    num_labels = config.num_labels) 
        
        self.embedding_size = config.embedding_size
        self.batch_size = config.batch_size

        self.electra = ElectraModel.from_pretrained("beomi/KcELECTRA-base", config=self.config).to(self.device)
        self.lstm = nn.LSTM(self.embedding_size, self.embedding_size, batch_first=True, bidirectional=True).to(self.device)
        self.fc1 = nn.Linear(config.embedding_size * 5, config.num_labels)
        self.fc2 = nn.Linear(config.embedding_size * 2, config.num_labels)
        self.gelu = nn.GELU()


    def forward(self, input_ids=None, attention_mask=None, sep_idx=None):
        
        electra_output = self.electra(input_ids, attention_mask)[0]

        cls = electra_output[:, 0, :] # <CLS> embeddings
        # sep 토큰 가져오기
        sep_idx_x = sep_idx[0]
        sep_idx_y = sep_idx[1]

        idx = 0
        cnt = 0
        longest = torch.where(sep_idx_x==torch.mode(sep_idx_x).values)[0].size()[0]
        # 초기화
        sep_embeddings = torch.zeros(cls.size(0), longest, self.embedding_size).to(self.device)

        # embedding 값 집어넣어주기
        for x, y in zip(sep_idx_x, sep_idx_y):
            if idx == x:
                sep_embeddings[x, cnt, :] += electra_output[x, y, :]
                cnt += 1
            else:
                idx += 1
                cnt = 0
                sep_embeddings[x, cnt, :] += electra_output[x, y, :]


        # lstm 실행
        lstm_output, (h, c) = self.lstm(sep_embeddings) # (batch_size, seq_length, embedding_size)

        # lstm 처음과 끝 가져오기
        sep_first = lstm_output[:, 0, :]
        sep_last = lstm_output[:, -1, :]

        # lstm 결과와 cls 토큰 합치기
        concats = torch.cat((cls, sep_first, sep_last), dim=1)
        # fc 레이어에 넣고 44개 output
        x = self.gelu(concats)
        output = self.fc1(x)

        first_output = self.fc2(sep_first)
        last_output = self.fc2(sep_last)

        
        return output, first_output, last_output
