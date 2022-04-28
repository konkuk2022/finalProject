# ELECTRA

Discriminator를 파인튜닝

# 학습 데이터
<a href="https://aihub.or.kr/opendata/keti-data/recognition-laguage/KETI-02-009">한국어 단발성 대화</a>

# 파라미터
`n_epochs` : 5 <br/>
`batch_size` : 64 <br/>
`learning_rate` : 1e-5 <br/>
`seed` : 42 <br/>

# 학습 결과
`koelectra-small-v3` train acc: 48.19% / test acc: 47.76% <br/>
`electra-small` train acc: 25.26% / test acc: 25.37% <br/>
<br/>
base는 colab GPU 메모리 부족으로 못 돌려 봤습니다.
