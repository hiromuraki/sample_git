from fastapi import FastAPI

app = FastAPI()

def add(a: int, b: int) -> int:
    return a + b

@app.get("/")
def read_root():
    return {"Hello": "Gitea Actions + UV"}

@app.get("/calc/{a}/{b}")
def calc(a: int, b: int):
    return {"result": add(a, b)}