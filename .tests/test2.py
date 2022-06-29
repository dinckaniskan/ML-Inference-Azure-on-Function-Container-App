import requests

url = 'http://localhost:8081/api/test'

r = requests.get(url)
r = r.text
print(r)


# import glob

# x = glob.glob('../assets/*.*', recursive=True)
# print(x)
# print(len(x))
