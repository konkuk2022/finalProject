# koBERT

BERT 모델을 기반으로 만든 모델로, BERT 모델에서 한국어 데이터를 추가로 학습시켰다. (한국어 위키 5백만개 문장 및 54백만개 단어)

# 학습 데이터

[AIHUB - 한국어 감정 정보가 포함된 단발성 대화 데이터셋](https://aihub.or.kr/keti_data_board/language_intelligence)

# 파라미터

- max_len = 64
- batch_size = 64
- warmup_ratio = 0.1
- num_epochs = 5
- max_grad_norm = 1
- log_interval = 200
- learning_rate =  5e-5

# 결과

학습데이터 정확도 : 0.78
테스트데이터 정확도 : 0.55
