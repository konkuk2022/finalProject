


# koBART 
### koBART <br/><br/>

- - -
## 학습 데이터 
#### [한국어 단발성 대화](https://aihub.or.kr/opendata/keti-data/recognition-laguage/KETI-02-009)<br/><br/>

- - -
### 파라미터  
#### batch_size = 32
#### MAX_LEN = 32
#### num_epochs = 7
#### Learning rage(Adam) = 1e-5
<br/><br/>

### 학습 결과
### 학습 데이터 정확도 : 0.5636 / 테스트 데이터 정확도 0.5626<br/><br/>
- - -

### 파라미터  
#### batch_size = 128
#### MAX_LEN = 32
#### num_epochs = 5
#### Learning rage(Adam) = 1e-8
<br/><br/>

### 학습 결과
### 학습 데이터 정확도 : 0.5202 / 테스트 데이터 정확도 0.5616<br/><br/>
- - -

### 파라미터  
#### batch_size = 128
#### MAX_LEN = 32
#### num_epochs = 7
#### Learning rage(Adam) = 1e-8
#### attention_probs_dropout_prob = 0.5
#### hidden_dropout_prob = 0.5
<br/><br/>

### 학습 결과
### 학습 데이터 정확도 : 0.5568 / 테스트 데이터 정확도 0.5649<br/><br/>
- - -

###### 학습 데이터 감성 대화 말뭉치 추가로 학습 시켰습니다
###### '공포' 감정 제외시켰습니다

###### 파라미터  
#### batch_size = 128
#### MAX_LEN = 32
#### num_epochs = 15
#### Learning rage(Adam) = 1e-5
<br/><br/>

### 학습 결과
### 학습 데이터 정확도 : 0.7927 / 테스트 데이터 정확도 0.6601<br/><br/>

