from fastapi import FastAPI
import socket

app = FastAPI()

@app.get("/")
def read_root():
    # 返回主机名，方便在 Docker/K8s 里验证负载均衡
    return {
        "message": "Hello from uv!", 
        "hostname": socket.gethostname()
    }
