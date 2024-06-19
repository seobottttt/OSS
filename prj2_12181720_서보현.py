import numpy as np
from sklearn.cluster import KMeans

with open('ratings.dat', 'r') as f:
    lines = f.readlines()

ratingsMatrix = np.zeros((6040, 3952))
for line in lines:
    UserID, MovieID, Rating, _ = line.strip().split('::')
    ratingsMatrix[int(UserID)-1, int(MovieID)-1] = Rating


# 3. K-Means 클러스터링을 통해 3개의 그룹으로 나누기
kmeans = KMeans(n_clusters=3, random_state=0)
user_clusters = kmeans.fit_predict(ratingsMatrix)

# 4. 각 그룹에 대한 AU 집계 함수 결과 확인
def AU(m):
    return m.sum(axis=0)

def Avg(m):
  return np.mean(m, axis=0)

def SC(m):
  return np.count_nonzero(m, axis=0)


def AV(m , threshold=4):
  return np.count_nonzero(m >= threshold, axis=0)


def BC(m):
  n = m.shape[1]
  scores = np.zeros(n)
  for row in m:
    ranked_items = np.argsort(row)[::-1]
  for i, item in enumerate(ranked_items):
    scores[item] += n - i - 1
  return scores


def CR(m):
  n = m.shape[1]
  scores = np.zeros(n)
  for i in range(n):
    for j in range(n):
      if i != j:
        if np.sum(ratings_matrix[:, i] > ratings_matrix[:, j]) > np.sum(ratings_matrix[:, i] < ratings_matrix[:, j]):
          scores[i] += 1
          scores[j] -= 1
        elif np.sum(ratings_matrix[:, i] > ratings_matrix[:, j]) == np.sum(ratings_matrix[:, i] < ratings_matrix[:, j]):
          scores[i] += 0
          scores[j] += 0
  return scores

